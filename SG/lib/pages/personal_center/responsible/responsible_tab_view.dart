import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/personal_center/responsible/responsible_logic.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/tab_bar/custom_tabbar_covered.dart';
import 'view/betting_limits_view.dart';
import 'view/self_exclusion_view.dart';

class ResponsibleTabView extends StatefulWidget {
  const ResponsibleTabView({super.key});

  @override
  State<ResponsibleTabView> createState() => _ResponsibleTabViewState();
}

class _ResponsibleTabViewState extends State<ResponsibleTabView>
    with SingleTickerProviderStateMixin {
  final ResponsibleLogic controller = Get.find<ResponsibleLogic>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // margin: const EdgeInsets.only(
          //     left: AppValues.defaultMargin, right: AppValues.defaultMargin),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(49),
            color: ThemeService().theme.colorScheme.surface, // 设置背景色
          ),
          child: CustomTabBarCoveredIcon(
            tabController: controller.tabController,
            // 将TabController与TabBar关联
            tabs: controller.tab,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 49,
            height: 54,
            buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 6),
            sideMargin: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            log('约束信息：TabBarView...constraints...$constraints');
            return Container(
              margin: const EdgeInsets.symmetric(
                horizontal: AppValues.defaultMargin,
                vertical: AppValues.defaultMargin,
              ),
              child: CustomAutoLayoutTabBarView(
                physics: const NeverScrollableScrollPhysics(), //禁止滑动
                controller: controller.tabController, // 将TabController与TabBarView关联
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
                    child: SelfExclusionView(),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(height: constraints.maxHeight),
                    child: BettingLimitsView(),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
