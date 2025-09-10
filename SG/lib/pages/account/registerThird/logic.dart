import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/device_service.dart';
import 'package:flutter_bet/services/mqtt/mqtt_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';

class RegisterThirdController extends GetxController {
  final isUserNameError = false.obs;
  final userNameErrorText = ''.obs;
  String userNameText = '';

  final isNotEmail = true.obs; //第三方登录是否有邮箱，为是否显示邮箱输入框
  final isCheckCode = false.obs;
  final isEmailError = false.obs;
  final emailErrorText = ''.obs;
  String emailText = '';

  final isPasswordError = false.obs;
  final passwordErrorText = ''.obs;
  String passwordText = '';

  final isEditPassword = false.obs;
  final isEightPassword = false.obs;
  final isContainsNumber = false.obs;
  final isContainsAlphabet = false.obs;

  final isNextPage = false.obs; //显示下一页

  final isCanClickProtocol = false.obs; //是否可以点击阅读
  final isCheckProtocol = false.obs;
  final ifClickStartGame = false.obs; //是否点击了开始游戏
  final contentHeight = 0.obs;
  final isButtonEnable = true.obs;

  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  void onInit() {
    isNotEmail.value = globalController.thirdLoginEmail.value == '0'; //如果是0，代表没有邮箱，显示邮箱输入框
    super.onInit();
  }

  Future<void> onInputUerName(String value) async {
    userNameText = value;
  }

  Future<bool> onUserNameCheck(BuildContext context, String value) async {
    bool isPass = false;
    userNameText = value;

    /// 英文和数字组合 3-16位
    if (value.length < 3 && value.isNotEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.minimum_character_limit_text(3);
    } else if (value.length > 16) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.max_character_limit_text(16);
    } else if (!CommonUtil.containsAlphabetAndNumbers(value) && value.isNotEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.user_name_error_tips;
    }
    // else if (CommonUtil.containsUppercase(value)) {
    //   isUserNameError.value = true;
    //   userNameErrorText.value = S.current.user_name_uppercase_error_tips;
    // }
    else {
      isUserNameError.value = false;
      userNameErrorText.value = '';
    }
    if (isUserNameError.value == true || value.isEmpty) return isPass;
    await ApiService.instance.accountCheck(
        value: value,
        type: 1,
        success: (message) {
          if (message.isNotEmpty) {
            isUserNameError.value = true;
            userNameErrorText.value = message;
          } else {
            isPass = true;
          }
        },
        fail: (message) {});
    return isPass;
  }

  void onInputCompletionPassword(String value) {
    passwordText = value;
    if (passwordText.isEmpty || passwordText.isEmpty) {
      isEditPassword.value = false;
    } else {
      isEditPassword.value = true;
    }
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

  void clickPasswordField() {
    isEditPassword.value = true;
  }

  Future<void> onNextPage(BuildContext context, CustomButtonController btnCtr) async {
    if (userNameText.isEmpty) {
      isUserNameError.value = true;
      userNameErrorText.value = S.current.random_text_506;
    }
    if (emailText.isEmpty && isNotEmail.value) {
      isEmailError.value = true;
      emailErrorText.value = S.current.please_input_email_tips;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.password_required_characters(8);
    }
    if (isUserNameError.value) return;
    if (isEmailError.value && isNotEmail.value) return;
    if (isPasswordError.value) return;
    await onUserNameCheck(context, userNameText);
    if (isNotEmail.value) {
      onEmailCheck(context, emailText);
    }
    onInputCompletionPassword(passwordText);
    if (!isEightPassword.value) return;
    if (!isContainsNumber.value) return;
    if (!isContainsAlphabet.value) return;
    // isNextPage.value = true;
    onRegisterThird(context, btnCtr);
  }

  Future<void> onCheckProtocol() async {
    isCheckProtocol.value = !isCheckProtocol.value;
    isButtonEnable.value = isCheckProtocol.value;
  }

  Future<void> onRegisterThird(BuildContext context, CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    await ApiService.instance.thirdRegister(
        email: isNotEmail.value ? emailText : globalController.thirdLoginEmail.value,
        username: userNameText,
        password: passwordText,
        parentId: '',
        thirdType: globalController.thirdPartyType,
        thirdId: globalController.thirdId.value,
        success: (String token) async {
          ///取消订阅监听
          MqttService.instance?.unsubscribeMemberGoogle();

          ///登录账号
          await ApiService.instance.getUserInfo(
              token: token,
              success: (user) {
                final newUser = user.copyWith(token: token);
                AccountService.sharedInstance.loginUser(newUser);
                CustomSnackBar.show(
                    title: S.current.welcome_title_text,
                    S.current.welcome_body_text('${user.username}'),
                    context,
                    preIcon: CustomSnackBarIcons.welcome);
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

          RouteUtil.popView(); //关闭弹窗
          RouteUtil.popView(); //关闭 注册或者登录页面
        },
        fail: (String? message) {
          CustomProgressHUD.dismiss(context);
          if (message != null) {
            CustomSnackBar.show(
                title: message, message, context, preIcon: CustomSnackBarIcons.error);
          }
        });
    btnCtr.hideAnimation();
  }

  ///返回上一页
  back() {
    isNextPage.value = false;
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
    return isPass;
  }

  Future<void> onInputEmail(String value) async {
    emailText = value;
  }
}
