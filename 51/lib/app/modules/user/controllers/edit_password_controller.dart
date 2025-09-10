import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/widget/common_loading_view.dart';
import 'package:flutter_tiyu_app/utils/regex_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';

import 'package:flutter_tiyu_app/app/modules/login/data/contact_config_bean.dart';

class EditPasswordController extends GetxController {
  RxString pwdLevel = '1'.obs; // 密码等级
  RxString title = ''.obs; // 标题
  RxBool isLoginPwd = true.obs; // 是否为修改登录密码

  RxString oldPwd = "".obs; // 旧密码
  RxString userPwd = "".obs; //密码
  RxString userConfirmPwd = "".obs; //确认密码

  RxString verifyErrorTips = "".obs; // 错误提示

  RxBool isLoading = false.obs;
  RxBool hasPwd = false.obs; //旧密码是否为空；默认false
  @override
  void onInit() async {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    isLoginPwd.value = arguments['isLoginPwd'] == true;

    doVerify();
    EasyLoading.show(indicator: CommonLoadingView());
    await _reqContactInfo();
    hasPwd.value =
        await UserApi().checkPwdStatus(isLoginPwd.value == true ? 1 : 2);
    title.value = arguments['isLoginPwd'] == true
        ? (hasPwd.value ? '登录密码修改' : '登录密码设置')
        : (hasPwd.value ? '支付密码修改' : '支付密码设置');
    EasyLoading.dismiss();
  }

  // 请求租户注册联系人配置
  Future<void> _reqContactInfo() async {
    final res = await LoginApi.reqContactConfig();

    if (res.type == NetworkService.networkTypeSuccess) {
      SysRegisterOptionsBean sysOptions =
          ContactConfigBean.fromJson(res.data).sysOptions!;

      pwdLevel.value =
          sysOptions.CUST_REGISTER_PASSWORD_MODE!.PASSWORD_MODE ?? '1';

      verifyErrorTips.value =
          isLoginPwd.value ? _getErrorTips() : '支付密码需由6位纯数字组成';
    }
  }

  //设置密码
  void setOldPwd(String str) {
    oldPwd.value = str;
    doVerify();
  }

  //设置密码
  void setUserPwd(String str) {
    userPwd.value = str;
    doVerify();
  }

  //设置确认密码
  void setConfirmPwd(String str) {
    userConfirmPwd.value = str;
    doVerify();
  }

  // 验证旧密码
  String _validOldPwd({bool needTips = false}) {
    if (oldPwd.value.isEmpty) {
      if (needTips) EasyLoading.showToast('请输入原密码');
      return '请输入原密码';
    }

    return '';
  }

  // 验证密码
  String _validUserPwd({bool needTips = false}) {
    // 登录密码模式
    if (isLoginPwd.value) {
      String errorPwdTips = _getCheckPwdTips();
      if (userPwd.value.isEmpty) {
        if (needTips) EasyLoading.showToast('请输入新密码');
        return '请输入新密码';
      }

      if (errorPwdTips.isNotEmpty) {
        if (needTips) EasyLoading.showToast(errorPwdTips);
        return errorPwdTips;
      }
    } else {
      if (userPwd.value.isEmpty && !RegexUtils.isSixNumber(userPwd.value)) {
        if (needTips) EasyLoading.showToast('支付密码需由6位纯数字组成');
        return '支付密码需由6位纯数字组成';
      }
    }

    return '';
  }

  // 验证确认密码
  String _validUserConfirmPwd({bool needTips = false}) {
    if (userConfirmPwd.value.isEmpty) {
      if (needTips) EasyLoading.showToast('请输入确认密码');
      return '请输入确认密码';
    }

    if (userPwd.value != userConfirmPwd.value) {
      if (needTips) EasyLoading.showToast('两次密码输入的不一致');
      return '两次密码输入的不一致';
    }

    return '';
  }

  // 验证
  bool doVerify({bool? needTips = false}) {
    String oldPwdError = "";
    if (hasPwd.value) {
      oldPwdError = _validOldPwd();
    }
    String userPwdError = _validUserPwd();
    String confirmPwdError = _validUserConfirmPwd();

    // 通过验证
    bool verifyed =
        oldPwdError.isEmpty && userPwdError.isEmpty && confirmPwdError.isEmpty;

    // if (verifyed) {
    //   verifyErrorTips.value = '';
    // } else {
    //   if (oldPwdError.isNotEmpty) {
    //     verifyErrorTips.value = oldPwdError;
    //   } else if (userPwdError.isNotEmpty) {
    //     verifyErrorTips.value = userPwdError;
    //   } else if (confirmPwdError.isNotEmpty) {
    //     verifyErrorTips.value = confirmPwdError;
    //   }
    // }
    /// 未通过验证
    if (!verifyed && needTips == true) {
      if (oldPwdError.isNotEmpty && hasPwd.value) {
        EasyLoading.showToast(oldPwdError);
      } else if (userPwdError.isNotEmpty) {
        EasyLoading.showToast(userPwdError);
      } else if (confirmPwdError.isNotEmpty) {
        EasyLoading.showToast(confirmPwdError);
      }
    }

    return verifyed;
  }

  String _getErrorTips() {
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
      default:
        return '';
    }
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

  // 点击提交
  handleSubmit() async {
    if (!doVerify(needTips: true)) {
      return;
    }

    try {
      isLoading.value = true;

      bool isSuccess = false;
      if (isLoginPwd.value) {
        var data = {
          'password': getP(userPwd.value),
          'ori_password': hasPwd.value ? getP(oldPwd.value) : "",
          'ori_value': getP(oldPwd.value),
          'new_value': getP(userPwd.value),
          'trans_type': 103,
          'busi_type': 211,
          'oper_method': hasPwd.value ? 2 : 1,
        };
        isSuccess = await UserApi().newChangeLoginPwd(data);
      } else {
        var data = {
          'ispwd': hasPwd.value ? "" : 1,
          'acct_pwd': getP(userPwd.value),
          'ori_acct_pwd': hasPwd.value ? getP(oldPwd.value) : "",
          'ori_value': getP(oldPwd.value),
          'new_value': getP(userPwd.value),
          'trans_type': 103,
          'busi_type': 213,
          'oper_method': hasPwd.value ? 2 : 1,
        };
        isSuccess = await UserApi().changePayPwd(data);
      }

      if (isSuccess) {
        Get.back();
        if (hasPwd.value) {
          Get.snackbar("修改成功!", "");
        } else {
          Get.snackbar("设置成功!", "");
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
