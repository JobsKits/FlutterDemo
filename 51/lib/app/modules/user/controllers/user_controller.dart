import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/vip_info_bean.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/language_util.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../api/user_api.dart';
import '../../../routes/app_pages.dart';
import '../../activity/data/activity_bean.dart';
import '../../settings/views/settings_withdrawal_pwd_dialog.dart';

//我的页面的Controller
class UserController extends GetxController with GetTickerProviderStateMixin {
  RxString userHead = "".obs;
  RxString userName = "登录/注册".obs;
  RxString userId = "".obs;
  RxString vipLevel = "".obs;
  RxString balanceStr = "".obs;
  List<String> functionsList = [
    "投注记录",
    "资金明细",
    "账户管理",
    "代理中心",
  ];
  List<String> bottomItemList = [
    "福利中心",
    "自助返水",
    "找回余额",
    "个人报表",
    "备用网址",
    "在线客服",
    // "幸运大转盘",
  ];
  List<String> bottomItemList2 = [
    "帮助中心",
    "关于我们",
  ];
  RxString versionStr = "".obs;
  late TabsController tabsController = Get.find();
  // RxInt unReadCount = 0.obs;
  RxString languageIcon = "".obs;
  RxBool isLogoutLoading = false.obs;

  // --------------------
  RxBool isWeekPower = true.obs; // 周俸禄
  RxBool isMonthPower = true.obs; // 月俸禄
  RxBool isLevelPower = true.obs; // 晋级礼金
  RxBool isRebetePower = true.obs; // 自助返水
  // --------------------
  late AnimationController animationController; // 刷新按钮动画
  final ActivityController actController = Get.put(ActivityController());

  @override
  void onInit() async {
    super.onInit();
    animationController = AnimationController(
      duration: const Duration(seconds: 1), // 动画持续时间
      vsync: this,
    )..repeat(); // 循环动画
    ever(LoginManager.instance.isLogin, (isLogin) {
      //登录状态发生变化，都要重新初始化用户数据
      if (isLogin) {
        initUserInfo();
      } else {
        clearData();
      }
    });
    ever(tabsController.currentIndex, (value) async {
      var isShowVideo = tabsController.showVideo;
      var isRefresh = isShowVideo ? value == 4 : value == 3;
      if (isRefresh) {
        updateLastLogin();
        // reqMessage();
        reqMoney();
        checkPwdStatus();
        reqVipData();
        tabsController.reqActivityCollections(receiveType: 99999);
      }
    });
    updateLastLogin();
    initUserInfo();
    versionStr.value = await fetchVersionInfo();
  }

  //请求vip数据
  void reqVipData() async {
    await _reqVipInfo();
    await _reqVipList();
  }

  bool hasPwd = false; //是否有支付密码，默认false
  void checkPwdStatus() async {
    hasPwd = await UserApi().checkPwdStatus(2);
  }

  void clearData() {
    userHead.value = "";
    userId.value = "";
    userName.value = "登录/注册";
    balanceStr.value = "";
    vipLevel.value = "";

    isWeekPower.value = true;
    isMonthPower.value = true;
    isLevelPower.value = true;
    isRebetePower.value = true;
  }

  @override
  void dispose() {
    animationController.dispose(); // 先释放 AnimationController
    super.dispose();
  } //初始化用户信息

  Future<void> initUserInfo({isRefresh = false}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reqBanner();
      // 在构建完成后执行
      if (!LoginManager.instance.isLogin.value) {
        if (isRefresh) {
          //下拉刷新才弹出
          showLoginDialog();
        }
        return;
      }
      String head = LoginManager.instance.loginInfo?.head ?? '';
      if (head.startsWith('http')) {
        userHead.value = head;
      } else {
        String imgDomain = TenantManager.instance.appImgDomainPath.value;
        if (imgDomain.isNotEmpty) {
          userHead.value = "$imgDomain/$head";
        }
      }
      userName.value = LoginManager.instance.loginInfo?.nickname ?? "";
      userId.value = "${LoginManager.instance.loginInfo?.custId}";
      languageIcon.value = await LanguageUtil.getLanguageIconPath();
      reqBanner();
      await reqMoney();
      currentVipLevel.value = LoginManager.instance.loginInfo?.custLevel ?? 0;
      reqVipData();
      // reqMessage(); //请求消息通知
      checkPwdStatus();
      tabsController.reqActivityCollections(receiveType: 99999);
    });
  }

  // void reqMessage() async {
  //   int unReadCount = 0; //未读数量
  //
  //   List<InboxMsgItemBean> inboxList = await UserApi().reqInboxMsg();
  //   unReadCount += inboxList
  //       .where((item) => item.type == 0 || item.type == 4)
  //       .toList()
  //       .length;
  //   MyMessageBean? messageBean = await UserApi().reqMyMsg();
  //   if (messageBean != null && messageBean.data != null) {
  //     List<MyMessageItemBean> myMsgList = messageBean.data!;
  //
  //     unReadCount += myMsgList.where((item) => item.state != 9).length;
  //   }
  //   this.unReadCount.value = unReadCount;
  // }

  //退出登录
  void logout() async {
    isLogoutLoading.value = true;
    await LoginApi.logout();
    // tabsController.jumpToPage(0);
    isLogoutLoading.value = false;
  }

  // 获取账户余额
  Future<void> reqMoney() async {
    if (TenantManager.instance.tenantBean != null &&
        LoginManager.instance.loginInfo != null) {
      animationController.forward(from: 0);
      await UserApi().findMoney2('');
      await LoginManager.instance.reqMoney();
      animationController.stop();
    }
  }

  void clickFunctions(int index) {
    switch (index) {
      case 0:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.BET); //投注记录
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.BET); //投注记录
          });
        }
        break;
      case 1:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.FUNDING_DETAILS); //交易明细
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.FUNDING_DETAILS); //交易明细
          });
        }
        break;
      case 2:
        if (LoginManager.instance.isLogin.value) {
          // Get.toNamed(Routes.ACCOUNT_MANAGEMENT); //账户管理
          Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT); //新账户管理
        } else {
          showLoginDialog(callback: () {
            // Get.toNamed(Routes.ACCOUNT_MANAGEMENT); //账户管理
            Get.toNamed(Routes.NEW_ACCOUNT_MANAGEMENT); //新账户管理
          });
        }
        break;
      case 3:
        if (LoginManager.instance.isLogin.value) {
          _toAgentCenter();
        } else {
          showLoginDialog(callback: () {
            _toAgentCenter();
          });
        }
        // Get.toNamed(Routes.AGENT_CENTER); //代理中心
        break;
    }
  }

  final ActivityController activityController = Get.find();
  void clickItemList1(int index) {
    switch (index) {
      case 0:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.BOUNS_CENTER)?.then((_) {
            initUserInfo(isRefresh: true);
          }); //找回余额
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.BOUNS_CENTER)?.then((_) {
              initUserInfo(isRefresh: true);
            }); //找回余额
          });
        }
        break;
      case 1:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        pushToActivity('返水');
        break;
      case 2:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.FIND_BALANCE)?.then((_) => reqMoney()); //找回余额
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.FIND_BALANCE)?.then((_) => reqMoney()); //找回余额
          });
        }
        break;
      case 3:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.PERSONAL_STATEMENTS); //个人报表
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.PERSONAL_STATEMENTS); //个人报表
          });
        }
        break;
      case 4:
        Get.toNamed(Routes.ALTERNATE_URLS); //备用网址
        break;
      case 5:
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
        break;
      // case 4:
      //   Get.toNamed(Routes.LUCKY_WHEEL); //幸运大转盘
      //   break;
    }
  }

  void clickItemList2(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.HELP_CENTER); //帮助中心
        break;
      case 1:
        Get.toNamed(Routes.ABOUT_US); //关于我们
        break;
    }
  }

  // 充值
  void handleRecharge() {
    if (LoginManager.instance.isLogin.value) {
      var isOpenVideo =
          TenantManager.instance.tenantBean?.isOpenVideo == 'true';
      tabsController.jumpToPage(isOpenVideo ? 2 : 1);
    } else {
      showLoginDialog(callback: () {
        Get.toNamed(Routes.RECHARGE);
      });
    }
  }

  // 提现
  void handleWithdraw() async {
    if (LoginManager.instance.isLogin.value) {
      // Get.toNamed(Routes.RECHARGE_WITHDRAWAL, arguments: {"isBand": true});
      if (hasPwd) {
        Get.toNamed(Routes.NEW_RECHARGE_WITHDRAWAL,
            arguments: {"isBand": true});
      } else {
        // Get.toNamed(Routes.EDIT_PASSWORD, arguments: {"isLoginPwd": false})
        //     ?.then((_) {
        //   checkPwdStatus();
        // });
        await Get.dialog(SettingsWithdrawalPwdDialog());
        checkPwdStatus();
      }
    } else {
      showLoginDialog(callback: () {
        // Get.toNamed(Routes.RECHARGE_WITHDRAWAL, arguments: {"isBand": true});
        Get.toNamed(Routes.NEW_RECHARGE_WITHDRAWAL,
            arguments: {"isBand": true});
      });
    }
  }

  void _toAgentCenter() async {
    Get.toNamed(Routes.AGENT_CENTER);
  }

  void pushToActivity(String name) {
    var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
    tabsController.jumpToPage(isOpenVideo ? 3 : 2);
    final signInIndex = actController.activityData.indexWhere(
      (activity) => activity.title == name,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      actController.jumpToPage(signInIndex);
    });
  }

  RxDouble rechargeDiff = 0.0.obs; // 距离下一个等级的充值差额：当前进度条
  RxDouble bettingDiff = 0.0.obs; // 距离下一个等级的投注差额：当前进度条
  RxList<VipLevelItemBean> vipInfoData = <VipLevelItemBean>[].obs; // VIP 配置信息
  RxInt currentVipLevel = 0.obs; // 当前VIP等级
  RxBool isMaxLevel = false.obs;
  Future<void> _reqVipInfo() async {
    VipInfoBean? resData = await UserApi().reqVipInfo();
    if (resData != null) {
      vipInfoData.value = resData.data ?? [];
      isMaxLevel.value = vipInfoData.last.level == currentVipLevel.value;
      List<VipLevelItemBean> list = vipInfoData
          .where((ele) => ele.level == currentVipLevel.value)
          .toList();
      if (list.isNotEmpty) {
        VipLevelItemBean item = list[0];
        rechargeDiff.value = double.parse(
            ((item.balanceDifferAmount ?? 0) / 1000).truncateToFixed(2));
        bettingDiff.value =
            double.parse(((item.differAmount ?? 0) / 1000).truncateToFixed(2));
      }
    }
  }

  RxList<VipLevelItemBean> vipListData = <VipLevelItemBean>[].obs; // VIP 配置信息
  RxDouble betProgress = 0.0.obs;
  RxDouble rechargeProgress = 0.0.obs;
  RxDouble allProgress = 0.0.obs;
  RxDouble nextBetMin = 0.0.obs; //下一等级最小投注金额(进度条最大值)
  RxDouble nextRechargeMin = 0.0.obs; //下一等级最小充值金额(进度条最大值)
  RxString showStr = "".obs;

  // 获取vip晋级模式列表信息
  Future<void> _reqVipList() async {
    VipInfoBean? resData = await UserApi().reqVipList();
    if (resData != null) {
      vipListData.value = resData.data ?? [];
      var nextLevel =
          isMaxLevel.value ? currentVipLevel.value : currentVipLevel.value + 1;
      var index = vipInfoData.indexWhere((item) => item.level == nextLevel); //
      nextBetMin.value = double.parse(
          ((vipListData[index].valueLower ?? 0) / 1000).truncateToFixed(2));
      nextRechargeMin.value = double.parse(
          ((vipListData[index].balanceLower ?? 0) / 1000).truncateToFixed(2));

      var rechargeStr = "";
      var betStr = "";
      if (rechargeDiff.value > 0) {
        //还需要充值的金额
        rechargeStr = "充值${rechargeDiff.toStringAsFixed(2)}";
      }
      if (bettingDiff.value > 0) {
        //还需要投注的金额
        betStr = "投注${bettingDiff.toStringAsFixed(2)}";
      }
      var bet1 = nextBetMin.value - bettingDiff.value;
      if (bet1 <= 0) {
        bet1 = 1;
      }
      var recharge1 = nextRechargeMin.value - rechargeDiff.value;
      if (recharge1 <= 0) {
        recharge1 = 1;
      }
      betProgress.value = bet1 / (nextBetMin.value == 0 ? 1 : nextBetMin.value);

      rechargeProgress.value =
          recharge1 / (nextRechargeMin.value == 0 ? 1 : nextRechargeMin.value);
      if (isMaxLevel.value) {
        allProgress.value = 1;
      } else {
        allProgress.value = (betProgress.value + rechargeProgress.value) / 2;
      }

      var newStr = "";
      if (rechargeStr.isNotEmpty && betStr.isNotEmpty) {
        newStr = "晋级还需$rechargeStr,$betStr";
      } else if (rechargeStr.isNotEmpty) {
        newStr = "晋级还需$rechargeStr";
      } else {
        newStr = "晋级还需$betStr";
      }
      if (isMaxLevel.value) {
        newStr = "恭喜，您已经是最高等级VIP";
      }
      showStr.value = newStr;
    }
  }

  late CarouselSliderController buttonCarouselController =
      CarouselSliderController(); //banner和指示器的Controller
  //切换banner的index
  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  RxInt currentBannerIndex = 0.obs; //当前选中banner的index

  RxInt isShowBulletinId = 0.obs; // 点击了当前子项目
  RxList<ActivityListItemBean> bannerList = <ActivityListItemBean>[].obs;
  reqBanner() async {
    var tempList = await UserApi().reqBanner();
    bannerHeight.value = await getMaxImageHeight(tempList);
    bannerList.value = tempList;
  }

  RxDouble bannerHeight = 0.0.obs;

  Future<double> getMaxImageHeight(List<ActivityListItemBean> urls) async {
    try {
      // 异步拿到所有图片尺寸
      final sizes = await Future.wait(urls.map(getImageSize));

      // 提取高度列表
      final heights = sizes.map((s) => s.height).toList();

      // 找最大值
      var tempMax = heights.reduce((a, b) => a > b ? a : b);
      if (tempMax > 400) {
        tempMax = 400;
      }
      if (tempMax < 236) {
        tempMax = 236;
      }
      return tempMax;
    } catch (e) {
      print('Error getting image sizes: $e');
      return 0.0; // 出错返回0或其他默认值
    }
  }

  Future<Size> getImageSize(ActivityListItemBean bannerBean) async {
    final completer = Completer<Size>();
    final image = NetworkImage(bannerBean.subject ?? "");
    final listener = ImageStreamListener((ImageInfo info, bool _) {
      final myImage = info.image;
      completer
          .complete(Size(myImage.width.toDouble(), myImage.height.toDouble()));
    }, onError: (dynamic error, StackTrace? stackTrace) {
      completer.completeError(error, stackTrace);
    });

    image.resolve(const ImageConfiguration()).addListener(listener);

    return completer.future;
  }

  updateLastLogin() {
    if (LoginManager.instance.isLogin.value) {
      // print('调用 修改客户最后登录信息 接口');
      UserApi.updateLastLogin();
    }
  }
}
