import 'package:flutter/material.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/2FA/email/view.dart';
import 'package:flutter_bet/pages/setup/index/logic.dart';
import 'package:flutter_bet/pages/setup/index/setup_widget.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_bet/widget/snack_bar/custom_timer_helper.dart';
import 'package:get/get.dart';

class SetupPay2FAController extends GetxController {
  final isEditPwd = false.obs; //是否是修改资金密码
  final isBindEmail = false.obs; //是否绑定了邮箱

  final oldPasswordText = ''.obs;
  final oldPasswordError = false.obs;
  final oldPasswordErrorFlag = false.obs;
  final oldPasswordErrorText = ''.obs;

  final newPasswordText = ''.obs;
  final newPasswordError = false.obs;
  final newPasswordErrorFlag = false.obs;
  final newPasswordErrorText = ''.obs;

  final newPassword2Text = ''.obs;
  final newPassword2Error = false.obs;
  final newPassword2ErrorFlag = false.obs;
  final newPassword2ErrorText = ''.obs;

  final verCodeText = ''.obs;
  final verCodeError = false.obs;
  final verCodeErrorFlag = false.obs;
  final verCodeErrorText = ''.obs;

  final verCodeBtnText = S.current.get_verification_code.obs;
  final isEnableCodeBtn = false.obs;

  final isEightPassword = false.obs;
  final isContainsNumber = false.obs;
  final isContainsAlphabet = false.obs;

  ///辅助定时器工具助手
  late final CustomTimerHelper timeHelper;
  static const int _defaultDuration = 60;
  final progressValue = 0.0.obs;

  AccountServiceListener? _accountListener;

  Future<void> onInputOldPassword(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!oldPasswordErrorFlag.value)return;
    }
    oldPasswordText.value = value;
    if (value.length == 6 || value.isEmpty) {
      oldPasswordError.value = false;
      oldPasswordErrorText.value = '';
    } else {
      oldPasswordError.value = true;
      if(isFocusLost){
        oldPasswordErrorFlag.value = true;
      }
      oldPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
    }
  }

  Future<void> onInputNewPassword(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!newPasswordErrorFlag.value)return;
    }
    newPasswordText.value = value;

    newPasswordError.value = false;
    newPasswordErrorText.value = '';

    if (value.length == 6 || value.isEmpty) {
      newPasswordError.value = false;
    } else {
      newPasswordError.value = true;
      newPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      if(isFocusLost){
        newPasswordErrorFlag.value = true;
      }
    }
  }

  Future<void> onInputNewPasswordNext(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!newPassword2ErrorFlag.value)return;
    }

    newPassword2Text.value = value;
    if (value.length == 6 || value.isEmpty) {
      if (value != newPasswordText.value && newPasswordText.isNotEmpty && value.isNotEmpty) {
        newPassword2ErrorText.value = S.current.two_password_inputs_are_inconsistent;
        newPassword2Error.value = true;
        if(isFocusLost){
          newPassword2ErrorFlag.value = true;
        }
      } else {
        newPassword2Error.value = false;
        isEnableCodeBtn.value = true;
      }
    } else {
      newPassword2Error.value = true;
      newPassword2ErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      if(isFocusLost){
        newPassword2ErrorFlag.value = true;
      }
    }
  }

  ///验证码输入框逻辑
  Future<void> onInputVerificationCode(String value,bool isFocusLost) async {
    if(!isFocusLost){
      if(!verCodeErrorFlag.value)return;
    }
    verCodeText.value = value;
    if (value.length == 6 || value.isEmpty) {
      verCodeError.value = false;
      verCodeErrorText.value = '';
    } else {
      verCodeError.value = true;
      verCodeErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      if(isFocusLost){
        verCodeErrorFlag.value = true;
      }
    }
  }

  ///获取验证码
  Future<void> getVerCode(BuildContext context, CustomButtonController btnCtr) async {
    await onInputNewPasswordNext(newPassword2Text.value,true);

    if (isEditPwd.value && oldPasswordText.isEmpty) {
      oldPasswordErrorText.value = S.current.password_can_not_be_blank;
      oldPasswordError.value = true;
    }

    if (newPasswordText.isEmpty) {
      newPasswordErrorText.value = S.current.password_can_not_be_blank;
      newPasswordError.value = true;
    }
    if (newPassword2Text.isEmpty) {
      newPassword2ErrorText.value = S.current.password_can_not_be_blank;
      newPassword2Error.value = true;
    }
    if (!(oldPasswordError.value == false &&
        newPasswordError.value == false &&
        newPassword2Error.value == false)) return;

    btnCtr.showAnimation();
    isEnableCodeBtn.value = false;
    await ApiService.instance.sendEmailCode(success: (String message) {
      CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
      //倒计时处理
      timeHelper.newTimer();
      timeHelper.startTimer();
    }, fail: (String? message) {
      if (message?.isEmpty == true) return;
      CustomSnackBar.showError(message!, context);
      isEnableCodeBtn.value = true;
      verCodeBtnText.value = S.current.get_verification_code;
    });
    btnCtr.hideAnimation();
  }

  Future<void> onSubmit(BuildContext context, CustomButtonController btnCtr) async {
    await onInputVerificationCode(verCodeText.value,true);

    if (oldPasswordText.isEmpty) {
      oldPasswordErrorText.value = S.current.password_can_not_be_blank;
      oldPasswordError.value = true;
    }
    if (newPasswordText.isEmpty) {
      newPasswordErrorText.value = S.current.password_can_not_be_blank;
      newPasswordError.value = true;
    }
    if (newPassword2Text.isEmpty) {
      newPassword2ErrorText.value = S.current.password_can_not_be_blank;
      newPassword2Error.value = true;
    }
    if (verCodeText.isEmpty) {
      verCodeErrorText.value = S.current.verification_code_must_be_filled;
      verCodeError.value = true;
    }
    if (!(newPasswordError.value == false &&
        newPassword2Error.value == false &&
        verCodeError.value == false)) return;

    if (isEditPwd.value) {
      if (oldPasswordError.value == true) return;
    }

    onSubmitServer(context, btnCtr);
  }

  Future<void> onSubmitServer(BuildContext context, CustomButtonController btnCtr) async {
    btnCtr.showAnimation();
    await ApiService.instance.updatePayPassword(
      types: isEditPwd.value ? 2 : 1,
      oldPassword: isEditPwd.value ? oldPasswordText.value : '',
      payPassword: newPassword2Text.value,
      code: verCodeText.value,
      codeType: 1,
      success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kEmailVerifyWidget);
        CustomSnackBar.show(
            isEditPwd.value
                ? S.current.password_has_been_updated
                : S.current.transaction_password_set_successfully,
            title: S.current.transaction_password,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        AccountService.sharedInstance.refreshUserInfo();
        isEditPwd.value = true;
        initView();
      },
      fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
      },
    );
    btnCtr.hideAnimation();
  }

  ///重新初始化界面
  void initView() {
    oldPasswordText.value = '';
    oldPasswordError.value = false;
    oldPasswordErrorText.value = '';

    newPasswordText.value = '';
    newPasswordError.value = false;
    newPasswordErrorText.value = '';

    newPassword2Text.value = '';
    newPassword2Error.value = false;
    newPassword2ErrorText.value = '';

    verCodeText.value = '';
    verCodeError.value = false;
    verCodeErrorText.value = '';

    timeHelper.closeTimer();
    isEnableCodeBtn.value = true;
    verCodeBtnText.value = S.current.get_verification_code;
  }

  // String passwordText = '';
  // final passwordError = false.obs;
  // String password2Text = '';
  // final password2Error = false.obs;
  // String codeValue = '';
  // String code2Value = '';
  // final GlobalKey bodyGlobalKey = GlobalKey();
  // final buttonEnable = false.obs;
  //
  // Future<void> onInputPassword(String value) async {
  //   codeValue = value;
  //   if ((value.isEmpty || value.length < 6) ||
  //       (code2Value.isEmpty || code2Value.length < 6)) {
  //     buttonEnable.value = false;
  //   } else {
  //     buttonEnable.value = true;
  //   }
  // }
  //
  // Future<void> onInputPasswordNext(String value) async {
  //   code2Value = value;
  //   if ((code2Value.isEmpty || code2Value.length < 6) ||
  //       (codeValue.isEmpty || codeValue.length < 6)) {
  //     buttonEnable.value = false;
  //   } else {
  //     if(code2Value == codeValue) {
  //       buttonEnable.value = true;
  //       password2Error.value = false;
  //       password2Text = '';
  //     }else {
  //       password2Error.value = true;
  //       password2Text = S.current.fund_password_is_inconsistent;
  //     }
  //   }
  //
  // }
  //
  // Future<void> onSubmit(
  //     BuildContext context, CustomButtonController btnCtr) async {
  //   if (codeValue != code2Value) {
  //     CustomSnackBar.showError(S.current.twice_password_error_text, context);
  //     return;
  //   }
  //   btnCtr.showAnimation();
  //   await ApiService.instance.sendEmailCode(success: (String message) {
  //     CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
  //     showEmailVerifyWidget(context: context, password: code2Value);
  //   }, fail: (String? message) {
  //     if (message?.isEmpty == true) return;
  //     CustomSnackBar.showError(message!, context);
  //   });
  //   btnCtr.hideAnimation();
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    _accountListener = AccountServiceListener(onUserInfoChange: (model) {
      _updateInfo();
    });
    AccountService.sharedInstance.addListener(_accountListener!);
    _updateInfo();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    timeHelper = CustomTimerHelper(
      durationTime: _defaultDuration,
      onChangeValue: (value, _) {
        progressValue.value = value / 1000;
        if (progressValue.value.toInt() > 0) {
          verCodeBtnText.value = '${S.current.reacquire}${progressValue.value.toInt()}${S.current.random_text_888}';
        }
      },
      onTimeFinish: (timer) {
        timeHelper.closeTimer();
        isEnableCodeBtn.value = true;
        verCodeBtnText.value = S.current.get_verification_code;
      },
    );
  }

  @override
  void onClose() {
    timeHelper.closeTimer();
    if (_accountListener != null) {
      AccountService.sharedInstance.removeListener(_accountListener!);
    }
    super.onClose();
  }

  void goToBind() {
    try {
      SetupLogic setupLogic = Get.find<SetupLogic>();
      setupLogic.changedView(0);
    } on Exception catch (e) {}
  }

  void _updateInfo() {
    int emailCheckState = AccountService.sharedInstance.currentUser?.emailCheckState ?? 0;
    if (emailCheckState != 1) {
      isBindEmail.value = true;
    } else {
      isBindEmail.value = false;
      String playPwd = AccountService.sharedInstance.currentUser?.payPassword ?? '';
      if (playPwd == '1') {
        isEditPwd.value = true;
      } else {
        isEditPwd.value = false;
      }
    }
  }

  ///前往客服
  Future<void> customerService() async {
    GlobalStateController globalStateController = GlobalStateController.of();
    if(globalStateController.csUrl.isEmpty){
      await globalStateController.brandCS();
    }
    UrlLaunchUtil.jumpCs();
  }
}
