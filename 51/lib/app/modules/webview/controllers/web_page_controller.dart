import 'dart:convert';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageController extends GetxController {
  late WebViewController webViewController;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    webViewController = arguments['webViewController'];
  }

  @override
  void onClose() {
    // print('WebPageController onClose');
    super.onClose();
  }
}
