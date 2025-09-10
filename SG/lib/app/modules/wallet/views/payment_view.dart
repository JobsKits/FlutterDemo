import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/pact_sel_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_m_sel_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/top_title_view.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../controllers/wallet_controller.dart';
import 'coin_sel_view.dart';
import 'deposit_amount_view.dart';
import 'deposit_bank_sel_view.dart';
import 'deposit_name_view.dart';

class PaymentView extends GetView<WalletCtrl> {
  PaymentView({super.key});

  final GlobalKey rootViewGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(AppValues.defaultMargin),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                color: ThemeService().colorScheme.background,
              ),
              child: Column(
                // key: rootViewGlobalKey,
                children: [
                  const TopTitleView(),
                  CoinSelView(
                    // rootViewGlobalKey,
                    isPayment: true,
                  ),
                  getView(),
                  DepositBankSelView(),
                  DepositNameView(),
                  DepositAmountView(),
                ],
              )),
        ));
  }

  Widget getView() {
    if (controller.getMergerSelCoin(controller.fiatCurrTabSel.value).currency_type == 2) {
      return PactSelView((model) {
        controller.saveSelectedPact(model);
      });
    } else {
      return PaymentMethodSelSelView();
    }
  }
}
