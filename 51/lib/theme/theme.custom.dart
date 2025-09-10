import 'package:flutter/material.dart';
import 'base.theme.dart';

class CustomTheme extends ThemeExtension<CustomTheme> {
  /// 主题色
  Color? primary;

  /// 通知小红点颜色
  Color? notify;

  /// 导航栏文字颜色
  Color? appbarText;

  /// 底部导航栏背景色
  Color? navbarBg;

  /// 底部导航栏背景色
  Color? pageBg;

  /// 底部导航栏背景色
  Color? pageTwoBg;

  /// 公告弹窗三级背景色
  Color? pageThreeBg;

  /// 亮字色
  Color? titleColor;

  /// 浅字色
  Color? title2Color;

  /// 中字色
  Color? title3Color;

  /// 选中文字色
  Color? msTextColor;

  /// 普通文字色
  Color? mnTextColor;

  /// 线条色
  Color? lineColor;

  /// 箭头色
  Color? arrowColor;

  /// 输入框
  Color? inputBgColor;

  /// 弹窗X色
  Color? input2Color;

  /// 弹窗背景色
  Color? dialogBgColor;

  /// 弹窗X色
  Color? dialogXColor;

  /// 选项框
  Color? selectBoxColor;

  /// 首页游戏搜索框背景色
  Color? homeGameSearchBgColor;

  /// 首页游戏搜索提示文案颜色
  Color? homeGameSearchHintTxtColor;

  /// 首页游戏搜索文案颜色
  Color? homeGameSearchTxtColor;

  /// 充值类型背景颜色
  Color? rechargeTypeBgColor;

  /// 充值类型二级背景颜色
  Color? rechargeSecondTypeBgColor;

  /// 充值类型二级背景颜色
  Color? rechargeMoneyColor;

  /// 充值类型三级背景颜色
  Color? rechargeMoneyTypeColor;

  /// 充值余额不足弹窗内容文字颜色
  Color? rechargeTipsTxtColor;

  /// 充值余额不足弹窗按钮边框颜色
  Color? rechargeTipsDialogBorderLineColor;

  /// 充值未选中的tab文字颜色
  Color? rechargeTabBarUnSelectTextColor;

  /// 人工充值额度背景颜色
  Color? manualRechargeBgColor;

  /// 人工充值额度文字颜色
  Color? manualRechargeTxtColor1;

  /// 人工充值额度文字颜色
  Color? manualRechargeTxtColor2;

  /// 设置提现密码弹窗背景色
  Color? settingsWithdrawalPwdDialogBgColor;
  CustomTheme({
    /// 主题色
    this.primary,

    /// 通知小红点颜色
    this.notify,

    /// 导航栏文字颜色
    this.appbarText,

    /// 底部导航栏背景色
    this.navbarBg,

    /// 底部导航栏背景色
    this.pageBg,

    /// 底部导航栏背景色
    this.pageTwoBg,

    /// 公告弹窗三级背景色
    this.pageThreeBg,

    /// 亮字色
    this.titleColor,

    /// 浅字色
    this.title2Color,

    /// 中字色
    this.title3Color,

    /// 选中文字色
    this.msTextColor,

    /// 普通文字色
    this.mnTextColor,

    /// 线条色
    this.lineColor,

    /// 箭头色
    this.arrowColor,

    /// 输入框
    this.inputBgColor,

    /// 弹窗X色
    this.input2Color,

    /// 弹窗背景色
    this.dialogBgColor,

    /// 弹窗X色
    this.dialogXColor,

    /// 选项框
    this.selectBoxColor,

    /// 首页游戏搜索框背景色
    this.homeGameSearchBgColor,

    /// 首页游戏搜索提示文案颜色
    this.homeGameSearchHintTxtColor,

    /// 首页游戏搜索文案颜色
    this.homeGameSearchTxtColor,

    /// 充值类型背景颜色
    this.rechargeTypeBgColor,

    /// 充值类型二级背景颜色
    this.rechargeSecondTypeBgColor,

    /// 充值类型二级背景颜色
    this.rechargeMoneyColor,

    /// 充值类型三级背景颜色
    this.rechargeMoneyTypeColor,

    /// 充值余额不足弹窗内容文字颜色
    this.rechargeTipsTxtColor,

    /// 充值余额不足弹窗按钮边框颜色
    this.rechargeTipsDialogBorderLineColor,

    /// 充值未选中的tab文字颜色
    this.rechargeTabBarUnSelectTextColor,

    /// 人工充值额度背景颜色
    this.manualRechargeBgColor,

    /// 人工充值额度文字颜色
    this.manualRechargeTxtColor1,

    /// 人工充值额度文字颜色
    this.manualRechargeTxtColor2,

    /// 设置提现密码弹窗背景色
    this.settingsWithdrawalPwdDialogBgColor,
  });
  @override
  ThemeExtension<CustomTheme> copyWith({
    Color? primary,
    Color? notify,
    Color? appbarText,
    Color? navbarBg,
    Color? pageBg,
    Color? pageTwoBg,
    Color? pageThreeBg,
    Color? titleColor,
    Color? title2Color,
    Color? title3Color,
    Color? msTextColor,
    Color? mnTextColor,
    Color? lineColor,
    Color? arrowColor,
    Color? inputBgColor,
    Color? input2Color,
    Color? dialogBgColor,
    Color? dialogXColor,
    Color? selectBoxColor,
    Color? homeGameSearchBgColor,
    Color? homeGameSearchHintTxtColor,
    Color? homeGameSearchTxtColor,
    Color? rechargeTypeBgColor,
    Color? rechargeSecondTypeBgColor,
    Color? rechargeMoneyColor,
    Color? rechargeMoneyTypeColor,
    Color? rechargeTipsTxtColor,
    Color? rechargeTipsDialogBorderLineColor,
    Color? rechargeTabBarUnSelectTextColor,
    Color? manualRechargeBgColor,
    Color? manualRechargeTxtColor1,
    Color? manualRechargeTxtColor2,
    Color? settingsWithdrawalPwdDialogBgColor,
  }) {
    return CustomTheme(
      primary: primary ?? this.primary,
      notify: notify ?? this.notify,
      appbarText: appbarText ?? this.appbarText,
      navbarBg: navbarBg ?? this.navbarBg,
      pageBg: pageBg ?? this.pageBg,
      pageTwoBg: pageTwoBg ?? this.pageTwoBg,
      pageThreeBg: pageThreeBg ?? this.pageThreeBg,
      titleColor: titleColor ?? this.titleColor,
      title2Color: title2Color ?? this.title2Color,
      title3Color: title3Color ?? this.title3Color,
      msTextColor: msTextColor ?? this.msTextColor,
      mnTextColor: mnTextColor ?? this.mnTextColor,
      lineColor: lineColor ?? this.lineColor,
      arrowColor: arrowColor ?? this.arrowColor,
      inputBgColor: inputBgColor ?? this.inputBgColor,
      input2Color: input2Color ?? this.input2Color,
      dialogBgColor: dialogBgColor ?? this.dialogBgColor,
      dialogXColor: dialogXColor ?? this.dialogXColor,
      selectBoxColor: selectBoxColor ?? this.selectBoxColor,
      homeGameSearchBgColor:
          homeGameSearchBgColor ?? this.homeGameSearchBgColor,
      homeGameSearchHintTxtColor:
          homeGameSearchHintTxtColor ?? this.homeGameSearchHintTxtColor,
      homeGameSearchTxtColor:
          homeGameSearchTxtColor ?? this.homeGameSearchTxtColor,
      rechargeTypeBgColor: rechargeTypeBgColor ?? this.rechargeTypeBgColor,
      rechargeSecondTypeBgColor:
          rechargeSecondTypeBgColor ?? this.rechargeSecondTypeBgColor,
      rechargeMoneyColor: rechargeMoneyColor ?? this.rechargeMoneyColor,
      rechargeMoneyTypeColor:
          rechargeMoneyTypeColor ?? this.rechargeMoneyTypeColor,
      rechargeTipsTxtColor: rechargeTipsTxtColor ?? this.rechargeTipsTxtColor,
      rechargeTipsDialogBorderLineColor: rechargeTipsDialogBorderLineColor ??
          this.rechargeTipsDialogBorderLineColor,
      rechargeTabBarUnSelectTextColor: rechargeTabBarUnSelectTextColor ??
          this.rechargeTabBarUnSelectTextColor,
      manualRechargeBgColor:
          manualRechargeBgColor ?? this.manualRechargeBgColor,
      manualRechargeTxtColor1:
          manualRechargeTxtColor1 ?? this.manualRechargeTxtColor1,
      manualRechargeTxtColor2:
          manualRechargeTxtColor2 ?? this.manualRechargeTxtColor2,
      settingsWithdrawalPwdDialogBgColor: settingsWithdrawalPwdDialogBgColor ??
          this.settingsWithdrawalPwdDialogBgColor,
    );
  }

  @override
  ThemeExtension<CustomTheme> lerp(
      ThemeExtension<CustomTheme>? other, double t) {
    return CustomTheme();
  }

  static CustomTheme get dark => CustomTheme(
        primary: BaseTheme.primaryDark,
        notify: BaseTheme.notifyDark,
        appbarText: BaseTheme.appbarTextDark,
        navbarBg: BaseTheme.navbarBgDark,
        pageBg: BaseTheme.pageBgDark,
        pageTwoBg: BaseTheme.pageTwoBgDark,
        pageThreeBg: BaseTheme.pageThreeBgDark,
        titleColor: BaseTheme.titleColorDark,
        title2Color: BaseTheme.title2ColorDark,
        title3Color: BaseTheme.title3ColorDark,
        msTextColor: BaseTheme.msTextColorDark,
        mnTextColor: BaseTheme.mnTextColorDark,
        lineColor: BaseTheme.lineColorDark,
        arrowColor: BaseTheme.arrowColorDark,
        inputBgColor: BaseTheme.inputBgColorDark,
        input2Color: BaseTheme.input2ColorDark,
        dialogBgColor: BaseTheme.dialogBgColorDark,
        dialogXColor: BaseTheme.dialogXColorDark,
        selectBoxColor: BaseTheme.selectBoxColorDark,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgDark,
        homeGameSearchHintTxtColor: BaseTheme.homeGameSearchHintTxtColorDark,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorDark,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorDark,
        rechargeSecondTypeBgColor: BaseTheme.rechargeSecondTypeBgColorDark,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorDark,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorDark,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorDark,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorDark,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorDark,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorDark,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1Dark,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2Dark,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorDark,
      );
  static CustomTheme get light => CustomTheme(
        primary: BaseTheme.primaryLight,
        notify: BaseTheme.notifyLight,
        appbarText: BaseTheme.appbarTextLight,
        navbarBg: BaseTheme.navbarBgLight,
        pageBg: BaseTheme.pageBgLight,
        pageTwoBg: BaseTheme.pageTwoBgLight,
        pageThreeBg: BaseTheme.pageThreeBgLight,
        titleColor: BaseTheme.titleColorLight,
        title2Color: BaseTheme.title2ColorLight,
        title3Color: BaseTheme.title3ColorLight,
        msTextColor: BaseTheme.msTextColorLight,
        mnTextColor: BaseTheme.mnTextColorLight,
        lineColor: BaseTheme.lineColorLight,
        arrowColor: BaseTheme.arrowColorLight,
        inputBgColor: BaseTheme.inputBgColorLight,
        input2Color: BaseTheme.input2ColorLight,
        dialogBgColor: BaseTheme.dialogBgColorLight,
        dialogXColor: BaseTheme.dialogXColorLight,
        selectBoxColor: BaseTheme.selectBoxColorLight,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgLight,
        homeGameSearchHintTxtColor: BaseTheme.homeGameSearchHintTxtColorLight,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorLight,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorLight,
        rechargeSecondTypeBgColor: BaseTheme.rechargeSecondTypeBgColorLight,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorLight,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorLight,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorLight,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorLight,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorLight,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorLight,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1Light,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2Light,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorLight,
      );
  static CustomTheme get blueDark => CustomTheme(
        primary: BaseTheme.primaryBlueDark,
        notify: BaseTheme.notifyBlueDark,
        appbarText: BaseTheme.appbarTextBlueDark,
        navbarBg: BaseTheme.navbarBgBlueDark,
        pageBg: BaseTheme.pageBgBlueDark,
        pageTwoBg: BaseTheme.pageTwoBgBlueDark,
        pageThreeBg: BaseTheme.pageThreeBgBlueDark,
        titleColor: BaseTheme.titleColorBlueDark,
        title2Color: BaseTheme.title2ColorBlueDark,
        title3Color: BaseTheme.title3ColorBlueDark,
        msTextColor: BaseTheme.msTextColorBlueDark,
        mnTextColor: BaseTheme.mnTextColorBlueDark,
        lineColor: BaseTheme.lineColorBlueDark,
        arrowColor: BaseTheme.arrowColorBlueDark,
        inputBgColor: BaseTheme.inputBgColorBlueDark,
        input2Color: BaseTheme.input2ColorBlueDark,
        dialogBgColor: BaseTheme.dialogBgColorBlueDark,
        dialogXColor: BaseTheme.dialogXColorBlueDark,
        selectBoxColor: BaseTheme.selectBoxColorBlueDark,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgBlueDark,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorBlueDark,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorBlueDark,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorBlueDark,
        rechargeSecondTypeBgColor: BaseTheme.rechargeSecondTypeBgColorBlueDark,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorBlueDark,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorBlueDark,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorBlueDark,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorBlueDark,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorBlueDark,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorBlueDark,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1BlueDark,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2BlueDark,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorBlueDark,
      );
  static CustomTheme get blueLight => CustomTheme(
        primary: BaseTheme.primaryBlueLight,
        notify: BaseTheme.notifyBlueLight,
        appbarText: BaseTheme.appbarTextBlueLight,
        navbarBg: BaseTheme.navbarBgBlueLight,
        pageBg: BaseTheme.pageBgBlueLight,
        pageTwoBg: BaseTheme.pageTwoBgBlueLight,
        pageThreeBg: BaseTheme.pageThreeBgBlueLight,
        titleColor: BaseTheme.titleColorBlueLight,
        title2Color: BaseTheme.title2ColorBlueLight,
        title3Color: BaseTheme.title3ColorBlueLight,
        msTextColor: BaseTheme.msTextColorBlueLight,
        mnTextColor: BaseTheme.mnTextColorBlueLight,
        lineColor: BaseTheme.lineColorBlueLight,
        arrowColor: BaseTheme.arrowColorBlueLight,
        inputBgColor: BaseTheme.inputBgColorBlueLight,
        input2Color: BaseTheme.input2ColorBlueLight,
        dialogBgColor: BaseTheme.dialogBgColorBlueLight,
        dialogXColor: BaseTheme.dialogXColorBlueLight,
        selectBoxColor: BaseTheme.selectBoxColorBlueLight,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgBlueLight,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorBlueLight,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorBlueLight,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorBlueLight,
        rechargeSecondTypeBgColor: BaseTheme.rechargeSecondTypeBgColorBlueLight,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorBlueLight,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorBlueLight,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorBlueLight,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorBlueLight,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorBlueLight,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorBlueLight,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1BlueLight,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2BlueLight,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorBlueLight,
      );
  static CustomTheme get gold3Dark => CustomTheme(
        primary: BaseTheme.primaryGold3Dark,
        notify: BaseTheme.notifyGold3Dark,
        appbarText: BaseTheme.appbarTextGold3Dark,
        navbarBg: BaseTheme.navbarBgGold3Dark,
        pageBg: BaseTheme.pageBgGold3Dark,
        pageTwoBg: BaseTheme.pageTwoBgGold3Dark,
        pageThreeBg: BaseTheme.pageThreeBgGold3Dark,
        titleColor: BaseTheme.titleColorGold3Dark,
        title2Color: BaseTheme.title2ColorGold3Dark,
        title3Color: BaseTheme.title3ColorGold3Dark,
        msTextColor: BaseTheme.msTextColorGold3Dark,
        mnTextColor: BaseTheme.mnTextColorGold3Dark,
        lineColor: BaseTheme.lineColorGold3Dark,
        arrowColor: BaseTheme.arrowColorGold3Dark,
        inputBgColor: BaseTheme.inputBgColorGold3Dark,
        input2Color: BaseTheme.input2ColorGold3Dark,
        dialogBgColor: BaseTheme.dialogBgColorGold3Dark,
        dialogXColor: BaseTheme.dialogXColorGold3Dark,
        selectBoxColor: BaseTheme.selectBoxColorGold3Dark,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgGold3Dark,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorGold3Dark,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorGold3Dark,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorGold3Dark,
        rechargeSecondTypeBgColor: BaseTheme.rechargeSecondTypeBgColorGold3Dark,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorGold3Dark,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorGold3Dark,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorGold3Dark,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorGold3Dark,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorGold3Dark,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorGold3Dark,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1Gold3Dark,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2Gold3Dark,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorGold3Dark,
      );
  static CustomTheme get gold3Light => CustomTheme(
        primary: BaseTheme.primaryGold3Light,
        notify: BaseTheme.notifyGold3Light,
        appbarText: BaseTheme.appbarTextGold3Light,
        navbarBg: BaseTheme.navbarBgGold3Light,
        pageBg: BaseTheme.pageBgGold3Light,
        pageTwoBg: BaseTheme.pageTwoBgGold3Light,
        pageThreeBg: BaseTheme.pageThreeBgGold3Light,
        titleColor: BaseTheme.titleColorGold3Light,
        title2Color: BaseTheme.title2ColorGold3Light,
        title3Color: BaseTheme.title3ColorGold3Light,
        msTextColor: BaseTheme.msTextColorGold3Light,
        mnTextColor: BaseTheme.mnTextColorGold3Light,
        lineColor: BaseTheme.lineColorGold3Light,
        arrowColor: BaseTheme.arrowColorGold3Light,
        inputBgColor: BaseTheme.inputBgColorGold3Light,
        input2Color: BaseTheme.input2ColorGold3Light,
        dialogBgColor: BaseTheme.dialogBgColorGold3Light,
        dialogXColor: BaseTheme.dialogXColorGold3Light,
        selectBoxColor: BaseTheme.selectBoxColorGold3Light,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgGold3Light,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorGold3Light,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorGold3Light,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorGold3Light,
        rechargeSecondTypeBgColor:
            BaseTheme.rechargeSecondTypeBgColorGold3Light,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorGold3Light,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorGold3Light,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorGold3Light,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorGold3Light,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorGold3Light,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorGold3Light,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1Gold3Light,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2Gold3Light,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorGold3Light,
      );
  static CustomTheme get blackGoldDark => CustomTheme(
        primary: BaseTheme.primaryBlackGoldDark,
        notify: BaseTheme.notifyBlackGoldDark,
        appbarText: BaseTheme.appbarTextBlackGoldDark,
        navbarBg: BaseTheme.navbarBgBlackGoldDark,
        pageBg: BaseTheme.pageBgBlackGoldDark,
        pageTwoBg: BaseTheme.pageTwoBgBlackGoldDark,
        pageThreeBg: BaseTheme.pageThreeBgBlackGoldDark,
        titleColor: BaseTheme.titleColorBlackGoldDark,
        title2Color: BaseTheme.title2ColorBlackGoldDark,
        title3Color: BaseTheme.title3ColorBlackGoldDark,
        msTextColor: BaseTheme.msTextColorBlackGoldDark,
        mnTextColor: BaseTheme.mnTextColorBlackGoldDark,
        lineColor: BaseTheme.lineColorBlackGoldDark,
        arrowColor: BaseTheme.arrowColorBlackGoldDark,
        inputBgColor: BaseTheme.inputBgColorBlackGoldDark,
        input2Color: BaseTheme.input2ColorBlackGoldDark,
        dialogBgColor: BaseTheme.dialogBgColorBlackGoldDark,
        dialogXColor: BaseTheme.dialogXColorBlackGoldDark,
        selectBoxColor: BaseTheme.selectBoxColorBlackGoldDark,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgBlackGoldDark,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorBlackGoldDark,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorBlackGoldDark,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorBlackGoldDark,
        rechargeSecondTypeBgColor:
            BaseTheme.rechargeSecondTypeBgColorBlackGoldDark,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorBlackGoldDark,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorBlackGoldDark,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorBlackGoldDark,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorBlackGoldDark,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorBlackGoldDark,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorBlackGoldDark,
        manualRechargeTxtColor1: BaseTheme.manualRechargeTxtColor1BlackGoldDark,
        manualRechargeTxtColor2: BaseTheme.manualRechargeTxtColor2BlackGoldDark,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorBlackGoldDark,
      );
  static CustomTheme get blackGoldLight => CustomTheme(
        primary: BaseTheme.primaryBlackGoldLight,
        notify: BaseTheme.notifyBlackGoldLight,
        appbarText: BaseTheme.appbarTextBlackGoldLight,
        navbarBg: BaseTheme.navbarBgBlackGoldLight,
        pageBg: BaseTheme.pageBgBlackGoldLight,
        pageTwoBg: BaseTheme.pageTwoBgBlackGoldLight,
        pageThreeBg: BaseTheme.pageThreeBgBlackGoldLight,
        titleColor: BaseTheme.titleColorBlackGoldLight,
        title2Color: BaseTheme.title2ColorBlackGoldLight,
        title3Color: BaseTheme.title3ColorBlackGoldLight,
        msTextColor: BaseTheme.msTextColorBlackGoldLight,
        mnTextColor: BaseTheme.mnTextColorBlackGoldLight,
        lineColor: BaseTheme.lineColorBlackGoldLight,
        arrowColor: BaseTheme.arrowColorBlackGoldLight,
        inputBgColor: BaseTheme.inputBgColorBlackGoldLight,
        input2Color: BaseTheme.input2ColorBlackGoldLight,
        dialogBgColor: BaseTheme.dialogBgColorBlackGoldLight,
        dialogXColor: BaseTheme.dialogXColorBlackGoldLight,
        selectBoxColor: BaseTheme.selectBoxColorBlackGoldLight,
        homeGameSearchBgColor: BaseTheme.homeGameSearchBgBlackGoldLight,
        homeGameSearchHintTxtColor:
            BaseTheme.homeGameSearchHintTxtColorBlackGoldLight,
        homeGameSearchTxtColor: BaseTheme.homeGameSearchTxtColorBlackGoldLight,
        rechargeTypeBgColor: BaseTheme.rechargeTypeBgColorBlackGoldLight,
        rechargeSecondTypeBgColor:
            BaseTheme.rechargeSecondTypeBgColorBlackGoldLight,
        rechargeMoneyColor: BaseTheme.rechargeMoneyColorBlackGoldLight,
        rechargeMoneyTypeColor: BaseTheme.rechargeMoneyTypeColorBlackGoldLight,
        rechargeTipsTxtColor: BaseTheme.rechargeTipsTxtColorBlackGoldLight,
        rechargeTipsDialogBorderLineColor:
            BaseTheme.rechargeTipsDialogBorderLineColorBlackGoldLight,
        rechargeTabBarUnSelectTextColor:
            BaseTheme.rechargeTabBarUnSelectTextColorBlackGoldLight,
        manualRechargeBgColor: BaseTheme.manualRechargeBgColorBlackGoldLight,
        manualRechargeTxtColor1:
            BaseTheme.manualRechargeTxtColor1BlackGoldLight,
        manualRechargeTxtColor2:
            BaseTheme.manualRechargeTxtColor2BlackGoldLight,
        settingsWithdrawalPwdDialogBgColor:
            BaseTheme.settingsWithdrawalPwdDialogBgColorBlackGoldLight,
      );
}
