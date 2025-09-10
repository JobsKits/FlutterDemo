import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_offline_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_online_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/Third_wallet_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/Wallet_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_tab_bean.dart';
import 'package:flutter_tiyu_app/app/modules/webview/controllers/app_web_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api/system_api.dart';
import '../data/manual_recharge_tips.dart';
import '../data/recharge_type_bean.dart';
import '../data/tutorials_config_bean.dart';
import '../widget/wallet_input_field_widget.dart';

class RechargeController extends GetxController
    with GetTickerProviderStateMixin {
  final RxBool isShowMore = false.obs;
  RxBool isExpand = false.obs; //是否已展开列表，默认为false

  final RxDouble currencyRate = 0.00.obs; // 币种汇率

  final RxBool isRefreshBalance = false.obs; // 是否刷新余额
  late AnimationController animationController; // 刷新按钮动画
  final RxBool isShowDiscount = false.obs; // 是否展示优惠

  late RxList<RechargeTypeBean> showRechargeTypeList =
      <RechargeTypeBean>[].obs; //用于显示的充值类型列表
  final RxInt currentRechargePayOrgId = 0.obs; // 当前选中的充值类型ID
  final RxInt currentRechargeTypeIndex = 0.obs; //当前选中的充值类型
  late RxInt currentRechargeMarkType = 0.obs; // 默认没有 1线下 2线上 3快速充值

  final RxInt currentSelectProtocalIndex = 0.obs; //当前选中的交易类型
  final Rx<num> currentSelectProtocalTenantPayId = 0.obs; //当前选中的交易类型ID
  RxList<TenantPayInfo> offLineProtocolList = <TenantPayInfo>[].obs; // 线下方式的协议
  RxList<TenantPayMerchant> merchatProtocolList =
      <TenantPayMerchant>[].obs; // 线上以及快速充值的协议
  final RxBool isShowTutorial = false.obs; // 是否显示充值教程
  final RxBool isCanEnter = false.obs; // 是否可以输入

  /// ---------------------------------------
  RxBool isExpandMoneyList = false.obs; //是否已展开列表，默认为false
  final RxList<String> quickMoneyList = <String>[].obs; // 快捷充值金额列表
  final RxInt currentSelectMoneyIndex = 99999.obs; //当前选中的金额
  late TabController tabController;
  RxInt currentTabIndex = 0.obs; //当前选中的tab
  late RechargeTypeBean currentRechargeType;
  late ScrollController rechargeScrollController;
  Map<String, String> thirdParameters = {};
  Rx<CurrencyType> currencyType = CurrencyType.crypto.obs;
  late TabsController tabsController = Get.find();
  late Worker tabsWorker;

  ///  ---------------------------------------
  @override
  void onInit() async {
    super.onInit();
    rechargeScrollController = ScrollController();
    tabController = TabController(length: 0, vsync: this);
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // 动画持续时间
      vsync: this,
    )..repeat(); // 循环动画

    initData();

    // 使用 ever 方法监听 登录状态，状态发生改变， 请求余额数据
    ever(LoginManager.instance.isLogin, (value) {
      initData();
    });

    tabsWorker = ever(tabsController.currentIndex, (value) async {
      var isShowVideo = tabsController.showVideo;
      var rechargeIndex = 1;
      if (isShowVideo) {
        rechargeIndex = 2;
      }
      if (value == rechargeIndex) {
        // 切换tab刷新数据
        initData();
      }
    });
  }

  @override
  void onClose() {
    tabsWorker.dispose();
    tabController.dispose();
    animationController.dispose(); // 先释放 AnimationController
    super.onClose(); // 然后调用父类的 dispose 方法
  }

  /// 恢复默认值
  _reset() {
    showRechargeTypeList.clear(); // 清空显示的充值列表
    currentRechargePayOrgId.value = 0; // 重置当前选中的充值类型ID
    currentRechargeTypeIndex.value = 0; // 重置当前选中的充值类型index
    currentRechargeMarkType.value = 0;
    offLineProtocolList.value = [];
    merchatProtocolList.value = [];
    isShowDiscount.value = false; // 重置是否展示优惠
  }

  /// 初始化请求
  Future<void> initData() async {
    // errorTryCount = 0;
    // 无租户信息时
    if (TenantManager.instance.tenantBean == null) {
      return;
    }

    // 用户已登录
    if (LoginManager.instance.isLogin.value) {
      currencyRate.value =
          double.parse(TenantManager.instance.tenantBean!.rate ?? '1'); // 币种汇率
      reqMoney(); // 获取用户余额数据
      await reqDiscountInfo(); // 获取禁用名单
      reqRechargeType(); // 获取充值方式
      manualBean.value = await SystemApi.getManualRechargeDesc(); //获取人工充值描述信息
    } else {
      _reset();
    }
  }

  Rxn<ManualRechargeTips> manualBean = Rxn();
  DiscountBean? discountBean;

  /// 获取禁用名单
  Future<void> reqDiscountInfo() async {
    final res = await LoginApi.reqDiscountInfo();

    if (res.type == NetworkService.networkTypeSuccess) {
      discountBean = DiscountBean.fromJson(res.data);
      // 是否展示优惠， 1：不展示 2: 展示
      isShowDiscount.value = discountBean?.isShowDiscount == 2;
    }
  }

  /// 获取账户余额 （能点击刷新按钮，必定已登录，否则有BUG）
  Future<void> reqMoney() async {
    if (isRefreshBalance.value) return;

    isRefreshBalance.value = true;
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await UserApi().findMoney2('');
      await LoginManager.instance.reqMoney();

      isRefreshBalance.value = false;
    });
  }

  RxList<RechargeTypeTabBean> tabList = <RechargeTypeTabBean>[].obs;
  RxList<RechargeTypeBean> manualRechargeList = <RechargeTypeBean>[].obs;
  RxBool isShowErrorView = false.obs;
  int errorTryCount = 0; //错误尝试次数,最多尝试3次
  /// 获取充值方式
  reqRechargeType() async {
    manualRechargeList.clear();
    EasyLoading.show(indicator: const CommonLoadingView());
    try {
      final res = await LoginApi.reqRechargeType();
      if (res.type == NetworkService.networkTypeSuccess) {
        errorTryCount = 0;
        if (res.data is List) {
          isShowErrorView.value = false;
          tabList.clear();
          for (var item in res.data) {
            RechargeTypeTabBean tempItem = RechargeTypeTabBean.fromJson(item);
            if (tempItem.title != null) {
              List<RechargeTypeBean>? typeList = tempItem.data ?? [];
              if (typeList.isNotEmpty) {
                RechargeTypeBean maxItem = typeList.reduce((current, next) {
                  return (double.tryParse(current.maxPercentage ?? "0") ?? 0) >
                          (double.tryParse(next.maxPercentage ?? "0") ?? 0)
                      ? current
                      : next;
                });
                tempItem.maxPercentage = maxItem.maxPercentage;
                //从typeList里面抽离人工充值的
                tempItem.data =
                    typeList.where((item) => item.payOrgId != 205).toList();
                if (manualRechargeList.isEmpty) {
                  manualRechargeList.addAll(
                      typeList.where((item) => item.payOrgId == 205).toList());
                }
              }
              tabList.add(tempItem);
            }
          }
          //组装推荐数据
          createRemandData();
          //如果有pay_org_id = 205的数据，表示有人工充值，从线上充值抽离出来，单独使用
          if (manualRechargeList.isNotEmpty) {
            RechargeTypeBean maxItem =
                manualRechargeList.reduce((current, next) {
              return (double.tryParse(current.maxPercentage ?? "0") ?? 0) >
                      (double.tryParse(next.maxPercentage ?? "0") ?? 0)
                  ? current
                  : next;
            });
            tabList.add(RechargeTypeTabBean(
                title: "人工充值",
                data: manualRechargeList.value,
                maxPercentage: maxItem.maxPercentage,
                isManualRecharge: true));
          }

          if (tabList.isNotEmpty) {
            isShowErrorView.value = false;
            tabController.dispose();
            tabController = TabController(length: tabList.length, vsync: this);

            if (currentTabIndex.value >= tabList.length) {
              currentTabIndex.value = 0;
            }

            tabController.index = currentTabIndex.value; //如果当前选中的index
          } else {
            isShowErrorView.value = true;
          }
        } else {
          isShowErrorView.value = true;
        }
        refreshRechargeTypeList();
      } else {
        //接口报错，重新请求
        if (errorTryCount < 3) {
          print("报错了重新请求");
          reqRechargeType();
          errorTryCount++;
        } else {
          isShowErrorView.value = true;
        }
      }
    } catch (e) {
      print("报错了:${e}");
      isShowErrorView.value = true;
    } finally {
      EasyLoading.dismiss();
    }
  }

  //清除不需要的推荐数据
  void cleanRemandData(DiscountBean discountBean) {
    List<SuggestBean> bList = []; //新的前置推荐集合
    List<SuggestBean> aList = []; //新的后置推荐集合
    if (tabList != null && tabList.isNotEmpty) {
      for (var item in tabList) {
        if (item.data != null && item.data!.isNotEmpty) {
          var tempList = List.from(item.data!);
          // if (manualRechargeList != null && manualRechargeList.isNotEmpty) {
          //   print("人工充值:${manualRechargeList}");
          //   tempList.addAll(manualRechargeList);
          // }
          for (var item2 in item.data!) {
            if (item2.tenantPayMerchant != null &&
                item2.tenantPayMerchant!.isNotEmpty) {
              for (var item3 in item2.tenantPayMerchant!) {
                if (discountBean.suggestBefore != null &&
                    discountBean.suggestBefore!.isNotEmpty) {
                  for (var item4 in discountBean.suggestBefore!) {
                    if (item4.merId == item3.tenantPatMerId.toString()) {
                      bList.add(item4);
                    }
                  }
                }
                if (discountBean.suggestAfter != null &&
                    discountBean.suggestAfter!.isNotEmpty) {
                  for (var item4 in discountBean.suggestAfter!) {
                    if (item4.merId == item3.tenantPatMerId.toString()) {
                      aList.add(item4);
                    }
                  }
                }
              }
            }
            if (item2.tenantPayInfo != null &&
                item2.tenantPayInfo!.isNotEmpty) {
              for (var item3 in item2.tenantPayInfo!) {
                if (discountBean.suggestBefore != null &&
                    discountBean.suggestBefore!.isNotEmpty) {
                  for (var item4 in discountBean.suggestBefore!) {
                    if (item4.merId == item3.tenantPayId.toString()) {
                      bList.add(item4);
                    }
                  }
                }
                if (discountBean.suggestAfter != null &&
                    discountBean.suggestAfter!.isNotEmpty) {
                  for (var item4 in discountBean.suggestAfter!) {
                    if (item4.merId == item3.tenantPayId.toString()) {
                      aList.add(item4);
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
    if (manualRechargeList != null && manualRechargeList.isNotEmpty) {
      //人工充值也需要判断进去
      for (var item in manualRechargeList) {
        if (item.tenantPayMerchant != null &&
            item.tenantPayMerchant!.isNotEmpty) {
          for (var item3 in item.tenantPayMerchant!) {
            if (discountBean.suggestBefore != null &&
                discountBean.suggestBefore!.isNotEmpty) {
              for (var item4 in discountBean.suggestBefore!) {
                if (item4.merId == item3.tenantPatMerId.toString()) {
                  bList.add(item4);
                }
              }
            }
            if (discountBean.suggestAfter != null &&
                discountBean.suggestAfter!.isNotEmpty) {
              for (var item4 in discountBean.suggestAfter!) {
                if (item4.merId == item3.tenantPatMerId.toString()) {
                  aList.add(item4);
                }
              }
            }
          }
        }
        if (item.tenantPayInfo != null && item.tenantPayInfo!.isNotEmpty) {
          for (var item3 in item.tenantPayInfo!) {
            if (discountBean.suggestBefore != null &&
                discountBean.suggestBefore!.isNotEmpty) {
              for (var item4 in discountBean.suggestBefore!) {
                if (item4.merId == item3.tenantPayId.toString()) {
                  bList.add(item4);
                }
              }
            }
            if (discountBean.suggestAfter != null &&
                discountBean.suggestAfter!.isNotEmpty) {
              for (var item4 in discountBean.suggestAfter!) {
                if (item4.merId == item3.tenantPayId.toString()) {
                  aList.add(item4);
                }
              }
            }
          }
        }
      }
    }
    discountBean.suggestBefore = bList;
    discountBean.suggestAfter = aList;
  }

  //创建推荐数据
  void createRemandData() {
    if (discountBean != null) {
      //清除充值类型接口里面没有的数据
      cleanRemandData(discountBean!);
    }
    if (discountBean?.suggestOrgs != null &&
        discountBean!.suggestOrgs!.isNotEmpty) {
      var tempArray = discountBean!.suggestOrgs!.split(",");
      if (tabList != null && tabList.isNotEmpty) {
        for (var tempItem in tabList) {
          if (tempItem.data != null && tempItem.data!.isNotEmpty) {
            for (var item1 in tempItem.data!) {
              if (tempArray.contains(item1.payOrgId.toString())) {
                item1.isHasRecommend = true;
                item1.realDataLength = item1.tenantPayMerchant?.length ?? 0;
                //组装线上数据↓
                if (item1.tenantPayMerchant != null &&
                    item1.tenantPayMerchant!.isNotEmpty) {
                  if (discountBean?.suggestBefore != null &&
                      discountBean!.suggestBefore!.isNotEmpty) {
                    item1.beforeRecommendLength =
                        discountBean!.suggestBefore!.length;
                    //线上数据,前面组装
                    List<TenantPayMerchant> tempTenantPayMerchantList =
                        discountBean!.suggestBefore!
                            .map((item2) => TenantPayMerchant(
                                sourcetypeName: item2.show,
                                isRecommend: true,
                                cat: item2.cat,
                                tenantPatMerId: int.parse(item2.merId ?? "0")))
                            .toList();
                    if (tempTenantPayMerchantList != null &&
                        tempTenantPayMerchantList.isNotEmpty) {
                      if (item1.tenantPayMerchant != null) {
                        item1.tenantPayMerchant!
                            .insertAll(0, tempTenantPayMerchantList);
                      } else {
                        item1.tenantPayMerchant = tempTenantPayMerchantList;
                      }
                    }
                  }

                  if (discountBean?.suggestAfter != null &&
                      discountBean!.suggestAfter!.isNotEmpty) {
                    item1.afterRecommendLength =
                        discountBean!.suggestAfter!.length;
                    //线上数据,后面组装
                    List<TenantPayMerchant> tempTenantPayMerchantList =
                        discountBean!.suggestAfter!
                            .map((item2) => TenantPayMerchant(
                                sourcetypeName: item2.show,
                                isRecommend: true,
                                cat: item2.cat,
                                tenantPatMerId: int.parse(item2.merId ?? "0")))
                            .toList();
                    if (tempTenantPayMerchantList != null &&
                        tempTenantPayMerchantList.isNotEmpty) {
                      if (item1.tenantPayMerchant != null) {
                        item1.tenantPayMerchant!
                            .addAll(tempTenantPayMerchantList);
                      } else {
                        item1.tenantPayMerchant = tempTenantPayMerchantList;
                      }
                    }
                  }
                }
                //组装线上数据↑
                //组装线下数据↓
                if (item1.tenantPayInfo != null &&
                    item1.tenantPayInfo!.isNotEmpty) {
                  if (discountBean?.suggestBefore != null &&
                      discountBean!.suggestBefore!.isNotEmpty) {
                    item1.beforeRecommendLength =
                        discountBean!.suggestBefore!.length;
                    //线上数据,前面组装
                    List<TenantPayInfo> tempTenantPayMerchantList =
                        discountBean!.suggestBefore!
                            .map((item2) => TenantPayInfo(
                                sourcetypeName: item2.show,
                                isRecommend: true,
                                cat: item2.cat,
                                tenantPayId: int.parse(item2.merId ?? "0")))
                            .toList();
                    if (tempTenantPayMerchantList != null &&
                        tempTenantPayMerchantList.isNotEmpty) {
                      if (item1.tenantPayInfo != null) {
                        item1.tenantPayInfo!
                            .insertAll(0, tempTenantPayMerchantList);
                      } else {
                        item1.tenantPayInfo = tempTenantPayMerchantList;
                      }
                    }
                  }

                  if (discountBean?.suggestAfter != null &&
                      discountBean!.suggestAfter!.isNotEmpty) {
                    item1.afterRecommendLength =
                        discountBean!.suggestAfter!.length;
                    //线上数据,后面组装
                    List<TenantPayInfo> tempTenantPayMerchantList =
                        discountBean!.suggestAfter!
                            .map((item2) => TenantPayInfo(
                                sourcetypeName: item2.show,
                                isRecommend: true,
                                cat: item2.cat,
                                tenantPayId: int.parse(item2.merId ?? "0")))
                            .toList();
                    if (tempTenantPayMerchantList != null &&
                        tempTenantPayMerchantList.isNotEmpty) {
                      if (item1.tenantPayInfo != null) {
                        item1.tenantPayInfo!.addAll(tempTenantPayMerchantList);
                      } else {
                        item1.tenantPayInfo = tempTenantPayMerchantList;
                      }
                    }
                  }
                }
                //组装线下数据↑
              }
            }
          }
        }
      }
    }
  }

  void refreshRechargeTypeList({bool isRecommend = false}) {
    showRechargeTypeList.clear();
    showRechargeTypeList.value =
        List.from(tabList[currentTabIndex.value].data ?? []);
    isShowMore.value = showRechargeTypeList.length > 9;
    if (showRechargeTypeList.isNotEmpty) {
      // 进行排序
      showRechargeTypeList.sort((a, b) => b.sortV!.compareTo(a.sortV!));
      //首次请求成功的时候，切换到0
      changeRechargeTypeIndex(isRecommend ? indexLevel2 : 0,
          isRecommend: isRecommend);
    }
  }

  RxString describe = "".obs;
  //切换选中的充值类型的indexR
  void changeRechargeTypeIndex(int index, {bool isRecommend = false}) {
    currentSelectProtocalIndex.value = 0;
    thirdParameters.clear();
    thirdWalletBean.value = null;
    currentRechargeType = showRechargeTypeList[index];
    // describe.value = currentRechargeType.describeinfo ?? "";
    currentRechargeTypeIndex.value = index; // 选中支付索引
    currentRechargePayOrgId.value = currentRechargeType.payOrgId!; // 选中支付ID

    currentRechargeMarkType.value = currentRechargeType.mark!;

    // 处理协议
    if (currentRechargeType.mark == RechargeMarkType.offline) {
      offLineProtocolList.value = currentRechargeType.tenantPayInfo ?? [];
    } else {
      merchatProtocolList.value = currentRechargeType.tenantPayMerchant ?? [];
    }

    // 切换充值类型后将充值金额置为空
    if (currentRechargeType.mark == RechargeMarkType.offline) {
      if (Get.isRegistered<RechargeOfflineController>()) {
        RechargeOfflineController offlineController = Get.find();
        offlineController.rechargeAmount.value = '';
        offlineController.realAmount.value = '';
        offlineController.xnbRealAmount.value = '0.00';
      }
    } else {
      if (Get.isRegistered<RechargeOnlineController>()) {
        RechargeOnlineController onlineController = Get.find();
        onlineController.rechargeAmount.value = '';
        onlineController.realAmount.value = '';
        onlineController.xnbRealAmount.value = '0.00';
      }
    }

    // 点击后恢复成第一个协议
    if (currentRechargeType.isHasRecommend == true) {
      changeCurrentSelectProtocalIndex(
          currentRechargeType.beforeRecommendLength ?? 0);
    } else {
      changeCurrentSelectProtocalIndex(isRecommend ? indexLevel3 : 0);
    }
    describe.value = currentRechargeType
            .tenantPayMerchant?[currentSelectProtocalIndex.value].remark ??
        "";
    _updateShowTutorial();
  }

  // 判断是否显示教程
  _updateShowTutorial() {
    if (currentRechargeMarkType.value == RechargeMarkType.offline) {
      var payOrgId = currentRechargePayOrgId.value;
      var area = TenantManager.instance.tenantBean!.area;
      // 帮助教程 - 银行卡转账
      if ([1, 9].contains(payOrgId.toInt()) && area == 'CNY') {
        isShowTutorial.value = true;
        return;
      }

      // 视频教程 - 虚拟币线下
      if ([188].contains(payOrgId.toInt()) && area == 'CNY') {
        isShowTutorial.value = true;
        return;
      }
    }
    isShowTutorial.value = false;
  }

  RxBool isLoadingWalletInfo = false.obs;
  RxBool isBindWallet = false.obs; //是否绑定钱包，默认false;
  Rxn<ThirdWalletBean> thirdWalletBean = Rxn();
  var indexLevel1 = 0; //tab index
  var indexLevel2 = 0; //大类 index
  var indexLevel3 = 0; //小类 index
  // 切换渠道:比如支付宝下的a,b,c 逻辑有点绕
  void changeCurrentSelectProtocalIndex(int index) async {
    TenantPayMerchant? tempTenantPayMerchant;
    TenantPayInfo? tempTenantPayInfo;
    if (currentRechargeMarkType.value == RechargeMarkType.offline) {
      tempTenantPayInfo = offLineProtocolList[index];
      bool isRecommend = offLineProtocolList[index].isRecommend ?? false;
      if (isRecommend) {
        tabList.asMap().forEach((index1, item) {
          //第一层:顶部tab
          if (item.data != null && item.data!.isNotEmpty) {
            item!.data!.asMap().forEach((index2, item2) {
              if (item2.cat == 1) {
                //第二层:充值大类
                if (item2.tenantPayMerchant != null &&
                    item2.tenantPayMerchant!.isNotEmpty) {
                  if (tempTenantPayInfo != null) {
                    if (tempTenantPayInfo.cat == 1) {
                      item2.tenantPayMerchant!.asMap().forEach((index3, item3) {
                        //第三层:大类下的具体渠道
                        if (item3.tenantPatMerId ==
                                tempTenantPayInfo!.tenantPayId &&
                            (item3.isRecommend == false ||
                                item3.isRecommend == null)) {
                          indexLevel1 = index1;
                          indexLevel2 = index2;
                          indexLevel3 = index3;
                        }
                      });
                    } else {
                      //线下数据
                      if (item2.tenantPayInfo != null &&
                          item2.tenantPayInfo!.isNotEmpty) {
                        item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                          if (item3.tenantPayId ==
                              tempTenantPayInfo!.tenantPayId) {
                            indexLevel1 = index1;
                            indexLevel2 = index2;
                            indexLevel3 = index3;
                          }
                        });
                      }
                    }
                  }
                }
              } else {
                //第二层:充值大类
                if (item2.tenantPayInfo != null &&
                    item2.tenantPayInfo!.isNotEmpty) {
                  if (tempTenantPayInfo != null) {
                    if (tempTenantPayInfo.cat == 1) {
                      item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                        //第三层:大类下的具体渠道
                        if (item3.tenantPatMerId ==
                                tempTenantPayInfo!.tenantPayId &&
                            (item3.isRecommend == false ||
                                item3.isRecommend == null)) {
                          indexLevel1 = index1;
                          indexLevel2 = index2;
                          indexLevel3 = index3;
                        }
                      });
                    } else {
                      //线下数据
                      if (item2.tenantPayInfo != null &&
                          item2.tenantPayInfo!.isNotEmpty) {
                        item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                          if (item3.tenantPayId ==
                              tempTenantPayInfo!.tenantPayId) {
                            indexLevel1 = index1;
                            indexLevel2 = index2;
                            indexLevel3 = index3;
                          }
                        });
                      }
                    }
                  }
                }
              }
            });
          }
        });
        if (currentTabIndex.value != indexLevel1) {
          //tab不一样,先切换tab
          changeTabIndex(indexLevel1, isRecommend: isRecommend);
        } else if (currentRechargeTypeIndex.value != indexLevel2) {
          //大类不一样
          changeRechargeTypeIndex(isRecommend ? indexLevel2 : 0,
              isRecommend: isRecommend);
        }
        return;
      }
    } else {
      tempTenantPayMerchant = merchatProtocolList[index];
      bool isRecommend = merchatProtocolList[index].isRecommend ?? false;
      if (isRecommend) {
        tabList.asMap().forEach((index1, item) {
          //第一层:顶部tab
          if (item.data != null && item.data!.isNotEmpty) {
            item!.data!.asMap().forEach((index2, item2) {
              if (item2.cat == 1) {
                //第二层:充值大类
                if (item2.tenantPayMerchant != null &&
                    item2.tenantPayMerchant!.isNotEmpty) {
                  if (tempTenantPayMerchant != null) {
                    if (tempTenantPayMerchant.cat == 1) {
                      item2.tenantPayMerchant!.asMap().forEach((index3, item3) {
                        //第三层:大类下的具体渠道
                        if (item3.tenantPatMerId ==
                                tempTenantPayMerchant!.tenantPatMerId &&
                            (item3.isRecommend == false ||
                                item3.isRecommend == null)) {
                          indexLevel1 = index1;
                          indexLevel2 = index2;
                          indexLevel3 = index3;
                        }
                      });
                    } else {
                      //线下数据
                      if (item2.tenantPayInfo != null &&
                          item2.tenantPayInfo!.isNotEmpty) {
                        item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                          if (item3.tenantPayId ==
                              tempTenantPayMerchant!.tenantPatMerId) {
                            indexLevel1 = index1;
                            indexLevel2 = index2;
                            indexLevel3 = index3;
                          }
                        });
                      }
                    }
                  }
                }
              } else {
                //第二层:充值大类
                if (item2.tenantPayInfo != null &&
                    item2.tenantPayInfo!.isNotEmpty) {
                  if (tempTenantPayMerchant != null) {
                    if (tempTenantPayMerchant.cat == 1) {
                      item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                        //第三层:大类下的具体渠道
                        if (item3.tenantPayId ==
                                tempTenantPayMerchant!.tenantPatMerId &&
                            (item3.isRecommend == false ||
                                item3.isRecommend == null)) {
                          indexLevel1 = index1;
                          indexLevel2 = index2;
                          indexLevel3 = index3;
                          print(
                              "输出一下点击的333:${indexLevel1} ${indexLevel2} ${indexLevel3}");
                        }
                      });
                    } else {
                      //线下数据
                      if (item2.tenantPayInfo != null &&
                          item2.tenantPayInfo!.isNotEmpty) {
                        item2.tenantPayInfo!.asMap().forEach((index3, item3) {
                          if (item3.tenantPayId ==
                              tempTenantPayMerchant!.tenantPatMerId) {
                            indexLevel1 = index1;
                            indexLevel2 = index2;
                            indexLevel3 = index3;
                          }
                        });
                      }
                    }
                  }
                }
              }
            });
          }
        });
        print("输出一下点击的:${indexLevel1} ${indexLevel2} ${indexLevel3}");
        if (currentTabIndex.value != indexLevel1) {
          //tab不一样,先切换tab
          changeTabIndex(indexLevel1, isRecommend: isRecommend);
        } else if (currentRechargeTypeIndex.value != indexLevel2) {
          //大类不一样
          changeRechargeTypeIndex(isRecommend ? indexLevel2 : 0,
              isRecommend: isRecommend);
        }
        return;
      }
    }

    thirdParameters.clear();
    thirdWalletBean.value = null;
    currentSelectProtocalIndex.value = index;
    if (currentRechargeMarkType.value == RechargeMarkType.offline) {
      if ([188, 187].contains(
          offLineProtocolList[currentSelectProtocalIndex.value].payOrgId)) {
        reqRates();
      }
      isCanEnter.value = offLineProtocolList[index].isEnterAmount! != 0;

      /// ？？？
      currentSelectProtocalTenantPayId.value =
          offLineProtocolList[index].tenantPayId!;
      // 设置快捷金额
      _setQuickMoneyList(offLineProtocolList[index].quickRechargeAmount!);
    } else {
      if ([188, 187].contains(
          merchatProtocolList[currentSelectProtocalIndex.value].payOrgId)) {
        reqRates();
      }
      isCanEnter.value = merchatProtocolList[index].isEnterAmount! != 0;

      /// ？？？
      currentSelectProtocalTenantPayId.value =
          merchatProtocolList[index].tenantPatMerId!;
      // 设置快捷金额
      _setQuickMoneyList(merchatProtocolList[index].quickRechargeAmount!);
      thirdParameters = {};
      if (merchatProtocolList[currentSelectProtocalIndex.value].isEmbed ==
          "1") {
        //如果有内嵌钱包，请求数据
        isLoadingWalletInfo.value = true;
        try {
          thirdWalletBean.value = await LoginApi.reqUserBindStatus(
              payEngName: merchatProtocolList[currentSelectProtocalIndex.value]
                      .sourcetype ??
                  "");
          isBindWallet.value = thirdWalletBean.value?.isBind == "1";
          isLoadingWalletInfo.value = false;

          List<Charge> tempList = thirdWalletBean.value?.field?.charge ?? [];
          if (tempList.isNotEmpty) {
            for (var item in tempList) {
              thirdParameters['${item.key}'] = '';
            }
          }
          await reqUserInfo();
        } catch (e) {
          isLoadingWalletInfo.value = false;
        }
        isLoadingWalletInfo.value = false;
      }
      RechargeOnlineController onlineController;
      if (Get.isRegistered<RechargeOnlineController>()) {
        onlineController = Get.find();
      } else {
        onlineController = Get.put(RechargeOnlineController());
      }
      onlineController.rechargeAmount.value = '';
      onlineController.realAmount.value = '';
      onlineController.xnbRealAmount.value = '0.00';
      onlineController.isCanClickRecharge();
    }
  }

  Future<String?> getJumpUrl() async {
    String jumpUrl = await LoginApi.reqRechargeJumpAddress(
        payEngName:
            merchatProtocolList[currentSelectProtocalIndex.value].sourcetype ??
                "");
    return jumpUrl;
  }

  Future<String?> reqNoPayRegisterUrl(bool isBind) async {
    String thirdKey =
        thirdWalletBean.value?.field?.bind?[0].key?.isNotEmpty == true
            ? thirdWalletBean.value!.field!.bind![0]!.key!
            : "3rdKey1";

    var thirdValue = isBind ? "1" : "2";
    String? registerUrl = await LoginApi.reqRegisterAddress(
        payEngName:
            merchatProtocolList[currentSelectProtocalIndex.value].sourcetype ??
                "",
        thirdData: {thirdKey: thirdValue});
    return registerUrl;
  }

  Future<String?> reqRegisterUrl() async {
    String? registerUrl = await LoginApi.reqRegisterAddress(
        payEngName:
            merchatProtocolList[currentSelectProtocalIndex.value].sourcetype ??
                "",
        thirdData: thirdParameters);
    return registerUrl;
  }

  Future<void> reqUserInfo({bool isRefresh = false}) async {
    if (isRefresh) {
      EasyLoading.show(indicator: CommonLoadingView());
      walletBean.value = await LoginApi.reqRechargeUserInfo(
          payEngName: merchatProtocolList[currentSelectProtocalIndex.value]
                  .sourcetype ??
              "");
      EasyLoading.dismiss();
    } else {
      walletBean.value = await LoginApi.reqRechargeUserInfo(
          payEngName: merchatProtocolList[currentSelectProtocalIndex.value]
                  .sourcetype ??
              "");
    }
    if (merchatProtocolList[currentSelectProtocalIndex.value].payOrgId == 308) {
      //只有308 nopay才需要额外判断
      isBindWallet.value = walletBean.value?.walletBalance != -1; //只要不是-1,就绑定了
    }
  }

  //////////////////////////////////////////////⬇️
  Rxn<WalletBean> walletBean = Rxn<WalletBean>();
  //////////////////////////////////////////////⬆️

  // 设置快捷金额项
  void _setQuickMoneyList(String quickRechargeAmount) {
    if (quickRechargeAmount.trim() != '') {
      List<String> amountList = quickRechargeAmount.split(',').toList();

      quickMoneyList.value = amountList;
    } else {
      quickMoneyList.value = [];
    }

    currentSelectMoneyIndex.value = 99999;
  }

  //收起或者展开列表
  void openOrExpandList() {
    isExpand.value = !isExpand.value;
  }

  void changeMoneyIndex(int index) {
    currentSelectMoneyIndex.value = index;
  }

  /// 获取充值类型的icon地址
  String getRechargeTypeIcon({required int payOrgId}) {
    Map<int, int> idMap = {183: 30, 184: 0, 200: 199, 204: 203};
    int iconId = idMap[payOrgId] ?? payOrgId;

    if ([9, 24, 33, 23].contains(payOrgId)) {
      return 'assets/theme1/images/recharge/icons/recharge_${iconId}${AppConfigs.lang == 'cn' ? '' : '_en'}.png';
    }

    return 'assets/theme1/images/recharge/icons/recharge_${iconId}.png';
  }

  /// 点击快速充值
  void clickQuickRecharge() {
    String reqAddr = '';
    if (currentRechargeMarkType.value == RechargeMarkType.offline) {
      reqAddr = offLineProtocolList[currentSelectProtocalIndex.value].reqAddr!;
    } else {
      reqAddr = merchatProtocolList[currentSelectProtocalIndex.value].reqAddr!;
    }

    if (reqAddr == '') {
      EasyLoading.showToast('支付线路异常，请联系客服');
      return;
    }
    Get.toNamed(Routes.WEB_VIEW, arguments: {
      "url": reqAddr,
      "isShowTitle": true, //是否显示title
      "isShowRecharge": false,
      "title": "快速充值",
    });
  }

  /// 获取教程配置
  TutorialsConfigBean getTutorialsConfig() {
    String title = '';
    List<String> contentList = [];
    if (currentRechargePayOrgId.value == 188) {
      title = '视频教程';
      contentList.addAll(['火币APP转账教程', 'imToken转账教程']);
    } else {
      title = '帮助教程';
      contentList.addAll(['微信转银行卡教程', '支付宝转银行卡教程']);
    }

    return TutorialsConfigBean(title: title, contentList: contentList);
  }

  /// 点击教程
  handleTutorials(int index) {
    if (currentRechargePayOrgId.value.toInt() == 188) {
      // 视频教程 - 虚拟币线下
      String imgDomain =
          TenantManager.instance.tenantBean!.imgsDomain[0].domainAddr;
      String cusUrl = '$imgDomain/static/tutorial/index.html';

      List<String> vedioList = [
        'https://www.youtube.com/watch?v=r1TRBRi-_LI',
        'https://www.youtube.com/watch?v=cQa9j-5CHUY',
      ];

      String url = AppConfigs.lang == 'cn' ? cusUrl : vedioList[index];

      Get.back(); // 关闭

      Get.toNamed(Routes.WEB_VIEW, arguments: {
        "url": url,
        "isShowTitle": true, //是否显示title
        "isShowRecharge": false,
        "title": "视频教程",
      });
    } else {
      // 帮助教程 - 银行卡转账
      List<String> imageList = [
        Assets.theme1.images.recharge.tutorials.wxzyhk.path,
        Assets.theme1.images.recharge.tutorials.zfbzyhk.path,
      ];

      String url = imageList[index];
      Get.back(); // 关闭

      Get.toNamed(Routes.WEB_VIEW, arguments: {
        "url": url,
        "isShowTitle": true, //是否显示title
        "isShowRecharge": false,
        "appMode": AppModeEnum.assetsImage,
        "title": "帮助教程",
      });
    }
  }

  /// 获取充值金额的文字
  String getRechargeAmountPlaceholder() {
    String placeholder = '请输入充值金额';
    String area = TenantManager.instance.tenantBean!.area ?? ''; // 币种
    // 线下
    if (currentRechargeMarkType.value == RechargeMarkType.offline) {
      num quotaMin =
          offLineProtocolList[currentSelectProtocalIndex.value].quotaMin ?? 0;
      num quotaMax =
          offLineProtocolList[currentSelectProtocalIndex.value].quotaMax ?? 0;
      num rate =
          offLineProtocolList[currentSelectProtocalIndex.value].rate ?? 1;

      num realRate = rate / currencyRate.value;

      if (quotaMin > 0 && quotaMax > 0) {
        var min = ((quotaMin / 1000) * realRate).truncateToFixed(2);
        var max = ((quotaMax / 1000) * realRate).truncateToFixed(2);

        placeholder = '${min}${area} ~ ${max}${area}';
      }
    }
    if (tabList[currentTabIndex.value].data?[0].payOrgId == 187) {
      //数字货币
      num quotaMin =
          merchatProtocolList[currentSelectProtocalIndex.value].quotaMin ?? 0;
      num quotaMax =
          merchatProtocolList[currentSelectProtocalIndex.value].quotaMax ?? 0;
      num rate = digitalCurrencyRate.value;
      // merchatProtocolList[currentSelectProtocalIndex.value].rate ?? 1;

      num realRate = rate / currencyRate.value;

      if (quotaMin > 0 && quotaMax > 0) {
        var min = (currencyType.value == CurrencyType.fiat
                ? ((quotaMin / 1000) * realRate)
                : (quotaMin / 1000))
            .truncateToFixed(0);
        var max = (currencyType.value == CurrencyType.fiat
                ? ((quotaMax / 1000) * realRate)
                : (quotaMax / 1000))
            .truncateToFixed(0);

        placeholder = currencyType.value == CurrencyType.crypto
            ? '单笔${min} ~ ${max}'
            : "请输入上分数量";
      }
    }
    // 线上
    if (currentRechargeMarkType.value == RechargeMarkType.online) {
      //
    }

    return placeholder;
  }

  /// 联系客服
  void handleContactCustomer() {
    AppManager.instance.tapVibrate();
    if (TenantManager.instance.isCanOpenCustomerService) {
      Get.toNamed(Routes.CUSTOMER_SERVICE);
    } else {
      String? onlineAddr =
          TenantManager.instance.tenantBean?.tenant?.onlineAddr;
      if (onlineAddr != null) {
        String? type = TenantManager
            .instance.tenantBean?.sysOptions?.customerServiceSkipType;
        if (type == '1') {
          launchUrl(Uri.parse(onlineAddr),
              mode: LaunchMode.externalApplication);
        } else {
          Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
            "url": onlineAddr, //请求地址
            "title": "在线客服",
          });
        }
      }
    }
  }

  void changeTabIndex(int index, {bool isRecommend = false}) {
    currentTabIndex.value = index;
    tabController.index = index;
    refreshRechargeTypeList(isRecommend: isRecommend);
  }

  void scrollTop() {
    rechargeScrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  reqRates() async {
    animationController.forward(from: 0);
    String? rate = await LoginApi.reqRates(
        payEngName:
            merchatProtocolList[currentSelectProtocalIndex.value].sourcetype ??
                "");
    if (rate != null && rate.isNotEmpty) {
      digitalCurrencyRate.value = num.parse(rate!);
    }
    animationController.stop();
  }

  RxNum digitalCurrencyRate = RxNum(0); //数字货币汇率
}
