import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_details_crypto_view.dart';
import 'package:flutter_bet/app/modules/wallet/views/payment_details_view.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../widget/dialog/custom_dialog_base_view.dart';

class PayDetailsDialogView extends CustomDialogBaseView {
  PayDetailsDialogView(this.fiatCurr, {super.key});

  final bool fiatCurr;

  final double dialogMaxHeight = Get.height - AppValues.barTopBottomHeightMargin - 50;

  static void openDialog(bool fiatCurr) {
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      barrierDismissible: true,
      dialogView: PayDetailsDialogView(fiatCurr),
    );
  }

  @override
  StatefulElement createElement() {
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
  }

  @override
  String buildTitleAsset() {
    return "";
  }

  @override
  String buildTitleLabel() {
    return "";
  }

  @override
  List<Widget> buildContentView() {
    return [getView()];
  }

  Widget getView() {
    return fiatCurr ? PaymentDetailsView() : CryptoDetails();
  }
}
