import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:get/get.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/common_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../code_tips/view.dart';

class VerifyCodeController extends GetxController {
  VerifyCodeController();

  BuildContext? context;
  final codeText = ''.obs;
  final isCodeError = false.obs;
  final codeErrorText = ''.obs;
  final isButtonEnable = true.obs;
  String passwordText = '';
  final isPasswordError = false.obs;
  final passwordErrorText = ''.obs;
  final hidden = false.obs;

  late Timer timer;
  final seconds = 59.obs;
  final showTime = false.obs;
  final isPhone = false.obs;
  var areaCode = '+63';
  var phone = '';
  var email = '';
  final passwordCount = 0.obs;
  final isEditPassword = false.obs;

  _initData() {
    update(["verify_code"]);
  }

  initial(String number) {
    isPhone.value = !number.contains('@');
    if (isPhone.value) {
      areaCode = number.split(' ').first;
      phone = number.split(' ').last;
    } else {
      email = number;
    }
  }

  void onTap() {
    RouteUtil.popView();
  }

  onTapTips() {
    hidden.value = true;
    showCustomCodeTipsWidget(isPhone: isPhone.value,fromPage: 2);
  }

  void resend() {
    if (!showTime.value) {
      if (isPhone.value) {
        verifyPhone();
      } else {
        verifyEmail();
      }
    }
  }

  verifyEmail() async {
    // btnCtr.showAnimation();
    await ApiService.instance.verifyEmail(
        email: email,
        success: (message) {
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
          timedown();
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    // btnCtr.hideAnimation();
  }

  verifyPhone() async {
    // btnCtr.showAnimation();
    await ApiService.instance.verifyPhone(
        phone: '$areaCode-$phone',
        success: (message) {
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
          timedown();
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    // btnCtr.hideAnimation();
  }

  Future<void> onSubmit(
    CustomButtonController btnCtr,
  ) async {
    if (codeText.value.isEmpty) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.random_text_1051;
    }
    if (codeText.value.length < 6) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1148;
    }

    if (isCodeError.value || isPasswordError.value) {
      return ;
    }
    var account = email;
    var type = 1;
    if (isPhone.value) {
      account = '$areaCode-$phone';
      type = 2;
    }
    btnCtr.showAnimation();
    //.forgetPassword
    await ApiService.instance.resetPassword(
        account: account,
        code: codeText.value,
        password: passwordText,
        type: type,
        success: (message) {
          RouteUtil.popView();
          RouteUtil.popView();
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_1150, context!, preIcon: CustomSnackBarIcons.activitySuccess);
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    btnCtr.hideAnimation();
  }

  Future<void> onInputCode(String value) async {
    codeText.value = value;
    if (value.isEmpty) {
      isCodeError.value = false;
      codeErrorText.value = '';
      return;
    } else if (!CommonUtil.isNumber(value)) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
      codeText.value = value.substring(0,value.length -1);
      return;
    } else {
      isCodeError.value = false;
      codeErrorText.value = '';
    }
  }

  Future<void> onCheckCode(String value) async {
    codeText.value = value;
    if (value.isEmpty) {
      isCodeError.value = false;
      codeErrorText.value = '';
      return;
    } else if (!CommonUtil.isNumber(value)) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
      codeText.value = value.substring(0,value.length -1);
      return;
    } else {
      isCodeError.value = false;
      codeErrorText.value = '';
    }
    if (value.length < 6) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1148;
    }
  }

  Future<void> onInputPwd(String value) async {
    passwordCount.value = 0;
    passwordText = value;
    if (value.isEmpty) {
      isPasswordError.value = false;
      passwordErrorText.value = '';
      isEditPassword.value = false;
      return;
    } else {
      isEditPassword.value = true;
    }
    if (value.length >= 8) {
      isPasswordError.value = false;
      passwordErrorText.value = '';
    }

    String text = '';
    if (CommonUtil.containsUppercaseAndLowercase(value)) {
      passwordCount.value ++;
    } else {
      text = S.current.password_contains_uppercase_and_lowercase_tips;
    }

    if (CommonUtil.containsNumbers(value)) {
      passwordCount.value ++;
    } else {
      text = S.current.contains_one_more_number_text;
    }

    if (value.length >= 8) {
      passwordCount.value ++;
    } else {
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

  @override
  void onInit() {
    super.onInit();
    timedown();
    // Future.delayed(const Duration(milliseconds: 100),() {
    //   resend();
    // });
  }

  timedown() {
    showTime.value = true;
    seconds.value = 59;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (seconds < 1) {
        timer.cancel();
        showTime.value = false;
      } else {
        seconds.value--;
      }
    });
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    super.onClose();
    if (timer.isActive) {
      timer.cancel();
    }
  }
}
