import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/2FA/email/view.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

class EmailVerifyController extends GetxController {
  String codeValue = '';
  final buttonEnable = false.obs;

  Future<void> onInputCode(String value) async {
    codeValue = value;
    if (value.isEmpty || value.length < 6) {
      buttonEnable.value = false;
    } else {
      buttonEnable.value = true;
    }
  }

  Future<void> onSubmit(
      BuildContext context, CustomButtonController btnCtr, String password) async {
    if (codeValue.length < 6) {
      CustomSnackBar.showError(S.current.random_text_453, context);
      return;
    }

    btnCtr.showAnimation();
    await ApiService.instance.updatePayPassword(
      types: 1,
      oldPassword: '',
      payPassword: password,
      code: codeValue,
      codeType: 1,
      success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kEmailVerifyWidget);
        CustomSnackBar.show(
            S.current.transaction_password_set_successfully,
            title: S.current.random_text_455,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
      },
      fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
      },
    );
    btnCtr.hideAnimation();
  }
}
