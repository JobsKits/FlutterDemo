import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/transactions/other.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

class TransactionsWalletItem extends StatelessWidget {
  const TransactionsWalletItem({super.key, required this.type, required this.info});

  final TransactionsType type;
  final TrWalletModel info;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ThemeService().colorScheme;
    const smallPaddingSeparator = SizedBox(width: AppValues.smallPadding);
    return <Widget>[

      Container(
        width: 62,
        height: 70,
        color: colorScheme.surfaceVariant,
        alignment: Alignment.center,
        child: _buildIconWidget(),
      ),

      const SizedBox(width: AppValues.halfMargin),
      <Widget>[
        <Widget>[
          CustomText(info.itemStateTitle(type), // Confirmed
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              textColorStyle: CustomTextColorStyle.white
          ).expanded(),
          // const Spacer(),
          CustomText("${S.current.vault_amount} ${info.amountTitle}",
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textColorStyle: CustomTextColorStyle.secondary
          ),
          CustomNetWorkImage(
            imageUrl: info.coinUrlPath,
            width: AppValues.iconSmallSize,
            height: AppValues.iconSmallSize,
          ),
        ].toRow(separator: smallPaddingSeparator),

        const SizedBox(height: AppValues.padding_10),

        <Widget>[
          CustomText(info.timeTitle,
              style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              textColorStyle: CustomTextColorStyle.secondary
          ),
          const SizedBox(width: AppValues.smallPadding),
          CustomText(info.orderNumber,
              style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              textColorStyle: CustomTextColorStyle.white
          ).expanded(),
          const SizedBox(width: AppValues.smallPadding),
          const CustomIcon(
              asset: "assets/images/personal_center_icon/transaction_records.webp",
              size: AppValues.iconSmallerSize
          ),
        ].toRow(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center).expanded(),
      const SizedBox(width: AppValues.halfMargin),
    ].toRow()
        .backgroundColor(colorScheme.tertiary)
        .clipRRect(all: AppValues.smallRadius);
  }

  /// 左侧icon
  Widget _buildIconWidget() {
    final iconPath = info.itemStateIcPath(type);
    bool isHttpIcon = iconPath.contains("http");

    if(isHttpIcon) {
      return Image.network(
        iconPath,
        width: AppValues.iconSize_20,
        height: AppValues.iconSize_20,
      );
    }

    return Image.asset(
      iconPath,
      width: AppValues.iconSize_20,
      height: AppValues.iconSize_20,
    );
  }

}

class TransactionsOtherItem extends StatelessWidget {
  const TransactionsOtherItem({super.key, required this.info});

  final TrOtherModel info;

  @override
  Widget build(BuildContext context) {
    final colorScheme = ThemeService().colorScheme;
    const smallPaddingSeparator = SizedBox(width: AppValues.smallPadding);
    return <Widget>[

      Container(
        width: 62,
        height: 70,
        color: colorScheme.surfaceVariant,
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/personal_center_icon/cash_in.webp",
          width: AppValues.iconSize_20,
          height: AppValues.iconSize_20,
        ),
      ),

      const SizedBox(width: AppValues.halfMargin),
      <Widget>[
        <Widget>[
          CustomText(info.cashTypeName, // Confirmed
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              maxLines: 2,
              textColorStyle: CustomTextColorStyle.white
          ).expanded(),
          CustomText("${S.current.vault_amount} ${info.amountTitle}",
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              textColorStyle: CustomTextColorStyle.secondary
          ),
          CustomNetWorkImage(
            imageUrl: info.coinUrlPath,
            width: AppValues.iconSmallSize,
            height: AppValues.iconSmallSize,
          ),
        ].toRow(separator: smallPaddingSeparator),

        const SizedBox(height: AppValues.padding_10),

        <Widget>[
          CustomText(info.timeTitle,
              style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              textColorStyle: CustomTextColorStyle.secondary
          ),
        ].toRow(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.center).expanded(),
      const SizedBox(width: AppValues.halfMargin),
    ].toRow()
        .backgroundColor(colorScheme.tertiary)
        .clipRRect(all: AppValues.smallRadius);
  }
}


