import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../base/getx/base_view.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_app_life_cycle_listen_widget.dart';
import '../betting_sport_logic.dart';
import '../widget/sport_bet_slip_tabbar.dart';
import 'sport_duplex_bet_view.dart';
import 'sport_single_bet_view.dart';

///体育投注单
class SportBetOrderView extends BaseView<BettingSportLogic> {
  SportBetOrderView({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget buildBody(BuildContext context) {
    return CustomAppLifeCycleListenWidget(
      didChangeDependencies: () {
        log("体育投注...投注订单...");
        // controller.loadSingleSportInfo();
        // controller.loadDuplexSportInfo();
        controller.reLoadSportBetInfo();
      },
      child: Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.centerLeft,
              child: SportBetSlipTabbar(
                tabController: controller.tabController,
                tabs: controller.state.tabs,
                onTap: controller.onTabChanged,
              ),
            ),
            _buildLine(),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  ///单项投注
                  SportSingleBetView(),

                  ///复式投注
                  SportDuplexBetView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildLine() {
  return Container(
    width: double.infinity,
    height: 2,
    color: ThemeService().theme.colorScheme.tertiary,
  );
}
