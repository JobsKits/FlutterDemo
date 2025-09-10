import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_dialog_base_view.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../controllers/commission_wallet_controller.dart';
import 'commission_wallet_view.dart';

///佣金钱包 弹窗模式
class CommissionWalletDialog extends CustomDialogBaseView {
  CommissionWalletDialog({super.key});

  ///打开对话框
  static void openDialog() {
    GlobalStateController.of().showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      dialogView: CommissionWalletDialog(),
    ).then((value) => GlobalStateController.of().showOverlayView());
  }

  @override
  StatefulElement createElement() {
    Get.lazyPut<CommissionWalletController>(() => CommissionWalletController());
    return super.createElement();
  }

  @override
  void onCloseDialog() {
    super.onCloseDialog();
  }

  @override
  void onDeleteDialog() {
    super.onDeleteDialog();
    Get.delete<CommissionWalletController>();
  }

  @override
  String buildTitleAsset() {
    return "assets/images/top_wallet.png";
  }

  @override
  String buildTitleLabel() {
    return S.current.random_text_516;
  }

  @override
  List<Widget> buildContentView() {
    return [
      // _buildConditionView(),
      _buildContentListView(),
    ];
  }

  ///条件view
  Widget _buildConditionView() {
    return Container();
  }

  ///列表view
  Widget _buildContentListView() {
    return SizedBox(
      height: Get.height - AppValues.barTopBottomHeightMargin ,
      child: const CommissionWalletView(),
    );
  }
}
