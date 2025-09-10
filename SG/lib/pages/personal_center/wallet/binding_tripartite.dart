import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/BankcardBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/input/custom_main_text_field.dart';
import 'binding_bank_card_controller.dart';


const kCustomBindingTripartiteWidget = 'BindingTripartite';

class BindingTripartite extends StatelessWidget {
  BindingTripartite({super.key});

  late BindingBankCardControllerOld controller = Get.find<BindingBankCardControllerOld>();

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => BindingBankCardControllerOld());
    controller.context = context;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: ThemeService().colorScheme.background,
        ),
        child: Container(
          margin: const EdgeInsets.all(AppValues.defaultMargin),
          child: Column(
            children: [
              _topView(),
              Divider(
                indent: 0.0,
                endIndent: 0.0,
                thickness: 1,
                color: ThemeService().colorScheme.tertiary,
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomAsterisksTipsText(
                text: S.current.binding_tripartite_account_holder_name,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomMainTextField(
                hintText: S.current.binding_bank_card_please_enter,
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomAsterisksTipsText(
                text: S.current.random_text_447,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomMainTextField(
                hintText: S.current.binding_bank_card_please_enter,
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              CustomBigMainButton(
                title: S.current.binding_bank_card_binding,
              ),
              const SizedBox(
                height: AppValues.margin_12,
              ),
              _textRich()
            ],
          ),
        ),
      ),
    );
  }

  Widget _textRich() {
    return RichText(
        text: TextSpan(children: [
          TextSpan(
            text: S.current.binding_bank_card_all_bound_accounts,
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: CustomTextColorStyle.normal.value),
          ),
          TextSpan(
            text: S.current.binding_bank_card_names_must_match,
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: CustomTextColorStyle.white.value),
          ),
          TextSpan(
            text: S.current.binding_bank_card_hint,
            style: ThemeService()
                .theme
                .textTheme
                .bodyMedium
                ?.copyWith(color: CustomTextColorStyle.normal.value),
          ),
        ]));
  }

  Widget _topView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomIcon(
          color: AppThemes.iconColor,
          asset: "assets/images/personal_center_icon/add_bankcard_bank.webp",
          size: 18,
        ),
        const SizedBox(
          width: 4,
        ),
        CustomText(
          S.current.random_text_448,
          style: ThemeService().theme.textTheme.titleMedium?.copyWith(
              fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

Future<void> showCustomBindingTripartiteWidget<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
}) async {
  await CustomSafeDialog.show<T>(
      context: context,
      tag: kCustomBindingTripartiteWidget,
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
            BindingTripartite(
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                RouteUtil.popView();
              },
            )),
          ],
        );
      });
}
