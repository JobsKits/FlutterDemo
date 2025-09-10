import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../../services/theme/theme_service.dart';

class CasinoTabBar extends StatelessWidget {
  final List<Tab> tabs;
  final TabController tabController;
  final void Function(int)? onTap;
  const CasinoTabBar({super.key, required this.tabs, required this.tabController,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          color: ThemeService().theme.colorScheme.surface, // 设置背景色
          borderRadius: BorderRadius.circular(AppValues.radius_12 * 2), // 设置圆角的半径
        ),
        child: DefaultTabController(
          length: tabs.length,
          child: CustomTabBarWithIcon(
            unselectedLabelStyle: ThemeService()
                .theme
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            labelStyle: ThemeService()
                .theme
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            tabController: tabController,
            tabs: tabs,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: AppValues.sportRadius_23,
            height: 54,
            buttonMargin: const EdgeInsets.all(6),
            isShowScrollBar: true,
            onTap: onTap,
          ),
    )));
  }
}
