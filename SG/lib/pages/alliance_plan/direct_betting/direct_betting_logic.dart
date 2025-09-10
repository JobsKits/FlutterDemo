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
import '../wmodel/alliance_common_params.dart';
import 'direct_betting_api_model.dart';
import 'direct_betting_state.dart';
import 'dirent_betting_model.dart';

class DirectBettingLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin, CustomPrevNextMixin {
  final DirectBettingState state = DirectBettingState();

  ///窗口列表可是最大框宽度
  final double windowListWidthMax = Get.width * 1.1;

  int currentPage = 0; //当第几页

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs = PageCommonModel.init(
      curPage: 1, curPageSize: AllianceCommonData.pageSize, first: true, content: <DirectBettingApiModel>[]).obs;

  ///自定义方便取数据
  List<DirectBettingApiModel> get apiModelList => pageModelObs.value.content;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    // loadListData();
    loadNetData(isRefreshOrPrev: true, isFirst: true);
  }

  final modelList = <DirectBettingModel>[].obs;

  ///加载列表数据
  void loadListData() {
    var tempList = <DirectBettingModel>[];
    List.generate(math.Random().nextInt(10), (index) {
      var model = DirectBettingModel(
        time: 1698057515902,
        account: "jacky666",
        validBet: 99999999.00,
        amountBet: 1000,
        totalWinOrLoss: -0.00000338,
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
    await ApiService.instance.getDirectBetting(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      // page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      //todo:0611.兼容几把上下页
      page: getPnRequestIndex(pageModelObs.value, prevPage: isRefreshOrPrev, jumpPage: jumpPage),
      page_size: pageModelObs.value.curPageSize,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      currency_id: conditionModel.getCoin(),
      username: conditionModel.getSearchWord(),
      sortModel: sortModel,
      success: (PageCommonModel<DirectBettingApiModel> resultData) {
        // pageModelObs.value.copyWith(resultData, isRefreshOrPrev);
        // pageModelObs.value.content = <DirectBettingApiModel>[DirectBettingApiModel(
        //   uid: "48359506800075917", //会员ID
        //   username: "12345yuyu88", //会员账号
        //   currencyId: "707", //货币ID
        //   currencyName: "CNY", //货币名称
        //   betCount: 0, //注单数量
        //   validBetAmount: "1.00000001", //有效投注
        //   netAmount: "1.00000001", //总输赢
        //   vip: "1", //vip等级
        //   time:1716280726, //统计日期
        //   createdAt: 1716280726, //创建时间
        // )];
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
