import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_urls_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/mobile_area_code.dart';
import 'package:flutter_bet/model/user.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/account_api_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/http/http_response.dart';
import 'package:flutter_bet/utils/keyboard_util.dart';
import 'package:flutter_bet/widget/button/custom_button_controller.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../constant/app_cache_key.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../utils/sp_util.dart';
import '../../../utils/url_launch_util.dart';
import '../../account/model/model.dart';
import '../../account/verify/verify/view.dart';
import '../index/logic.dart';

class SetupContactController extends GetxController {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final SetupLogic setupLogic = Get.put(SetupLogic());
  final ScrollController scrollController = ScrollController();
  final model = RegularModel().obs;
  final needPhone = false.obs;
  final emailText = ''.obs;
  final userEmail = ''.obs;
  final isEmailTextError = false.obs;
  final emailErrorText = ''.obs;
  final areaCodeText = ''.obs;
  final isBindEmail = false.obs; //是否绑定了邮箱
  final isPhone = false.obs;
  final needVerify = false.obs;
  final userPhone = ''.obs;
  final isBindPhone = false.obs; //是否绑定了手机
  final sended = false.obs;
  final canSavePhone = false.obs;
  final canSaveEmail = false.obs;
  final canResendEmail = false.obs;
  final canEditorEmail = true.obs;
  final noSendEmail = true.obs;
  final isCheckedEmail = false.obs;
  final isGmail = false.obs;
  final areaCodeArray = <MobileAreaCodeModel>[];
  final showArray = <MobileAreaCodeModel>[].obs;
  final userModel = User.fromJson({}).obs;
  final seconds = 0.obs;
  final isShowTime = false.obs;
  final facebookText = "".obs;
  final whatsappText = "whats".obs;
  final telegramText = "".obs;
  final lineText = "".obs;
  final xText = "".obs;
  final zaloText = "".obs;
  final viberText = "".obs;
  final wechatText = "".obs;
  final phoneText = "".obs;
  final isPhoneError = false.obs;
  final phoneErrorText = ''.obs;
  final isEnableSaveButton = false.obs;
  final FullTime = 59.obs;/// 倒计时的秒数
  final isClick = false.obs;/// 是否已经点击“重新发送”这个按钮，默认没有按

  
  var userCode = '';

  int areaCodeSelectIndex = -1;
  bool isKeyboardVisible = false;
  AccountServiceListener? _accountListener;
  BuildContext? context;

  late Timer timer;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void onClose() {
    SPUtil().setJson('seconds', {'seconds': seconds.value, 'date': DateTime.now().millisecondsSinceEpoch});
    GlobalState.instance.isEdit = false;
    /// 记录当前倒计时的秒数
    SPUtil().setBool(CacheKey.isShowTime,false);
    isShowTime.value = (SPUtil().getBool(CacheKey.isShowTime))!;
    /// 离开这个页面，按钮就当没有点按过
    SPUtil().setBool(CacheKey.isClick,false);
    isClick.value = (SPUtil().getBool(CacheKey.isClick))!;

    keyboardSubscription.cancel();
    if (_accountListener != null) {
      AccountService.sharedInstance.removeListener(_accountListener!);
    }
    // 先做事，后调父类
    super.onClose();
  }
  @override
  void onInit() {
    everAll(
      [facebookText,
        whatsappText,
        telegramText,
        lineText,
        xText,
        zaloText,
        viberText,
        wechatText],
          (_) => checkSaveButton(),
    );

    /// 进入这个页面，按钮是没有点按过
    SPUtil().setBool(CacheKey.isClick,false);
    isClick.value = (SPUtil().getBool(CacheKey.isClick))!;
    /// 获得上次退出页面时，所记录的倒计时秒值
    seconds.value = SPUtil().getInt(CacheKey.countdownKey) ?? 0;
    /// 刚进页面，倒计时是看不到的
    isShowTime.value = false;
    canSaveEmail.value = true;
    canResendEmail.value = true;
    _accountListener = AccountServiceListener(onUserInfoChange: (model) {
      _updateInfo();
    });
    AccountService.sharedInstance.addListener(_accountListener!);
    final keyboardVisibilityController = KeyboardVisibilityController();
    keyboardSubscription = keyboardVisibilityController.onChange.listen((bool visible) {
      isKeyboardVisible = visible;
    });

    /// 必须写，要不走到一半不动了！！！
    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {});

    loadArCode();
    initTime();
    getIP();
    getBrandDetail();
    ever(globalController.registerIndex, (callback) => getBrandDetail());
    // 先做事，后调父类
    super.onInit();
  }
  /// iscan ：倒计时过程中，不能点按发送邮件按钮。
  countdown(bool iscan, int sec) {
    if (timer.isActive) timer.cancel();
    seconds.value = sec <= 0 ? FullTime.value : sec;
    if(isClick.value) canResendEmail.value = false;
    if (iscan) canSaveEmail.value = false;
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      SPUtil().setBool(CacheKey.isShowTime,seconds.value > 0);
      isShowTime.value = (SPUtil().getBool(CacheKey.isShowTime))!;
      if (seconds.value <= 0) {
        canResendEmail.value = true;
        if (iscan) canSaveEmail.value = true;
        if (timer.isActive) timer.cancel();
      } else {
        seconds.value--;
        SPUtil().setInt(CacheKey.countdownKey, seconds.value);
      }
    });
  }
  getOrigincode() {
    if (userCode.isNotEmpty && areaCodeArray.isNotEmpty) {
      int index = 0;
      for (MobileAreaCodeModel model in areaCodeArray) {
        if (model.attr == userCode) {
          areaCodeSelectIndex = index;
          areaCodeText.value = '${model.attr}';
          setupLogic.areaCodeSelectIndex = index;
          setupLogic.areaCodeText.value = areaCodeText.value;
          break;
        }
        index++;
      }
    }
  }
  initTime() {
    var dic = SPUtil().getJson('seconds');
    if (dic != null && dic.containsKey('seconds')) {
      var seconds = dic['seconds'];
      var nowTime = DateTime.now().millisecondsSinceEpoch;
      var oldTime = dic['date'];
      if (oldTime + seconds * 1000 > nowTime) {
        var sec = oldTime + seconds * 1000 - nowTime;
        if((SPUtil().getBool(CacheKey.isShowTime)) ?? false){
          countdown(false, (sec / 1000).round());
        }
      }
    }
  }
  checkSaveButton() {
    bool isAnyFieldNotEmpty = facebookText.value.isNotEmpty ||
        whatsappText.value.isNotEmpty ||
        telegramText.value.isNotEmpty ||
        lineText.value.isNotEmpty ||
        xText.value.isNotEmpty ||
        zaloText.value.isNotEmpty ||
        viberText.value.isNotEmpty ||
        wechatText.value.isNotEmpty;
    isEnableSaveButton.value = isAnyFieldNotEmpty && GlobalState.instance.isEdit;
  }
  getCurrLanguage() {
    if (areaCodeArray.isEmpty) {
      areaCodeText.value = "";
    }
    // areaCodeSelectIndex = 0;
    // areaCodeText.value = '${areaCodeArray[0].attr} ${areaCodeArray[0].name}';
    getOrigincode();
    // String langCode = globalController.getLangCode();
    // for (int i = 0; i < areaCodeArray.length; i++) {
    //   if (areaCodeArray[i].attr == langCode) {
    //     areaCodeSelectIndex = i;
    //     areaCodeText.value = '${areaCodeArray[i].attr} ${areaCodeArray[i].name}';
    //     break;
    //   }
    // }
  }
  saveSocialInfo(BuildContext context) {
    final info = {
      "facebook": facebookText.value,
      "whatsapp": whatsappText.value,
      "telegram": telegramText.value,
      "line": lineText.value,
      "twitter": xText.value,
      "zalo": zaloText.value,
      "viber": viberText.value,
      "wechat": wechatText.value,
    };
    syncUserInfo(context, info, snackBarTitle: S.current.success_pwd, snackBarText: S.current.random_text_1200);/// 已保存成功
  }
  setSocialInfo() {
    facebookText.value = userModel.value.mext?.facebook ?? '';
    whatsappText.value = userModel.value.mext?.whatsapp ?? '';
    telegramText.value = userModel.value.mext?.telegram ?? '';
    lineText.value = userModel.value.mext?.line ?? '';
    xText.value = userModel.value.mext?.twitter ?? '';
    zaloText.value = userModel.value.mext?.zalo ?? '';
    viberText.value = userModel.value.mext?.viber ?? '';
    wechatText.value = userModel.value.mext?.wechat ?? '';
  }
  /// 关闭软键盘
  hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }
  /// 去谷歌邮箱
  goToGoogleEmail() {
    //打开网址
    UrlLaunchUtil.launchURL(
        'https://mail.google.com/mail/u/#search/from:@${AppUrlsValues.envConfig.api_url}',
        mode: LaunchMode.platformDefault);
  }
  /// 验证Gmail邮箱地址
  bool isValidGmail(String email) {
    if (emailText.isEmpty) {
      return false;
    }
    RegExp gmailRegExp = RegExp(r'^[a-zA-Z0-9_.+-]+@gmail\.com$');
    return gmailRegExp.hasMatch(email);
  }

  Future<void> changeEmail(String value) async {
    emailText.value = value;
    if (CommonUtil.isEmail(value)) {
      canSaveEmail.value = true;
    } else {
      canSaveEmail.value = false;
    }
    // onInputEmail(value);
  }
  Future<void> onInputEmail(String value) async {
    emailText.value = value;

    if (isValidGmail(emailText.value)) {
      isGmail.value = true;
    } else {
      isGmail.value = false;
    }

    final account = AccountService.sharedInstance.currentUser;
    if (emailText.value == account?.email) {
      emailErrorText.value = '';
      isEmailTextError.value = false;
      canSaveEmail.value = false;
      return;
    } else {
      canSaveEmail.value = true;
    }

    if (value.isEmpty) {
      isEmailTextError.value = true;
      emailErrorText.value = '此字段为必填项';
      return;
    }
    if (!value.contains('@')) {
      isEmailTextError.value = true;
      emailErrorText.value = S.current.email_error_tips;/// 请在您的电邮地址中加入 “@” 符号
      return;
    }
    if (!CommonUtil.isEmail(value)) {
      isEmailTextError.value = true;
      emailErrorText.value = S.current.email_error_tips;/// 用户名含有无效的字符
      return;
    }
    isEmailTextError.value = false;
    emailErrorText.value = '';
  }
  Future<void> onInputAreaCode(String value) async {
    areaCodeText.value = value;
    if (areaCodeText.value.isEmpty || phoneText.value.isEmpty) {
      canSavePhone.value = false;
    } else {
      canSavePhone.value = true;
    }
  }
  Future<void> onInputPhone(String value) async {
    phoneText.value = value;
    if (areaCodeText.value.isEmpty || phoneText.value.isEmpty) {
      isPhoneError.value = false;
      phoneErrorText.value = '';
      canSavePhone.value = false;
    } else {
      if (phoneText.value.length < 6 || phoneText.value.length > 16) {
        isPhoneError.value = true;
        phoneErrorText.value = S.current.random_text_1290;/// 手机号码无效
        canSavePhone.value = false;
      } else {
        isPhoneError.value = false;
        phoneErrorText.value = '';
        canSavePhone.value = true;
      }
    }
  }
  Future<void> onInputFacebook(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    facebookText.value = value;
  }
  Future<void> onInputWhatsapp(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    whatsappText.value = value;
  }
  Future<void> onInputTelegram(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    telegramText.value = value;
  }
  Future<void> onInputLine(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    lineText.value = value;
  }
  Future<void> onInputX(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    xText.value = value;
  }
  Future<void> onInputZalo(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    zaloText.value = value;
  }
  Future<void> onInputViber(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    viberText.value = value;
  }
  Future<void> onInputWechat(String value) async {
    // 编辑了，那么第一次灌入数据的，禁止提交限制被解除
    GlobalState.instance.isEdit = value.isNotEmpty;
    wechatText.value = value;
  }
  ///获取配置信息
  Future<void> getBrandDetail({String tag = 'regapp'}) async {
    await ApiService.instance.getBrandDetail(
        tag: tag,
        success: (dynamic) {
          if (dynamic['reg'] != null) {
            model.value = RegularModel.fromJson(dynamic['reg'].first);
            // print('object---------配置--${dynamic['reg'].first}');
            if (model.value.phone!.phone == true && model.value.phone!.verify == true) {
              needPhone.value = true;
            } else {
              needPhone.value = false;
            }
          }
        },
        fail: (String? message) {});
  }
  Future<void> getUserInfo() async {
    if (AccountService.sharedInstance.isLogin() == false) return;
    userModel.value = AccountService.sharedInstance.currentUser!;
    final account = AccountService.sharedInstance.currentUser;
    await ApiService.instance.getUserInfo(
        token: account!.token,
        success: (user) {
          final newUser = user.copyWith(token: account.token);
          AccountService.sharedInstance.loginUser(newUser);
          emailText.value = user.email ?? '';
          userEmail.value = user.email ?? '';
          phoneText.value = '';
          if (user.phone!.isNotEmpty) {
            areaCodeText.value = user.phone!.split('-').first;
            phoneText.value = user.phone!.split('-').last;
          }
          userPhone.value = phoneText.value;
        },
        fail: (errorMessage) {
        });
  }
  Future<void> getIP() async {
    var response = await Dio().get('https://ipapi.co/json/');
    userCode = response.data['country_calling_code'];
    if (userModel.value.phone!.isNotEmpty) {
      userCode = userModel.value.phone!.split('-').first;
    }
    getOrigincode();
  }
  Future<void> loadArCode() async {
    await ApiService.instance.treeList<MobileAreaCodeModel>(
        success: (list) {
          areaCodeArray.addAll(list);
          showArray.addAll(list);
          getCurrLanguage();
          _updateInfo();
        },
        fail: (errorMessage) {},
        level: "011",
        converter: (json) {
          return MobileAreaCodeModel.fromJson(json);
        });
  }
  Future<void> _updateInfo() async {
    if (AccountService.sharedInstance.isLogin() == false) return;
    userModel.value = AccountService.sharedInstance.currentUser!;
    final account = AccountService.sharedInstance.currentUser;
    int emailCheckState = AccountService.sharedInstance.currentUser?.emailCheckState ?? 0;
    isBindEmail.value = emailCheckState == 1;
    // if (emailText.isEmpty) {
    emailText.value = account?.email ?? '';
    userEmail.value = account?.email ?? ''; 
    // }
    if (account!.phone!.isNotEmpty) {
      if (phoneText.isEmpty) {
        areaCodeText.value = account.phone!.split('-').first;
        phoneText.value = account.phone!.split('-').last;
      }
    }
    setSocialInfo();

    int phoneCheckState = AccountService.sharedInstance.currentUser?.phoneCheckState ?? 0;
    isBindPhone.value = phoneCheckState == 1;
    // areaCodeText.value = account?.areaCode ?? '';
    if (areaCodeText.isNotEmpty == true && areaCodeArray.isNotEmpty == true) {
      int index = 0;
      for (MobileAreaCodeModel model in areaCodeArray) {
        if (model.attr == areaCodeText.value) {
          areaCodeSelectIndex = index;
          areaCodeText.value = '${model.attr}';
          break;
        }
        index++;
      }
    }
    // phoneText.value = account?.mext?.phone ?? '';
    userPhone.value = phoneText.value;
    if (areaCodeText.value.isEmpty || phoneText.value.isEmpty) {
      canSavePhone.value = false;
      isPhone.value = false;
      // needVerify.value = false;
    } else {
      canSavePhone.value = true;
      isPhone.value = true;
      // needVerify.value = true;
    }
    if (isValidGmail(account?.email ?? "")) {
      isGmail.value = true;
    } else {
      isGmail.value = false;
    }

    ///邮箱是否验证1=已验证,2=未验证
    if (account?.emailCheckState == 2) {
      canSaveEmail.value = false;
      canResendEmail.value = true;
      canEditorEmail.value = true;
      /// 正在倒计时
      if (seconds.value < FullTime.value && seconds.value > 0) {
        if(isClick.value) canResendEmail.value = false;
      }
    } else if (account?.emailCheckState == 1) {
      canEditorEmail.value = false;
      canSaveEmail.value = false;
      canResendEmail.value = false;
    } else {
      canEditorEmail.value = false;
      canSaveEmail.value = false;
      canResendEmail.value = false;
    }
    // print('object--------${isBindPhone.value}');
  }
  Future<void> onEmailCheck(BuildContext context,
      CustomButtonController? btnCtr) async {
    if (!canResendEmail.value) return;
    if (!CommonUtil.isEmail(emailText.value) || emailText.isEmpty) return;
    if (emailText.value != userEmail.value) {
      var existed = await checkEmail();
      if (existed.isNotEmpty) {
        CustomSnackBar.showError(existed, context);
        return;
      }
    }

    btnCtr?.showAnimation();
    countdown(false, seconds.value);

    SPUtil().setBool(CacheKey.isShowTime,true);
    isShowTime.value = (SPUtil().getBool(CacheKey.isShowTime))!;

    await ApiService.instance.emailCheck(
        email: emailText.value,
        success: (message) {
          noSendEmail.value = false;
          if (seconds.value == FullTime.value) {
            CustomSnackBar.show(
                '${S.current.random_text_672}${emailText.value}',/// 验证电邮已重新发送至
                title: S.current.random_text_673,/// 已重新发送电邮
                context,
                preIcon: CustomSnackBarIcons.blueEmail);
          }

          if (canSaveEmail.value && seconds.value == 0) {
            onUpdateEmail(context, btnCtr, isSaveHint: false);
          }
        },
        fail: (message) {
          if (message?.isEmpty == true) return;
          CustomSnackBar.showError(message!, context);
          if (timer.isActive) timer.cancel();
        });
    btnCtr?.hideAnimation();
  }
  /// Ok
  Future<void> onUpdateEmail(BuildContext context,
      CustomButtonController? btnCtr,
      {bool isSaveHint = true}) async {
    final map = {'email': emailText.value};
    if (!CommonUtil.isEmail(emailText.value) || emailText.isEmpty) {
      return;
    }
    if (emailText.value != userEmail.value) {
      var existed = await checkEmail();
      if (existed.isNotEmpty) {
        CustomSnackBar.showError(existed, context);
        return;
      }
    }
    
    btnCtr?.showAnimation();
    isClick.value = true;
    bool isUpdateOk = await syncUserInfo(context, map,
        snackBarTitle: S.current.random_text_476,/// 成功更新电邮地址
        snackBarText: '${S.current.random_text_477}$emailText',/// 确认电邮已发送至
        preIcon: CustomSnackBarIcons.blueEmail);
    if (isUpdateOk && isSaveHint) {
      countdown(canSaveEmail.value, 0);
      ApiService.instance.emailCheck(
          email: emailText.value,
          success: (message) {
            sended.value = true;
            // CustomSnackBar.show(
            //     '${S.current.random_text_674}${emailText.value}',
            //     title: S.current.random_text_476,
            //     context,
            //     preIcon: CustomSnackBarIcons.blueEmail);
          },
          fail: (message) {
            if (message?.isEmpty == true) return;
            CustomSnackBar.showError(message!, context);
            if (timer.isActive) timer.cancel();
          });
    }
    btnCtr?.hideAnimation();
  }

  Future<String> checkEmail() async {
    String isPass = '';
    await ApiService.instance.accountCheck(
        value: emailText.value,
        type: 2,
        success: (message) {
          if (message.isNotEmpty) {
            isPass = message;
            
          }
        },
        fail: (message) {
        });
    return isPass;
  }

  Future<void> onUpdatePhone(BuildContext context,
      CustomButtonController btnCtr) async {
    KeyboardUtils.hideKeyboard(context);
    if (areaCodeArray?.isEmpty == true || areaCodeSelectIndex == -1) return;
    final areaModel = areaCodeArray![areaCodeSelectIndex];
    final map = {'area_code': areaModel.attr, 'phone': phoneText.value};

    if (userPhone.value == phoneText.value) {
      if (needPhone.value) {
        showCustomVerifyWidget(number: '${areaModel.attr} ${phoneText.value}');
      } else {
        getInfo(context);
      }
      return ;
    }
    var code = areaModel.attr!.replaceAll('+', '%2B');
    await ApiService.instance.accountCheck(
        value: '$code-${phoneText.value}',
        type: 3,
        noNotify: true,
        success: (message) {
          if (message.isNotEmpty) {
            CustomSnackBar.showError(message, context);
          } else {
            if (needPhone.value) {
              showCustomVerifyWidget(number: '${areaModel.attr} ${phoneText.value}');
            } else {
              getInfo(context);
            }
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
  Future<void> getInfo(BuildContext context,
      {String? captcha = ''}) async {
    final areaModel = areaCodeArray![areaCodeSelectIndex];
    final map = {'phone': '${areaModel.attr}-${phoneText.value}'};
    // btnCtr.showAnimation();
    await syncUserInfo(context, map,
        captcha: captcha,
        snackBarTitle: S.current.random_text_478,/// 成功更新手机号码
        snackBarText: '${S.current.random_text_479}${areaModel.attr} ${phoneText.value}',/// 手机号码已更新为
        preIcon: CustomSnackBarIcons.phone);
    // btnCtr.hideAnimation();
  }
  Future<bool> syncUserInfo(BuildContext context,
      Map<String, dynamic> map,
      {String? snackBarTitle,
        String? snackBarText,
        Image? preIcon,
        String? captcha = ''}) async {
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
          if (message != null) {
            CustomSnackBar.showError(message, context);
          }
        });
    return h.ok && h.statusOk;
  }
  Future<void> onSelectAreaCode(int index) async {
    areaCodeSelectIndex = index;
    final model = showArray[index];
    areaCodeText.value = '${model.attr}';
    if (areaCodeText.value.isEmpty || phoneText.value.isEmpty) {
      canSavePhone.value = false;
    } else {
      canSavePhone.value = true;
    }
    // RouteUtil.popView();
    setupLogic.showCode.value = false;
  }
}
