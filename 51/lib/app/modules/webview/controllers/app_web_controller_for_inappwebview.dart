import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/url_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'app_web_controller.dart';

///app内置网页 - 改用inappWebView三方库，支持图片上传，暂时不全局替换原来的webview
class AppWebControllerForInAppWebView extends GetxController {
  late InAppWebViewController webViewController;

  late String url;
  late String title = '';

  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url'] ?? '';
    title = arguments['title'] ?? '';
  }

  @override
  void onClose() {
    cleanWebView();
    super.onClose();
  }

  Future<void> cleanWebView() async {
    try {
      // 1. 停止任何加载中的内容
      await webViewController.stopLoading();

      // 2. 加载 about:blank 清空页面内容
      await webViewController.loadUrl(
        urlRequest: URLRequest(url: WebUri("about:blank")),
      );

      // 3. 清除缓存（静态方法）
      await InAppWebViewController.clearAllCache();

      // 4. 可选：清除本地存储、cookies 等
      await CookieManager.instance().deleteAllCookies();
    } catch (e) {
      debugPrint('清理 WebView 异常: $e');
    }
  }
}
