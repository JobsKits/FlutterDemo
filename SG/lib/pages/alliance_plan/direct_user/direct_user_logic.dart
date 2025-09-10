import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'package:get/get.dart';

import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../whepler/alliance_biz_mixin.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../widget/custom_select_model.dart';
import '../wmodel/alliance_common_params.dart';
import 'direct_user_api_model.dart';
import 'direct_user_state.dart';
import 'dirent_user_model.dart';

class DirectUserLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin, CustomPrevNextMixin {
  final DirectUserState state = DirectUserState();

  ///窗口列表可是最大框宽度
  final double windowListWidthMax = Get.width * 1.3;

  int currentPage = 0; //当第几页

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1,curPageSize: AllianceCommonData.pageSize, first: true, content: <DirectUserApiModel>[]).obs;

  ///自定义方便取数据
  List<DirectUserApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // loadNetData(true);
    log("logic生命周期...onReady()");
    loadNetData(isRefreshOrPrev: true, isFirst: true);
  }

  final modelList = <DirectUserModel>[].obs;

  ///加载列表数据
  void loadListData() {
    var tempList = <DirectUserModel>[];
    List.generate(math.Random().nextInt(10), (index) {
      var model = DirectUserModel(
        time: 1698057515902,
        account: "jacky666",
        isFirstDeposit: math.Random().nextBool(),
        lastLoginTime: 1698057515902,
        onLineState: math.Random().nextInt(2) + 1,
        onLineTimes: 20,
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
    // showLoading(isFirst);
    pnWidgetShow = !isShowLoad;
    showLoading(isShowLoad, isFirst, preload);
    await ApiService.instance.getDirectUser(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      // page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      //todo:0611.兼容几把上下页
      page: getPnRequestIndex(pageModelObs.value, prevPage: isRefreshOrPrev, jumpPage: jumpPage),
      page_size: pageModelObs.value.curPageSize,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      // currency_id: conditionModel.getCoin(),
      // model_id: conditionModel.getType(),
      username: conditionModel.getSearchWord(),
      sortModel: sortModel,
      success: (PageCommonModel<DirectUserApiModel> resultData) {
        // pageModelObs.value.copyWith(resultData, isRefreshOrPrev);
        // pageModelObs.refresh();
        // log("直属用户api...上层...${pageModelObs.toString()}");
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
}
