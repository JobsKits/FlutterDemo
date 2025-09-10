import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../api/system_api.dart';
import '../../../../api/user_api.dart';
import '../../../../kernel/configs/app_configs.dart';
import '../../../../kernel/network/error.dart';
import '../../../../kernel/network/service.dart';
import '../../wallet/data/withdraw_type_bean2.dart';
import '../../wallet/data/withdraw_type_new_bean.dart';

class NewUserAccountManagementController extends GetxController
    with GetTickerProviderStateMixin {
  late ScrollController withdrawScrollController;
  late TabController tabController;
  late AnimationController animationController; // 刷新按钮动画
  Worker? loginListener;
  RxList<WithdrawTypeTabBean2> tabList = <WithdrawTypeTabBean2>[].obs;
  final RxBool isShowMore = false.obs;
  RxBool isExpand = false.obs; //是否已展开列表，默认为false

  //===============================新账户管理⬇️
  RxList<PayInfo> contentList = <PayInfo>[].obs;
  List<List<PayInfo>> bindAllList = <List<PayInfo>>[];
  Rxn<PayInfo> currentSelectItem = Rxn();
  bool hasPwd = false; //是否有支付密码，默认false
  //===============================新账户管理⬆️
  String? boundName = null;
  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null) {
      final arguments = Get.arguments as Map<String, dynamic>;
      currentTabIndex.value = arguments['tabIndex'] ?? 0;
    }
    checkPwdStatus();
    // print(
    //     "token:${LoginManager.instance.loginInfo?.accessToken}  cid:${LoginManager.instance.loginInfo?.custId}");
    boundName = LoginManager.instance.loginInfo?.custContact?.contactName;
    if (boundName != null && boundName!.isEmpty) {
      boundName = null;
    }
    withdrawScrollController = ScrollController();
    tabController = TabController(length: 0, vsync: this);
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // 动画持续时间
      vsync: this,
    )..repeat(); // 循环动画
    reqDefaultBankCard(); // 获取提现方式
  }

  void checkPwdStatus() async {
    hasPwd = await UserApi().checkPwdStatus(2);
  }

  @override
  onClose() {
    tabController.dispose();
    animationController.dispose();
    withdrawScrollController.dispose();
    super.onClose();
  }

  /// 获取提现方式
  Future<void> reqDefaultBankCard({bool isRefresh = true}) async {
    EasyLoading.show(indicator: CommonLoadingView());
    if (!isRefresh) return;
    try {
      final res = await SystemApi.reqDefaultBankCard2();
      if (res.type == NetworkService.networkTypeSuccess) {
        EasyLoading.dismiss();
        tabList.clear();
        bindAllList.clear();
        for (var item in res.data) {
          List<PayInfo> tempList = [];

          WithdrawTypeTabBean2 secondItem = WithdrawTypeTabBean2.fromJson(item);
          if (secondItem.data != null && secondItem.data!.isNotEmpty) {
            for (var item2 in secondItem.data!) {
              if (item2.payInfo != null && item2.payInfo!.isNotEmpty) {
                for (var item3 in item2.payInfo!) {
                  if (item3.payInfoId != 0) {
                    if (secondItem.rechargeTypeId == 3 && boundName == null) {
                      // 取银行卡已绑定的名字
                      boundName = item3.pay_name;
                    }
                    tempList.add(item3);
                  }
                }
              }
            }
          }
          tempList.map((item) {
            if (item.pay_no != null) {
              String payNo = item.pay_no!;
              int length = payNo.length;
              if (length > 7) {
                // 长度大于7，保留前3位和后4位
                item.tempPayNo = payNo.replaceRange(3, length - 4, '...');
              } else if (length > 4) {
                // 长度在4到7之间，保留前2位和后3位
                item.tempPayNo = payNo.replaceRange(2, length - 3, '...');
              } else if (length > 1) {
                // 长度为2或3，保留第1位和最后1位，中间加 `...`
                item.tempPayNo = '${payNo[0]}...${payNo[length - 1]}';
              } else {
                // 长度为1，直接返回
                item.tempPayNo = payNo;
              }
            } else {
              // pay_no 为 null
              item.tempPayNo = '';
            }
            return item;
          }).toList();
          tabList.add(secondItem);
          bindAllList.add(tempList);
        }
        if (tabList.isNotEmpty) {
          tabController.dispose();
          tabController = TabController(length: tabList.length, vsync: this);
          changeTabIndex(currentTabIndex.value);
        }
      } else if (res.type == NetworkService.networkTypeError) {
        if (res.data is NetworkError) {
          NetworkError error = res.data;
          print("执行出错:${res}");
          Get.snackbar("请求出错", "接口无数据响应");
        }
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("错误：${e}");
      Get.snackbar("请求出错", "${e}");
    }
  }

  //显示或者隐藏账号
  void showOrHideAccount(int index) {
    contentList[index].isShowNum.value = !(contentList[index].isShowNum.value);
    if (!contentList[index].isShowNum.value) {
      contentList[index].tempPayNo = contentList[index]
          .pay_no!
          .replaceRange(3, contentList[index].pay_no!.length - 4, '...');
    }
  }

  //切换默认卡
  void setDefaultValue(int index) async {
    bool isUnSelect = contentList[index].sortV != 1; //判断一下点击的是否已经是默认卡
    if (isUnSelect) {
      EasyLoading.show(indicator: const CommonLoadingView());
      //不是默认卡
      //执行设置默认卡的逻辑
      bool isSuccess =
          await UserApi().setDefaultBank(contentList[index].payInfoId!.toInt());
      if (isSuccess) {
        reqDefaultBankCard();
      }
      EasyLoading.dismiss();
    }
  }

  RxInt currentTabIndex = 0.obs; //当前选中的tab
  void changeTabIndex(int index) {
    currentTabIndex.value = index;
    tabController.animateTo(index);
    contentList.value = bindAllList[index];
    print("输出一下请求2：${contentList.length}  index:${index}");
  }

  RxBool isReqWithdrawAccountFinish = false.obs; // 是否请求完成用户钱包

  String getRechargeTypeIcon({required num payOrgId}) {
    Map<int, int> idMap = {183: 30, 184: 0, 200: 199, 204: 203};
    num iconId = idMap[payOrgId] ?? payOrgId;

    if ([9, 24, 33, 23].contains(payOrgId)) {
      return 'assets/theme1/images/recharge/icons/recharge_${iconId}${AppConfigs.lang == 'cn' ? '' : '_en'}.png';
    }

    return 'assets/theme1/images/recharge/icons/recharge_${iconId}.png';
  }
}
