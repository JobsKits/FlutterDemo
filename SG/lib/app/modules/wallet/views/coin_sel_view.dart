import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/wallet/CurrencyBean.dart';
import '../../../../pages/personal_center/wallet/widget/custom_select_coin_widget.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/wallet_controller.dart';

class CoinSelView extends GetView<WalletCtrl> {
  CoinSelView({super.key, this.isPayment = false, this.title});

  final bool isPayment;
  final String? title;
  final GlobalKey rootViewGlobalKey = GlobalKey();
  final GlobalKey globalKeyCoin = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //https://jira.vgtech.org/browse/STAK-11170
      return Visibility(
          visible: controller.globalController
                  .getCurList(controller.fiatCurrTabSel.value,
                      controller.globalController.dcAvailableData.value)
                  .length !=
              1,
          child: _deposit());
    });
  }

  Widget _deposit() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomAsterisksTipsText(
            text: title ?? S.current.random_text_1130,
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Obx(() {
            return CustomSelectCoinWidget(
              arrowBasisOffset: 55,
              positionedRight: 16,
              hintSearchTextual: S.current.wallet_search,
              globalKeyS: rootViewGlobalKey,
              globalKeyWidget: globalKeyCoin,
              bubbleWidth: controller.bubbleCoinWidth,
              ratio: 1.0,
              dataList: controller.globalController.getCurList(controller.fiatCurrTabSel.value,
                  controller.globalController.dcAvailableData.value),
              contentBuilder: (context, bean) {
                return _depositView();
              },
              itemBuilder: (context, bean) {
                return _coinItem(bean);
              },
            );
          })
        ],
      ),
    ).marginOnly(top: 16);
  }

  _depositView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: AppValues.width_12,
        ),
        CustomText("${controller.getMergerSelCoin(controller.fiatCurrTabSel.value).name}",
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(
          width: AppValues.margin_4,
        ),
        CustomNetWorkImage(
          imageUrl: controller.getMergerSelCoin(controller.fiatCurrTabSel.value).coinImgUrl,
          width: 18,
          height: 18,
        ),
        const SizedBox(
          width: AppValues.margin_2,
        ),
      ],
    );
  }

  _coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        // controller.isPaymentView.value = isPayment;
        controller.saveSelectedCoin(bean);
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.only(top: AppValues.margin_6, bottom: AppValues.margin_6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
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
            Spacer(),
            CustomText(
              bean.amount ?? "",
              style: ThemeService()
                  .theme
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: ThemeService().colorScheme.tertiary),
            ),
          ],
        ).marginOnly(left: 10, right: 10),
      ),
    );
  }
}
