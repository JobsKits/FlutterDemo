import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_divider_widget.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../account/ThirdPartyAuthorizationToController.dart';
import '../../account/bind_controller.dart';
import '../../setup/2FA/google/logic.dart';
import '../../setup/a_hepler/setting_biz_helper.dart';
import 'auth_widget.dart';

class GoogleAuth extends GetView<SetupGoogle2FAController> {
  final tips;

  GoogleAuth({super.key, this.tips});

  final controller = Get.put(SetupGoogle2FAController());
   final bindController = Get.put(BindController()); 

  @override
  Widget build(BuildContext context) {
    Get.lazyPut<FiatPaymentDetailsToController>(
      () => FiatPaymentDetailsToController(),
    );
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
            border: Border.all(color: ThemeService().colorScheme.tertiary, width: 1),
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            )),
            margin: const EdgeInsets.only(
                left: AppValues.margin_12, right: AppValues.margin_12, bottom: 0, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      CustomText(
                        S.current.tab_bar_title_2fa_text,
                        style: ThemeService().textTheme.titleLarge,
                        textColorStyle: CustomTextColorStyle.white,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomText(S.current.random_text_659,
                          style: ThemeService()
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: ThemeService().colorScheme.onTertiary)),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomDividerWidget(),
                      const SizedBox(
                        height: 16,
                      ),
                      _buildAuthHaveNotView(context),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
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
                      return CustomBigMainButton(
                        maxWidth: 90,
                        isEnable: controller.authHelper.buttonEnable.value,
                        title: S.current.submit_text,
                        colorStyle: CustomButtonColorStyle.tertiary,
                        onTap: (btnController) {
                          controller.globalController.isOpenVerificationAndPayPassword.value = false;
                          controller.doActionAuthSet(btnController, isRefPwConfig: true);
                        },
                      );
                    }),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
          Obx(() => bindController.checkIndex.value == 3 ? const AuthWidget() : Container())
        ],
      ),
    );
  }

  ///还没有启动验证页面
  _buildAuthHaveNotView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQrCodeView(),
        _buildInputView(),
        // _buildBottom(context),
      ],
    );
  }

  Widget _buildInputView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppValues.defaultMargin),
        //密码
        Obx(() {
          return CustomMainTextField(
            text: controller.authHelper.passwordText.value,
            title: S.current.random_text_670,
            required: true,
            showError: controller.authHelper.passwordError.value,
            errorText: controller.authHelper.passwordErrorText.value,
            isPwd: true,
            inputCallBack: (value) => controller.authHelper.onInputPassword(value, false),
            inputCompletionCallBack: (value, isSubmitted) =>
                controller.authHelper.onInputPassword(value, true),
          );
        }),
        const SizedBox(height: AppValues.defaultPadding),

        //双重验证码
        Obx(() {
          return CustomMainTextField(
            text: controller.authHelper.codeText.value,
            title: S.current.s_2fa_body_code_text,
            required: true,
            showError: controller.authHelper.codeError.value,
            errorText: controller.authHelper.codeErrorText.value,
            isPwd: false,
            // maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            inputCallBack: (value) => controller.authHelper.onInputCode(value, false),
            inputCompletionCallBack: (value, isSubmitted) =>
                controller.authHelper.onInputCode(value, true),
          );
        }),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultMargin),
        Obx(() {
          return CustomBigMainButton(
            isEnable: controller.authHelper.buttonEnable.value,
            title: S.current.submit_text,
            onTap: (btnController) {
              controller.globalController.isOpenVerificationAndPayPassword.value = false;
              controller.doActionAuthSet(btnController, isRefPwConfig: true);
            },
          );
        }),
        const SizedBox(height: 20),
      ],
    );
  }

  ///显示二维码
  _buildQrCodeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          S.current.copy_text_to_authenticator_app,
          textColorStyle: CustomTextColorStyle.normal,
        ),
        const SizedBox(height: AppValues.defaultPadding),
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(4)),
              color: ThemeService().theme.colorScheme.tertiary),
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 2),
                  child: Obx(() {
                    return CustomText(
                      // controller.getGoogleKey(),
                      controller.authSecretValueObs.value,
                      style: ThemeService().textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                    );
                  }),
                ),
              ),
              InkWell(
                onTap: () => SettingBizHelper.copyText(controller.authSecretValueObs.value),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    color: ThemeService().colorScheme.surface,
                  ),
                  child: const UnconstrainedBox(
                    child: CustomAssetIcon(
                      name: "assets/images/setup/ic_account_copy.webp",
                      size: 17,
                    ),
                  ),
                  // child: IconButton(
                  //   icon: const Icon(Icons.copy),
                  //   color: Colors.white,
                  //   onPressed: () {
                  //     // Clipboard.setData(ClipboardData(text: controller.getGoogleKey()));
                  //     AccountBizHelper.copyText(controller.authSecretObs.value);
                  //   },
                  // ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Column(
          children: [
            CustomText(
              S.current.prevent_other_people_look,
              textColorStyle: CustomTextColorStyle.normal,
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),

            // QrImageView(
            //   data: controller.getGoogleKey(),
            //   size: 160,
            //   backgroundColor: Colors.white,
            // ),

            Container(
              height: 120,
              width: 120,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              // margin: const EdgeInsets.all(6),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: QrImageView(
                // size: 100,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
                // data: controller.authSecretValueObs.value,
                data: controller.getQrUrl(),
              ),
              // CustomNetWorkImage(
              //     imageUrl:
              //         "https://support.content.office.net/zh-cn/media/0fe67add-a793-408e-ae9b-f98f80841480.png"),
            ),
          ],
        ),
      ],
    );
  }
}
