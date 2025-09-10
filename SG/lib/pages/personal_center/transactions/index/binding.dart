import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/view.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';
import 'logic.dart';

const kCustomTransactionsWidget = 'CustomTransactionsWidget';

class TransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionsLogic());
  }
}

// Future<void> showCustomTransactionsWidget<T>({
//   required BuildContext context,
//   bool barrierDismissible = true,
//   bool useRootNavigator = true,
// }) async {
//   await CustomSafeDialog.show<T>(
//       context: context,
//       tag: kCustomTransactionsWidget,
//       barrierDismissible: barrierDismissible,
//       useRootNavigator: useRootNavigator,
//       builder: (_) {
//         return Container(
//           color: Colors.transparent,
//           width: double.infinity,
//           height: double.infinity,
//           alignment: Alignment.center,
//           padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
//           child: TransactionsPage().onTap(() {}),
//         ).onTap(() {
//           RouteUtil.popView();
//         });
//       });
// }
