import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/setup/2FA/email/view.dart';
import 'package:flutter_bet/pages/setup/index/logic.dart';
import 'package:flutter_bet/pages/setup/index/setup_widget.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_bet/widget/snack_bar/custom_timer_helper.dart';
import 'package:get/get.dart';
import '../../account/model/model.dart';

///修改资金密码
class ModifyPasswordLogic extends GetxController {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final isEnableSaveButton = false.obs;
  final payButtonEnable = false.obs;

  final model = RegularModel().obs;
  final bindIndex = 0.obs;//修改资金密码 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 无需绑定
  final showPhone = false.obs;
  final showTitle = false.obs;
  var phoneText = '';
  var areaCodeText = '';

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

  final isEightPassword = false.obs;
  final isContainsNumber = false.obs;
  final isContainsAlphabet = false.obs;


  final isShowEditPwd = false.obs; //是否显示资金密码
  final isEditPwd = false.obs; //是否是修改资金密码
  final isBindEmail = false.obs; //是否绑定了邮箱
  final isBindPhone = false.obs; //是否绑定了手机号

  final oldMoneyPasswordText = ''.obs;
  final oldMoneyPasswordError = false.obs;
  final oldMoneyPasswordErrorFlag = false.obs;
  final oldMoneyPasswordErrorText = ''.obs;

  final newMoneyPasswordText = ''.obs;
  final newMoneyPasswordError = false.obs;
  final newMoneyPasswordErrorFlag = false.obs;
  final newMoneyPasswordErrorText = ''.obs;

  final newMoneyPassword2Text = ''.obs;
  final newMoneyPassword2Error = false.obs;
  final newMoneyPassword2ErrorFlag = false.obs;
  final newMoneyPassword2ErrorText = ''.obs;

  final verCodeText = ''.obs;
  final verCodeError = false.obs;
  final verCodeErrorFlag = false.obs;
  final verCodeErrorText = ''.obs;

  final verCodeBtnText = S.current.get_verification_code.obs;
  final isEnableCodeBtn = false.obs;

  final isMoneyEightPassword = false.obs;
  final isMoneyContainsNumber = false.obs;
  final isMoneyContainsAlphabet = false.obs;

  ///辅助定时器工具助手
  late final CustomTimerHelper timeHelper;
  static const int _defaultDuration = 60;
  final progressValue = 0.0.obs;

  AccountServiceListener? _accountListener;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    everAll([oldPasswordText, newPasswordText, newPassword2Text], (_) => checkSaveButton());
    everAll([oldMoneyPasswordText,newMoneyPasswordText,newMoneyPassword2Text], (callback) => checkPayButton());
    int check = globalController.getVerifyType(); //1谷歌验证 2资金密码 3全部
    isShowEditPwd.value = (check == 2 || check == 3);
    _accountListener = AccountServiceListener(onUserInfoChange: (model) {
      _updateInfo();
    });
    AccountService.sharedInstance.addListener(_accountListener!);
    _updateInfo();
    getBrandDetail();
    ever(globalController.registerIndex, (callback) => getBrandDetail());
  }

  void checkSaveButton() {
    isEnableSaveButton.value = oldPasswordText.isNotEmpty || newPasswordText.isNotEmpty || newPassword2Text.isNotEmpty;
  }

  void checkPayButton() {
    payButtonEnable.value = oldMoneyPasswordText.isNotEmpty || newMoneyPasswordText.isNotEmpty || newMoneyPassword2Text.isNotEmpty;
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
    if (model.value.mail!.verify == true && model.value.phone!.verify == false) {//只显示邮箱
      showTitle.value = false;
      showPhone.value = false;
      bindIndex.value = 0;
    } else if (model.value.mail!.verify == false && model.value.phone!.verify == true) {//只显示手机
      showTitle.value = false;
      showPhone.value = true;
      bindIndex.value = 1;
    } else if (model.value.mail!.verify == true && model.value.phone!.verify == true) {//显示邮箱 手机
      showTitle.value = true;
      bindIndex.value = 2;
      if (!isBindEmail.value && isBindPhone.value) {
        showTitle.value = false;
        showPhone.value = true;
        bindIndex.value = 1;
      }
      if (isBindEmail.value && !isBindPhone.value) {
        showTitle.value = false;
        showPhone.value = false;
        bindIndex.value = 0;
      }
    } else {
      bindIndex.value = 3;
    }
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
          verCodeBtnText.value = '${S.current.reacquire} ${progressValue.value.toInt()}${S.current.random_text_888}';
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

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> onInputOldPassword(String value, bool isFocusLost) async {
    oldPasswordText.value = value;
    if (!isFocusLost && !oldPasswordErrorFlag.value) return;

    if (value.length >= 8 || value.isEmpty) {
      oldPasswordError.value = false;
    } else {
      oldPasswordError.value = true;
      if (isFocusLost) {
        oldPasswordErrorFlag.value = true;
      }
      oldPasswordErrorText.value = S.current.random_text_502;
    }
  }

  Future<void> onInputNewPassword(String value, bool isFocusLost) async {
    newPasswordText.value = value;
    if (!isFocusLost && !newPasswordErrorFlag.value) return;

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
      text = S.current.random_text_675;
    }

    if (value.length >= 8) {
      isEightPassword.value = true;
    } else {
      isEightPassword.value = false;
      text = S.current.random_text_676;
    }

    if (value.isNotEmpty && text.isNotEmpty) {
      newPasswordError.value = true;
      newPasswordErrorText.value = text;
      if (isFocusLost) {
        newPasswordErrorFlag.value = true;
      }
    } else {
      newPasswordError.value = false;
      newPasswordErrorText.value = '';
      if (value != newPassword2Text.value && newPassword2Text.isNotEmpty && value.isNotEmpty) {
        newPassword2ErrorText.value = S.current.twice_password_error_text;
        newPassword2Error.value = true;
        if (isFocusLost) {
          newPasswordErrorFlag.value = true;
        }
      } else {
        newPassword2ErrorText.value = "";
        newPassword2Error.value = false;
      }
    }
    newPasswordsSame();
  }

  Future<void> onInputNewPasswordNext(String value, bool isFocusLost) async {
    newPassword2Text.value = value;
    if (!isFocusLost && !newPassword2ErrorFlag.value) return;

    if (value.isEmpty) {
      newPassword2Error.value = false;
      newPassword2ErrorText.value = '';
      return;
    }

    if (value.length < 8) {
      newPassword2Error.value = true;
      newPassword2ErrorText.value = S.current.random_text_676;
      if (isFocusLost) {
        newPassword2ErrorFlag.value = true;
      }
      return;
    }

    if (CommonUtil.containsUppercaseAndLowercase(value)) {
      newPassword2Error.value = false;
    } else {
      newPassword2Error.value = true;
      newPassword2ErrorText.value = S.current.password_contains_uppercase_and_lowercase_tips;
      if (isFocusLost) {
        newPassword2ErrorFlag.value = true;
      }
      return;
    }

    if (CommonUtil.containsNumbers(value)) {
      newPassword2Error.value = false;
    } else {
      newPassword2Error.value  = true;
      newPassword2ErrorText.value = S.current.random_text_675;
      if (isFocusLost) {
        newPassword2ErrorFlag.value = true;
      }
      return;
    }

    if (value != newPasswordText.value && newPasswordText.isNotEmpty) {
      newPassword2ErrorText.value = S.current.random_text_677;
      newPassword2Error.value = true;
      if (isFocusLost) {
        newPassword2ErrorFlag.value = true;
      }
      return;
    } else {
      newPassword2Error.value = false;
      newPassword2ErrorText.value = '';
    }
    newPasswordsSame();
  }


  newPasswordsSame() {
    if (newPasswordText.value.length > 7 && newPassword2Text.value.length > 7) {
      if (newPasswordText.value != newPassword2Text.value) {
        newPassword2ErrorText.value = S.current.random_text_677;
        newPassword2Error.value = true;
      }
    }
  }

  Future<void> onSubmit(
      BuildContext context, CustomButtonController btnCtr) async {
    if (oldPasswordText.isEmpty) {
      oldPasswordErrorText.value = S.current.random_text_1201;
      oldPasswordError.value = true;
    }
    if (newPasswordText.isEmpty) {
      newPasswordErrorText.value = S.current.random_text_1202;
      newPasswordError.value = true;
    }
    if (newPassword2Text.isEmpty) {
      newPassword2ErrorText.value = S.current.random_text_1203;
      newPassword2Error.value = true;
    }
    if (newPasswordText.value != newPassword2Text.value) {
      newPassword2ErrorText.value = S.current.random_text_677;
      newPassword2Error.value = true;
    }

    if (!(oldPasswordError.value == false &&
        newPasswordError.value == false &&
        newPassword2Error.value == false)) return;

    btnCtr.showAnimation();
    await ApiService.instance.updatePassword(
        password: oldPasswordText.value,
        newPassword: newPasswordText.value,
        success: (String message) {
          CustomSafeDialog.dismiss(context: context,tag: kCustomSetupWidget);
          CustomSnackBar.show(
              S.current.password_has_been_updated,
              title: S.current.success_pwd,
              context,
              preIcon: CustomSnackBarIcons.passwordSucceed);
          AccountService.sharedInstance.logoutUser();
          globalController.onArticleCollect();
          Future.delayed(const Duration(milliseconds: 1500), () {
            Get.back();
            btnCtr.hideAnimation();
          });
        },
        fail: (String? message) {
          CustomSnackBar.showError(message!, context);
          btnCtr.hideAnimation();
        });
  }


  ///资金密码
  Future<void> onInputMoneyOldPassword(String value,bool isFocusLost) async {
    oldMoneyPasswordText.value = value;
    if(isFocusLost){
      oldMoneyPasswordErrorFlag.value = true;
    }
    if (value.length == 6 || value.isEmpty) {
      oldMoneyPasswordError.value = false;
      oldMoneyPasswordErrorText.value = '';
    } else if (oldMoneyPasswordErrorFlag.value) {
      oldMoneyPasswordError.value = true;
      oldMoneyPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
    }
  }

  Future<void> onInputMoneyNewPassword(String value,bool isFocusLost) async {
    newMoneyPasswordText.value = value;
    if(isFocusLost){
      newMoneyPasswordErrorFlag.value = true;
    }
    newMoneyPasswordError.value = false;
    newMoneyPasswordErrorText.value = '';

    if (value.length == 6 || value.isEmpty) {
      newMoneyPasswordError.value = false;
      if (value.length == 6 && newMoneyPassword2Text.isNotEmpty && value != newMoneyPassword2Text.value) {
        newMoneyPassword2ErrorText.value = S.current.two_password_inputs_are_inconsistent;
        newMoneyPassword2Error.value = true;
      }  else {
        newMoneyPassword2Error.value = false;
        isEnableCodeBtn.value = true;
      }
    } else if (newMoneyPasswordErrorFlag.value) {
      newMoneyPasswordError.value = true;
      newMoneyPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
    }
  }

  Future<void> onInputMoneyNewPasswordNext(String value,bool isFocusLost) async {
    newMoneyPassword2Text.value = value;
    if (isFocusLost) {
      newMoneyPassword2ErrorFlag.value = isFocusLost;
    }
    if (value.length == 6 || value.isEmpty) {
      if (value != newMoneyPasswordText.value && newMoneyPasswordText.isNotEmpty && value.isNotEmpty) {
        newMoneyPassword2ErrorText.value = S.current.two_password_inputs_are_inconsistent;
        newMoneyPassword2Error.value = true;
      } else {
        newMoneyPassword2Error.value = false;
        isEnableCodeBtn.value = true;
      }
    } else if (newMoneyPassword2ErrorFlag.value) {
      newMoneyPassword2Error.value = true;
      newMoneyPassword2ErrorText.value = S.current.only_supports_6_digit_pure_numbers;
    }
  }

  ///验证码输入框逻辑
  Future<void> onInputMoneyVerificationCode(String value,bool isFocusLost) async {
    verCodeText.value = value;
    if(!isFocusLost){
      if(!verCodeErrorFlag.value)return;
    }
    if (value.length == 6 || value.isEmpty) {
      verCodeError.value = false;
      verCodeErrorText.value = '';
    } else {
      verCodeError.value = true;
      verCodeErrorText.value = S.current.random_text_1291;
      if(isFocusLost){
        verCodeErrorFlag.value = true;
      }
    }
  }

  ///获取验证码
  Future<void> getVerCode(BuildContext context, CustomButtonController btnCtr) async {
    await onInputMoneyNewPasswordNext(newMoneyPassword2Text.value,true);

    if (isEditPwd.value && oldMoneyPasswordText.isEmpty) {
      oldMoneyPasswordErrorText.value = S.current.password_can_not_be_blank;
      oldMoneyPasswordError.value = true;
    }

    if (newMoneyPasswordText.isEmpty) {
      newMoneyPasswordErrorText.value = S.current.password_can_not_be_blank;
      newMoneyPasswordError.value = true;
    }
    if (newMoneyPassword2Text.isEmpty) {
      newMoneyPassword2ErrorText.value = S.current.password_can_not_be_blank;
      newMoneyPassword2Error.value = true;
    }
    if (!(newMoneyPasswordError.value == false &&
        newMoneyPassword2Error.value == false)) return;

    if (isEditPwd.value) {
      if (oldMoneyPasswordError.value == true) return;
    }

    btnCtr.showAnimation();
    isEnableCodeBtn.value = false;
    if (showPhone.value) {
      await ApiService.instance.verifyPhone(success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
        CustomSnackBar.show(
          S.current.random_text_878,
            title:  S.current.success_pwd,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        //倒计时处理
        timeHelper.newTimer();
        timeHelper.startTimer();
      }, fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
        isEnableCodeBtn.value = true;
        verCodeBtnText.value = S.current.get_verification_code;
      },
      phone: '$areaCodeText-$phoneText',
      );
    } else {
      await ApiService.instance.sendEmailCode(success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
        CustomSnackBar.show(
          S.current.random_text_878,
            title:  S.current.success_pwd,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        //倒计时处理
        timeHelper.newTimer();
        timeHelper.startTimer();
      }, fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
        isEnableCodeBtn.value = true;
        verCodeBtnText.value = S.current.get_verification_code;
      });
    }
    btnCtr.hideAnimation();
  }

  ///获取验证码 无按钮变化
  Future<void> getVerCodeText(BuildContext context) async {
    await onInputMoneyNewPasswordNext(newMoneyPassword2Text.value,true);

    if (isEditPwd.value && oldMoneyPasswordText.isEmpty) {
      oldMoneyPasswordErrorText.value = S.current.password_can_not_be_blank;
      oldMoneyPasswordError.value = true;
    }

    if (newMoneyPasswordText.isEmpty) {
      newMoneyPasswordErrorText.value = S.current.password_can_not_be_blank;
      newMoneyPasswordError.value = true;
    }
    if (newMoneyPassword2Text.isEmpty) {
      newMoneyPassword2ErrorText.value = S.current.password_can_not_be_blank;
      newMoneyPassword2Error.value = true;
    }
    if (!(newMoneyPasswordError.value == false &&
        newMoneyPassword2Error.value == false)) return;

    if (isEditPwd.value) {
      if (oldMoneyPasswordError.value == true) return;
    }

    isEnableCodeBtn.value = false;
    if (showPhone.value) {
      await ApiService.instance.verifyPhone(success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
        CustomSnackBar.show(
          S.current.random_text_878,
            title:  S.current.success_pwd,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        //倒计时处理
        timeHelper.newTimer();
        timeHelper.startTimer();
      }, fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
        isEnableCodeBtn.value = true;
        verCodeBtnText.value = S.current.get_verification_code;
      },
      phone: '$areaCodeText-$phoneText',
      );
    } else {
      await ApiService.instance.sendEmailCode(success: (String message) {
        CustomSafeDialog.dismiss(context: context, tag: kCustomSetupWidget);
        CustomSnackBar.show(
          S.current.random_text_878,
            title:  S.current.success_pwd,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        //倒计时处理
        timeHelper.newTimer();
        timeHelper.startTimer();
      }, fail: (String? message) {
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, context);
        isEnableCodeBtn.value = true;
        verCodeBtnText.value = S.current.get_verification_code;
      });
    }
  }

  //isRefPwConfig 是否刷新密码配置 默认不刷新
  Future<void> onMoneySubmit(BuildContext context, CustomButtonController btnCtr,{bool isRefPwConfig = false}) async {
    if (bindIndex.value != 3) {
      await onInputMoneyVerificationCode(verCodeText.value,true);
    }
    if(isRefPwConfig){
      globalController.isOpenVerificationAndPayPassword.value = false;
    }
    if (oldMoneyPasswordText.isEmpty) {
      oldMoneyPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      oldMoneyPasswordError.value = true;
    }
    if (newMoneyPasswordText.isEmpty) {
      newMoneyPasswordErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      newMoneyPasswordError.value = true;
    }
    if (newMoneyPassword2Text.isEmpty) {
      newMoneyPassword2ErrorText.value = S.current.only_supports_6_digit_pure_numbers;
      newMoneyPassword2Error.value = true;
    }
    if (verCodeText.isEmpty) {
      verCodeErrorText.value = S.current.random_text_1046;
      verCodeError.value = true;
    }
    if (!(newMoneyPasswordError.value == false &&
        newMoneyPassword2Error.value == false)) return;
    if (isEditPwd.value) {
      if (oldMoneyPasswordError.value == true) return;
    }
    if (bindIndex.value != 3 && verCodeError.value) return;
    onSubmitServer(context, btnCtr,isRefPwConfig:isRefPwConfig);
  }

  Future<void> onSubmitServer(BuildContext context, CustomButtonController btnCtr,{ bool isRefPwConfig = false}) async {
    btnCtr.showAnimation();
    await ApiService.instance.updatePayPassword(
      types: isEditPwd.value ? 2 : 1,
      oldPassword: isEditPwd.value ? oldMoneyPasswordText.value : '',
      payPassword: newMoneyPassword2Text.value,
      code: verCodeText.value,
      codeType: showPhone.value ? 2 : 1,
      success: (String message) async {
        CustomSafeDialog.dismiss(context: context, tag: kEmailVerifyWidget);
        CustomSnackBar.show(
            isEditPwd.value
                ? S.current.random_text_715
                : S.current.random_text_716,
            title:S.current.success_pwd,
            context,
            preIcon: CustomSnackBarIcons.verifySucceed);
        isEditPwd.value = true;
        initView();
        await AccountService.sharedInstance.refreshUserInfo();
        if(isRefPwConfig){
          await globalController.getBrandBaseInfo();
          await globalController.getPassWordConfig();
          globalController.isOpenVerificationAndPayPassword.value = true;
          globalController.bindPayed.value = true;
        }
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
    oldMoneyPasswordText.value = '';
    oldMoneyPasswordError.value = false;
    oldMoneyPasswordErrorText.value = '';

    newMoneyPasswordText.value = '';
    newMoneyPasswordError.value = false;
    newMoneyPasswordErrorText.value = '';

    newMoneyPassword2Text.value = '';
    newMoneyPassword2Error.value = false;
    newMoneyPassword2ErrorText.value = '';

    verCodeText.value = '';
    verCodeError.value = false;
    verCodeErrorText.value = '';

    timeHelper.closeTimer();
    isEnableCodeBtn.value = true;
    verCodeBtnText.value = S.current.get_verification_code;
  }

  void goToBind() {
    try {
      SetupLogic setupLogic = Get.find<SetupLogic>();
      setupLogic.changedView(0);
    } on Exception catch (e) {}
  }

  void _updateInfo() {
    final account = AccountService.sharedInstance.currentUser;
    int emailCheckState = AccountService.sharedInstance.currentUser?.emailCheckState ?? 0;
    // if (emailCheckState != 1) {
    //   isBindEmail.value = true;
    // } else {
    //   isBindEmail.value = false;
    //   String playPwd = AccountService.sharedInstance.currentUser?.payPassword ?? '';
    //   if (playPwd == '1') {
    //     isEditPwd.value = true;
    //   } else {
    //     isEditPwd.value = false;
    //   }
    // }
    
    isBindEmail.value = emailCheckState == 1;
    if (isBindEmail.value) {
      String playPwd = AccountService.sharedInstance.currentUser?.payPassword ?? '';
      if (playPwd == '1') {
        isEditPwd.value = true;
      } else {
        isEditPwd.value = false;
      }
    }
    int phoneCheckState = AccountService.sharedInstance.currentUser?.phoneCheckState ?? 0;
    isBindPhone.value = phoneCheckState == 1;
    phoneText = account?.mext?.phone ?? '';
    areaCodeText = account?.mext?.areaCode ?? '';
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
