import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/widget/custom_tips*_text.dart.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../controllers/wallet_controller.dart';
import 'details_tips_view.dart';
import 'dialog_basic_view.dart';

final GlobalKey _globalKeyName = GlobalKey();
final GlobalKey _globalKeyBankAccount = GlobalKey();
final GlobalKey _globalKeyNameBankAreaCpf = GlobalKey();
final GlobalKey _globalKeyNameAmount = GlobalKey();

class PaymentDetailsView extends GetView<WalletCtrl> {
  PaymentDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicView(
      contentView: _rootView(),
    );
  }

  Widget _rootView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const TopTitleView(),
        // const SizedBox(
        //   height: 16,
        // ),
        CustomAsterisksTipsText(
          text: S.current.random_text_1130,
        ),
        getBg(Row(
          children: [
            CustomNetWorkImage(
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/currency_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/currency_default_ic.webp',
              ),
              imageUrl:
                  "${AppValues.defaultBranch.asset_url}/currency/${controller.applicationDep.currencyId}${controller.coinIcExtensionName}",
              width: 14,
              height: 14,
            ),
            CustomText(controller.fiatCurrBeanSel.value.name ?? "").marginOnly(left: 6)
          ],
        )),
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
          text: S.current.fiat_currency_payee_name,
        ),
        _textWidget(controller.applicationDep.bankcard?.openName ?? "", _globalKeyName),
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
          text: S.current.random_text_1210,
        ),
        _textWidget(
            controller.formatBankAccountStr(controller.applicationDep.bankcard?.bankAccount ?? ""),
            _globalKeyBankAccount),
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
          text: controller.applicationDep.currencyId == "702" ? S.current.random_text_1211 : S.current.random_text_591_copy,
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          padding: const EdgeInsets.only(left: AppValues.defaultPadding),
          height: AppValues.defaultTextHeight,
          decoration: BoxDecoration(
              color: ThemeService().colorScheme.tertiary,
              borderRadius: const BorderRadius.all(Radius.circular(4))),
          child: Row(children: [
            CustomNetWorkImage(
              fit: BoxFit.fitWidth,
              placeholder: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/pay_default_ic.webp',
              ),
              errorWidget: const CustomAssetIcon(
                name: 'assets/images/personal_center_icon/pay_default_ic.webp',
              ),
              width: 16,
              height: 16,
              imageUrl:
                  "${controller.payIcDomain}${controller.getChlIc(controller.pwySelBean.value)}${controller.chSelBean.value.alias}${controller.coinIcExtensionName}",
            ),
            const SizedBox(
              width: 8,
            ),
            CustomText(controller.applicationDep.bankcard?.bankId ?? "")
          ]),
        ),
        // Visibility(
        //     visible: controller.applicationDep.currencyId == "701" ? true : false,
        //     child: _textWidget(
        //         "${S.current.wallet_accountOpeningOutlets}：${controller.applicationDep.bankcard?.bankAreaCpf ?? ""}",
        //         _globalKeyNameBankAreaCpf)),
        const SizedBox(
          height: 16,
        ),
        CustomAsterisksTipsText(
          text: S.current.random_text_1183,
        ),
        _textWidget(
            //${S.current.wallet_transferAmount}：\t${controller.fiatCurrBeanSel.value.symbol}
            "${MoneyUtil.toCoinAmountFormat(controller.applicationDep.currencyId, controller.applicationDep.amount)}",
            _globalKeyNameAmount),
        DetailsTipsView(S.current.random_text_1212),
        // CustomText(
        //   S.current.fiat_currency_transfer_amount_must_match_the_order_amount,
        //   style: ThemeService().textTheme.bodySmall?.copyWith(color: AppThemes.reverseStateColor),
        // ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomBigMainButton(
                    onTap: (btr) {
                      controller.bankCancel(controller.context, controller.applicationDep.id ?? "");
                      },
                    colorStyle: CustomButtonColorStyle.secondaryIcon,
                    title: S.current.random_text_1184,
                    height: 50
                ),
              ),
              const SizedBox(
                width: AppValues.margin_30,
              ),
              Expanded(
                  child: CustomBigMainButton(
                      title: S.current.random_text_1185,
                      colorStyle: CustomButtonColorStyle.tertiary,
                      onTap: (btr) {
                        controller.bankConfirm(
                            controller.context, btr, controller.applicationDep.id ?? "");
                      },
                      height: 50
              )),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        // CustomErrorTipsText(
        //   text: S.current
        //       .fiat_currency_confirm_promptly_after_successful_transfer_to_avoid_scoring_delays,
        //   iconSize: 12,
        //   textStyle: const TextStyle(color: AppThemes.reverseStateColor, fontSize: 12),
        // )
      ],
    );
  }

  Widget _textWidget(String content, GlobalKey globalKey) {
    return Container(
      key: globalKey,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 13),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.tertiary, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(top: 5),
      child: Stack(
        children: [
          CustomText(
            content,
          ),
          Positioned(
              right: 4,
              child: GestureDetector(
                onTap: () {
                  controller.onClickCopy(controller.context, content, globalKey);
                },
                child: const CustomAssetIcon(
                  size: 14,
                  color: AppThemes.onTertiaryColor,
                  name: "assets/images/personal_center_icon/copy.webp",
                ),
              ))
        ],
      ),
    );
  }

  Widget getBg(Widget childView) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 13, bottom: 13),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.tertiary, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(top: 5),
      child: childView,
    );
  }
}
