import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:get/get.dart';
import '../../../../../constant/app_values.dart';
import '../../../../../model/yulecheng/big_wins_model.dart';
import '../../../../../services/branch/branch_service.dart';
import '../../../../../services/theme/theme_service.dart';
import '../../../../../widget/custom_asset_icon.dart';
import '../../../../../widget/custom_text.dart';
import '../../../../../widget/network_image/custom_network_image.dart';
import '../index.dart';

class RankView extends GetView<BottomRankController> {
  const RankView({Key? key,this.rTitle,this.lTitle,this.infos,this.isLoading,this.firstTransparent =true}) : super(key: key);

  final String? rTitle;
  final String? lTitle;
  final List<BigWinsModel>? infos;
  final bool? isLoading;
  final bool firstTransparent;

  @override
  Widget build(BuildContext context) {
    return _buildList();
  }

  Widget _buildList() {
    final titleStyle = ThemeService()
        .theme
        .textTheme
        .bodyMedium
        ?.copyWith(color: CustomTextColorStyle.secondary.value,
        fontWeight: FontWeight.w500);
    var temps = [];
    for (int index = 0; index < 10; index++) {
      temps.add(index);
    }
    return <Widget>[
      // title
      <Widget>[
        CustomText(lTitle!, style: titleStyle),
        const Spacer(),
        CustomText(rTitle!, style: titleStyle),
      ].toRow()
          .paddingHorizontal(AppValues.defaultPadding),
      const SizedBox(height: AppValues.largePadding),
      // item
      if(isLoading!)
        for (int index = 0; index < 10; index++)
          _buildLoadingItem(index),

      if(!isLoading!)
      for (int index = 0; index < infos!.length; index++)
        InkWell(
          onTap: () => controller.onItemClick(infos![index]),
          child: _buildItem(index, infos![index]),
        )
        // _buildItem(index, infos![index])
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
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .height(54)
        .backgroundColor(index % 2 == (firstTransparent ? 0 : 1)
        ? Colors.transparent : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }

  // 数据 item
  Widget _buildItem(index, BigWinsModel info) {

    final payoutColor = info.payout.contains("-")
        ? CustomTextColorStyle.secondary.value : const Color(0xFF69E244);
    final payoutTextStyle = ThemeService().theme.textTheme.bodyMedium
        ?.copyWith(color: payoutColor, fontWeight: FontWeight.w400);
    final gameTextStyle = ThemeService().theme.textTheme.bodyMedium
        ?.copyWith(color: CustomTextColorStyle.white.value, fontWeight: FontWeight.w400);

    return <Widget>[
      const SizedBox(width: AppValues.defaultPadding),
      // 游戏类型icon
      CustomNetWorkImage(
        imageUrl: BranchService.instance.current.asset_url + info.icon,
        width: 18,
        height: AppValues.iconDefaultSize,
        errorWidget: const CustomAssetIcon(name: 'assets/images/network_image/777.png'),
      ),
      const SizedBox(width: AppValues.halfPadding),
      // 游戏名
      CustomText(info.gameName, style: gameTextStyle, maxLines: 1, overflow: TextOverflow.ellipsis)
          .constrained(maxWidth: Get.width - 180),
      const Spacer(),
      // 金额
      CustomText(
        info.payout,
        style: payoutTextStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.end
      ),
      const SizedBox(width: AppValues.halfPadding),
      // 货币icon
      CustomNetWorkImage(
        imageUrl: info.coinImgUrl,
        width: AppValues.iconDefaultSize,
        height: AppValues.iconDefaultSize,
      ),
      const SizedBox(width: AppValues.defaultPadding),
    ].toRow(crossAxisAlignment: CrossAxisAlignment.center)
        .height(54)
        .backgroundColor(index % 2 == (firstTransparent ? 0 : 1)
        ? Colors.transparent : ThemeService().colorScheme.tertiary)
        .clipRRect(all: 5);
  }
}