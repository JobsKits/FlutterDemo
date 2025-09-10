import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/url_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RechargeWebController extends GetxController {
  late InAppWebViewController webViewController;

  late final String url;
  late String title = '';
  late String availableCredits = ''; //可用额度
  late String desc = ''; //描述

  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url'] ?? '';
    title = arguments['title'] ?? '';
    availableCredits = arguments['availableCredits'] ?? '';
    desc = arguments['desc'] ?? '';
    // webViewController = WebViewController()
    //   ..setJavaScriptMode(JavaScriptMode.unrestricted)
    //   ..setBackgroundColor(const Color(0x00000000))
    //   ..loadRequest(Uri.parse(url));
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
