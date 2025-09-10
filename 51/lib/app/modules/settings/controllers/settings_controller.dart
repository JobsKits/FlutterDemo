import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_tiyu_app/app/modules/user/widget/change_language_widget.dart';
import 'package:flutter_tiyu_app/app/modules/webview/widget/common_dialog.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../views/settings_withdrawal_pwd_dialog.dart';
// import 'package:flutter/material.dart';

class SettingBean {
  final String title;
  final SettingEnum key;

  SettingBean({required this.title, required this.key});
}

enum SettingEnum {
  userInfo, // 个人信息
  loginPwd, // 登录密码
  paymentPwd, // 支付密码
  language, // 系统语言
  clearCache, // 清理缓存
}

class SettingsController extends GetxController {
  List<SettingBean> settingList = [
    SettingBean(title: '个人信息', key: SettingEnum.userInfo),
    SettingBean(title: '登录密码', key: SettingEnum.loginPwd),
    SettingBean(title: '支付密码', key: SettingEnum.paymentPwd),
    SettingBean(title: '语言', key: SettingEnum.language),
    SettingBean(title: '清除缓存', key: SettingEnum.clearCache),
  ];

  RxBool isShowPasswordDialog = false.obs;

  final GlobalKey loginPwdformKey = GlobalKey();
  final RxString oldPassword = ''.obs;
  final RxString newPassword = ''.obs;
  final RxString confirmPassword = ''.obs;
  RxString cacheSize = "".obs;

  @override
  void onInit() {
    _calculateCacheSize();
    super.onInit();
  }

  // 获取缓存目录并计算缓存大小
  Future<void> _calculateCacheSize() async {
    int totalSize = 0;

    // 获取缓存目录路径
    final Directory tempDir = await getTemporaryDirectory();
    final String cacheDirPath = '${tempDir.path}/libCachedImageData';
    final Directory cacheDir = Directory(cacheDirPath);

    // 检查目录是否存在，遍历文件并累加大小
    if (await cacheDir.exists()) {
      for (var file in cacheDir.listSync()) {
        if (file is File) {
          totalSize += await file.length();
        }
      }
    }
    if ((totalSize / (1024 * 1024)) > 0) {
      cacheSize.value = "${(totalSize / (1024 * 1024)).truncateToFixed(2)} MB";
    } else {
      cacheSize.value = "";
    }
  }

  // 手动清除缓存
  Future<void> _clearCache() async {
    final cacheManager = DefaultCacheManager();
    await cacheManager.emptyCache(); // 清除所有缓存
    PaintingBinding.instance.imageCache.clear();

    final Directory tempDir = await getTemporaryDirectory();
    final String cacheDirPath = '${tempDir.path}/libCachedImageData';
    final Directory cacheDir = Directory(cacheDirPath);
    // 如果目录存在，则删除目录及其内容
    if (await cacheDir.exists()) {
      await cacheDir.delete(recursive: true);
    }
    SpUtil.remove("homeBean"); //首页缓存
    SpUtil.remove("electronicGameBean"); //电子缓存
    SpUtil.remove("chessGameBean"); //棋牌缓存
    SpUtil.remove("fishingGameBean"); //捕鱼缓存
    // 重新计算缓存大小
    await _calculateCacheSize();
  }

  /// 点击每一项
  onClickItem(SettingBean settingItem) {
    switch (settingItem.key) {
      case SettingEnum.userInfo:
        // print('=====xxx> ${showLoginPwdDialog}');
        // showLoginPwdDialog!();
        Get.toNamed(Routes.USER_INFO, arguments: {"isShowSendCode": true});
        break;
      case SettingEnum.loginPwd:
        // Get.dialog(const ResetLoginPwdDialog(), barrierDismissible: false);
        Get.toNamed(Routes.EDIT_PASSWORD, arguments: {"isLoginPwd": true});
        break;
      case SettingEnum.paymentPwd:
        Get.dialog(SettingsWithdrawalPwdDialog());
        // Get.toNamed(Routes.EDIT_PASSWORD, arguments: {"isLoginPwd": false});
        break;
      // Get.dialog(
      //     const ResetLoginPwdDialog(
      //       isLoginType: false,
      //     ),
      //     barrierDismissible: false);
      // Get.dialog(const ResetPayPwdDialog(), barrierDismissible: false);
      case SettingEnum.language:
        Get.bottomSheet(const ChangeLanguageWidget(), isScrollControlled: true);
        break;
      case SettingEnum.clearCache:
        Get.dialog(CommonDialog(
          title: "确定要清理缓存吗？",
          clickOk: () {
            AppManager.instance.tapVibrate();
            Get.back();
            _clearCache();
          },
        ));
        break;
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
