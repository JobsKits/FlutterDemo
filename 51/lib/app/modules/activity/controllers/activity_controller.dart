import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_record_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_activity_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_rebate_new_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_sign_in_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/collection/activity_collection_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/record/activity_record_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/vip_home_view.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_tiyu_app/app/modules/user/views/vip/vip_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_page_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_page_view.dart';
import "package:flutter_tiyu_app/app/modules/activity/views/sign_in/sign_in_page_view.dart";
import "package:flutter_tiyu_app/app/modules/activity/views/rebate_new/rebate_view.dart";
import "package:flutter_tiyu_app/app/modules/activity/views/yuebao/yuebao_view.dart";
import "package:flutter_tiyu_app/app/modules/activity/views/vip/vip_view.dart";

class ActivityBaseBean {
  ActivityBaseBean({
    required this.child,
    required this.title,
    required this.show,
  });

  final String title;
  final Widget child;
  final bool show;
}

class ActivityController extends GetxController
    with GetTickerProviderStateMixin {
  RxInt currentTabIndex = 0.obs;

  late PageController pageController;
  // 活动数据
  late RxList<ActivityBaseBean> activityData = <ActivityBaseBean>[].obs;
  late TabController tabController;
  final ActivitysComponentController acController = Get.find();
  final NewHomeController homeController = Get.find();
  late TabsController tabsController = Get.find();
  RxInt taskTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 0, vsync: this);

    _initData(displaySign: acController.signInData.value.hasVipConfig == 1);
    
    ever(ActivityManager.instance.activeConfigurationObs, (value) {
      if (value.isNotEmpty) {
        currentTabIndex.value = 0;
        _initData(displaySign: acController.signInData.value.hasVipConfig == 1);
        jumpToPage(currentTabIndex.value);
      }
    });

    ever(tabsController.currentIndex, (value) async {
      int idx = homeController.tabsController.defaultBottomItemList
          .indexWhere((e) => e.title == 'events');
      if (idx == value) {
        currentTabIndex.value = 0;
        _initData(displaySign: acController.signInData.value.hasVipConfig == 1);
        jumpToPage(currentTabIndex.value);
      }
    });
  }

  bool checkAuth(String key) {
    // 活动配置
    ActivityConfigurationInt activeConfiguration =
        ActivityManager.instance.activeConfiguration;
    if (activeConfiguration.isEmpty) {
      return false;
    }

    return activeConfiguration[key] == null
        ? false
        : activeConfiguration[key]! > 0;
  }

  void _initData({bool displaySign = false}) {
    // Create new list of tabs
    List<ActivityBaseBean> baseData = [
      ActivityBaseBean(
        title: '活动',
        child: const ActivityPageView(),
        show: true,
      ),
      ActivityBaseBean(
        title: '任务',
        child: const TaskPageView(),
        show: true,
      ),
      ActivityBaseBean(
        title: 'VIP',
        child: ThemeService.to.currentTheme.value?.model == 'blackGold'
            ? const VipHomeView(isShowTitle: false)
            : const VipView(isShowTitle: false),
        show: checkAuth('84'),
      ),
      ActivityBaseBean(
        title: '利息宝',
        child: const YuebaoView(),
        show: checkAuth('1'),
      ),
      ActivityBaseBean(
        title: '返水',
        child: const RebateView(),
        show: checkAuth('20'),
      ),
    ].where((ele) => ele.show).toList();

    if (displaySign) {
      baseData.add(ActivityBaseBean(
        title: '签到',
        child: const SignInPageView(),
        show: true,
      ));
    }

    // Update the tab controller
    final newLength = baseData.length;
    if (tabController.length != newLength) {
      tabController.dispose();
      tabController = TabController(length: newLength, vsync: this);
      
      // Sync the controllers if needed
      tabController.addListener(() {
        if (tabController.indexIsChanging) {
          currentTabIndex.value = tabController.index;
          pageController.jumpToPage(tabController.index);
        }
      });
    }

    activityData.value = baseData;
  }

  void jumpToPage(int index) {
    if (index >= activityData.length) return;
    
    ActivityBaseBean bean = activityData[index];
    
    // Lazy load data for each page type
    if (bean.title == '活动') {
      ControllerActivityPage controller = Get.find();
      if (controller.tabList.isEmpty) {
        controller.requestActivityData();
      }
    } else if (bean.title == '任务') {
      ControllerTaskPage controller = Get.find();
      if (controller.tabList.isEmpty) {
        controller.requestActivityData();
      }
    } else if (bean.title == '返水') {
      ControllerRebatePage controller = Get.find();
      if (controller.reabteData.value.cust_id == null) {
        controller.initData();
      }
    } else if (bean.title == '签到') {
      ControllerSignInPage controller = Get.find();
      if (controller.signInRewardList.isEmpty) {
        controller.reqSignInData();
      }
    }
    
    currentTabIndex.value = index;
    tabController.animateTo(index);
    pageController.jumpToPage(index);
    taskTabIndex.value = 0;
  }

  bool shouldShowRedDot(int index) {
    return activityData[index].title == '待领取'; // 示例：根据是否有未读消息显示红点
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }
}
