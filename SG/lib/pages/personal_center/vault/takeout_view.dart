import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/vault/vault_controller.dart';
import 'package:flutter_bet/utils/vault_util.dart';
import 'package:get/get.dart';

import '../../../app/modules/vaultDescriptions/views/vault_descriptions_view.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_button_style.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/custom_error_tips_text.dart.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_tips*_text.dart.dart';
import '../../../widget/input/custom_main_text_field.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../wallet/auth_widget.dart';
import '../wallet/widget/custom_password_tip.dart';
import '../wallet/widget/custom_select_coin_widget.dart';

double bubbleWidthWith = 232;
const ratio = 1.0;
final GlobalKey _globalKeyCoin = GlobalKey();
final GlobalKey _globalKey = GlobalKey();

class TakeoutView extends StatelessWidget {
  final VaultController controller;

  const TakeoutView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(key: _globalKey, crossAxisAlignment: CrossAxisAlignment.start, children: [
      _topView(),
      const SizedBox(
        height: 16,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: AppValues.margin_14),
          CustomText(S.current.vault_amount,
              style: ThemeService().textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          const Spacer(),
          Obx(() {
            return Offstage(
              offstage: true,
              child: CustomText('US\$${controller.withdrawRateCount.toStringAsFixed(2)}',
                  style:
                      ThemeService().textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
            );
          }),
          const SizedBox(width: AppValues.margin_14),
        ],
      ),
      _inputWidget(),
      Obx(() {
        return Visibility(
            visible: controller.takeoutAmountShowErrorHint.value,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: AppValues.smallPadding, left: AppValues.margin_12),
              child: CustomErrorTipsText(
                text: controller.takeoutAmountShowErrorStr.value,
              ),
            ));
      }),
      const SizedBox(
        height: AppValues.margin_12,
      ),
      Container(
          margin: const EdgeInsets.only(left: AppValues.margin_12),
          // child: CustomAsterisksTipsText(text: S.current.login_text_field_password_tips)),
          child: Obx(() {
            return CustomAsterisksTipsText(
                text: controller.pwdTypeBean.isNotEmpty ? controller.pwdTypeBean['typeName'] : "");
          })),
      const SizedBox(
        height: AppValues.margin_4,
      ),
      Container(
          margin: const EdgeInsets.only(left: 12, right: 12),
          child: Row(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Obx(() {
                      return CustomMainTextField(
                        keyboardType: const TextInputType.numberWithOptions(decimal: false),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                        ],
                        maxLength: 6,
                        isPwd: true,
                        // isUpdatePsdOffset: true,
                        hintText: controller.pwdTypeBean.isNotEmpty
                            ? controller.pwdTypeBean['typeName']
                            : "",
                        decoration: controller
                            .getBoxDecoration(controller.takeoutPasswordShowErrorHint.value),
                        showError: controller.takeoutPasswordShowErrorHint.value,
                        // errorText: controller.takeoutPasswordShowErrorStr.value,
                        // focusNode: controller.focusNodeTakeoutPassword,
                        text: controller.takeoutInputPassword.value,
                        inputCallBack: (source) {
                          controller.checkPasswordStr(source);
                          controller.takeoutInputPassword.value = source.toString();
                        },
                      );
                    }),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  controller.defaultOutputAmount.value = controller.takeoutSelectAmount.value;
                  controller.takeoutAmountController.text = controller.takeoutSelectAmount.value;
                  controller.takeoutAmountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: controller.takeoutAmountController.text.length),
                  );
                  controller.withdrawExchangeRateCount(controller.defaultOutputAmount.value, 2);
                },
                child: Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    // width: controller.globalController.isChinese() ? 100 : 126,
                    height: AppValues.defaultTextHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: ThemeService().colorScheme.tertiary,
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4), bottomRight: Radius.circular(4))),
                    child: CustomPasswordTips(
                      onPwdTypeSelected: (selectedPwdType) {
                        controller.pwdTypeBean.value = selectedPwdType;
                        // controller.takeoutPasswordShowErrorStr.value =
                        //     S.current.binding_bank_card_please_enter +
                        //         "${controller.pwdTypeBean["title"]}";
                        controller.takeoutPasswordShowErrorStr.value =
                            "${controller.pwdTypeBean["title"]}格式错误";
                        log("neco  密码配置 ${controller.pwdTypeBean['title']}");
                      },
                    )),
              )
            ],
          )),
      Obx(() {
        return Visibility(
            visible: controller.takeoutPasswordShowErrorHint.value,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: AppValues.smallPadding, left: AppValues.margin_12),
              child: CustomErrorTipsText(
                text: controller.takeoutPasswordShowErrorStr.value,
              ),
            ));
      }),
      const SizedBox(
        height: 26,
      ),
      Container(
          margin: const EdgeInsets.only(left: AppValues.margin_12, right: AppValues.margin_12),
          child: CustomBigMainButton(
              colorStyle: CustomButtonColorStyle.tertiary,
              onTap: (customButtonController) {
                // if (VaultUtil.isPayPasswordNotSetting()&&controller.setFundPassword() == false) {
                //   showCustomPromptToPwWidget(context: context);
                //   return;
                // }
                controller.balanceLocker(controller.takeout, controller.defaultOutputAmount.value,
                    customButtonController,
                    passWord: controller.takeoutInputPassword.value,
                    selectAmountCoinIc: controller.takeoutSelectAmountCoinIc.value,
                    isDeposit: false);
              },
              title: S.current.vault_takeout)),
      Obx(() {
        return Visibility(
            visible: VaultUtil.isSecretNot(),
            child: AuthWidget(
              tips: S.current.random_text_598,
            ));
      }),
      Obx(() {
        return Visibility(
            visible: !VaultUtil.isSecretNot(),
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
    ]);
  }

  //输入框
  Widget _inputWidget() {
    return Container(
      margin: const EdgeInsets.only(top: 4, left: AppValues.margin_12, right: AppValues.margin_12),
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  return CustomMainTextField(
                    decoration:
                        controller.getBoxDecoration(controller.takeoutAmountShowErrorHint.value),
                    controller: controller.takeoutAmountController,
                    // errorText: controller.takeoutAmountShowErrorStr.value,
                    showError: controller.takeoutAmountShowErrorHint.value,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,9}')),
                    ],
                    hintText: "",
                    text: controller.defaultOutputAmount.value,
                    inputCallBack: (source) {
                      controller.getErrorTakeoutStr(source);
                      if (source.isEmpty) {
                        controller.takeoutAmountShowErrorHint.value = false;
                        controller.defaultOutputAmount.value = source;
                      } else {
                        controller.withdrawExchangeRateCount(source, 2);
                        double inputAmount = double.parse(source);
                        var selectAmount = controller.takeoutSelectAmount.value;
                        double selAm = double.parse(selectAmount.isEmpty ? "0" : selectAmount);
                        if (inputAmount > selAm) {
                          controller.defaultOutputAmount.value =
                              controller.takeoutSelectAmount.value;
                          controller.takeoutAmountController.text =
                              controller.takeoutSelectAmount.value;
                          controller.takeoutAmountController.selection = TextSelection.fromPosition(
                            TextPosition(offset: controller.takeoutAmountController.text.length),
                          );
                        } else {
                          controller.defaultOutputAmount.value = source;
                        }
                      }
                    },
                  );
                }),
                Obx(() {
                  return Positioned(
                      right: 12,
                      child: Container(
                        alignment: Alignment.center,
                        height: AppValues.defaultTextHeight,
                        child: CustomNetWorkImage(
                          placeholder: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                          ),
                          errorWidget: const CustomAssetIcon(
                            name: 'assets/images/personal_center_icon/currency_default_ic.webp',
                          ),
                          imageUrl: controller.takeoutSelectAmountCoinIc.value,
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
              controller.defaultOutputAmount.value = controller.takeoutSelectAmount.value;
              controller.takeoutAmountController.text = controller.takeoutSelectAmount.value;
              controller.takeoutAmountController.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.takeoutAmountController.text.length),
              );
              controller.withdrawExchangeRateCount(controller.defaultOutputAmount.value, 2);
              controller.getErrorTakeoutStr(controller.takeoutSelectAmount.value);
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
            _coin()
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
        dataList: controller.balanceLockerList.value,
        isHeight: true,
        contentBuilder: (context, bean) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: AppValues.width_12,
              ),
              CustomText(
                  // "${controller.syl.value}"
                  controller.takeoutSelectAmount.value,
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
                imageUrl: controller.takeoutSelectAmountCoinIc.value,
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
        // controller.depositFun(bean);
        controller.takeoutFun(bean);
        controller.saveSelected(bean);
      },
      child: Container(
        color: Colors.transparent,
        // color: controller.isSelectedItem(bean)
        //     ? ThemeService().colorScheme.primary
        //     : Colors.transparent,
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
}
