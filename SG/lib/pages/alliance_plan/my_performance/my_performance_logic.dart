import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:get/get.dart';

import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../alliance_plan_logic.dart';
import '../alliance_plan_logic.dart';
import '../whepler/alliance_biz_mixin.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../wmodel/alliance_common_params.dart';
import '../wmodel/alliance_condition_model.dart';
import 'my_performance_api_model.dart';
import 'my_performance_model.dart';
import 'my_performance_state.dart';

///联盟计划-tab-我的业绩界面
class MyPerformanceLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin, CustomPrevNextMixin {
  final MyPerformanceState state = MyPerformanceState();

  MyPerformanceLogic({this.jumpUpdate =false});

  bool? jumpUpdate; //是否是跳转跟新

  ///jumpUpdate 是否初始化页面，加载数据， jumpUpdate = false 比较适合带条件 更新数据
  static MyPerformanceLogic of({bool jumpUpdate = false}) {
    //先判断是否已经初始化
    if (Get.isRegistered<MyPerformanceLogic>()) {
      return Get.find<MyPerformanceLogic>();
    } else {
      return Get.put<MyPerformanceLogic>(MyPerformanceLogic(jumpUpdate: jumpUpdate));
    }
  }

  ///窗口列表可是最大框宽度
  final double windowListWidthMax =
      GlobalStateController.of().isChinese() ? Get.width * 1.3 : Get.width * 1.3;

  int currentPage = 0; //当第几页

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs = PageCommonModel.init(
    curPage: 1,
    curPageSize: AllianceCommonData.pageSize,
    first: true,
    content: <MyPerformanceApiModel>[],
  ).obs;

  ///自定义方便取数据
  List<MyPerformanceApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (jumpUpdate == false) {
      loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true, preload: false);
    }
  }

  final modelList = <MyPerformanceModel>[].obs;

  ///加载列表数据
  void loadListData() {
    var tempList = <MyPerformanceModel>[];
    List.generate(/*Random().nextInt(10)*/ 10, (index) {
      var model = MyPerformanceModel(
        id: "1",
        time: 1698057515902,
        account: "musk",
        underNumber: 100,
        performance: 99999999.00,
        commission: -0.00338,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局
  void loadNetData({
    required bool isRefreshOrPrev, //刷新或者上一页
    int? jumpPage,
    bool isShowLoad = true,
    bool isFirst = false,
    bool preload = false,
  }) async {
    pnWidgetShow = !isShowLoad;
    showLoading(isShowLoad, isFirst, preload);
    await ApiService.instance.getMyPerformance(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      // page: pageModelObs.value.pageIndex(isRefresh),
      //todo:0611.兼容几把上下页
      page: getPnRequestIndex(pageModelObs.value, prevPage: isRefreshOrPrev, jumpPage: jumpPage),
      page_size: pageModelObs.value.curPageSize,
      // page_size: 2,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      currency_id: conditionModel.getCoin(),
      username: conditionModel.getSearchWord(),
      sortModel: sortModel,
      success: (PageCommonModel<MyPerformanceApiModel> resultData) {
        // pageModelObs.value.copyWith(resultData, isRefresh);
        // pageModelObs.refresh();
        // log("我的业绩api上层...${pageModelObs.toString()}");
        // successFinish(isRefresh, pageModelObs.value, refreshController);
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

  ///点击上下页
  void onClickNextPage(int nextPage) {
    CustomToast.show("${S.current.random_text_132}${nextPage}", Get.overlayContext!);
  }

  ///点击搜索
  void onClickSearch(String inputText) {
    CustomToast.show("${S.current.random_text_133}${inputText}", Get.overlayContext!);
  }

  @override
  void onClose() {
    log("我的业绩...MyPerformanceLogic...onClose...");
    // KeyboardUtils.hideKeyShowUnFocus();
    // KeyboardUtils.hideKeyboard(currentContext!);
    super.onClose();
  }

  final coinIndexObs = 0.obs;

  ///更新搜索条件
  void updateCondition(AllianceConditionModel? updateModel) {
    if (updateModel != null) {
      //条件有：开始时间、结束时间、货币类型、账号搜索
      // var coinModel  =  CustomSelectModel("USDT", data: "706");
      conditionModel.selectCoinModel = updateModel.selectCoinModel;
      var coinId = conditionModel.selectCoinModel?.data ?? "";
      //寻找相同的货币 id  index
      coinIndexObs.value =
          AlliancePlanLogic.of().selectCoinList.indexWhere((element) => element.data == coinId);
      conditionModel.defaultStartTime = updateModel.startTimeModel?.data;
      conditionModel.defaultEndTime = updateModel.endTimeModel?.data;
      // conditionModel.startTimeModel = updateModel.startTimeModel;
      // conditionModel.endTimeModel = updateModel.endTimeModel;
      // conditionModelObs.update();
      // conditionModelObs.refresh();
      // conditionModel
      // collectParams(conditionModelObs.value);
      loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: false, preload: false);
    }
  }
}
