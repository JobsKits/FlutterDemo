import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_small_mian_button.dart';
import '../../../../widget/custom_text.dart';
import '../responsible_logic.dart';

///自我排除, 了解更多 OR  点击按钮

class SelfExclusionDetailView extends StatelessWidget {
  SelfExclusionDetailView({super.key});

  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraint) {
      log('约束信息：SelfExclusionDetailView...$boxConstraint');
      return Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
            height: 1,
            color: ThemeService().colorScheme.tertiary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppValues.largePadding, vertical: AppValues.defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  S.current.responsible_title_self_exclusion,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: AppValues.halfMargin),
                CustomText(
                  S.current.random_text_377,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .labelMedium
                      ?.copyWith(fontWeight: FontWeight.w400),
                ),
                SizedBox(height: AppValues.halfMargin),
                // SizedBox(height: AppValues.margin_40),
                // SizedBox(height: AppValues.margin_40),
                // SizedBox(height: AppValues.margin_40),
                // SizedBox(height: AppValues.margin_40),
                // SizedBox(height: AppValues.margin_40),
                CustomText(
                  S.current.random_text_378,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w400, color: Color(0xffED4163)),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppValues.halfMargin),
            height: 1,
            color: ThemeService().colorScheme.tertiary,
          ),
          SizedBox(height: AppValues.defaultMargin),
          CustomSmallMainButton(
            title: S.current.responsible_btn_request_self_exclusion,
            width: 124,
            backgroundColor: ThemeService().colorScheme.tertiaryContainer,
            fontWeight: FontWeight.w500,
            onTap: () => controller.onClickSelfExclusion(),
          ),
          SizedBox(height: AppValues.defaultMargin),
          CustomSmallMainButton(
            isEnable: false,
            title: S.current.random_text_380,
            width: 124,
            backgroundColor: ThemeService().colorScheme.tertiaryContainer,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: AppValues.defaultMargin),
        ],
      );
    });
  }
}
