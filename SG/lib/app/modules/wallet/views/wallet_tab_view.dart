import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:get/get.dart';

import '../../../../utils/vault_util.dart';
import 'deposit_view.dart';
import 'exchange_curr.dart';
import 'tabbar_wallet.dart';
import 'withdraw_view.dart';

class WalletTab extends GetView<WalletCtrl> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBarWallet(),
        Obx(() {
          return getView(controller.tabPos.value) ?? const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget? getView(int tabPos) {
    switch (tabPos) {
      case 0:
        return DepositView();
      case 1:
        return WithdrawView();
      case 2:
        // STAK-12694
        var fiatCurNum = controller.globalController.currTypeLists
            .where((bean) => bean.currency_type == 1)
            .toList()
            .length;
        var cryptoCurNum = controller.globalController.currTypeLists
            .where((bean) => bean.currency_type != 1)
            .toList()
            .length;
        if (VaultUtil.isShowExchangeCurrency() && fiatCurNum > 1 && cryptoCurNum > 1) {
          return ExchangeCurr();
        } else {
          return null;
        }
      default:
        return null;
    }
  }
}
