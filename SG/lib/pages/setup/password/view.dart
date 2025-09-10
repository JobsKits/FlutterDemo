import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';

import 'logic.dart';

///修改资金密码界面
class ModifyPasswordPage extends StatelessWidget {
  ModifyPasswordPage({super.key, this.maxHeight = 500});

  final double maxHeight;

  // TODO: implement controller
  final controller = Get.put(ModifyPasswordLogic());

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: maxHeight),
      margin: const EdgeInsets.only(bottom: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeService().colorScheme.surface,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10, vertical: AppValues.defaultMargin),
          child:  Obx(() {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              changedPasswordView(context),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              if (controller.isShowEditPwd.value)
                (controller.bindIndex.value == 0 && !controller.isBindEmail.value) || (controller.bindIndex.value == 1 && !controller.isBindPhone.value) || (controller.bindIndex.value == 2 && !controller.isBindEmail.value && !controller.isBindPhone.value) ? _notBindEmailView() : changedMoneyPassword(context),
              // if (controller.isShowEditPwd.value)
              //   const SizedBox(
              //     height: AppValues.defaultPadding,
              //   ),
            ],
          );
        }))
      ),
    );
  }

  ///修改密码界面
  changedPasswordView(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          color: ThemeService().theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      // padding: const EdgeInsets.all(AppValues.defaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 28,
                ),
                Row(
                  children: [
                    CustomText(
                      S.current.random_text_670,
                      style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                CustomMainTextField(
                  title: S.current.old_password_text,
                  text: controller.oldPasswordText.value,
                  showError: controller.oldPasswordError.value,
                  errorText: controller.oldPasswordErrorText.value,
                  hintText: S.current.old_password_text,
                  isPwd: true,
                  required: true,
                  inputCallBack: (str) => controller.onInputOldPassword(str, false),
                  inputCompletionCallBack: (value, isSubmitted) =>
                      {controller.onInputOldPassword(value, true)},
                ),
                const SizedBox(
                  height: AppValues.defaultMargin,
                ),
                CustomMainTextField(
                  title: S.current.new_password_text,
                  text: controller.newPasswordText.value,
                  showError: controller.newPasswordError.value,
                  errorText: controller.newPasswordErrorText.value,
                  hintText: S.current.new_password_text,
                  isPwd: true,
                  required: true,
                  inputCallBack: (str) => controller.onInputNewPassword(str, false),
                  inputCompletionCallBack: (value, isSubmitted) =>
                      controller.onInputNewPassword(value, true),
                ),
                const SizedBox(
                  height: AppValues.defaultMargin,
                ),
                CustomMainTextField(
                  title: S.current.confirm_new_password_text,
                  text: controller.newPassword2Text.value,
                  required: true,
                  showError: controller.newPassword2Error.value,
                  errorText: controller.newPassword2ErrorText.value,
                  hintText: S.current.confirm_new_password_text,
                  isPwd: true,
                  inputCallBack: (str) => controller.onInputNewPasswordNext(str, false),
                  inputCompletionCallBack: (value, isSubmitted) =>
                      controller.onInputNewPasswordNext(value, true),
                ),
                const SizedBox(
                  height: AppValues.defaultMargin,
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: ThemeService().colorScheme.tertiary,
          ),
          const SizedBox(
            height: AppValues.defaultMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomBigMainButton(
                title: S.current.button_save_text,
                isEnable:controller.isEnableSaveButton.value,
                maxWidth: 100,
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (btnCtr) => controller.onSubmit(context, btnCtr),
              ),
              const SizedBox(width: 20,),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultMargin,
          ),
        ],
      ),
    );
  }

  ///修改资金密码
  changedMoneyPassword(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          color: ThemeService().theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(AppValues.smallRadius)),
      // padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 28,
                ),
                Row(
                  children: [
                    Obx(() => CustomText(
                      controller.isEditPwd.value ? S.current.change_fund_password : S.current.wallet_fundPassword,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    )),
                  ],
                ),
                const SizedBox(
                  height: 28,
                ),
                // const SizedBox(
                //   height: AppValues.extraSmallPadding,
                // ),
                // CustomText(controller.isEditPwd.value
                //     ? S.current.change_fund_password
                //     : S.current.set_fund_password),
                // const SizedBox(
                //   height: AppValues.defaultPadding,
                // ),
                Visibility(
                    visible: controller.isEditPwd.value,
                    child: CustomMainTextField(
                      title: S.current.original_fund_password,
                      text: controller.oldMoneyPasswordText.value,
                      showError: controller.oldMoneyPasswordError.value,
                      errorText: controller.oldMoneyPasswordErrorText.value,
                      hintText: S.current.original_fund_password,
                      maxLength: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      isPwd: true,
                      required: true,
                      inputCallBack: (value) => controller.onInputMoneyOldPassword(value, false),
                      inputCompletionCallBack: (value, isSubmitted) =>
                          controller.onInputMoneyOldPassword(value, true),
                    )),
                Visibility(
                    visible: controller.isEditPwd.value,
                    child: const SizedBox(
                      height: AppValues.defaultPadding,
                    )),
                // const SizedBox(
                //   height: AppValues.defaultPadding,
                // ),
                Obx(() => CustomMainTextField(
                  title: controller.isEditPwd.value ? S.current.random_text_877 : S.current.wallet_fundPassword,
                  text: controller.newMoneyPasswordText.value,
                  showError: controller.newMoneyPasswordError.value,
                  errorText: controller.newMoneyPasswordErrorText.value,
                  hintText: controller.isEditPwd.value ? S.current.random_text_877 : S.current.wallet_fundPassword,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  isPwd: true,
                  required: true,
                  inputCallBack: (value) => controller.onInputMoneyNewPassword(value, false),
                  inputCompletionCallBack: (value, isSubmitted) =>
                      controller.onInputMoneyNewPassword(value, true),
                )),
                const SizedBox(
                  height: AppValues.defaultPadding,
                ),
                CustomMainTextField(
                  controller: TextEditingController(),
                  title: S.current.confirm_fund_password,
                  text: controller.newMoneyPassword2Text.value,
                  required: true,
                  maxLength: 6,
                  showError: controller.newMoneyPassword2Error.value,
                  errorText: controller.newMoneyPassword2ErrorText.value,
                  hintText: S.current.confirm_fund_password,
                  isPwd: true,
                  keyboardType: TextInputType.number,
                  inputCallBack: (value) {
                    controller.newMoneyPassword2Text.value = value;
                    if (value?.length == 6) {
                      controller.isEnableCodeBtn.value = true;
                    } else {
                      controller.isEnableCodeBtn.value = false;
                    }
                    controller.onInputMoneyNewPasswordNext(value, false);
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  inputCompletionCallBack: (value, isSubmitted) =>
                      controller.onInputMoneyNewPasswordNext(value, true),
                ),
                Obx(() => Visibility(
                  visible: controller.bindIndex.value != 3,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppValues.defaultPadding,
                      ),
                      Row(
                        children: [
                          Obx(() => RichText(
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(children: [
                            TextSpan(
                              text: controller.showPhone.value ? S.current.random_text_1115 : S.current.email_verification_code,
                              style: ThemeService().textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500, color: CustomTextColorStyle.normal.value),
                            ),
                            TextSpan(
                                text: '*',
                                style: ThemeService().textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500, color: AppThemes.reverseStateColor)),
                          ]))),
                        ],
                      ),
                      const SizedBox(
                        height: AppValues.defaultPadding / 2,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomMainTextField(
                              text: controller.verCodeText.value,
                              hintText: S.current.random_text_1162,
                              maxLength: 6,
                              keyboardType: TextInputType.number,
                              required: true,
                              inputCallBack: (value) => controller.onInputMoneyVerificationCode(value, false),
                              inputCompletionCallBack: (value, isSubmitted) =>
                                  controller.onInputMoneyVerificationCode(value, true),
                            ),
                          ),
                          const SizedBox(
                            width: AppValues.halfPadding,
                          ),
                          Container(
                            height: 40,
                            child: Obx(() => CustomBigMainButton(
                                  title: controller.verCodeBtnText.value,
                                  maxWidth: getBtnWidth(),
                                  isEnable: controller.isEnableCodeBtn.value,
                                  onTap: (btnCtr) => controller.getVerCode(context, btnCtr),
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppValues.smallPadding,
                      ),
                      Visibility(
                          visible: controller.verCodeError.value,
                          child: CustomErrorTipsText(text: controller.verCodeErrorText.value)),
                      Obx(() => Visibility(
                        visible: controller.showTitle.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppValues.halfPadding),
                          child: Row(
                            children: [
                              Obx(() => CustomText(controller.showPhone.value ? S.current.random_text_1116 : S.current.random_text_1117, style: const TextStyle(color: AppThemes.textColorSecondary,fontWeight: FontWeight.w500),)),
                              GestureDetector(
                                onTap: () => controller.showPhone(!controller.showPhone.value),
                                child: Obx(() => CustomText(controller.showPhone.value ? S.current.random_text_1118 : S.current.random_text_1119, style: const TextStyle(fontWeight: FontWeight.w600),))
                              ),
                            ],
                          ),
                        )
                      )),
                    ],
                  )
                )),
                const SizedBox(
                  height: AppValues.defaultMargin,
                ),
              ],
            ),
          ),
          Visibility(visible:controller.isEditPwd.value,child: _textRich()),
          Container(
            height: 2,
            color: ThemeService().colorScheme.tertiary,
          ),
          const SizedBox(
            height: AppValues.defaultMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomBigMainButton(
                title: S.current.button_save_text,
                colorStyle: CustomButtonColorStyle.tertiary,
                maxWidth: 100,
                onTap: (btnCtr) => controller.onMoneySubmit(context, btnCtr),
              ),
              const SizedBox(width: 20,),
            ],
          ),
          const SizedBox(
            height: AppValues.defaultMargin,
          ),
        ],
      ),
    );
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

  _notBindEmailView() {
    return Container(
        width: double.infinity,
        // height: 158,
        decoration: BoxDecoration(
            border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
            color: ThemeService().theme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(AppValues.smallRadius)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 28,
            ),
            Obx(() => CustomText(
              controller.isEditPwd.value ? S.current.change_fund_password : S.current.wallet_fundPassword,
              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
            )),
            const SizedBox(
              height: 28,
            ),
            Obx(() =>  CustomText(
              controller.bindIndex.value == 2 ? S.current.random_text_1204 : controller.bindIndex.value == 1 ? S.current.random_text_1205 : S.current.random_text_678,
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppThemes.onTertiaryColor),
            )),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            SizedBox(
              width: double.infinity,
              height: 20,
              child: Center(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: controller.goToBind,
                  child: CustomText(
                    S.current.go_to_Binding,
                    style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                          color: CustomButtonColorStyle.normal.backgroundColor,
                          decoration: TextDecoration.underline,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: AppValues.largeMargin,
            ),
          ],
        ));
  }

  ///根据语言显示按钮宽度
  double getBtnWidth() {
    if (controller.globalController.langType.value == 1) {
      return 120;
    } else if (controller.globalController.langType.value == 2) {
      return 180;
    } else if (controller.globalController.langType.value == 3) {
      return 220;
    } else if (controller.globalController.langType.value == 4) {
      return 150;
    } else if (controller.globalController.langType.value == 5) {
      return 150;
    } else {
      return 120;
    }
  }
}
