import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'logic.dart';

const String kEmailVerifyWidget = 'kEmailVerifyWidget';

class EmailVerifyWidget extends StatelessWidget {
  final controller = Get.put(EmailVerifyController());
  final String password;

  EmailVerifyWidget({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
              onTap: () => RouteUtil.popView(),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultPadding),
                  margin: const EdgeInsets.symmetric(
                      horizontal: AppValues.defaultPadding),
                  decoration: BoxDecoration(
                    color: ThemeService().theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  ),
                  child: Column(
                    children: [
                      _buildTop(),
                      _buildBody(context),
                      _buildBottom(context)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Column(
      children: [
        // SizedBox(height:AppValues.defaultPadding,),
        Obx(() {
          return CustomBigMainButton(
            title: S.current.confirm_button_text,
            colorStyle: CustomButtonColorStyle.tertiary,
            isEnable: controller.buttonEnable.value,
            onTap: (btnCtr) => controller.onSubmit(context, btnCtr,password),
          );
        }),
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.5),
      child: Column(
        children: [
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          PinCodeTextField(
            cursorColor: ThemeService().colorScheme.tertiary,
            autoFocus: true,
            length: 6,
            obscureText: false,
            cursorWidth: 1,
            animationType: AnimationType.fade,
            textStyle: ThemeService().textTheme.titleLarge,
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              fieldHeight: 40.w,
              fieldWidth: 40.w,
              selectedFillColor: ThemeService().colorScheme.surface,
              inactiveFillColor: ThemeService().colorScheme.surface,
              activeFillColor: Colors.transparent,
              borderWidth: 2,
              borderRadius: BorderRadius.circular(AppValues.smallRadius),
              activeColor: ThemeService().colorScheme.tertiary,
              selectedColor: ThemeService().colorScheme.tertiary,
              inactiveColor: ThemeService().colorScheme.tertiary,
              disabledColor: ThemeService().colorScheme.tertiary,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            keyboardType: TextInputType.number,
            // controller: controller.text2EditingController,
            appContext: context,
            onChanged: (String value) => controller.onInputCode(value),
          ),
        ],
      ),
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
        SizedBox(
          height: 22,
          child: Row(
            children:  [
              const CustomIcon(asset: 'assets/images/setup/ic_email_check.png'),
              const SizedBox(
                width: AppValues.smallPadding,
              ),
              CustomText(S.current.setup_pay_password_button_text),
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        const CustomDividerWidget(),
      ],
    );
  }
}

Future<void> showEmailVerifyWidget<T>({
  required BuildContext context,
  required String password,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kEmailVerifyWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) => EmailVerifyWidget(password: password));
}
