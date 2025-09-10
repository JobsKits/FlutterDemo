import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../../model/wallet/CoinPaymentDetailsBean.dart';
import '../../../../services/api/api_service.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';

class VirtualPaymentDetailsController extends GetxController {

  var coinBean=CoinPaymentDetailsBean();
  var currencyIc="";
  var currencyName="";
  var currencyContract="";

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if(arguments != null){
      if(arguments.containsKey('coinBean')){
        coinBean =  arguments['coinBean'] ?? {} ;
      }
      if(arguments.containsKey('currencyIc')){
        currencyIc = arguments['currencyIc'] ?? "";
      }
      if(arguments.containsKey('currencyName')){
        currencyName = arguments['currencyName'];
      }
      if(arguments.containsKey('currencyContract')){
        currencyContract = arguments['currencyContract'];
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
  Future<void> coinConfirm(BuildContext context, CustomButtonController btnCtr ) async {
    btnCtr.showAnimation();
    await ApiService.instance.coinConfirm(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
        btnCtr.hideAnimation();
      },
      id: coinBean.id ?? "",
    );
    Future.delayed(
      const Duration(seconds: 1),
          () {
        btnCtr.hideAnimation();
      },
    );
  }
  Future<void> coinCancel(BuildContext context  ) async {
    await ApiService.instance.coinCancel(
      success: (bean) {
        Get.back();
      },
      fail: (errorMessage) {
        if (errorMessage != null) {
          CustomSnackBar.showError(errorMessage, context);
        }
      },
      id: coinBean.id ?? "",
    );
  }
}
