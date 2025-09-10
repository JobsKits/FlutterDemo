import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'logic.dart';

class WebBrowserPage extends BaseView<WebBrowserLogic> {
  WebBrowserPage({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    // TODO: implement appBar
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    // TODO: implement body
    return Scaffold(
      appBar: MediaQuery.of(context).orientation == Orientation.portrait
          ? CustomAppBar(
              appBarTitleText: controller.detail.title,
            )
          : null,
      backgroundColor: Colors.transparent,
      body: Center(
        child: buildBody1(),
      ),
    );
  }

  Widget _buildWebView() {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        controller.detail.link.startsWith("<!doctype html>")
            ? WebViewWidget(
                controller: controller.webViewController,
                // initialUrl: controller.detail.link,
                // javascriptMode: JavascriptMode.unrestricted,
                // onProgress: (pro) {
                //   controller.progress.value = (pro / 100).toDouble();
                // },
              )
            : InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(controller.detail.link)),
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    transparentBackground: true,
                    javaScriptEnabled: true,
                  ),
                ),
                onWebViewCreated: (controller) {
                  controller.addJavaScriptHandler(
                      handlerName: "handlerCallbacks",
                      callback: (a) {
                        print("---h5点击事件回调=$a");
                        RouteUtil.pushToView(Routes.yulechengGongPingXingPage);
                      });
                },
                onProgressChanged: (_controller, progress) {
                  controller.progress.value = (progress / 100).toDouble();
                },
              ),
        Obx(() => Visibility(
              visible: controller.progress < 1,
              child: LinearProgressIndicator(
                minHeight: 2,
                backgroundColor: Colors.transparent,
                color: ThemeService().theme.primaryColor,
                value: controller.progress.value,
              ),
            )),
      ],
    );
  }

  Widget buildBody1() {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildWebView().paddingBottom(AppValues.barBottomHeight);
        } else {
          return _buildWebView();
        }
      },
    );
  }
}
