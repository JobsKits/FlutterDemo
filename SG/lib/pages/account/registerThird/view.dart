import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/registerThird/logic.dart';
import 'package:flutter_bet/pages/account/widgets/password_tips_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_check_box.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

const String kRegisterThirdWidget = 'kRegisterThirdWidget';

class RegisterThirdWidget extends StatelessWidget {
  final controller = Get.put(RegisterThirdController());
  int webViewScrollY = 0;
  InAppWebViewController? webViewController;
  double webViewHeight = 350;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              color: Colors.transparent,
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(bottom: AppValues.largeMargin),
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                    color: ThemeService().theme.scaffoldBackgroundColor,
                  ),
                  child: Obx(() => Column(
                        children: [
                          _buildTop(),
                          controller.isNextPage.value
                              ? _buildTextBody(context)
                              : _buildBody(context),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomText(
            // "${S.current.random_text_8}${S.current.create_account_title}",
            S.current.create_account_title,
            textColorStyle: CustomTextColorStyle.normal,
            style: ThemeService().textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Obx(() {
            return CustomMainTextField(
                title: S.current.please_input_user_name_tips,
                text: controller.userNameText,
                required: true,
                showError: controller.isUserNameError.value,
                errorText: controller.userNameErrorText.value,
                inputCompletionCallBack: (String value, bool isSubmitted) =>
                    controller.onUserNameCheck(context, value),
                inputCallBack: (value) => controller.onInputUerName(value));
          }),
          Obx(() {
            return Visibility(
                visible: controller.isNotEmail.value,
                child: Container(
                  padding: const EdgeInsets.only(top: AppValues.defaultPadding),
                  child: CustomMainTextField(
                      title: S.current.email_address_text,
                      required: true,
                      text: controller.emailText,
                      showError: controller.isEmailError.value,
                      errorText: controller.emailErrorText.value,
                      keyboardType: TextInputType.emailAddress,
                      inputCompletionCallBack: (String value, bool isSubmitted) =>
                          controller.onEmailCheck(context, value),
                      inputCallBack: (value) => controller.onInputEmail(value)),
                ));
          }),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          Obx(() {
            return CustomMainTextField(
              title: S.current.binding_bank_card_please_enter + S.current.random_text_670,
              text: controller.passwordText,
              required: true,
              showError: controller.isPasswordError.value,
              errorText: controller.passwordErrorText.value,
              isPwd: true,
              inputCallBack: (value) => controller.onInputCompletionPassword(value),
              getFocusNodeCallBack: () => controller.clickPasswordField(),
              inputCompletionCallBack: (value, isSubmit) =>
                  controller.onInputCompletionPassword(value),
            );
          }),
          Obx(() {
            return Visibility(
              visible: controller.isEditPassword.value,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: AppValues.smallPadding,
                ),
                child: Column(
                  children: [
                    PassWordTipsWidget(
                      text: S.current.contains_alphabet_text,
                      isActive: controller.isContainsAlphabet.value,
                    ),
                    const SizedBox(
                      height: AppValues.smallPadding,
                    ),
                    PassWordTipsWidget(
                      text: S.current.contains_one_more_number_text,
                      isActive: controller.isContainsNumber.value,
                    ),
                    const SizedBox(
                      height: AppValues.smallPadding,
                    ),
                    PassWordTipsWidget(
                      text: S.current.least_character_text(8),
                      isActive: controller.isEightPassword.value,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            // title: S.current.reg_next,
            title: S.current.start_game_text,
            onTap: (buttonCtr) => controller.onNextPage(context,buttonCtr),
            colorStyle: CustomButtonColorStyle.normal,
          ),
        ],
      ),
    );
  }

  Widget _buildTextBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
                onPressed: controller.back,
                icon: const CustomIcon(
                  asset: 'assets/images/personal_center_icon/feedback_back.webp',
                  size: 18,
                )),
            const SizedBox(
              width: AppValues.defaultRadius * 2,
            ),
            CustomText(
              S.current.random_text_21,
              textColorStyle: CustomTextColorStyle.normal,
              style: ThemeService().textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
          child: Column(
            children: [
              SizedBox(
                height: webViewHeight,
                child: InAppWebView(
                  initialFile: 'assets/html/register_protocol.html',
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(transparentBackground: true),
                  ),
                  onWebViewCreated: (controller) {
                    webViewController = controller;
                  },
                  onScrollChanged: (InAppWebViewController controller, int x, int y) {
                    _checkWebVIfBottom(y);
                  },
                  onLoadStop: (controllers, url) async {
                    controller.contentHeight.value = await controllers.getContentHeight() ?? 0;
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
            child: _buildProtocol(context)),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    );
  }

  _checkWebVIfBottom(int currentY) {
    double currentPosition = currentY.toDouble();
    double bottomPosition = controller.contentHeight.value - webViewHeight;

    if (currentPosition >= bottomPosition) {
      controller.isCanClickProtocol.value = true;
    } else {
      controller.isCanClickProtocol.value = false;
    }
  }

  Widget _buildProtocol(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        GestureDetector(
          onTap: () {
            if (!controller.isCanClickProtocol.value) {
              controller.ifClickStartGame.value = true;
              return;
            }
            controller.onCheckProtocol();
          },
          child: Row(
            children: [
              Obx(() {
                return CustomCheckBox(
                  value: controller.isCheckProtocol.value,
                );
              }),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: CustomText(
                  S.current.agree_terms_text,
                  textColorStyle: CustomTextColorStyle.normal,
                  style: ThemeService().textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
        Obx(() {
          return Visibility(
            visible: !controller.isCheckProtocol.value && controller.ifClickStartGame.value,
            child: Padding(
                padding: EdgeInsets.only(top: AppValues.smallPadding),
                child: CustomErrorTipsText(text: S.current.random_text_825)),
          );
        }),
        const SizedBox(
          height: AppValues.largePadding,
        ),
        Container(
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: CustomBigMainButton(
              title: S.current.start_game_text,
              colorStyle: CustomButtonColorStyle.normal,
              onTap: (buttonCtr) {
                controller.ifClickStartGame.value = true;
                if (controller.isCheckProtocol.value) {
                  controller.onRegisterThird(context, buttonCtr);
                }
              }),
        ),
      ],
    );
  }

  Widget _buildTop() {
    return Column(
      children: [
        const SizedBox(
          height: AppValues.largePadding,
        ),
        Row(
          children: [
            const SizedBox(
              width: AppValues.defaultPadding,
            ),
            CustomText(
              '${S.current.top_register} OAuth',
              style: ThemeService().textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                RouteUtil.popView();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppValues.defaultPadding, vertical: AppValues.smallPadding),
                child: const CustomIcon(
                  asset: 'assets/images/normal/ic_normal_close.png',
                  size: 18,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
      ],
    );
  }
}

Future<void> showCustomRegisterThirdWidget<T>({
  required BuildContext context,
  bool barrierDismissible = false,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kRegisterThirdWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return WillPopScope(
            onWillPop: () async => false, // 不允许按返回键关闭对话框
            child: RegisterThirdWidget());
      });
}
