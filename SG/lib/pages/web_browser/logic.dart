import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebEntity {
  /// 标题
  String title = '';

  /// 链接
  String link = '';

  WebEntity({this.title = '', this.link = ''});
}

class WebBrowserLogic extends BaseController {
  late WebViewController webViewController;

  ///加载URL
  WebEntity detail = Get.arguments["detail"];

  ///进度条
  var progress = 0.0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    globalController.backToMain.value = true;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webViewController = WebViewController.fromPlatformCreationParams(params);
    webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(onProgress: (int pro) {
        progress.value = (pro / 100.0).toDouble();
      }))
      ..addJavaScriptChannel("handlerCallbacks", onMessageReceived: (JavaScriptMessage message) {
        print('h5点击事件回调 Received message: ${message.message}');
        // 这里可以处理从JavaScript传递过来的消息
      });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    if (detail.link.startsWith("<!doctype html>")) {
      print("detail.link.${detail.link}");
      webViewController.loadHtmlString(detail.link);
    } else {
      // final uri = Uri.parse(detail.link);
      // print("detail.link.${detail.link}");

      // webViewController.loadRequest(uri);
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}
