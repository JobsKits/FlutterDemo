import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/video_api.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_category_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_home_bean.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_home_tab_bean.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:get/get.dart';

import '../../home/controllers/new_home_controller.dart';
import '../data/video_category_bean.dart';

class VideoController extends GetxController with GetTickerProviderStateMixin {
  late NewHomeController homeController;
  late TabsController tabsController = Get.find();
  // late HomeController homeController = Get.find();
  late TabController tabController;
  late ScrollController scrollController;
  final count = 0.obs;
  RxList<VideoHomeTabBean> tabList = <VideoHomeTabBean>[].obs;
  RxList<VideoHomeBean> homeList = <VideoHomeBean>[].obs;
  RxList<VideoSecondList> secondList = <VideoSecondList>[].obs;
  RxList<VideoCategoryBean> categoryList = <VideoCategoryBean>[].obs; //分类数据
  // late List<GlobalKey> homeListKeys;
  GlobalKey tabBarKey = GlobalKey(); //tab的key
  GlobalKey titleKey = GlobalKey(); //标题栏的key
  List<double> widgetPositions = []; //首页列表组件的初始位置的集合
  RxInt currentTabIndex = 0.obs; //当前tab的index，0为首页
  int currentCategoryPage = 1; //当前分类的页数
  RxBool isRequestBlack = false.obs; //是否正在请求黑料
  RxBool isShowScrollTopButton = false.obs; //是否显示滚动到顶部的按钮游戏列表假数据

  @override
  void onInit() async {
    super.onInit();
    homeController = Get.find();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (tabList[currentTabIndex.value].id! == 130) {
        //是黑料，才需要加载更多
        if (scrollController.position.pixels ==
                scrollController.position.maxScrollExtent &&
            !isRequestBlack.value) {
          loadMoreBlackVideoList();
        }
      }
      isShowScrollTopButton.value = scrollController.position.pixels > 1000.h;
    });
    tabController = TabController(length: 0, vsync: this);
    reqTabData();
  }

  //滚动到顶部
  void scrollTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  Future<void> reqTabData() async {
    EasyLoading.show(indicator: CommonLoadingView());
    currentCategoryPage = 1;
    currentTabIndex.value = 0;
    tabList.value = await VideoApi.reqTabData();
    tabController.dispose();
    tabController = TabController(length: tabList.length, vsync: this);
    homeList.value = await VideoApi.reqVideoHomeData();
    categoryList.value = await VideoApi.reqVideoCategoryList();
    // homeListKeys = List.generate(
    //     homeList.length, (_) => GlobalKey()); //根据首页tab的数量，创建对应的key

    // getWidgetPosition(); //拿到每个列表的位置
    EasyLoading.dismiss();
  }
  // getWidgetPosition() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     widgetPositions.clear();
  //     var titleHeight =
  //         (titleKey.currentContext!.findRenderObject() as RenderBox)
  //             .localToGlobal(Offset.zero)
  //             .dy;
  //     var tabBarHeight =
  //         (tabBarKey.currentContext!.findRenderObject() as RenderBox)
  //             .localToGlobal(Offset.zero)
  //             .dy;
  //     for (var i = 0; i < homeListKeys.length; i++) {
  //       if (i == 0) {
  //         widgetPositions.add(0); //第一个，直接滚动到顶部
  //       } else {
  //         //其他的滚动位置需要加上tabbar和标题栏的高度
  //         final RenderBox renderBox =
  //             homeListKeys[i].currentContext!.findRenderObject() as RenderBox;
  //         final position = renderBox.localToGlobal(Offset.zero).dy;
  //         widgetPositions.add(position -
  //             titleHeight -
  //             tabBarHeight -
  //             ScreenUtil().statusBarHeight);
  //       }
  //     }
  //   });
  // }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void increment() => count.value++;

  //切换了tab，滚动到指定列表处
  void tabChange(int index) async {
    scrollController.jumpTo(0);
    currentTabIndex.value = index;
    currentCategoryPage = 1; //切换tab后置为1
    if (index == 0) {
      //首页请求其他接口
      await reqTabData();
    } else if (tabList[currentTabIndex.value].id == 130) {
      await reqBlackVideoList();
    } else {
      EasyLoading.show(indicator: CommonLoadingView());

      secondList.value = await VideoApi.reqVideoList(
          id: tabList[index].id!, type: tabList[index].type!);
      EasyLoading.dismiss();
    }
    // scrollController.animateTo(widgetPositions[index],
    //     duration: Duration(milliseconds: 500), curve: Curves.linear);
  }

  void refreshTabList() async {
    currentCategoryPage += 1;
    EasyLoading.show(indicator: CommonLoadingView());
    secondList.value = await VideoApi.reqVideoList(
        id: tabList[currentTabIndex.value].id!,
        type: tabList[currentTabIndex.value].type!,
        page: currentCategoryPage);
    EasyLoading.dismiss();
  }

  void goCategoryDetailView(int index) {
    Get.toNamed(Routes.VIDEO_CATEGORY, arguments: {
      "id": categoryList[index].id,
      "type": "cate",
      "title": categoryList[index].classify,
    });
    Get.delete<VideoCategoryController>();
  }

  void goCategoryMoreDetailView(
      {required int id, required String type, required String title}) {
    Get.toNamed(Routes.VIDEO_CATEGORY, arguments: {
      // "id": tabList[currentTabIndex.value].id,
      "id": id,
      // "type": tabList[currentTabIndex.value].type,
      "type": type,
      "title": title,
      // "title": tabList[currentTabIndex.value].name,
    });
  }

  //请求黑料视频列表
  Future<void> reqBlackVideoList() async {
    currentPage = 1;
    EasyLoading.show(indicator: CommonLoadingView());
    secondList.value = await VideoApi.reqVideoList(
        id: tabList[currentTabIndex.value].id!,
        type: tabList[currentTabIndex.value].type!,
        isBlack: true,
        pageSize: 10,
        page: currentPage);
    hasMore = secondList.length == 10; //如果长度等于10，表示刚好请求到足够的数据，所以可以进行下一页的请求
    EasyLoading.dismiss();
  }

  bool hasMore = false; //是否还有必要加载更多
  int currentPage = 1;
  void loadMoreBlackVideoList() async {
    if (hasMore) {
      currentPage += 1;
      List<VideoSecondList> tempList = [];
      try {
        isRequestBlack.value = true;
        tempList = await VideoApi.reqVideoList(
            id: tabList[currentTabIndex.value].id!,
            type: tabList[currentTabIndex.value].type!,
            isBlack: true,
            pageSize: 10,
            page: currentPage);

        secondList.addAll(tempList);
      } finally {
        isRequestBlack.value = false;
      }
      hasMore = tempList.length == 10;
    }
  }
}
