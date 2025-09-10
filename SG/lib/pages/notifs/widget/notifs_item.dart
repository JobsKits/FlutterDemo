import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/notifis/announcement.dart';
import 'package:flutter_bet/model/wallet/CoinBean.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/time/time_format.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 通知-消息列表-消息item
class NotifsItem extends StatelessWidget {
  const NotifsItem({super.key, required this.model});
  final NotifsInfo model;

  @override
  Widget build(BuildContext context) {
    const iconWidth = 62.0;
    final titleWidth = Get.width - iconWidth - AppValues.defaultPadding * 4;
    final colorScheme = ThemeService().colorScheme;
    final textTheme = ThemeService().theme.textTheme;

    return <Widget>[
      // 左侧typeName对应icon
      _buildTypeAsset().center().tight(width: iconWidth),

      // 右侧内容
      <Widget>[
        // 标题/时间
        <Widget>[
          CustomText(model.itemTitle,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)).expanded(),
          Container(color: colorScheme.primaryContainer, width: 8, height: 8)
              .clipOval()
              .paddingTop(3)
              .visibility(model.isUnread),
          const SizedBox(width: AppValues.padding_3),
          CustomText(model.timeTitle, style: textTheme.labelMedium),
        ].toRow().paddingBottom(AppValues.smallMargin),
        // 内容
        _buildContentWidget(),
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .width(titleWidth)
          .marginAll(AppValues.defaultPadding)
          .backgroundColor(colorScheme.tertiary)
    ]
        .toRow()
        .width(Get.width - AppValues.defaultPadding * 2)
        .backgroundColor(colorScheme.surfaceVariant)
        .clipRRect(all: AppValues.roundedButtonRadius);
  }

  // 左侧类型icon
  Widget _buildTypeAsset() {
    for (var coinInfo in globalController.currTypeLists) {
      if (coinInfo.name == model.typeNameAsset) {
        return Image.network(
            coinInfo.coinImgUrl,
            width: AppValues.iconSize_20,
            height: AppValues.iconSize_20,
        );
      }
    }
    return Image.asset(
      model.typeNameAsset,
      width: AppValues.iconSize_20,
      height: AppValues.iconSize_20,
    );
  }


  /// 内容 TODO: finance / risk / announcement 等做区分
  Widget _buildContentWidget() {
    return RichText(
        text: TextSpan(
          children: <InlineSpan>[
            for(int index = 0; index < model.contentInfos.length; index++)
              _buildContentText(model.contentInfos[index])
          ]
        )
    );
  }

  /// 内容富文本子组件
  InlineSpan _buildContentText(String text){
    final textStyle =  ThemeService().theme.textTheme.bodyMedium
        ?.copyWith(fontWeight: FontWeight.w400, color: CustomTextColorStyle.secondary.value);

    // 货币Icon类型
    for (var coinInfo in globalController.currTypeLists) {
      if (coinInfo.name == text) {
        return WidgetSpan(
            child: Image.network(coinInfo.coinImgUrl, width: 15, height: 15)
                .paddingRight(AppValues.smallPadding)
        );
      }
    }
    // 文本类型
    return TextSpan(text:"$text ", style: textStyle);
  }
}

class NotifsAnnouncementItem extends StatelessWidget {
  const NotifsAnnouncementItem({super.key, required this.model});

  final AnnouncementModel model;

  @override
  Widget build(BuildContext context) {
    const iconWidth = 62.0;
    final titleWidth = Get.width - iconWidth - AppValues.defaultPadding * 4;
    final colorScheme = ThemeService().colorScheme;
    final textTheme = ThemeService().theme.textTheme;

    return <Widget>[
      // 左侧typeName对应icon
      Image.asset(
        model.typeNameAsset,
        width: model.typeNameAssetSize,
        height: model.typeNameAssetSize,
      ).center().tight(width: iconWidth),

      // 右侧内容
      <Widget>[
        // 标题/时间
        <Widget>[
          CustomText(model.title,
                  maxLines: 1, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))
              .expanded(),
          const SizedBox(width: AppValues.smallPadding),
          Container(color: colorScheme.primaryContainer, width: 8, height: 8)
              .clipOval()
              .paddingTop(3)
              .visibility(model.isUnread),
          const SizedBox(width: AppValues.padding_3),
          CustomText(model.timeTitle, style: textTheme.labelMedium),
        ].toRow().paddingBottom(AppValues.smallMargin),
        // 内容
        CustomText(model.itemContent,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textColorStyle: CustomTextColorStyle.secondary,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
      ]
          .toColumn(crossAxisAlignment: CrossAxisAlignment.start)
          .width(titleWidth)
          .marginAll(AppValues.defaultPadding)
          .backgroundColor(colorScheme.tertiary)
    ]
        .toRow()
        .width(Get.width - AppValues.defaultPadding * 2)
        .backgroundColor(colorScheme.surfaceVariant)
        .clipRRect(all: AppValues.roundedButtonRadius);
  }
}
