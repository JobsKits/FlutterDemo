import 'dart:convert';

import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/modules/login/controllers/login_dialog_controller.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/open_share_plugin.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
// import 'package:openinstall_flutter_plugin/openinstall_flutter_plugin.dart';

import '../data/contact_config_bean.dart';

//登录弹窗内，注册页面的内容
enum RegisterType {
  userNameRegisterType, //用户名注册
  emailRegisterType, //邮箱注册
  phoneRegisterType, //手机号注册
}

typedef RegisterModeMapType = Map<RegisterType, bool>;

class RegisterContentController extends GetxController {
  RxString userName = "".obs; //用户名
  RxString userPwd = "".obs; //密码
  RxString userConfirmPwd = "".obs; //确认密码
  RxString userPhone = "".obs; //手机号
  RxString userCode = "".obs; //验证码
  RxString userEmail = "".obs; //邮箱
  RxString userInviteCode = "".obs; // 邀请码

  RxString contactName = "".obs; // 真实姓名
  RxString nickName = "".obs; // 昵称
  RxString acctPwd = "".obs; // 资金密码
  RxString mobilePhone = "".obs; // mobilePhone
  RxString zalo = "".obs; // zalo
  RxString line = "".obs; // line
  RxString facebook = "".obs; // facebook
  RxString telegram = "".obs; // telegram
  RxString whatsApp = "".obs; // whatsApp
  RxString email = "".obs; // email
  RxString qq = "".obs; // qq

  RxString defualtContent = "".obs; // qq

  RxBool isCheckAgree = false.obs; //是否选中同意条款

  /// 字段显示配置相关
  /// --------------------------------------------------
  RxBool hasRealName = false.obs; // 真实姓名
  RxBool hasPhone = false.obs; // 手机号码
  RxBool hasQQ = false.obs; // QQ
  RxBool hasEmail = false.obs; // 邮箱号码
  RxBool hasInvite = false.obs; // 邀请码
  RxBool hasZalo = false.obs; // Zalo
  RxBool hasLine = false.obs; // Line
  RxBool hasFacebook = false.obs; // Facebook
  RxBool hasWhatsApp = false.obs; // WhatsApp
  RxBool hasTelegram = false.obs; // Telegram
  RxBool hasRepassWord = false.obs; // 确认密码
  RxBool hasAcctPwd = false.obs; // 资金密码
  RxBool hasNickName = false.obs; // 昵称

  RxBool hasRealNameRequire = false.obs;
  RxBool hasPhoneRequire = false.obs;
  RxBool hasQQRequire = false.obs;
  RxBool hasEmailRequire = false.obs;
  RxBool hasInviteRequire = false.obs;
  RxBool hasZaloRequire = false.obs;
  RxBool hasLineRequire = false.obs;
  RxBool hasFacebookRequire = false.obs;
  RxBool hasWhatsAppRequire = false.obs;
  RxBool hasTelegramRequire = false.obs;
  RxBool hasRepassWordRequire = false.obs;
  RxBool hasAcctPwdRequire = false.obs;
  RxBool hasNickNameRequire = false.obs;

  /// --------------------------------------------------

  /// 图形验证码相关
  /// --------------------------------------------------
  RxString verifyCode = "".obs; //图形验证码Code
  RxString verifyImage = "".obs; // 图形验证码图片
  RxString verifyCodeKey = "".obs; // 图形验证码key
  RxBool isShowImageVerifyCode = false.obs; // 是否显示图形验证码
  /// --------------------------------------------------

  /// /// 易盾智能验证
  bool isAiVerify = false;
  String captchaId = '';
  String aiValidate = '';

  /// 防重复请求相关
  /// --------------------------------------------------
  RxBool isRequestImageVerifyCode = false.obs; // 是否请求图形验证码
  RxBool isRequestEmailCode = false.obs; // 是否请求邮箱验证码
  RxBool isRequestPhoneCode = false.obs; // 是否请求手机验证码
  RxBool isRequestRegister = false.obs; // 是否请求手机验证码
  /// --------------------------------------------------

  RxString pwdLevel = '1'.obs; // 密码等级

  RegisterModeMapType registerModeMap = {
    // 模块显示MAP
    RegisterType.userNameRegisterType: false,
    RegisterType.emailRegisterType: false,
    RegisterType.phoneRegisterType: false,
  };

  RxString verifyErrorTips = "".obs; //校验失败的提示信息
  RxBool isCanRegister = false.obs; //是否可以注册
  late TabsController bottomTabsController;
  Rx<RegisterType> currentRegisterType =
      RegisterType.userNameRegisterType.obs; //当前登录方式
  late LoginDialogController loginDialogController;

  RxList<CountryCode> countrys = <CountryCode>[].obs;
  final Map<String, dynamic> _defaultCountryCode = {
    'name': '中国',
    'code': 'CN',
    'dial_code': '+86',
  };
  late Rx<CountryCode> countryCode =
      CountryCode.fromJson(_defaultCountryCode).obs;
  late VoidCallback? callback;
  RxBool isRememberPwd = true.obs; //是否记住密码
  RxBool isNewLogin = false.obs;

  @override
  void onInit() async {
    super.onInit();
    bottomTabsController = Get.find<TabsController>();
    loginDialogController = Get.find<LoginDialogController>();

    // String params = await OpenSharePlugin.getInstallParams();
    // print('OpenShare参数: ${params}');
    // if (params.isNotEmpty) {
    //   final paramsObj = jsonDecode(params);
    //   if (paramsObj['code'] is String) {
    //     userInviteCode.value = paramsObj['code'];
    //   }
    // }
    // if (userInviteCode.isEmpty) {
    // print('请求OpenInstall参数');
    // OpeninstallFlutterPlugin openinstallFlutterPlugin =
    //     OpeninstallFlutterPlugin();
    // openinstallFlutterPlugin.install(installHandler);
    // }
  }

  @override
  void onReady() async {
    // 处理异步请求
    super.onReady();

    await _reqContactInfo();
    // 请求一次图形验证码的
    await reqImageVerifyCode();
    if (userName.isNotEmpty) {
      loginVerify(); //因为可能从配置拿数据，所以打开就需要校验一次
    }
  }

  Future installHandler(Map<String, Object> data) async {
    if (data['bindData'] is String) {
      Map bindData = jsonDecode(data['bindData'] as String);
      userInviteCode.value = bindData['code'];
    }
  }

  // 请求租户注册联系人配置
  Future<void> _reqContactInfo() async {
    final res = await LoginApi.reqContactConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      ContactConfigBean ccb = ContactConfigBean.fromJson(res.data);

      SysRegisterOptionsBean sysRegisterOptions = ccb.sysOptions!;
      _initRegisterType(sysRegisterOptions);
    }
  }

  // 初始化注册类型
  _initRegisterType(SysRegisterOptionsBean sysRegisterOptions) {
    // 设置图形验证码显示状态
    isShowImageVerifyCode.value =
        sysRegisterOptions.CUST_REGISTER_CAPTCHA_MODE!.PICTURE_SWITCH == '1';

    // 是否展示易盾智能验证
    String? smartSwitch =
        sysRegisterOptions.CUST_REGISTER_CAPTCHA_MODE!.SMART_SWITCH;
    String? smartCaptchaMode =
        sysRegisterOptions.CUST_REGISTER_CAPTCHA_MODE!.Z2_M_SMART_CAPTCHA_MODE;
    if (smartSwitch == '1' && smartCaptchaMode != '0') {
      String idKey = 'CAPTCHA_ID_${smartCaptchaMode}';
      if (sysRegisterOptions.YIDUN_CAPTCHA_ID?[idKey] != null) {
        isAiVerify = true;
        captchaId = (sysRegisterOptions.YIDUN_CAPTCHA_ID?[idKey])!;
      }
    }

    bool accountMode = sysRegisterOptions.CUST_REGISTER_MODE!.account == '1';
    bool emailMode =
        sysRegisterOptions.CUST_REGISTER_MODE!.email_captcha == '1';
    bool phoneMode =
        sysRegisterOptions.CUST_REGISTER_MODE!.phone_captcha == '1';
    bool newPhoneMode =
        sysRegisterOptions.CUST_REGISTER_MODE!.phone_pwd_captcha == '1';
    print({
      'object --------- ${sysRegisterOptions.CUST_REGISTER_MODE?.toJson()}'
    });
    // 设置注册模式显示状态
    registerModeMap[RegisterType.userNameRegisterType] = accountMode;
    registerModeMap[RegisterType.emailRegisterType] = emailMode;
    registerModeMap[RegisterType.phoneRegisterType] = phoneMode;

    // 设置初始化显示的模式
    if (accountMode) {
      currentRegisterType.value = RegisterType.userNameRegisterType;
    } else if (emailMode) {
      currentRegisterType.value = RegisterType.emailRegisterType;
    } else if (phoneMode) {
      currentRegisterType.value = RegisterType.phoneRegisterType;
    } else if (newPhoneMode) {
      isNewLogin.value = true;
      currentRegisterType.value = RegisterType.userNameRegisterType;
    }

    // 设置密码等级
    pwdLevel.value =
        sysRegisterOptions.CUST_REGISTER_PASSWORD_MODE!.PASSWORD_MODE ?? '1';

    CountryCode? defaultCountryCode;

    sysRegisterOptions.SMS_OPEN_COUNTRY!.forEach((key, value) {
      var splitValue = value.split('+');
      var code = splitValue[0].trim();
      var dialCode = splitValue[1].trim();
      var country = CountryCode(name: key, code: code, dialCode: dialCode);
      countrys.add(country);

      defaultCountryCode ??= country;
    });

    if (countrys.isNotEmpty) {
      countryCode.value = defaultCountryCode!;
    }

    // 设置联系列表
    if (sysRegisterOptions.CUST_CONTACT_LIST != '') {
      List<String> contactList =
          sysRegisterOptions.CUST_CONTACT_LIST!.split(',');
      Map<String, String> tempMap = {};

      for (int i = 0; i < contactList.length; i++) {
        List<String> contactItemList = contactList[i].split(':');
        tempMap[contactItemList[0]] = contactItemList[1].toString();
      }

      hasRealName.value = tempMap['Z1_real_name'] == '1';
      hasPhone.value = tempMap['Z1_mobile_phone'] == '1';
      hasQQ.value = tempMap['Z1_qq'] == '1';
      hasEmail.value = tempMap['Z1_email'] == '1';
      hasInvite.value = tempMap['Z1_code'] == '1';
      hasZalo.value = tempMap['Z1_zalo'] == '1';
      hasLine.value = tempMap['Z1_line'] == '1';
      hasFacebook.value = tempMap['Z1_facebook'] == '1';
      hasWhatsApp.value = tempMap['Z1_whatsApp'] == '1';
      hasTelegram.value = tempMap['Z1_telegram'] == '1';
      hasRepassWord.value = tempMap['Z1_confirm_password'] == '1';
      hasAcctPwd.value = tempMap['Z1_withdrawal_password'] == '1';
      hasNickName.value = tempMap['Z1_nickname'] == '1';

      hasRealNameRequire.value = tempMap['Z2_real_name'] == '1';
      hasPhoneRequire.value = tempMap['Z2_mobile_phone'] == '1';
      hasQQRequire.value = tempMap['Z2_qq'] == '1';
      hasEmailRequire.value = tempMap['Z2_email'] == '1';
      hasInviteRequire.value = tempMap['Z2_code'] == '1';
      hasZaloRequire.value = tempMap['Z2_zalo'] == '1';
      hasLineRequire.value = tempMap['Z2_line'] == '1';
      hasFacebookRequire.value = tempMap['Z2_facebook'] == '1';
      hasWhatsAppRequire.value = tempMap['Z2_whatsApp'] == '1';
      hasTelegramRequire.value = tempMap['Z2_telegram'] == '1';
      hasRepassWordRequire.value = tempMap['Z2_confirm_password'] == '1';
      hasAcctPwdRequire.value = tempMap['Z2_withdrawal_password'] == '1';
      hasNickNameRequire.value = tempMap['Z2_nickname'] == '1';
    }
  }

  //保存用户信息，内存、本地各一份
  void _saveRegisterInfo(LoginBean loginBean) async {
    LoginManager.instance.setLoginBean(loginBean); //保存一份到内存中
    SystemApi.updatePushInfo();
    print(
        "注册成功：${loginBean.accessToken} 保存的数据为：${LoginManager.instance.loginInfo?.accessToken}");

    UserLocalBean userLocalBean = UserLocalBean.fromJson({
      "userInputName": userName.value,
      "userInputEmail": userEmail.value,
      "userInputPhone": userPhone.value,
      "userIsRememberPwd": isRememberPwd.value,
      "userInputPwd": isRememberPwd.value ? userPwd.value : "",
    });

    await SpUtil.saveBean<LoginBean>(
        "loginBean", loginBean); //把保存了接口用户信息和记住密码状态、密码的用户信息对象，进行本地保存

    // 单独存储用户名/密码等信息，退出时不需要清理
    await SpUtil.saveBean<UserLocalBean>("userLocalBean", userLocalBean);
  }

  // 获取图形验证码
  reqImageVerifyCode() async {
    if (isRequestImageVerifyCode.value) {
      return false;
    }

    isRequestImageVerifyCode.value = true;
    final res = await LoginApi.reqImageVerifyCode(2);

    if (res.type == NetworkService.networkTypeSuccess) {
      final data = ImageVerifyCodeBean.fromJson(res.data);

      verifyImage.value = data.image!;
      verifyCodeKey.value = data.verifyCodeKey!;
    }
    isRequestImageVerifyCode.value = false;
  }

  // 验证邮箱
  bool _validEmailCode() {
    if (userEmail.value.isEmpty) {
      EasyLoading.showToast('邮箱账号不能为空');
      return false;
    }

    if (!RegexUtils.isEmail(userEmail.value)) {
      EasyLoading.showToast('请输入正确的[邮箱账号]');
      return false;
    }

    return true;
  }

  // 获取邮箱验证码
  Future<void> reqEmailCode(Function callback) async {
    if (isRequestEmailCode.value) {
      return;
    }
    if (!_validEmailCode()) {
      return;
    }
    var data = {
      'verifycode_key': verifyCodeKey.value,
      'verifycode': verifyCode.value,
      'email_to_account': userEmail.value,
    };

    EasyLoading.show(indicator: const CommonLoadingView());
    isRequestEmailCode.value = true;
    final res = await LoginApi.reqEmailCode(data, isLogin: false);

    if (res.type == NetworkService.networkTypeSuccess) {
      final resData = res.data;
      if (resData != null && resData['response_code'] == '9999') {
        callback();
        EasyLoading.showSuccess('发送成功');
      }
    }
    isRequestEmailCode.value = false;
    EasyLoading.dismiss();
  }

  // 验证手机
  bool _validPhoneCode() {
    if (userPhone.value.isEmpty) {
      EasyLoading.showToast('手机号不能为空');
      return false;
    }

    if (!RegexUtils.isMobileSimple(userPhone.value)) {
      EasyLoading.showToast('请输入正确的[手机号]');
      return false;
    }

    return true;
  }

  // 获取手机验证码
  Future<void> reqSMSCode(Function callback) async {
    if (isRequestPhoneCode.value) {
      return;
    }

    if (!_validPhoneCode()) {
      return;
    }

    var data = {
      'verifycode_key': verifyCodeKey.value,
      'verifycode': '',
      'country': 'China',
      'receive_mobile': userPhone.value,
      'type': 1,
    };

    EasyLoading.show(indicator: const CommonLoadingView());
    isRequestEmailCode.value = true;
    final res = await LoginApi.reqSMSCode(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      final resData = res.data;
      if (resData != null && resData['response_code'] == '9999') {
        callback();
        EasyLoading.showSuccess('发送成功');
      }
    }
    isRequestEmailCode.value = false;
    EasyLoading.dismiss();
  }

  //是否选中记住密码
  void isCheckRememberPwd(bool? isCheck) {
    isRememberPwd.value = isCheck ?? !isRememberPwd.value;
  }

  //设置用户名
  void setUserName(String str) {
    userName.value = str;
  }

  //设置密码
  void setPwd(String str) {
    userPwd.value = str;
  }

  //设置确认密码
  void setConfirmPwd(String str) {
    userConfirmPwd.value = str;
    loginVerify();
  }

  //设置邮箱
  void setUserEmail(String str) {
    userEmail.value = str;
    loginVerify();
  }

  //设置电话号码
  void setPhone(String str) {
    userPhone.value = str;
  }

  //设置电话号码
  void setDefualtContent(String str) {
    defualtContent.value = str;
  }

  //设置验证码
  void setCode(String str) {
    userCode.value = str;
  }

  //设置图形验证码
  void setImageVerifyCode(String str) {
    verifyCode.value = str;
    loginVerify();
  }

  // 设置选中的国家地区
  void setCountryCode(CountryCode code) {
    countryCode.value = code;
    loginVerify();
  }

  // 设置邀请码
  void setInviteCode(String str) {
    userInviteCode.value = str;
    loginVerify();
  }

  // 设置QQ
  void setQQ(String str) {
    qq.value = str;
    loginVerify();
  }

  // 设置email
  void setEmail(String str) {
    email.value = str;
    loginVerify();
  }

  // 设置whatsApp
  void setWhatsApp(String str) {
    whatsApp.value = str;
    loginVerify();
  }

  // 设置telegram
  void setTelegram(String str) {
    telegram.value = str;
    loginVerify();
  }

  // 设置Facebook
  void setFacebook(String str) {
    facebook.value = str;
    loginVerify();
  }

  // 设置Line
  void setLine(String str) {
    line.value = str;
    loginVerify();
  }

  // 设置Zalo
  void setZalo(String str) {
    zalo.value = str;
    loginVerify();
  }

  // 设置acctPwd
  void setAcctPwd(String str) {
    acctPwd.value = str;
    loginVerify();
  }

  // 设置nickName
  void setNickName(String str) {
    nickName.value = str;
    loginVerify();
  }

  // 设置contactName
  void setContactName(String str) {
    contactName.value = str.trim();
    loginVerify();
  }

  //登录验证
  void loginVerify() {
    isCanRegister.value = _isRegisterValid();
    if (!isCanRegister.value) {
      verifyErrorTips.value = _getVerifyErrorTip();
    } else {
      verifyErrorTips.value = "";
    }
  }

  //验证是否可以进行注册
  bool _isRegisterValid() {
    switch (currentRegisterType.value) {
      case RegisterType.userNameRegisterType:
        return _isUserNameValid() == '';
      case RegisterType.emailRegisterType:
        return _isEmailValid() == '';
      case RegisterType.phoneRegisterType:
        return _isPhoneValid() == '';
    }
  }

  //验证失败的提示信息
  String _getVerifyErrorTip() {
    switch (currentRegisterType.value) {
      case RegisterType.userNameRegisterType:
        return _isUserNameValid();

      case RegisterType.emailRegisterType:
        return _isEmailValid();

      case RegisterType.phoneRegisterType:
        return _isPhoneValid();
    }
  }

  // 获取共用的错误提示
  String _getCommonErrorTips() {
    String errorPwdTips = _getCheckPwdTips();

    if (currentRegisterType.value != RegisterType.phoneRegisterType) {
      if (userPwd.value.isEmpty) return "密码不能为空";
      if (errorPwdTips != '') return errorPwdTips;
    }

    // 真实姓名
    if (hasRealName.value) {
      if (contactName.value.isEmpty && hasRealNameRequire.value) {
        return '请输入会员真实姓名';
      }

      if (contactName.value.isNotEmpty) {
        if (contactName.value.length > 50) {
          return '真实姓名请输入50个以内字符';
        }
        if (RegexUtils.isHasSpace(contactName.value) ||
            contactName.value.trim() == '') {
          return '请输入正确格式真实姓名';
        }
      }
    }

    /// 昵称
    if (hasNickName.value) {
      if (nickName.value.isEmpty && hasNickNameRequire.value) {
        return '请输入昵称';
      }

      if (nickName.value.isNotEmpty) {
        if (nickName.value.length > 32) {
          return '请输入32个以内字符';
        }
        if (RegexUtils.isHasSpace(nickName.value) ||
            nickName.value.trim() == '') {
          return '请输入正确昵称';
        }
      }
    }

    // 重复密码
    if (hasRepassWord.value) {
      if (userConfirmPwd.value.isEmpty) return '请输入确认密码';
      if (userPwd.value != userConfirmPwd.value) return '两次密码输入的不一致';
    }

    // 资金密码
    if (hasAcctPwd.value) {
      if (acctPwd.value.isEmpty && hasAcctPwdRequire.value) {
        return '请输入资金密码';
      }

      if (acctPwd.value.isNotEmpty && !RegexUtils.isSixNumber(acctPwd.value)) {
        return '请输入6位纯数字';
      }
    }

    // Zalo
    if (hasZalo.value) {
      if (zalo.value.isEmpty && hasZaloRequire.value) {
        return '请输入Zalo';
      }

      if (zalo.value.isNotEmpty && !RegexUtils.isZalo(zalo.value)) {
        return '请输入正确的Zalo账号';
      }
    }

    // Line
    if (hasLine.value) {
      if (line.value.isEmpty && hasLineRequire.value) {
        return '请输入Line';
      }

      if (line.value.isNotEmpty && !RegexUtils.isLine(line.value)) {
        return '请输入正确的Line账号';
      }
    }

    // Facebook
    if (hasFacebook.value) {
      if (facebook.value.isEmpty && hasFacebookRequire.value) {
        return '请输入Facebook';
      }

      if (facebook.value.isNotEmpty && !RegexUtils.isFacebook(facebook.value)) {
        return '请输入正确的Facebook账号';
      }
    }

    // Telegram
    if (hasTelegram.value) {
      if (telegram.value.isEmpty && hasTelegramRequire.value) {
        return '请输入Telegram';
      }
      if (telegram.value.isNotEmpty && !RegexUtils.isTelegram(telegram.value)) {
        return '请输入正确的Telegram账号';
      }
    }

    // WhatsApp
    if (hasWhatsApp.value) {
      if (whatsApp.value.isEmpty && hasWhatsAppRequire.value) {
        return '请输入WhatsApp';
      }
      if (whatsApp.value.isNotEmpty && !RegexUtils.isWhatsApp(whatsApp.value)) {
        return '请输入正确的WhatsApp账号';
      }
    }

    // QQ
    if (hasQQ.value) {
      if (qq.value.isEmpty && hasQQRequire.value) {
        return '请输入QQ';
      }
      if (qq.value.isNotEmpty && !RegexUtils.isQQ(qq.value)) {
        return '请输入正确的QQ账号';
      }
    }

    // mobilePhone

    // email
    if (hasEmail.value &&
        currentRegisterType.value != RegisterType.emailRegisterType) {
      if (email.value.isEmpty && hasEmailRequire.value) {
        return '请输入Email';
      }
      if (email.value.isNotEmpty && !RegexUtils.isEmail(email.value)) {
        return '请输入正确的Email';
      }
    }

    // 图形验证码
    if (isShowImageVerifyCode.value) {
      if (verifyCode.value.isEmpty) {
        return '请输入验证码';
      }
    }

    // 邀请码
    if (hasInvite.value) {
      if (userInviteCode.value.isEmpty && hasInviteRequire.value) {
        return '请输入邀请码';
      }
      if (userInviteCode.value.isNotEmpty &&
          RegexUtils.isHasSpace(userInviteCode.value)) {
        return '请输入正确的邀请码';
      }
    }

    return '';
  }

  //用户名密码登录的验证
  String _isUserNameValid() {
    if (userName.value.isEmpty) return "用户名不能为空";
    if (RegexUtils.isHasSpace(userName.value)) return "用户名不能含有空格";

    return _getCommonErrorTips();
  }

  //邮箱+验证码的严重
  String _isEmailValid() {
    if (userEmail.value.isEmpty) return "邮箱不能为空";
    if (!RegexUtils.isEmail(userEmail.value)) return "请输入正确的Email";
    if (userCode.value.isEmpty) return "请输入验证码";

    return _getCommonErrorTips();
  }

  //电话+验证码的验证
  String _isPhoneValid() {
    // if (userName.value.isEmpty) return "用户名不能为空";
    // if (RegexUtils.isHasSpace(userName.value)) return "用户名不能含有空格";

    if (userPhone.value.isEmpty)
      return isNewLogin.value ? "请输入手机号/账号" : "请输入手机号";
    if (!RegexUtils.isMobileSimple(userPhone.value)) return "请输入正确的手机号";
    if (userCode.value.isEmpty) return "请输入验证码";

    return _getCommonErrorTips();
  }

  //是否选中记住密码
  void isCheckAgreeUse(bool? isCheck) {
    isCheckAgree.value = isCheck ?? false;
  }

  //切换登录类型：手机注册、账号注册、邮箱注册
  void changeRegisterType(RegisterType loginType) {
    currentRegisterType.value = loginType;
    clearStatus();
    loginVerify();
  }

  //切换注册方式需要清空状态
  void clearStatus() {
    userName.value = "";
    userPwd.value = "";
    userConfirmPwd.value = "";
    userPhone.value = "";
    userCode.value = "";
    userEmail.value = "";
  }

  String _getCheckPwdTips() {
    // 检查密码是否通过验证
    if (!RegexUtils.checkPwd(userPwd.value, level: int.parse(pwdLevel.value))) {
      switch (pwdLevel.value.toString()) {
        case '1':
          return '密码规则为6-16位数字';
        case '2':
          return '密码规则为6-16位数字+字母';
        case '3':
          return '密码规则为6-16位数字+大小字母';
        case '4':
          return '密码规则为6-16位数字+大小写字母+特殊字符(~@^#-%/.+:;=*)';
        case '5':
          return '密码规则为6-16位的字符';
      }
    }
    return '';
  }

  Future<void> reqRegister() async {
    isCanRegister.value = _isRegisterValid();
    verifyErrorTips.value = _getVerifyErrorTip();
    if (!isCanRegister.value) return;
    FocusScope.of(Get.context!).unfocus();
    if (isAiVerify) {
      if (aiValidate.isEmpty) {
        showCaptcha();
        return;
      }
    }

    if (isCanRegister.value) {
      try {
        switch (currentRegisterType.value) {
          case RegisterType.userNameRegisterType:
            await _performAccountRegister();
            break;

          case RegisterType.emailRegisterType:
            await _performEmailCodeRegister();
            break;

          case RegisterType.phoneRegisterType:
            await _performPhoneCodeRegister();
            break;
        }
      } catch (e) {
        //
      }
    }
  }

  String getPromoteLinkCode() {
    return '';
  }

  Map<String, dynamic> _getCommonParam() {
    String mobilePhone = userPhone.value != ''
        ? "+${countryCode.value.dialCode}-${userPhone.value}"
        : "";
    NetworkService ns = NetworkService();
    return {
      'chan_code': AppConfigs.chanCode,
      'client_id': AppConfigs.clientId,
      'verifycode_key': verifyCodeKey.value,
      'verifycode': verifyCode.value,
      'inviteCode': userInviteCode.value,
      'invite_code': userInviteCode.value, // 邀请码
      'contact_name': contactName.value, // 真实会员名称
      'acct_pwd': acctPwd.value, // 资金密码
      'facebook': facebook.value, // 注册的facebook
      'line': line.value, // line 邮箱
      'qq': qq.value, // qq
      'whatsApp': whatsApp.value,
      'zalo': zalo.value,
      'telegram': telegram.value,
      'mobile_phone': mobilePhone, // 联系电话
      'areaCode': countryCode.value.code, // 国家地区(个人加的)
      'nickname': nickName.value, // 昵称
      'email': email.value, // 注册邮箱
      'link_addr': ns.baseURL,
    };
  }

  // 账号密码注册
  Future<void> _performAccountRegister() async {
    if (isRequestRegister.value) {
      return;
    }
    var data = {
      ..._getCommonParam(),
      'adm_code': '1',
      'cust_name': userName.value, // 会员账号
      'gender': 0,
      'grant_type': 'password',
      'password': getP(userPwd.value),
      'isQp': 1,
      'validate': aiValidate,
      'regist_type': 2,
    };
    data.remove('mobile_phone');
    isRequestRegister.value = true;
    final res = await LoginApi.reqRegister(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      SpUtil.remove("popupLastShownDate"); //注册成功，移除公告弹窗的数据
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveRegisterInfo(loginBean);
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      // //跳转到登录界面
      // Get.snackbar("注册成功!", "已跳转至登录页面");
      clearStatus();
      loginDialogController.changePage(0);
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }
    isRequestRegister.value = false;
  }

  // 手机号注册
  Future<void> _performPhoneCodeRegister() async {
    if (isRequestRegister.value) {
      return;
    }
    var data = {
      ..._getCommonParam(),
      'cust_name': '', // 会员账号
      'phone': userPhone.value,
      'password': '',
      'smsCode': userCode.value,
      'validate': aiValidate,
      'regist_type': 1,
    };

    isRequestRegister.value = true;
    final res = await LoginApi.reqSMSRigister(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      SpUtil.remove("popupLastShownDate"); //注册成功，移除公告弹窗的数据
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveRegisterInfo(loginBean);
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      // //跳转到登录界面
      // Get.snackbar("注册成功!", "已跳转至登录页面");
      clearStatus();
      loginDialogController.changePage(0);
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestRegister.value = false;
  }

  // 邮箱注册
  Future<void> _performEmailCodeRegister() async {
    if (isRequestRegister.value) {
      return;
    }

    var data = {
      ..._getCommonParam(),
      'cust_name': userName.value, // 会员账号
      'email': userEmail.value, // 注册邮箱
      'password': getP(userPwd.value),
      'smsCode': userCode.value, // 邮箱验证码
      'validate': aiValidate,
      'regist_type': 3,
    };
    data.remove('mobile_phone');
    isRequestRegister.value = true;
    final res = await LoginApi.reqEmailRigister(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      SpUtil.remove("popupLastShownDate"); //注册成功，移除公告弹窗的数据
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveRegisterInfo(loginBean);
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      // //跳转到登录界面
      // Get.snackbar("注册成功!", "已跳转至登录页面");
      clearStatus();
      loginDialogController.changePage(0);
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestRegister.value = false;
  }

  void showCaptcha() {
    aiValidate = '';
    isRequestRegister.value = true;

    CaptchaPluginFlutter captchaPlugin = CaptchaPluginFlutter();
    CaptchaPluginConfig styleConfig = CaptchaPluginConfig(
        radius: 10,
        capBarTextColor: "#25D4D0",
        capBarTextSize: 18,
        capBarTextWeight: "bold",
        borderColor: "#25D4D0",
        borderRadius: 10,
        backgroundMoving: "#DC143C",
        executeBorderRadius: 10,
        executeBackground: "#DC143C",
        capBarTextAlign: "center",
        capPaddingTop: 10,
        capPaddingRight: 10,
        capPaddingBottom: 10,
        capPaddingLeft: 10,
        paddingTop: 15,
        paddingBottom: 15);
    captchaPlugin.init({
      "captcha_id": captchaId,
      'is_debug': false,
      'is_show_loading': false,
      "dimAmount": 0.8,
      "is_touch_outside_disappear": true,
      "timeout": 8000,
      "is_hide_close_button": false,
      "use_default_fallback": true,
      "failed_max_retry_count": 4,
      "language_type": "zh-CN",
      "is_close_button_bottom": true,
      "styleConfig": styleConfig.toJson(),
    });

    captchaPlugin.showCaptcha(onLoaded: () {
      // print("================onLoaded==============");
    }, onSuccess: (dynamic data) {
      // print('onSuccess: $data');
      bool result = data['result'] == true || data['result'] == 'true';
      if (result) {
        aiValidate = data['validate'];
        isRequestRegister.value = false;
        reqRegister();
      }
    }, onClose: (dynamic data) {
      // print('onClose: $data');
      isRequestRegister.value = false;
    }, onError: (dynamic data) {
      // print('onError: $data');
      isRequestRegister.value = false;
    });
  }

  RxBool isPwdRegister = true.obs; //是否密码注册，默认为true
  changeLoginTypeStatus(bool isPwd) {
    isPwdRegister.value = isPwd;
    if (isPwd) {
      changeRegisterType(RegisterType.userNameRegisterType);
    } else {
      changeRegisterType(RegisterType.phoneRegisterType);
    }
  }
}
