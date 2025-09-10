import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/url_utils.dart';
import '../../home/controllers/new_home_controller.dart';
import '../controllers/android_app_web_controller.dart';
import '../controllers/app_web_controller.dart';
import '../widget/common_dialog.dart';

///app内置网页
class AndroidAppWebView extends StatefulWidget {
  const AndroidAppWebView({super.key});

  @override
  State<AndroidAppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AndroidAppWebView> {
  late AndroidAppWebController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(AndroidAppWebController());
  }

  @override
  void dispose() {
    Get.delete<AndroidAppWebController>();
    super.dispose();
  }

  DateTime? _lastPressedAt; // 上次点击时间
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (_lastPressedAt == null ||
            now.difference(_lastPressedAt!) > const Duration(seconds: 1)) {
          _lastPressedAt = now;
          EasyLoading.showToast("连续返回两次即可呼出退出弹窗!");
          return false; // 阻止退出
        }
        // findMoney();
        // Get.back(result: 'back');
        showBackDialog();
        return false;
      },
      child: Scaffold(
        backgroundColor:
            controller.isShowGameBack ? Colors.black : Colors.white,
        appBar: controller.isShowTitle
            ? AppBar(
                backgroundColor: Colors.white,
                title: Text(controller.title),
                centerTitle: true,
                actions: _buildActions(),
              )
            : null,
        body: SafeArea(
          top: true,
          bottom: false,
          child: _buildBody(context),
        ),
      ),
    );
  }

  _buildActions() {
    return [
      Visibility(
        visible: controller.isShowRecharge,
        child: Padding(
          padding: EdgeInsets.only(right: 40.w),
          child: SizedBox(
            height: 100.h,
            child: ElevatedButton(
              onPressed: () {
                AppManager.instance.tapVibrate();
                Get.toNamed(Routes.RECHARGE);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.r), // 设置圆角半径
                ),
                backgroundColor: const Color(theme01MainColor),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                '充值',
                style: TextStyle(color: Color(colorFFFFFF)),
              ),
            ),
          ),
        ),
      )
    ];
  }

  _buildBody(context) {
    // 内嵌网页模式
    if (controller.appMode == AppModeEnum.webview) {
      return Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(controller.url),
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              transparentBackground: true,
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
              allowFileAccess: true,
              useHybridComposition: true, // 必须开启！
            ),
            onWebViewCreated: (controller) {
              this.controller.webViewController = controller;
              if (UrlUtils.isHtmlText(this.controller.url)) {
                controller.loadData(
                    data: this.controller.url,
                    mimeType: 'text/html',
                    encoding: 'utf-8');

                if (this.controller.isChangeHtmlFontSize) {
                  controller.addJavaScriptHandler(
                    handlerName: 'pageReady',
                    callback: (args) async {
                      await controller.evaluateJavascript(
                        source: "document.body.style.fontSize = '40px';",
                      );
                    },
                  );

                  controller.evaluateJavascript(source: """
            if (document.readyState === 'complete') {
              window.flutter_inappwebview.callHandler('pageReady');
            } else {
              window.addEventListener('load', function() {
                window.flutter_inappwebview.callHandler('pageReady');
              });
            }
          """);
                }
              } else {
                controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri(this.controller.url)));
              }
            },
            onPermissionRequest: (controller, request) async {
              return PermissionResponse(
                action: PermissionResponseAction.GRANT,
                resources: request.resources,
              );
            },
          ),
          Visibility(
            visible: controller.isShowGameBack,
            child: Obx(
              () => Positioned(
                top: controller.top.value,
                left: controller.left.value,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    controller.updatePosition(
                      details.delta.dx,
                      details.delta.dy,
                    );
                  },
                  // onPanEnd: (details) {
                  //   reloadWebView();
                  // },
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    showBackDialog();
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        Assets.theme1.images.home.iconGameBack.path,
                        width: 164.w,
                        height: 164.h,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // 本地图片模式
    if (controller.appMode == AppModeEnum.assetsImage) {
      return SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Image.asset(
            controller.url,
            fit: BoxFit.fitWidth,
          ),
        ),
      );
    }

    return const Placeholder();
  }

  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  void showBackDialog() {
    var isLand = isLandscape(context);
    Get.dialog(
      CommonDialog(
        title: "退出${controller.title}",
        clickOk: () {
          AppManager.instance.tapVibrate();
          Get.back(result: 'back');
          Get.back();
          findMoney();
        },
        isLandscape: isLand,
      ),
    ).then((value) {});
  }

  //找回余额
  void findMoney() {
    if (controller.playId > 0) {
      String playIds = '${controller.playId}';
      NewHomeController homeController = Get.find();
      homeController.waittingForBalance = true;
      // 延迟2秒调回收余额接口
      Future.delayed(
        const Duration(seconds: 2),
        () async {
          homeController.retrieveAndCheckBalance(
            false,
            playIds,
          );
        },
      );
    }
  }

  void reloadWebView() async {
    if (Platform.isIOS) {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      final version = iosInfo.systemVersion;
      // print('version: $version');
      bool needReload = false;
      final versionParts = version.split('.'); // 按点分割成 [major, minor, patch]
      final major = int.tryParse(versionParts[0]) ?? 0;
      final minor =
          int.tryParse(versionParts.length > 1 ? versionParts[1] : '0') ?? 0;
      final patch =
          int.tryParse(versionParts.length > 2 ? versionParts[2] : '0') ?? 0;
      if (major > 18) {
        needReload = true;
      }
      if (major == 18 && minor > 3) {
        needReload = true;
      }
      if (major == 18 && minor == 3 && patch > 0) {
        needReload = true;
      }

      if (needReload) {
        controller.webViewController.reload();
      }
    }
  }
}
