import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

import '../../../base/getx/base_controller.dart';

class YulechengGongPingXingController extends BaseController with GetTickerProviderStateMixin {
  YulechengGongPingXingController();
  BuildContext? context;
  List<Tab> tabsNoIcons = [
    const Tab(text: "概述"),
    const Tab(text: "实施"),
    const Tab(text: "转换"),
    const Tab(text: "游戏事件"),
    const Tab(text: "取消服务器种子散列"),
    const Tab(text: "计算"),
  ];
  // tab 控制器
  late TabController tabController;
  // tab 控制器
  int tabIndex = 0;
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabsNoIcons.length, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      tabIndex = tabController.index;

      update(['yulecheng_gongpingxing']);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
