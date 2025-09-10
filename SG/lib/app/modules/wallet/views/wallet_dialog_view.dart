import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/wallet_tab_view.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../pages/account/ThirdPartyAuthorizationToController.dart';
import '../../../../pages/setup/index/logic.dart';
import '../../../../widget/dialog/custom_dialog_base_view.dart';
import '../controllers/exchange_ctrl.dart';
import '../controllers/wallet_controller.dart';
import '../controllers/withdraw_ctrl.dart';

class WalletDialogView extends CustomDialogBaseView {
  WalletDialogView({super.key});

  final double dialogMaxHeight = Get.height - AppValues.barTopBottomHeightMargin - 50;
  final bool resizeToAvoidBottomInset = true;

  static void openDialog() {
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      barrierDismissible: true,
      dialogView: WalletDialogView(),
    ).then((value) => {GlobalStateController.of().showOverlayView()});
    Future.delayed(const Duration(milliseconds: 100), () {
      GlobalStateController.of()
          .showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
    });
  }

  @override
  StatefulElement createElement() {
    Get.put<WalletCtrl>(WalletCtrl());
    Get.put<ExchangeCtrl>(ExchangeCtrl());
    return super.createElement();
  }

  @override
  void onCloseDialog() {
    super.onCloseDialog();
  }

  @override
  void onDeleteDialog() {
    // TODO: implement onDeleteDialog
    super.onDeleteDialog();
    // Get.delete<WalletController>();
    Get.delete<WalletCtrl>();
    Get.delete<ExchangeCtrl>();
    Get.delete<WithDrawCtrl>();
    if (Get.isRegistered<FiatPaymentDetailsToController>()) {
      Get.delete<FiatPaymentDetailsToController>();
    }
    if (Get.isRegistered<SetupLogic>()) {
      // 由于提款有使用绑定电邮业务 有用到SetupLogic
      Get.delete<SetupLogic>();
    }
  }

  @override
  String buildTitleAsset() {
    return "assets/images/top_wallet.png";
  }

  @override
  String buildTitleLabel() {
    return S.current.wallet;
  }

  @override
  List<Widget> buildContentView() {
    return [
      WalletTab(),
    ];
  }
}
