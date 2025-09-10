import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/app_bar/custom_app_bar.dart';
import '../controllers/cs_home_controller.dart';
import '../controllers/cs_webview_controller.dart';

class CsWebviewView extends GetView {
  CsWebviewView({Key? key}) : super(key: key);
  CsHomeController csHomeCtrl = Get.find<CsHomeController>();
  // CsWebViewController csWebViewCtrl = Get.find<CsWebViewController>();
  CsWebViewController csWebViewCtrl = Get.put<CsWebViewController>(CsWebViewController());
  @override
  Widget build(BuildContext context) {
    Get.find<GlobalStateController>().showOverlayView(isShowTopBarView:false,isShowBottomBarView:false);
    Get.lazyPut(() => CsHomeController());
    return Scaffold(
      backgroundColor: const Color(0xFF2F4452),
      body:
      Center(
        child: buildBody(context),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildWebView(context);
        } else {
          return _buildWebView(context);
        }
      },
    );
  }

  Widget _buildWebView(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).padding.top),
        Obx(() {
          return Visibility(
            visible: csWebViewCtrl.progress < 1,
            child: LinearProgressIndicator(
              minHeight: 2,
              backgroundColor: Colors.transparent,
              color: Colors.grey,
              value: csWebViewCtrl.progress.value,
            ),
          );
        }),
        Expanded(
          child:InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(csHomeCtrl.url)),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                transparentBackground: true, javaScriptEnabled: true,),
            ),
            onWebViewCreated: (controller) {
              controller.addJavaScriptHandler(handlerName: "delView", callback: (a) {
                RouteUtil.popView();
                RouteUtil.popView();
              });
            },
            onProgressChanged: (_controller, progress) {
              csWebViewCtrl.progress.value   = progress / 100;
            },
          ),
        ),
      ],
    );
  }
}
