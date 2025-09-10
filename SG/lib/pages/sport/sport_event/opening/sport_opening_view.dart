import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/sport/sport_event/sport_event_logic.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:flutter_bet/widget/status/load_state_config.dart';
import 'package:get/get.dart';

import '../../../../constant/app_themes.dart';
import '../../../../generated/l10n.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../widget/sport/custom_sport_expand/custom_sport_expand.dart';
import '../../../../widget/sport/custom_sport_odd_type.dart';
import '../../../alliance_plan/widget/custom_select_widget.dart';
import '../../common_helper/sport_width_config.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_model/sport_game_model.dart';
import '../../common_model/sport_handicap_select_model.dart';
import '../../common_widget/custom_sport_opening_list_expend_widget.dart';
import '../../sport_detail/model.dart';
import '../../sport_detail/view.dart';
import '../../sport_event_ranking/sport_event_ranking_view.dart';
import '../../common_widget/custom_sport_opening_one_expend_widget.dart';
import '../../common_widget/custom_sport_handicap_select_widget.dart';
import '../bottom_rank/view.dart';
import 'sport_opening_logic.dart';

///体育赛事-tab-滚球盘与即将开赛盘口
class SportOpeningPage extends StatelessWidget {
  ///强制给 标记来区分 重复的页面
  SportOpeningPage({Key? key, required this.pageTag, required this.params})
      : logic = Get.put<SportOpeningLogic>(SportOpeningLogic(params), tag: pageTag),
        // state = Get.find<SportOpeningLogic>(tag: pageTag).state,
        super(key: key);
  final String pageTag;
  final SportOpeningLogic logic;

  // final SportOpeningState state;
  final SportOpenPageParams params;
  late int sportId;

  @override
  Widget build(BuildContext context) {
    sportId = params.si;
    return !logic.isSportLeague() ? _buildAllAreaContentView() : _buildOneLeagueContentView();
  }

  ///盘口 下拉框
  _buildTopSelect() {
    return Row(
      children: [
        //CustomSportHandicapSelectWidget
        Obx(() {
          return CustomSelectWidget(
            width: SportWidthConfig.handicap().width,
            initSelected: logic.handicapTypeIndexObs.value,
            // scaleAmin: logic.showRetry.value,
            hintText: "",
            panelRatio: 0.9,
            backgroundColor: Colors.white,
            borderShow: false,
            // selectColor: Colors.white,
            // unselectColor: ThemeService().colorScheme.tertiary,
            // selectColorFull: AppThemes.secondaryColor,
            selectColor: AppThemes.secondaryColor,
            unselectColor: ThemeService().colorScheme.tertiary,
            modelList: logic.handicapTypeListObs,
            onSelected: (index, model) {
              logic.handicapTypeObs.value = model;
            },
          );
        }),
      ],
    );
  }

  ///所有地区联赛
  _buildAllAreaContentView() {
    return SingleChildScrollView(
      child: ListView(
        // children: [..._buildAllExpendView()],
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildTopSelect(),

          ///热门
          // Offstage(
          //   offstage: logic.apiDataModel.value.hot.isEmpty,
          //   child:
          // ),
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
                    // S.current.sport_event_list_sort_hot, //"热门"
                    '${S.current.sport_event_list_sort_hot} ${params.title}',
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
              configState: logic.areaPageHotStateObs.value,
              showEmptyRetry: false,
              // showNetErrorRetry: false,
              showErrorRetry: logic.showRetry.value,
              configRetry: (pageState) => logic.requestDataAndStartTimer(),
              configSuccess: Column(
                children: _buildAllExpendView(logic.apiDataModel.value.hot),
              ),
            );
          }),

          ///所有 "按字母顺序排序"
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
                    //"按字母顺序排序"
                    '${S.current.sport_event_list_sort_ab} ${params.title}',
                    style: ThemeService()
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              )),
          // ..._buildAllExpendView(logic.apiDataModel.value.list),
          Obx(() {
            return CustomLoadStateLayout(
              configType: LoadStateConfigType.sport,
              configState: logic.areaPageAllStateObs.value,
              showEmptyRetry: false,
              // showNetErrorRetry: false,
              showErrorRetry: logic.showRetry.value,
              configRetry: (pageState) => logic.requestDataAndStartTimer(),
              configSuccess: Column(
                children: _buildAllExpendView(logic.apiDataModel.value.list),
              ),
            );
          }),
          _buildRankingTabView(),
        ],
      ),
    );
  }

  _buildAllExpendView(List<SportGameModel> modelList) {
    return modelList.map((itemModel) {
      ///某个联赛的 expend view
      return CustomSportOpeningListExpendWidget(
        sportId: sportId,
        gameModel: itemModel,
        // isExpend: itemModel == logic.openingSportList.first,
        isExpend: itemModel == modelList.first,
        handicapType: logic.handicapTypeObs.value.data,
        sportBetClick: (SportClikType type, int? section, int? row, int colum, int si, String eid) {
          log("点击了...进入赛事详情...地区赛事...");
          if (type == SportClikType.detail) {
            SportDetailPage.openPage(si: si, ci: eid, isChampion: false);
          }
        },
        section: 1,
        onItemExpend: (SportGameParams params) async {
          var tempData = <SportMatchModel>[];
          await logic.getListData(params).then((dataList) {
            tempData = dataList;
          });
          return tempData;
        },
      );
    }).toList();
  }

  ///体育赛事 内嵌的排行榜tabView，包括：所有投注、风云榜、竞赛排行榜
  _buildRankingTabView() {
    return BottomRankPage();
    return SportEventRankingPage();
    // return CustomBettingRankWidget(competitonList: []);
  }

  ///联赛的 滚球与即将开赛的盘口 列表
  _buildOneLeagueContentView() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildTopSelect(),
          const SizedBox(height: AppValues.margin_12),
          Obx(() {
            return CustomLoadStateLayout(
              configType: LoadStateConfigType.sport,
              configState: logic.leaguePageStateObs.value,
              showEmptyRetry: false,
              showErrorRetry: logic.showRetry.value,
              configRetry: (pageState) => logic.requestDataAndStartTimer(),
              configSuccess: CustomSportOpeningOneExpendWidget(
                modelList: logic.openingSportList,
                title:
                    logic.openingSportList.isNotEmpty ? logic.openingSportList.first.cn ?? "" : '',
                sportBetClick: (type, section, row, colum, si, eid) {
                  log("点击了...进入赛事详情...单个赛事...");
                  if (type == SportClikType.detail) {
                    SportDetailPage.openPage(si: si, ci: eid, isChampion: false);
                  }
                },
                isExpend: true,
                handicapType: logic.handicapTypeObs.value.data,
              ),
            );
          }),
          const SizedBox(height: AppValues.defaultMargin),
          _buildRankingTabView(),
        ],
      ),
    );
  }

  _buildExpendViewTest() {
    return LayoutBuilder(builder: (context, constraints) {
      log("constraints...$constraints");
      return Container(
        height: 600,
        child: SingleChildScrollView(
          // controller: ScrollController(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            children: [
              ...List.generate(
                  20,
                  (index) => CustomSportExpand(
                          isExpanded: false,
                          title: Text("${S.current.random_text_494}$index"),
                          children: [
                            Container(height: 50, color: Colors.red),
                            Container(height: 100, color: Colors.green),
                            Container(height: 200, color: Colors.blue),
                          ])).toList(),
              _buildRankingTabView(),
            ],
          ),
        ),
      );
    });
  }
}
