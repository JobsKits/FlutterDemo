import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:package_info/package_info.dart';

class AboutUsController extends BaseController with GetTickerProviderStateMixin {
  AboutUsController();
  final pageIndex = 0.obs; //初始化时显示知道页面
  TabController? tabController;
  final tabs = [
    // Tab(
    //   child: Text(S.current.home_forum, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ),
    Tab(
      child: Text(S.current.privacy_policy, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.terms_of_service_text, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.responsible_for_gambling, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    // Tab(
    //   child: Text(S.current.fairness, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ),
    Tab(
      child: Text(S.current.sports_betting_rules, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      child: Text(S.current.version, style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
  ];

  _initData() {
    update(["about_us"]);
    getPackageInfo();
  }

  getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    tabs.removeLast();
    tabs.add(Tab(
      child: Text('${S.current.version}($version)', style: ThemeService().textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ));
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    GlobalState.instance.index = 13;
    super.onReady();
    _initData();
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    super.onClose();
  }
}
