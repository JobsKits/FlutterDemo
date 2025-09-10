import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/view.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'view.dart';

const kCustomTrWalletDetailWidget = 'CustomTrWalletDetailWidget';

Future<void> showCustomTrWalletDetailsWidget({
  required BuildContext context,
  required TransactionsType transactionsType,
  required TrWalletModel info,
  TransactionsCoinType coinType = TransactionsCoinType.banking,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomTrWalletDetailWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child:  TrWalletDetailsPage(transactionsType, coinType, info).onTap(() {}),
        ).onTap(() {
          RouteUtil.popView();
        });
      });
}