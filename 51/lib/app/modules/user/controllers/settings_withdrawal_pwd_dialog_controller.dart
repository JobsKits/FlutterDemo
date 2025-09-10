import 'package:flutter/cupertino.dart';
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

class SettingsWithdrawalPwdDialogController extends GetxController {
  RxString oldPwd = "".obs; // 旧密码
  RxString oldStylePwd = "".obs; // 旧风格密码
  RxString userPwd = "".obs; //密码
  RxString userConfirmPwd = "".obs; //确认密码

  RxString verifyErrorTips = "".obs; // 错误提示

  RxBool isLoading = false.obs;
  RxBool hasPwd = false.obs; //旧密码是否为空；默认false

  RxBool oldPwdIsShow = true.obs; // 之前的密码是否明文展示
  RxBool currentPwdIsShow = true.obs; // 当前密码是否明文展示
  RxBool confirmPwdIsShow = true.obs; // 确认密码是否明文展示

  RxBool isShowOldPwdTips = false.obs;
  RxString oldPwdTips = "".obs;
  RxString userPwdTips = "".obs;
  RxString confirmPwdTips = "".obs;
  RxBool isShowOldStylePwd = false.obs;

  @override
  void onInit() async {
    super.onInit();

    doVerify();
    hasPwd.value = await UserApi().checkPwdStatus(2);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //设置密码
  void setOldPwd(String str) {
    oldPwd.value = str;
    doVerify();
  }

  //设置密码
  void setOldStylePwd(String str) {
    oldStylePwd.value = str;
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
  String validOldPwd({bool needTips = false}) {
    if (oldPwd.value.isEmpty) {
      if (needTips) EasyLoading.showToast('请输入原密码');
      return '请输入原密码';
    }
    if (oldPwd.value.length < 6) {
      if (needTips) EasyLoading.showToast('密码不能少于6位');
      return '密码不能少于6位';
    }
    return '';
  }

  String _validOldStylePwd({bool needTips = false}) {
    if (oldStylePwd.value.isEmpty) {
      if (needTips) EasyLoading.showToast('请输入原密码');
      return '请输入原密码';
    }

    return '';
  }

  // 验证密码
  String validUserPwd({bool needTips = false}) {
    if (userPwd.value.isEmpty || !RegexUtils.isSixNumber(userPwd.value)) {
      if (needTips) EasyLoading.showToast('支付密码需由6位纯数字组成');
      return '支付密码需由6位纯数字组成';
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
    if (hasPwd.value) {
      oldPwdTips.value =
          isShowOldStylePwd.value ? _validOldStylePwd() : validOldPwd();
    }
    userPwdTips.value = validUserPwd();
    confirmPwdTips.value = _validUserConfirmPwd();

    // 通过验证
    bool verifyed = oldPwdTips.value.isEmpty &&
        userPwdTips.value.isEmpty &&
        confirmPwdTips.value.isEmpty;

    /// 未通过验证
    if (!verifyed && needTips == true) {
      if (oldPwdTips.value.isNotEmpty && hasPwd.value) {
        EasyLoading.showToast(oldPwdTips.value);
      } else if (userPwdTips.value.isNotEmpty) {
        EasyLoading.showToast(userPwdTips.value);
      } else if (confirmPwdTips.value.isNotEmpty) {
        EasyLoading.showToast(confirmPwdTips.value);
      }
    }

    return verifyed;
  }

  // 点击提交
  handleSubmit() async {
    if (!doVerify(needTips: true)) {
      return;
    }

    try {
      isLoading.value = true;
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
      bool isSuccess = await UserApi().changePayPwd(data);

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
