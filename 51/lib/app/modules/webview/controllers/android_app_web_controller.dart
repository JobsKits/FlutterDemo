import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/url_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import 'app_web_controller.dart';

class AndroidAppWebController extends GetxController {
  late InAppWebViewController webViewController;

  late String url;
  bool isShowTitle = true;
  bool isShowRecharge = false;
  bool isShowGameBack = false;
  bool isChangeHtmlFontSize = false;
  AppModeEnum appMode = AppModeEnum.webview;
  late String title = '';
  int playId = 0;
  RxDouble top = 0.0.obs;
  RxDouble left = 0.0.obs;
  RxBool fullscreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    url = arguments['url'] ?? '';
    isShowTitle = arguments['isShowTitle'] ?? true;
    isShowRecharge = arguments['isShowRecharge'] ?? false;
    isShowGameBack = arguments['isShowGameBack'] ?? false;
    isChangeHtmlFontSize = arguments['isChangeHtmlFontSize'] ?? false;
    appMode = arguments['appMode'] ?? AppModeEnum.webview;
    title = arguments['title'] ?? '';
    playId = arguments['playId'] ?? 0;

    if (isShowGameBack) {
      // 进入游戏，允许横屏
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      // 隐藏状态栏
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

      top.value = 120.h;
      left.value = 40.w;
    }

    if (appMode == AppModeEnum.webview) {
      late final PlatformWebViewControllerCreationParams params;
      if (WebViewPlatform.instance is WebKitWebViewPlatform) {
        params = WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true,
          mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
        );
      } else {
        params = const PlatformWebViewControllerCreationParams();
      }
    }
  }

  @override
  void onClose() {
    // 返回竖屏模式
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // 恢复状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
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

  void updatePosition(double deltaX, double deltaY) {
    top.value += deltaY;
    left.value += deltaX;
  }
}
