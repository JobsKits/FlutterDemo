import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:get/get.dart';

import 'logic.dart';

const String kCustomLogoutWidget = 'kCustomLogoutWidget';

class LogoutWidget extends StatelessWidget {
  final controller = Get.put(LogoutController());

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
                  padding: const EdgeInsets.only(bottom: AppValues.largeMargin),
                  margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppValues.smallRadius),
                    color: ThemeService().theme.scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      _buildTop(),
                      _buildBody(context),
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

  _buildBody(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
      child: Column(
        children: [
          CustomText(
            S.current.random_text_fix3,
            textColorStyle: CustomTextColorStyle.normal,
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          CustomBigMainButton(
            fontWeight: FontWeight.w600,
            title: S.current.logout_text,
            onTap: (buttonCtr) => controller.onLogout(context, buttonCtr),
            colorStyle: CustomButtonColorStyle.login,
          ),
        ],
      ),
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
            const CustomIcon(
              asset: 'assets/images/login/ic_logout.webp',
              size: 18,
            ),
            const SizedBox(
              width: AppValues.smallPadding,
            ),
            CustomText(
              S.current.logout_text,
              style: ThemeService().textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            Spacer(),
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

Future<void> showCustomLogoutWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  GlobalStateController.of().showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomLogoutWidget,
      barrierDismissible: barrierDismissible,
      useRootNavigator: useRootNavigator,
      builder: (_) {
        return LogoutWidget();
      })?.then((value) => GlobalStateController.of().showOverlayView());
}
