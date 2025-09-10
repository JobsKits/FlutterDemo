import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/auth_widget.dart';
import 'package:get/get.dart';

import '../../../../generated/l10n.dart';
import '../../../../pages/personal_center/vault/vault_controller.dart';
import '../../../../pages/personal_center/vault/vault_tabbar.dart';
import '../../../../pages/setup/index/logic.dart';
import '../../../../widget/dialog/custom_dialog_base_view.dart';

/// 保险库 对话框
class VaultDialogView extends CustomDialogBaseView {
  VaultDialogView({super.key});
  final double dialogMaxHeight = Get.height - AppValues.barTopHeight - AppValues.barBottomHeight;
  ///打开对话框
  static void openDialog() {
    late VaultController controller = Get.find<VaultController>();
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      barrierDismissible: true,
      dialogView: VaultDialogView(),
    ).then((value) => {GlobalStateController.of().showOverlayView()});
    Future.delayed(const Duration(milliseconds: 100), () {
      GlobalStateController.of().showOverlayView(isShowTopBarView: false, isShowBottomBarView: false);
    });
    Obx(() => controller.isDeposits.value == false ? AuthWidget(tips: S.current.random_text_598) : SizedBox());
  }

  @override
  StatefulElement createElement() {
    Get.put<VaultController>(VaultController());
    return super.createElement();
  }

  @override
  void onCloseDialog() {
    super.onCloseDialog();
    Get.delete<VaultController>();
  }

  @override
  void onDeleteDialog() {
    super.onDeleteDialog();
    Get.delete<VaultController>();
    if (Get.isRegistered<SetupLogic>()) {
      // 由于提款有使用绑定电邮业务 有用到SetupLogic
      Get.delete<SetupLogic>();
    }
  }

  @override
  String buildTitleAsset() {
    return "assets/images/personal_center_icon/vault.webp";
  }

  @override
  String buildTitleLabel() {
    return S.current.vault;
  }

  @override
  List<Widget> buildContentView() {
    return [const VaultTabBar()];
  }
}
