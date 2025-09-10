import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CsWebViewController extends GetxController with WidgetsBindingObserver{
  final progress = 0.0.obs ;
  // String url = "" ;
  @override
  void onInit() {
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
}