import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../constant/app_themes.dart';
import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/money_util.dart';
import '../../../../widget/button/custom_big_main_button.dart';
import '../../../../widget/button/custom_button_style.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/custom_text.dart';
import '../../../../widget/custom_tips*_text.dart.dart';
import '../../../../widget/network_image/custom_network_image.dart';
import '../controllers/wallet_controller.dart';
import 'details_tips_view.dart';
import 'dialog_basic_view.dart';

final GlobalKey _globalKeyAddress = GlobalKey();
final GlobalKey _globalKeyAmount = GlobalKey();

class CryptoDetails extends GetView<WalletCtrl> {
  const CryptoDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicView(
      contentView: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const TopTitleView(),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomText(S.current.wallet_currency),
          //     const SizedBox(
          //       width: 20,
          //     ),
          //     CustomText(S.current.random_text_1181),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.wallet_currency_copy,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  getBg(Row(
                    children: [
                      CustomNetWorkImage(
                        imageUrl: controller.cryptoBeanSel.value.coinIc ?? "",
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CustomText(
                          "${controller.cryptoDep.depositCoin?.currencyName ?? controller.cryptoBeanSel.value.name}"),
                    ],
                  )),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomText(
                    S.current.random_text_1181,
                    textColorStyle: CustomTextColorStyle.normal,
                  ),
                  getBg(CustomText(
                      "${controller.cryptoDep.depositCoin?.contractTypeName ?? controller.currDepSelCtrStr}")),
                ],
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     CustomText(
          //         "${controller.cryptoDep.depositCoin?.currencyName ?? controller.cryptoBeanSel.value.name}\t\t${controller.cryptoDep.depositCoin?.contractTypeName ?? controller.currDepSelCtrStr}"),
          //     const SizedBox(
          //       width: 8,
          //     ),
          //     CustomNetWorkImage(
          //       imageUrl: controller.cryptoBeanSel.value.coinIc ?? "",
          //       width: 18,
          //       height: 18,
          //     ),
          //   ],
          // ),
          const SizedBox(
            height: 11,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(4.0), // Adjust the corner radius
              ),
              padding: const EdgeInsets.all(4.0),
              child: QrImageView(
                  padding: const EdgeInsets.all(10),
                  backgroundColor: Colors.white,
                  // Set the background color
                  size: 170,
                  data:
                      "${controller.cryptoDep.depositCoin?.walletAddress ?? controller.cryptoDep.address}"),
            ),
          ),
          // CustomText(
          //   // S.current.vault_transfer_to_address,
          //   "收款地址",
          //   textColorStyle: CustomTextColorStyle.normal,
          // ),
          const SizedBox(
            height: 16,
          ),
          CustomAsterisksTipsText(
            text: S.current.random_text_1182,
          ),

          _inputWidget(
              context,
              "${controller.cryptoDep.depositCoin?.walletAddress ?? controller.cryptoDep.address}",
              _globalKeyAddress),
          // CustomText(
          //   S.current.vault_USDT_transfer_in_progress_Please_wait_for_confirmation(
          //       controller.cryptoDep.depositCoin?.currencyName ??
          //           controller.cryptoBeanSel.value.name ??
          //           ""),
          //   style: ThemeService()
          //       .textTheme
          //       .labelMedium
          //       ?.copyWith(color: AppThemes.reverseStateColor),
          // ),
          const SizedBox(
            height: 16,
          ),
          // CustomText(
          //   S.current.vault_transfer_amount(
          //       "：${controller.cryptoDep.depositCoin?.currencyName ?? controller.cryptoBeanSel.value.name}"),
          //   textColorStyle: CustomTextColorStyle.normal,
          // ),
          CustomAsterisksTipsText(
            text: S.current.random_text_1183,
          ),
          _amountView(context, controller.cryptoDep.amount ?? "", _globalKeyAmount),
          // _inputWidget(context, controller.cryptoDep.amount ?? "", _globalKeyAmount, amt: true),
          const SizedBox(
            height: 4,
          ),
          // CustomText(
          //   S.current
          //       .vault_Confirm_deposit_with_full_amount_excluding_fees_to_avoid_issues_with_crediting,
          //   style: ThemeService()
          //       .textTheme
          //       .labelMedium
          //       ?.copyWith(color: AppThemes.reverseStateColor),
          // ),
          DetailsTipsView(S.current.random_text_1180),
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: (controller.cryptoDep.id ?? "").isEmpty ? false : true,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomBigMainButton(
                      fontWeight: FontWeight.w600,
                      onTap: (btr) {
                        controller.coinCancel(context);
                      },
                      // title: S.current.vault_Cancel_deposit_request,
                      title: S.current.random_text_1184,
                      colorStyle: CustomButtonColorStyle.secondaryIcon,
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.margin_20,
                  ),
                  Expanded(
                      child: CustomBigMainButton(
                    fontWeight: FontWeight.w600,
                    colorStyle: CustomButtonColorStyle.tertiary,
                    // title: S.current.vault_have_deposited,
                    title: S.current.random_text_1185,
                    onTap: (btr) {
                      controller.coinConfirm(context, btr);
                    },
                  )),
                ],
              ),
            ).marginOnly(bottom: 10),
          )
        ],
      ),
    );
  }

  Widget _inputWidget(BuildContext context, String data, GlobalKey globalKey, {bool amt = false}) {
    return Container(
      key: globalKey,
      padding: EdgeInsets.only(left: amt ? 10 : 10),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: AppValues.defaultTextHeight,
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.tertiary,
        // border: Border.all(color: ThemeService().colorScheme.tertiary),
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      margin: const EdgeInsets.only(top: 4),
      child: Stack(
        children: [
          CustomText(
            data,
            maxLines: 2,
          ).marginOnly(right: 22),
          Positioned(
              top: 0,
              bottom: 0,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  DialogUtils.onClickCopy(context, data, globalKey);
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

  Widget _amountView(BuildContext context, String data, GlobalKey globalKey) {
    return Container(
      key: globalKey,
      padding: EdgeInsets.only(left: 10),
      width: double.infinity,
      alignment: Alignment.centerLeft,
      height: AppValues.defaultTextHeight,
      decoration: BoxDecoration(
        color: ThemeService().colorScheme.tertiary,
        borderRadius: BorderRadius.circular(AppValues.smallRadius),
      ),
      margin: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          CustomNetWorkImage(
            imageUrl: controller.cryptoBeanSel.value.coinIc ?? "",
            width: 14,
            height: 14,
          ),
          const SizedBox(
            width: 8,
          ),
          CustomText(
            MoneyUtil.toCoinAmountFormat(controller.cryptoDep.depositCoin?.currencyId, data),
            maxLines: 2,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              DialogUtils.onClickCopy(context, data, globalKey);
            },
            child: const CustomAssetIcon(
              size: 14,
              color: AppThemes.onTertiaryColor,
              name: "assets/images/personal_center_icon/copy.webp",
            ).marginOnly(right: 10),
          )
        ],
      ),
    );
  }

  Widget getBg(Widget childView) {
    return Container(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 13, bottom: 13),
      decoration: BoxDecoration(
          color: ThemeService().colorScheme.surface, borderRadius: BorderRadius.circular(4)),
      margin: const EdgeInsets.only(top: 5),
      child: childView,
    );
  }
}
