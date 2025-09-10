import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/refresh/widget/cupertino/easy_refresh_path.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'index.dart';

class FeedbackInsertPage extends GetView<FeedbackInsertController> {
  FeedbackInsertPage({Key? key}) : super(key: key);

  Widget _buildView(context) {

    final titleStyle = ThemeService().theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500);
    const subColor   = Color.fromRGBO(255, 255, 255, 0.5);
    final subStyle   = ThemeService().theme.textTheme.bodySmall?.copyWith(color:subColor, fontWeight: FontWeight.w500);

    final RegExp _emojiRegExp = RegExp(
      '[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F700}-\u{1F77F}]|[\u{1F780}-\u{1F7FF}]|[\u{1F800}-\u{1F8FF}]|[\u{1F900}-\u{1F9FF}]|[\u{1FA00}-\u{1FA6F}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]',
      unicode: true,
    );

    return <Widget>[

      /// 输入框部分
      <Widget>[
        CustomText(S.current.feedback_title_content, style: titleStyle),
        CustomText("*", style: titleStyle?.copyWith(color: const Color(0xFFED4163))),
      ].toRow(),
      const SizedBox(height: AppValues.halfMargin),
      TextField(
        maxLines: 100,
        maxLength: 200,
        focusNode: controller.focusNode,
        inputFormatters: [FilteringTextInputFormatter.deny(_emojiRegExp)],
        controller: controller.textController,
        style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintStyle: subStyle,
          hintText: controller.focusNode.hasFocus ? "" : S.current.feedback_content_sub,
        ),
      ).height(140).paddingHorizontal(AppValues.defaultPadding)
          .border(all: 2, color: ThemeService().colorScheme.tertiary),

      const SizedBox(height: AppValues.halfMargin),
      <Widget>[
        Obx(() =>
            CustomText(S.current.random_text_1169,
                style: ThemeService().theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFED4163), fontWeight: FontWeight.w500)
            ).visibility(controller.textLength.value == 0 && (controller.showEmptyHint2.value || controller.showEmptyHint.value)),
        ),
        const SizedBox().expanded(),
        Obx(() =>
            CustomText("${controller.textLength}/200",
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: CustomTextColorStyle.secondary.value, fontWeight: FontWeight.w500),
              textAlign: TextAlign.end
            )
        ),
      ].toRow(),

      const SizedBox(height: AppValues.defaultMargin),

      /// 图片选择部分
      CustomText(S.current.feedback_title_img, style: titleStyle),
      const SizedBox(height: AppValues.halfMargin),

      <Widget>[
        for (int i = 0; i < controller.assets.length; i++)
          Image(
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            image: AssetEntityImageProvider(controller.assets[i], isOriginal: false),
          ).paddingRight(AppValues.defaultPadding),
        const CustomAssetIcon(name: "assets/images/normal/ic_img_add.webp", size: 80).onTap(() {
          controller.pickAssets();
        })
      ].toListView(scrollDirection: Axis.horizontal).height(80),
      const SizedBox(height: AppValues.halfMargin),
      CustomText(S.current.feedback_img_sub, style: subStyle),
      const SizedBox(height: AppValues.defaultMargin),
      /// 奖励规则
      CustomText(S.current.feedback_rule_title, style: titleStyle),
      const SizedBox(height: AppValues.halfMargin),
      CustomText(
        style: subStyle,
        maxLines: 20,
        S.current.feedback_rule_sub,
      ),

      const SizedBox(height: AppValues.defaultMargin),

      /// 提交按钮
      <Widget>[
        Container(
            height: 44,
            clipBehavior: Clip.antiAlias,
            alignment: Alignment.center,
            decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: ThemeService().colorScheme.tertiary),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            child: CustomText(S.current.wallet_cancel, style: ThemeService().theme.textTheme.bodyMedium)
        ).onTap(controller.cancelAction).expanded(),
        const SizedBox(width: 12),

        Obx(() =>
            CustomText(
                controller.currentSeconds.value == 0 ?
                S.current.submit_text : "${S.current.submit_text}(${controller.currentSeconds.value}s)",
                style: ThemeService().theme.textTheme.bodyMedium?.copyWith(color: Colors.black)
            ).center()
                .tight(height: 44)
                .backgroundColor(CustomButtonColorStyle.tertiary.backgroundColor)
                .opacity(controller.currentSeconds.value == 0 ? 1 : 0.35)
                .clipRRect(all: 4)
                .onTap((){if(controller.currentSeconds.value == 0) controller.feedbackSubAction(context);})
                .expanded()
        )


      ].toRow(),

      // 底部预留空间
      const SizedBox(height: 50),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .marginSymmetric(horizontal: AppValues.defaultMargin);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackInsertController>(
      init: FeedbackInsertController(),
      id: "feedback_insert",
      builder: (_) {
        return SingleChildScrollView(
          child: _buildView(context),
        ).expanded();
      },
    );
  }
}
