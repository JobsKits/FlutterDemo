import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get_utils/get_utils.dart';

class VipBaoJiTips extends StatelessWidget {
  VipBaoJiTips(this.betNeededAmountString, this.cashInNeededAmountString, {super.key});
  String cashInNeededAmountString = "";
  String betNeededAmountString = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 134,
      decoration: BoxDecoration(
          color: ThemeService().theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4)),
      child: <Widget>[
        <Widget>[
          const SizedBox(width: AppValues.extraSmallMargin),
          CustomText(S.current.random_text_938,
              style:
                  ThemeService().theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          const CustomIcon(
                  asset: 'assets/images/normal/ic_normal_close.png', size: AppValues.iconSize_20)
              .marginOnly(left: AppValues.defaultMargin)
              .center()
              .onTap(() {
            RouteUtil.popView();
          })
        ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
        <Widget>[
          <Widget>[
            CustomText("${S.current.random_text_943} ${cashInNeededAmountString} ",
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600, color: Color(0xffb1bad3))),
            Image.network("${AppValues.defaultBranch.asset_url}/currency/706.webp").tightSize(12)
          ].toRow(mainAxisAlignment: MainAxisAlignment.center),
          SizedBox(
            height: AppValues.defaultPadding,
          ),
          <Widget>[
            CustomText("${S.current.random_text_944} ${betNeededAmountString} ",
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600, color: Color(0xffb1bad3))),
            Image.network("${AppValues.defaultBranch.asset_url}/currency/706.webp").tightSize(12)
          ].toRow(mainAxisAlignment: MainAxisAlignment.center),
        ]
            .toColumn(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center)
            .paddingTop(AppValues.defaultPadding),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.start).paddingAll(AppValues.defaultPadding),
    );
  }
}
