import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/url_utils.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

// 模式
enum AppModeEnum {
  webview,
  assetsImage,
}

class AppWebController extends GetxController {
  late WebViewController webViewController;

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

      webViewController = WebViewController.fromPlatformCreationParams(params)
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(const Color(0x00000000));
      // ..loadRequest(Uri.parse(url));
      if (UrlUtils.isHtmlText(url)) {
        webViewController.loadHtmlString(url);
        if (isChangeHtmlFontSize) {
          //更改html标签的字体大小和背景颜色，目前仅用于帮助中心
          webViewController
              .setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
            webViewController
                .runJavaScript("""document.body.style.fontSize = '40px'; """);
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
    super.onClose();
    // 返回竖屏模式
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // 恢复状态栏
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    webViewController.clearCache();
    // 停止正在加载的内容
    webViewController.loadRequest(Uri.parse('about:blank'));
  }

  void updatePosition(double deltaX, double deltaY) {
    top.value += deltaY;
    left.value += deltaX;
  }
}
