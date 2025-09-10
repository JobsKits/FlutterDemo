import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/view.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'view.dart';

const kCustomTransactionsDetailWidget = 'CustomTransactionsDetailWidget';

class TransactionsDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TransactionDetailsController());
  }
}

Future<void> showCustomTransactionsDetailsWidget({
  required BuildContext context,
  required TransactionsType transactionsType,
  TransactionsCoinType coinType = TransactionsCoinType.banking,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomTransactionsDetailWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child:  TransactionDetailsPage(transactionsType, coinType).onTap(() {}),
        ).onTap(() {
          RouteUtil.popView();
        });
      });
}