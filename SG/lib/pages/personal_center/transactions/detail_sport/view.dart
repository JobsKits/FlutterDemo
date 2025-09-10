import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/transactions/detail_sport/controller.dart';
import 'package:flutter_bet/pages/personal_center/transactions/index/widget/tabbar.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';

import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/app_bar/custom_app_bar.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';


class TransactionsDetailSportPage extends GetView<TransactionsDetailSportController> {
  TransactionsDetailSportPage({Key? key}) : super(key: key);

  final colorScheme = ThemeService().colorScheme;
  final textTheme   = ThemeService().theme.textTheme;

  // 主视图
  Widget _buildView() {

    const separator = SizedBox(width: AppValues.smallPadding, height: AppValues.defaultPadding);

    return <Widget>[
      buildTransactionsTitle(),

      TransactionsTabbar(
        type: TabbarType.coinType,
        titles: [S.current.active_bet, S.current.settled_bet],
        selIndex: 0,
      ),

      <Widget>[
        <Widget>[
          CustomText('17:42 2023/07/06'),
          const Spacer(),
          CustomText('ID 2317739'),
          CustomText('icon').randomBackgroundColor(),
          CustomText('icon').randomBackgroundColor(),
        ].toRow(separator: separator, mainAxisAlignment: MainAxisAlignment.center)
            .marginAll(AppValues.defaultPadding)
            .backgroundColor(colorScheme.surfaceVariant),
        <Widget>[
          CustomText(S.current.random_text_390),
          CustomText(S.current.random_text_391),
          <Widget>[
            CustomText(S.current.random_text_392),
            const Spacer(),
            CustomText("2.30"),
          ].toRow(),
          <Widget>[
            CustomText(S.current.bet_live)
                .marginSymmetric(horizontal: AppValues.margin_4, vertical: AppValues.margin_2)
                .backgroundColor(AppThemes.reverseStateColor),
            CustomText("70'"),
            CustomText(S.current.random_text_393),
            CustomText("0-1"),
            const Spacer(),
            CustomText("icon").randomBackgroundColor(),
            CustomText("icon").randomBackgroundColor(),
          ].toRow(separator: separator),

          <Widget>[
            Container(color:colorScheme.tertiary, height: 2).expanded(),
            CustomText("logo_icon").center().tight(width: 100, height: 50).randomBackgroundColor(),
            Container(color:colorScheme.tertiary, height: 2).expanded(),
          ].toRow(separator: separator),

          <Widget>[
            CustomText(S.current.menu_odds),
            const Spacer(),
            CustomText("1.08"),
          ].toRow(),

          <Widget>[
            CustomText(S.current.random_text_227),
            const Spacer(),
            CustomText("1.0000"),
            CustomText("icon").randomBackgroundColor(),
          ].toRow(separator: separator),
          <Widget>[
            CustomText(S.current.random_text_220),
            const Spacer(),
            CustomText("1.0000"),
            CustomText("icon").randomBackgroundColor(),
          ].toRow(separator: separator),

          buildExchangeBtn(),
        ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, separator: separator)
            .marginAll(AppValues.defaultPadding),
      ].toColumn()
          .backgroundColor(colorScheme.background)
          .clipRRect(topLeft: AppValues.smallRadius, topRight: AppValues.smallRadius)
          .boxShadow(color: AppThemes.appBarShadowColor, blurRadius: AppValues.indicatorDefaultSize)
          .paddingTop(AppValues.defaultPadding),


    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min)
        .marginAll(AppValues.defaultPadding)
        .backgroundColor(ThemeService().colorScheme.background)
        .clipRRect(all: AppValues.smallRadius)
        .paddingAll(AppValues.defaultPadding);
  }

  /// 构建title
  Widget buildTransactionsTitle() {
    return <Widget>[
      const CustomIcon(asset: 'assets/images/bet_slip/ic_casino_bet_order.webp'),
      const SizedBox(width: AppValues.extraSmallMargin),
      CustomText(S.current.sport_bet, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
      const Spacer(),
      const CustomIcon(asset: 'assets/images/normal/ic_normal_close.png',).onTap(() {RouteUtil.popView();})
    ].toRow()
        .marginOnly(left: AppValues.defaultMargin, top: AppValues.defaultMargin, right: AppValues.defaultMargin, bottom: AppValues.defaultPadding)
        .backgroundColor(ThemeService().theme.scaffoldBackgroundColor);
  }

  /// 兑换按钮
  Widget buildExchangeBtn() {
    bool isEnable = false;
    return CustomButton(
      child: <Widget>[
        CustomText(S.current.random_text_394),
        const SizedBox(width: AppValues.smallPadding),
        CustomText('icon').randomBackgroundColor()
      ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      textStyle: textTheme.bodyMedium,
      onTap: controller.exchange,
    ).center()
        .backgroundColor(isEnable ? colorScheme.primary : colorScheme.surfaceVariant)
        .tight(width: double.infinity, height:ThemeService().theme.buttonTheme.height)
        .clipRRect(all: AppValues.smallRadius);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransactionsDetailSportController>(
      init: TransactionsDetailSportController(),
      id: "transaction_details",
      builder: (_) {
        return _buildView();
      },
    );
  }
}
