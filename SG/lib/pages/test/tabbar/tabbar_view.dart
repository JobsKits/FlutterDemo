import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_point.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import 'tabbar_logic.dart';

class TabbarPage extends StatelessWidget {
  final logic = Get.find<TabbarLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabbar with icon'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          DefaultTabController(
            length: logic.tabs.length,
            child: CustomTabBarWithIcon(
              tabs: logic.tabs,
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          DefaultTabController(
            length: logic.tabsNoIcons.length,
            child: CustomTabBarWithIcon(
              tabs: logic.tabsNoIcons,
            ),
          ),
          const SizedBox(
            height: AppValues.defaultPadding,
          ),
          DefaultTabController(
            length: logic.tabs.length,
            child: CustomTabBarPoint(
              indicatorColor: ThemeService().colorScheme.primary,
              tabs: logic.tabs,
            ),
          )
        ],
      ),
    );
  }
}
