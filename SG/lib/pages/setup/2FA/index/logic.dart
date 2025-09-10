import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/2FA/email/view.dart';
import 'package:flutter_bet/pages/setup/index/setup_widget.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:get/get.dart';

class Setup2FAController extends GetxController {
  String passwordText = '';
  final passwordError = false.obs;
  String password2Text = '';
  final password2Error = false.obs;
  String codeValue = '';
  String code2Value = '';
  final GlobalKey bodyGlobalKey = GlobalKey();
  final buttonEnable = false.obs;

  Future<void> onInputPassword(String value) async {
    codeValue = value;
    if ((value.isEmpty || value.length < 6) ||
        (code2Value.isEmpty || code2Value.length < 6)) {
      buttonEnable.value = false;
    } else {
      buttonEnable.value = true;
    }
  }

  Future<void> onInputPasswordNext(String value) async {
    code2Value = value;
    if ((value.isEmpty || value.length < 6) ||
        (codeValue.isEmpty || codeValue.length < 6)) {
      buttonEnable.value = false;
    } else {
      buttonEnable.value = true;
    }
  }

  Future<void> onSubmit(
      BuildContext context, CustomButtonController btnCtr) async {
    if (codeValue != code2Value) {
      CustomSnackBar.showError(S.current.twice_password_error_text, context);
      return;
    }
    btnCtr.showAnimation();
    await ApiService.instance.sendEmailCode(success: (String message) {
      CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
      showEmailVerifyWidget(context: context, password: code2Value);
    }, fail: (String? message) {
      if (message?.isEmpty == true) return;
      CustomSnackBar.showError(message!, context);
    });
    btnCtr.hideAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
