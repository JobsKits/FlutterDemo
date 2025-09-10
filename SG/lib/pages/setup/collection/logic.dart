import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

class SetupCollectionInfoController extends GetxController {
  final isERC20 = false.obs;
  final isTRC20 = true.obs;
  final usdtInputText = ''.obs;
  final CustomButtonController buttonCtr = CustomButtonController();

  Future<void> onWalletInsert(
      BuildContext context, CustomButtonController btnCtr,
      {required String name, String? type, required String address}) async {
    btnCtr.showAnimation();
    await ApiService.instance.walletInsert(
        contractType: type ?? '',
        currencyId: name,
        address: address,
        isDefault:1,
        payPassword: "123456", //资金密码
        success: (message) {
          CustomSnackBar.show(message, context,
              preIcon: CustomSnackBarIcons.error);
        },
        fail: (message) { //
          if (message?.isNotEmpty == false) return;
          CustomSnackBar.show(message!, context,
              preIcon: CustomSnackBarIcons.error);
        }, authType: ''); //无地方使用
    btnCtr.hideAnimation();

  }
}
