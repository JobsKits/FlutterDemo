import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

// 代理中心 加载web页面
class AgentCenterWebController extends GetxController {
  late WebViewController webViewController;
  late TabsController tabsController;

  @override
  void onInit() {
    super.onInit();
    tabsController = Get.find<TabsController>();
    final arguments = Get.arguments as Map<String, dynamic>;
    webViewController = arguments['webViewController'];
  }

  @override
  void onClose() {
    // print('WebPageController onClose');
    super.onClose();
  }

  void backToIndex(int index) {
    Get.back();
    tabsController.jumpToPage(index);
  }
}
