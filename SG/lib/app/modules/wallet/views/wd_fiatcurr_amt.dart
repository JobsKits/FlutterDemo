import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/withdraw_ctrl.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/input/custom_main_text_field.dart';
import '../../../../widget/network_image/custom_network_image.dart';

class WdFiatCurrAmt extends GetView<WithDrawCtrl> {
  @override
  Widget build(BuildContext context) {
    return _amtWidget(context);
  }

  Widget _amtWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: AppValues.defaultMargin,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomAsterisksTipsText(
                textStyle: const TextStyle(fontWeight: FontWeight.w600),
                text: S.current.random_text_1144,
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          _inWidget(),
          Obx(() =>
              controller.errView(controller.inAmtShowEr.value, controller.inAmtShowErrStr.value))
        ],
      ),
    );
  }

  Widget _inWidget() {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              Obx(() {
                return CustomMainTextField(
                  decoration: controller.getBoxDecoration(showErr: controller.inAmtShowEr.value),
                  keyboardType: TextInputType.number,
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.digitsOnly,
                  // ],
                  hintText: S.current.random_text_1144,
                  showError: controller.inAmtShowEr.value,
                  // errorText: controller.inAmtShowErrStr.value,
                  text: controller.inAmt.value,
                  controller: controller.inAmtCtrl,
                  inputCallBack: (str) {
                    if (str.isNotEmpty) {
                      double inputAmount = double.parse(str);
                      double currencyAmount = double.parse(
                          controller.usableBal.value.isEmpty ? "0" : controller.usableBal.value);
                      double currencyAmountTotal = double.parse(
                          controller.getMergerSelCoin(controller.wdFiatCurrTabSel.value).amount ??
                              "0");
                      if (inputAmount > currencyAmount) {
                        controller.inAmt.value = controller.usableBal.value;
                        controller.inAmtCtrl.text = controller.inAmt.value;
                        controller.inAmtCtrl.selection = TextSelection.fromPosition(
                          TextPosition(offset: controller.inAmtCtrl.text.length),
                        );
                        if (currencyAmount != currencyAmountTotal) {
                          controller.inAmtShowEr.value = true;
                          controller.inAmtShowErrStr.value =
                              "${S.current.random_text_711}${controller.usableBal.value}${S.current.random_text_712}${controller.remainingBal.value}";
                        }
                      } else {
                        if (inputAmount == currencyAmount) {
                          controller.inAmtCtrl.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.inAmtCtrl.text.length),
                          );
                        }
                        controller.inAmt.value = str;
                        controller.checkInputAmount();
                      }
                    } else {
                      controller.inAmt.value = str;
                      controller.inAmtShowEr.value = false;
                    }
                  },
                  isCursorEnd: false,
                );
              }),
              Obx(() {
                return Positioned(
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.only(top: 11, bottom: 11),
                      height: AppValues.defaultTextHeight,
                      child: CustomNetWorkImage(
                        placeholder: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                        ),
                        errorWidget: const CustomAssetIcon(
                          name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                        ),
                        imageUrl: controller
                            .getMergerSelCoin(controller.wdFiatCurrTabSel.value)
                            .coinImgUrl,
                        width: 18,
                        height: 18,
                      ),
                    ));
              }),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            controller.inAmt.value = controller.usableBal.value;
            controller.inAmtCtrl.text = controller.inAmt.value;
            controller.inAmtCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: controller.inAmtCtrl.text.length),
            );
            controller.checkInputAmount();
          },
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: AppValues.defaultTextHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.tertiaryContainer,
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
            child: CustomText(S.current.vault_max_value,
                style: ThemeService()
                    .theme
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ),
        )
      ],
    );
  }
}
