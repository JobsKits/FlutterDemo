import 'package:flutter/material.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/betting_list/logic.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../front/widget/front_competition_view.dart';
import '../casino_rank/betting_casino_race_list_view.dart';
import '../casino_rank/betting_casino_rank_list_view.dart';
import '../common_model/betting_common_params.dart';

///投注 排行榜，包括： 所有投注、风云榜、竞赛排行榜
class CustomCasinoSportRankWidget extends StatefulWidget {
  const CustomCasinoSportRankWidget(
      {super.key, this.height,  this.controller,this.fromPageType});

  // final List<CompetitionBean>? competitonList;
  final double? height;
  final ScrollController? controller;
  final BettingFromPageType? fromPageType;

  @override
  State<CustomCasinoSportRankWidget> createState() => _CustomCasinoSportRankWidgetState();
}

class _CustomCasinoSportRankWidgetState extends State<CustomCasinoSportRankWidget>
    with SingleTickerProviderStateMixin {
  late TabController bottomTabController;
  final bottomTabs = [
    Tab(
      child: Text(S.current.all_bet,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: Text(S.current.billboard,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: <Widget>[
        Text(S.current.random_text_268,  style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
        ).paddingLeft(AppValues.halfPadding),
      ].toRow(),
    ),
  ].obs;

  @override
  void initState() {
    super.initState();
    bottomTabController = TabController(length: bottomTabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    bottomTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: widget.controller,
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        //列表 + tab
        height: widget.height ?? BettingCommonConfig.rankListDefaultHeight_10+ 64,
        child: Column(
          children: [
            _buildRankListTab(),
            Expanded(child: _buildRankListTabBarView()),
          ],
        ),
      ),
    );
  }

  ///tab 行
  _buildRankListTab() {
    return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppValues.padding_10,
          // vertical: AppValues.defaultMargin,
        ),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(49),
          // color: ThemeService().theme.colorScheme.surface, // 设置背景色
        ),
        //CustomTabBarCoveredIcon
        //CustomTabBarWithIcon
        child: CustomTabBarWithIcon(
          tabs: bottomTabs,
          tabController: bottomTabController,
          backgroundColor: ThemeService().theme.colorScheme.tertiary,
          radius: 25,
          height: 50,
          buttonMargin: const EdgeInsets.all(6),
          isShowScrollBar: true,
        )
        // child: CustomTabBarWithIcon(
        //   isLogin: true,
        //   tabController: logic.bottomTabController,
        //   // controller: controller.tabController,
        //   // 将TabController与TabBar关联
        //   tabs: logic.bottomTabs,
        //   backgroundColor: ThemeService().theme.colorScheme.tertiary,
        //   radius: 44,
        //   height: 54,
        //   buttonMargin: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 6),
        //   contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        // ),
        );
  }

  ///tab列表详情区域
  _buildRankListTabBarView() {
    return Container(
      // color: ThemeService().colorScheme.surface, // 设置背景色
      // padding: EdgeInsets.zero,
      child: LayoutBuilder(builder: (context, constraints) {
        // log("TabBarView...constraints...$constraints");
        return CustomAutoLayoutTabBarView(
          physics: const NeverScrollableScrollPhysics(), //禁止滑动
          controller: bottomTabController, // 将TabController与TabBarView关联
          children: [
            //所有投注 和 风云榜公用 界面
            //所有投注
            ConstrainedBox(
                constraints: constraints,
                child:  BettingCasinoRankListView(
                  bettingType: BettingTypeEnum.allBet,
                  // fromPage: BettingFromPageType.menuBettingCasinoType,
                  fromPage: widget.fromPageType,
                  isNeverScrollable: true,
                  // scrollController: logic.rankListScrollCtrl,
                )),
            //风云榜
            ConstrainedBox(
                constraints: constraints,
                child:  BettingCasinoRankListView(
                  bettingType: BettingTypeEnum.stormRanking,
                  // fromPage: BettingFromPageType.menuBettingCasinoType,
                  fromPage: widget.fromPageType,
                  isNeverScrollable: true,
                  // scrollController: logic.rankListScrollCtrl,
                )),
            // ConstrainedBox(
            //     constraints: constraints,
            //     child: FrontCompetitionView(
            //       listData: widget.competitonList ?? [],
            //     )),
            //竞赛排行榜
            ConstrainedBox(
                constraints: constraints,
                child: const BettingCasinoRaceListView(
                  chooseType: BettingTypeEnum.raceRanking,
                  fromPage: BettingFromPageType.sideMenuBettingCasinoType,
                  isNeverScrollable: true,
                )),
          ],
        );
      }),
    );
  }
}
