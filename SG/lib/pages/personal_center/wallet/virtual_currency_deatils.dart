import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/pages/personal_center/wallet/custom_wallet.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../app/modules/virtual_payment_details/controllers/virtual_payment_details_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_big_outline_button.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/network_image/custom_network_image.dart';

///钱包-存款
final GlobalKey _globalKeyAddress = GlobalKey();
final GlobalKey _globalKeyAmount = GlobalKey();

class VirtualCurrencyDetails extends StatelessWidget {
  const VirtualCurrencyDetails({super.key, required this.virtualPaymentDetailsController});

  final VirtualPaymentDetailsController virtualPaymentDetailsController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppValues.defaultMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                  "${virtualPaymentDetailsController.coinBean.depositCoin?.currencyName ??
                      virtualPaymentDetailsController.currencyName}\t\t${virtualPaymentDetailsController.coinBean.depositCoin?.contractTypeName ??
                      virtualPaymentDetailsController.currencyContract}"),
              const SizedBox(
                width: 8,
              ),
              CustomNetWorkImage(
                imageUrl: virtualPaymentDetailsController.currencyIc,
                width: 18,
                height: 18,
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                borderRadius: BorderRadius.circular(4.0), // Adjust the corner radius
              ),
              padding: const EdgeInsets.all(4.0),
              child: QrImageView(
                  padding: const EdgeInsets.all(1.5),
                  backgroundColor: Colors.white,
                  // Set the background color
                  size: 120,
                  data:
                      "${virtualPaymentDetailsController.coinBean.depositCoin?.walletAddress ?? virtualPaymentDetailsController.coinBean.address}"),
            ),
          ),
          CustomText(
            S.current.vault_transfer_to_address,
            textColorStyle: CustomTextColorStyle.normal,
          ),
          _inputWidget(
              context,
              "${virtualPaymentDetailsController.coinBean.depositCoin?.walletAddress ?? virtualPaymentDetailsController.coinBean.address}",
              _globalKeyAddress),
          const SizedBox(
            height: 4,
          ),
          CustomText(
            S.current.vault_USDT_transfer_in_progress_Please_wait_for_confirmation(
                virtualPaymentDetailsController.coinBean.depositCoin?.currencyName ??
                    virtualPaymentDetailsController.currencyName),
            style:
                ThemeService().textTheme.labelMedium?.copyWith(color: AppThemes.reverseStateColor),
          ),
          const SizedBox(
            height: 12,
          ),
          CustomText(
            S.current.vault_transfer_amount(
                "：${virtualPaymentDetailsController.coinBean.depositCoin?.currencyName ?? virtualPaymentDetailsController.currencyName}"),
            textColorStyle: CustomTextColorStyle.normal,
          ),
          _inputWidget(
              context, virtualPaymentDetailsController.coinBean.amount ?? "", _globalKeyAmount),
          const SizedBox(
            height: 4,
          ),
          CustomText(
            S.current
                .vault_Confirm_deposit_with_full_amount_excluding_fees_to_avoid_issues_with_crediting,
            style:
                ThemeService().textTheme.labelMedium?.copyWith(color: AppThemes.reverseStateColor),
          ),
          const SizedBox(
            height: 12,
          ),
          Visibility(
            visible: (virtualPaymentDetailsController.coinBean.id ?? "").isEmpty ? false : true,
            child: SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomBigOutlineButton(
                      onTap: (btr) {
                        virtualPaymentDetailsController.coinCancel(context);
                      },
                      title: S.current.vault_Cancel_deposit_request,
                      lineColor: ThemeService().colorScheme.primary,
                      textColor: ThemeService().colorScheme.primary,
                    ),
                  ),
                  const SizedBox(
                    width: AppValues.defaultMargin,
                  ),
                  Expanded(
                      child: CustomBigMainButton(
                    title: S.current.vault_have_deposited,
                    onTap: (btr) {
                      virtualPaymentDetailsController.coinConfirm(context, btr);
                    },
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //输入框
  Widget _inputWidget(BuildContext context, String data, GlobalKey globalKey) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(left: 8,right: 20),
            alignment: Alignment.centerLeft,
            width: double.infinity,
          height: AppValues.defaultTextHeight,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.surface,
            border: Border.all(color: ThemeService().colorScheme.tertiary, width: 2),
            borderRadius: BorderRadius.circular(AppValues.smallRadius),
          ),
              child: CustomText(data,maxLines: 2,),
    ),
          Positioned(
              right: 0,
              child: GestureDetector(
                onTap: () {
                  DialogUtils.onClickCopy(context, data, globalKey);
                },
                child: Container(
                  key: globalKey,
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  color: Colors.transparent,
                  height: AppValues.defaultTextHeight,
                  child: const CustomAssetIcon(
                    size: 14,
                    color: AppThemes.widgetColorWhite,
                    name: "assets/images/personal_center_icon/copy.webp",
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
