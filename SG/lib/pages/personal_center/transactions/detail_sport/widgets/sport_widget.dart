import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';


class TransactionsDetailSport extends StatelessWidget {
  TransactionsDetailSport({super.key});
  final textTheme   = ThemeService().theme.textTheme;

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  Widget _buildView() {

    const separator = SizedBox(width: AppValues.smallPadding);

    return <Widget>[
      CustomText('Lightning Blackjack', style: textTheme.titleSmall)
          .paddingAll(AppValues.defaultPadding),
      <Widget>[
        CustomText('ID 8378288'),
        CustomText('icon').randomBackgroundColor(),
        CustomText('icon').randomBackgroundColor(),
      ].toRow(separator: separator, mainAxisAlignment: MainAxisAlignment.center)
          .paddingVertical(AppValues.smallPadding),
      CustomText(S.current.random_text_395).paddingVertical(AppValues.smallPadding),
      CustomText(S.current.random_text_396).paddingVertical(AppValues.smallPadding),
      <Widget>[
        CustomText(S.current.tab_bar_order),
        CustomText('4.0000'),
        CustomText('icon').randomBackgroundColor(),
      ].toRow(separator: separator, mainAxisAlignment: MainAxisAlignment.center)
          .paddingVertical(AppValues.smallPadding),
      <Widget>[
        CustomText(S.current.random_text_397),
        CustomText('1.0x'),
      ].toRow(separator: separator, mainAxisAlignment: MainAxisAlignment.center)
          .paddingVertical(AppValues.smallPadding),
      <Widget>[
        CustomText(S.current.random_text_398),
        CustomText('+4.0000'),
        CustomText('icon').randomBackgroundColor(),
      ].toRow(separator: separator, mainAxisAlignment: MainAxisAlignment.center)
          .paddingVertical(AppValues.smallPadding),
    ].toColumn().center();
  }

  Widget _buildRow(List<Widget> widgets) {
    return <Widget>[
      for(int index = 0; index < widgets.length; index++)
        widgets[index].paddingLeft(AppValues.smallPadding)
    ].toRow();
  }

}
