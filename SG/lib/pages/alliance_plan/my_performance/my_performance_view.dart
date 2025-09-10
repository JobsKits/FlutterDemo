import 'dart:developer';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/refresh/custom_prev_next_widget.dart';
import '../../../widget/refresh/custom_prev_next_widget_num.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget/custom_alliance_condition_widget.dart';
import '../widget/custom_alliance_listpn_view.dart';
import '../widget/custom_alliance_page_widget.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../wmodel/alliance_condition_model.dart';
import 'my_performance_logic.dart';
import 'my_performance_view_item.dart';
import 'my_performance_view_title.dart';

///联盟计划-tab-我的业绩界面
class MyPerformancePage extends StatefulWidget {
  const MyPerformancePage({Key? key}) : super(key: key);

  @override
  State<MyPerformancePage> createState() => _MyPerformancePageState();
}

class _MyPerformancePageState extends State<MyPerformancePage> with AutomaticKeepAliveClientMixin {
  final logic = Get.put(MyPerformanceLogic());
  final state = Get.find<MyPerformanceLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<MyPerformanceLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        height: logic.refreshController.getMeasureHeight(350) + 150,
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          children: [
            // const SizedBox(height: AppValues.defaultPadding),
            _buildTopView(),
            _buildListView(),
            // _buildBottomView(),
          ],
        ),
      );
    });
  }

  _buildTopView() {
    return Obx(() {
      return CustomAllianceConditionWidget(
        conditionConfig: AllianceConditionConfig.myPerformance(),
        startTimeDefault: logic.conditionModel.defaultStartTime,
        endTimeDefault: logic.conditionModel.defaultEndTime,
        selectCoinList: logic.fLogic.selectCoinList,
        selectCoinDefault: logic.coinIndexObs.value,
        onAnyOneSelectedCallback: (dataOne, dataTwo, threeData) {
          log("条件选中...dataOne=${dataOne}...dataTwo=${dataTwo}...threeData=${threeData.toString()}");
          // logic.conditionModel.defaultEndTime = threeData.startTimeModel?.data;
          logic.collectParams(threeData);
          logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false);
        },
      );
    });
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
    //     CustomAllianceSearchWidget(
    //       hintText: "账号",
    //       callback: (data) => controller.onClickSearch(data),
    //     ),
    //   ],
    // );
  }

  _buildListView() {
    return Expanded(
      child: CustomListViewSlideWidget(
        // itemCount: controller.modelList.length,
        // listWidthMax: logic.windowListWidthMax,
        listWidthMax: AllianceWidthConfig.myPerformance().width,
        titleBuilder: (context) => MyPerformanceTitleView(
          onAnyOneSortCallback: (dataOne, dataTwo, threeData) {
            logic.collectSort(threeData);
            logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false, jumpPage: 1);
          },
        ),
        // itemBuilder: (BuildContext context, int index) {
        //   return MyPerformanceItemView(index: index, model: controller.modelList[index]);
        // },

        childBulider: (context, hCtrl, vCtrl) {
          return Obx(() {
            return CustomLoadStateLayout(
              configState: logic.pageStateObs.value,
              configRetry: (pageState) =>
                  logic.loadNetData(isRefreshOrPrev: true, isFirst: true, isShowLoad: true),
              emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
              showErrorRetry: false,
              showEmptyRetry: false,
              showNetErrorRetry: false,
              configSuccess: CustomRefreshView(
                controller: logic.refreshController,
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
                          padding: EdgeInsets.zero,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          // physics: const BouncingScrollPhysics(),
                          // controller: ScrollController(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: logic.apiModelList.length,
                          controller: vCtrl,
                          itemBuilder: (context, index) {
                            return MyPerformanceItemView(
                                index: index, model: logic.apiModelList[index]);
                          }),
                      CustomPrevNextNumWidget(
                        hasPrevPage: logic.hasPrevPage,
                        hasNextPage: logic.hasNextPage,
                        curPage: logic.pnCurPage,
                        totalPage: logic.pnTotalPage,
                        showWidget: logic.pnWidgetShow,
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
      ),
    );
  }

  _buildBottomView() {
    return CustomAlliancePageWidget(
      currentPage: logic.currentPage,
      callback: (next, page) => logic.onClickNextPage(page),
    );
  }
}
