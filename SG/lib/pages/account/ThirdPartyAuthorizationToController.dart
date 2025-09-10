import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/third_party_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/services/mqtt/mqtt_service.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../model/mobile_area_code.dart';
import '../../services/account_service.dart';
import '../../utils/common_util.dart';
import '../../utils/http/http_response.dart';
import '../../utils/keyboard_util.dart';
import '../../widget/button/custom_button_controller.dart';
import '../../widget/snack_bar/custom_snack_bar.dart';
import '../../widget/snack_bar/custom_snack_bar_icons.dart';
import 'model/model.dart';

class FiatPaymentDetailsToController extends GetxController {
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  var dic = {}.obs;
  final model = RegularModel().obs;
  final bindIndex = 0.obs;//修改资金密码 0 绑定邮箱 1 绑定手机号 2 绑定邮箱 手机号  3 无需绑定
  final showTitle = false.obs;

  BuildContext? context;
  late Timer timer;
  final seconds = 59.obs;
  final showTime = false.obs;
  final showResend = false.obs;

  final showPhone = false.obs;
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;
  int areaCodeSelectIndex = -1;
  final ScrollController scrollController = ScrollController();
  final areaCode = '+63'.obs;
  final isPhoneError = false.obs;
  final phoneErrorText = ''.obs;
  String phoneText = '';
  final phoneEnable = false.obs;

  String codeText = '';
  final isCodeError = false.obs;
  final codeErrorText = ''.obs;

  bool isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;

  onPhoneCheck( String value,bool isFocusLost) async {
    phoneText = value;
    if (value.isEmpty) {
      isPhoneError.value = true;
      phoneErrorText.value = S.current.random_text_1014;
      phoneEnable.value = false;
    } else {
      isPhoneError.value = false;
      if (value.length > 5 && value.length < 15 && codeText.length == 6){
        phoneEnable.value = true;
      } else {
        phoneEnable.value = false;
      }
    }
    if (isFocusLost) {
      if (value.length < 5 || value.length > 15){
        isPhoneError.value = true;
        phoneErrorText.value = S.current.random_text_1290;
      }
    }
  }

  Future<void> onInputCode(String value) async {
    codeText = value;
    if (value.isEmpty) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
      phoneEnable.value = false;
      return;
    } else if (value.length != 6) {
      isCodeError.value = true;
      codeErrorText.value = '您的手机验证码含有6位数字';
      phoneEnable.value = false;
      return;
    }
    if (!CommonUtil.isNumber(value)) {
      isCodeError.value = true;
      codeErrorText.value = S.current.random_text_1046;
      return;
    } else {
      isCodeError.value = false;
      codeErrorText.value = '';
      if (codeText.length == 6 && phoneText.length > 5 && phoneText.length < 15) {
        phoneEnable.value = true;
      } else {
        phoneEnable.value = false;
      }
    }
  }

  void resend() {
    if (!showTime.value) {
      verifyPhone();
    }
  }

  verifyPhone() async {
    // btnCtr.showAnimation();
    if (phoneText.isEmpty) {
      isPhoneError.value = true;
      phoneErrorText.value = S.current.random_text_1290;
      return ;
    }
    await ApiService.instance.verifyPhone(
        phone: '$areaCode-$phoneText',
        success: (message) {
          CustomSnackBar.show(title:S.current.success_pwd,S.current.random_text_878, context!, preIcon: CustomSnackBarIcons.activitySuccess);
          timedown();
        },
        fail: (message) {
          if (message == null) return;
          CustomSnackBar.showError(message, context);
        });
    // btnCtr.hideAnimation();
  }

  timedown() {
    showResend.value = true;
    showTime.value = true;
    seconds.value = 59;
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
  void onInit() {
    super.onInit();
    getBrandDetail();
    final keyboardVisibilityController = KeyboardVisibilityController();
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });
    // areaCode.value = globalController.getLangCode();
    getIP();
    loadArCode();
    getBrandDetailReg();
    ever(globalController.registerIndex, (callback) => getBrandDetailReg());
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
  
  ///获取配置信息
  Future<void> getBrandDetail({String tag = 'third'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        success: (dynamic) {
          if (dynamic['third'] != null) {
            dic.value = dynamic['third'];
          }
        },
        fail: (String? message) {});
  }

  ///获取配置信息
  Future<void> getBrandDetailReg({String tag = 'regapp'}) async {
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
      showPhone.value = false;
      bindIndex.value = 2;
    } else {
      bindIndex.value = 3;
    }
  }

  Future<void> onUpdatePhone(BuildContext context, CustomButtonController btnCtr) async {
    KeyboardUtils.hideKeyboard(context);
    if (areaCodeArray?.isEmpty == true || areaCodeSelectIndex == -1) return;
    final areaModel = areaCodeArray![areaCodeSelectIndex];
    final map = {'area_code': areaModel.attr, 'phone': phoneText};

    var code = areaModel.attr!.replaceAll('+', '%2B');
    await ApiService.instance.accountCheck(
        value: '$code-$phoneText',
        type: 3,
        noNotify: true,
        success: (message) {
          if (message.isNotEmpty) {
            CustomSnackBar.showError(message, context);
          } else {
            getInfo(context,captcha: codeText);
          }
        },
        fail: (message) {});
    // btnCtr.showAnimation();
    // await syncUserInfo(context, map,
    //     snackBarTitle: S.current.random_text_478,
    //     snackBarText: '${S.current.random_text_479}${areaModel.attr}${phoneText.value}',
    //     preIcon: CustomSnackBarIcons.phone);
    // btnCtr.hideAnimation();
  }

  Future<void> getInfo(BuildContext context,{String? captcha = ''}) async {
    final areaModel = areaCodeArray![areaCodeSelectIndex];
    final map = {'phone': '${areaModel.attr}-$phoneText'};
    // btnCtr.showAnimation();
    await syncUserInfo(context, map,
        captcha: captcha,
        snackBarTitle: S.current.random_text_478,
        snackBarText: '${S.current.random_text_479}${areaModel.attr} $phoneText',
        preIcon: CustomSnackBarIcons.phone);
    // btnCtr.hideAnimation();
  }

  Future<bool> syncUserInfo(BuildContext context, Map<String, dynamic> map,
      {String? snackBarTitle, String? snackBarText, Image? preIcon,String? captcha = ''}) async {
    HttpResponse h = await ApiService.instance.updateUserInfo(
        map: map,
        captcha: captcha,
        success: (message) {
          // RouteUtil.popView();
          AccountService.sharedInstance.refreshUserInfo();
          if (snackBarText != null) {
            CustomSnackBar.show(
              snackBarText,
              context,
              title: snackBarTitle,
              preIcon: preIcon ?? CustomSnackBarIcons.verifySucceed,
            );
          }
        },
        fail: (String? message) {
          CustomSnackBar.showError(message!, context);
        });
    return h.ok && h.statusOk;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///去facebook
  void goToThirdPartyFacebook() {
    goToThirdParty('fb', 1);
    Get.back();
  }

  ///去谷歌
  void goToThirdPartyGoogle() {
    goToThirdParty('google', 2);
    Get.back();
  }

  ///去line
  void goToThirdPartyLine() {
    goToThirdParty('line', 4);
    Get.back();
  }

  ///去twitch
  void goToThirdPartyTwitch() {
    goToThirdParty('twitch', 3);
    Get.back();
  }

  void goToThirdParty(String strType, int thirdPartyType) {
    globalController.thirdLoginEmail.value = '';
    //订阅监听结果
    MqttService.instance?.subscribeMemberGoogle();
    ApiService.instance.goToThirdParty(strType, success: (String url) {
      globalController.thirdPartyType = thirdPartyType;
      //打开网址
      log("neco 打开网址 $url");
      UrlLaunchUtil.launchURL(url);
    }, fail: (String? message) {
      MqttService.instance?.unsubscribeMemberGoogle();
    });
  }
}
