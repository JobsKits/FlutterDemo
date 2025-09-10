import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/api/tenant_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/data/tabs_bean.dart';
import 'package:flutter_tiyu_app/app/data/tenant_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/app/modules/home/views/new_home_view.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_collection_model/activity_collection_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/views/night_home_view.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_tiyu_app/utils/theme_utils.dart';
import 'package:get/get.dart';

import '../../../../api/login_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/network/error.dart';
import '../../../../kernel/network/service.dart';
import '../../../../kernel/utils/app_utils.dart';
import '../../../../theme/theme.service.dart';
import '../../../data/video_domain.dart';
import '../../../widget/keep_alive_wrapper.dart';
import '../../activity/views/activity_view.dart';
import '../../user/controllers/user_controller.dart';
import '../../user/views/user_view.dart';
import '../../video/views/video_view.dart';
import '../../wallet/data/recharge_type_bean.dart';
import '../../wallet/data/recharge_type_tab_bean.dart';
import '../../wallet/views/recharge_view.dart';

class TabsController extends GetxController {
  RxInt currentIndex = 0.obs;
  late PageController pageController;
  Timer? _timer;
  late UserController userController = Get.find();
  bool showVideo = false;
  RxBool bottomViewLoading = false.obs;
  RxList<TabsBean> defaultBottomItemList = [
    TabsBean(
      title: "home",
      inPath: 'assets/lottie/home_in.json',
      outPath: 'assets/lottie/home_out.json',
    ),
    TabsBean(
      title: "recharge",
      inPath: 'assets/lottie/recharge_in.json',
      outPath: 'assets/lottie/recharge_out.json',
    ),
    TabsBean(
      title: "events",
      inPath: 'assets/lottie/activity_in.json',
      outPath: 'assets/lottie/activity_out.json',
    ),
    TabsBean(
      title: "my",
      inPath: 'assets/lottie/mine_in.json',
      outPath: 'assets/lottie/mine_out.json',
    )
  ].obs;

  List<Widget> pageList = [
    // KeepAliveWrapper(child: NewHomeView()),
    KeepAliveWrapper(child: NightHomeView()),
    const KeepAliveWrapper(child: RechargeView()),
    const KeepAliveWrapper(child: ActivityView()),
    const KeepAliveWrapper(child: UserView())
  ];

  RxList<ActivityCollectionModel> collections = <ActivityCollectionModel>[].obs;
  bool isShowRechargeTips = false;
  @override
  void onInit() async {
    super.onInit();
    bottomViewLoading.value = true;
    pageController = PageController(initialPage: currentIndex.value);
    isShowRechargeTips = await SystemApi.getIsShowRechargeTips();
    if (LoginManager.instance.isLogin.value) {
      reqRechargeType();
    }
    var isOpenVideo = TenantManager.instance.tenantBean!.isOpenVideo;
    // print('isOpenVideo:${isOpenVideo}');
    if (isOpenVideo == 'true') {
      showVideo = true;
      defaultBottomItemList.insert(
        1,
        TabsBean(
          title: "video",
          inPath: 'assets/lottie/video_in.json',
          outPath: 'assets/lottie/video_out.json',
        ),
      );
      pageList.insert(
        1,
        const KeepAliveWrapper(child: VideoView()),
      );

      NetworkService.initVideoInfo(await getCurrentVideoDomain());
    }
    loadLottie();
    EasyLoading.instance
      ..backgroundColor = Get.context!.customTheme!.pageTwoBg
      ..textColor = Get.context!.theme.primaryColor
      ..indicatorColor = Get.context!.theme.primaryColor;
    ever(ThemeService.to.currentTheme, (theme) {
      EasyLoading.instance.backgroundColor =
          Get.context!.customTheme!.pageTwoBg;
      loadLottie();
    });
    bottomViewLoading.value = false;
    if (LoginManager.instance.isLogin.value) {
      //打开app发现已登录，直接开始轮询
      startPollingMsg();
      reqActivityCollections(receiveType: 99999);
    }

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        reqRechargeType();
        reqActivityCollections(receiveType: 99999);
      } else {
        unreadCount.value = 0;
        messageInstsCount.value = 0;
        collections.clear();
      }
    });
  }

  loadLottie() {
    for (var item in defaultBottomItemList) {
      item.inPath = ThemeUtils.getBottomBarLottieIn(item.title);
      item.outPath = ThemeUtils.getBottomBarLottieOut(item.title);
    }
    defaultBottomItemList.refresh();
  }

  RxString rechargeMax = "0".obs;
  reqRechargeType() async {
    if (!isShowRechargeTips) {
      return;
    }
    final res = await LoginApi.reqRechargeType();
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
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

              if ((double.tryParse(maxItem.maxPercentage ?? "0") ?? 0) >
                  double.parse(rechargeMax.value)) {
                rechargeMax.value = maxItem.maxPercentage ?? "";
              }
            }
          }
        }
      }
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  //切换底部tab
  void changePageIndex(int index) {
    currentIndex.value = index;
  }

  // 暴露方法用于手动页面跳转
  void jumpToPage(int index) {
    bool isNotLogin = !LoginManager.instance.isLogin.value;

    int rechargeIndex = 1; // 充值页面
    int activityIndex = 2; // 活动页面
    int userIndex = 3; // 我的页面

    if (showVideo) {
      rechargeIndex = 2;
      activityIndex = 3;
      userIndex = 4;
    }
    // 充值页面，需要先登录才进入
    if (index == rechargeIndex && isNotLogin) {
      showLoginDialog(callback: () {
        changePageIndex(index);
        pageController.jumpToPage(index);
      });
      return;
    }
    // 活动页面，需要先登录才进入
    if (index == activityIndex && isNotLogin) {
      // showLoginDialog(callback: () {
      //   changePageIndex(index);
      pageController.jumpToPage(index);
      // });
      return;
    }
    // 我的页面，需要先登录才进入
    // if (index == userIndex && isNotLogin) {
    //   showLoginDialog(callback: () {
    //     userController.loadAgentCenter();
    //     changePageIndex(index);
    //     pageController.jumpToPage(index);
    //   });
    //   return;
    // }

    changePageIndex(index);
    pageController.jumpToPage(index);
  }

  void startPollingMsg() {
    reqUnReadMsg();
    if (_timer == null || !_timer!.isActive) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        reqUnReadMsg();
      });
    }
  }

  void stopPollingMsg() {
    _timer?.cancel();
  }

  RxInt unreadCount = 0.obs;
  RxInt messageInstsCount = 0.obs;
  RxInt feedbackUnReadCount = 0.obs;
  //请求未读消息
  void reqUnReadMsg() async {
    //每次请求轮询之前，判断是否已退出登录，如果退出了，则终止轮询
    if (!LoginManager.instance.isLogin.value) {
      stopPollingMsg();
      return;
    }

    final res = await SystemApi.reqUnReadMsg();
    if (res.type == NetworkService.networkTypeSuccess) {
      unreadCount.value = res.data?['unreadCount'] ?? 0;
      messageInstsCount.value = res.data?['messageInstsCount'] ?? 0;
      feedbackUnReadCount.value = res.data?['feedbackCornerCount'] ?? 0;
      // print('输出: ${res.data}');
    } else {
      if (res.data is NetworkError) {
        NetworkError error = res.data;
        error.log();
        if (error.logout) {
          Get.snackbar("登录已过期！", "请重新登录");
          if (currentIndex.value == 4 || currentIndex.value == 2) {
            jumpToPage(0); //登录过期，跳转到首页
          }
          // //退出登录，清空现有的登录信息
          LoginManager.instance.clear();
        }
      }
    }
  }

  //获取当前视频域名
  Future<String> getCurrentVideoDomain() async {
    int cmdId = 373133;
    var data = {
      'tid': AppConfigs.tid,
      // 1聊天线路 8视频线路 9阿里云存储线路 10AWS云存储
      'domain_type': '8', // 支持一次请求多种 比如1,8
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 1,
    );
    if (res.data is List) {
      List<VideoDomain> list = [];
      for (var item in res.data) {
        list.add(VideoDomain.fromJson(item));
      }
      String videoUrl = await reqVideosUrl(list);
      return videoUrl;
    }
    return "";
  }

  Future<void> reqActivityCollections({int receiveType = 0}) async {
    if (LoginManager.instance.isLogin.value == false) {
      return;
    }
    EasyLoading.show(indicator: const CommonLoadingView());
    try {
      final response =
          await ActivityApi.reqCollectionList(receiveType: receiveType);
      if (response.type == NetworkService.networkTypeSuccess) {
        collections.assignAll((response.data as List)
            .map((item) => ActivityCollectionModel.fromJson(item))
            .toList());
      }
    } finally {
      EasyLoading.dismiss();
    }
  }

  bool shouldShowRedDot(int index) {
    // 判断某个 tab 是否需要显示红点
    return defaultBottomItemList[index].title == 'my'; // 示例：只有第一个 tab 显示红点
  }

  bool shouldShowRedDot2(int index) {
    // 判断某个 tab 是否需要显示红点
    return defaultBottomItemList[index].title ==
        'recharge'; // 示例：只有第一个 tab 显示红点
  }
}
