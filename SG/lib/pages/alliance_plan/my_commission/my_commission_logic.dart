import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/widgets.dart';
import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/pages/alliance_plan/whepler/alliance_biz_mixin.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/date_util.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../alliance_plan_logic.dart';
import '../widget/custom_select_model.dart';
import '../wmodel/alliance_common_params.dart';
import '../wmodel/alliance_condition_model.dart';
import 'my_commission_api_model.dart';
import 'my_commission_model.dart';
import 'my_commission_state.dart';

///联盟计划-tab-我的佣金界面
class MyCommissionLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin, CustomPrevNextMixin {
  final MyCommissionState state = MyCommissionState();

  ///窗口列表可是最大框宽度
  // final double windowListWidthMax = Get.width * 1.3;
  final double windowListWidthMax =
      GlobalStateController.of().isChinese() ? Get.width * 1.3 : Get.width * 2.5;
  final currentPage = 1.obs; //当第几页, 默认1为第一页
  BuildContext? currentContext; //当前view的context

  ///所有数据集合
  // final modelAllList =<MyCommissionModel>[];
  final Map<int, List<MyCommissionModel>> modelAllList = {};

  ///当前页集合
  final modelListObs = <MyCommissionModel>[].obs;
  int indexTest = 0;

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, curPageSize: 5, first: true, content: <MyCommissionApiModel>[]).obs;

  ///自定义方便取数据
  List<MyCommissionApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // loadListData(1);
    // loadListDataNew();
    loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true, preload: false);
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局
  void loadNetData({
    required bool isRefreshOrPrev,
    int? jumpPage,
    bool isShowLoad = true,
    bool isFirst = false,
    bool preload = false,
  }) async {
    pnWidgetShow = !isShowLoad;
    showLoading(isShowLoad, isFirst, preload);
    // await Future.delayed(Duration(seconds: 3), () => null);
    await ApiService.instance.getMyCommission(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      // page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      page: getPnRequestIndex(pageModelObs.value, prevPage: isRefreshOrPrev, jumpPage: jumpPage),
      page_size: pageModelObs.value.curPageSize,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      currency_id: conditionModel.getCoin(),
      model_id: conditionModel.getType(),
      // username:conditionModel.getSearchWord(),
      success: (PageCommonModel<MyCommissionApiModel> resultData) {
        // pageModelObs.value.copyWith(resultData, isRefreshOrPrev);
        // pageModelObs.refresh();
        // log("我的佣金api...上层...${pageModelObs.toString()}");
        // successFinish(isRefreshOrPrev, pageModelObs.value, refreshController);
        //todo:0612兼容几把上下页
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

  ///加载列表数据；
  ///page 目标加载页码，不要传currentPage++ 或--，因为是虚拟的临时页码，加载成功失败才取改变currentPage的值；
  ///page 从1开始
  void loadListData(int targetPage) {
    ///集合有数据 且 请求页有缓存，直接走缓存
    var tempList = <MyCommissionModel>[];
    if (modelAllList.isNotEmpty && modelAllList.length > targetPage) {
      tempList.assignAll(modelAllList[targetPage]!);
      modelListObs.assignAll(tempList);
      updatePageWhenAfter(targetPage);
    } else {
      ///走网络数据， 页码需要考虑到 失败的情
      List.generate(/*Random().nextInt(6)*/ 10, (index) {
        indexTest++;
        var model = MyCommissionModel(
          id: "$indexTest",
          time: 1698057515902 + Random().nextInt(10000),
          type: 1,
          performance: 99999999.00,
          contributeMans: 100,
          commission: -0.00000338,
        );
        tempList.add(model);
      });
      modelListObs.assignAll(tempList);
      //缓存数据
      modelAllList[targetPage] = tempList;
      //成功
      updatePageWhenAfter(targetPage);
    }
  }

  ///查看详情
  void onClickLookDetail(MyCommissionApiModel model) {
    //组装 详情参数 作为我的业绩页面 的搜索条件
    AllianceConditionModel conditionModel = AllianceConditionModel();

    var startTime = CustomSelectModel(
        DateUtil.formatDateMs(model.startTime * 1000, format: 'yyyy-MM-dd'),
        data: DateUtil.getDateTimeByMs(model.startTime * 1000));
    var endTime = CustomSelectModel(
        DateUtil.formatDateMs(model.endTime * 1000, format: 'yyyy-MM-dd'),
        data: DateUtil.getDateTimeByMs(model.endTime * 1000));
    var coinModel = CustomSelectModel("", data: model.currencyId);
    conditionModel.startTimeModel = startTime;
    conditionModel.endTimeModel = endTime;
    // conditionModel.selectCoinModel = coinModel;
    AlliancePlanLogic.of().switchAllianceTab(
      pageEnum: AlliancePageEnum.myPerformance,
      conditionModel: conditionModel,
    );
  }

  ///加载缓存数据成功，判断目标页码 和 当前保存的页码关系
  void updatePageWhenAfter(int targetPage) {
    if (targetPage < currentPage.value) {
      currentPage.value--;
    } else if (targetPage > currentPage.value) {
      currentPage.value++;
    }
  }

  ///点击上下页
  ///next 是否点击下一页， page 是组件保存的当前页，回调给方法
  void onClickNextPage(bool next, int page) {
    if (!next) {
      //上一页
      // currentPage.value--;
      // CustomToast.show("当前页：${page}， 上一页:${currentPage.value-1}", currentContext!);
      loadListData(currentPage.value - 1);
    } else {
      //下一页
      // CustomToast.show("当前页：${page}，下一页:${currentPage.value+1}", currentContext!);
      loadListData(currentPage.value + 1);
    }
  }

  final countCommissionObs = "0.0".obs;

  ///累积佣金计算
  String _countCommission(List<MyCommissionApiModel>? modelList) {
    var count = 0.0;
    if (modelList != null && modelList.isNotEmpty) {
      count = modelList.fold(0.0, (previousValue, element) {
        return previousValue + (double.tryParse(element.commissionAmountTotal) ?? 0.0);
      });
    }
    return count.toString();
  }
}
