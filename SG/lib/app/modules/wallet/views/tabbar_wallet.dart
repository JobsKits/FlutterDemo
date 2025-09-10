import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/vault_util.dart';
import '../controllers/wallet_controller.dart';

class TabBarWallet extends GetView<WalletCtrl> {
  TabBarWallet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => WalletCtrl());
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: controller.tabScrollCtrl,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          color: ThemeService().colorScheme.surface,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => {controller.tabPos.value = 0, controller.scrollToIndex(0)},
              child: Obx(() => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: AppValues.margin_12, bottom: AppValues.margin_12, left: 30, right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: controller.tabPos.value == 0
                          ? ThemeService().colorScheme.tertiary
                          : ThemeService().colorScheme.surface,
                    ),
                    child: CustomText(
                      S.current.wallet_deposit,
                      style: TextStyle(
                          fontSize: 14,
                          color: controller.tabPos.value == 0
                              ? AppThemes.textColorWhite
                              : AppThemes.onTertiaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () => {controller.tabPos.value = 1, controller.scrollToIndex(1)},
              child: Obx(() => Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: AppValues.margin_12, bottom: AppValues.margin_12, left: 30, right: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: controller.tabPos.value == 1
                          ? ThemeService().colorScheme.tertiary
                          : ThemeService().colorScheme.surface,
                    ),
                    child: CustomText(
                      S.current.vault_withdraw_money,
                      style: TextStyle(
                          fontSize: 14,
                          color: controller.tabPos.value == 1
                              ? AppThemes.textColorWhite
                              : AppThemes.onTertiaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )),
            ),
            GestureDetector(
              onTap: () => {controller.tabPos.value = 2, controller.scrollToIndex(2)},
              child: Obx(() {
                var fiatCurNum = controller.globalController.currTypeLists
                    .where((bean) => bean.currency_type == 1)
                    .toList()
                    .length;
                var cryptoCurNum = controller.globalController.currTypeLists
                    .where((bean) => bean.currency_type != 1)
                    .toList()
                    .length;
                return Visibility(
                  visible: VaultUtil.isShowExchangeCurrency() && fiatCurNum > 1 && cryptoCurNum > 1,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(
                        top: AppValues.margin_12, bottom: AppValues.margin_12, left: 20, right: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: controller.tabPos.value == 2
                          ? ThemeService().colorScheme.tertiary
                          : ThemeService().colorScheme.surface,
                    ),
                    child: CustomText(
                      S.current.buy_crypto,
                      style: TextStyle(
                          fontSize: 14,
                          color: controller.tabPos.value == 2
                              ? AppThemes.textColorWhite
                              : AppThemes.onTertiaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
