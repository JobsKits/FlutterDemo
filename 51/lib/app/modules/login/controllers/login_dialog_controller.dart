import 'package:flutter/material.dart';
import 'package:get/get.dart';

///登录弹窗的Controller
class LoginDialogController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentPageIndex = 0.obs;
  RxBool isSelectLogin = true.obs;
  PageController pageController = PageController(initialPage: 0);

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
  }

  //切换弹窗内部页面
  void changePage(index) {
    currentPageIndex.value = index;
    isSelectLogin.value = index == 0;
  }
}
