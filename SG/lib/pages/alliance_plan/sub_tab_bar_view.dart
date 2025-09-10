import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/pages/alliance_plan/subagent/subagent_view.dart';
import 'package:get/get.dart';

import '../../constant/app_values.dart';
import '../../services/theme/theme_service.dart';
import '../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'all_data/all_data_view.dart';
import 'alliance_plan_logic.dart';
import 'commission_rate/commission_rate_view.dart';
import 'direct_betting/direct_betting_view.dart';
import 'direct_finance/direct_finance_view.dart';
import 'direct_receive/direct_receive_view.dart';
import 'direct_user/direct_user_view.dart';
import 'my_commission/my_commission_view.dart';
import 'my_performance/my_performance_view.dart';
import 'my_promotion/my_promotion_view.dart';
import 'study/promotion_study_view.dart';

class SubTabBarView extends StatefulWidget {
  const SubTabBarView({super.key, required this.isLogin});

  final bool isLogin;

  @override
  State<SubTabBarView> createState() => _SubTabBarViewState();
}

class _SubTabBarViewState extends State<SubTabBarView> {
  final AlliancePlanLogic controller = Get.find<AlliancePlanLogic>();

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ///tab 行
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: AppValues.defaultPadding,
            // vertical: AppValues.defaultMargin,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(49),
            color: ThemeService().theme.colorScheme.surface, // 设置背景色
          ),
          //CustomTabBarCoveredIcon
          //CustomTabBarWithIcon
          child: CustomTabBarWithIcon(
            isLogin: true,
            tabController: controller.tabController,
            // controller: controller.tabController,
            // 将TabController与TabBar关联
            tabs: controller.tabList,
            backgroundColor: ThemeService().theme.colorScheme.tertiary,
            radius: 44,
            height: 54,
            buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            isShowScrollBar: true,
          ),
        ),

        ///tab列表详情区域
        Expanded(
          child: Container(
            // color: ThemeService().colorScheme.surface, // 设置背景色
            // padding: EdgeInsets.zero,
            margin: EdgeInsets.all(AppValues.margin_12),
            child: LayoutBuilder(builder: (context, constraints) {
              // log("TabBarView...constraints...$constraints");
              return CustomAutoLayoutTabBarView(
                physics: const NeverScrollableScrollPhysics(), //禁止滑动
                controller: controller.tabController, // 将TabController与TabBarView关联
                children: [
                  //1
                  ConstrainedBox(constraints: constraints, child: PromotionStudyPage()),
                  //推广教程
                  ConstrainedBox(constraints: constraints, child: MyPromotionPage()),
                  //我的推广
                  ConstrainedBox(constraints: constraints, child: MyCommissionPage()),
                  //我的佣金
                  ConstrainedBox(constraints: constraints, child: MyPerformancePage()),
                  //我的业绩
                  ConstrainedBox(constraints: constraints, child: AllDataPage()),
                  //所有数据
                  //6
                  ConstrainedBox(constraints: constraints, child: DirectFinancePage()),
                  //直属财务
                  ConstrainedBox(constraints: constraints, child: DirectBettingPage()),
                  //直属投注
                  ConstrainedBox(constraints: constraints, child: DirectUserPage()),
                  //直属用户
                  // ConstrainedBox(constraints: constraints, child: DirectReceivePage()), //直属领取//【0228】联盟计划 隐藏直属领取模块
                  ConstrainedBox(constraints: constraints, child: CommissionRatePage()),
                  //佣金比例
                  //11 0124.联盟计划 把注册子代理给删除【老板反馈】
                  // ConstrainedBox(
                  //     constraints: constraints, child: SubAgentPage(context: context)), //新增子代理
                ],
              );
            }),
          ),
        ),
        SizedBox(height: AppValues.barBottomHeight - AppValues.margin_12),
      ],
    );
  }
}
