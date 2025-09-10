import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../services/theme/theme_service.dart';
import '../../common_model/betting_common_params.dart';
import '../widget/sport_bet_slip_tabbar.dart';
import 'betting_sport_mybet_logic.dart';
import 'sport_bet_mine_list_billed_view.dart';
import 'sport_bet_mine_list_unbill_view.dart';

///体育模块 下 我的投注
///被公用的页面， 在首页菜单 我的投注、首页菜单投注单、个人中心的 体育投注
class BettingSportMyBetView extends StatefulWidget {
  BettingSportMyBetView(
      {super.key, required this.fromPage, this.isShowTab = true, this.tabIndex = 0, this.padding});

  ///主要是给 首页菜单 的 我的投注 页面使用， 因为该页面 是隐藏tab的， 通过其他方式来切换不同的tab页面
  final bool isShowTab;
  int tabIndex;
  final EdgeInsetsGeometry? padding; //适配h5, 菜单的投注单 和 浏览的我的投注

  final BettingFromPageType fromPage;

  @override
  State<BettingSportMyBetView> createState() => _BettingSportMyBetViewState();
}

class _BettingSportMyBetViewState extends State<BettingSportMyBetView> {
  final BettingSportMyBetLogic logic = Get.put<BettingSportMyBetLogic>(BettingSportMyBetLogic());
  final tabIndexObs = 0.obs;

  @override
  void initState() {
    super.initState();
    ever(tabIndexObs, (value) => logic.myBetTabController.animateTo(tabIndexObs.value));
  }

  @override
  Widget build(BuildContext context) {
    tabIndexObs.value = widget.tabIndex;
    return Container(
      height: double.infinity,
      padding: widget.padding ?? EdgeInsets.zero,
      child: Column(
        children: [
          Visibility(
            visible: widget.isShowTab,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.centerLeft,
              child: SportBetSlipTabbar(
                tabController: logic.myBetTabController,
                tabs: logic.myBetTabs,
              ),
            ),
          ),
          Visibility(visible: widget.isShowTab, child: _buildLine()),
          Expanded(
            child: TabBarView(
              controller: logic.myBetTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                ///未结算
                SportBetMineUnBillView(
                  fromPage: widget.fromPage,
                  isShowTab: widget.isShowTab,
                ),

                ///已结算
                SportBetMineBilledView(
                  fromPage: widget.fromPage,
                  isShowTab: widget.isShowTab,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLine() {
    return Container(
      width: double.infinity,
      height: 2,
      color: ThemeService().theme.colorScheme.tertiary,
    );
  }
}
