
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/notifis/feedback.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

/// 有奖反馈列表Item
class NotifsFeedbackItem extends StatelessWidget {
  NotifsFeedbackItem({super.key, required this.feedbackInfo});

  final FeedbackModel feedbackInfo;

  final colorScheme = ThemeService().colorScheme;
  // 白色默认
  final textStyle  = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500);
  // 橙色处理中
  final processingTextStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFFFF9800));
  // 未读
  final sTextStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500, color: const Color(0xFFB1BBD3));
  // 日期
  final tTextStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFFB1BBD3));

  @override
  Widget build(BuildContext context) {

    final info     = feedbackInfo;

    return <Widget>[

      // 反馈状态
      <Widget>[
        CustomText(S.current.feedback_state_title, maxLines: 2,  style: textStyle),
        CustomText(info.stateTitle, style: info.state == 1 ? processingTextStyle : textStyle).expanded(),
        // const SizedBox().expanded(),
        // 未读消息提示
        Container(color: colorScheme.primaryContainer, width: 6, height: 6)
            .clipOval().visibility(info.isUnread),
        const SizedBox(width: 4),
        CustomText(info.isUnreadTitle, style: info.isUnread ? sTextStyle : textStyle)
      ].toRow(),

      // 反馈ID
      <Widget>[
        CustomText(S.current.feedbacl_id_title, style: textStyle, maxLines: 1),
        CustomText(info.id, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis).expanded(),
        const SizedBox(width: AppValues.halfPadding),
        CustomText(info.timeTitle, style:sTextStyle),
      ].toRow(),

      // 反馈内容
      <Widget>[
        CustomText(S.current.feedback_content_title, style: textStyle),
        CustomText(info.description, style: textStyle, maxLines: 1, overflow: TextOverflow.ellipsis).expanded(),
      ].toRow(),
    ].toColumn(separator: const SizedBox(height: AppValues.defaultPadding))
        .marginAll(AppValues.defaultPadding)
        .backgroundColor(ThemeService().colorScheme.tertiary)
        .paddingHorizontal(AppValues.defaultMargin)
        .paddingBottom(AppValues.defaultMargin);
  }
}
