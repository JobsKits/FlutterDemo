import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/widget_util.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  // TODO: implement priority
  int? get priority => 2;

  @override
  RouteSettings? redirect(String? route) {
    // TODO: implement redirect
    debugPrint('=======AuthMiddleware.redirect:$route');
    return super.redirect(route);
  }

  @override
  GetPage? onPageCalled(GetPage? page) {
    debugPrint('=======AuthMiddleware.onPageCalled:$page');
    final account = AccountService.sharedInstance.currentUser;
    if (account == null) {
      debugPrint('${Get.rawRoute} must be login');
      AccountService.sharedInstance.pushToLoginPage(WidgetUtil.getCurrentContext()!);
      return null;
    }
    return super.onPageCalled(page);
  }
}
