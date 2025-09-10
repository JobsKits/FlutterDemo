import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';

import '../../../../app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import '../../../../app/modules/binding_pix/controllers/binding_pix_controller.dart';
import '../../../../app/modules/binding_virtual_address/controllers/binding_virtual_address_controller.dart';
import '../../../../app/modules/wallet/views/bind_bk_info.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/dialog/custom_dialog_base_view.dart';
import '../a_model/wallet_common_params.dart';
import '../binding_pix.dart';
import '../binding_virtual_address.dart';
import 'custom_card_banding_dialog_logic.dart';

///钱包 绑定对话框
class CustomCardBandingDialog extends CustomDialogBaseView {
  CustomCardBandingDialog({
    super.key,
    super.dialogMaxHeight,
    required this.bandingType,
    required this.currencyId,
    this.bankTree,
    this.contractType,
    this.currencyName,
    this.id,
    this.contractId,
  });

  final bool resizeToAvoidBottomInset = true;

  ///打开对话框
  static void openDialog({
    required bandingType,
    required currencyId,
    bankTree,
    contractType,
    currencyName,
    id,
    contractId,
  }) {
    var maxHeight = Get.height - AppValues.barTopBottomHeightMargin;
    CustomDialogBaseView.showDetailDialog(
      context: Get.overlayContext!,
      dialogView: CustomCardBandingDialog(
        dialogMaxHeight: maxHeight,
        bandingType: bandingType,
        currencyId: currencyId,
        bankTree: bankTree,
        contractType: contractType,
        currencyName: currencyName,
        id: id,
        contractId: contractId,
      ),
    );
  }

  ///页面参数
  final String currencyId;
  final String? bankTree;
  final List<dynamic>? contractType;
  final String? contractId;
  final String? currencyName;
  final String? id;
  final CardBandingTypeEnum bandingType;

  @override
  StatefulElement createElement() {
    // logic = Get.put<CustomCardBandingDialogLogic>(CustomCardBandingDialogLogic());

    if (bandingType == CardBandingTypeEnum.brl) {
      Get.put(BindingPixController(dialogParams: {
        "currencyId": currencyId,
        "bankTree": bankTree,
        "id": id,
      }));
    } else if (bandingType == CardBandingTypeEnum.fiat) {
      Get.put(BindingBankCardController(dialogParams: {
        "currencyId": currencyId,
        "bankTree": bankTree,
        "id": id,
      }));
    } else if (bandingType == CardBandingTypeEnum.crypto) {
      Get.put(BindingVirtualAddressController(dialogParams: {
        "currencyId": currencyId,
        "contractType": contractType,
        "contractId": contractId,
        "currencyName": currencyName,
        "id": id,
      }));
    } else {}
    return super.createElement();
  }

  @override
  void onBackDialog() {
    super.onBackDialog();
    RouteUtil.popView();
  }

  @override
  void onDeleteDialog() {
    removeController();
    super.onDeleteDialog();
  }

  void removeController() {
    Get.delete<BindingPixController>();
    Get.delete<BindingBankCardController>();
    Get.delete<BindingVirtualAddressController>();
    Get.delete<CustomCardBandingDialogLogic>();
  }

  @override
  String buildTitleAsset() {
    return "assets/images/common/ic_common_back_gray.webp";
  }

  @override
  String buildTitleLabel() {
    return bandingType == CardBandingTypeEnum.crypto
        ? S.current.random_text_1127
        : currencyId == "702"
            ? S.current.bind_pix_account
            : S.current.binding_bank_card;
  }

  @override
  List<Widget> buildContentView() {
    return [
      // _buildConditionView(),
      // _buildContentListView(),
      // BindingPixView(),
      // SingleChildScrollView(child: BindingPix(flag: "2",))
      // BindingPix(flag: "2"),
      // BindingBankCard(flag: "2"),
      // BindingVirtualAddress(flag: "2"),
      getBandingView(bandingType),
      const SizedBox(height: AppValues.defaultMargin),
    ];
  }

  Widget getBandingView(CardBandingTypeEnum bandingType) {
    switch (bandingType) {
      case CardBandingTypeEnum.brl:
        // 巴西币
        return BindingPix(flag: "2");
      case CardBandingTypeEnum.vnd:
      case CardBandingTypeEnum.cny:
      case CardBandingTypeEnum.fiat:
        // 法币
        final resizeToAvoidBottomInset = true;
        return BindBkInfoView();
      case CardBandingTypeEnum.crypto:
        // 加密货币
        return BindingVirtualAddress(flag: "2");
      default:
        return Container();
    }
  }
}
