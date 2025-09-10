import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/dialog/custom_dialog_base_view.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import 'commission_history_logic.dart';
import 'commission_history_view.dart';

///佣金历史改为 弹窗模式
class CommissionHistoryDialog extends CustomDialogBaseView {
  CommissionHistoryDialog({super.key});

  ///打开对话框
  static void openDialog() {
    GlobalStateController.of().showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      dialogView: CommissionHistoryDialog(),
    ).then((value) => GlobalStateController.of().showOverlayView());
  }

  @override
  StatefulElement createElement() {
    Get.lazyPut<CommissionHistoryLogic>(() => CommissionHistoryLogic());
    return super.createElement();
  }

  @override
  void onCloseDialog() {
    super.onCloseDialog();
  }

  @override
  void onDeleteDialog() {
    super.onDeleteDialog();
    Get.delete<CommissionHistoryLogic>();
  }

  @override
  String buildTitleAsset() {
    return "assets/images/alliance/ic_alliance_commission_history_title.webp";
  }

  @override
  String buildTitleLabel() {
    return S.current.random_text_517;
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
    return Container(
      // height: Get.height - AppValues.barTopBottomHeightMargin * 1.3,
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: CommissionHistoryPage(),
    );
  }
}
