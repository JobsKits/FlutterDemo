import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/dialog/custom_dialog_base_view.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/refresh/custom_prev_next_widget_num.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../../../widget/status/custom_load_state_view.dart';
import '../../alliance_plan/widget/custom_alliance_listpn_view.dart';
import '../../alliance_plan/widget/custom_alliance_search_widget.dart';
import '../../alliance_plan/widget/custom_select_widget.dart';
import 'activity_invite_detail_dialog_logic.dart';
import 'activity_invite_detail_view_item.dart';
import 'activity_invite_detail_view_title.dart';

///推广活动 邀请详情
class ActivityInviteDetailDialogWidget extends CustomDialogBaseView {
  ActivityInviteDetailDialogWidget({
    super.key,
    required this.pid,
    required this.coinId,
  });

  final String pid;
  final String coinId;
  late ActivityInviteDetailDialogLogic logic;

  @override
  StatefulElement createElement() {
    logic = Get.put<ActivityInviteDetailDialogLogic>(
        ActivityInviteDetailDialogLogic(pid: pid, coinId: coinId));
    return super.createElement();
  }

  @override
  void onCloseDialog() {
    super.onCloseDialog();
  }

  @override
  void onDeleteDialog() {
    super.onDeleteDialog();
    Get.delete<ActivityInviteDetailDialogLogic>();
  }

  ///打开对话框
  static void openDialog(String pid, String coinId) {
    GlobalStateController.of().showOverlayView(isShowBottomBarView: false, isShowTopBarView: false);
    CustomDialogBaseView.showDetailDialog(
        context: Get.overlayContext!,
        dialogView: ActivityInviteDetailDialogWidget(
          pid: pid,
          coinId: coinId,
        )).then((value) => GlobalStateController.of().showOverlayView());
  }

  @override
  String buildTitleAsset() {
    return "assets/images/activity/ic_activity_invite.webp";
  }

  @override
  String buildTitleLabel() {
    return S.current.random_text_917;
  }

  @override
  List<Widget> buildContentView() {
    return [
      _buildConditionView(),
      _buildContentListView(),
    ];
  }

  ///条件view
  Widget _buildConditionView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: CustomSelectWidget(
              borderShow: false,
              // width: 130,
              width: Get.width,
              panelRatio: 0.95,
              scaleAmin: false,
              modelList: logic.typeModelList,
              // initSelected: null,
              initSelected: 0,
              hintText: "",
              backgroundColor: Colors.white,
              selectColor: Colors.white,
              unselectColor: ThemeService().colorScheme.tertiary,
              selectColorFull: AppThemes.secondaryColor,
              onSelected: (index, model) {
                logic.collectParamsAndLoadData(type: model.data);
              },
              // rightIcon: CustomExpandIcon(onPressed: (bool value) {  } ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: CustomAllianceSearchWidget(
              borderShow: false,
              // width: 90,
              width: Get.width,
              hintText: S.current.random_text_551,
              callback: (input) {
                log('搜索回调...$input');
                logic.collectParamsAndLoadData(username: input.trim());
              },
            ),
          ),
        ],
      ),
    );
  }

  ///动态获取高度
  double getListHeight() {
    var height = logic.refreshController.getMeasureHeight(150)+100;

    if (height > Get.height * 0.8) {
      return Get.height * 0.8;
    } else {
      return height;
    }
  }

  ///列表view
  Widget _buildContentListView() {
    return Obx(() {
      return Container(
        // height: Get.height / 2.2,
        // height: 300,
        height: getListHeight(),
        padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        child: LayoutBuilder(builder: (_, constraints) {
          return CustomListViewSlideWidget(
            // itemCount: logic.modelListObs.length,
            // listWidthMax: logic.windowListWidthMax,
            listWidthMax: constraints.maxWidth,
            // listWidthMax: ActivityWidthConfig.invite().width,
            titleBuilder: (context) => const ActivityInviteDetailTitleView(),
            childBulider: (context, hCtrl, vCtrl) {
              return Obx(() {
                return CustomLoadStateLayout(
                  configState: logic.pageStateObs.value,
                  // configRetry: (pageState) => logic.loadNetData(isRefresh: true, isFirst: true),
                  configRetry: (pageState) =>
                      logic.loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true),
                  emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
                  showNetErrorRetry: false,
                  showEmptyRetry: false,
                  showErrorRetry: false,
                  showEmptyPrevNext: true,
                  // configPreLoad: const CustomPreLoadView(),
                  // showPreLoad: true,
                  configSuccess: CustomRefreshView(
                    controller: logic.refreshController,
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
                                // return  Container( child:  CustomText("dfsfd"),);
                                return ActivityInviteDetailItemView(
                                  index: index,
                                  model: logic.apiModelList[index],
                                );
                              }),
                          CustomPrevNextNumWidget(
                            hasPrevPage: logic.hasPrevPage,
                            hasNextPage: logic.hasNextPage,
                            curPage: logic.pnCurPage,
                            totalPage: logic.pnTotalPage,
                            // showWidget: logic.pnWidgetShow,
                            showWidget: true,
                            spaceMargin:10,
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
    });
  }
}
