import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/webview/controllers/web_page_controller.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebPageView extends GetView<WebPageController> {
  const WebPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.webViewController.canGoBack()) {
          controller.webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: WebViewWidget(controller: controller.webViewController),
        ),
      ),
    );
  }
}
