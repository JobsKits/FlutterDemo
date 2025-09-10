import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/api/user_api.dart';

import 'package:flutter_tiyu_app/app/modules/user/data/vip_info_bean.dart';

import '../../home/controllers/new_home_controller.dart';

class VipTabBean {
  VipTabBean({
    required this.title,
    required this.show,
    // required this.child,
  });

  final String title;
  final bool show;
  // final Widget child;
}

class ControllerVipPage extends GetxController
    with GetTickerProviderStateMixin {
  // late PageController pageController;

  RxInt tabCurrentIndex = 0.obs;
  late RxList<VipTabBean> tabData = <VipTabBean>[].obs; // tab的数据
  late TabController tabController;

  final ActivityController actController = Get.find();

  final NewHomeController homeController = Get.find();

  //--------------------------------------------------------------
  RxList<VipLevelItemBean> vipInfoData = <VipLevelItemBean>[].obs; // VIP 配置信息
  Rx<VipLevelItemBean> currentInfoData = VipLevelItemBean().obs; //

  RxList<VipLevelItemBean> vipListData = <VipLevelItemBean>[].obs; // VIP 配置信息
  RxInt currentVipLevel = 0.obs; // 当前VIP等级

  RxDouble rechargeDiff = 0.00.obs; // 距离下一个等级的充值差额
  RxDouble bettingDiff = 0.00.obs; // 距离下一个等级的投注差额

  RxDouble totalReward = 0.00.obs; // 总领取金额

  RxDouble levelReward = 0.00.obs; // 晋级奖金
  RxBool isLevelReward = false.obs; // 晋级是否领取
  RxDouble dayReward = 0.00.obs; // 日俸禄
  RxBool isDayReward = false.obs; // 日俸禄是否领取
  RxDouble weekReward = 0.00.obs; // 周俸禄
  RxBool isWeekReward = false.obs; // 周俸禄是否领取
  RxDouble monthReward = 0.00.obs; // 月俸禄
  RxBool isMonthReward = false.obs; // 月俸禄是否领取

  RxBool isReceiveLoading = false.obs; // 领取loading
  RxString ruler = ''.obs; // vip规则

  RxBool dayHaveValue = false.obs; // 月俸禄是否领取
  RxBool weekHaveValue = false.obs; // 月俸禄是否领取
  RxBool monthHaveValue = false.obs; // 月俸禄是否领取
  RxDouble totalBet = 0.00.obs; // 总领取金额
  RxDouble totalRechrge = 0.00.obs; // 总领取金额

  @override
  onInit() async {
    super.onInit();

    _initTabData();

    await initData(needLoading: true);

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        initData(needLoading: true);
      } else {
        _clearData();
      }
    });

    ever(homeController.tabsController.currentIndex, (index) async {
      int idx = homeController.tabsController.defaultBottomItemList
          .indexWhere((e) => e.title == 'events');
      if (idx == index && actController.currentTabIndex == 2) {
        if (LoginManager.instance.isLogin.value) {
          _clearData();
          initData(needLoading: true);
        } else {
          _clearData();
        }
      }
    });

    ever(actController.currentTabIndex, (index) async {
      if (index == 2) {
        if (LoginManager.instance.isLogin.value) {
          _clearData();
          initData();
        } else {
          _clearData();
        }
      }
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    // pageController.dispose();
    super.onClose();
  }

  void _clearData() {
    vipListData.value = [];
    currentVipLevel.value = 0;
  }

  void _initTabData() {
    List<VipTabBean> list = [
      VipTabBean(title: '晋级奖金', show: true),
      VipTabBean(title: '日俸禄', show: true),
      VipTabBean(title: '周俸禄', show: true),
      VipTabBean(title: '月俸禄', show: true),
      VipTabBean(title: '生日红包', show: true),
      VipTabBean(title: '保级要求', show: true),
      VipTabBean(title: 'VIP特权', show: true),
    ];

    tabData.value = list;
    // pageController = PageController(initialPage: 0);
    tabController = TabController(length: list.length, vsync: this);
  }

  jumpToPage(int index) {
    tabCurrentIndex.value = index;
    // pageController.jumpToPage(index);
  }

  // 初始化数据请求
  Future<void> initData({bool? needLoading = false}) async {
    if (!LoginManager.instance.isLogin.value) {
      return;
    }

    try {
      if (needLoading == true) {
        EasyLoading.show(status: '加载中...');
      }

      currentVipLevel.value =
          int.parse(LoginManager.instance.vipLevel.value.toString());
      await _reqVipInfo();
      await _reqVipList();
      await _reqVipRuler();
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    } finally {
      if (needLoading == true) {
        EasyLoading.dismiss();
      }
    }
  }

  // 获取vip晋级模式列表信息,并携带领取状态
  Future<void> _reqVipInfo() async {
    VipInfoBean? resData = await UserApi().reqVipInfo();
    if (resData != null) {
      vipInfoData.value = resData.data ?? [];
      VipTotalBean? total = resData.t;
      levelReward.value = (total?.levelRewardSum ?? 0) / 1000;
      isLevelReward.value = levelReward.value <= 0; // 已领取

      dayReward.value = (total?.dayRewardSum ?? 0) / 1000;
      isDayReward.value = dayReward.value <= 0; // 已领取

      weekReward.value = (total?.weekRewardSum ?? 0) / 1000;
      isWeekReward.value = weekReward.value <= 0; // 已领取

      monthReward.value = (total?.monthRewardSum ?? 0) / 1000;
      isMonthReward.value = monthReward.value <= 0;

      totalReward.value = (total?.totalRewardSum ?? 0) / 1000;

      totalBet.value = (total?.totalBet ?? 0) / 1000;
      totalRechrge.value = (total?.totalRecharge ?? 0) / 1000;

      // print('=====>${isLevelReward.value} ${isDayReward.value}');
      List<VipLevelItemBean> list = vipInfoData
          .where((ele) => ele.level == currentVipLevel.value)
          .toList();

      if (list.isNotEmpty) {
        VipLevelItemBean item = list[0];
        currentInfoData.value = item;

        rechargeDiff.value = (item.balanceDifferAmount ?? 0) / 1000;
        bettingDiff.value = (item.differAmount ?? 0) / 1000;

        // double total = 0;

        // levelReward.value = (item.levelReward ?? 0) / 1000;
        // isLevelReward.value = item.isLevelReward == 2; // 等于2为已领取
        // if (!isLevelReward.value) {
        //   total += levelReward.value;
        // }

        // weekReward.value = (item.weekReward ?? 0) / 1000;
        // isWeekReward.value = item.isWeekReward == 2; // 等于2为已领取
        // if (!isWeekReward.value) {
        //   total += weekReward.value;
        // }

        // monthReward.value = (item.monthReward ?? 0) / 1000;
        // isMonthReward.value = item.isMonthReward == 2; // 等于2为已领取
        // if (!isMonthReward.value) {
        //   total += monthReward.value;
        // }

        // totalReward.value = total;
      }
    }
  }

  // 获取vip晋级模式列表信息
  Future<void> _reqVipList() async {
    VipInfoBean? resData = await UserApi().reqVipList();
    if (resData != null) {
      vipListData.value = resData.data ?? [];

      dayHaveValue.value = vipListData.any((vipItem) => vipItem.dayReward! > 0);
      if (!dayHaveValue.value) {
        tabData.removeWhere((tabItem) => tabItem.title == '日俸禄');
      }

      weekHaveValue.value =
          vipListData.any((vipItem) => vipItem.weekReward! > 0);
      if (!weekHaveValue.value) {
        tabData.removeWhere((tabItem) => tabItem.title == '周俸禄');
      }

      monthHaveValue.value =
          vipListData.any((vipItem) => vipItem.monthReward! > 0);
      if (!monthHaveValue.value) {
        tabData.removeWhere((tabItem) => tabItem.title == '月俸禄');
      }

      bool chargeLower =
          vipListData.any((vipItem) => vipItem.relegationChargeLower! > 0);
      bool betLower =
          vipListData.any((vipItem) => vipItem.relegationBetLower! > 0);
      if (!chargeLower && !betLower) {
        tabData.removeWhere((tabItem) => tabItem.title == '保级要求');
      }
      bool brithdayLower =
          vipListData.any((vipItem) => vipItem.birthdayRedPacket! > 0);
      if (!brithdayLower) {
        tabData.removeWhere((tabItem) => tabItem.title == '生日红包');
      }
      tabController.dispose();
      tabController = TabController(length: tabData.length, vsync: this);
    }
  }

  // 获取vip晋级模式列表信息
  Future<void> _reqVipRuler() async {
    String? resData = await UserApi().reqVipRule();
    if (resData != null) {
      ruler.value = resData;
    }
  }

  Future<void> handleReceive() async {
    try {
      isReceiveLoading.value = true;
      bool isSuccess = await UserApi().reqReceiveVipReward();

      if (isSuccess) {
        await initData();

        await LoginManager.instance.reqMoney();
        EasyLoading.showSuccess('领取成功');
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }
}
