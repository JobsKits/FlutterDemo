import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_empty_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 排行榜内容列表
class RankingList extends StatelessWidget {
  final String rTitle;
  final String lTitle;
  final List<BigWinsModel> infos;
  final bool isLoading;
  final bool firstTransparent;
  final Function callBack;

  RankingList({
      super.key,
      required this.rTitle,
      required this.lTitle,
      required this.infos,
      this.isLoading = false,
      this.firstTransparent = true,
      required this.callBack
  });

  @override
  Widget build(BuildContext context) {
    if(infos.isEmpty && !isLoading) {
      return const CustomEmptyWidget().paddingTop(AppValues.largePadding * 5);
    }
    return _buildList();
  }

  Widget _buildList() {
    final titleStyle = ThemeService()
        .theme
        .textTheme
        .bodyMedium
        ?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w500);

    return <Widget>[
      // title
      <Widget>[
        CustomText(rTitle, style: titleStyle),
        const Spacer(),
        CustomText(lTitle, style: titleStyle),
      ].toRow().paddingHorizontal(AppValues.defaultPadding),
      const SizedBox(height: AppValues.largePadding),
      // item
      if (isLoading)
        for (int index = 0; index < 10; index++) _buildLoadingItem(index),

      if (!isLoading)
        for (int index = 0; index < infos.length; index++)
          _buildItem(index, infos[index]).onTap(() {
            callBack(infos[index]);
          })
    ].toColumn();
  }

  // Loading item
  Widget _buildLoadingItem(index) {
    final box = Container(height: AppValues.iconDefaultSize, color: const Color(0xFF8998B0));
    return <Widget>[
      const SizedBox(width: AppValues.defaultPadding),
      // 游戏类型icon
      box.width(AppValues.iconDefaultSize).clipRRect(all: AppValues.iconDefaultSize / 2.0),
      const SizedBox(width: AppValues.halfPadding),
      // 游戏名
      box.width(Get.width * 0.2 * Random().nextDouble() + Get.width * 0.1).clipRRect(all: 3),
      const Spacer(),
      // 金额
      box.width(Get.width * 0.15).clipRRect(all: 3),
      const SizedBox(width: AppValues.halfPadding),
      // 货币icon
      box.width(AppValues.iconDefaultSize).clipRRect(all: AppValues.iconDefaultSize / 2.0),
      const SizedBox(width: AppValues.defaultPadding),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .height(54)
        .backgroundColor(index % 2 == (firstTransparent ? 0 : 1)
            ? Colors.transparent
            : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }

  // 数据 item
  Widget _buildItem(index, BigWinsModel info) {
    final payoutColor =
    (info.payout.contains("-") || info.payout == "0") ? CustomTextColorStyle.secondary.value : const Color(0xFF69E244);
    final payoutTextStyle = ThemeService()
        .theme
        .textTheme
        .bodyMedium
        ?.copyWith(color: payoutColor, fontWeight: FontWeight.w400);
    final gameTextStyle = ThemeService()
        .theme
        .textTheme
        .bodyMedium
        ?.copyWith(color: CustomTextColorStyle.white.value, fontWeight: FontWeight.w400);

    return <Widget>[
      const SizedBox(width: AppValues.defaultPadding),
      // 游戏类型icon
      CustomNetWorkImage(
        imageUrl: info.gameClassIcon,
        width: AppValues.iconDefaultSize,
        height: AppValues.iconDefaultSize,
      )
          .constrained(width: AppValues.iconDefaultSize, height: AppValues.iconDefaultSize)
          .visibility(info.gameClassIcon.isNotEmpty),
      const SizedBox(width: AppValues.halfPadding),
      // 游戏名
      CustomText(info.gameName, style: gameTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
          .constrained(maxWidth: Get.width / 3),
      // const Spacer(),
      const SizedBox(width: AppValues.halfPadding),
      // 金额
      CustomText(info.payout,
              style: payoutTextStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end).expanded(),
      const SizedBox(width: AppValues.halfPadding),
      // 货币icon
      CustomNetWorkImage(
        imageUrl: info.coinImgUrl,
        width: AppValues.iconDefaultSize,
        height: AppValues.iconDefaultSize,
      ),
      const SizedBox(width: AppValues.defaultPadding),
    ]
        .toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .height(54)
        .backgroundColor(index % 2 == (firstTransparent ? 0 : 1)
            ? Colors.transparent
            : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }
}
