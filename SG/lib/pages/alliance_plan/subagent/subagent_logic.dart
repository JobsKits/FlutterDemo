import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../services/api/api_service.dart';
import '../../../utils/common_util.dart';
import '../../../utils/keyboard_util.dart';
import '../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../widget/snack_bar/custom_snack_bar_icons.dart';
import 'subagent_state.dart';

class SubAgentLogic extends GetxController {
  final SubAgentState state = SubAgentState();

  final isCanSubmitObs = false.obs;

  ///邮件
  final emailErrorObs = false.obs;
  final emailObs = "".obs;
  final emailErrorTipObs = S.current.random_text_540.obs;

  ///账号
  final accErrorObs = false.obs;
  final accountObs = "".obs;
  final accountErrorTipObs = S.current.random_text_541.obs;

  ///密码
  final pwdErrorObs = false.obs;
  final pwdObs = "".obs;
  final pwdErrorTipObs = S.current.password_can_not_be_blank.obs;

  final pageState = PageState.SUCCESS.obs;

  ///出生日期相关
  final ScrollController scrollController = ScrollController();
  final isDayError = false.obs;
  final isMonthError = false.obs;
  final isYearError = false.obs;

  // final birthdayErrorText = S.current.please_input_birthday_tips.obs;
  final birthdayErrorText = "".obs;
  final dayText = ''.obs;
  final yearText = ''.obs;
  final monthText = ''.obs;
  bool isKeyboardVisible = false;
  final monthListObs = [
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
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // KeyboardUtils.hideKeyboard(Get.overlayContext!);
    log("============SubAgentLogic...onClose...销毁");
    // KeyboardUtils.hideKeyShowUnFocus();
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // FocusScope.of(Get.context!).requestFocus(FocusNode());
    super.onClose();
  }

  ///账号输入完毕
  void onInputCompleteEmail(String value) {
    if (value == null || value.isEmpty) {
      emailErrorObs.value = true;
      emailErrorTipObs.value = S.current.random_text_540;
    } else {
      if (!value.isEmail) {
        emailErrorObs.value = true;
        emailErrorTipObs.value = S.current.random_text_542;
      } else {
        emailErrorObs.value = false;
      }
    }
    emailObs.value = value;
    checkSubmitButton();
  }

  ///账号输入完毕
  void onInputCompleteAcc(String value) {
    if (value == null || value.isEmpty) {
      accErrorObs.value = true;
      accountErrorTipObs.value = S.current.random_text_541;
    } else {
      if (value.length >= 3 && value.length <= 14) {
        accErrorObs.value = false;
      } else {
        accErrorObs.value = true;
        accountErrorTipObs.value = S.current.random_text_543;
      }
    }
    accountObs.value = value;
    checkSubmitButton();
  }

  ///密码输入完毕
  void onInputCompletePwd(String value) {
    if (value == null || value.isEmpty) {
      pwdErrorObs.value = true;
      pwdErrorTipObs.value = S.current.password_can_not_be_blank;
    } else if (value.length < 8) {
      pwdErrorObs.value = true;
      pwdErrorTipObs.value = S.current.random_text_544;
    } else {
      pwdErrorObs.value = false;
    }
    pwdObs.value = value;
    checkSubmitButton();
  }

  ///检查是否可以提交
  bool checkSubmitButton() {
    isCanSubmitObs.value = !(emailErrorObs.value ||
        accErrorObs.value ||
        pwdErrorObs.value ||
        checkBirthdayError() ||
        checkInputEmpty());
    return isCanSubmitObs.value;
  }

  bool checkInputEmpty() {
    return emailObs.isEmpty || accountObs.isEmpty || pwdObs.isEmpty;
  }

  bool checkBirthdayError() {
    return isYearError.value || isMonthError.value || isDayError.value;
  }

  ///提交注册
  void onClickSubmit() async {
    //如果都没有错误
    if (checkSubmitButton()) {
      log("请求网络...");
      pageState.value = PageState.UPDATED;
      await ApiService.instance.registerSubAgent(
        username: accountObs.value,
        password: pwdObs.value,
        email: emailObs.value,
        birthday: "${yearText.value}-${monthText.value}-${dayText.value}",
        success: (data) {
          pageState.value = PageState.SUCCESS;
          CustomSnackBar.show(
              S.current.random_text_545,
              title: S.current.success_pwd,
              Get.overlayContext!,
              preIcon: CustomSnackBarIcons.allianceSuccess);
        },
        fail: (isConnect, message, candy) {
          pageState.value = PageState.SUCCESS;
          if (isConnect) {
            CustomSnackBar.show(
                message ?? S.current.random_text_546,
                title: S.current.transactions_detail_state_fail,
                Get.overlayContext!,
                preIcon: CustomSnackBarIcons.error);
          }
        },
      );
    }

    // //提交成功
    // isCanSubmitObs.value = false;
  }

  /*===================== 出生日期相关方法 =====================*/

  Future<void> onInputDay(String value) async {
    dayText.value = value;
    _checkBrithDay();
    checkSubmitButton();
  }

  Future<void> onInputMonth(String value) async {
    monthText.value = value;
    _checkBrithDay();
    checkSubmitButton();
  }

  Future<void> onInputYear(String value) async {
    yearText.value = value;
    _checkBrithDay();
    checkSubmitButton();
  }

  Future<void> _checkBrithDay() async {
    isYearError.value = yearText.value.isEmpty;
    isDayError.value = dayText.value.isEmpty;
    isMonthError.value = monthText.value.isEmpty;
    if (isDayError.value == false) {
      if (int.parse(dayText.value) > 31) {
        birthdayErrorText.value = S.current.random_text_3;
        return;
      }
    }
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

    var monthStr = monthText.value.length == 1 ? "-0${monthText.value}" : "-${monthText.value}";
    var dayStr = dayText.value.length == 1 ? "-0${dayText.value}" : "-${dayText.value}";
    log("neco  输入的日期 ${yearText.value}$monthStr$dayStr");
    bool ageVerification = CommonUtil.ageVerification("${yearText.value}$monthStr$dayStr");
    if (ageVerification == true) {
      isDayError.value = true;
      isYearError.value = true;
      isMonthError.value = true;
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
}
