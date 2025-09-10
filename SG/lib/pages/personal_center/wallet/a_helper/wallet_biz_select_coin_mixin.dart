import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';

///钱包 coin 下拉框业务mixin
 GlobalKey walletCoinKey = GlobalKey();
 GlobalKey  walletCoinPanelKey = GlobalKey();
mixin WalletBizSelectCoinMixin {
  final double bubbleWidth = 114;
  final double bubbleWidthWithDrawal = 220;
  final double ratio = 2.0;
  final currTypeSelected = CurrencyBean().obs; //选中的币种
  final currencyDepositSelectCoinIc = "".obs;
  final currencyWithdrawalSelectCoinIc = "".obs;
  final currencyDepositSelectCoin = "".obs;
  final currencyWithdrawalSelectCoinAndAmount = "".obs;
  final currencyAmount = "".obs;

  final position = 0.obs;

  Widget coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        // controller.withdrawal(bean);
        // controller.saveSelected(bean);
        saveSelected(bean);
      },
      child: Container(
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: bubbleWidth / 2 - 31,
            ),
            CustomNetWorkImage(
              width: 18,
              height: 18,
              imageUrl: bean.coinIc ?? "",
            ),
            const SizedBox(
              width: 8,
            ),
            CustomText(
              bean.name ?? "",
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.tertiary),
            ),
          ],
        ),
      ),
    );
  }

  Widget coinWithDrawalItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        // controller.withdrawal(bean);
        // controller.saveSelected(bean);
        saveSelected(bean);
      },
      child: Container(
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const SizedBox(
                  width: 12,
                ),
                CustomText(
                  // "${bean.symbol}${controller.truncateText(bean.amount ?? "", 13)}",
                  truncateText(bean.amount ?? "", 13),
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ThemeService().colorScheme.tertiary),
                ),
              ],
            ),
            SizedBox(
              width: 76,
              child: Row(
                children: [
                  CustomNetWorkImage(
                    imageUrl: bean.coinIc ?? "",
                    width: 18,
                    height: 18,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  CustomText(
                    bean.name ?? " ",
                    style: ThemeService()
                        .theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: ThemeService().colorScheme.tertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget withDrawalView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppValues.width_12,
        ),
        CustomText(
            // controller.position.value == 0
            //     ? controller.currencyDepositSelectCoin.value
            //     : controller.currencyWithdrawalSelectCoinAndAmount.value,
            position.value == 0 ? currencyDepositSelectCoin.value : currencyAmount.value,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          width: AppValues.margin_4,
        ),
        CustomNetWorkImage(
          imageUrl: position.value == 0
              ? currencyDepositSelectCoinIc.value
              : currencyWithdrawalSelectCoinIc.value,
          width: 18,
          height: 18,
        ),
        const SizedBox(
          width: 4,
        ),
      ],
    );
  }

  Widget coinContentView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppValues.width_12,
        ),
        // CustomNetWorkImage(
        //   imageUrl: position.value == 0
        //       ? currencyDepositSelectCoinIc.value
        //       : currencyWithdrawalSelectCoinIc.value,
        //   width: 18,
        //   height: 18,
        // ),
        const SizedBox(
          width: AppValues.margin_4,
        ),
        CustomText(
            position.value == 0 || position.value == 2
                ? currencyDepositSelectCoin.value
                : currencyWithdrawalSelectCoinAndAmount.value,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          width: AppValues.margin_4,
        ),
      ],
    );
  }

  ///临时保存选中的币种
  void saveSelected(CurrencyBean bean) {
    currTypeSelected.value = bean;
  }

  String truncateText(String str, int maxLength) {
    if (str.isEmpty) {
      return "";
    }
    if (str.length > maxLength) {
      return '${str.substring(0, maxLength)}...';
    }
    return str;
  }
}
