import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/widget/button/custom_button.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/app_values.dart';
import '../../../model/yulecheng/big_wins_model.dart';
import '../../../model/yulecheng/casino_record_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/custom_app_life_cycle_listen_widget.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../common_model/betting_common_params.dart';
import 'betting_casino_rank_list_logic.dart';
import 'betting_casino_rank_list_view_item.dart';
import 'betting_casino_rank_list_view_title.dart';
import '../casino/betting_casino_mybet_list_logic.dart';
import '../casino/custom_casino_mybet_title_view.dart';

///娱乐城 的 所有投注、风云榜 共用list页面
class BettingCasinoRankListView extends StatefulWidget {
  // List<CasinoRecordModel> listData;
  // final ParamSingleCallback<CasinoRecordModel> callback;

  const BettingCasinoRankListView({
    super.key,
    required this.bettingType,
    this.fromPage,
    this.isNeverScrollable = false, //不滚动，不分页，只是加载页数据
    this.scrollController,
    this.tag,
  });

  ///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  final BettingTypeEnum bettingType;
  final BettingFromPageType? fromPage;
  final bool isNeverScrollable;
  final ScrollController? scrollController;
  final dynamic tag;

  // final BettingFromPageType? fromPageType; //为了适配不同入口的 我的投注， 以及国际化翻译的不同

  @override
  State<BettingCasinoRankListView> createState() => _BettingCasinoRankListViewState();
}

class _BettingCasinoRankListViewState extends State<BettingCasinoRankListView>
    with AutomaticKeepAliveClientMixin {
  late BettingCasinoRankListLogic logic;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    log("BettingCasinoRankListView...initState()...hashCode:${widget.hashCode}");
    //todo:避免上层调用者 使用CustomScrollView 回刷新BettingCasinoRankListView
    logic = Get.put<BettingCasinoRankListLogic>(
        BettingCasinoRankListLogic(bettingType: widget.bettingType, fromPage: widget.fromPage),
        tag: widget.tag ?? DateTime.now().toString());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // return _buildShimmerView();
    return CustomAppLifeCycleListenWidget(
      didChangeDependencies: () {
        // logic.getCasinoRecord();
        log("娱乐城投注...排行版...");
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        child: Column(
          children: [
            BettingCasinoListTitleView(fromPageType: widget.fromPage),
            Expanded(child: _buildListView()),
          ],
        ),
      ),
    );
    // return CustomAppLifeCycleListenWidget(
    //   didChangeDependencies: () {
    //     logic.getCasinoRecord();
    //     log("娱乐城投注...我的投注...");
    //   },
    //   child: Obx(() {
    //     return logic.isLoading.value
    //         ? _buildShimmerView()
    //         : (logic.isError.value ? _buildNoDataView() : _buildContent());
    //   }),
    // );
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
                      .map((e) => CustomButton(
                          padding: EdgeInsets.zero,
                          onTap: () {
                            //我的投注 or  所有投注可以 弹窗
                            return logic.onItemClick(context, logic.apiModelList[e.key]);
                          },
                          child: BettingCasinoListItemView(index: e.key, model: e.value)))
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
                        return CustomButton(
                          padding: EdgeInsets.zero,
                          onTap: () {
                            //我的投注 or  所有投注可以 弹窗
                            return logic.onItemClick(context, logic.apiModelList[index]);
                          },
                          child: BettingCasinoListItemView(
                              index: index, model: logic.apiModelList[index]),
                        );
                      }),
                ),
        );
      }),
    );
  }

  // 骨架屏效果
  Widget _buildShimmerView() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 8,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: index % 2 == 0
                        ? ThemeService().theme.colorScheme.surfaceVariant
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5)),
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _childShimmerView(w: 20, radius: 90, leftMargin: 5),
                    _childShimmerView(w: 80, rightMargin: 70),
                    _childShimmerView(),
                    _childShimmerView(w: 20, radius: 90, rightMargin: 5),
                  ],
                ),
              ),
            );
          }),
    );
  }

  // _buildContent() {
  Widget _buildNoDataView() {
    return Container(
      height: Get.height -
          AppBar().preferredSize.height -
          AppValues.sportHeight_20 -
          AppValues.sportHeight_153,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(height: AppValues.sportHeight_153),
            Image.asset(
              // 'assets/images/sport/sport_nodata.webp',
              'assets/images/status/ic_status_view_empty.webp',
              height: AppValues.sportIcon_112,
              width: AppValues.sportIcon_112,
            ),
            const SizedBox(height: AppValues.sportHeight_16),
            CustomText(
              S.current.random_text_221,
              style: ThemeService().textTheme.bodyMedium?.copyWith(
                    color: Color(0xFFB1BAD3),
                  ),
            ),
            const SizedBox(height: 5),
            // GestureDetector(onTap:(){
            //   logic.state.activityLoading.value=false;
            //   logic.loadActivityInfo(0);
            // },child:
            InkWell(
                onTap: () {
                  logic.onClickEmptyBettingToHome(widget.fromPage);
                },
                child: CustomText(S.current.betting_casino_begin_game)),
          ],
        ),
      ),
    );
  }

  _childShimmerView(
      {double w = 140,
      double h = 20,
      double radius = 3,
      double leftMargin = 0,
      double rightMargin = 0}) {
    return Shimmer.fromColors(
        baseColor: AppThemes.chatRooCardColor,
        highlightColor: AppThemes.textColorLightGrey,
        // baseColor: AppThemes.textColorSecondary,
        // highlightColor: AppThemes.textColorWhite,
        child: Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              color: AppThemes.chatRooCardColor, borderRadius: BorderRadius.circular(radius)),
          margin: EdgeInsets.only(left: leftMargin, right: rightMargin),
        ));
  }
}
