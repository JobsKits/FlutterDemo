import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/switch/custom_switch.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'logic.dart';

class SetupPrivacyPage extends StatelessWidget {
  final controller = Get.put(SetupPrivacyLogic());
  SetupPrivacyPage({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPrivacy(),
            _buildChatRoom(),
            _buildAdvertise(),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvertise() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        CustomText(
          S.current.privacy_body_sale_title_text,
          style: ThemeService()
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSwitch(value: false),
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.privacy_body_switch_sale_title_text,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  const SizedBox(
                    height: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.privacy_body_switch_sale_tips_text,
                    maxLines: 2,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),

        CustomBigMainButton(
          title: S.current.button_save_text,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Center(
          child: CustomText(
            S.current.privacy_body_take_effect_tips_text,
            textColorStyle: CustomTextColorStyle.normal,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _buildChatRoom() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        CustomText(
          S.current.privacy_body_community_title_text,
          style: ThemeService()
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSwitch(value: false),
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.privacy_body_switch_red_rain_title_text,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  const SizedBox(
                    height: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.privacy_body_switch_red_rain_tips_text,
                    maxLines: 2,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        CustomBigMainButton(
          title: S.current.button_save_text,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Center(
          child: CustomText(
            S.current.privacy_body_take_effect_tips_text,
            textColorStyle: CustomTextColorStyle.normal,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          height: 1,
          color: ThemeService().colorScheme.tertiary,
          // padding:
          //     const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        ),
      ],
    );
  }

  Widget _buildPrivacy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          S.current.privacy_body_title_text,
          style: ThemeService()
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 8,
        ),
         CustomText(
          S.current.privacy_body_tips_text,
          maxLines: 5,
          textColorStyle: CustomTextColorStyle.normal,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          height: 1,
          color: ThemeService().colorScheme.tertiary,
          // padding:
          //     const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSwitch(value: false),
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.privacy_body_stealth_switch_title_text,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  const SizedBox(
                    height: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.privacy_body_stealth_switch_tips_text,
                    maxLines: 2,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSwitch(value: false),
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.privacy_body_statistics_switch_title_text,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  const SizedBox(
                    height: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.privacy_body_statistics_switch_tips_text,
                    maxLines: 2,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomSwitch(value: false),
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.privacy_body_stealth_switch_title_text,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  const SizedBox(
                    height: AppValues.smallPadding,
                  ),
                  CustomText(
                    S.current.privacy_body_race_switch_tips_text,
                    maxLines: 2,
                    textColorStyle: CustomTextColorStyle.normal,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        CustomBigMainButton(
          title: S.current.button_save_text,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Center(
          child: CustomText(
            S.current.privacy_body_take_effect_tips_text,
            textColorStyle: CustomTextColorStyle.normal,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          height: 1,
          color: ThemeService().colorScheme.tertiary,
          // padding:
          //     const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        ),
      ],
    );
  }
}
