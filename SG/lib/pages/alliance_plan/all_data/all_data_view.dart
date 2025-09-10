import 'dart:developer';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/refresh/custom_prev_next_widget_num.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../alliance_plan_logic.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget/custom_alliance_condition_widget.dart';
import '../widget/custom_alliance_listpn_view.dart';
import '../widget/custom_alliance_page_widget.dart';
import '../widget/custom_alliance_search_widget.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../widget/custom_select_widget.dart';
import '../wmodel/alliance_condition_model.dart';
import 'all_data_logic.dart';
import 'all_data_view_item.dart';
import 'all_data_view_item_total.dart';
import 'all_data_view_title.dart';

///联盟计划-tab-所有数据
class AllDataPage extends StatefulWidget {
  const AllDataPage({Key? key}) : super(key: key);

  @override
  State<AllDataPage> createState() => _AllDataPageState();
}

class _AllDataPageState extends State<AllDataPage> with AutomaticKeepAliveClientMixin {
  // final controllerFather = AlliancePlanLogic.of();
  final logic = Get.put(AllDataLogic());
  final state = Get.find<AllDataLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<AllDataLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        // padding: EdgeInsets.only(bottom: AppValues.barTopBottomHeight),
        height: logic.refreshController.getMeasureHeight(350)+150,
        child: CustomScrollView(
          // mainAxisSize: MainAxisSize.max,
          physics: const NeverScrollableScrollPhysics(),
          // physics: const ClampingScrollPhysics(),
          // physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            // const SizedBox(height: AppValues.defaultPadding),
            // _buildTopView(),
            // _buildListView(),
            SliverToBoxAdapter(child: _buildTopView()),
            SliverFillRemaining(child: _buildListView()),
          ],
        ),
      );
    });
  }

  _buildTopView() {
    return CustomAllianceConditionWidget(
      conditionConfig: AllianceConditionConfig.allData(),
      startTimeDefault: logic.conditionModel.defaultStartTime,
      endTimeDefault: logic.conditionModel.defaultEndTime,
      selectCoinList: logic.fLogic.selectCoinList,
      selectCoinDefault: 0,
      // selectTypeList: controllerFather.selectTypeList,
      onAnyOneSelectedCallback: (dataOne, dataTwo, threeData) {
        log("条件选中...dataOne=${dataOne}...dataTwo=${dataTwo}...threeData=${threeData.toString()}");
        logic.collectParams(threeData);
        logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false);
      },
    );
    // return Row(
    //   // mainAxisSize: MainAxisSize.max,
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     CustomSelectWidget(
    //       width: 210,
    //       modelList: controller.selectTimeList,
    //       initSelected: 0,
    //       hintText: "选择时间",
    //       onSelected: (index, model) {},
    //     ),
    //     CustomAllianceSearchWidget(),
    //   ],
    // );
  }

  _buildListView() {
    return CustomListViewSlideWidget(
      // vCtrl: widget.scrollController,
      // itemCount: controller.modelList.length,
      // listWidthMax: logic.windowListWidthMax,
      listWidthMax: AllianceWidthConfig.allData().width,
      // physics: const ClampingScrollPhysics(),
      physics: const AlwaysScrollableScrollPhysics(),
      titleBuilder: (context) => AllDataTitleView(
        onAnyOneSortCallback: (dataOne, dataTwo, threeData) {
          logic.collectSort(threeData);
          logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false, jumpPage: 1);
          // logic.refreshController.callRefresh();
        },
      ),
      // itemBuilder: (BuildContext context, int index) {
      //   return AllDataItemView(index: index, model: controller.modelList[index]);
      // },
      childBulider: (context, hCtrl, vCtrl) {
        return Obx(() {
          return CustomLoadStateLayout(
            configState: logic.pageStateObs.value,
            configRetry: (pageState) =>
                logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true),
            emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
            showErrorRetry: false,
            showEmptyRetry: false,
            showNetErrorRetry: false,
            configSuccess: CustomRefreshView(
              controller: logic.refreshController,
              // physics: const ClampingScrollPhysics(),
              physics: const NeverScrollableScrollPhysics(),
              // clipBehavior: Clip.none,
              refreshOnStart: false,
              isCanRefresh: false,
              isCanLoadMore: false,
              onRefreshAction: (refreshController) {
                logic.loadNetData(isRefreshOrPrev: true, isShowLoad: false);
              },
              onLoadMoreAction: (refreshController) {
                logic.loadNetData(isRefreshOrPrev: false, isShowLoad: false);
              },
              child: CustomMeasureSizeWidget(
                onChange: (size) {
                  logic.refreshController.measureHeight = size.height;
                },
                child: CustomAllianceListPnView(
                  children: [
                    ListView.builder(
                        // physics: const ClampingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        // primary: false,
                        // clipBehavior: Clip.hardEdge,
                        // physics: const BouncingScrollPhysics(),
                        // physics: const ClampingScrollPhysics(),
                        physics: const NeverScrollableScrollPhysics(),
                        // controller: ScrollController(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: logic.apiModelList.length,
                        controller: vCtrl,
                        itemBuilder: (context, index) {
                          var model = logic.apiModelList[index];
                          if (!model.isTotalItem) {
                            return AllDataItemView(index: index, model: model);
                          } else {
                            return AllDataTotalItemView(index: index, model: model);
                          }
                        }),
                    CustomPrevNextNumWidget(
                      hasPrevPage: logic.hasPrevPage,
                      hasNextPage: logic.hasNextPage,
                      curPage: logic.pnCurPage,
                      totalPage: logic.pnTotalPage,
                      // showWidget: logic.pnWidgetShow,
                      showWidget: true,
                      onClickPrevPage: () {
                        logic.loadNetData(isRefreshOrPrev: true, isShowLoad: false);
                      },
                      onClickNextPage: () {
                        logic.loadNetData(isRefreshOrPrev: false, isShowLoad: false);
                      },
                      onClickJumpPage: (jumpPage) {
                        logic.loadNetData(
                            isRefreshOrPrev: false, isShowLoad: false, jumpPage: jumpPage);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  _buildBottomView() {
    return CustomAlliancePageWidget(currentPage: logic.currentPage);
  }
}
