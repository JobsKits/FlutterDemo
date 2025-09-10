import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../controllers/wallet_controller.dart';

class TabBarWidget extends GetView<WalletCtrl> {
  TabBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => {
            controller.fiatCurrTabSel.value = true,
          },
          child: Obx(() => Visibility(
                visible: controller.depFiatCurrState.value && controller.depCryptoCurrState.value,
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width / 2 - 38,
                  padding: const EdgeInsets.only(
                      top: AppValues.defaultMargin, bottom: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: controller.fiatCurrTabSel.value
                                  ? ThemeService().colorScheme.primary
                                  : ThemeService().colorScheme.tertiary))),
                  child: CustomText(
                    S.current.random_text_1139,
                    style: TextStyle(
                        fontSize: 14,
                        color: controller.fiatCurrTabSel.value
                            ? AppThemes.textColorWhite
                            : AppThemes.onTertiaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )),
        ),
        GestureDetector(
          onTap: () => {
            controller.fiatCurrTabSel.value = false,
          },
          child: Obx(() => Visibility(
                visible: controller.depCryptoCurrState.value && controller.depFiatCurrState.value,
                child: Container(
                  alignment: Alignment.center,
                  width: Get.width / 2 - 38,
                  padding: const EdgeInsets.only(
                      top: AppValues.defaultMargin, bottom: AppValues.defaultMargin),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1,
                              color: controller.fiatCurrTabSel.value
                                  ? ThemeService().colorScheme.tertiary
                                  : ThemeService().colorScheme.primary))),
                  child: CustomText(
                    S.current.crypto_text,
                    style: TextStyle(
                        fontSize: 14,
                        color: controller.fiatCurrTabSel.value
                            ? AppThemes.onTertiaryColor
                            : AppThemes.textColorWhite,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              )),
        )
      ],
    );
  }
}
