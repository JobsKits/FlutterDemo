import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_controller.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:get/get.dart';

import '../../../app/modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../wallet/auth_widget.dart';
import '../wallet/widget/custom_select_coin_widget.dart';

double bubbleWidthWith = 232;
const ratio = 1.0;
final GlobalKey _globalKeyCoin = GlobalKey();
final GlobalKey _globalKey = GlobalKey();
final GlobalStateController globalController = Get.find<GlobalStateController>();

class DepositView extends StatelessWidget {
  final VaultController controller;

  const DepositView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: _globalKey,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _topView(),
        const SizedBox(
          height: 16,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: AppValues.margin_14),
            Obx(() {
              // String interestRate;
              // try {
              //   interestRate = controller.selCoinBean['interest_rate'] ?? "0";
              //   if (interestRate.isEmpty) {
              //     interestRate = "0";
              //   } else {
              //     interestRate = double.parse(interestRate).toInt().toString();
              //   }
              // } catch (e) {
              //   interestRate = "0"; // 如果解析失败，使用默认值
              // }
              // return CustomText("${S.current.random_text_596} $interestRate%",
              //     style:
              //         ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600));
              return CustomText(
                  S.current.random_text_596 +
                      " "
                          // "${controller.getAnnualInterestRate(double.parse(controller.selCoinBean['interest_rate'] ?? "0"))}%",
                          "${controller.selCoinBean['interest_rate'].toString().isEmpty ? "0" : controller.selCoinBean['interest_rate']}%",
                  style:
                      ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600));
            }),
            const Spacer(),
            Obx(() {
              return Offstage(
                offstage: true,
                child: CustomText('US\$${controller.withdrawRateCount.toStringAsFixed(2)}',
                    style: ThemeService()
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
              );
            }),
            const SizedBox(width: AppValues.margin_14),
          ],
        ),
        _inputWidget(),
        Obx(() {
          return Visibility(
              visible: controller.isShowErrorHint.value,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: AppValues.smallPadding, left: AppValues.margin_12),
                child: CustomErrorTipsText(
                  text: controller.showErrorStr.value ?? '',
                ),
              ));
        }),
        const SizedBox(
          height: 26,
        ),
        Container(
            margin: const EdgeInsets.only(
                left: AppValues.margin_12, right: AppValues.margin_12, bottom: AppValues.margin_12),
            child: CustomBigMainButton(
                colorStyle: CustomButtonColorStyle.tertiary,
                onTap: (customButtonController) {
                  // String minDeposit = controller.selCoinBean['min_deposit'] ?? "0";
                  // if (double.parse(controller.defaultAmount.value.isEmpty
                  //         ? "0"
                  //         : controller.defaultAmount.value) <
                  //     double.parse(minDeposit)) {
                  //   // controller.showErrorStr.value = "${S.current.random_text_597}$minDeposit";
                  //   // controller.isShowErrorHint.value = true;
                  // }

                  log("neco 当前需要存的金额 ${controller.defaultAmount.value}");
                  controller.balanceLocker(
                      controller.deposit, controller.defaultAmount.value, customButtonController,
                      selectAmountCoinIc: controller.selectAmountCoinIc.value);
                },
                // 存入保险库
                title: S.current.vault_deposit_vault)),
        Obx(() {
          return Visibility(
              visible: VaultUtil.isSecretNot(),
              child: AuthWidget(
                tips: S.current.random_text_598,
              ));
        }),
        Obx(() {
          return Visibility(
              visible: !(VaultUtil.isSecretNot() || !VaultUtil.isEmailCheckStateNotBind()),
              child: CupertinoButton(
                  onPressed: () {
                    VaultDescriptionsView.openPage();
                  },
                  child: Center(
                      child: CustomText(
                    S.current.random_text_598,
                    textColorStyle: CustomTextColorStyle.normal,
                  ))));
        }),
      ],
    );
  }

  Widget _topView() {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(flex: 1, child: Container()),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start, // 左对齐
          children: [
            Container(
                padding: const EdgeInsets.only(top: AppValues.defaultPadding),
                child: CustomText(S.current.wallet_currency,
                    style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500, color: ThemeService().colorScheme.onSurface))),
            const SizedBox(
              height: 8,
            ),
            _coin(),
          ],
        ),
        Expanded(flex: 1, child: Container()),
      ],
    );
  }

  Widget _coin() {
    return Obx(() {
      return CustomSelectCoinWidget(
        hintSearchTextual: S.current.random_text_452,
        globalKeyS: _globalKey,
        globalKeyWidget: _globalKeyCoin,
        bubbleWidth: bubbleWidthWith,
        ratio: ratio,
        isHeight: true,
        dataList: globalController.currTypeLists.value,
        contentBuilder: (context, bean) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: AppValues.width_12,
              ),
              CustomText(
                  // "${controller.syl}"
                  "${controller.selectAmount.value}",
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500)),
              const SizedBox(
                width: AppValues.allianceWidth_6,
              ),
              CustomNetWorkImage(
                placeholder: const CustomAssetIcon(
                  name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                ),
                errorWidget: const CustomAssetIcon(
                  name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                ),
                imageUrl: controller.selectAmountCoinIc.value,
                width: 18,
                height: 18,
              ),
              const SizedBox(
                width: 4,
              ),
            ],
          );
        },
        itemBuilder: (context, bean) {
          return _coinItem(bean);
        },
      );
    });
  }

  Widget _coinItem(CurrencyBean bean) {
    return GestureDetector(
      onTap: () {
        Get.back();
        controller.depositFun(bean);
        controller.saveSelected(bean);
      },
      child: Container(
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
                  // "${bean.symbol}"
                  "${controller.truncateText(bean.amount ?? "", 13)}",
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: ThemeService().colorScheme.tertiary),
                ),
              ],
            ),
            SizedBox(
              width: 82,
              child: Row(
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //输入框
  Widget _inputWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: AppValues.margin_12, right: AppValues.margin_12),
      child: Row(
        children: [
          Obx(() {
            return Expanded(
              child: Stack(
                children: [
                  CustomMainTextField(
                    decoration: controller.getBoxDecoration(controller.isShowErrorHint.value),
                    controller: controller.depositAmountController,
                    // errorText: controller.showErrorStr.value,
                    showError: controller.isShowErrorHint.value,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,9}')),
                    ],
                    inputCallBack: (source) {
                      log("neco defaultAmount = ${controller.defaultAmount.value} source=$source");
                      controller.withdrawExchangeRateCount(source, 1);
                      if (source.isEmpty) {
                        controller.isShowErrorHint.value = false;
                        controller.defaultAmount.value = source;
                      } else {
                        double inputAmount = double.parse(source);
                        var selectAmount = controller.selectAmount.value;
                        double selAm = double.parse(selectAmount.isEmpty ? "0" : selectAmount);
                        if (inputAmount > selAm) {
                          controller.defaultAmount.value = controller.selectAmount.value;
                          controller.depositAmountController.text = controller.selectAmount.value;
                          controller.depositAmountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.depositAmountController.text.length),
                          );
                        } else {
                          controller.defaultAmount.value = source;
                        }

                        // String minDeposit = controller.selCoinBean['min_deposit'] ?? "0";
                        // if (controller.isSubmit) {
                        //   if (double.parse(source) < double.parse(minDeposit)) {
                        //     controller.isShowErrorHint.value = true;
                        //   } else {
                        //     controller.isShowErrorHint.value = false;
                        //   }
                        // }
                      }
                    },
                    text: controller.defaultAmount.value,
                  ),
                  Positioned(
                    right: 12,
                    child: Obx(() {
                      return Container(
                        alignment: Alignment.center,
                        height: AppValues.defaultTextHeight,
                        child: CustomNetWorkImage(
                          placeholder: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                          ),
                          errorWidget: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                          ),
                          imageUrl: controller.selectAmountCoinIc.value,
                          width: 18,
                          height: 18,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            );
          }),
          InkWell(
            onTap: () {
              controller.defaultAmount.value = controller.selectAmount.value;
              controller.depositAmountController.text = controller.selectAmount.value;
              controller.depositAmountController.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.depositAmountController.text.length),
              );
              controller.withdrawExchangeRateCount(controller.defaultAmount.value, 1);

              controller.getErrorStr(controller.defaultAmount.value);

              ///处理点击最大值，是否显示红色提示框
              // String minDeposit = controller.selCoinBean['min_deposit'] ?? "0";
              // String maxSource =
              // controller.defaultAmount.value.isEmpty ? "0" : controller.defaultAmount.value;
              // if (double.parse(maxSource) < double.parse(minDeposit)) {
              //   controller.isShowErrorHint.value = true;
              // } else {
              //   controller.isShowErrorHint.value = false;
              // }
            },
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              height: AppValues.defaultTextHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: ThemeService().colorScheme.tertiary,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
              child: CustomText(S.current.vault_max_value,
                  textAlign: TextAlign.center,
                  style: ThemeService()
                      .theme
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
            ),
          )
        ],
      ),
    );
  }
}
