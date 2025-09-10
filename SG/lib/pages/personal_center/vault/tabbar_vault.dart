import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import 'vault_controller.dart';

class TabBarWidget extends GetView<VaultController> {
  TabBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: ThemeService().colorScheme.surface, // 设置背景色
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {
              controller.isDeposits.value = true,
            },
            child: Obx(() => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      top: AppValues.margin_12, bottom: AppValues.margin_12, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: controller.isDeposits.value
                        ? ThemeService().colorScheme.tertiary
                        : ThemeService().colorScheme.surface, // 设置背景色
                  ),
                  child: CustomText(
                    S.current.wallet_deposit,
                    style: TextStyle(
                        fontSize: 14,
                        color: controller.isDeposits.value
                            ? AppThemes.textColorWhite
                            : AppThemes.onTertiaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ),
          GestureDetector(
            onTap: () => {
              controller.isDeposits.value = false,
            },
            child: Obx(() => Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(
                      top: AppValues.margin_12, bottom: AppValues.margin_12, left: 20, right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: controller.isDeposits.value
                        ? ThemeService().colorScheme.surface
                        : ThemeService().colorScheme.tertiary, // 设置背景色
                  ),
                  child: CustomText(
                    S.current.vault_withdraw_money,
                    style: TextStyle(
                        fontSize: 14,
                        color: controller.isDeposits.value
                            ? AppThemes.onTertiaryColor
                            : AppThemes.textColorWhite,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
