import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:get/get.dart';

import '../../../controllers/global_state_controller.dart';
import '../../../model/page_common_model.dart';
import '../../../model/wallet/CurrencyBean.dart';
import '../../../services/api/api_service.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../../alliance_plan/widget/custom_select_model.dart';
import '../a_model/activity_common_params.dart';
import '../a_model/activity_invite_api_model.dart';

class ActivityInviteDetailDialogLogic extends BaseController
    with CustomRefreshStateMixinHelper, CustomPrevNextMixin {
  ActivityInviteDetailDialogLogic({required this.pid, required this.coinId});

  //单前选中的币种
  // CurrencyBean get currentCoin => GlobalStateController.of().currTypeSelected.value;
  final String pid;
  final String coinId;

  final List<CustomSelectModel> typeModelList = [
    CustomSelectModel(
      ActivityInviteState.all.getLabel(),
      data: ActivityInviteState.all.type,
    ),
    CustomSelectModel(
      ActivityInviteState.efficient.getLabel(),
      data: ActivityInviteState.efficient.type,
    ),
    CustomSelectModel(
      ActivityInviteState.invalid.getLabel(),
      data: ActivityInviteState.invalid.type,
    ),
  ];

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs = PageCommonModel.init(
      curPage: 1, curPageSize: 10, first: true, content: <ActivityInviteApiModel>[]).obs;

  ///自定义方便取数据
  List<ActivityInviteApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    //初始化餐素
    collectParamsAndLoadData(type: ActivityInviteState.all.type);
    loadNetData(isRefreshOrPrev: true, isShowLoad: true, isFirst: true, preload: false);
  }

  //请求参数
  String paramType = "";
  String paramUsername = "";

  ///收集条件参数 并请求网络数据
  void collectParamsAndLoadData({int? type, String? username}) {
    if (type != null) {
      paramType = type.toString();
    }
    if (username != null) {
      paramUsername = username;
    }
    loadNetData(isRefreshOrPrev: true, jumpPage: 1, isFirst: true);
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
    showLoading(isShowLoad, isFirst, preload);
    await ApiService.instance.getActivityInviteList(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      page_size: pageModelObs.value.curPageSize,
      pid: pid,
      state: paramType,
      username: paramUsername,
      currency_id: coinId,
      success: (PageCommonModel<ActivityInviteApiModel> resultData) {
        //模拟数据
        // var demoList =
        //     List.generate(10, (index) => ActivityInviteApiModel(username: "name$index")).toList();
        // resultData.content = demoList;
        // resultData.resultPageNeedSize = 10;
        // resultData.resultPageSize = 10;
        // resultData.total = 34;
        // pageModelObs.value.copyWith(resultData, isRefresh);
        // pageModelObs.refresh();
        // log("邀请列表api...上层...${pageModelObs.toString()}");
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
}
