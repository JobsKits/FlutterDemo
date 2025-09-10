import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/night_login_dialog.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/login_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/forget_password_dialog.dart';

import '../theme/theme.service.dart';

/// // 得到当前租户 如：17-6
String getCurrentTenant() {
  int clustersId = TenantManager.instance.tenantBean!.clustersId;
  int tid = TenantManager.instance.tenantBean!.tid;
  return '$clustersId-$tid';
}

// 判断当前租户是否为传入租户 如：17-6
isSpecialTenant({required int clustersId, required int tid}) {
  return '$clustersId-$tid' == getCurrentTenant();
}

/// 打开登录弹窗
void showLoginDialog({VoidCallback? callback}) {
  print("这里吗");
  if (LoginManager.instance.isLoginDialogShowing) {
    return;
  }
  print("这里吗2");
  LoginManager.instance.isLoginDialogShowing = true;
  if (ThemeService.to.currentTheme.value?.model == "blackGold") {
    Get.dialog(
      NightLoginDialog(
        isShowLogin: true,
        callback: callback,
      ),
      barrierDismissible: false,
    );
  } else {
    Get.dialog(
      LoginDialog(
        isShowLogin: true,
        callback: callback,
      ),
      barrierDismissible: false,
    );
  }
}

/// 打开注册弹窗
void showRegisterDialog() {
  if (ThemeService.to.currentTheme.value?.model == "blackGold") {
    Get.dialog(
      const NightLoginDialog(
        isShowLogin: false,
      ),
      barrierDismissible: false,
    );
  } else {
    Get.dialog(
      const LoginDialog(
        isShowLogin: false,
      ),
      barrierDismissible: false,
    );
  }
}

/// 打开忘记密码弹窗
void showForgetPasswordDialog() {
  Get.dialog(
    const ForgetPasswordDialog(),
    barrierDismissible: false,
  );
}

/// 卡号脱敏
String maskCardNumber(String cardNumber, {int minVisibleLength = 4}) {
  // 将卡号转为字符串
  cardNumber = cardNumber.toString();

  // 如果卡号长度小于 minVisibleLength，返回原卡号
  if (cardNumber.length < minVisibleLength) {
    return cardNumber;
  }

  if (cardNumber.length < 8) {
    // 取前2位和后2位
    String visibleStart = cardNumber.substring(0, 2);
    String visibleEnd = cardNumber.substring(cardNumber.length - 2);

    // 返回处理后的卡号
    return '$visibleStart******$visibleEnd';
  }

  // 取前2位和后4位
  String visibleStart = cardNumber.substring(0, 2);
  String visibleEnd = cardNumber.substring(cardNumber.length - 4);
  return '$visibleStart******$visibleEnd';
}

// 解析数字数据
String parseNumber(num? value) {
  if (value == null) {
    return '';
  }
  return value == value.toInt() ? value.toInt().toString() : value.toString();
}

// 解析数字数据
String parseNumber2(num? value) {
  if (value == null) {
    return '';
  }
  var num =
      value == value.toInt() ? value.toInt().toString() : value.toString();
  return num == "0" ? "-" : num;
}

// 计算table高度
double calcTableHeight({
  required int dataLength,
  required int pageSize,
}) {
  // 大于10条
  if (dataLength > pageSize) {
    return 150.h * pageSize;
  }

  // 等于10条 以及 小于10条
  return dataLength == pageSize ? 150.h * pageSize - 100.h : 150.h * dataLength;
}
