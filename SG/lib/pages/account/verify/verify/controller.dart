import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:get/get.dart';

import '../../../../services/api/api_service.dart';
import '../../../../utils/common_util.dart';
import '../../../../utils/route_util.dart';
import '../../../../widget/button/custom_button_controller.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../../setup/contact/logic.dart';
import '../../register/logic.dart';
import '../code_tips/index.dart';

class VerifyController extends GetxController {
  VerifyController();

  BuildContext? context;
  final codeText = ''.obs;
  final isCodeError = false.obs;
  final codeErrorText = ''.obs;
  final isButtonEnable = true.obs;

  late Timer timer;
  final seconds = 59.obs;
  final showTime = false.obs;
  final isPhone = false.obs;
  var areaCode = '+63';
  var phone = '';
  var email = '';

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
    // resend();
  }

  void onTap() {
    RouteUtil.popView();
    codeText.value = '';
  }

  onTapTips() {
    showCustomCodeTipsWidget(isPhone: isPhone.value,fromPage: 1);
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
          if (!CommonUtil.isNumber(message)) {
            CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
            timedown(0);
          } else {
            timedown(int.parse(message));
          }
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
          if (!CommonUtil.isNumber(message)) {
            CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
            timedown(0);
          } else {
            timedown(int.parse(message));
          }
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
    if (codeText.isEmpty) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
    } else if (codeText.value.length < 6) {
      isCodeError.value = true;
      codeErrorText.value = '您的手机验证码含有6位数字';
    }
    if (isCodeError.value) {
      return ;
    }

    var account = email;
    var type = 1;
    if (isPhone.value) {
      account = areaCode + phone;
      type = 2;
    }
    if (Get.previousRoute.contains('setup_page')) {
      final SetupContactController setupcontroller = Get.find<SetupContactController>();
      setupcontroller.getInfo(setupcontroller.context!,captcha: codeText.value);
    } else {
      final RegisterLogic registerLogic = Get.find<RegisterLogic>();
      registerLogic.onStartGameButton(registerLogic.context!,captcha: codeText.value);
    }
    // btnCtr.showAnimation();
    // //.forgetPassword
    // await ApiService.instance.resetPassword(
    //     account: account,
    //     code: codeText.value,
    //     password: '',
    //     type: type,
    //     success: (message) {
    //       if (Get.previousRoute.contains('setup_page')) {
    //         final SetupContactController setupcontroller = Get.find<SetupContactController>();
    //         setupcontroller.getInfo(setupcontroller.context!);
    //       }
    //       RouteUtil.popView();
    //       CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_1149, context!, preIcon: CustomSnackBarIcons.activitySuccess);
    //     },
    //     fail: (message) {
    //       if (message == null) return;
    //       CustomSnackBar.showError(message, context);
    //     });
    // btnCtr.hideAnimation();
  }

  Future<void> onInputCode(String value) async {
    codeText.value = value;
    if (value.isEmpty) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
      return;
    } else if (codeText.value.length < 6) {
      isCodeError.value = true;
      codeErrorText.value = '您的手机验证码含有6位数字';
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

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100),() {
      resend();
    });
  }

  timedown(int sec) {
    showTime.value = true;
    seconds.value = 59;
    if (sec > 0) {
      seconds.value = sec;
    }
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
