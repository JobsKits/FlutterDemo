import 'package:flutter_tiyu_app/app/modules/login/controllers/login_dialog_controller.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:country_code_picker/country_code_picker.dart';

import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';

import '../data/contact_config_bean.dart';

class ForgetPasswordController extends GetxController {
  RxString userPwd = "".obs; //密码
  RxString userConfirmPwd = "".obs; //确认密码
  RxString userPhone = "".obs; //手机号
  RxString userCode = "".obs; //验证码

  RxBool isCanForget = false.obs; // 能否忘记密码
  RxBool isLoading = false.obs; // loading
  RxBool isRequestPhoneCode = false.obs; // loading

  RxString verifyErrorTips = "".obs; //校验失败的提示信息
  // ------------
  RxList<CountryCode> countrys = <CountryCode>[].obs;

  Rxn<CountryCode> countryCode = Rxn();
  //---------------

  @override
  void onReady() async {
    // 处理异步请求
    super.onReady();
    await _reqContactInfo();

    forgetVerify(); //因为可能从配置拿数据，所以打开就需要校验一次
    print('ForgetPasswordController onReady');
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
      countryCode.value = defaultCountryCode;
    }
  }

  //设置电话号码
  void setPhone(String str) {
    userPhone.value = str;
    forgetVerify();
  }

  // 设置选中的国家地区
  void setCountryCode(CountryCode code) {
    countryCode.value = code;
    forgetVerify();
  }

  //设置密码
  void setPwd(String str) {
    userPwd.value = str;
    forgetVerify();
  }

  //设置确认密码
  void setConfirmPwd(String str) {
    userConfirmPwd.value = str;
    forgetVerify();
  }

  //设置验证码
  void setCode(String str) {
    userCode.value = str;
    forgetVerify();
  }

  forgetVerify({bool? needTips = false}) {
    String phoneError = _validPhoneCode(needTips: needTips ?? false);
    String pwdError = _validUserPwd(needTips: needTips ?? false);
    String confirmPwdError = _validUserConfirmPwd(needTips: needTips ?? false);
    String codeError = _validuserCode(needTips: needTips ?? false);

    isCanForget.value = phoneError.isEmpty &&
        pwdError.isEmpty &&
        confirmPwdError.isEmpty &&
        codeError.isEmpty;

    if (isCanForget.value) {
      verifyErrorTips.value = '';
    } else {
      if (phoneError.isNotEmpty) {
        verifyErrorTips.value = phoneError;
      } else if (pwdError.isNotEmpty) {
        verifyErrorTips.value = pwdError;
      } else if (confirmPwdError.isNotEmpty) {
        verifyErrorTips.value = confirmPwdError;
      } else if (codeError.isNotEmpty) {
        verifyErrorTips.value = codeError;
      }
    }
  }

  // 验证手机
  String _validPhoneCode({bool needTips = false}) {
    if (userPhone.value.isEmpty) {
      if (needTips) EasyLoading.showToast('手机号不能为空');
      return '手机号不能为空';
    }

    if (!RegexUtils.isMobileSimple(userPhone.value)) {
      if (needTips) EasyLoading.showToast('请输入正确的[手机号]');
      return '请输入正确的[手机号]';
    }

    return '';
  }

  // 验证密码
  String _validUserPwd({bool needTips = false}) {
    if (userPhone.value.isEmpty) {
      if (needTips) EasyLoading.showToast('密码不能为空');
      return '密码不能为空';
    }

    return '';
  }

  // 验证确认密码
  String _validUserConfirmPwd({bool needTips = false}) {
    if (userConfirmPwd.value.isEmpty) {
      if (needTips) EasyLoading.showToast('确认密码不能为空');
      return '请输入确认密码';
    }

    if (userPwd.value != userConfirmPwd.value) {
      if (needTips) EasyLoading.showToast('两次密码输入的不一致');
      return '两次密码输入的不一致';
    }

    return '';
  }

  // 验证验证码
  String _validuserCode({bool needTips = false}) {
    if (userCode.value.isEmpty) {
      if (needTips) EasyLoading.showToast('验证码不能为空');
      return '验证码不能为空';
    }

    return '';
  }

  // 获取手机验证码
  Future<void> reqSMSCode(Function callback) async {
    if (isRequestPhoneCode.value) {
      return;
    }

    if (_validPhoneCode(needTips: true).isNotEmpty) {
      return;
    }

    var data = {
      'verifycode_key': null,
      'verifycode': '',
      'country': 'China',
      'receive_mobile': userPhone.value,
      'type': 2,
    };

    EasyLoading.show(indicator: const CommonLoadingView());
    isRequestPhoneCode.value = true;
    final res = await LoginApi.reqSMSCode(data);

    if (res.type == NetworkService.networkTypeSuccess) {
      final resData = res.data;
      if (resData != null && resData['response_code'] == '9999') {
        callback();
        EasyLoading.showSuccess('发送成功');
      }
    }
    isRequestPhoneCode.value = false;
  }

  Future<void> handleForget() async {
    try {
      isLoading.value = true;

      var data = {
        'phone': userPhone.value.trim(),
        'password': getP(userPwd.value.trim()),
        'smsCode': userCode.value.trim(),
      };

      final res = await LoginApi.reqForgetPassword(data);
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['response_code'] == '9999') {
          EasyLoading.showToast('修改密码成功');
          Get.back();
        } else {
          EasyLoading.showError(res.data['msg'] ?? "操作失败");
        }
        print('===aaa==${res.data}');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
