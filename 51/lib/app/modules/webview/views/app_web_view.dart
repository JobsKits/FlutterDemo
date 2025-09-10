import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../home/controllers/new_home_controller.dart';
import '../controllers/app_web_controller.dart';
import '../widget/common_dialog.dart';

///app内置网页
class AppWebView extends StatefulWidget {
  const AppWebView({super.key});

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late AppWebController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(AppWebController());
  }

  @override
  void dispose() {
    Get.delete<AppWebController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isShowGameBack) {
          return false;
        }
        return true;
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
                backgroundColor: context.theme.primaryColor,
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
          WebViewWidget(controller: controller.webViewController),
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
        },
        isLandscape: isLand,
      ),
    ).then((value) {});
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
