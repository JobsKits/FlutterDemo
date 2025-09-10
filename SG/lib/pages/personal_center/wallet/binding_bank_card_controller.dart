import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/personal_center/wallet/wallet_controller.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:get/get.dart';

import '../../../app/modules/binding_bank_card/controllers/binding_bank_card_controller.dart';
import '../../../app/modules/binding_pix/controllers/binding_pix_controller.dart';
import '../../../app/modules/binding_virtual_address/controllers/binding_virtual_address_controller.dart';
import '../../../app/modules/wallet/controllers/comm_ctrl.dart';
import '../../../app/modules/wallet/controllers/withdraw_ctrl.dart';
import '../../../generated/l10n.dart';
import '../../../services/api/api_service.dart';
import '../../../services/event/event_service.dart';
import '../../../widget/button/custom_button_controller.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';

class BindingBankCardControllerOld extends BaseController
    with GetTickerProviderStateMixin, CommonCtrl {
  BuildContext? context;
  String? bankTree;

  // final GlobalStateController globalController = Get.find<GlobalStateController>();

  // var passwordContr= "";
  // var passwordShowError= false.obs;
  // var passwordShowErrorText= "";

  var currencyId = "";
  var id = "";

  final pwdTypeBean = {}.obs;
  final inputPassWord = "".obs;
  final inputPassWordShowError = false.obs;
  final inputPassWordShowErrorText = "".obs;

  String name = "";
  List<dynamic> contractType = [];

  @override
  void onInit() {
    super.onInit();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments.containsKey('currencyId')) {
        currencyId = arguments['currencyId'] ?? "";
        id = currencyId;
      }
      if (arguments.containsKey('bankTree')) {
        bankTree = arguments['bankTree'] ?? "";
      }
      if (arguments.containsKey('contractType')) {
        contractType = arguments['contractType'];
      }
      if (arguments.containsKey('currencyName')) {
        name = arguments['currencyName'];
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

  @override
  void dispose() {
    super.dispose();
  }

  checkInputPassWord() {
    if (inputPassWord.value.isEmpty) {
      inputPassWordShowError.value = true;
      // inputPassWordShowErrorText.value =  S.current.wallet_pleaseEnterFundPassword;
      inputPassWordShowErrorText.value =
          S.current.binding_bank_card_please_enter + "${pwdTypeBean["title"]}";
    } else {
      if (inputPassWord.value.length < 6) {
        inputPassWordShowError.value = true;
        inputPassWordShowErrorText.value = S.current.wallet_yourFundPasswordContainsDigit("6");
      } else {
        inputPassWordShowError.value = false;
        inputPassWordShowErrorText.value = "";
      }
    }
  }

  Future<void> removeAddress(BuildContext context, CustomButtonController btnCtr, String id) async {
    if (id.isEmpty) {
      return;
    }
    checkInputPassWord();
    if (inputPassWordShowError.value) {
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.removeAddress(
        success: (message) {
          EventService.instance.dispatchEvent(kAddressRefEvent);
          EventService.instance.dispatchEvent(kWalletRefAddressEvent);
          Get.delete<BindingVirtualAddressController>();
          Get.back();
          CustomSnackBar.show(
              title: S.current.success_pwd,
              message,
              context,
              preIcon: CustomSnackBarIcons.verifySucceed);
          inputPassWord.value = "";
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            CustomSnackBar.show(
                title: S.current.transactions_detail_state_fail,
                errorMessage,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        },
        id: id,
        payPassword: inputPassWord.value,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "");
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  Future<void> removeBankcard(
      BuildContext context, CustomButtonController btnCtr, String id, String currencyId) async {
    if (id.isEmpty) {
      return;
    }
    checkInputPassWord();
    if (inputPassWordShowError.value) {
      return;
    }
    // log("neco 删除银行卡 密码 ${passwordContr}  币种ID：${currencyId}");
    // if(passwordContr.isEmpty){
    //   passwordShowError.value = true ;
    //   passwordShowErrorText = S.current.wallet_pleaseEnterFundPassword;
    //   return;
    // }
    btnCtr.showAnimation();
    await ApiService.instance.removeBankcard(
        success: (message) {
          //https://vgstake.atlassian.net/browse/STAK-534
          EventService.instance.dispatchEvent(kBnkRefEvent);

          EventService.instance.dispatchEvent(kWalletRefEvent);
          Get.delete<BindingBankCardController>();
          Get.delete<BindingPixController>();
          Get.back();
          CustomSnackBar.show(
              title: S.current.success_pwd,
              "删除成功",
              context,
              preIcon: CustomSnackBarIcons.verifySucceed);
          inputPassWord.value = "";
        },
        fail: (errorMessage) {
          if (errorMessage != null) {
            CustomSnackBar.show(
                title: S.current.transactions_detail_state_fail,
                errorMessage,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        },
        id: id,
        payPassword: inputPassWord.value,
        authType: pwdTypeBean.isNotEmpty ? pwdTypeBean['authType'] : "");
    Future.delayed(
      const Duration(seconds: 1),
      () {
        btnCtr.hideAnimation();
      },
    );
  }

  dynamic getCoinOrBankName(var subData, bool fiatCurrency) {
    if (fiatCurrency) {
      return subData['bank_name'] ?? "";
    } else {
      return subData['name'] ?? "";
    }
  }

  dynamic getOpenNameOrCurrType(var subData, bool fiatCurrency) {
    if (fiatCurrency) {
      return subData['open_name'] ?? "";
    } else {
      return subData['contract_name'] ?? "";
    }
  }

  String getAddressOrBankAccount(var subData, bool fiatCurrency) {
    if (fiatCurrency) {
      return subData['bank_account'] ?? "";
    } else {
      return subData['address'] ?? "";
    }
  }

  dynamic getCoinOrBankNameTitle(bool fiatCurrency, var subData) {
    if (fiatCurrency) {
      return subData['currency_id'] == "702"
          ? S.current.random_text_1171
          : S.current.random_text_1123;
    } else {
      return S.current.random_text_560;
    }
  }

  dynamic getOpenNameOrCurrTypeTitle(bool fiatCurrency) {
    if (fiatCurrency) {
      return S.current.random_text_1122;
    } else {
      return S.current.random_text_643;
    }
  }

  String getAddressOrBankAccountTitle(bool fiatCurrency) {
    if (fiatCurrency) {
      return S.current.random_text_1125;
    } else {
      return S.current.vault_address;
    }
  }
}
