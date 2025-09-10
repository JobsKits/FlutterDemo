import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../widget/betting_list/logic.dart';
import 'sport_event_ranking_state.dart';

class SportEventRankingLogic extends GetxController  with GetTickerProviderStateMixin {
  final SportEventRankingState state = SportEventRankingState();
  late TabController tabController;//所有投注、风云榜、竞赛排行榜
  late List<Tab> tabs;
  //一共有11
  static final tabLabel = [
    S.current.all_bet,
    S.current.billboard,
    S.current.race_leaderboard,
  ];


  @override
  void onInit() {
    super.onInit();
    tabs = tabLabel
        .map((label) => Tab(child: Text(label, style: ThemeService().theme.textTheme.bodyMedium)))
        .toList();
    tabController = TabController(length: tabs.length, initialIndex: 0, vsync: this);


  }

}
