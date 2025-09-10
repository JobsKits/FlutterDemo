import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/bet_list/widget/bet_list_bar.dart';
import 'package:flutter_bet/pages/bet_list/widget/sport_my_bet_activity.dart';
import 'package:flutter_bet/pages/bet_list/widget/sport_my_bet_done.dart';

import '../../services/theme/theme_service.dart';
import '../../widget/app_bar/custom_app_bar.dart';
import '../betting/sport/widget/sport_bet_slip_tabbar.dart';
import 'bet_list_logic.dart';

///投注界面[]
class BetListPage extends BaseView<BetListLogicTwo> {
  BetListPage({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return CustomAppBar(
      titleView: BetListBar(),
      showLeading: true,
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            alignment: Alignment.centerLeft,
            child: SportBetSlipTabbar(
              tabController: controller.myBetTabController,
              tabs: controller.state.myBetTabs,
            ),
          ),
          _buildLine(),
           Expanded(
             child: TabBarView(
                controller: controller.myBetTabController,
                children: [
                  SportMyBetActivity(),
                  SportMyBetDone(),
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
