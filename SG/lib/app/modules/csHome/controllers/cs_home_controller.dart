import 'package:flutter_bet/generated/l10n.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../pages/web_browser/logic.dart';
import '../../../../routes/routes.dart';
import '../../../../services/account_service.dart';
import '../../../../utils/url_launch_util.dart';

class CsHomeController extends GetxController with WidgetsBindingObserver{

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final List<String> avatarPaths = [
    'assets/images/cs/avatar/image_1.webp',
    'assets/images/cs/avatar/image_2.webp',
    'assets/images/cs/avatar/image_3.webp',
    'assets/images/cs/avatar/image_4.webp',
    'assets/images/cs/avatar/image_5.webp',
    'assets/images/cs/avatar/image_6.webp',
    'assets/images/cs/avatar/image_7.webp',
    'assets/images/cs/avatar/image_8.webp',
    'assets/images/cs/avatar/image_9.webp',
    'assets/images/cs/avatar/image_10.webp',
    'assets/images/cs/avatar/image_11.webp',
    'assets/images/cs/avatar/image_12.webp',
    'assets/images/cs/avatar/image_13.webp',
    'assets/images/cs/avatar/image_14.webp',
    'assets/images/cs/avatar/image_15.webp',
    'assets/images/cs/avatar/image_16.webp',
    'assets/images/cs/avatar/image_17.webp',
    'assets/images/cs/avatar/image_18.webp',
    'assets/images/cs/avatar/image_19.webp',
    'assets/images/cs/avatar/image_20.webp',
    'assets/images/cs/avatar/image_21.webp',
    'assets/images/cs/avatar/image_22.webp',
    'assets/images/cs/avatar/image_23.webp',
    'assets/images/cs/avatar/image_24.webp',
    'assets/images/cs/avatar/image_25.webp',
    'assets/images/cs/avatar/image_26.webp',
    'assets/images/cs/avatar/image_27.webp',
    'assets/images/cs/avatar/image_28.webp',
    'assets/images/cs/avatar/image_29.webp',
    'assets/images/cs/avatar/image_30.webp',
    'assets/images/cs/avatar/image_31.webp',
    'assets/images/cs/avatar/image_32.webp',
    'assets/images/cs/avatar/image_33.webp',
    'assets/images/cs/avatar/image_34.webp',
    'assets/images/cs/avatar/image_35.webp',
    'assets/images/cs/avatar/image_36.webp',
    'assets/images/cs/avatar/image_37.webp',
    'assets/images/cs/avatar/image_38.webp',
    'assets/images/cs/avatar/image_39.webp',
    'assets/images/cs/avatar/image_40.webp',
  ];

  final Set<int> selectedIndexes = {};
  String url = "" ;
  // final  progress =0.0.obs ;
  @override
  void onInit() {
    print('${AppUrlsValues.envConfig.asset_url}/${globalController.brandDetailPc?['pc']?['pc_logo_white']}');
    // https://d2utx4nptvgikt.cloudfront.net/brand/1716547703689.webp
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      // 应用程序处于非活动状态
        debugPrint(S.current.random_text_1294);
        break;
      case AppLifecycleState.paused:
      // 应用程序处于后台
        debugPrint(S.current.random_text_1295);
        break;
      case AppLifecycleState.resumed:
      // 应用程序处于前台并可交互
        debugPrint(S.current.random_text_1296);
        break;
      case AppLifecycleState.detached:
      // 应用程序没有关联的 Flutter 引擎
        debugPrint(S.current.random_text_1297);
        break;
      // case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
    super.didChangeAppLifecycleState(state);
  }

  String getRandomImagePath() {
    final random = Random();
    int index;
    do {
      index = random.nextInt(avatarPaths.length);
    } while (selectedIndexes.contains(index));
    selectedIndexes.add(index);
    return avatarPaths[index];
  }

  csEvent(){
    if (globalController.csUrl.isEmpty) {
      globalController.brandCS();
      return;
    }
    String un = AccountService.sharedInstance.currentUser?.username ?? "";
    if (un.isEmpty) {
      if (globalController.csUrl.value.contains("?")) {
        // UrlLaunchUtil.launchURL("${globalController.csUrl.value}&lang=${globalController.getLangSimpleString()}",
        //     mode: LaunchMode.platformDefault);
        url = "${globalController.csUrl.value}?lang=${globalController.getLangSimpleString()}" ;
        RouteUtil.pushToView(Routes.csWebView );

      }
      else {
        // UrlLaunchUtil.launchURL("${globalController.csUrl.value}?lang=${globalController.getLangSimpleString()}",
        //     mode: LaunchMode.platformDefault);
        url = "${globalController.csUrl.value}?lang=${globalController.getLangSimpleString()}";
        RouteUtil.pushToView(Routes.csWebView );

      }
    } else {
      if (globalController.csUrl.value.contains("?")) {
        // UrlLaunchUtil.launchURL(
        //     "${globalController.csUrl.value}&lang=${globalController.getLangSimpleString()}&username=$un&sign=${globalController.csSign}",
        //     mode: LaunchMode.platformDefault);
        url ="${globalController.csUrl.value}&lang=${globalController.getLangSimpleString()}&username=$un&sign=${globalController.csSign}";
        print(url);
        // RouteUtil.popView();
        // RouteUtil.pushToView(Routes.csWebView );
        // Future.delayed(Duration(seconds: 1), () {
          RouteUtil.pushToView(Routes.csWebView);
        // });
      } else {
        // UrlLaunchUtil.launchURL(
        //     "${globalController.csUrl.value}?lang=${globalController.getLangSimpleString()}&username=$un&sign=${globalController.csSign}",
        //     mode: LaunchMode.platformDefault);
        url =  "${globalController.csUrl.value}?lang=${globalController.getLangSimpleString()}&username=$un&sign=${globalController.csSign}" ;
        RouteUtil.pushToView(Routes.csWebView );
      }
    }
  }
}
