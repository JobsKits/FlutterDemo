import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';

///导航栏搜索栏下展示内容
Widget searchBuildInfoBg({required List<Widget> children}) {
  return Expanded(
    child: Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Stack(
        children: children,
      ),
    ),
  );
}

///导航栏导航背景
Widget navigationBuildInfoBg({required List<Widget> children}) {
  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: children,
    ),
  );
}

///导航栏模块背景
Widget navigationBuildModuleBg({required List<Widget> children}) {
  return Card(
    elevation: 0.0,
    // color: ThemeService().theme.colorScheme.background,
    color: ThemeService().theme.scaffoldBackgroundColor,
    margin:
        const EdgeInsets.symmetric(horizontal: AppValues.margin_12, vertical: AppValues.margin_6),
    child: Column(
      children: children,
    ),
  );
}
