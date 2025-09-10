import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';

import 'index.dart';
import 'package:get/get.dart';


const kCustomNotifsFeedbackBonusWidget = 'CustomNotifsFeedbackBonus';

Future<void> showCustomFeedbackBonusWidget({
  required BuildContext context,
  required String feedId,
  required String bonus,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show(
      context: context,
      tag: kCustomNotifsFeedbackBonusWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Container(
          color: Colors.transparent,
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child:  FeedbackBonusPage(feedId, bonus).onTap(() { }),
        ).onTap(() {
          RouteUtil.popView();
        });
      });
}