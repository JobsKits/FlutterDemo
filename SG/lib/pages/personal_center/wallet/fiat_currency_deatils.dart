import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_bubble.dart';
import 'package:flutter_bet/widget/custom_error_tips_text.dart.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/input/custom_main_text_field.dart';

import '../../../app/modules/FiatPaymentDetails/controllers/fiat_payment_details_controller.dart';
import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/button/custom_big_main_button.dart';
import '../../../widget/button/custom_big_outline_button.dart';
import '../../../widget/dialog/bubble_dialog.dart';
import '../../../widget/dialog/dialog_utils.dart';
final GlobalKey _globalKeyName = GlobalKey();
final GlobalKey _globalKeyBankAccount = GlobalKey();
final GlobalKey _globalKeyNameBankAreaCpf = GlobalKey();
final GlobalKey _globalKeyNameAmount = GlobalKey();
class FiatCurrencyDetails extends StatelessWidget {
  final FiatPaymentDetailsController detailsController;

  const FiatCurrencyDetails({super.key, required this.detailsController });

  @override
  Widget build(BuildContext context) {
    detailsController.context = context;
    return Container(
      margin: const EdgeInsets.all(AppValues.defaultMargin),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            S.current.fiat_currency_payee_name, textColorStyle: CustomTextColorStyle.normal,),
          _textWidget(detailsController.bankBank.bankcard?.openName??"",_globalKeyName),
          _textWidget(detailsController.formatBankAccountStr(detailsController.bankBank.bankcard?.bankAccount??"") ,_globalKeyBankAccount),
          const SizedBox(height: 12,),
          Container(
            padding: const EdgeInsets.only(left: AppValues.defaultPadding),
            height: AppValues.defaultTextHeight,
            decoration: BoxDecoration(
                color: ThemeService().colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(4))
            ),
            child: Row(children: [
              const CustomAssetIcon(name: "assets/images/personal_center_icon/bank.webp",),
              const SizedBox(width: 8,),
              CustomText(detailsController.bankBank.bankcard?.bankId??"")
            ]),
          ),
          //https://jira.vgtech.org/browse/STAK-222
          Visibility(visible: detailsController.bankBank.currencyId=="701"?true:false
              ,child: _textWidget("${S.current.wallet_accountOpeningOutlets}：${detailsController.bankBank.bankcard?.bankAreaCpf??""}",_globalKeyNameBankAreaCpf)),
          _textWidget("${S.current.wallet_transferAmount}：${detailsController.bankBank.amount}\t${detailsController.symbol}",_globalKeyNameAmount),
          const SizedBox(height: 4,),
          CustomText(S.current.fiat_currency_transfer_amount_must_match_the_order_amount,
            style: ThemeService().textTheme.bodySmall?.copyWith(
                color: AppThemes.reverseStateColor),),
          const SizedBox(height: 12,),
          SizedBox(height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomBigOutlineButton(
                    onTap: (btr) {
                      detailsController.bankCancel(context);
                    },
                    title: S.current.vault_Cancel_deposit_request,
                    lineColor: ThemeService().colorScheme.primary,
                    textColor: ThemeService().colorScheme.primary,),
                ),
                const SizedBox(width: AppValues.defaultMargin,),
                Expanded(child: CustomBigMainButton(title: S.current.vault_have_deposited,onTap: (btr){
                  detailsController.bankConfirm(context,btr);
                },)),
              ],
            ),
          ),
          const SizedBox(height: 12,),
          CustomErrorTipsText(text: S.current
              .fiat_currency_confirm_promptly_after_successful_transfer_to_avoid_scoring_delays,
            iconSize: 12,
            textStyle: const TextStyle(color: AppThemes.reverseStateColor, fontSize: 12),)
        ],
      ),
    );
  }
  //输入框
  Widget _textWidget(String content,GlobalKey globalKey) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Stack(
        children: [
          CustomMainTextField(enabled: false, text: content,),
          Positioned(
              right: 0,
              child: GestureDetector(
                onTap: (){
                  DialogUtils.onClickCopy(detailsController.context,content,globalKey);
                },
                child: Container(
                key: globalKey,
                  padding: const EdgeInsets.only(left: 20,right: 10),
                  color: Colors.transparent,
                  height: AppValues.defaultTextHeight,
                  child:   const CustomAssetIcon(
                     size: 14,color: AppThemes.widgetColorWhite,name: "assets/images/personal_center_icon/copy.webp",),
                ),
              ))
        ],
      ),
    );
  }
}