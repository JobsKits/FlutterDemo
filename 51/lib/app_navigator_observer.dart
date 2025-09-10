import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';

class AppNavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // 监听返回事件
    // print("页面返回了: ${route.settings.name}");
    if (route.settings.name != null && route.settings.name!.isNotEmpty) {
      AppManager.instance.tapVibrate();
    }
  }
}
