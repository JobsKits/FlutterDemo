import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_divider_widget.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/cell/custom_tooltip_widget.dart';
import '../../../../widget/custom_bubble.dart';
import '../../a_hepler/setting_biz_helper.dart';
import 'logic.dart';

class SetupGoogle2FAPage extends StatelessWidget {
  final controller = Get.put(SetupGoogle2FAController());
  final GlobalKey _globalKeyCopy = GlobalKey();
  final GlobalKey _globalKeyTip = GlobalKey();

  SetupGoogle2FAPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Obx(() => !controller.isOpenVerification.value
          ? _buildAuthHaveNotView(context)
          : _buildAuthAlreadyView(context)),
    );
  }

  ///还没有启动验证页面
  _buildAuthHaveNotView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeService().colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10, vertical: AppValues.defaultMargin),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            color: ThemeService().theme.scaffoldBackgroundColor,
            border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTop(),
                    _buildQrCodeView(),
                    _buildInputView(),
                  ],
                ),
              ),
              _buildBottom(context),
            ],
          )
        )
      )
    );
  }

  ///已启动验证页面
  _buildAuthAlreadyView(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 38),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ThemeService().colorScheme.surface,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.padding_10, vertical: AppValues.defaultMargin),
        child: Container(
          // padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
            color: ThemeService().theme.scaffoldBackgroundColor,
            border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTopAlready(),
                    _buildInputViewAlready(),
                  ],
                ),
              ),
              _buildBottomAlready(context),
            ],
          )
        )
      )
    );
  }

  Widget _buildTop() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 28,
        ),
        Row(
          children: [
            CustomText(
              S.current.tab_bar_title_2fa_text,
              style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(
          height: 28,
        ),
        CustomText(
          S.current.s_2fa_body_tips_text,
          textColorStyle: CustomTextColorStyle.normal,
        ),
        const SizedBox(height: AppValues.defaultMargin),
        const CustomDividerWidget(),
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
        const SizedBox(height: AppValues.defaultMargin),

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
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
        Container(
          height: 2,
          color: ThemeService().colorScheme.tertiary,
        ),
        const SizedBox(height: AppValues.defaultMargin),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomBigMainButton(
              isEnable: controller.authHelper.buttonEnable.value,
              title: S.current.submit_text,
              maxWidth: 100,
              colorStyle: CustomButtonColorStyle.tertiary,
              onTap: (btnController) {
                controller.doActionAuthSet(btnController);
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: AppValues.defaultMargin),
      ],
    );
  }

  ///显示二维码
  _buildQrCodeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppValues.defaultMargin),
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: CustomText(
                    // controller.getGoogleKey(),
                    controller.authSecretValueObs.value,
                    style: ThemeService().textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
              ),
              //复制小图标
              CustomTooltipWidget(
                padding: EdgeInsets.zero,
                verticalOffset: 10,
                decoration: const BoxDecoration(color: Colors.transparent),
                richMessage: WidgetSpan(
                  // alignment: PlaceholderAlignment.bottom,
                  // child: _buildTipContentView(S.current.random_text_799, _globalKeyCopy),
                  child: _buildTipContentView(S.current.random_text_1289, _globalKeyCopy),
                ),
                onTriggered: () {
                  // log("复制成功：${widget.data?.billNo}");
                  // tooltipOffset(_globalKeyCopy);
                  // onClickCopyAndTooltip(widget.data?.billNo);
                  Clipboard.setData(ClipboardData(text: controller.authSecretValueObs.value));
                },
                child: Container(
                  key: _globalKeyCopy,
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
                ),
              ),
              // InkWell(
              //   onTap: () => SettingBizHelper.copyText(controller.authSecretValueObs.value),
              //   child: Container(
              //     height: 42,
              //     width: 42,
              //     decoration: BoxDecoration(
              //       borderRadius: const BorderRadius.only(
              //         topRight: Radius.circular(4),
              //         bottomRight: Radius.circular(4),
              //       ),
              //       color: ThemeService().colorScheme.surface,
              //     ),
              //     child: const UnconstrainedBox(
              //       child: CustomAssetIcon(
              //         name: "assets/images/setup/ic_account_copy.webp",
              //         size: 17,
              //       ),
              //     ),
              //     // child: IconButton(
              //     //   icon: const Icon(Icons.copy),
              //     //   color: Colors.white,
              //     //   onPressed: () {
              //     //     // Clipboard.setData(ClipboardData(text: controller.getGoogleKey()));
              //     //     AccountBizHelper.copyText(controller.authSecretObs.value);
              //     //   },
              //     // ),
              //   ),
              // )
            ],
          ),
        ),
        const SizedBox(
          height: AppValues.defaultPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              S.current.random_text_458,//prevent_other_people_look,
              textColorStyle: CustomTextColorStyle.normal,
            ),
            const SizedBox(
              height: AppValues.defaultPadding,
            ),
            Container(
              height: 160,
              width: 160,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration:
                  BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
              child: QrImageView(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.white,
                version: QrVersions.auto,
                // data: controller.authSecretValueObs.value,
                data: controller.getQrUrl(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildTipContentView(String? content, GlobalKey iconKey) {
    // final RenderBox renderBox = _globalKeyCopy.currentContext!.findRenderObject() as RenderBox;
    // Offset offset = renderBox.localToGlobal(Offset.zero);
    // log("_buildTipContentView...offset...$offset");
    return UnconstrainedBox(
      key: _globalKeyTip,
      child: BubbleView(
        direction: ArrowDirection.bottom,
        arrowWidth: 8,
        arrowHeight: 4,
        borderRadius: const Radius.circular(4.0),
        arrowBasisOffset: 0,
        //偏移修改
        arrowPeakOffset: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: CustomText(
          content ?? '',
          style: ThemeService().textTheme.labelMedium?.copyWith(
                color: const Color(0xFF13212D),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        offsetCallback: (size, offset) {
          // 获取组件 icon大小和偏移
          final RenderBox iconRenderBox = iconKey.currentContext?.findRenderObject() as RenderBox;
          Size iconSize = iconRenderBox.size;
          final iconOffset = iconRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...iconSize=$iconSize...iconOffset=$iconOffset");
          // 获取组件 tooltip大小和偏移
          final RenderBox tipRenderBox =
              _globalKeyTip.currentContext?.findRenderObject() as RenderBox;

          Size tipSize = tipRenderBox.size;
          final tipOffset = tipRenderBox.localToGlobal(Offset.zero);
          // log("offsetCallback...tipSize=$tipSize...tipOffset=$tipOffset");
          return iconOffset.dx - tipOffset.dx + iconSize.width / 2;
        },
      ),
    );
  }

  _buildTopAlready() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 28,
        ),
        CustomText(
          S.current.s_2fa_body_title_text,
          style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 28,
        ),
        CustomText(
          S.current.s_2fa_body_tips_text,
          textColorStyle: CustomTextColorStyle.normal,
        ),
        const SizedBox(height: AppValues.defaultPadding),
        const CustomDividerWidget(),
      ],
    );
  }

  _buildInputViewAlready() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppValues.defaultMargin,
        ),
        //密码
        Obx(() {
          return CustomMainTextField(
            text: controller.unAuthHelper.passwordText.value,
            title: S.current.random_text_670,
            required: true,
            showError: controller.unAuthHelper.passwordError.value,
            errorText: controller.unAuthHelper.passwordErrorText.value,
            isPwd: true,
            inputCallBack: (value) => controller.unAuthHelper.onInputPassword(value, false),
            inputCompletionCallBack: (value, isSubmitted) =>
                controller.unAuthHelper.onInputPassword(value, true),
          );
        }),
        const SizedBox(
          height: AppValues.defaultMargin,
        ),

        //双重验证码
        Obx(() {
          return CustomMainTextField(
            text: controller.unAuthHelper.codeText.value,
            title: S.current.s_2fa_body_code_text,
            required: true,
            showError: controller.unAuthHelper.codeError.value,
            errorText: controller.unAuthHelper.codeErrorText.value,
            isPwd: false,
            // maxLength: 6,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            inputCallBack: (value) => controller.unAuthHelper.onInputCode(value, false),
            inputCompletionCallBack: (value, isSubmitted) =>
                controller.unAuthHelper.onInputCode(value, true),
          );
        }),
      ],
    );
  }

  _buildBottomAlready(context) {
    return Column(
      children: [
        const SizedBox(height: AppValues.defaultMargin),
        Container(
          height: 2,
          color: ThemeService().colorScheme.tertiary,
        ),
        const SizedBox(height: AppValues.defaultMargin),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CustomBigMainButton(
              title: S.current.submit_text,
              maxWidth: 100,
              colorStyle: CustomButtonColorStyle.tertiary,
              isEnable: controller.unAuthHelper.buttonEnable.value,
              onTap: (btnController) {
                controller.doActionAuthClose(btnController);
              },
            ),
            const SizedBox(width: 20),
          ],
        ),
        const SizedBox(height: AppValues.defaultMargin),
      ],
    );
  }
}
