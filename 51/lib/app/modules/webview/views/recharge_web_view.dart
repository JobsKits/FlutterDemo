import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/webview/controllers/recharge_web_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/app_web_controller.dart';
import '../widget/common_dialog.dart';

//充值用的网页
class RechargeWebView extends GetView<RechargeWebController> {
  const RechargeWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(controller.title),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context) {
    return Column(
      children: [
        _buildAppBar(context),
        // Expanded(
        //     child: SafeArea(
        //   top: false,
        //   bottom: true,
        //   child: WebViewWidget(
        //     controller: controller.webViewController,
        //   ),
        // ))
        Expanded(
            child: SafeArea(
                top: false,
                bottom: true,
                child: InAppWebView(
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
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                      action: PermissionResponseAction.GRANT,
                      resources: request.resources,
                    );
                  },
                )))
      ],
    );
  }

  Widget _buildAppBar(context) {
    return Container(
        padding:
            EdgeInsets.only(top: 15.h, bottom: 15.h, left: 30.w, right: 30.w),
        color: Color(0xfff0fdff),
        child: Row(
          children: [
            Image.asset(
              Assets.theme1.images.recharge.icons.recharge1.path,
              width: 80.w,
              height: 80.h,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    RichText(
                      text: TextSpan(
                          text: "可用额度：",
                          children: [
                            TextSpan(
                                text: "${controller.availableCredits}",
                                style: TextStyle(color: Colors.red))
                          ],
                          style:
                              TextStyle(fontSize: 48.sp, color: Colors.black)),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w), // 添加与 Row 内部间距一致的左边距
                  child: HtmlWidget(
                    "${controller.desc}",
                    textStyle: TextStyle(fontSize: 32.sp),
                  ),
                ),
                // HtmlWidget("${controller.desc}", textStyle: TextStyle(fontSize: 32.sp),)
                // Text("${controller.desc}",maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 42.sp,color: Color(color4B4B4B)),)
              ],
            ),
          ],
        ));
  }
}
