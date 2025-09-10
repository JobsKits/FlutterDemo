import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';
import 'login_widget.dart';

class LoginController extends GetxController {
  final isAccountError = false.obs;
  final accountErrorText = ''.obs;
  String accountText = '';

  final isPasswordError = false.obs;
  final passwordErrorText = ''.obs;
  String passwordText = '';

  Future<void> onInputAccount(String value) async {
    accountText = value;
    if (value.contains('@') && value.isNotEmpty) {
      if (!CommonUtil.isEmail(value)) {
        isAccountError.value = true;
        accountErrorText.value = S.current.email_error_tips;
      } else {
        isAccountError.value = false;
        accountErrorText.value = '';
      }
      return;
    }
    if (value.length < 3 && value.isNotEmpty) {
      isAccountError.value = true;
      accountErrorText.value = S.current.minimum_character_limit_text(3);
    } else if (!CommonUtil.containsAlphabetAndNumbers(value) &&
        value.isNotEmpty) {
      isAccountError.value = true;
      accountErrorText.value = S.current.user_name_error_tips;
    } else {
      isAccountError.value = false;
      accountErrorText.value = '';
    }
  }

  Future<void> onInputPassword(String value) async {
    passwordText = value;
    if (value.length < 6 && value.isNotEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.minimum_character_limit_text(6);
    } else {
      isPasswordError.value = false;
      passwordErrorText.value = '';
    }
  }

  Future<void> onLogin(
      BuildContext context, CustomButtonController btnCtr) async {
    await onInputAccount(accountText);
    await onInputPassword(passwordText);

    if (accountText.isEmpty) {
      isAccountError.value = true;
      accountErrorText.value = S.current.please_input_account_tips;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.please_input_password_tips;
    }
    if (isAccountError.value) return;
    if (isPasswordError.value) return;
    KeyboardUtils.hideKeyboard(context);

    btnCtr.showAnimation();
    String? acToken;
    await ApiService.instance.login(
        username: accountText,
        password: passwordText,
        success: (token) {
          acToken = token;
        },
        fail: (errorMessage) {
          btnCtr.hideAnimation();
          if (errorMessage != null) {
            CustomSnackBar.show(
                title: S.current.error_title_text,
                errorMessage,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        });
    if (acToken == null) return;
    await ApiService.instance.getUserInfo(
        token: acToken!,
        success: (user) {
          final newUser = user.copyWith(token: acToken!);
          AccountService.sharedInstance.loginUser(newUser);
          CustomSnackBar.show(title: S.current.welcome_title_text,
              S.current.welcome_body_text('${user.username}'), context,
              preIcon: CustomSnackBarIcons.welcome);
          CustomSafeDialog.dismiss(context: context, tag: 'kCustomLoginWidget');
        },
        fail: (errorMessage) {
          CustomProgressHUD.dismiss(context);
          if (errorMessage != null) {
            CustomSnackBar.show(
                title: S.current.error_title_text,
                errorMessage,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        });
    btnCtr.hideAnimation();
  }
}
