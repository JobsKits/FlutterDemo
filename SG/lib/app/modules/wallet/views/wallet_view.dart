import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/wallet/wallet_tabbar.dart';
import '../../../../widget/custom_back_icon_button.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: const CustomBackIconButton(
            style: CustomBackIconButtonStyle.normal,
          ),
          title: Text(
            S.current.wallet,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: const WalletTabBar());
  }
}
