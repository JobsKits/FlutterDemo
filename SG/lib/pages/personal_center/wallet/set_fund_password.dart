import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/personal_center/wallet/auth_widget.dart';
import 'package:flutter_bet/pages/setup/password/logic.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:get/get.dart';

import '../../../app/modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/vault_util.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../account/ThirdPartyAuthorizationToController.dart';
import '../../account/bind_controller.dart';

class FundPassword extends GetView<ModifyPasswordLogic> {
  final tips;
  final bool isVault;

  FundPassword({super.key, this.tips, this.isVault = false});

  final controller = Get.put(ModifyPasswordLogic());
  final bindController = Get.put(BindController()); 

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FiatPaymentDetailsToController>(
      () => FiatPaymentDetailsToController(),
    );
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 16, left: 0, right: 0),
          decoration: BoxDecoration(
              border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              )),
          margin: const EdgeInsets.only(
              left: AppValues.margin_12, right: AppValues.margin_12, bottom: 0, top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      S.current.wallet_fundPassword,
                      style: ThemeService().textTheme.titleLarge,
                      textColorStyle: CustomTextColorStyle.white,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomText(S.current.random_text_658,
                        style: ThemeService()
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: ThemeService().colorScheme.onTertiary)),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Container(
                      height: 2,
                      color: ThemeService().colorScheme.tertiary,
                    ),
                    const SizedBox(
                      height: AppValues.defaultMargin,
                    ),
                    Obx(() {
                      return CustomMainTextField(
                        title: S.current.wallet_fundPassword,
                        text: controller.newMoneyPasswordText.value,
                        hintText: S.current.wallet_fundPassword,
                        showError: controller.newMoneyPasswordError.value,
                        errorText: controller.newMoneyPasswordErrorText.value,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        isPwd: true,
                        required: true,
                        inputCallBack: (value) => controller.onInputMoneyNewPassword(value, false),
                        inputCompletionCallBack: (value, isSubmitted) =>
                            controller.onInputMoneyNewPassword(value, true),
                      );
                    }),
                    const SizedBox(
                      height: AppValues.defaultPadding,
                    ),
                    Obx(() {
                      return CustomMainTextField(
                        title: S.current.confirm_fund_password,
                        text: controller.newMoneyPassword2Text.value,
                        hintText: S.current.confirm_fund_password,
                        required: true,
                        maxLength: 6,
                        showError: controller.newMoneyPassword2Error.value,
                        errorText: controller.newMoneyPassword2ErrorText.value,
                        isPwd: true,
                        keyboardType: TextInputType.number,
                        inputCallBack: (value) {
                          controller.newMoneyPassword2Text.value = value;
                          if (value.length == 6) {
                            controller.isEnableCodeBtn.value = true;
                          } else {
                            controller.isEnableCodeBtn.value = false;
                          }
                          controller.onInputMoneyNewPasswordNext(value, false);
                        },
                        inputCompletionCallBack: (value, isSubmitted) =>
                            controller.onInputMoneyNewPasswordNext(value, true),
                      );
                    }),
                    const SizedBox(
                      height: AppValues.defaultPadding,
                    ),
                    Obx(() {
                      return Visibility(
                        visible: bindController.bindIndex.value != 3,
                        child: CustomAsterisksTipsText(
                          text: bindController.showPhone.value
                              ? S.current.random_text_1115
                              : S.current.email_verification_code,
                        ),
                      );
                    }),
                    Obx(() => Visibility(
                      visible: bindController.bindIndex.value != 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Obx(() => CustomMainTextField(
                                  text: controller.verCodeText.value,
                                  hintText: S.current.random_text_1162,
                                  showError: controller.verCodeError.value,
                                  errorText: controller.verCodeErrorText.value,
                                  maxLength: 6,
                                  keyboardType: TextInputType.number,
                                  required: true,
                                  inputCallBack: (value) =>
                                      controller.onInputMoneyVerificationCode(value, false),
                                  inputCompletionCallBack: (value, isSubmitted) =>
                                      controller.onInputMoneyVerificationCode(value, true),
                                )),
                          ),
                          const SizedBox(
                            width: AppValues.halfPadding,
                          ),
                          SizedBox(
                            height: AppValues.defaultTextHeight,
                            child: Obx(() => CustomBigMainButton(
                                  title: controller.verCodeBtnText.value,
                                  maxWidth: getBtnWidth(),
                                  isEnable: controller.isEnableCodeBtn.value,
                                  colorStyle: !controller.isEnableCodeBtn.value &&
                                          controller.verCodeBtnText.value !=
                                              S.current.get_verification_code
                                      ? CustomButtonColorStyle.secondaryIcon
                                      : CustomButtonColorStyle.normal,
                                  onTap: (btnCtr) => controller.getVerCode(context, btnCtr),
                                )),
                          ),
                        ],
                      ),
                    )),
                    Obx(() => Visibility(
                        visible: bindController.showTitle.value,
                        child: Padding(
                          padding: const EdgeInsets.only(top: AppValues.defaultMargin),
                          child: Row(
                            children: [
                              Expanded(
                                child: Obx(() => Text.rich(TextSpan(
                                  children: [
                                    TextSpan(
                                      text: S.current.random_text_1035,
                                      style: const TextStyle(
                                          color: AppThemes.textColorSecondary,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    TextSpan(
                                      text: bindController.showPhone.value
                                              ? S.current.random_text_1118
                                              : S.current.random_text_1119,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                      recognizer: TapGestureRecognizer()..onTap =() => bindController.showPhone(!bindController.showPhone.value),
                                    ),
                                  ]
                                ))),
                              ),
                            ],
                          ),
                        ))),
                    const SizedBox(
                      height: AppValues.defaultPadding,
                    ),
                  ],
                ),
              ),
              Container(
                height: 2,
                color: ThemeService().colorScheme.tertiary,
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() {
                    return Visibility(
                        visible: bindController.bindIndex.value == 1 || (bindController.bindIndex.value == 2 && bindController.showPhone.value),
                        child: GestureDetector(
                          onTap: () => controller.getVerCodeText(context),
                          child: CustomText(
                            S.current.resend_email_text,
                            textColorStyle: controller.isEnableCodeBtn.value
                                ? CustomTextColorStyle.white
                                : CustomTextColorStyle.normal,
                          ),
                        ));
                  }),
                  const SizedBox(
                    width: 20,
                  ),
                  Obx(() => CustomBigMainButton(
                    maxWidth: 90,
                    title: isVault ? S.current.button_save_text : S.current.submit_text,
                    isEnable:controller.payButtonEnable.value,
                    colorStyle: CustomButtonColorStyle.tertiary,
                    onTap: (btnCtr) =>
                        controller.onMoneySubmit(context, btnCtr, isRefPwConfig: true),
                  )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        Obx(() {
          return isVault
              ? (VaultUtil.isSecretNot()
                  ? AuthWidget(
                      tips: S.current.random_text_598,
                    )
                  : CupertinoButton(
                      onPressed: () {
                        VaultDescriptionsView.openPage();
                      },
                      child: Center(
                          child: CustomText(
                        S.current.random_text_598,
                        textColorStyle: CustomTextColorStyle.normal,
                      ))))
              : Visibility(visible: VaultUtil.isSecretNot(), child: AuthWidget(tips: S.current.random_text_598,));
        }),
      ],
    );
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
