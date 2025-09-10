import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageNotifyController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> tabList = [
    "我的消息",
    "通知公告",
  ];
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabList.length, vsync: this);
  }
}
