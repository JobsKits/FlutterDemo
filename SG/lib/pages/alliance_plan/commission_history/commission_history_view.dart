import 'dart:developer';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_view.dart';
import 'package:flutter_bet/pages/alliance_plan/widget/custom_select_time_widget.dart';
import 'package:flutter_bet/widget/status/custom_load_state_view.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';
import '../../../constant/app_values.dart';
import '../../../routes/routes.dart';
import '../../../services/lang_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/date_util.dart';
import '../../../utils/route_util.dart';
import '../../../utils/time/time_format.dart';
import '../../../widget/app_bar/custom_app_bar.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/measure/custom_measure_size_widget.dart';
import '../../../widget/refresh/custom_prev_next_widget_num.dart';
import '../../../widget/refresh/custom_refresh_view.dart';
import '../../../widget/row/custom_row_expanded_widget.dart';
import '../../../widget/scroller/custom_listview_slide_widget.dart';
import '../whepler/Alliance_width_config.dart';
import '../widget/custom_alliance_listpn_view.dart';
import '../widget/custom_select_model.dart';
import '../widget/custom_select_time_two_widget.dart';
import '../widget/custom_select_widget.dart';
import '../widget_cell/alliance_item_cell_widget.dart';
import 'commission_history_logic.dart';
import 'commission_history_view_item.dart';

///联盟计划-佣金历史
class CommissionHistoryPage extends StatelessWidget {
  CommissionHistoryPage({Key? key}) : super(key: key);

  final logic = Get.find<CommissionHistoryLogic>();
  final state = Get.find<CommissionHistoryLogic>().state;

  CustomSelectModel? startTimeModel;
  CustomSelectModel? endTimeModel;

  static const int maxDays = 90;
  final _minEndTime =
      Rxn<DateTime>(DateTime.now().toLocal().subtract(const Duration(days: maxDays)));
  final _maxEndTime = Rxn<DateTime>(DateTime.now().toLocal());

  //默认时间 or 动态显示时间
  final _startTimeDefault = Rxn<DateTime>(); //默认开始时间
  final _endTimeDefault = Rxn<DateTime>(); //默认结束时间

  ///打开页面
  static openPage() {
    RouteUtil.pushToView(Routes.personalCommissionHistory);
  }

  // @override
  // PreferredSizeWidget? appBar(BuildContext context) {
  //   return null;
  //   return CustomAppBar(
  //     appBarTitleText: S.current.random_text_517,
  //     showLeading: true,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        // padding: const EdgeInsets.symmetric(horizontal: AppValues.defaultMargin),
        height: getListHeight(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: AppValues.defaultMargin),
            _buildTimeSelectView(),
            const SizedBox(height: AppValues.defaultMargin),
            _buildTypeSelectView(),
            // _buildListTitle(),
            Expanded(child: _buildListView()),
            // _buildListView(),
            // SizedBox(height: AppValues.margin_40),
          ],
        ),
      );
    });
  }

  _buildTimeSelectView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        CustomText(
          S.current.random_text_518,
          style: ThemeService().textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        SizedBox(height: AppValues.margin_4),
        Row(
          children: [
            //【0229需求变更】【app】联盟计划，时间筛选，分开始时间和结束时间两个框
            // 开始时间
            Expanded(
                flex: 1,
                child: CustomSelectTimeWidget(
                  timeUtc: true,
                  borderShow: false,
                  width: 120,
                  hintText: S.current.sport_event_list_begin_time,
                  defaultTime: logic.defaultStartTime,
                  minTime: DateTime.now().toLocal().subtract(const Duration(days: 2000)),
                  maxTime: DateTime.now().toLocal(),
                  // defaultTime: _startTimeDefault.value,
                  timeFormatter: TimeFormatterEnum.start,
                  onSelected: (dataOne, dataTwo) {
                    log('start时间选择器回调数据...${dataTwo.toString()}');
                    startTimeModel = dataTwo;
                    _endTimeDefault.value = startTimeModel?.data;
                    var endDateTime =
                        dealMaxEndTime(dataTwo.data, endTimeModel?.data ?? logic.defaultEndTime);
                    if (endTimeModel == null) {
                      endTimeModel = CustomSelectModel(endDateTime.toString(), data: endDateTime);
                    } else {
                      endTimeModel?.label = endDateTime.toString();
                      endTimeModel?.data = endDateTime;
                    }
                    //转换成 utc,查询
                    startTimeModel = copyWithUtc(startTimeModel!);
                    _doOnSelected(startTimeModel, endTimeModel);
                    log("_endTimeDefault...${_endTimeDefault.value}");
                  },
                )),
            SizedBox(width: AppValues.largeMargin),
            // 结束时间
            Expanded(
              flex: 1,
              child: Obx(() {
                return CustomSelectTimeWidget(
                  timeUtc: true,
                  borderShow: false,
                  width: 120,
                  hintText: S.current.random_text_550,
                  // defaultTime: widget.endTimeDefault,
                  // defaultTime: conditionModel.startTimeModel?.data,
                  defaultTime: _endTimeDefault.value ?? logic.defaultEndTime,
                  // defaultTime: logic.defaultEndTime,
                  minTime: _minEndTime.value,
                  maxTime: _maxEndTime.value,
                  timeFormatter: TimeFormatterEnum.end,
                  onSelected: (dataOne, dataTwo) {
                    log('end时间选择器回调数据...${dataTwo.toString()}');
                    // "start_time": "2024-01-21 00:00:00",
                    // "end_time": "2024-01-23 23:59:59",
                    //针对 结束时间做特殊处理
                    // String? dealEndTime =DateUtil.formatDate(dataTwo, format: 'yyyy-MM-dd 23:59:59');
                    // DateTime.parse(DateUtil.formatDate(dataTwo, format: 'yyyy-MM-dd 23:59:59'));
                    // conditionModel.endTimeModel = dataTwo;
                    //转换成 utc,查询
                    endTimeModel = copyWithUtc(dataTwo);
                    // _doOnSelected(conditionModel);
                    _doOnSelected(startTimeModel, endTimeModel);
                  },
                );
              }),
            ),
            // CustomSelectTimeTwoWidget(
            //     // width: 125,
            //     borderShow: false,
            //     // startHintText: '开始日期',
            //     // endHintText: '结束日期',
            //     defaultStartTime: logic.defaultStartTime,
            //     defaultEndTime: logic.defaultEndTime,
            //     onSelected: (dataOne, dataTwo) {
            //       logic.collectParams(startTime: dataOne, endTime: dataTwo);
            //       logic.loadNetData(isRefresh: true, isFirst: true);
            //     }),
          ],
        ),
      ],
    );
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          flex: 6,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                S.current.random_text_518,
                style: ThemeService().textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: AppValues.margin_4),
              CustomSelectTimeTwoWidget(
                  // width: 125,
                  borderShow: false,
                  // startHintText: '开始日期',
                  // endHintText: '结束日期',
                  defaultStartTime: logic.defaultStartTime,
                  defaultEndTime: logic.defaultEndTime,
                  onSelected: (dataOne, dataTwo) {
                    logic.collectParams(startTime: dataOne, endTime: dataTwo);
                    logic.loadNetData(isRefreshOrPrev: true, isFirst: true);
                  }),
            ],
          ),
        ),
        // Spacer(),
        SizedBox(width: AppValues.margin_4),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                S.current.random_text_519,
                style: ThemeService().textTheme.labelLarge?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: AppValues.margin_4),
              CustomSelectWidget(
                // width: 150,
                // itemHeight: LangService().isChinese ? 80 : 42,
                //国际化适配， 中文默认即可
                borderShow: false,
                initSelected: 0,
                scaleAmin: false,
                modelList: logic.selectTypeListObs,
                panelRatio: LangService().isChinese ? 0.9 : 1.6,
                dxWidth: LangService().isChinese ? 0.0 : -35,
                arrowBasisOffset: LangService().isChinese ? 0.0 : 35.0,
                backgroundColor: Colors.white,
                selectColor: Colors.white,
                unselectColor: ThemeService().colorScheme.tertiary,
                selectColorFull: AppThemes.secondaryColor,
                onSelected: (dataOne, dataTwo) {
                  logic.collectParams(type: dataTwo);
                  logic.loadNetData(isRefreshOrPrev: true, isFirst: true);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildTypeSelectView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          S.current.random_text_519,
          style: ThemeService().textTheme.labelLarge?.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppValues.margin_4),
        CustomSelectWidget(
          width: Get.width,
          // itemHeight: LangService().isChinese ? 80 : 42,
          //国际化适配， 中文默认即可
          textAlign: TextAlign.left,
          borderShow: false,
          initSelected: 0,
          scaleAmin: false,
          modelList: logic.selectTypeListObs,

          // panelRatio:0.5,
          panelRatio: LangService().isChinese ? 0.42 : 0.75,
          // dxWidth: LangService().isChinese ? 0.0 : -35,
          // arrowBasisOffset: LangService().isChinese ? 0.0 : 35.0,
          backgroundColor: Colors.white,
          // selectColor: ThemeService().colorScheme.tertiary,
          selectColor: AppThemes.secondaryColor,
          unselectColor: ThemeService().colorScheme.tertiary,
          // selectColorFull: Colors.white,
          onSelected: (dataOne, dataTwo) {
            logic.collectParams(type: dataTwo);
            logic.loadNetData(isRefreshOrPrev: true, isFirst: true);
          },
        ),
      ],
    );
  }

  _buildListTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(
        // horizontal: AppValues.defaultMargin,
        // vertical: AppValues.defaultMargin,
        horizontal: AppValues.halfPadding,
        vertical: AppValues.padding_16,
      ),
      child: CustomRowExpandedWidget(
        // mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        expanded: AllianceWidthConfig.history().expends,
        children: [
          Center(
            child: AllianceItemCellWidget(S.current.random_text_128, isTitle: true),
          ),
          Center(
            child: AllianceItemCellWidget(S.current.vault_amount, isTitle: true),
          ),
          Center(
            child: AllianceItemCellWidget(S.current.random_text_520, isTitle: true),
          ),
          Center(
            // alignment: Alignment.centerRight,
            child: AllianceItemCellWidget(S.current.random_text_521, isTitle: true),
          ),
        ],
      ),
    );
  }

  final ScrollController vScroll = ScrollController();

  ///动态获取高度
  double getListHeight() {
    var height = logic.refreshController.getMeasureHeight(350) + 150;
    var maxHeight = Get.height - AppValues.barTopBottomHeightMargin;
    if (height > maxHeight) {
      return maxHeight;
    } else {
      return height;
    }
  }

  _buildListView() {
    return CustomListViewSlideWidget(
      listWidthMax: AllianceWidthConfig.history().width,
      titleBuilder: (context) => _buildListTitle(),
      childBulider: (context, hCtrl, vCtrl) {
        return Obx(() {
          return CustomLoadStateLayout(
            configState: logic.pageStateObs.value,
            configRetry: (pageState) => logic.loadNetData(isRefreshOrPrev: true, isFirst: true),
            emptyImage: "assets/images/status/ic_status_view_empty0dp.webp",
            showNetErrorRetry: false,
            showEmptyRetry: false,
            showErrorRetry: false,
            showEmptyPrevNext: true,
            configSuccess: CustomRefreshView(
              controller: logic.refreshController,
              // clipBehavior: Clip.none,
              refreshOnStart: false,
              isCanRefresh: false,
              isCanLoadMore: false,
              // scrollController: vScroll,
              onRefreshAction: (refreshController) {
                log("上下拉组件...触发刷新...");
                logic.loadNetData(isRefreshOrPrev: true);
              },
              onLoadMoreAction: (refreshController) {
                log("上下拉组件...触发更多...");
                logic.loadNetData(isRefreshOrPrev: false);
              },
              child: CustomMeasureSizeWidget(
                onChange: (size) {
                  logic.refreshController.measureHeight = size.height;
                },
                child: CustomAllianceListPnView(
                  children: [
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      // primary: false,
                      shrinkWrap: true,
                      itemCount: logic.apiModelList.length,
                      scrollDirection: Axis.vertical,
                      // controller: vScroll,
                      itemBuilder: (context, index) {
                        return CommissionHistoryItemView(
                            index: index, model: logic.apiModelList[index]);
                      },
                    ),
                    CustomPrevNextNumWidget(
                      hasPrevPage: logic.hasPrevPage,
                      hasNextPage: logic.hasNextPage,
                      curPage: logic.pnCurPage,
                      totalPage: logic.pnTotalPage,
                      showWidget: logic.pnWidgetShow,
                      // showWidget: true,
                      spaceMargin: 16,
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

  /// 结束时间组件， 最小 和 最大 范围控制
  /// 返回需要更新查询的 endTime
  DateTime dealMaxEndTime(DateTime startTime, DateTime? endTime) {
    var dataTimeNow = DateTime.parse(
        DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.end.formatter));
    var currentEndTime = endTime ?? dataTimeNow;

    // 开始时间与结束时间的距离
    var inDays = startTime.difference(currentEndTime).inDays;
    // 开始时间距离现在时间的距离，为了结束时间控制在90天之内
    int inDaysNow = startTime.difference(dataTimeNow).inDays;
    var showEndTime;
    log("currentEndTime...$currentEndTime");
    log("inDays...$inDays,,,inDaysNow....$inDaysNow");
    if (inDays <= -maxDays) {
      //比如<=-90
      _minEndTime.value = startTime;
      _maxEndTime.value = startTime.add(const Duration(days: maxDays));
      _endTimeDefault.value = _maxEndTime.value;
      showEndTime = _maxEndTime.value;
    } else if (inDays >= 0) {
      //两种情况： =1，=0  等于或者超过结束时间
      // "start_time": "2024-01-21 00:00:00",
      // "end_time": "2024-0121 23:59:59",
      //这种情况inDays == 0
      _minEndTime.value = startTime;
      //结束时间自动延后
      _maxEndTime.value =
          inDaysNow.abs() >= maxDays ? startTime.add(const Duration(days: maxDays)) : dataTimeNow;
      _endTimeDefault.value = startTime;
      showEndTime = startTime;
    } else {
      //在合理的90天之内
      // _maxEndTime.value = DateTime.now();
      // _minEndTime.value = startTime;
      //结束时间自动延后
      _minEndTime.value = startTime;
      _maxEndTime.value =
          inDaysNow.abs() >= maxDays ? startTime.add(const Duration(days: maxDays)) : dataTimeNow;
      ;
      _endTimeDefault.value = currentEndTime;
      showEndTime = currentEndTime;
    }
    return DateTime.parse(
        DateUtil.formatDate(showEndTime, format: TimeFormatterEnum.end.formatter));
  }

  ///转换成 utc, 因为后端 存储 是utc+0, 在执行搜索时，需要转换成utc+0，显示不用
  CustomSelectModel copyWithUtc(CustomSelectModel model) {
    var dateTimeUtc =
        DateUtil.getDateTimeByMs((model.data as DateTime).millisecondsSinceEpoch, isUtc: true);
    var timeModelUtc = CustomSelectModel(model.label, type: model.type, data: dateTimeUtc);
    // log("model...${model.toString()}");
    // log("timeModelUtc...${timeModelUtc.toString()}");
    return timeModelUtc;
  }

  ///任意 一个选中执行回调
  _doOnSelected(CustomSelectModel? startTime, CustomSelectModel? endTime) {
    logic.collectParams(startTime: startTime, endTime: endTime);
    logic.loadNetData(isRefreshOrPrev: true, isFirst: true);
  }
}
