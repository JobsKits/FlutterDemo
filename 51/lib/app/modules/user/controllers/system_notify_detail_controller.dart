import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/url_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../webview/controllers/app_web_controller.dart';

class SystemNotifyDetailController extends GetxController {
  late WebViewController webViewController;
  late ScrollController scrollController; //首页滚动Controller

  late final String url;
  bool isChangeHtmlFontSize = false;
  AppModeEnum appMode = AppModeEnum.webview;
  late String title = '';
  late String time = '';
  RxBool isImage = false.obs;
  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url'] ?? '';
    print("url:${url}");
    isChangeHtmlFontSize = arguments['isChangeHtmlFontSize'] ?? false;
    appMode = arguments['appMode'] ?? AppModeEnum.webview;
    title = arguments['title'] ?? '';
    time = arguments['time'] ?? '';
    scrollController = ScrollController();
    if (isImageUrl(url)) {
      isImage.value = true;
    }
    if (appMode == AppModeEnum.webview) {
      webViewController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000));
      // ..loadRequest(Uri.parse(url));
      if (UrlUtils.isHtmlText(url)) {
        webViewController.loadHtmlString(url);
        if (isChangeHtmlFontSize) {
          //更改html标签的字体大小和背景颜色，目前仅用于帮助中心
          webViewController
              .setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
            webViewController.runJavaScript(
                """document.body.style.fontSize = '40px'; document.body.style.color = "${ThemeService.to.currentTheme.value?.model == 'blackGold' ? '#fff' : '#000'}";""");
          }));
        }
      } else {
        webViewController.loadRequest(Uri.parse(url));
      }
    } else {
      webViewController = WebViewController();
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    webViewController.clearCache();
    super.onClose();
  }

  bool isImageUrl(String url) {
    final RegExp imagePattern =
        RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp|svg)$', caseSensitive: false);
    return imagePattern.hasMatch(url);
  }
}
