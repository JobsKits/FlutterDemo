import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/network_image/custom_network_image_placeholder.dart';
import '../index.dart';

/// 游戏介绍
class TabGameInfoView extends GetView<YulechenggamedetailsController> {
  const TabGameInfoView(this.info, {Key? key,}) : super(key: key);

  final GameListModel info;

  @override
  Widget build(BuildContext context) {
    return <Widget>[
      CustomNetWorkImage(
        imageUrl: BranchService.instance.current.asset_url +
            controller.items.gameImgUrl,
        width: 136,
        height: 170,
        fit: BoxFit.cover,
      ).borderRadius(all: 8.0).center(),

      <Widget>[
        CustomText(
          S.current.random_text_276,
          style: ThemeService().theme.textTheme.bodyMedium
              ?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w400),
        ),
        CustomText(
          '3.62%',
          style: ThemeService().theme.textTheme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ].toRow(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center)
        .paddingSymmetric(horizontal: 8.0)
        .backgroundColor(AppThemes.surfaceVariant)
        .height(22)
        .clipRRect(all: 11)
        .marginOnly(right: AppValues.defaultPadding, top: AppValues.defaultPadding),

      <Widget>[
        buildLab(S.current.random_text_277),
        buildLab('Evolution'),
        buildLab(S.current.yulecheng_casino),
      ].toRow(),

      <Widget>[
        buildLab(S.current.random_text_279),
      ].toRow(),

      const SizedBox(height: AppValues.defaultPadding),
      CustomText(testGameInfo(),
        style: ThemeService().theme.textTheme.bodyMedium
        ?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w400, height: 1.5),
      )
      
      
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start);
  }


  Widget buildLab(String text){
    return CustomText(
      text,
      textAlign: TextAlign.center,
      style: ThemeService().theme.textTheme.bodyMedium
          ?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w400),
    ).paddingSymmetric(horizontal: 8.0).center()
        .backgroundColor(AppThemes.surfaceVariant)
        .height(22)
        .clipRRect(all: 11)
        .marginOnly(right: 12, top: 12);
  }
  

  String testGameInfo() {
    return """Dork Unit is a 5-reel slot game by Hacksaw Gaming that brings colourful and fun slot gaming that is full of clown-themed bonus features.\n
This slot game plays on a 5x4 gameplay area and has players match fun, colourful symbols across 16 paylines of action.\n
Dork Unit has players trigger gameplay mechanics leading to bonus features such as gift boxes,gift bonanza and dork spins to add a twist to their slots gameplay.""";
  }


}
