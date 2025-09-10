import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'logic.dart';

///设置资金密码
class SetupPay2FAPage extends StatelessWidget {
  final controller = Get.put(SetupPay2FAController());

  @override
  Widget build(BuildContext context) {
    //TODO: implement build
    return Obx(() => Container(
        constraints: const BoxConstraints(minHeight: 600),
        child: controller.isBindEmail.value
            ? notBindEmailView()
            : Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const SizedBox(
                    height: AppValues.extraSmallPadding,
                  ),
                  CustomText(controller.isEditPwd.value
                      ? S.current.change_fund_password
                      : S.current.set_fund_password),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  Visibility(
                      visible: controller.isEditPwd.value,
                      child: CustomMainTextField(
                        title: S.current.original_fund_password,
                        text: controller.oldPasswordText.value,
                        showError: controller.oldPasswordError.value,
                        errorText: controller.oldPasswordErrorText.value,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        isPwd: true,
                        required: true,
                        inputCallBack: (value) => controller.onInputOldPassword(value,false),
                        inputCompletionCallBack: (value, isSubmitted) =>
                            controller.onInputOldPassword(value,true),
                      )),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  CustomMainTextField(
                    title: S.current.wallet_fundPassword,
                    text: controller.newPasswordText.value,
                    showError: controller.newPasswordError.value,
                    errorText: controller.newPasswordErrorText.value,
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    isPwd: true,
                    required: true,
                    inputCallBack: (value) => controller.onInputNewPassword(value,false),
                    inputCompletionCallBack: (value, isSubmitted) =>
                        controller.onInputNewPassword(value,true),
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  CustomMainTextField(
                    title: S.current.confirm_fund_password,
                    text: controller.newPassword2Text.value,
                    required: true,
                    maxLength: 6,
                    showError: controller.newPassword2Error.value,
                    errorText: controller.newPassword2ErrorText.value,
                    isPwd: true,
                    keyboardType: TextInputType.number,
                    inputCallBack: (value) {
                      controller.newPassword2Text.value = value;
                      if (value?.length == 6) {
                        controller.isEnableCodeBtn.value = true;
                      } else {
                        controller.isEnableCodeBtn.value = false;
                      }
                      controller.onInputNewPasswordNext(value,false);
                    },
                    inputCompletionCallBack: (value, isSubmitted) =>
                        controller.onInputNewPasswordNext(value,true),
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: CustomMainTextField(
                          title: S.current.email_verification_code,
                          text: controller.verCodeText.value,
                          showError: controller.verCodeError.value,
                          errorText: controller.verCodeErrorText.value,
                          maxLength: 6,
                          keyboardType: TextInputType.number,
                          required: true,
                          inputCallBack: (value) => controller.onInputVerificationCode(value,false),
                          inputCompletionCallBack: (value, isSubmitted) =>
                              controller.onInputVerificationCode(value,true),
                        ),
                      ),
                      const SizedBox(
                        width: AppValues.halfPadding,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 20.h),
                        height: 60,
                        child: Obx(() => CustomBigMainButton(
                              title: controller.verCodeBtnText.value,
                              maxWidth: 114,
                              isEnable: controller.isEnableCodeBtn.value,
                              onTap: (btnCtr) => controller.getVerCode(context, btnCtr),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppValues.defaultPadding,
                  ),
                  CustomBigMainButton(
                    title: S.current.submit_text,
                    onTap: (btnCtr) => controller.onSubmit(context, btnCtr),
                  ),
                  const SizedBox(
                    height: AppValues.marginBelowVerticalLine,
                  ),
                  Visibility(visible:controller.isEditPwd.value,child: _textRich())
                ],
              )));
    // return Container(
    //   child: SingleChildScrollView(
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         _buildTop(),
    //         _buildCode(context),
    //         _buildBottom(context),
    //       ],
    //     ),
    //   ),
    // );
  }

  Widget _textRich() {
    return Container(
      margin: const EdgeInsets.all(AppValues.defaultMargin),
      alignment: Alignment.center,
      child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: S.current.forgot_your_fund_password_go_to,
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: CustomTextColorStyle.normal.value),
            ),
            TextSpan(text: LangUtil().isZhCn()?'':'\n'),
            TextSpan(
              text: S.current.contact_customer_service,
              recognizer: TapGestureRecognizer()..onTap = controller.customerService,
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: CustomButtonColorStyle.normal.backgroundColor),
            ),
          ]))
    );
  }

  notBindEmailView() {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.extraLargeSpacing,
        ),
        CustomText(
          S.current.you_have_not_bound_your_email,
          style: ThemeService()
              .theme
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomTextColorStyle.grey.value),
        ),
        const SizedBox(
          height: AppValues.largeMargin,
        ),
        CustomText(
          S.current.first_and_then_set_the_password,
          style: ThemeService()
              .theme
              .textTheme
              .bodyMedium
              ?.copyWith(color: CustomTextColorStyle.grey.value),
        ),
        const SizedBox(
          height: AppValues.margin_40,
        ),
        CupertinoButton(
          onPressed: controller.goToBind,
          child: CustomText(
            S.current.go_to_Binding,
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: CustomButtonColorStyle.normal.backgroundColor),
          ),
        ),
      ],
    );
  }

// Widget _buildTop() {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       CustomText(
//         S.current.setup_pay_password_title_text,
//         textColorStyle: CustomTextColorStyle.normal,
//       ),
//       const SizedBox(height: AppValues.defaultPadding,),
//       const CustomDividerWidget(),
//     ],
//   );
// }
//
// Widget _buildCode(BuildContext context) {
//   // final fieldWidth = (Get.width - (AppValues.defaultPadding * 4) -(14 * 5)) / 6;
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       const SizedBox(height: AppValues.defaultPadding,),
//       CustomAsterisksTipsText(text: S.current.login_text_field_password_tips,),
//       const SizedBox(height: AppValues.smallPadding,),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.5),
//         child: PinCodeTextField(
//           cursorColor: ThemeService().colorScheme.tertiary,
//           autoFocus: false,
//           length: 6,
//           obscureText: true,
//           cursorWidth: 1,
//           animationType: AnimationType.fade,
//           textStyle: ThemeService().textTheme.titleLarge,
//           pinTheme: PinTheme(
//             shape: PinCodeFieldShape.box,
//             fieldHeight: 40.w,
//             fieldWidth: 40.w,
//             selectedFillColor: ThemeService().colorScheme.surface,
//             inactiveFillColor: ThemeService().colorScheme.surface,
//             activeFillColor: Colors.transparent,
//             borderWidth: 2,
//             borderRadius: BorderRadius.circular(AppValues.smallRadius),
//             activeColor: ThemeService().colorScheme.tertiary,
//             selectedColor: ThemeService().colorScheme.tertiary,
//             inactiveColor: ThemeService().colorScheme.tertiary,
//             disabledColor: ThemeService().colorScheme.tertiary,
//
//           ),
//           animationDuration: const Duration(milliseconds: 300),
//           backgroundColor: Colors.transparent,
//           enableActiveFill: true,
//           keyboardType: TextInputType.number,
//           // controller: controller.textEditingController,
//           appContext: context,
//           onChanged: (String value) => controller.onInputPassword(value),
//
//         ),
//       ),
//       // const SizedBox(height: AppValues.defaultPadding,),
//       CustomAsterisksTipsText(text: S.current.confirm_password,),
//       const SizedBox(height: AppValues.smallPadding,),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.5),
//         child: PinCodeTextField(
//           cursorColor: ThemeService().colorScheme.tertiary,
//           autoFocus: false,
//           length: 6,
//           obscureText: true,
//           cursorWidth: 1,
//           animationType: AnimationType.fade,
//           textStyle: ThemeService().textTheme.titleLarge,
//           pinTheme: PinTheme(
//             shape: PinCodeFieldShape.box,
//             fieldHeight: 40.w,
//             fieldWidth: 40.w,
//             selectedFillColor: ThemeService().colorScheme.surface,
//             inactiveFillColor: ThemeService().colorScheme.surface,
//             activeFillColor: Colors.transparent,
//             borderWidth: 2,
//             borderRadius: BorderRadius.circular(AppValues.smallRadius),
//             activeColor: ThemeService().colorScheme.tertiary,
//             selectedColor: ThemeService().colorScheme.tertiary,
//             inactiveColor: ThemeService().colorScheme.tertiary,
//             disabledColor: ThemeService().colorScheme.tertiary,
//
//           ),
//           animationDuration: const Duration(milliseconds: 300),
//           backgroundColor: Colors.transparent,
//           enableActiveFill: true,
//           keyboardType: TextInputType.number,
//           appContext: context,
//           onChanged: (String value) => controller.onInputPasswordNext(value),
//         ),
//       ),
//       Obx(() {
//         return Visibility(
//           visible: controller.password2Error.value,
//           child: Padding(
//             padding: const EdgeInsets.only(top: AppValues.smallPadding),
//             child: CustomErrorTipsText(
//               text: controller.password2Text ?? '',
//             ),
//           ),
//         );
//       })
//     ],
//   );
// }
//
// Widget _buildBottom(BuildContext context) {
//   return Obx(() {
//     return Column(
//       children: [
//         const SizedBox(height: AppValues.defaultPadding,),
//         CustomBigMainButton(title: S.current.setup_pay_password_button_text,
//           colorStyle: CustomButtonColorStyle.tertiary,
//           isEnable: controller.buttonEnable.value,
//           onTap: (btnCtr) => controller.onSubmit(context, btnCtr),),
//         const SizedBox(height: 20,),
//       ],
//     );
//   });
// }
}
