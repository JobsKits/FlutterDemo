import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail/widgets/text.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

/// 投注记录样式
class TransactionsDetailBets extends StatelessWidget {
  TransactionsDetailBets({super.key});
  final textTheme   = ThemeService().theme.textTheme;

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }

  Widget _buildView() {

    const smallPadding = SizedBox(width: AppValues.smallPadding);

    return <Widget>[
      TrDetailsText.bodyLight('Lightning Blackjack'),
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        TrDetailsText.bodyLight('ID 167,069,599,379'),
        const SizedBox(width: AppValues.smallPadding),
        const CustomIcon(
          asset: 'assets/images/personal_center_icon/copy.webp',
          size: AppValues.iconSmallSize,
        ).onTap(() {

        }),
        const SizedBox(width: AppValues.smallPadding),
        const CustomIcon(
          asset: 'assets/images/personal_center_icon/hyperlink.webp',
          size: AppValues.iconSmallSize,
        ).onTap(() {

        })
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      const SizedBox(height: AppValues.defaultPadding),
      TrDetailsText.body(S.current.transactions_detail_player("UserXXX")),
      const SizedBox(height: AppValues.defaultPadding),
      TrDetailsText.body('2023/07/07 17:42'),
      const SizedBox(height: AppValues.defaultPadding),
      <Widget>[
        const SizedBox(height: AppValues.defaultPadding),
        <Widget>[
          TrDetailsText.body(S.current.transactions_detail_bet),
          TrDetailsText.bodyLight('4.0000000'),
          CustomAssetIcon(
              name: 'assets/images/coin_icon/eth_ic.png',
              size: AppValues.iconSmallSize
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center, separator: smallPadding),
        const SizedBox(height: AppValues.defaultPadding),
        <Widget>[
          TrDetailsText.body(S.current.transactions_detail_odds),
          TrDetailsText.bodyLight('1.00x'),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center, separator: smallPadding),
        const SizedBox(height: AppValues.defaultPadding),
        <Widget>[
          TrDetailsText.body(S.current.transactions_detail_pay),
          CustomText(
              '4.0000000',
              style: ThemeService().textTheme.bodyMedium?.copyWith(color: AppThemes.frontStateColor)
          ),
          CustomAssetIcon(
              name: 'assets/images/coin_icon/eth_ic.png',
              size: AppValues.iconSmallSize
          ),
        ].toRow(mainAxisAlignment: MainAxisAlignment.center, separator: smallPadding),
        const SizedBox(height: AppValues.defaultPadding),
      ].toColumn().backgroundColor(ThemeService().theme.colorScheme.surface),
      const SizedBox(height: AppValues.defaultPadding),
    ].toColumn().center();
  }

  Widget _buildRow(List<Widget> widgets) {
    return <Widget>[
      for(int index = 0; index < widgets.length; index++)
        widgets[index].paddingLeft(AppValues.smallPadding)
    ].toRow();
  }

}
