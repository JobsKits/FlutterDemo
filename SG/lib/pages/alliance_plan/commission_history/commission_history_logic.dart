import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:get/get.dart';

import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/time/time_format.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../sport/common_model/sport_handicap_api_model.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../widget/custom_select_model.dart';
import '../wmodel/alliance_commission_type_api_model.dart';
import 'commission_history_api_model.dart';
import 'commission_history_model.dart';
import 'commission_history_state.dart';

class CommissionHistoryLogic extends BaseController
    with CustomRefreshStateMixinHelper, CustomPrevNextMixin {
  final CommissionHistoryState state = CommissionHistoryState();

  final modelList = <CommissionHistoryModel>[].obs;

  ///佣金类型类型选择范围
  CustomSelectModel defaultSelectModel = CustomSelectModel(S.current.random_text_188, data: '');
  final List<CustomSelectModel> selectTypeListObs = <CustomSelectModel>[
    // defaultSelectModel,
    // CustomSelectModel("全部类型",data: ''),
    // CustomSelectModel("佣金转账",data: '845'),
    // CustomSelectModel("佣金发放",data: '845'),
    // CustomSelectModel("佣金提现",data: '845'),
    // CustomSelectModel("佣金兑换",data: '845'),
  ];

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <CommissionHistoryApiModel>[]).obs;

  ///自定义方便取数据
  List<CommissionHistoryApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();

    //初始化 参数, 默认选中第一个
    collectParams(type: selectTypeListObs[0]);
    loadNetData(isRefreshOrPrev: true, isFirst: true);
    loadCommissionTypeNetData();
  }

  //默认前后一天
  // final DateTime? defaultStartTime = DateTime.now().subtract(const Duration(days: 30)); //获取前一天数据
  // final DateTime? defaultEndTime = DateTime.now();

  DateTime? defaultStartTime =
      DateTime.parse(DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.start.formatter))
          .toUtc();
  DateTime? defaultEndTime =
      DateTime.parse(DateUtil.formatDate(DateTime.now(), format: TimeFormatterEnum.end.formatter))
          .toUtc();
  String startTimeParam = "";
  String endTimeParam = "";
  String typeParam = "";

  ///初始化数据
  void initData() {
    selectTypeListObs.clear();
    selectTypeListObs.add(defaultSelectModel);
  }

  ///收集参数
  void collectParams(
      {CustomSelectModel? startTime, CustomSelectModel? endTime, CustomSelectModel? type}) {
    //[开始时间] 先判断是否手动选中
    if (startTime != null && startTime.data != null) {
      startTimeParam = DateUtil.formatDate(startTime.data, format: DateFormats.full);
    } else if (startTime == null && startTimeParam.isEmpty) {
      startTimeParam = DateUtil.formatDate(defaultStartTime, format: DateFormats.full);
    }

    //[结束时间] 先判断是否手动选中
    if (endTime != null && endTime.data != null) {
      endTimeParam = DateUtil.formatDate(endTime.data, format: DateFormats.full);
    } else if (endTime == null && endTimeParam.isEmpty) {
      endTimeParam = DateUtil.formatDate(defaultEndTime, format: DateFormats.full);
    }

    //如果有更新数据
    if (type != null && type.data != null) {
      typeParam = type.data;
    }
  }

  ///请求网络数据
  void loadNetData({
    required bool isRefreshOrPrev,
    int? jumpPage,
    bool isShowLoad = true,
    bool isFirst = false,
  }) async {
    pnWidgetShow = !isShowLoad;
    showLoading(isFirst);
    await ApiService.instance.getCommissionHistory(
      page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      page_size: pageModelObs.value.curPageSize,
      start_time: startTimeParam,
      end_time: endTimeParam,
      cash_type: typeParam,
      success: (PageCommonModel<CommissionHistoryApiModel> resultData) {
        //模拟数据
        // var demoList =
        //     List.generate(10, (index) => CommissionHistoryApiModel(username: "name$index")).toList();
        // resultData.content = demoList;
        // resultData.resultPageNeedSize = 10;
        // resultData.resultPageSize = 10;
        // resultData.total = 34;

        // pageModelObs.value.copyWith(resultData, isRefreshOrPrev);
        // log("佣金历史api...上层...${pageModelObs.value.toString()}");
        // pageModelObs.refresh();
        // successFinish(isRefreshOrPrev, pageModelObs.value, refreshController);

        //todo:0611.兼容几把上下页
        refreshPnPage(pageModelObs.value, resultData,
            prevPage: isRefreshOrPrev, jumpPage: jumpPage);
        pageModelObs.refresh();
        successFinish(isRefreshOrPrev, pageModelObs.value, refreshController);
      },
      fail: (bool isConnect, String? message, candy) {
        failFinish(isConnect, isRefreshOrPrev, isFirst, refreshController);
      },
    );
  }

  ///获取联盟计划-佣金类型 - 下拉框
  Future<bool> loadCommissionTypeNetData() async {
    await ApiService.instance.getCommissionType(
      success: (List<CommissionTypeApiModel> dataList) {
        if (dataList.isNotEmpty) {
          var targetList = <CustomSelectModel>[];
          var tempList = dataList
              .map((model) => CustomSelectModel(model.cashTypeName ?? '', data: model.cashType))
              .toList();
          targetList.add(defaultSelectModel);
          targetList.addAll(tempList);
          selectTypeListObs.assignAll(targetList);
        }
      },
      fail: (isConnect, message, candy) {
        log('佣金类型异常：$message');
      },
    );

    return true;
  }

  //改方法随时可调用
  Future<List<CustomSelectModel>> getGameType() async {
    //如果数据为空，等待加载完毕
    if (selectTypeListObs.isEmpty) {
      await loadCommissionTypeNetData();
    }
    return selectTypeListObs;
    // return Future.value([]);
  }
}
