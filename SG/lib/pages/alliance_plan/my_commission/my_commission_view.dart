import 'dart:developer';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bet/pages/alliance_plan/alliance_plan_logic.dart';
import 'package:flutter_bet/pages/alliance_plan/my_commission/my_commission_view_item.dart';
import 'package:flutter_bet/widget/row/custom_row_expanded_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/preload/custom_preload_item_view.dart';
import '../../../widget/refresh/custom_prev_next_widget_num.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget/custom_alliance_condition_widget.dart';
import '../widget/custom_alliance_listpn_view.dart';
import '../widget/custom_alliance_page_widget.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../widget/custom_select_model.dart';
import '../wmodel/alliance_common_params.dart';
import '../wmodel/alliance_condition_model.dart';
import 'my_commission_logic.dart';
import 'my_commission_view_title.dart';

///联盟计划-tab-我的佣金界面
class MyCommissionPage extends StatefulWidget {
  const MyCommissionPage({Key? key}) : super(key: key);

  @override
  State<MyCommissionPage> createState() => _MyCommissionPageState();
}

class _MyCommissionPageState extends State<MyCommissionPage> with AutomaticKeepAliveClientMixin {
  // final controllerFather = Get.find<AlliancePlanLogic>();
  final logic = Get.put(MyCommissionLogic());
  final state = Get.find<MyCommissionLogic>().state;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    Get.delete<MyCommissionLogic>();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    logic.currentContext = context;
    // return CustomScrollView(
    //   physics: NeverScrollableScrollPhysics(),
    //   slivers: [
    //     SliverToBoxAdapter(child: _buildTopView()),
    //     SliverFillRemaining(child: _buildListView()),
    //   ],
    // );
    return Obx(() {
      return Container(
        // padding: EdgeInsets.symmetric(horizontal: AppValues.defaultPadding),
        // width: ,
        height: logic.refreshController.getMeasureHeight(350)+150,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // const SizedBox(height: AppValues.defaultPadding),
            // _buildTopViewUp(),
            // _buildTopViewDown(),
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
      conditionConfig: AllianceConditionConfig.myshowCommission(),
      startTimeDefault: logic.conditionModel.defaultStartTime,
      endTimeDefault: logic.conditionModel.defaultEndTime,
      selectTypeList: logic.fLogic.selectTypeListObs,
      selectTypeDefault: 0,
      selectCoinList: logic.fLogic.selectCoinList,
      selectCoinDefault: 0,
      commission: 0.00,
      onAnyOneSelectedCallback: (dataOne, dataTwo, threeData) {
        log("条件选中...dataOne=${dataOne}...dataTwo=${dataTwo}...threeData=${threeData.toString()}");
        logic.collectParams(threeData);
        logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false, jumpPage: 1);
      },
    );
  }

  _buildListView() {
    return Expanded(
      child: LayoutBuilder(builder: (_, constraints) {
        return CustomListViewSlideWidget(
          // itemCount: logic.modelListObs.length,
          // listWidthMax: logic.windowListWidthMax,
          listWidthMax: AllianceWidthConfig.myCommission().width,
          titleBuilder: (context) => const MyCommissionTitleView(),
          // itemBuilder: (BuildContext context, int index) {
          //   return MyCommissionItemView(index: index, model: logic.modelListObs[index]);
          // },
          childBulider: (context, hCtrl, vCtrl) {
            return Obx(() {
              return CustomLoadStateLayout(
                configState: logic.pageStateObs.value,
                // configRetry: (pageState) => logic.loadNetData(isRefresh: true, isFirst: true),
                configRetry: (pageState) =>
                    logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true),
                // configPreLoad: const CustomPreLoadView(),
                // showPreLoad: true,
                emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
                showErrorRetry: false,
                showEmptyRetry: false,
                showNetErrorRetry: false,
                configSuccess: CustomRefreshView(
                  controller: logic.refreshController,
                  // clipBehavior: Clip.none,
                  physics: const NeverScrollableScrollPhysics(),
                  // physics: const ClampingScrollPhysics(),
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
                            // physics: const ClampingScrollPhysics(),
                            // physics: const BouncingScrollPhysics(),
                            // controller: ScrollController(),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: logic.apiModelList.length,
                            controller: vCtrl,
                            itemBuilder: (context, index) {
                              return MyCommissionItemView(
                                index: index,
                                model: logic.apiModelList[index],
                                onClickDetail: (model) => logic.onClickLookDetail(model),
                              );
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
        );
      }),
    );
  }
}
