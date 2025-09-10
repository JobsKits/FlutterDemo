import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 创建反馈/我的反馈 Tab选择器
class NotifsFeedBackTab extends StatelessWidget {
  NotifsFeedBackTab({super.key, required this.titles, required this.selIndex, required this.bonus, this.callback, this.callbackPopBonus});

  final List<String> titles;
  final int selIndex;
  final String bonus;
  final Function(BuildContext, int)? callback;
  final Function()? callbackPopBonus;

  final colorScheme = ThemeService().colorScheme;
  final titleStyle  = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: AppThemes.textColorSecondary);
  final selTitleStyle  = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  final amountStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFFFF9800), fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {

    final isEnabledBonus  = double.parse(bonus) > 0;
    // final bonusFormat     = MoneyUtil.toCoinAmountFormat("706", bonus);
    final bonusFormat     = bonus;
    final bonusBtnBgColor = isEnabledBonus ? const Color(0xFF1475E1) : ThemeService().colorScheme.tertiary;

    return <Widget>[
      <Widget>[
        for(int index = 0; index < titles.length; index++)
          CustomText(titles[index], style: index == selIndex ? selTitleStyle : titleStyle)
              .paddingSymmetric(horizontal: AppValues.defaultMargin)
              .alignBottom()
              .paddingBottom(AppValues.defaultPadding)
              .onTap((){index == selIndex ? null : callback?.call(context, index);})
              .border(bottom: 2, color: index == selIndex ? ThemeService().theme.colorScheme.primary : ThemeService().colorScheme.tertiary),

        const SizedBox().expanded(),
      ].toRow(),

      <Widget>[
        CustomText(S.current.feedback_bonus_title, style: selTitleStyle),
        // CustomText(bonusFormat, style: isEnabledBonus ? amountStyle : selTitleStyle),
        CustomText(bonusFormat, style: amountStyle),
        const SizedBox(width: AppValues.smallMargin),
        const CustomAssetIcon(name: "assets/images/personal_center_icon/ic_usdt.webp", size: AppValues.iconSmallSize),
        const SizedBox(width: AppValues.halfMargin),
        CustomText(
            S.current.receive,
            style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)
        ).marginSymmetric(horizontal: 10, vertical: 3)
            .backgroundColor(bonusBtnBgColor)
            .clipRRect(all: 50)
            .opacity(isEnabledBonus ? 1 : 0.5)
            .onTap(() {isEnabledBonus ? callbackPopBonus?.call() : Void;}),
      ].toRow(crossAxisAlignment: CrossAxisAlignment.center)
          .paddingTop(AppValues.defaultMargin)
          .visibility(selIndex == 1)

    ].toColumn().paddingHorizontal(AppValues.defaultPadding);
  }


}