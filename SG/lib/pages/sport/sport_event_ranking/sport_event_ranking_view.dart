import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constant/app_values.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../betting/common_widget/custom_casino_sport_rank_widget.dart';
import 'betting/sport_betting_list_view.dart';
import 'compete/sport_compete_list_view.dart';
import 'sport_event_ranking_logic.dart';

//体育赛事 内嵌的排行榜，包括：所有投注、风云榜、竞赛排行榜
class SportEventRankingPage extends StatefulWidget {
  SportEventRankingPage({Key? key}) : super(key: key);

  @override
  State<SportEventRankingPage> createState() => _SportEventRankingPageState();
}

class _SportEventRankingPageState extends State<SportEventRankingPage> {
  // final sportOpeningLogic = Get.find<SportOpeningLogic>();
  final logic = Get.put(SportEventRankingLogic());

  final state = Get.find<SportEventRankingLogic>().state;

  @override
  void dispose() {
    Get.delete<SportEventRankingLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCasinoSportRankWidget();
    // return _buildTabBarView();
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      // controller: ScrollController(),
      child: Column(
        // shrinkWrap: true,
        // physics: const NeverScrollableScrollPhysics(),
        children: [
          // _buildTabBarView(),
          // _buildTabBarPageView(),
        ],
      ),
    );
    return Container(
      child: ListView(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(height: 100, color: Colors.red),
          Container(height: 200, color: Colors.green),
          Container(height: 300, color: Colors.blue),
        ],
      ),
    );
  }

  _buildTabBarView() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppValues.defaultPadding,
        vertical: AppValues.defaultMargin,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(49),
        color: ThemeService().theme.colorScheme.surface, // 设置背景色
        // color: ThemeService().theme.colorScheme.tertiary,
      ),
      child: CustomTabBarWithIcon(
        tabController: logic.tabController,
        // 将TabController与TabBar关联
        tabs: logic.tabs,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: 44,
        height: 54,
        buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  _buildTabBarPageView() {
    return Container(
      // color: ThemeService().colorScheme.surface, // 设置背景色
      // padding: EdgeInsets.all(AppValues.defaultMargin),
      padding: const EdgeInsets.only(
        left: AppValues.defaultPadding,
        right: AppValues.defaultPadding,
        // left: AppValues.sportPadding_12.w,
        // right: AppValues.sportPadding_12.w,
        bottom: AppValues.largeMargin,
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        log("竞赛排行榜...SportRankingListPage...constraints...$constraints");
        return CustomAutoLayoutTabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止滑动
          controller: logic.tabController, // 将TabController与TabBarView关联
          children: [
            // //滚球盘与即将开赛盘口
            // ConstrainedBox(constraints: constraints, child: SportBettingListPage()),
            // //冠军投注
            // ConstrainedBox(constraints: constraints, child: SportBettingListPage()),
            // //全部足球[篮球、网球等等]
            // ConstrainedBox(constraints: constraints, child: SportCompeteListPage()),

            SportBettingListPage(),
            SportBettingListPage(),
            SportCompeteListPage(),
          ],
        );
      }),
    );
  }

  _buildTabBarView2() {
    return Column(
      children: [
        ///tab 行
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppValues.defaultPadding,
            vertical: AppValues.defaultMargin,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(49),
            color: ThemeService().theme.colorScheme.surface, // 设置背景色
            // color: ThemeService().theme.colorScheme.tertiary,
          ),
          child: CustomTabBarWithIcon(
            tabController: logic.tabController,
            // 将TabController与TabBar关联
            tabs: logic.tabs,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 44,
            height: 54,
            buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),

        ///tab列表详情区域
        Expanded(
          child: Container(
            // color: ThemeService().colorScheme.surface, // 设置背景色
            // padding: EdgeInsets.all(AppValues.defaultMargin),
            padding: const EdgeInsets.only(
              left: AppValues.defaultPadding,
              right: AppValues.defaultPadding,
              // left: AppValues.sportPadding_12.w,
              // right: AppValues.sportPadding_12.w,
              bottom: AppValues.largeMargin,
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              log("竞赛排行榜...SportRankingListPage...constraints...$constraints");
              return CustomAutoLayoutTabBarView(
                physics: const NeverScrollableScrollPhysics(), //禁止滑动
                controller: logic.tabController, // 将TabController与TabBarView关联
                children: [
                  // //滚球盘与即将开赛盘口
                  // ConstrainedBox(constraints: constraints, child: SportBettingListPage()),
                  // //冠军投注
                  // ConstrainedBox(constraints: constraints, child: SportBettingListPage()),
                  // //全部足球[篮球、网球等等]
                  // ConstrainedBox(constraints: constraints, child: SportCompeteListPage()),

                  SportBettingListPage(),
                  SportBettingListPage(),
                  SportCompeteListPage(),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
