import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/widget/custom_password_tip.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_icon.dart';
import '../../../../widget/dialog/custom_safe_dialog.dart';
import '../controllers/withdraw_ctrl.dart';

const kCustomPassWorldWidget = 'PassWorld';

class PassWorld extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Container(
          margin: const EdgeInsets.all(AppValues.defaultMargin),
          child: Column(
            children: [
              _topView(),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: EdgeInsets.zero,
                child: PinCodeTextField(
                    cursorColor: ThemeService().colorScheme.tertiary,
                    autoFocus: false,
                    length: 6,
                    obscureText: true,
                    cursorWidth: 1,
                    animationType: AnimationType.fade,
                    textStyle: ThemeService().textTheme.titleMedium,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      // fieldHeight: 42,
                      fieldWidth: 45,
                      selectedFillColor: ThemeService().colorScheme.surface,
                      inactiveFillColor: ThemeService().colorScheme.surface,
                      activeFillColor: Colors.transparent,
                      borderWidth: 1,
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
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    //0-9
                    appContext: context,
                    onChanged: (String str) =>
                    {
                      controller.inPwd.value = str,
                      controller.checkInputPassWord(),
                    }),
              ),
              Obx(() =>
                  controller.errView(
                      controller.inPwShowErr.value, controller.inPwShowErrStr.value)),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                title: S.current.random_text_710,
                onTap: (btnCtr) {
                  controller.mergeWd(controller.fiatCurrTabSel.value, context, btnCtr);
                  // RouteUtil.popView();
                },
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/personal_center_icon/password_clock.webp",
          size: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomPasswordTips(
          style: const TextStyle(fontSize: 18),
          onPwdTypeSelected: (selectedPwdType) {
            controller.pwTypeBean.value = selectedPwdType;
            controller.inPwShowErrStr.value =
                S.current.binding_bank_card_please_enter + "${controller.pwTypeBean["title"]}";
          },
        ),
        const Spacer(),
        InkWell(
          onTap: () => RouteUtil.popView(),
          child: const CustomAssetIcon(
            width: 18,
            height: 18,
            name: 'assets/images/normal/ic_normal_close.webp',
          ),
        )
      ],
    );
  }
}

Future<void> showCustomPassWorldWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomPassWorldWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
            PassWorld(),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
