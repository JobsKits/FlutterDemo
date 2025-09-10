import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/custom.webview.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HalfScreenController extends GetxController {
  static OverlayEntry? _overlayEntry;
  static bool _isOverlayVisible = false;
  static late WebViewController _webViewController; // WebViewController 实例
  static RxDouble currentProgress = 0.0.obs;

  /// 初始化 WebViewController
  static void _initializeWebViewController(String url) {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..getUserAgent().then((String? userAgent) {
        _webViewController.setUserAgent('FlutterApp $userAgent');
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // 可以使用进度控制逻辑，例如显示加载进度条
            print("Loading progress: $progress%");

            currentProgress.value = progress / 100;
          },
          onPageStarted: (String url) async {
            await _webViewController.runJavaScript('''
              (function() {
                if ('serviceWorker' in navigator) {
                  navigator.serviceWorker.register('/cacheServiceWorker.js');
                }
              })();
            ''');
          },
          onPageFinished: (String url) async {
            print("Page loading finished: $url");
            var isCached =
                await _webViewController.runJavaScriptReturningResult('''
              caches.has('$url')
            ''');
            print("Is page cached: $isCached");
          },
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(Uri.parse(url), headers: {
        'Cache-Control': 'public, max-age=604800',
      })
      ..setBackgroundColor(Colors.transparent);
  }

  /// 创建 OverlayEntry
  static OverlayEntry _createOverlayEntry(VoidCallback? onClose) {
    final loginInfo = LoginManager.instance.loginInfo;
    NetworkService ns = NetworkService();
    final baseUrl =
        '${ns.baseURL}/jumph5?appVersion=1&play_cat=1&play_name=K31FCT3&play_id=237&chat_room=1&sub_play_id=237000&play_id=237&cust_id=${loginInfo?.custId ?? ''}&token=${loginInfo?.accessToken ?? ''}&type=7';

    _initializeWebViewController(baseUrl); // 初始化 WebViewController

    return OverlayEntry(
      builder: (context) => Positioned(
        top: Get.height - (Get.height / 1.625),
        left: 0,
        right: 0,
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            height: Get.height - (Get.height / 1.625),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF10C8E3),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Spacer(),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              "一分快三",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(width: 5),
                            Image.asset(
                              Assets.theme1.images.lottery.lotteryTipsSubtract
                                  .path,
                              fit: BoxFit.cover,
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          AppManager.instance.tapVibrate();
                          hideHalfScreenImage();
                          if (onClose != null) onClose();
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Obx(
                  () => Expanded(
                      child: Stack(
                    children: [
                      WebViewWidget(controller: _webViewController),
                      if (currentProgress < 1) ...[
                        const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      ]
                    ],
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 显示半屏图片
  static void showHalfScreenImage({VoidCallback? onClose}) {
    if (!LoginManager.instance.isLogin.value) {
      showLoginDialog();
      EasyLoading.showToast('亲，请先登录哦');
      return;
    }

    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry(onClose);
    }

    if (!_isOverlayVisible) {
      Overlay.of(Get.context!).insert(_overlayEntry!);
      _isOverlayVisible = true;
    }
  }

  /// 隐藏半屏图片
  static void hideHalfScreenImage() {
    if (_isOverlayVisible && _overlayEntry != null) {
      _overlayEntry!.remove();
      _isOverlayVisible = false;
    }
  }
}
