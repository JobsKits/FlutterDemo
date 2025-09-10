import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_mybet_list_view.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_view.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/auto_layout_tab_bar_view/custom_auto_layout_tabbar_widget.dart';
import '../../../widget/bottom/custom_close_button.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_Keep_alive_wrapper.dart';
import '../../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/tab_bar/custom_tab_bar_with_icon.dart';
import '../../front/widget/front_competition_view.dart';
import '../../main/code.dart';
import '../../main/logic.dart';
import '../casino_rank/betting_casino_race_list_view.dart';
import '../casino_rank/betting_casino_rank_list_view.dart';
import '../common_model/betting_common_params.dart';
import '../common_widget/bet_slip_bar.dart';
import 'betting_casino_logic.dart';

///娱乐城投注单, 给首页底部中间菜单的【投注】使用
class BettingCasinoPage extends BaseView<BettingCasinoLogic> {
  BettingCasinoPage({super.key});

  final logic = Get.put<BettingCasinoLogic>(BettingCasinoLogic());
  final state = Get.find<BettingCasinoLogic>().state;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    logic.buildData();
    return CustomAppBar(
      titleView: Obx(() {
        return Row(
          children: [
            BetSlipBar(
              modelType: 0,
              chooseBetSlipTypeModel: logic.chooseTypeModelObs.value,
              betSlipTypeList: logic.casinoTypeListObs,
              onChange: (chooseBetSlipType) {
                log('娱乐城...chooseBetSlipType...${chooseBetSlipType.toString()}');
                logic.chooseTypeModelObs.value = chooseBetSlipType;
              },
              myBetCount: 0,
              betSlipCount: 0,
            ),
            Spacer(),
            CustomCloseButton(onTap: () {
              RouteUtil.popView();
              MainLogic.of().onMenuSelected(MenuCode.GAME);
            }),
          ],
        );
      }),
      showLeading: false,
    );
  }

  Widget? bodyWidget;

  @override
  Widget buildBody(BuildContext context) {
    return CustomAppLifeCycleListenWidget(
      didChangeDependencies: () {
        // controller.getCasinoRecord();
        log("娱乐城投注...BettingCasinoPage...");
      },
      child: Stack(
        children: [
          ///我的投注
          Visibility(
            visible: logic.chooseTypeModelObs.value.type == BettingTypeEnum.myBet,
            child: BettingCasinoMyBetListView(
              chooseType: BettingTypeEnum.myBet,
              fromPage: BettingFromPageType.mainMenuBettingCasinoType,
              isNeverScrollable: false,
            ),
          ),

          ///所有投注
          Visibility(
            visible: logic.chooseTypeModelObs.value.type == BettingTypeEnum.allBet,
            child: BettingCasinoRankListView(
              bettingType: BettingTypeEnum.allBet,
              fromPage: BettingFromPageType.mainMenuBettingCasinoType,
              isNeverScrollable: false,
              tag: logic.allPageTag,
            ),
          ),

          ///风云榜
          Visibility(
            visible: logic.chooseTypeModelObs.value.type == BettingTypeEnum.stormRanking,
            // child: FrontSportCompetitionView(
            //   listData: controller.betSportList,
            //   isNeverScrollable: false,
            // ),
            child: BettingCasinoRankListView(
              // listData: controller.betSportList,
              isNeverScrollable: false,
              bettingType: BettingTypeEnum.stormRanking,
              fromPage: BettingFromPageType.mainMenuBettingCasinoType,
              tag: logic.stormPageTag,
            ),
          ),

          ///竞赛排行榜
          Visibility(
            visible: logic.chooseTypeModelObs.value.type == BettingTypeEnum.raceRanking,
            child: Container(
              // padding: const EdgeInsets.symmetric(vertical: 12),
              //FrontCompetitionView

              child: BettingCasinoRaceListView(
                isNeverScrollable: false,
                chooseType: BettingTypeEnum.stormRanking,
                fromPage: BettingFromPageType.mainMenuBettingCasinoType,
                tag: logic.racePageTag,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
