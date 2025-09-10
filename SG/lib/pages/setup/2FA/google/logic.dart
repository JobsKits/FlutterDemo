import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../model/user.dart';
import '../../../../services/account_service.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import '../../a_model/auth_config_api_model.dart';
import 'auth_qrcode_api_model.dart';
import 'goole_auth_mixin.dart';

class GoogleAuthHelper with GoogleAuthMixin {}

class GoogleUnAuthHelper with GoogleAuthMixin {}

class SetupGoogle2FAController extends GetxController {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  final isOpenVerification = false.obs; //是否开启了双重验证
  final GoogleAuthHelper authHelper = GoogleAuthHelper(); //验证
  final GoogleAuthHelper unAuthHelper = GoogleAuthHelper(); //解除验证
  @override
  void onReady() {
    super.onReady();
    loadAuthConfigData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final authSecretValueObs = "".obs; //
  final authQrcodeValueObs = "".obs; //动态二维码

  // final isAuthSecretedObs = false.obs;

  ///获取安全验证配置
  ///没设置的话， authSecret为"" 空
  void loadAuthConfigData() async {
    // await Future.delayed(Duration(seconds: 5),() => null,);
    await ApiService.instance.getAuthConfig(
      success: (AuthConfigApiModel apiModel) {
        //判断是否已开始双重验证
        isOpenVerification.value = apiModel.isAuthSecret();
        if (!isOpenVerification.value) {
          loadAuthSecretData();
        }
      },
      fail: (bool isConnect, String? message, candy) {},
    );
  }

  ///获取二阶段验证密钥
  void loadAuthSecretData() async {
    // await Future.delayed(Duration(seconds: 5),() => null,);
    // await ApiService.instance.getAuthSecret(
    //   success: (String data) {
    //     authSecretValueObs.value = data;
    //   },
    //   fail: (bool isConnect, String? message, candy) {},
    // );
    await ApiService.instance.getAuthSecretQrcode(
      success: (AuthQrcodeApiModel apiModel) {
        authSecretValueObs.value = apiModel.secret ?? "";
        authQrcodeValueObs.value = apiModel.qrcode ?? "";
      },
      fail: (bool isConnect, String? message, candy) {},
    );
  }

  ///设定二阶段验证
  void doActionAuthSet(CustomButtonController btnCtr, {bool isRefPwConfig = false}) async {
    // await Future.delayed(Duration(seconds: 5),() => null,);
    btnCtr.showAnimation();
    await ApiService.instance.requestAuthSet(
      password: authHelper.passwordText.value,
      auth_code: authHelper.codeText.value,
      success: (message) async {
        CustomSnackBar.show(
            message, title: S.current.success_pwd, Get.overlayContext!, preIcon: CustomSnackBarIcons.verifySucceed);
        btnCtr.hideAnimation();
        isOpenVerification.value = true;
        authHelper.passwordText.value = "";
        authHelper.codeText.value = "";
        if (!isRefPwConfig) {
          btnCtr.hideAnimation();
        }
        await AccountService.sharedInstance.refreshUserInfo();
        await globalController.getBrandBaseInfo();
        await globalController.getPassWordConfig();
        if (isRefPwConfig) {
          //这是处理钱包保险库设置双重验证成功后刷新数据
          //这是改变状态，为了更新界面
          globalController.isOpenVerificationAndPayPassword.value = true;
          globalController.bindGoogle.value = true;
          btnCtr.hideAnimation();
        }
      },
      fail: (bool isConnect, String? message, candy) {
        btnCtr.hideAnimation();
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, Get.overlayContext!);
      },
    );
  }

  ///关闭二阶段验证
  void doActionAuthClose(CustomButtonController btnCtr) async {
    // await Future.delayed(Duration(seconds: 5),() => null,);
    btnCtr.showAnimation();
    await ApiService.instance.requestAuthClose(
      password: unAuthHelper.passwordText.value,
      auth_code: unAuthHelper.codeText.value,
      success: (message) {
        CustomSnackBar.show(
            message, title: S.current.success_pwd, Get.overlayContext!, preIcon: CustomSnackBarIcons.setting);
        btnCtr.hideAnimation();
        isOpenVerification.value = false;
        unAuthHelper.passwordText.value = "";
        unAuthHelper.codeText.value = "";
        //重新获取验证授权码
        loadAuthSecretData();
        AccountService.sharedInstance.refreshUserInfo();
        globalController.getBrandBaseInfo();
        globalController.getPassWordConfig();
      },
      fail: (bool isConnect, String? message, candy) {
        btnCtr.hideAnimation();
        if (message?.isEmpty == true) return;
        CustomSnackBar.showError(message!, Get.overlayContext!);
      },
    );
  }

  String getGoogleKey() {
    User? currentUser = AccountService.sharedInstance.currentUser;
    return currentUser?.googleKey ?? "";
  }

  ///** appName */
  //   label: string
  //   /** email */
  //   email: string
  //   /** 密钥 */
  //   secret: string
  String getQrUrl() {
    return authQrcodeValueObs.value;
    // String? name = "";
    // String? gmail = "";
    // User? user = AccountService().currentUser;
    // if (user != null) {
    //   name = user.username;
    //   gmail = user.email;
    // }
    // var qrUrl = "otpauth://totp/${name}:${gmail}?secret=${authSecretValueObs.value}&issuer=${name}";
    // // log("二维码： $qrUrl");
    // return qrUrl;
  }
}
