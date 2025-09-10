

import 'package:flutter_bet/generated/l10n.dart';
import 'package:get/get.dart';
import '../../../../utils/common_util.dart';


///设置验证  or  解除验证 公用输入验证
mixin GoogleAuthMixin {

  final passwordText = ''.obs;
  final passwordError = false.obs;
  final passwordErrorText = "".obs;

  final codeText = ''.obs;
  final codeError = false.obs;
  final codeErrorText = "".obs;

  final buttonEnable = false.obs;

  ///输入完毕
  void onInputPassword(String value, bool isFocusLost) {
    if (value == null || value.isEmpty || value.length < 8) {
      passwordError.value = true;
      // passwordErrorText.value = "电邮地址不能为空";
      passwordErrorText.value = S.current.random_text_668;
    } else {
      passwordError.value = false;
      if (value.length >= 8) {
        if (!CommonUtil.containsUppercaseAndLowercase(value)) {
          passwordError.value = true;
          passwordErrorText.value = S.current.password_contains_uppercase_and_lowercase_tips;
        } else if (!CommonUtil.containsNumbers(value)) {
          passwordError.value = true;
          passwordErrorText.value = S.current.random_text_675;
        }
      }
    }
    passwordText.value = value;
    checkSubmitButton();
  }

  void onInputCode(String value, bool isFocusLost) {
    if (value == null || value.isEmpty || value.length != 6) {
      codeError.value = true;
      codeErrorText.value = S.current.random_text_669;
    } else {
      codeError.value = false;
    }
    codeText.value = value;
    checkSubmitButton();
  }

  ///检查是否可以提交
  bool checkSubmitButton() {
    buttonEnable.value = !(passwordError.value || codeError.value || checkInputEmpty());
    return buttonEnable.value;
  }

  bool checkInputEmpty() {
    return passwordText.isEmpty || codeText.isEmpty ;
  }



}