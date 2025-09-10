import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:get/get.dart';
import '../../../../constant/app_values.dart';
import '../../../../generated/l10n.dart';
import '../../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../find/widget/casino_tabbar.dart';
import 'index.dart';
import 'widgets/index.dart';

class BottomRankPage extends GetView<BottomRankController> {
  const BottomRankPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomRankController>(
      init: BottomRankController(),
      id: "bottom_rank",
      builder: (_) {
        return buildBottomRankListTab();
      },
    );
  }

  //创建底部切换排行榜
  Widget buildBottomRankListTab() {
    return <Widget>[
      CasinoTabBar(
        tabs: controller.bottomTabs,
        tabController: controller.bottomTabController,
        onTap: controller.onTapBottomRankList,
      ).paddingTop(AppValues.defaultPadding * 2),
      CustomAutoLayoutTabBarView(controller: controller.bottomTabController, children: [
        // 所有投注
        Obx(() => RankView(
          lTitle: S.current.random_text_286,
          rTitle: S.current.random_text_220,
          infos: controller.list1,
          isLoading: controller.isLoading.value,
          firstTransparent: controller.firstTransparent,
        ).paddingHorizontal(AppValues.defaultPadding)),
        // 风云榜
        Obx(() => RankView(
          lTitle: S.current.random_text_286,
          rTitle: S.current.random_text_220,
          infos: controller.list2,
          isLoading: controller.loadRank.value,
          firstTransparent: controller.firstTransparent,
        ).paddingHorizontal(AppValues.defaultPadding)),
        // 竞赛排行版
        CompetitionView(),
      ]).paddingTop(AppValues.defaultPadding)
    ].toColumn();
    // return ;
  }
}
