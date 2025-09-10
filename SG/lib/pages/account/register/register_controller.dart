import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/channel_util.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final isCheckCode = false.obs;
  final isEmailError = false.obs;
  final emailErrorText = ''.obs;
  String emailText = '';

  final isUserNameError = false.obs;
  final userNameErrorText = ''.obs;
  String userNameText = '';

  final isPasswordError = false.obs;
  final passwordErrorText = ''.obs;
  String passwordText = '';

  String codeText = '';

  final isEightPassword = false.obs;
  final isContainsNumber = false.obs;
  final isContainsAlphabet = false.obs;

  final isDayError = false.obs;
  final isMonthError = false.obs;
  final isYearError = false.obs;
  final birthdayErrorText = ''.obs;
  final dayText = ''.obs;
  final yearText = ''.obs;
  final isCheckProtocol = true.obs;
  final monthText = ''.obs;
  bool isKeyboardVisible = false;
  final isButtonEnable = true.obs;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
  }

  Future<void> onInputEmail(String value) async {
    emailText = value;
  }

  Future<void> onInputUerName(String value) async {
    userNameText = value;
  }

  Future<void>onInputCode(String value) async {
    codeText = value;
  }

  Future<void> onInputYear(String value) async {
    yearText.value = value;
    _checkBrithDay();
  }

  Future<void> onInputDay(String value) async {
    dayText.value = value;
    _checkBrithDay();
  }

  Future<void> onInputMonth(String value) async {
    monthText.value = value;
    _checkBrithDay();
  }

  void onInputPassword(String value) {
    passwordText = value;
    String text = '';
    if (CommonUtil.containsUppercaseAndLowercase(value)) {
      isContainsAlphabet.value = true;
    } else {
      isContainsAlphabet.value = false;
      text = S.current.password_contains_uppercase_and_lowercase_tips;
    }

    if (CommonUtil.containsNumbers(value)) {
      isContainsNumber.value = true;
    } else {
      isContainsNumber.value = false;
      text = S.current.contains_one_more_number_text;
    }

    if (value.length >= 8) {
      isEightPassword.value = true;
    } else {
      isEightPassword.value = false;
      text = S.current.password_required_characters(8);
    }

    if (value.isNotEmpty && text.isNotEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = text;
    } else {
      isPasswordError.value = false;
      passwordErrorText.value = '';
    }
  }

  bool onEmailCheck(BuildContext context, String value) {
    bool isPass = false;
    emailText = value;
    if (value.isEmpty) {
      isEmailError.value = false;
      emailErrorText.value = '';
      return isPass;
    }
    if (!value.contains('@')) {
      isEmailError.value = true;
      emailErrorText.value = S.current.random_text_fix1;
      return isPass;
    }
    if (!CommonUtil.isEmail(value)) {
      isEmailError.value = true;
      emailErrorText.value = S.current.user_name_error_tips;
      return isPass;
    }
    isEmailError.value = false;
    emailErrorText.value = '';
    isPass = true;
    // if (isEmailError.value == true || value.isEmpty) return isPass;
    // await ApiService.instance.accountCheck(
    //     value: value,
    //     type: 2,
    //     success: (message) {
    //       if (message.isNotEmpty) {
    //         isEmailError.value = true;
    //         emailErrorText.value = message;
    //       }else{
    //         isPass = true;
    //       }
    //     },
    //     fail: (message) {});
    return isPass;
  }

  bool onUserNameCheck(BuildContext context, String value) {
    bool isPass = false;
    userNameText = value;
    /// 英文和数字组合 3-16位
    if (value.length < 3 && value.isNotEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.minimum_character_limit_text(3);
    } else if (value.length > 16) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.max_character_limit_text(16);
    } else if (!CommonUtil.containsAlphabetAndNumbers(value) &&
        value.isNotEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.user_name_error_tips;
    } else if (CommonUtil.containsUppercase(value)) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.user_name_uppercase_error_tips;
    } else {
      isUserNameError.value = false;
      userNameErrorText.value = '';
    }
    isPass = true;
    // if (isUserNameError.value == true || value.isEmpty) return isPass;
    // await ApiService.instance.accountCheck(
    //     value: value,
    //     type: 1,
    //     success: (message) {
    //       if (message.isNotEmpty) {
    //         isUserNameError.value = true;
    //         userNameErrorText.value = message;
    //       }else{
    //         isPass = true;
    //       }
    //     },
    //     fail: (message) {});
    return isPass;
  }

  Future<void> onContinueButton(BuildContext context,CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    onEmailCheck(context,emailText);
    onUserNameCheck(context, userNameText);
    onInputPassword(passwordText);
    btnCtr.hideAnimation();
    if (emailText.isEmpty) {
      isEmailError.value = true;
      emailErrorText.value = S.current.please_input_email_tips;
    }
    if (userNameText.isEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.please_input_user_name_tips;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.please_input_password_tips;
    }

    if (isEmailError.value) return;
    if (isUserNameError.value) return;
    if (isPasswordError.value) return;
    // if (isDayError.value) return;
    // if (isMonthError.value) return;
    // if (isYearError.value) return;

    KeyboardUtils.hideKeyboard(context);
    onStartGameButton(context);
  }

  Future<void> _checkBrithDay() async {
    isYearError.value = yearText.value.isEmpty;
    isDayError.value = dayText.value.isEmpty;
    isMonthError.value = monthText.value.isEmpty;
    if (isYearError.value == true ||
        isDayError.value == true ||
        isMonthError.value == true) {
      birthdayErrorText.value = S.current.please_input_birthday_tips;
      return;
    }

    if (CommonUtil.isDateValid(
        int.parse(yearText.value), int.parse(monthText.value), int.parse(dayText.value)) ==
        false) {
      birthdayErrorText.value =  S.current.invalid_birthday_text;
      return;
    }

    if (CommonUtil.isOver18Years(int.parse(yearText.value),
        int.parse(monthText.value), int.parse(dayText.value)) == false) {
      birthdayErrorText.value =  S.current.must_over_18_year_text;
      return;
    }


    birthdayErrorText.value = '';
  }


  Future<void>onCheckProtocol() async {
    isCheckProtocol.value = !isCheckProtocol.value;
    isButtonEnable.value  = isCheckProtocol.value;
  }

  Future<void> onStartGameButton(BuildContext context) async {
    CustomProgressHUD.show(context, content: S.current.random_text_4);
    String? acToken;
    await ApiService.instance.createAccount(
        email: emailText,
        username: userNameText,
        password: passwordText,
        parentId: codeText,
        success: (String token) {
          acToken = token;
          CustomProgressHUD.dismiss(context);
          // AccountService().saveToken(token);
          CustomSnackBar.show(
              title: S.current.snack_bar_normal_tips,
              S.current.random_text_5,
              context,
              preIcon: CustomSnackBarIcons.welcome);
          CustomSafeDialog.dismiss(
              context: context, tag: 'kCustomRegisterWidget');
          ///统计注册账号
          FlutterPluginName.callMethod(CacheKey.registrationApp);
        },
        fail: (String? message) {
          CustomProgressHUD.dismiss(context);
          if (message != null) {
            CustomSnackBar.show(
                title: S.current.snack_bar_normal_tips,
                message,
                context,
                preIcon: CustomSnackBarIcons.welcome);
          }
        }, birthday: '');
    if (acToken == null) return;
    await ApiService.instance.getUserInfo(
        token: acToken!,
        success: (user) {
          final newUser = user.copyWith(token: acToken!);
          AccountService.sharedInstance.loginUser(newUser);
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
  }
}
