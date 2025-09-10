import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/registerThird/view.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../../../model/mobile_area_code.dart';
import '../ThirdPartyAuthorizationToController.dart';
import 'login_widget.dart';////

class LoginLogic extends BaseController {

  final isPhone = false.obs;
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;
  int areaCodeSelectIndex = -1;
  final ScrollController scrollController = ScrollController();
  final areaCode = '+1'.obs;
  bool isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;

  final isPhoneError = false.obs;
  final phoneErrorText = ''.obs;
  String phoneText = '';

  final isAccountError = false.obs;
  final accountErrorText = ''.obs;
  String accountText = '';

  final isPasswordError = false.obs;
  final passwordErrorText = ''.obs;
  String passwordText = '';

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final thirdController = Get.put(FiatPaymentDetailsToController());
  BuildContext? context;

  @override
  void onInit() {
    super.onInit();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
    // areaCode.value = globalController.getLangCode();
    getIP();
    loadArCode();
    globalController.loginRegister.value = 1;
    thirdController.getBrandDetail();
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
    globalController.loginRegister.value = 0;
  }

  Future<void> getIP() async {
    var response = await Dio().get('https://ipapi.co/json/');
    areaCode.value = response.data['country_calling_code'];
    scrollCode();
  }

  scrollCode() {
    if (areaCodeArray.isNotEmpty) {
      int index = 0;
      for (MobileAreaCodeModel model in areaCodeArray) {
        if (model.attr == areaCode.value) {
          areaCodeSelectIndex = index;
          break;
        }
        index++;
      }
    }
  }

  void onTap() {
    RouteUtil.popView();
  }

  Future<void> loadArCode() async {
    await ApiService.instance.treeList<MobileAreaCodeModel>(
        success: (list) {
          areaCodeArray.addAll(list);
          showArray.addAll(list);
          scrollCode();
        },
        fail: (errorMessage) {},
        level: "011",
        converter: (json) {
          return MobileAreaCodeModel.fromJson(json);
        });
  }

  Future<void> onInputAccount(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!isAccountError.value)return;
    }

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

  Future<void> onInputPhone(String value,bool isFocusLost) async {
    phoneText = value;
    if (value.isEmpty) {
      isPhoneError.value = true;
      phoneErrorText.value = S.current.random_text_1014;
    } else {
      isPhoneError.value = false;
    }
    if (isFocusLost) {
      if (value.length < 5 || value.length > 15){
        isPhoneError.value = true;
        phoneErrorText.value = S.current.random_text_1015;
      }
    }
  }

  Future<void> onInputPassword(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!isPasswordError.value)return;
    }

    passwordText = value;
    if (value.length < 8 && value.isNotEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.minimum_character_limit_text(8);
    } else {
      isPasswordError.value = false;
      passwordErrorText.value = '';
    }
  }

  Future<void> onLogin(
      BuildContext context, CustomButtonController btnCtr) async {
        if (isPhone.value) {
          onLoginWithPhone(context, btnCtr);
          return;
        }
    await onInputAccount(accountText,true);
    await onInputPassword(passwordText,true);

    if (accountText.isEmpty) {
      isAccountError.value = true;
      // accountErrorText.value = S.current.please_input_account_tips;
      accountErrorText.value = S.current.random_text_501;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      // passwordErrorText.value = S.current.please_input_password_tips;
      passwordErrorText.value = S.current.random_text_502;
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
          RouteUtil.popView();
          final newUser = user.copyWith(token: acToken!);
          AccountService.sharedInstance.loginUser(newUser);
          CustomSnackBar.show(title: S.current.welcome_title_text,
              S.current.welcome_body_text(accountText), context,
              preIcon: CustomSnackBarIcons.welcome);
          // CustomSafeDialog.dismiss(context: context, tag: 'kCustomLoginWidget');
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

  Future<void> onLoginWithPhone(
      BuildContext context, CustomButtonController btnCtr) async {
    await onInputPassword(passwordText,true);

    if (phoneText.isEmpty) {
      isPhoneError.value = true;
      phoneErrorText.value = S.current.random_text_1014;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      passwordErrorText.value = S.current.random_text_502;
    }
    if (isPhoneError.value) return;
    if (isPasswordError.value) return;
    KeyboardUtils.hideKeyboard(context);

    btnCtr.showAnimation();
    String? acToken;

    await ApiService.instance.login(
        username: '${areaCode.value}-$phoneText',
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
          RouteUtil.popView();
          final newUser = user.copyWith(token: acToken!);
          AccountService.sharedInstance.loginUser(newUser);
          CustomSnackBar.show(title: S.current.welcome_title_text,
              S.current.welcome_body_text('${user.username}'), context,
              preIcon: CustomSnackBarIcons.welcome);
          // CustomSafeDialog.dismiss(context: context, tag: kCustomLoginWidget);
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

  @override
  void onReady() {
    super.onReady();
    ever(globalController.isThirdLoginOk, (callback) {//第三方登录成功
      if (globalController.isThirdLoginOk.value) {
        RouteUtil.popView();
      }
    });

    ever(globalController.thirdLoginEmail, (callback) {//第三方登录 注册
      if(globalController.thirdLoginEmail.value.isNotEmpty){
        //第三方登录 注册
        showCustomRegisterThirdWidget(context: context!,);
      }
    });
  }

  switchUI() {
    isPhone.value = !isPhone.value;
  }

}