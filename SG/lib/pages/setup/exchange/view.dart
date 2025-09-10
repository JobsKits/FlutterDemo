import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SetupExchangePage extends StatelessWidget {
  final controller = Get.put(SetupExchangeController());
  final double maxHeight;

  SetupExchangePage({super.key, this.maxHeight = 400});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcome(),
            _buildAirdrop(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(S.current.offers_welcome_offer,
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: AppValues.smallPadding,
        ),
        CustomText(
          S.current.newcomer_discount_tips_text,
          textColorStyle: CustomTextColorStyle.normal,
          maxLines: 2,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),

        CustomMainTextField(
          text: '',
          required: true,
          title: S.current.redeem_code_text,
          inputCallBack: (value) => controller.onInputWelcomeCode(value),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: CustomBigMainButton(
            title: S.current.submit_text,
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          height: 1,
          color: ThemeService().colorScheme.tertiary,
        ),
      ],
    );
  }

  Widget _buildAirdrop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        CustomText(S.current.redeem_bonus_text,
            style: ThemeService()
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          height: AppValues.smallPadding,
        ),
        CustomText(
          S.current.redeem_bonus_tips_text,
          textColorStyle: CustomTextColorStyle.normal,
          maxLines: 3,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),

        CustomMainTextField(
          text: '',
          required: true,
          title: S.current.redeem_code_text,
          inputCallBack: (value) => controller.onInputWelcomeCode(value),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
         Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
          child: CustomBigMainButton(
            title: S.current.submit_text,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
