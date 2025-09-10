import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_kyc_expand.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SetupKYCPage extends StatelessWidget {
  final double maxHeight;

  SetupKYCPage({super.key, this.maxHeight = 400});

  final controller = Get.put(SetupKYCLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: [
              SetupKYCExpand(
                title: S.current.kyc_level_number_one_text,
                isInitExpanded: true,
                children: [_buildClassA()],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              SetupKYCExpand(
                title: S.current.kyc_level_number_two_text,
                isInitExpanded: false,
                children: [_buildClassB()],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              SetupKYCExpand(
                title: S.current.kyc_level_number_three_text,
                isInitExpanded: false,
                children: [_buildClassC()],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              SetupKYCExpand(
                title: S.current.kyc_level_number_four_text,
                isInitExpanded: false,
                children: [_buildClassD()],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassA() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              S.current.kyc_level_verify_title_text,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              S.current.kyc_level_one_tips_text,
              maxLines: 3,
              textColorStyle: CustomTextColorStyle.normal,

            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomMainTextField(
                title: S.current.kyc_given_name_text,
                showError: false,
              )),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              Expanded(
                  child: CustomMainTextField(
                title: S.current.kyc_family_name_text,
                showError: false,
              )),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                  child: CustomMainTextField(
                title: S.current.text_field_birthday_tips,
                hintText: 'DD',
                showError: false,
              )),
              SizedBox(
                width: AppValues.defaultPadding,
              ),
              Expanded(
                  child: CustomMainTextField(
                hintText: S.current.monthly_text,
                showError: false,
              )),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              Expanded(
                  child: CustomMainTextField(
                hintText: 'YYYY',
                showError: false,
              )),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomMainTextField(
            title: S.current.kyc_nationality_text,
            showError: false,
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomMainTextField(
            title: S.current.kyc_live_place_text,
            showError: false,
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                  child: CustomMainTextField(
                title: S.current.kyc_city_text,
                showError: false,
              )),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              Expanded(
                  child: CustomMainTextField(
                title: S.current.kyc_postal_code_text,
                showError: false,
              )),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomMainTextField(
            title: S.current.kyc_job_text,
            showError: false,
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              child: CustomText(
            S.current.kyc_security_tips_text,
            textColorStyle: CustomTextColorStyle.normal,
          )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            title: S.current.button_save_text,
          ),
        ],
      ),
    );
  }

  Widget _buildClassB() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              S.current.kyc_level_verify_title_text,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_two_tips1_text,
                textColorStyle: CustomTextColorStyle.error,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_two_tips2_text,
                textColorStyle: CustomTextColorStyle.normal,
                maxLines: 6,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_personal_id_text,
                textColorStyle: CustomTextColorStyle.normal,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: 146 / 92,
                        child: Image.asset(
                            'assets/images/ic_id_card_placeholder.png')),
                    const SizedBox(
                      height: AppValues.smallPadding,
                    ),
                     CustomText(
                      S.current.kyc_level_front_text,
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: AppValues.defaultPadding,
              ),
              Expanded(
                child: Column(
                  children: [
                    AspectRatio(
                        aspectRatio: 146 / 92,
                        child: Image.asset(
                            'assets/images/ic_id_card_placeholder.png')),
                    const SizedBox(
                      height: AppValues.smallPadding,
                    ),
                     CustomText(
                      S.current.kyc_level_reverse_text,
                      textColorStyle: CustomTextColorStyle.normal,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
                S.current.kyc_type_support_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
               S.current.kyc_security_tips_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            title: S.current.button_save_text,
          ),
        ],
      ),
    );
  }

  Widget _buildClassC() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              S.current.kyc_level_verify_title_text,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_there_tips1_text,
                textColorStyle: CustomTextColorStyle.error,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_there_tips2_text,
                textColorStyle: CustomTextColorStyle.normal,
                maxLines: 6,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_address_prove_text,
                textColorStyle: CustomTextColorStyle.normal,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: Center(
                child: SizedBox(
                  width: 146,
                  height: 116,
                  child: Image.asset('assets/images/ic_dzzm_placeholder.png'),
                ),
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
                S.current.kyc_type_support_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
                S.current.kyc_security_tips_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            title: S.current.button_save_text,
          ),
        ],
      ),
    );
  }
  Widget _buildClassD() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
             S.current.kyc_level_verify_title_text,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_four_tips1_text,
                textColorStyle: CustomTextColorStyle.error,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_four_tips2_text,
                textColorStyle: CustomTextColorStyle.normal,
                maxLines: 6,
                style: ThemeService().textTheme.bodySmall,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                S.current.kyc_level_money_source_text,
                textColorStyle: CustomTextColorStyle.normal,
                style: ThemeService()
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: Center(
                child: SizedBox(
                  width: 146,
                  height: 116,
                  child: Image.asset('assets/images/ic_dzzm_placeholder.png'),
                ),
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
                S.current.kyc_type_support_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          const CustomDividerWidget(),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Align(
              alignment: Alignment.center,
              child: CustomText(
                S.current.kyc_security_tips_text,
                textColorStyle: CustomTextColorStyle.normal,
              )),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            title: S.current.button_save_text,
          ),
        ],
      ),
    );
  }
}
