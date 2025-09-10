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
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:get/get_utils/get_utils.dart';

class VipFanshuiList extends StatelessWidget {
  VipFanshuiList({super.key, required this.callBack});
  final Function callBack;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: ThemeService().theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(4)),
      child: <Widget>[
        <Widget>[
          const SizedBox(width: AppValues.extraSmallMargin),
          CustomText(S.current.random_text_403,
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
        fanshuiListView(),
        lingquButton(),
      ].toColumn(mainAxisAlignment: MainAxisAlignment.start).paddingAll(AppValues.defaultPadding),
    );
  }

  Widget fanshuiListView() {
    List titleList = [
      S.current.random_text_560,
      S.current.random_text_128,
      S.current.vault_amount,
      S.current.detailscopy2
    ];

    return ListView.builder(
        itemCount: 6,
        itemBuilder: (context, index) {
          final bgColor = index % 2 == 1
              ? ThemeService().theme.colorScheme.surfaceVariant
              : ThemeService().theme.scaffoldBackgroundColor;
          return Container(
            color: bgColor,
            child: CustomRowExpandedWidget(
              expanded: [1, 1, 1, 1],
              children: [
                Center(
                  child: CustomText(
                    titleList[0],
                    style: ThemeService()
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: ThemeService().theme.colorScheme.onTertiary),
                  ),
                ),
                Center(
                  child: CustomText(
                    titleList[1],
                    style: ThemeService()
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: ThemeService().theme.colorScheme.onTertiary),
                  ),
                ),
                Center(
                  child: CustomText(
                    titleList[2],
                    style: ThemeService()
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: ThemeService().theme.colorScheme.onTertiary),
                  ),
                ),
                Center(
                  child: CustomText(
                    titleList[3],
                    style: ThemeService()
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: ThemeService().theme.colorScheme.onTertiary),
                  ),
                ),
              ],
            ).tight(height: 54),
          );
        }).tight(height: 54 * 6).paddingHorizontal(AppValues.defaultPadding);
  }

  lingquButton() {
    return CustomButton(
      backgroundColor: ThemeService().theme.colorScheme.primaryContainer,
      title: S.current.random_text_939,
      textStyle: ThemeService().theme.textTheme.bodyMedium!.copyWith(
          color: ThemeService().colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
      alignment: const Alignment(0, 0),
      onTap: () {
        callBack();
      },
    )
        .clipRRect(all: AppValues.smallRadius)
        .height(44)
        .constrained(minWidth: 80)
        .paddingHorizontal(AppValues.defaultPadding)
        .paddingTop(AppValues.defaultPadding);
  }
}
