import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/account/register/register_widget.dart';
import 'package:flutter_bet/pages/account/registerThird/view.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/channel_util.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';

import '../../../model/mobile_area_code.dart';
import '../ThirdPartyAuthorizationToController.dart';
import '../model/model.dart';
import '../register_protocol/view.dart';
import '../verify/verify/index.dart';
import 'widgets/o_auth/index.dart';
import 'widgets/user_agree/index.dart';
import 'widgets/verify/email_verify/index.dart';
import 'widgets/verify/phone_verify/index.dart';

class RegisterLogic extends BaseController {
  var isUpdated = false.obs;
  final hidden = false.obs;
  final model = RegularModel().obs;
  final showTitle = false.obs;
  final bindIndex = 0.obs;//修改资金密码 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 无需绑定
  final showBirthday = false.obs;
  final isPhone = false.obs;
  final agreeUser = false.obs;
  final agreeInfo = true.obs;
  final isAgreeError = false.obs;
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;
  int areaCodeSelectIndex = -1;
  final ScrollController scrollController = ScrollController();
  final areaCode = '+63'.obs;
  final isPhoneError = false.obs;
  final phoneErrorText = ''.obs;
  String phoneText = '';

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
  final passwordCount = 0.obs;

  final isDayError = false.obs;
  final isMonthError = false.obs;
  final isYearError = false.obs;
  final birthdayErrorText = ''.obs;
  final dayText = ''.obs;
  final yearText = ''.obs;
  final isCheckProtocol = false.obs;
  final ifClickStartGame = false.obs; //是否点击了开始游戏
  final isCanClickProtocol = false.obs; //是否可以点击阅读
  final contentHeight =0.obs;
  final monthText = ''.obs;
  bool isKeyboardVisible = false;
  final isButtonEnable = true.obs;
  final isEditPassword = false.obs;
  late StreamSubscription<bool> keyboardSubscription;

  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final thirdController = Get.put(FiatPaymentDetailsToController());
  BuildContext? context;
  final list = [
    {"month": S.current.random_text_9, "num": "1", "isSelected": false},
    {"month": S.current.random_text_10, "num": "2", "isSelected": false},
    {"month": S.current.random_text_11, "num": "3", "isSelected": false},
    {"month": S.current.random_text_12, "num": "4", "isSelected": false},
    {"month": S.current.random_text_13, "num": "5", "isSelected": false},
    {"month": S.current.random_text_14, "num": "6", "isSelected": false},
    {"month": S.current.random_text_15, "num": "7", "isSelected": false},
    {"month": S.current.random_text_16, "num": "8", "isSelected": false},
    {"month": S.current.random_text_17, "num": "9", "isSelected": false},
    {"month": S.current.random_text_18, "num": "10", "isSelected": false},
    {"month": S.current.random_text_19, "num": "11", "isSelected": false},
    {"month": S.current.random_text_20, "num": "12", "isSelected": false},
  ].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
    // areaCode.value = globalController.getLangCode();
    getIP();
    getBrandDetail();
    loadArCode();
    globalController.loginRegister.value = 2;
    thirdController.getBrandDetail();
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

  @override
  void onReady() {
    super.onReady();
    ever(globalController.isThirdLoginOk, (callback) {
      //第三方登录成功
      if (globalController.isThirdLoginOk.value) {
        RouteUtil.popView();
      }
    });

    ever(globalController.thirdLoginEmail, (callback) {
      if(globalController.thirdLoginEmail.value.isNotEmpty){
        //第三方登录 注册
        showCustomRegisterThirdWidget(context: context!,);
      }
    });

    ever(globalController.registerIndex, (callback) {
      getBrandDetail();
    });
  }

  @override
  void onClose() {
    keyboardSubscription.cancel();
    globalController.loginRegister.value = 0;
  }

  void onTap() {
    RouteUtil.popView();
  }

  showPhone(bool showed) {
    isPhone.value = showed;

    isUserNameError.value = false;
    userNameErrorText.value = '';
    userNameText = '';

    isPasswordError.value = false;
    passwordErrorText.value = '';
    passwordText = '';

  }

  ///获取配置信息
  Future<void> getBrandDetail({String tag = 'regapp'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        success: (dynamic) {
          if (dynamic['reg'] != null) {
            model.value = RegularModel.fromJson(dynamic['reg'].first);
            dealData();
          }
        },
        fail: (String? message) {});
  }

  dealData() {
    if (model.value.mail!.mail == true && model.value.phone!.phone == false) {//只显示邮箱
      showTitle.value = false;
      isPhone.value = false;
      bindIndex.value = 0;
    } else if (model.value.mail!.mail == false && model.value.phone!.phone == true) {//只显示手机
      showTitle.value = false;
      isPhone.value = true;
      bindIndex.value = 1;
    } else if (model.value.mail!.mail == true && model.value.phone!.phone == true) {//显示邮箱 手机
      showTitle.value = true;
      bindIndex.value = 2;
    } else { //都不显示
      bindIndex.value = 3;
    }
    isUpdated.value = true;
    showBirthday.value = model.value.birthday!;
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

  pushAgree() {
    hidden.value = true;
    showUserAgreeWidget();
  }

  Future<void> onInputEmail(String value) async {
    emailText = value;
    onEmailCheck(context!, value);
  }

  Future<void> onInputUerName(String value) async {
    userNameText = value;
    onUserNameCheck(context!, value);
  }

  Future<void> onInputCode(String value) async {
    codeText = value;
    onInputPassword(value);
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

  void clickPasswordField() {
    this.isEditPassword.value = true;
  }

  void changePasswordHit(value) {
    if (passwordText.isEmpty || passwordText.length == 0) {
      this.isEditPassword.value = false;
    } else {
      this.isEditPassword.value = true;
    }
  }

  void oninputCompletionPassword(String value) {
    passwordCount.value = 0;
    passwordText = value;
    if (passwordText.isEmpty) {
      isEditPassword.value = false;
    } else {
      isEditPassword.value = true;
    }
    String text = '';
    if (CommonUtil.containsUppercaseAndLowercase(value)) {
      passwordCount.value ++;
      isContainsAlphabet.value = true;
    } else {
      isContainsAlphabet.value = false;
      text = S.current.password_contains_uppercase_and_lowercase_tips;
    }

    if (CommonUtil.containsNumbers(value)) {
      passwordCount.value ++;
      isContainsNumber.value = true;
    } else {
      isContainsNumber.value = false;
      text = S.current.contains_one_more_number_text;
    }

    if (value.length >= 8) {
      passwordCount.value ++;
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

    // if (value.isNotEmpty && text.isNotEmpty) {
    //   isPasswordError.value = true;
    //   passwordErrorText.value = text;
    // } else {
    //   isPasswordError.value = false;
    //   passwordErrorText.value = '';
    // }
  }

  bool hasLetterAfterDecimal(String input) {
    // 正则表达式，匹配小数点后有字母的情况
    RegExp regex = RegExp(r'\.\D');
    // 使用正则表达式匹配字符串
    return regex.hasMatch(input);
  }

  Future<bool> onEmailCheck(BuildContext context, String value) async {
    bool isPass = false;
    emailText = value;
    if (value.isEmpty) {
      isEmailError.value = true;
      emailErrorText.value = S.current.random_text_503;
      return isPass;
    }
    if (!value.contains('@')) {
      isEmailError.value = true;
      emailErrorText.value = S.current.random_text_fix1;
      return isPass;
    }
    if (!value.contains('.')) {
      isEmailError.value = true;
      emailErrorText.value = S.current.random_text_504;
      return isPass;
    }
    if (hasLetterAfterDecimal(value) == false) {
      isEmailError.value = true;
      emailErrorText.value = S.current.random_text_503;
      return isPass;
    }
    if (!CommonUtil.isEmail(value)) {
      isEmailError.value = true;
      // emailErrorText.value = S.current.user_name_error_tips;
      emailErrorText.value = S.current.random_text_505;
      return isPass;
    }
    isEmailError.value = false;
    emailErrorText.value = '';
    // isPass = true;
    if (isEmailError.value == true || value.isEmpty) return isPass;
    await ApiService.instance.accountCheck(
        value: value,
        type: 2,
        success: (message) {
          if (message.isNotEmpty) {
            isEmailError.value = true;
            emailErrorText.value = message;
          } else {
            isPass = true;
          }
        },
        fail: (message) {});
    return isPass;
  }

  onInputPhone(String value,bool isFocusLost) async {
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

  onPhoneCheck(String value,bool isFocusLost) async {
    onInputPhone(value,isFocusLost);
    if (isPhoneError.value)  return ;
    var code = areaCode.value.replaceAll('+', '%2B');
    await ApiService.instance.accountCheck(
        value: '$code-$phoneText',
        type: 3,
        noNotify: true,
        success: (message) {
          if (message.isNotEmpty) {
            isPhoneError.value = true;
            phoneErrorText.value = message;
          }
        },
        fail: (message) {});
  }

  Future<bool> onUserNameCheck(BuildContext context, String value) async {
    bool isPass = false;
    userNameText = value;

    /// 英文和数字组合 6-18位
    if (value.length < 6 && value.isNotEmpty) {
      isUserNameError.value = true;
      // userNameErrorText.value = S.current.minimum_character_limit_text(3);
      userNameErrorText.value = S.current.random_text_506;
    } else if (value.length > 18) {
      isUserNameError.value = true;
      // userNameErrorText.value = S.current.max_character_limit_text(16);
      userNameErrorText.value = S.current.random_text_507;
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
    // isPass = true;
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

  Future<void> onContinueButton(BuildContext context, CustomButtonController btnCtr) async {

    if (isPhone.value) {
      registerWithPhone(context,btnCtr);
      return;
    }

    btnCtr.showAnimation();
    // isCheckCode.value = false ;
    if (bindIndex.value != 3) {
      await onEmailCheck(context, emailText);
    }
    await onUserNameCheck(context, userNameText);
    if (showBirthday.value) {
      _checkBrithDay();
    }

    onInputPassword(passwordText);
    btnCtr.hideAnimation();
    if (emailText.isEmpty && bindIndex.value != 3) {
      isEmailError.value = true;
      // emailErrorText.value = S.current.please_input_email_tips;
      emailErrorText.value = S.current.random_text_503;
    }
    if (userNameText.isEmpty) {
      isUserNameError.value = true;
      // userNameErrorText.value = S.current.please_input_user_name_tips;
      userNameErrorText.value = S.current.random_text_506;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      // passwordErrorText.value = S.current.please_input_password_tips;
      passwordErrorText.value = S.current.password_required_characters(8);
    }
    isAgreeError.value = !agreeUser.value;

    if (isEmailError.value) return;
    if (isUserNameError.value) return;
    if (isPasswordError.value) return;
    if (isDayError.value) return;
    if (isMonthError.value) return;
    if (isYearError.value) return;
    if (isAgreeError.value) return;

    KeyboardUtils.hideKeyboard(context);
    // showCustomRegisterProtocolWidget(context: context);
    if (model.value.mail!.verify!) {
      showCustomVerifyWidget(number: emailText);
      return ;
    }
    onStartGameButton(context);
  }

  registerWithPhone(BuildContext context, CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    // isCheckCode.value = false ;
    await onUserNameCheck(context, userNameText);
    if (showBirthday.value) {
      _checkBrithDay();
    }

    onInputPassword(passwordText);
    btnCtr.hideAnimation();
    if (phoneText.isEmpty) {
      isPhoneError.value = true;
      // emailErrorText.value = S.current.please_input_email_tips;
      phoneErrorText.value = S.current.random_text_1014;
    }
    if (userNameText.isEmpty) {
      isUserNameError.value = true;
      // userNameErrorText.value = S.current.please_input_user_name_tips;
      userNameErrorText.value = S.current.random_text_506;
    }
    if (passwordText.isEmpty) {
      isPasswordError.value = true;
      // passwordErrorText.value = S.current.please_input_password_tips;
      passwordErrorText.value = S.current.password_required_characters(8);
    }
    isAgreeError.value = !agreeUser.value;

    if (isPhoneError.value) return;
    if (isUserNameError.value) return;
    if (isPasswordError.value) return;
    if (isDayError.value) return;
    if (isMonthError.value) return;
    if (isYearError.value) return;
    if (isAgreeError.value) return;

    KeyboardUtils.hideKeyboard(context);
    // showCustomRegisterProtocolWidget(context: context);
    if (model.value.phone!.verify!) {
      showCustomVerifyWidget(number: '${areaCode.value} $phoneText');
      return ;
    }
    onStartGameButton(context);
  }

  Future<void> _checkBrithDay() async {
    isYearError.value = yearText.value.isEmpty;
    isDayError.value = dayText.value.isEmpty;
    isMonthError.value = monthText.value.isEmpty;
    // if (isDayError.value == false) {
    //   if (int.parse(dayText.value) > 31) {
    //     birthdayErrorText.value = S.current.random_text_3;
    //     return;
    //   }
    // }
    if (isYearError.value == false) {
      if (int.parse(yearText.value) < 1900) {
        isYearError.value = true;
        birthdayErrorText.value = S.current.random_text_508;
        return;
      }
    }

    if (isYearError.value == true || isDayError.value == true || isMonthError.value == true) {
      birthdayErrorText.value = S.current.please_input_birthday_tips;
      return;
    }

    var monthStr = monthText.value.length==1?"-0${monthText.value}":"-${monthText.value}";
    var dayStr = dayText.value.length==1?"-0${dayText.value}":"-${dayText.value}";
    log("neco  输入的日期 ${yearText.value}$monthStr$dayStr");
    bool ageVerification =
        CommonUtil.ageVerification("${yearText.value}$monthStr$dayStr");
    if (ageVerification == true) {
      isDayError.value = true;
      isYearError.value = true;
      isMonthError.value =true;
      birthdayErrorText.value = S.current.random_text_509;
      return;
    }
    int maxDays = CommonUtil.getMaxDays(int.parse(yearText.value), int.parse(monthText.value));
    if (maxDays != 0) {
      if (int.parse(dayText.value) > maxDays) {
        isDayError.value = true;
        birthdayErrorText.value = "${S.current.random_text_510}$maxDays${S.current.random_text_511}";
        if(LangUtil().isTh()) {
          birthdayErrorText.value = "${S.current.random_text_510}${S.current.random_text_511}$maxDays";
        }
        return;
      }
    }

    if (CommonUtil.isDateValid(
            int.parse(yearText.value), int.parse(monthText.value), int.parse(dayText.value)) ==
        false) {
      birthdayErrorText.value = S.current.invalid_birthday_text;
      return;
    }

    if (CommonUtil.isOver18Years(
            int.parse(yearText.value), int.parse(monthText.value), int.parse(dayText.value)) ==
        false) {
      birthdayErrorText.value = S.current.must_over_18_year_text;
      return;
    }

    birthdayErrorText.value = '';
  }

  Future<void> onCheckProtocol() async {
    isCheckProtocol.value = !isCheckProtocol.value;
    isButtonEnable.value = isCheckProtocol.value;
  }

  Future<void> onStartGameButton(BuildContext context,{String? captcha}) async {
    CustomProgressHUD.show(context, content: S.current.random_text_4);
    String? acToken;
    var birthday = "";
    if (showBirthday.value) {
      birthday = "$yearText-$monthText-$dayText";
    }
    // await ApiService.instance.accountCheck(
    //     value: emailText,
    //     type: 2,
    //     success: (message) {
    //       if (message.isNotEmpty) {
    //         // isEmailError.value = true;
    //         // emailErrorText.value = message;
    //         CustomSnackBar.show(
    //             title: message,
    //             message,
    //             context,
    //             preIcon: CustomSnackBarIcons.welcome);
    //       }else{
    //
    //       }
    //     },
    //     fail: (message) {});
    if (isPhone.value) {
      await ApiService.instance.createAccountWithPhone(
        phone: '${areaCode.value}-$phoneText',
        username: userNameText,
        password: passwordText,
        parentId: codeText,
        captcha: captcha??'',
        success: (String token) {
          acToken = token;
          CustomProgressHUD.dismiss(context);
          // AccountService().saveToken(token);
          RouteUtil.popView();
          RouteUtil.popView();
          CustomSnackBar.show(title: S.current.welcome_title_text,
              S.current.welcome_body_text(userNameText), context,
              preIcon: CustomSnackBarIcons.welcome);
          // CustomSnackBar.show(
          //     title: S.current.snack_bar_normal_tips,
          //     S.current.random_text_5,
          //     context,
          //     preIcon: CustomSnackBarIcons.welcome);

          ///统计注册账号
          FlutterPluginName.callMethod(CacheKey.registrationApp);
        },
        fail: (String? message) {
          CustomProgressHUD.dismiss(context);
          if (message != null) {
            CustomSnackBar.show(
                title: S.current.error_title_text,
                message,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        },
        birthday: birthday);
    } else {
      await ApiService.instance.createAccount(
        email: emailText,
        username: userNameText,
        password: passwordText,
        parentId: codeText,
        captcha: captcha??'',
        success: (String token) {
          acToken = token;
          CustomProgressHUD.dismiss(context);
          // AccountService().saveToken(token);
          RouteUtil.popView();
          RouteUtil.popView();
          CustomSnackBar.show(title: S.current.welcome_title_text,
              S.current.welcome_body_text(userNameText), context,
              preIcon: CustomSnackBarIcons.welcome);
          // CustomSnackBar.show(
          //     title: S.current.snack_bar_normal_tips,
          //     S.current.random_text_5,
          //     context,
          //     preIcon: CustomSnackBarIcons.welcome);

          ///统计注册账号
          FlutterPluginName.callMethod(CacheKey.registrationApp);
        },
        fail: (String? message) {
          CustomProgressHUD.dismiss(context);
          if (message != null) {
            if (globalController.isVi()) {
              message = 'Xác minh Email thất bại';
            }
            CustomSnackBar.show(
                title: S.current.error_title_text,
                message,
                context,
                preIcon: CustomSnackBarIcons.error);
          }
        },
        birthday: birthday);
    }
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
