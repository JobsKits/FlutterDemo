import 'dart:developer';

import 'package:flutter/material.dart';
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
import 'direct_finance_logic.dart';
import 'dirent_finance_model.dart';
import 'dirent_finance_view_item.dart';
import 'dirent_finance_view_title.dart';

///联盟计划-tab-直属财务
class DirectFinancePage extends StatefulWidget {
  const DirectFinancePage({Key? key}) : super(key: key);

  @override
  State<DirectFinancePage> createState() => _DirectFinancePageState();
}

class _DirectFinancePageState extends State<DirectFinancePage> with AutomaticKeepAliveClientMixin {
  // final controllerFather = Get.find<AlliancePlanLogic>();
  final logic = Get.put(DirectFinanceLogic());

  final state = Get
      .find<DirectFinanceLogic>()
      .state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<DirectFinanceLogic>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Obx(() {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        height: logic.refreshController.getMeasureHeight(350)+150,
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
    return CustomAllianceConditionWidget(
      conditionConfig: AllianceConditionConfig.directFinance(),
      startTimeDefault: logic.conditionModel.defaultStartTime,
      endTimeDefault: logic.conditionModel.defaultEndTime,
      selectCoinList: logic.fLogic.selectCoinList,
      selectCoinDefault: 0,
      onAnyOneSelectedCallback: (dataOne, dataTwo, threeData) {
        log("条件选中...dataOne=${dataOne}...dataTwo=${dataTwo}...threeData=${threeData.toString()}");
        logic.collectParams(threeData);
        logic.loadNetData(isRefreshOrPrev: true, isFirst: true, jumpPage: 1);
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
    return Expanded(
      child: CustomListViewSlideWidget(
        // itemCount: controller.modelList.length,
        // listWidthMax: logic.windowListWidthMax,
        listWidthMax: AllianceWidthConfig
            .directFinance()
            .width,
        titleBuilder: (context) =>
            DirectFinanceTitleView(
              onAnyOneSortCallback: (dataOne, dataTwo, threeData) {
                logic.collectSort(threeData);
                logic.loadNetData(isRefreshOrPrev: true, isFirst: true, jumpPage: 1);
              },
            ),
        // itemBuilder: (BuildContext context, int index) {
        //   return DirectFinanceItemView(index: index, model: controller.modelList[index]);
        // },
        childBulider: (context, hCtrl, vCtrl) {
          return Obx(() {
            return CustomLoadStateLayout(
              configState: logic.pageStateObs.value,
              configRetry: (pageState) => logic.loadNetData(isRefreshOrPrev: true, isFirst: true),
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
                  logic.loadNetData(isRefreshOrPrev: true);
                },
                onLoadMoreAction: (refreshController) {
                  logic.loadNetData(isRefreshOrPrev: false);
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
                            // return DirectReceiveIt vvemView(index: index, model: controller.modelList[index]);
                            return DirectFinanceItemView(
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
    return CustomAlliancePageWidget(currentPage: logic.currentPage);
  }
}
