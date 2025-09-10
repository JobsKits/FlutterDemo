import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../generated/l10n.dart';
import '../../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../../widget/custom_divider_widget.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../common_helper/betting_width_config.dart';
import '../common_model/betting_common_params.dart';
import 'betting_casino_race_list_logic.dart';
import 'betting_casino_race_list_view_item.dart';
import 'betting_casino_race_list_view_time.dart';
import 'betting_casino_race_list_view_title.dart';

///娱乐城 的 竞赛列表
class BettingCasinoRaceListView extends StatefulWidget {
  const BettingCasinoRaceListView({
    super.key,
    required this.chooseType,
    this.fromPage,
    this.isNeverScrollable = false, //不滚动，不分页，只是加载页数据
    this.scrollController,
    this.tag,
  });

  ///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  final BettingTypeEnum chooseType;
  final BettingFromPageType? fromPage;
  final bool isNeverScrollable;
  final ScrollController? scrollController;
  final dynamic tag;

  @override
  State<BettingCasinoRaceListView> createState() => _BettingCasinoRaceListViewState();
}

class _BettingCasinoRaceListViewState extends State<BettingCasinoRaceListView>
    with AutomaticKeepAliveClientMixin {
  late BettingCasinoRaceListLogic logic;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    //todo:避免上层调用者 使用CustomScrollView 回刷新BettingCasinoRankListView
    logic = Get.put<BettingCasinoRaceListLogic>(
        BettingCasinoRaceListLogic(bettingType: widget.chooseType, fromPage: widget.fromPage),
        tag: widget.tag ?? DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return _buildShimmerView();
    return CustomAppLifeCycleListenWidget(
      didChangeDependencies: () {
        // logic.getCasinoRecord();
        log("娱乐城投注...排行版...BettingCasinoRaceListView...");
        // log("娱乐城投注...排行版...BettingCasinoRaceListView...${logic.diffShowObs.value}");
        // log("娱乐城投注...排行版...BettingCasinoRaceListView...${S.current.random_text_553}");
        // log("娱乐城投注...排行版...BettingCasinoRaceListView...${S.current.random_text_554}");
        logic.diffTimeLogic();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: Column(
          children: [
            Obx(() {
              return BettingCasinoRaceListTimeView(endLabel: logic.diffShowObs.value);
            }),
            const CustomDividerWidget(),
            Expanded(
              child: CustomListViewSlideWidget(
                listWidthMax: BettingWidthConfig.race().width,
                titleBuilder: (context) {
                  return BettingCasinoRaceListTitleView();
                },
                childBulider: (context, hCtrl, vCtrl) {
                  return _buildListView();
                },
              ),
            ),
          ],
        ),

        // child: Column(
        //   children: [
        //     Obx(() {
        //       return BettingCasinoRaceListTitleView(endLabel: logic.diffShowObs.value);
        //     }),
        //     Expanded(child: _buildListView()),
        //   ],
        // ),
      ),
    );
  }

  _buildListView() {
    return Container(
      child: Obx(() {
        return CustomLoadStateLayout(
          configState: logic.pageStateObs.value,
          configRetry: (pageState) => logic.loadNetData(isRefresh: true, isShowLoad: true),
          showEmptyRetry: true,
          showErrorRetry: true,
          showNetErrorRetry: true,
          loadingCenter: false,
          configSuccess: widget.isNeverScrollable
              ? ListView(
                  padding: EdgeInsets.zero,
                  controller: widget.scrollController,
                  primary: false,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: logic.apiModelList
                      .asMap()
                      .entries
                      .map((e) => BettingCasinoRaceListItemView(index: e.key, model: e.value))
                      .toList(),
                  // logic.apiModelList
                  //     .map((e) => BettingCasinoListItemView(index: 0, model: e))
                  //     .toList(),
                )
              : CustomRefreshView(
                  scrollController: widget.scrollController,
                  controller: logic.refreshController,
                  // clipBehavior: Clip.none,
                  refreshOnStart: false,
                  isCanRefresh: !widget.isNeverScrollable,
                  // isCanLoadMore: !widget.isNeverScrollable,
                  isCanLoadMore: false,
                  onRefreshAction: (refreshController) {
                    logic.loadNetData(isRefresh: true, isShowLoad: false);
                  },
                  onLoadMoreAction: (refreshController) {
                    logic.loadNetData(isRefresh: false, isShowLoad: false);
                    // setState(() {
                    // log("加载更多刷新了...");
                    // });
                  },
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      primary: false,
                      // physics: const BouncingScrollPhysics(),
                      physics: const NeverScrollableScrollPhysics(),
                      controller: widget.scrollController,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: logic.apiModelList.length,
                      // controller: vCtrl,
                      itemBuilder: (context, index) {
                        return BettingCasinoRaceListItemView(
                            index: index, model: logic.apiModelList[index]);
                      }),
                ),
        );
      }),
    );
  }
}
