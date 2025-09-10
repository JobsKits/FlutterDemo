import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/controllers/new_home_controller.dart';
import '../controllers/app_web_controller.dart';
import '../controllers/app_web_controller_for_inappwebview.dart';
import '../widget/common_dialog.dart';

///app内置网页 - 改用inappWebView三方库，支持图片上传，暂时不全局替换原来的webview
class AppWebViewForInAppWebView extends StatefulWidget {
  const AppWebViewForInAppWebView({super.key});

  @override
  State<AppWebViewForInAppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebViewForInAppWebView> {
  late AppWebControllerForInAppWebView controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(AppWebControllerForInAppWebView());
  }

  @override
  void dispose() {
    Get.delete<AppWebControllerForInAppWebView>();
    super.dispose();
  }

  double _progress = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          controller.title,
          style: TextStyle(color: context.customTheme?.appbarText),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(controller.url),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                mediaPlaybackRequiresUserGesture: false,
                allowsInlineMediaPlayback: true,
                allowFileAccess: true,
                useHybridComposition: true, // 必须开启！
              ),
              onWebViewCreated: (controller) {
                this.controller.webViewController = controller;
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  _progress = progress / 100;
                });
              },
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  action: PermissionResponseAction.GRANT,
                  resources: request.resources,
                );
              },
            ),
            if (_progress < 1.0)
              Center(
                child: SizedBox(
                  width: 126.w,
                  height: 126.h,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballSpinFadeLoader,
                    colors: [context.theme.primaryColor],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
