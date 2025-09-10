import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/mobile_area_code.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../utils/route_util.dart';
import '../../../utils/url_launch_util.dart';
import '../login/logic.dart';
import '../verify/verify_code/index.dart';

class ForgetPasswordController extends GetxController {
  String accountText = '';
  final isAccountError = false.obs;
  final accountErrorText = ''.obs;
  final isButtonEnable = false.obs;

  final isPhone = false.obs;
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;
  int areaCodeSelectIndex = -1;
  final ScrollController scrollController = ScrollController();
  final areaCode = '+63'.obs;
  bool isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;
  final LoginLogic loginLogic = Get.find<LoginLogic>();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  @override
  void onInit() {
    super.onInit();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
    areaCodeArray.addAll(loginLogic.areaCodeArray);
    showArray.addAll(loginLogic.areaCodeArray);
    getIP();
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

  Future<void> onInputAccount(String value) async {
    accountText = value;
    if (value.isEmpty) {
      isAccountError.value = false;
      accountErrorText.value = '';
      isButtonEnable.value = false;
      isPhone.value = false;
      return;
    }
    isPhone.value = CommonUtil.isNumber(value);
    if (isPhone.value) {
      
    } else {
      if (!value.contains('@')) {
        isAccountError.value = true;
        accountErrorText.value = S.current.random_text_fix1;
        isButtonEnable.value = false;
        return;
      }
      if (!CommonUtil.isEmail(value)) {
        isAccountError.value = true;
        accountErrorText.value = S.current.user_name_error_tips;
        isButtonEnable.value = false;
        return;
      }
    }
    isButtonEnable.value = true;
    isAccountError.value = false;
    accountErrorText.value = '';
  }

  Future<bool> onAccountCheck(BuildContext context, String value) async {
    bool isPass = false;
    accountText = value;
    if (value.isNotEmpty) {
      var code = areaCode.value.replaceAll('+', '%2B');
      if (isPhone.value) {
        await ApiService.instance.accountCheck(
        value: '$code-$accountText',
        type: 3,
        noNotify: true,
        success: (message) {
          if (message.isNotEmpty) {
            isPass = true;
          } else {
            isAccountError.value = true;
            accountErrorText.value = S.current.random_text_1145;
          }
        },
        fail: (message) {});
      } else {
        await ApiService.instance.accountCheck(
        value: value,
        type: 2,
        success: (message) {
          if (message.isNotEmpty) {
            isPass = true;
          } else {
            isAccountError.value = true;
            accountErrorText.value = S.current.random_text_1146;
          }
        },
        fail: (message) {});
      }
    }
    return isPass;
  }

  Future<void> onSubmit(
    BuildContext context,
    CustomButtonController btnCtr,
  ) async {
    // showCustomVerifyCodeWidget(number: accountText);
    // return;
    await onAccountCheck(context, accountText);
    if (!isAccountError.value) {
      if (isPhone.value) {
        verifyPhone(context: context,btnCtr: btnCtr);
      } else {
        verifyEmail(context: context,btnCtr: btnCtr);
      }
    }
    // showCustomEmailVerifyWidget();
    // return;
    // btnCtr.showAnimation();
    // await ApiService.instance.forgetPassword(
    //     email: accountText,
    //     success: (message) {
    //       CustomSnackBar.show(
    //         S.current.random_text_fix2,
    //         context,
    //         title: '${S.current.random_text_1}$accountText',
    //         preIcon: CustomSnackBarIcons.email,
    //       );
    //     },
    //     fail: (message) {
    //       if (message == null) return;
    //       CustomSnackBar.showError(message, context);
    //     });
    // btnCtr.hideAnimation();
  }

  verifyEmail({required BuildContext context,required CustomButtonController btnCtr,}) async {
    btnCtr.showAnimation();
    await ApiService.instance.verifyEmail(
        email: accountText,
        success: (message) {
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
          showCustomVerifyCodeWidget(number: accountText);
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    btnCtr.hideAnimation();
  }

  verifyPhone({required BuildContext context,required CustomButtonController btnCtr,}) async {
    btnCtr.showAnimation();
    await ApiService.instance.verifyPhone(
        phone: '${areaCode.value}-$accountText',
        success: (message) {
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
          showCustomVerifyCodeWidget(number: '${areaCode.value} $accountText');
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    btnCtr.hideAnimation();
  }

  onTapService() {
    RouteUtil.popView();
    RouteUtil.popView();
    if (globalController.csUrl.isEmpty) {
      globalController.brandCS();
      // return;
    }
    UrlLaunchUtil.jumpCs();
  }

}
