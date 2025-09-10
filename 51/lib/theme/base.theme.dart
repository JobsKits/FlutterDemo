import 'dart:ui';

import 'package:flutter_tiyu_app/extensions/AnyExtensions/onString.dart';

class BaseTheme {
  static Color get primaryDark => '#10C8E3'.color();
  static Color get primaryLight => '#10C8E3'.color();
  static Color get primaryBlueDark => '#10C8E3'.color();
  static Color get primaryBlueLight => '#10C8E3'.color();
  static Color get primaryGold3Dark => '#C69108'.color();
  static Color get primaryGold3Light => '#C69108'.color();
  static Color get primaryBlackGoldDark => '#FFD69F'.color();
  static Color get primaryBlackGoldLight => '#FFD69F'.color();

  /// 主题色
  static Color get notifyDark => '#D9001C'.color();
  static Color get notifyLight => '#D9001C'.color();
  static Color get notifyBlueDark => '#D9001C'.color();
  static Color get notifyBlueLight => '#D9001C'.color();
  static Color get notifyGold3Dark => '#DC143C'.color();
  static Color get notifyGold3Light => '#DC143C'.color();
  static Color get notifyBlackGoldDark => '#DC143C'.color();
  static Color get notifyBlackGoldLight => '#DC143C'.color();

  /// 通知小红点颜色
  static Color get appbarTextDark => '#ffffff'.color();
  static Color get appbarTextLight => '#ffffff'.color();
  static Color get appbarTextBlueDark => '#ffffff'.color();
  static Color get appbarTextBlueLight => '#ffffff'.color();
  static Color get appbarTextGold3Dark => '#DC143C'.color();
  static Color get appbarTextGold3Light => '#DC143C'.color();
  static Color get appbarTextBlackGoldDark => '#E6E7EC'.color();
  static Color get appbarTextBlackGoldLight => '#E6E7EC'.color();

  /// 导航栏文字颜色
  static Color get navbarBgDark => '#ffffff'.color();
  static Color get navbarBgLight => '#ffffff'.color();
  static Color get navbarBgBlueDark => '#ffffff'.color();
  static Color get navbarBgBlueLight => '#ffffff'.color();
  static Color get navbarBgGold3Dark => '#ffffff'.color();
  static Color get navbarBgGold3Light => '#ffffff'.color();
  static Color get navbarBgBlackGoldDark => '#1D202D'.color();
  static Color get navbarBgBlackGoldLight => '#1D202D'.color();

  /// 底部导航栏背景色
  static Color get pageBgDark => '#F4F4F4'.color();
  static Color get pageBgLight => '#F4F4F4'.color();
  static Color get pageBgBlueDark => '#F4F4F4'.color();
  static Color get pageBgBlueLight => '#F4F4F4'.color();
  static Color get pageBgGold3Dark => '#F4F4F4'.color();
  static Color get pageBgGold3Light => '#F4F4F4'.color();
  static Color get pageBgBlackGoldDark => '#181A24'.color();
  static Color get pageBgBlackGoldLight => '#181A24'.color();

  /// 底部导航栏背景色
  static Color get pageTwoBgDark => '#ffffff'.color();
  static Color get pageTwoBgLight => '#ffffff'.color();
  static Color get pageTwoBgBlueDark => '#ffffff'.color();
  static Color get pageTwoBgBlueLight => '#ffffff'.color();
  static Color get pageTwoBgGold3Dark => '#ffffff'.color();
  static Color get pageTwoBgGold3Light => '#ffffff'.color();
  static Color get pageTwoBgBlackGoldDark => '#262836'.color();
  static Color get pageTwoBgBlackGoldLight => '#262836'.color();

  /// 底部导航栏背景色
  static Color get pageThreeBgDark => '#ffffff'.color();
  static Color get pageThreeBgLight => '#ffffff'.color();
  static Color get pageThreeBgBlueDark => '#ffffff'.color();
  static Color get pageThreeBgBlueLight => '#ffffff'.color();
  static Color get pageThreeBgGold3Dark => '#ffffff'.color();
  static Color get pageThreeBgGold3Light => '#ffffff'.color();
  static Color get pageThreeBgBlackGoldDark => '#252837'.color();
  static Color get pageThreeBgBlackGoldLight => '#252837'.color();

  /// 公告弹窗三级背景色
  static Color get titleColorDark => '#000000'.color();
  static Color get titleColorLight => '#000000'.color();
  static Color get titleColorBlueDark => '#000000'.color();
  static Color get titleColorBlueLight => '#000000'.color();
  static Color get titleColorGold3Dark => '#000000'.color();
  static Color get titleColorGold3Light => '#000000'.color();
  static Color get titleColorBlackGoldDark => '#E7E8F4'.color();
  static Color get titleColorBlackGoldLight => '#E7E8F4'.color();

  /// 亮字色
  static Color get title2ColorDark => '#787878'.color();
  static Color get title2ColorLight => '#787878'.color();
  static Color get title2ColorBlueDark => '#787878'.color();
  static Color get title2ColorBlueLight => '#787878'.color();
  static Color get title2ColorGold3Dark => '#787878'.color();
  static Color get title2ColorGold3Light => '#787878'.color();
  static Color get title2ColorBlackGoldDark => '#6A6C80'.color();
  static Color get title2ColorBlackGoldLight => '#6A6C80'.color();

  /// 浅字色
  static Color get title3ColorDark => '#787878'.color();
  static Color get title3ColorLight => '#787878'.color();
  static Color get title3ColorBlueDark => '#787878'.color();
  static Color get title3ColorBlueLight => '#787878'.color();
  static Color get title3ColorGold3Dark => '#787878'.color();
  static Color get title3ColorGold3Light => '#787878'.color();
  static Color get title3ColorBlackGoldDark => '#AFB3CA'.color();
  static Color get title3ColorBlackGoldLight => '#AFB3CA'.color();

  /// 中字色
  static Color get msTextColorDark => '#ffffff'.color();
  static Color get msTextColorLight => '#ffffff'.color();
  static Color get msTextColorBlueDark => '#ffffff'.color();
  static Color get msTextColorBlueLight => '#ffffff'.color();
  static Color get msTextColorGold3Dark => '#ffffff'.color();
  static Color get msTextColorGold3Light => '#ffffff'.color();
  static Color get msTextColorBlackGoldDark => '#1E212E'.color();
  static Color get msTextColorBlackGoldLight => '#1E212E'.color();

  /// 选中文字色
  static Color get mnTextColorDark => '#C6C8CF'.color();
  static Color get mnTextColorLight => '#C6C8CF'.color();
  static Color get mnTextColorBlueDark => '#C6C8CF'.color();
  static Color get mnTextColorBlueLight => '#C6C8CF'.color();
  static Color get mnTextColorGold3Dark => '#C6C8CF'.color();
  static Color get mnTextColorGold3Light => '#C6C8CF'.color();
  static Color get mnTextColorBlackGoldDark => '#B2B3BF'.color();
  static Color get mnTextColorBlackGoldLight => '#B2B3BF'.color();

  /// 普通文字色
  static Color get lineColorDark => '#C6C8CF'.color();
  static Color get lineColorLight => '#C6C8CF'.color();
  static Color get lineColorBlueDark => '#C6C8CF'.color();
  static Color get lineColorBlueLight => '#C6C8CF'.color();
  static Color get lineColorGold3Dark => '#C6C8CF'.color();
  static Color get lineColorGold3Light => '#C6C8CF'.color();
  static Color get lineColorBlackGoldDark => '#3C3E4F'.color();
  static Color get lineColorBlackGoldLight => '#3C3E4F'.color();

  /// 线条色
  static Color get arrowColorDark => '#C6C8CF'.color();
  static Color get arrowColorLight => '#C6C8CF'.color();
  static Color get arrowColorBlueDark => '#C6C8CF'.color();
  static Color get arrowColorBlueLight => '#C6C8CF'.color();
  static Color get arrowColorGold3Dark => '#C6C8CF'.color();
  static Color get arrowColorGold3Light => '#C6C8CF'.color();
  static Color get arrowColorBlackGoldDark => '#797B88'.color();
  static Color get arrowColorBlackGoldLight => '#797B88'.color();

  /// 箭头色
  static Color get inputBgColorDark => '#C6C8CF'.color();
  static Color get inputBgColorLight => '#C6C8CF'.color();
  static Color get inputBgColorBlueDark => '#C6C8CF'.color();
  static Color get inputBgColorBlueLight => '#C6C8CF'.color();
  static Color get inputBgColorGold3Dark => '#C6C8CF'.color();
  static Color get inputBgColorGold3Light => '#C6C8CF'.color();
  static Color get inputBgColorBlackGoldDark => '#1E202B'.color();
  static Color get inputBgColorBlackGoldLight => '#1E202B'.color();

  /// 输入框
  static Color get input2ColorDark => '#C6C8CF'.color();
  static Color get input2ColorLight => '#C6C8CF'.color();
  static Color get input2ColorBlueDark => '#C6C8CF'.color();
  static Color get input2ColorBlueLight => '#C6C8CF'.color();
  static Color get input2ColorGold3Dark => '#C6C8CF'.color();
  static Color get input2ColorGold3Light => '#C6C8CF'.color();
  static Color get input2ColorBlackGoldDark => '#1E202C'.color();
  static Color get input2ColorBlackGoldLight => '#1E202C'.color();

  /// 弹窗X色
  static Color get dialogBgColorDark => '#ffffff'.color();
  static Color get dialogBgColorLight => '#ffffff'.color();
  static Color get dialogBgColorBlueDark => '#ffffff'.color();
  static Color get dialogBgColorBlueLight => '#ffffff'.color();
  static Color get dialogBgColorGold3Dark => '#ffffff'.color();
  static Color get dialogBgColorGold3Light => '#ffffff'.color();
  static Color get dialogBgColorBlackGoldDark => '#252837'.color();
  static Color get dialogBgColorBlackGoldLight => '#252837'.color();

  /// 弹窗背景色
  static Color get dialogXColorDark => '#C6C8CF'.color();
  static Color get dialogXColorLight => '#C6C8CF'.color();
  static Color get dialogXColorBlueDark => '#C6C8CF'.color();
  static Color get dialogXColorBlueLight => '#C6C8CF'.color();
  static Color get dialogXColorGold3Dark => '#C6C8CF'.color();
  static Color get dialogXColorGold3Light => '#C6C8CF'.color();
  static Color get dialogXColorBlackGoldDark => '#5A5A67'.color();
  static Color get dialogXColorBlackGoldLight => '#5A5A67'.color();

  /// 弹窗X色
  static Color get selectBoxColorDark => '#F4F4F4'.color();
  static Color get selectBoxColorLight => '#F4F4F4'.color();
  static Color get selectBoxColorBlueDark => '#F4F4F4'.color();
  static Color get selectBoxColorBlueLight => '#F4F4F4'.color();
  static Color get selectBoxColorGold3Dark => '#F4F4F4'.color();
  static Color get selectBoxColorGold3Light => '#F4F4F4'.color();
  static Color get selectBoxColorBlackGoldDark => '#242632'.color();
  static Color get selectBoxColorBlackGoldLight => '#242632'.color();

  /// 选项框
  static Color get homeGameSearchBgDark => '#ffffff'.color();
  static Color get homeGameSearchBgLight => '#ffffff'.color();
  static Color get homeGameSearchBgBlueDark => '#ffffff'.color();
  static Color get homeGameSearchBgBlueLight => '#ffffff'.color();
  static Color get homeGameSearchBgGold3Dark => '#ffffff'.color();
  static Color get homeGameSearchBgGold3Light => '#ffffff'.color();
  static Color get homeGameSearchBgBlackGoldDark => '#222633'.color();
  static Color get homeGameSearchBgBlackGoldLight => '#222633'.color();

  /// 首页游戏搜索框背景色
  static Color get homeGameSearchHintTxtColorDark => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorLight => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorBlueDark => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorBlueLight => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorGold3Dark => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorGold3Light => '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorBlackGoldDark =>
      '#ff6A6C82'.color();
  static Color get homeGameSearchHintTxtColorBlackGoldLight =>
      '#ff6A6C82'.color();

  /// 首页游戏搜索提示文案颜色
  static Color get homeGameSearchTxtColorDark => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorLight => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorBlueDark => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorBlueLight => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorGold3Dark => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorGold3Light => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorBlackGoldDark => '#ffffffff'.color();
  static Color get homeGameSearchTxtColorBlackGoldLight => '#ffffffff'.color();

  /// 首页游戏搜索文案颜色
  static Color get rechargeTypeBgColorDark => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorLight => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorBlueDark => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorBlueLight => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorGold3Dark => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorGold3Light => '#DFFDFF'.color();
  static Color get rechargeTypeBgColorBlackGoldDark => '#181A24'.color();
  static Color get rechargeTypeBgColorBlackGoldLight => '#181A24'.color();

  /// 充值类型背景颜色
  static Color get rechargeSecondTypeBgColorDark => '#000000'.color();
  static Color get rechargeSecondTypeBgColorLight => '#000000'.color();
  static Color get rechargeSecondTypeBgColorBlueDark => '#000000'.color();
  static Color get rechargeSecondTypeBgColorBlueLight => '#000000'.color();
  static Color get rechargeSecondTypeBgColorGold3Dark => '#000000'.color();
  static Color get rechargeSecondTypeBgColorGold3Light => '#000000'.color();
  static Color get rechargeSecondTypeBgColorBlackGoldDark => '#ffffff'.color();
  static Color get rechargeSecondTypeBgColorBlackGoldLight => '#ffffff'.color();

  /// 充值类型二级背景颜色
  static Color get rechargeMoneyColorDark => '#ffffff'.color();
  static Color get rechargeMoneyColorLight => '#ffffff'.color();
  static Color get rechargeMoneyColorBlueDark => '#ffffff'.color();
  static Color get rechargeMoneyColorBlueLight => '#ffffff'.color();
  static Color get rechargeMoneyColorGold3Dark => '#ffffff'.color();
  static Color get rechargeMoneyColorGold3Light => '#ffffff'.color();
  static Color get rechargeMoneyColorBlackGoldDark => '#000000'.color();
  static Color get rechargeMoneyColorBlackGoldLight => '#000000'.color();

  /// 充值类型二级背景颜色
  static Color get rechargeMoneyTypeColorDark => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorLight => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorBlueDark => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorBlueLight => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorGold3Dark => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorGold3Light => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorBlackGoldDark => '#2F3345'.color();
  static Color get rechargeMoneyTypeColorBlackGoldLight => '#2F3345'.color();

  /// 充值类型三级背景颜色
  static Color get rechargeTipsTxtColorDark => '#000000'.color();
  static Color get rechargeTipsTxtColorLight => '#000000'.color();
  static Color get rechargeTipsTxtColorBlueDark => '#000000'.color();
  static Color get rechargeTipsTxtColorBlueLight => '#000000'.color();
  static Color get rechargeTipsTxtColorGold3Dark => '#000000'.color();
  static Color get rechargeTipsTxtColorGold3Light => '#000000'.color();
  static Color get rechargeTipsTxtColorBlackGoldDark => '#AEB3CC'.color();
  static Color get rechargeTipsTxtColorBlackGoldLight => '#AEB3CC'.color();

  /// 充值余额不足弹窗内容文字颜色
  static Color get rechargeTipsDialogBorderLineColorDark => '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorLight =>
      '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorBlueDark =>
      '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorBlueLight =>
      '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorGold3Dark =>
      '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorGold3Light =>
      '#FFF4F4F4'.color();
  static Color get rechargeTipsDialogBorderLineColorBlackGoldDark =>
      '#FFD69F'.color();
  static Color get rechargeTipsDialogBorderLineColorBlackGoldLight =>
      '#FFFFD69F'.color();

  /// 充值余额不足弹窗按钮边框颜色
  static Color get rechargeTabBarUnSelectTextColorDark => '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorLight => '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorBlueDark =>
      '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorBlueLight =>
      '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorGold3Dark =>
      '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorGold3Light =>
      '#FF4B4B4B'.color();
  static Color get rechargeTabBarUnSelectTextColorBlackGoldDark =>
      '#FF8288A2'.color();
  static Color get rechargeTabBarUnSelectTextColorBlackGoldLight =>
      '#FF8288A2'.color();

  /// 充值未选中的tab文字颜色
  static Color get manualRechargeBgColorDark => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorLight => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorBlueDark => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorBlueLight => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorGold3Dark => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorGold3Light => '#FFFFEFDF'.color();
  static Color get manualRechargeBgColorBlackGoldDark => '#00000000'.color();
  static Color get manualRechargeBgColorBlackGoldLight => '#00000000'.color();

  /// 人工充值额度背景颜色
  static Color get manualRechargeTxtColor1Dark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1Light => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1BlueDark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1BlueLight => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1Gold3Dark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1Gold3Light => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor1BlackGoldDark => '#FF82879C'.color();
  static Color get manualRechargeTxtColor1BlackGoldLight => '#FF82879C'.color();

  /// 人工充值额度文字颜色
  static Color get manualRechargeTxtColor2Dark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2Light => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2BlueDark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2BlueLight => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2Gold3Dark => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2Gold3Light => '#FFFF5702'.color();
  static Color get manualRechargeTxtColor2BlackGoldDark => '#FFFFD69F'.color();
  static Color get manualRechargeTxtColor2BlackGoldLight => '#FFFFD69F'.color();

  /// 人工充值额度文字颜色
  static Color get settingsWithdrawalPwdDialogBgColorDark =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorLight =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorBlueDark =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorBlueLight =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorGold3Dark =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorGold3Light =>
      '#ffffffff'.color();
  static Color get settingsWithdrawalPwdDialogBgColorBlackGoldDark =>
      '#ff212330'.color();
  static Color get settingsWithdrawalPwdDialogBgColorBlackGoldLight =>
      '#ff212330'.color();

  /// 设置提现密码弹窗背景色
}
