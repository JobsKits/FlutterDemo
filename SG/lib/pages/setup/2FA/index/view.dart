import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'logic.dart';

class Setup2FAPage extends StatelessWidget {
  final double maxHeight;

  final controller = Get.put(Setup2FAController());

  Setup2FAPage({super.key, this.maxHeight = 400});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTop(),
            _buildPassword(),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildTop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          S.current.random_text_456,
          textColorStyle: CustomTextColorStyle.normal,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          height: 1,
          color: ThemeService().colorScheme.tertiary,
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        CustomText(
          S.current.random_text_457,
          textColorStyle: CustomTextColorStyle.normal,
          maxLines: 3,
        ),
        const SizedBox(
          height: AppValues.smallPadding,
        ),
        Container(
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            color: ThemeService().colorScheme.tertiary,
          ),
          child: Row(
            children: [
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 14.5, right: 14.5),
                    child: CustomText(
                      'stake.com/?c=r123123132132123CiS8s',
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                    color: ThemeService().colorScheme.surface,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppValues.smallRadius),
                        bottomRight:
                        Radius.circular(AppValues.smallRadius))),
              )
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultRadius,
        ),
        Center(
          child: CustomText(
            S.current.random_text_458,
            textColorStyle: CustomTextColorStyle.normal,
          ),
        ),
        const SizedBox(height: AppValues.smallPadding,),
        Center(
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppValues.smallRadius),
                color: Colors.redAccent,
              ),
            )),
        const SizedBox(height: AppValues.defaultPadding,),
      ],
    );
  }

  Widget _buildBottom() {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultPadding,),
        CustomBigMainButton(title: S.current.submit_text,colorStyle: CustomButtonColorStyle.tertiary,),
        const SizedBox(height: 20,),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      children: [
        CustomMainTextField(
          title: S.current.login_text_field_password_tips,
          required: true,
          text: controller.passwordText,
          showError: controller.passwordError.value,
          isPwd: true,
          inputCallBack: (value) => controller.onInputPassword(value),
        ),
        const SizedBox(height: AppValues.defaultPadding,),
        CustomMainTextField(
          title: S.current.vault_two_step_verification,
          required: true,
          text: controller.password2Text,
          showError: controller.password2Error.value,
          isPwd: true,
          inputCallBack: (value) => controller.onInputPasswordNext(value),
        ),
      ],
    );
  }
}
