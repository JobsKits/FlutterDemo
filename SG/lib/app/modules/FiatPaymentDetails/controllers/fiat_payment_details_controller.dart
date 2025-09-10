import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../model/wallet/PaymentDetails.dart';
import '../../../../services/api/api_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';

class FiatPaymentDetailsController extends GetxController {

  var bankBank=PaymentDetails();
  var symbol= "";

  BuildContext? context;

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if(arguments != null){
      if(arguments.containsKey('bankBean')){
        bankBank =  arguments['bankBean'] ?? {} ;
      }
      if(arguments.containsKey('symbol')){
        symbol =  arguments['symbol'] ?? {} ;
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  Future<void> bankConfirm(BuildContext context, CustomButtonController btnCtr ) async {
    btnCtr.showAnimation();
    await ApiService.instance.bankConfirm(
        success: (bean) {
          Get.back();
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            CustomSnackBar.showError(errorMessage, context);
          }
          btnCtr.hideAnimation();
        },
        id: bankBank.id ?? "",
    );
    Future.delayed(
      const Duration(seconds: 1),
          () {
        btnCtr.hideAnimation();
      },
    );
  }
  Future<void> bankCancel(BuildContext context  ) async {
    await ApiService.instance.bankCancel(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
      },
      id: bankBank.id ?? "",
    );
  }
  String formatBankAccountStr(String bankAccount) {
    List<String> chunks = [];
    int length = bankAccount.length;

    for (int i = 0; i < length; i += 4) {
      int endIndex = i + 4;
      if (endIndex > length) {
        endIndex = length; // 避免超出字符串长度
      }
      chunks.add(bankAccount.substring(i, endIndex));
    }

    return chunks.join(' ');
  }
}
