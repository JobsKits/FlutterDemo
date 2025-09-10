import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/sport/sport_detail/view.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';

import '../../../../services/theme/theme_service.dart';
import '../../../../widget/custom_asset_icon.dart';
import '../../../../widget/status/load_state_config.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_model/sport_game_model.dart';
import '../../common_widget/custom_sport_outright_list_expend_widget.dart';
import '../../sport_event_ranking/sport_event_ranking_view.dart';
import '../../common_model/sport_outrihgt_api_model.dart';
import '../../common_widget/custom_sport_outrihgt_one_expend_widget.dart';
import '../bottom_rank/view.dart';
import 'sport_betting_logic.dart';
import 'sport_betting_state.dart';

///体育赛事-tab-冠军投注
class SportBettingPage extends StatelessWidget {
  SportBettingPage({Key? key, required this.pageTag, required this.params})
      : logic = Get.put<SportBettingLogic>(SportBettingLogic(params), tag: pageTag),
        // state = Get.find<SportBettingLogic>(tag: pageTag).state,
        super(key: key);

  final String pageTag;
  final SportBettingLogic logic;

  // final SportBettingState state;
  final SportOpenPageParams params;

  @override
  Widget build(BuildContext context) {
    return !logic.isLeagueOutright()
        ? _buildAreaOutrightExpendView()
        : _buildLeagueOutrightExpendView();
  }

  ///所有球种的冠军投注，包含地区
  _buildAreaOutrightExpendView() {
    return SingleChildScrollView(
      // physics: BouncingScrollPhysics(),
      // controller: ScrollController(),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const CustomAssetIcon(
                    size: 20,
                    name: "assets/images/sport/ic_sport_event_hot.webp",
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                    //热门 XX 冠军投注
                    '${S.current.sport_event_list_sort_hot} ${params.title} ${S.current.sport_champion}',
                    style: ThemeService()
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
          Obx(() {
            return CustomLoadStateLayout(
              configType: LoadStateConfigType.sport,
              configState: logic.areaOurRightPageHotStateObs.value,
              showEmptyRetry: false,
              showErrorRetry: false,
              configSuccess: Column(
                children: _buildAllAreaBettingView(logic.apiDataModelObs.value.hot),
              ),
            );
          }),

          ///"按字母顺序排序"
          Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const CustomAssetIcon(
                    size: 20,
                    name: "assets/images/sport/ic_sport_event_abc.webp",
                  ),
                  const SizedBox(width: 6),
                  CustomText(
                      '${S.current.sport_event_list_sort_ab} ${params.title} ${S.current.sport_champion}',
                      style: ThemeService()
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              )),
          Obx(() {
            return CustomLoadStateLayout(
              configType: LoadStateConfigType.sport,
              configState: logic.areaOurRightPageAllStateObs.value,
              showErrorRetry: false,
              showEmptyRetry: false,
              configSuccess: Column(
                children: _buildAllAreaBettingView(logic.apiDataModelObs.value.list),
              ),
            );
          }),
          // Column(
          //   children: _buildAllAreaBettingView(logic.apiDataModelObs.value.list),
          // ),
          _buildRankingTabView(),
        ],
      ),
    );
  }

  /// 某个联赛的 冠军投注
  _buildLeagueOutrightExpendView() {
    return Container(
      // height: 600,
      child: SingleChildScrollView(
        child: Column(
          // shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          children: [
            Obx(() {
              return CustomLoadStateLayout(
                configType: LoadStateConfigType.sport,
                configState: logic.leagueOurRightPageStateObs.value,
                showEmptyRetry: false,
                showErrorRetry: false,
                configSuccess: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logic.leagueOutrightModelObs.length,
                  itemBuilder: (context, index) {
                    var model = logic.leagueOutrightModelObs[index];
                    return OneLeagueOutrightExpendWidget(
                      model: model,
                      dataList: [],
                      clickCallBack: (model) =>
                          SportDetailPage.openPage(si: model.si, ci: model.ci, isChampion: true),
                    );
                  },
                ),
              );
            }),
            _buildRankingTabView(),
          ],
        ),
      ),
    );
  }

  ///体育赛事 内嵌的排行榜tabView，包括：所有投注、风云榜、竞赛排行榜
  _buildRankingTabView() {
    return BottomRankPage();
    return SportEventRankingPage();
  }

  ///所有地区 冠军投注 view
  List<Widget> _buildAllAreaBettingView(List<SportGameModel>? modelList) {
    if (modelList == null || modelList.isEmpty) {
      return [];
    }
    //第一个展开
    return modelList
        .map((model) => OneAreaOutrightExpendWidget(
              si: logic.sportId,
              ci: logic.pageParams.ci ?? "",
              openType: logic.pageParams.sportOpenType,
              model: model,
              isExpend: model == modelList.first,
              loadDataCallBack: (SportOutrightParams params) async {
                return await logic.getOutrightListData(
                  si: params.si,
                  pgid: params.pgid,
                  ci: params.ci,
                );
              },
              clickCallBack: (model) => SportDetailPage.openPage(si: model.si, ci: model.ci,ei: model.ei, isChampion: true),
              // isExpend: true,
            ))
        .toList();
  }
}
