import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';
import 'view.dart';
import 'controller.dart';

const kCustomOffersWidget = 'CustomOffersWidget';

class OffersBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OffersController>(() => OffersController());
  }
}

// Future<void> showCustomOffersWidget<T>({
//   required BuildContext context,
//   bool barrierDismissible = true,
//   bool useRootNavigator = true,
// }) async {
//   await CustomSafeDialog.show<T>(
//       context: context,
//       tag: kCustomOffersWidget,
//       barrierDismissible: barrierDismissible,
//       useRootNavigator: useRootNavigator,
//       builder: (_) {
//         return Container(
//           color: Colors.transparent,
//           width: double.infinity,
//           height: double.infinity,
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
//           child: OffersPage().onTap(() {}),
//         ).onTap(() {
//           RouteUtil.popView();
//         });
//       });
// }