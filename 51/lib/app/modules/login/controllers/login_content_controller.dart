import 'package:captcha_plugin_flutter/captcha_plugin_flutter.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

import '../../../../utils/tenant_manager.dart';
import '../../home/controllers/new_home_controller.dart';
import '../data/contact_config_bean.dart';

// 登录类型
enum LoginType {
  userNameLoginType, //用户名+密码登录
  emailAndPwdLoginType, // 邮箱+密码登录
  emailAndCodeLoginType, //邮箱+验证码登录
  phoneLoginType, //手机号+code登录
}

typedef LoginModeMapType = Map<LoginType, bool>;

class LoginContentController extends GetxController {
  RxString originUserName = "".obs; // 用户名
  RxString originUserEmail = "".obs; // 邮箱
  RxString originUserPhone = "".obs; // 手机号
  RxString originUserPwd = "".obs; // 密码
  /// --------------------------------------------------
  RxString userName = "".obs; //用户名
  RxString userPhone = "".obs; //手机号
  RxString userCode = "".obs; //手机验证码
  RxString emailCode = "".obs; //邮箱验证码
  RxString userEmail = "".obs; //邮箱
  RxString userPwd = "".obs; //密码
  RxString emailPwd = "".obs; //邮箱密码
  RxString verifyErrorTips = "".obs; //校验失败的提示信息

  /// 图形验证码相关
  /// --------------------------------------------------
  RxString verifyCode = "".obs; //图形验证码Code
  RxString verifyImage = "".obs; // 图形验证码图片
  RxString verifyCodeKey = "".obs; // 图形验证码key
  RxBool isShowImageVerifyCode = false.obs; // 是否显示图形验证码
  /// --------------------------------------------------

  /// 易盾智能验证
  bool isAiVerify = false;
  String captchaId = '';
  String aiValidate = '';

  /// 防重复请求相关
  /// --------------------------------------------------
  RxBool isRequestImageVerifyCode = false.obs; // 是否请求图形验证码
  RxBool isRequestEmailCode = false.obs; // 是否请求邮箱验证码
  RxBool isRequestPhoneCode = false.obs; // 是否请求手机验证码
  RxBool isRequestLogin = false.obs; // 是否登录请求
  /// --------------------------------------------------

  LoginModeMapType loginModeMap = {
    // 模块显示MAP
    LoginType.userNameLoginType: false,
    LoginType.emailAndPwdLoginType: false,
    LoginType.emailAndCodeLoginType: false,
    LoginType.phoneLoginType: false,
  };

  RxBool isCanLogin = false.obs;
  RxBool isRememberPwd = false.obs; //是否记住密码
  late TabsController bottomTabsController;
  late Rx<LoginType> currentLoginType =
      LoginType.userNameLoginType.obs; //当前登录方式
  late NewHomeController homeController;

  RxList<CountryCode> countrys = <CountryCode>[].obs;
  final Map<String, dynamic> _defaultCountryCode = {
    'name': '中国',
    'code': 'CN',
    'dial_code': '+86',
  };
  late Rx<CountryCode> countryCode =
      CountryCode.fromJson(_defaultCountryCode).obs;

  late VoidCallback? callback;

  RxBool isNewLogin = false.obs;

  RxBool isPwdLogin = true.obs; //是否密码登录，默认为true

  @override
  void onInit() async {
    super.onInit();
    bottomTabsController = Get.find<TabsController>();
    homeController = Get.find<NewHomeController>();
    print('LoginContentController onInit');
  }

  @override
  void onReady() async {
    // 处理异步请求
    super.onReady();
    await _initializeLoginInfo();
    await _reqContactInfo();
    // 请求一次图形验证码的
    await reqImageVerifyCode();
    print('LoginContentController onReady');
  }

  // 请求租户注册联系人配置
  Future<void> _reqContactInfo() async {
    final res = await LoginApi.reqContactConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      SysLoginOptionsBean sysLoginOptions =
          ContactConfigBean.fromJson(res.data).sysLoginOptions!;
      _initLoginType(sysLoginOptions);
    }
  }

  // 初始化登录类型
  _initLoginType(SysLoginOptionsBean sysLoginOptions) {
    // 设置图形验证码显示状态
    isShowImageVerifyCode.value =
        sysLoginOptions.CUST_LOGIN_CAPTCHA_MODE!.PICTURE_SWITCH == '1';

    // 是否展示易盾智能验证
    String? smartSwitch = sysLoginOptions.CUST_LOGIN_CAPTCHA_MODE!.SMART_SWITCH;
    String? smartCaptchaMode =
        sysLoginOptions.CUST_LOGIN_CAPTCHA_MODE!.Z2_M_SMART_CAPTCHA_MODE;
    if (smartSwitch == '1' && smartCaptchaMode != '0') {
      String idKey = 'CAPTCHA_ID_${smartCaptchaMode}';
      if (sysLoginOptions.YIDUN_CAPTCHA_ID?[idKey] != null) {
        isAiVerify = true;
        captchaId = (sysLoginOptions.YIDUN_CAPTCHA_ID?[idKey])!;
      }
    }
    bool accountMode = sysLoginOptions.CUST_LOGIN_MODE!.account == '1';
    bool phoneMode = sysLoginOptions.CUST_LOGIN_MODE!.phone_captcha == '1';
    bool newPhoneMode =
        sysLoginOptions.CUST_LOGIN_MODE!.phone_pwd_captcha == '1';
    bool emailMode = sysLoginOptions.CUST_LOGIN_MODE!.email_captcha == '1';
    bool emailPwdMode =
        sysLoginOptions.CUST_LOGIN_MODE!.email_pwd_captcha == '1';

    loginModeMap[LoginType.userNameLoginType] = accountMode;
    loginModeMap[LoginType.phoneLoginType] = phoneMode;
    loginModeMap[LoginType.emailAndCodeLoginType] = emailMode;
    loginModeMap[LoginType.emailAndPwdLoginType] = emailPwdMode;

    if (accountMode) {
      currentLoginType.value = LoginType.userNameLoginType;
    } else if (phoneMode) {
      currentLoginType.value = LoginType.phoneLoginType;
    } else if (newPhoneMode) {
      isNewLogin.value = true;
      if (isNumeric(userName.value) || userName.value == '') {
        currentLoginType.value = LoginType.userNameLoginType;
      }
    } else if (emailMode) {
      currentLoginType.value = LoginType.emailAndCodeLoginType;
    } else if (emailPwdMode) {
      currentLoginType.value =
          LoginType.emailAndPwdLoginType; // 已确认需求，此模式目前不需要考虑
    }

    CountryCode? defaultCountryCode;

    sysLoginOptions.SMS_OPEN_COUNTRY!.forEach((key, value) {
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
    bool isShow =
        TenantManager.instance.tenantBean?.sysOptions?.loginMethodSwitch == "1";
    if (isNewLogin.value) {
      if (!isNumeric(userName.value)) {
        if (!isShow) {
          currentLoginType.value = LoginType.userNameLoginType;
        }
      } else {
        if (!isShow) {
          currentLoginType.value = LoginType.phoneLoginType;
        }
      }
    }
  }

  //初始化登陆信息：从sp拿到本地缓存数据
  Future<void> _initializeLoginInfo() async {
    UserLocalBean? userLocalBean =
        await SpUtil.getBean<UserLocalBean>("userLocalBean", (json) {
      return UserLocalBean.fromJson(json);
    });

    userName.value = userLocalBean?.userInputName ?? "";
    userPhone.value = userLocalBean?.userInputPhone ?? "";
    userEmail.value = userLocalBean?.userInputEmail ?? "";
    userPwd.value = userLocalBean?.userInputPwd ?? "";
    // 原始的保存一份
    originUserName.value = userName.value;
    originUserPhone.value = userPhone.value;
    originUserEmail.value = userEmail.value;
    originUserPwd.value = userPwd.value;
    isRememberPwd.value = userLocalBean?.userIsRememberPwd ?? false;
  }

  // 获取图形验证码
  reqImageVerifyCode() async {
    if (isRequestImageVerifyCode.value) {
      return false;
    }

    isRequestImageVerifyCode.value = true;
    final res = await LoginApi.reqImageVerifyCode(1);

    if (res.type == NetworkService.networkTypeSuccess) {
      final data = ImageVerifyCodeBean.fromJson(res.data);

      verifyImage.value = data.image!;
      verifyCodeKey.value = data.verifyCodeKey!;
    }
    isRequestImageVerifyCode.value = false;
  }

  //设置用户名
  void setUserName(String str) {
    userName.value = str;
  }

  //设置密码
  void setPwd(String str) {
    if (currentLoginType.value == LoginType.userNameLoginType) {
      userPwd.value = str;
    } else {
      emailPwd.value = str;
    }
  }

  //设置邮箱
  void setEmail(String str) {
    userEmail.value = str;
  }

  //设置电话号码
  void setPhone(String str) {
    userPhone.value = str;
  }

  //设置验证码
  void setCode(String str) {
    if (currentLoginType.value == LoginType.phoneLoginType) {
      userCode.value = str;
    } else {
      emailCode.value = str;
    }
  }

  //设置图形验证码
  void setImageVerifyCode(String str) {
    verifyCode.value = str;
  }

  // 设置选中的国家地区
  void setCountryCode(CountryCode code) {
    countryCode.value = code;
  }

  //执行登录
  Future<void> login() async {
    isCanLogin.value = _isLoginValid();
    verifyErrorTips.value = _getVerifyErrorTipAll();
    if (!isCanLogin.value) return;
    FocusScope.of(Get.context!).unfocus();
    if (isAiVerify) {
      if (aiValidate.isEmpty) {
        showCaptcha();
        return;
      }
    }

    if (isCanLogin.value) {
      try {
        /// TODO: 缺失特殊验证逻辑， 以后需要补
        switch (currentLoginType.value) {
          case LoginType.userNameLoginType:
            await _performAccountLogin();
            break;

          case LoginType.emailAndPwdLoginType:
            await _performEmailAndPwdLogin();
            break;

          case LoginType.emailAndCodeLoginType:
            await _performEmailAndCodeLogin();
            break;

          case LoginType.phoneLoginType:
            await _performPhoneAndCodeLogin();
            break;
        }
      } catch (e) {
        e.printError();
        bottomTabsController.stopPollingMsg();
        Get.snackbar("登录失败", "请检查用户名、密码是否正确",
            snackPosition: SnackPosition.TOP, backgroundColor: Colors.white);
        EasyLoading.dismiss();
      }
    }
  }

  //进行账号登录的网络请求
  Future<void> _performAccountLogin() async {
    if (isRequestLogin.value) {
      return;
    }
    var data = {
      'cust_name': userName.value,
      'password': getP(userPwd.value.trim()),
      // 'verifycode_key': verifyCodeKey.value,
      // 'verifycode': verifyCode.value,
      'validate': aiValidate,
    };

    isRequestLogin.value = true;
    final res = await LoginApi.reqAccountLogin(data);
    if (res.type == NetworkService.networkTypeSuccess) {
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveLoginInfo(loginBean);
      bottomTabsController.startPollingMsg();
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestLogin.value = false;
  }

  //进行邮箱+code登录的网络请求
  Future<void> _performEmailAndCodeLogin() async {
    if (isRequestLogin.value) {
      return;
    }
    var data = {
      'cust_name': userEmail.value.trim(),
      'smsCode': emailCode.value.trim(),
      'verifycode_key': verifyCodeKey.value,
      'verifycode': verifyCode.value,
      'password': '',
      'validate': aiValidate,
    };

    isRequestLogin.value = true;
    final res = await LoginApi.reqEmaillogin(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveLoginInfo(loginBean);
      bottomTabsController.startPollingMsg();
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestLogin.value = false;
  }

  //进行邮箱+密码登录的网络请求
  Future<void> _performEmailAndPwdLogin() async {
    if (isRequestLogin.value) {
      return;
    }
    var data = {
      'cust_name': userEmail.value.trim(),
      'verifycode_key': verifyCodeKey.value,
      'verifycode': verifyCode.value,
      'password': getP(userPwd.value.trim()),
      'validate': aiValidate,
    };

    isRequestLogin.value = true;
    final res = await LoginApi.reqEmailPwdlogin(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveLoginInfo(loginBean);
      bottomTabsController.startPollingMsg();
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestLogin.value = false;
  }

  //进行手机+验证码登录的网络请求
  Future<void> _performPhoneAndCodeLogin() async {
    if (isRequestLogin.value) {
      return;
    }
    var data = {
      'receiveMobile': userPhone.value.trim(),
      'cust_name': userPhone.value.trim(),
      'smsCode': userCode.value,
      'verifycode_key': verifyCodeKey.value,
      'verifycode': verifyCode.value,
      'areaCode': countryCode.value.dialCode, // 国家地区(个人加的)
      'password': '',
      'validate': aiValidate,
    };

    isRequestLogin.value = true;
    final res = await LoginApi.reqSMSlogin(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      LoginBean loginBean = LoginBean.fromJson(res.data);
      _saveLoginInfo(loginBean);
      bottomTabsController.startPollingMsg();
      Get.back();
      LoginManager.instance.isLoginDialogShowing = false;
      if (callback != null) callback!();
    } else {
      aiValidate = '';
      reqImageVerifyCode();
    }

    isRequestLogin.value = false;
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
    final res = await LoginApi.reqEmailCode(data);

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
      'type': 2,
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

  //保存用户信息，内存、本地各一份
  void _saveLoginInfo(LoginBean loginBean) async {
    LoginManager.instance.setLoginBean(loginBean); //保存一份到内存中
    SystemApi.updatePushInfo();
    UserLocalBean userLocalBean = UserLocalBean.fromJson({
      "userInputName": userName.value,
      "userInputPhone": userPhone.value,
      "userInputEmail": userEmail.value,
      "userIsRememberPwd": isRememberPwd.value,
      "userInputPwd": isRememberPwd.value ? userPwd.value : "",
    });

    await SpUtil.saveBean<LoginBean>(
        "loginBean", loginBean); //把保存了接口用户信息和记住密码状态、密码的用户信息对象，进行本地保存

    // 非手机模式需要存储 邮箱或者账号
    if (currentLoginType.value != LoginType.phoneLoginType) {
      // 单独存储用户名/密码等信息，退出时不需要清理
      await SpUtil.saveBean<UserLocalBean>("userLocalBean", userLocalBean);
    }
  }

  //登录验证
  void loginVerify() {
    verifyErrorTips.value = _getVerifyErrorTip();
  }

  //验证是否可以进行登录
  bool _isLoginValid() {
    switch (currentLoginType.value) {
      case LoginType.userNameLoginType:
        return _isUserNameAndPwdValid() && _isImageVerifyCodeValid();
      case LoginType.emailAndPwdLoginType:
        return _isEmailAndPwdValid() && _isImageVerifyCodeValid();
      case LoginType.emailAndCodeLoginType:
        return _isEmailAndCodeValid() && _isImageVerifyCodeValid();
      case LoginType.phoneLoginType:
        return _isPhoneAndCodeValid() && _isImageVerifyCodeValid();
    }
  }

  //验证失败的提示信息
  String _getVerifyErrorTip() {
    print("监听一下：${currentLoginType}");
    switch (currentLoginType.value) {
      case LoginType.userNameLoginType:
        if (userPwd.value.isEmpty) return "";
        if (userPwd.value.length < 6) return "密码不能少于6位";
        break;

      case LoginType.emailAndPwdLoginType:
        if (userEmail.value.isEmpty) return "";
        if (!RegexUtils.isEmail(userEmail.value)) return "请输入正确的邮箱";
        if (emailPwd.value.isEmpty) return "";
        if (emailPwd.value.length < 6) return "密码不能少于6位";
        break;

      case LoginType.emailAndCodeLoginType:
        if (userEmail.value.isEmpty) return "";
        if (!RegexUtils.isEmail(userEmail.value)) return "请输入正确的邮箱";
        break;

      case LoginType.phoneLoginType:
        if (userPhone.value.isEmpty) return "";
        if (!RegexUtils.isMobileSimple(userPhone.value)) return "请输入正确的手机号";
        break;
    }

    if (isShowImageVerifyCode.value && verifyCode.value.isEmpty) {
      return '请输入验证码';
    }
    return "";
  }

  //验证失败的提示信息 - 对所有数据进行校验，用来在点击登录的时候判断
  String _getVerifyErrorTipAll() {
    switch (currentLoginType.value) {
      case LoginType.userNameLoginType:
        if (userName.value.isEmpty) return "用户名不能为空";
        if (userPwd.value.isEmpty) return "密码不能为空";
        if (userPwd.value.length < 6) return "密码不能少于6位";
        break;

      case LoginType.emailAndPwdLoginType:
        if (userEmail.value.isEmpty) return "邮箱不能为空";
        if (!RegexUtils.isEmail(userEmail.value)) return "请输入正确的邮箱";
        if (emailPwd.value.isEmpty) return "密码不能为空";
        if (emailPwd.value.length < 6) return "密码不能少于6位";
        break;

      case LoginType.emailAndCodeLoginType:
        if (userEmail.value.isEmpty) return "邮箱不能为空";
        if (!RegexUtils.isEmail(userEmail.value)) return "请输入正确的邮箱";
        if (emailCode.value.isEmpty) return "验证码不能为空";
        break;

      case LoginType.phoneLoginType:
        if (userPhone.value.isEmpty) return "手机号不能为空";
        if (!RegexUtils.isMobileSimple(userPhone.value)) return "请输入正确的手机号";
        if (userCode.value.isEmpty) return "验证码不能为空";
        break;
    }

    if (isShowImageVerifyCode.value && verifyCode.value.isEmpty) {
      return '请输入验证码';
    }
    return "";
  }

  // 校验图形验证码
  bool _isImageVerifyCodeValid() {
    return isShowImageVerifyCode.value ? verifyCode.value.isNotEmpty : true;
  }

  //用户名密码登录的验证
  bool _isUserNameAndPwdValid() {
    return userName.value.isNotEmpty &&
        userPwd.value.isNotEmpty &&
        userPwd.value.length > 5;
  }

  //邮箱+验证码的验证
  bool _isEmailAndCodeValid() {
    return userEmail.value.isNotEmpty && emailCode.value.isNotEmpty;
  }

  //邮箱+密码的验证
  bool _isEmailAndPwdValid() {
    return userEmail.value.isNotEmpty &&
        emailPwd.value.isNotEmpty &&
        emailPwd.value.length > 5;
  }

  //电话+验证码的验证
  bool _isPhoneAndCodeValid() {
    return userPhone.value.isNotEmpty &&
        RegexUtils.isMobileSimple(userPhone.value) &&
        userCode.value.isNotEmpty;
  }

  //是否选中记住密码
  void isCheckRememberPwd(bool? isCheck) {
    isRememberPwd.value = isCheck ?? !isRememberPwd.value;
  }

  //切换登录类型：手机登录、账号登录、邮箱登录
  void changeLoginType(LoginType loginType) {
    currentLoginType.value = loginType;
    // 切换后清除密码和验证码
    bool isShow =
        TenantManager.instance.tenantBean?.sysOptions?.loginMethodSwitch == "1";
    if (loginType == LoginType.phoneLoginType && isShow) {
      //如果切换到手机了
      if (isNumeric(userName.value)) {
        setPhone(userName.value);
      }
    }
    if (!isShow) {
      userPwd.value = '';
    }
    userCode.value = '';
  }

  void showCaptcha() {
    aiValidate = '';
    isRequestLogin.value = true;

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
      "loading_text": '',
    });

    captchaPlugin.showCaptcha(onLoaded: () {
      // print("================onLoaded==============");
    }, onSuccess: (dynamic data) {
      // print('onSuccess: $data');
      bool result = data['result'] == true || data['result'] == 'true';
      if (result) {
        aiValidate = data['validate'];
        isRequestLogin.value = false;
        login();
      }
    }, onClose: (dynamic data) {
      // print('onClose: $data');
      isRequestLogin.value = false;
    }, onError: (dynamic data) {
      // print('onError: $data');
      isRequestLogin.value = false;
    });
  }

  bool isNumeric(String text) {
    final RegExp numericRegExp = RegExp(r'^[0-9]{6,}$');
    return numericRegExp.hasMatch(text);
  }

  changeLoginTypeStatus(bool isPwd) {
    isPwdLogin.value = isPwd;
    if (isPwd) {
      changeLoginType(LoginType.userNameLoginType);
    } else {
      changeLoginType(LoginType.phoneLoginType);
    }
  }
}
