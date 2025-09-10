import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/widget/ranking_list.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/widget/tab.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/widgets/logic.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/widgets/view.dart';
import 'package:flutter_bet/pages/front/widget/front_competition_view.dart';
import 'package:get/get.dart';

import 'index.dart';

/*
Tab数据类型
我的投注/所有投注/风云榜/竞赛排行榜
* */
enum RankingTabType { myBets, allBets, highRollers, raceLeaderboard }

/// 我的投注/所有投注/风云榜.....
class RankingListWidget extends GetView<RankingListController> {
  // 复用标识
  final String tag;
  //
  final BuildContext context;
  // 所需展示类型
  final List<RankingTabType> tabInfos;

  const RankingListWidget(
    this.tag,
    this.context, {
    super.key,
    this.tabInfos = const [
      RankingTabType.myBets,
      RankingTabType.allBets,
      RankingTabType.highRollers,
      RankingTabType.raceLeaderboard
    ],
  });

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => RankingListController());
    return GetBuilder<RankingListController>(
      init: RankingListController(),
      tag: tag,
      id: "RankingListPage",
      builder: (_) {
        return buildBottomRankListTab();
      },
    );
  }

  Widget buildBottomRankListTab() {
    final GlobalStateController global = Get.find<GlobalStateController>();

    return <Widget>[
      const SizedBox(height: AppValues.defaultPadding),
      // tab
      RankingListTab(
        key: controller.viewKey,
        tabInfos: tabInfos,
        selType: controller.selType,
        isLogin: global.isLogin.value,
        tabController: controller.tabC,
        callback: (type) {
          controller.isLoading = true;
          controller.tabDidSelIndexAction(type);
        },
      ).marginSymmetric(horizontal: AppValues.defaultPadding),
      const SizedBox(height: AppValues.largePadding),

      // 我的投注 / 所有投注 / 风云榜
      if (controller.selType != RankingTabType.raceLeaderboard)
        RankingList(
          lTitle: S.current.random_text_220copy,
          rTitle: S.current.home_game,
          infos: controller.infos[controller.selType.index],
          isLoading: controller.isLoading,
          firstTransparent: controller.firstTransparent,
          callBack: (BigWinsModel model) {
            controller.onItemClick(context, model);
          },
        ).paddingHorizontal(AppValues.defaultPadding),

      // 竞赛排行版
      RankListCompetitionPage()
          .visibility(controller.selType == RankingTabType.raceLeaderboard),
      const SizedBox(height: AppValues.largePadding),
    ].toColumn().constrained(minHeight: 300);
  }
}
