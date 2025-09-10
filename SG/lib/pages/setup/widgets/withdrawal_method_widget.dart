import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_icon_button.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';

class WithdrawalMethodWidget extends StatelessWidget {
  const WithdrawalMethodWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 4,bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: CustomIconButton(
              iconWidth: 14,
              iconHeight: 14,
              widgetHeight: 40,
              name: S.current.random_text_485,
              borderRadius: AppValues.smallRadius,
              iconWidget: const CustomAssetIcon(
                name: 'assets/images/pay_method/ic_alipay.png',
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  color: ThemeService().colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: -1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2,
                      spreadRadius: -1,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              direction: Direction.left,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: AppValues.defaultPadding,),
          Expanded(
            child: CustomIconButton(
              iconWidth: 14,
              iconHeight: 14,
              widgetHeight: 40,
              name: S.current.random_text_485,
              borderRadius: AppValues.smallRadius,
              iconWidget: const CustomAssetIcon(
                name: 'assets/images/pay_method/ic_alipay.png',
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  color: ThemeService().colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: -1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2,
                      spreadRadius: -1,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              direction: Direction.left,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: AppValues.defaultPadding,),
          Expanded(
            child: CustomIconButton(
              iconWidth: 14,
              iconHeight: 14,
              widgetHeight: 40,
              name: S.current.random_text_485,
              borderRadius: AppValues.smallRadius,
              iconWidget: const CustomAssetIcon(
                name: 'assets/images/pay_method/ic_alipay.png',
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  color: ThemeService().colorScheme.tertiary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 3,
                      spreadRadius: -1,
                      offset: const Offset(0, 2),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 2,
                      spreadRadius: -1,
                      offset: const Offset(0, 1),
                    ),
                  ]),
              direction: Direction.left,
              style: ThemeService()
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
