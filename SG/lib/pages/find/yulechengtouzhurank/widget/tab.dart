import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/tab_bar/custom_tab_bar_with_icon.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

import '../view.dart';

/// 排行榜 Tabbar 选择器
class RankingListTab extends StatelessWidget {
  final List<RankingTabType> tabInfos;
  final RankingTabType selType;
  final bool isLogin;

  /// 选中回调
  final Function(RankingTabType)? callback;

  final TabController? tabController;

  RankingListTab({
    super.key,
    required this.tabInfos,
    required this.selType,
    required this.isLogin,
    this.callback,
    this.tabController,
  });

  final colorScheme = ThemeService().colorScheme;
  final titleStyle =
      ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context) {

    final tabs = initTabs();

    return DefaultTabController(
      length: tabs.length,
      initialIndex: tabInfos.indexOf(selType),

      child: CustomTabBarWithIcon(
        tabController: tabController,
        labelStyle:
            ThemeService().theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        tabs: tabs,
        backgroundColor: ThemeService().theme.colorScheme.tertiary,
        radius: AppValues.sportRadius_23,
        height: 44,
        buttonMargin: const EdgeInsets.all(5),
        prohibits: isLogin ? [] : [0],
        onTap: ((index) {
          final indexType = tabInfos[index];
          indexType == selType ? null : callback?.call(indexType);
        }),
      ),
    ).backgroundColor(ThemeService().colorScheme.surface).height(54).clipRRect(all: 40);
  }



  List<Tab> initTabs() {

    final allTabTitles = [
      S.current.sport_tabbar_mybet,
      S.current.all_bet,
      S.current.billboard,
      S.current.random_text_268
    ];

    final List<Tab> tabs = [];
    for (int index = 0; index < tabInfos.length; index++) {
      final textStyle = ThemeService().theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: (index == 0 && !isLogin)
              ? CustomTextColorStyle.grey.value
              : CustomTextColorStyle.white.value);

      final tab = Tab(
          child: <Widget>[
            Text(allTabTitles[index], style: textStyle),
            Container(
              width: 8,
              height: 8,
              color: ThemeService().colorScheme.primaryContainer,
            ).clipRRect(all: 4).paddingLeft(AppValues.halfPadding)
                .visibility(tabInfos[index] == RankingTabType.raceLeaderboard)
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center));

      tabs.add(tab);
    }

    return tabs;
  }


}
