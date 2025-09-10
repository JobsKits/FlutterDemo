import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/setup/widgets/setup_collection_info_expand.dart';
import 'package:flutter_bet/pages/setup/widgets/withdrawal_method_widget.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/button/custom_big_main_button.dart';
import 'package:flutter_bet/widget/button/custom_button_style.dart';
import 'package:flutter_bet/widget/custom_check_box.dart';
import 'package:flutter_bet/widget/custom_currency_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:get/get.dart';
import 'logic.dart';

class SetupCollectionInfoPage extends StatelessWidget {
  final double maxHeight;
  final controller = Get.put(SetupCollectionInfoController());

  SetupCollectionInfoPage({super.key, this.maxHeight = 350});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      constraints: BoxConstraints(minHeight: maxHeight, maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 35.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                S.current.random_text_462,
                style: ThemeService()
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              _buildEncryptAddress(context),
              const SizedBox(
                height: 32,
              ),
              CustomText(
                S.current.random_text_463,
                style: ThemeService()
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              _buildCurrencyAddress(),
            ],
          ),
        ),
      ),
    );
  }

  _buildCurrencyAddress() {
    return Column(
      children: [
        SetupCollectionInfoExpand(
            titleIcon: const CustomCurrencyIcon(
              type: CustomCurrency.brl,
            ),
            isInitExpanded: true,
            title: 'BRL',
            children: [
              Row(
                children: [
                  CustomText(
                    S.current.random_text_464,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                  CustomText(
                    '*',
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.reverseStateColor),
                  ),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              CustomMainTextField(),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: CustomText(S.current.random_text_465,
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.reverseStateColor)),
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  CustomText(
                    S.current.withdraw_money_type,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                  CustomText(
                    '*',
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.reverseStateColor),
                  ),
                ],
              ),
              SizedBox(
                height: AppValues.defaultPadding,
              ),
              WithdrawalMethodWidget(),
              SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  CustomText(
                    S.current.binding_bank_card_select_bank,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                  CustomText(
                    '*',
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.reverseStateColor),
                  ),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              CustomMainTextField(),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  CustomText(
                    S.current.random_text_468,
                    style: ThemeService().textTheme.bodySmall,
                  ),
                  CustomText(
                    '*',
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.reverseStateColor),
                  ),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              CustomMainTextField(),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  Expanded(child: SizedBox.shrink()),
                  SizedBox(
                    width: 150,
                    child: CustomBigMainButton(
                      title: S.current.wallet_cancel,
                      colorStyle: CustomButtonColorStyle.secondaryIcon,
                    ),
                  ),
                  SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomBigMainButton(title: S.current.button_save_text),
                  ),
                  Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeService().colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                ),
                child: Center(
                  child: CustomText(
                    S.current.random_text_471,
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.scoreTextColor),
                  ),
                ),
              ),
              SizedBox(
                height: AppValues.defaultPadding,
              ),
            ]),
      ],
    );
  }

  _buildEncryptAddress(BuildContext context) {
    return Column(
      children: [
        SetupCollectionInfoExpand(
            titleIcon: const CustomCurrencyIcon(
              type: CustomCurrency.usdt,
            ),
            isInitExpanded: true,
            title: 'USDT',
            children: [
              Obx(() {
                return CustomMainTextField(
                  text: controller.usdtInputText.value,
                  inputCallBack: (value) {
                    controller.usdtInputText.value = value;
                  },
                );
              }),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  Row(
                    children: [
                      GestureDetector(
                        child: Obx(() {
                          return CustomCheckBox(
                            value: controller.isTRC20.value,
                          );
                        }),
                        onTap: () {
                          controller.isTRC20.value = !controller.isTRC20.value;
                          controller.isERC20.value = !controller.isERC20.value;
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        'TRC 20',
                        style: ThemeService().textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        child: Obx(() {
                          return CustomCheckBox(
                              value: controller.isERC20.value);
                        }),
                        onTap: () {
                          controller.isERC20.value = !controller.isERC20.value;
                          controller.isTRC20.value = !controller.isTRC20.value;
                        },
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                        'ERC 20',
                        style: ThemeService().textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Row(
                children: [
                  const Expanded(child: SizedBox.shrink()),
                  SizedBox(
                    width: 150,
                    child: CustomBigMainButton(
                      title: S.current.wallet_cancel,
                      colorStyle: CustomButtonColorStyle.secondaryIcon,
                      onTap: (btnCtr) {},
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.defaultPadding,
                  ),
                  SizedBox(
                    width: 150,
                    child: CustomBigMainButton(
                      controller: controller.buttonCtr,
                      title: S.current.button_save_text,
                      onTap: (btnCtr) {
                        final type = controller.isERC20.value == true
                            ? 'ERC20'
                            : 'TRC20';
                        controller.onWalletInsert(context, btnCtr,
                            name: 'USDT',
                            type: type,
                            address: controller.usdtInputText.value);
                      },
                    ),
                  ),
                  const Expanded(child: SizedBox.shrink()),
                ],
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: ThemeService().colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                ),
                child: Center(
                  child: CustomText(
                    S.current.random_text_472,
                    style: ThemeService()
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppThemes.scoreTextColor),
                  ),
                ),
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
            ]),
        const SizedBox(
          height: 24,
        ),
        SetupCollectionInfoExpand(
            titleIcon: const CustomCurrencyIcon(
              type: CustomCurrency.eth,
            ),
            isInitExpanded: true,
            title: 'ETH',
            children: [
              CustomMainTextField(),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
              CustomBigMainButton(
                title: S.current.random_text_473,
                onTap: (btnCtr) {
                  controller.onWalletInsert(context, btnCtr,
                      name: 'ETH', address: controller.usdtInputText.value);
                },
              ),
              const SizedBox(
                height: AppValues.defaultPadding,
              ),
            ]),
      ],
    );
  }
}
