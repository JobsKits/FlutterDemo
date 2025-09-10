import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'view.dart';
export 'package:flutter_bet/widget/custom_rotating_arrow.dart';
export './widgets/currency_btn.dart';
export 'view.dart';



const kCustomPopCurrencyWidget = 'CustomPopCurrencyWidget';

Future<void> showPopCurrencyWidget({
  required BuildContext context,
  required PopCurrencyPage popPage,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomPopCurrencyWidget,
      useSafeArea: false,
      barrierDismissible: false,
      useRootNavigator: false,
      barrierColor: Colors.transparent,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          child:  popPage,
        );
      });
}