import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/num_util.dart';
import '../../../widget/refresh/custom_prev_next_mixin.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../whepler/alliance_biz_mixin.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../widget/custom_select_model.dart';
import '../wmodel/alliance_common_params.dart';
import 'all_data_api_model.dart';
import 'all_data_api_model_total.dart';
import 'all_data_model.dart';
import 'all_data_state.dart';

class AllDataLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin, CustomPrevNextMixin {
  final AllDataState state = AllDataState();

  ///窗口列表可是最大框宽度
  final double windowListWidthMax = Get.width * 1.4;

  int currentPage = 0; //当第几页

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1,curPageSize: AllianceCommonData.pageSize, first: true, content: <AllDataApiModel>[]).obs;

  ///自定义方便取数据
  List<AllDataApiModel> get apiModelList => pageModelObs.value.content;

  final totalModel = AllDataApiModel(isTotalItem: true, username: S.current.random_text_1068);

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData(isRefreshOrPrev: true, isFirst: true, isShowLoad: true);
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  void loadNetData({
    required bool isRefreshOrPrev,
    int? jumpPage,
    bool isShowLoad = true,
    bool isFirst = false,
  }) async {
    // pnWidgetShow = !isShowLoad;
    showLoading(isShowLoad, isFirst);
    await ApiService.instance.getAllData(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      // page: pageModelObs.value.pageIndex(isRefreshOrPrev),
      //todo:0611.兼容几把上下页
      page: getPnRequestIndex(pageModelObs.value, prevPage: isRefreshOrPrev, jumpPage: jumpPage),
      page_size: pageModelObs.value.curPageSize,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      // currency_id: conditionModel.getCoin(),
      // model_id: conditionModel.getType(),
      currency_id: conditionModel.getCoin(),
      username: conditionModel.getSearchWord(),
      sortModel: sortModel,
      success: (PageCommonModel<AllDataApiModel> resultData) {
        if (apiModelList.isNotEmpty) {
          apiModelList.remove(totalModel);
        }
        // pageModelObs.value.copyWith(resultData, isRefreshOrPrev);
        // //总共
        // if (apiModelList.isNotEmpty && resultData.totalData != null) {
        //   dealTotalModelData(resultData.totalData);
        // }
        // pageModelObs.refresh();
        // log("直属财务api...上层...${pageModelObs.toString()}");
        // successFinish(isRefreshOrPrev, pageModelObs.value, refreshController);
        //todo:0611.兼容几把上下页
        refreshPnPage(pageModelObs.value, resultData,
            prevPage: isRefreshOrPrev, jumpPage: jumpPage);
        //总共
        if (apiModelList.isNotEmpty && resultData.totalData != null) {
          dealTotalModelData(resultData.totalData);
        }
        pageModelObs.refresh();
        successFinish(isRefreshOrPrev, pageModelObs.value, refreshController);
      },
      fail: (bool isConnect, String? message, candy) {
        failFinish(isConnect, isRefreshOrPrev, isFirst, refreshController);
      },
    );
  }

  void dealTotalModelData(AllDataTotalApiModel? model) {
    //金额处理
    // var depositAmount = apiModelList.fold(0.00, (double value, AllDataApiModel model) {
    //   return NumUtil.add(value, Decimal.parse(model.depositAmount ?? "0.00").toDouble());
    // });
    //
    // var validBetAmount = apiModelList.fold(0.00, (double value, AllDataApiModel model) {
    //   return NumUtil.add(value, Decimal.parse(model.validBetAmount ?? "0.00").toDouble());
    // });
    //
    // var netAmount = apiModelList.fold(0.00, (double value, AllDataApiModel model) {
    //   return NumUtil.add(value, Decimal.parse(model.netAmount ?? "0.00").toDouble());
    // });
    // var totalAmount = NumUtil.add(NumUtil.add(depositAmount, validBetAmount), netAmount);
    // totalModel.totalAmount = totalAmount.toString();
    // totalModel.depositAmount = depositAmount.toString();
    // totalModel.validBetAmount = validBetAmount.toString();
    // totalModel.netAmount = netAmount.toString();

    //填充数据
    totalModel.totalAmount = model?.num.toString();
    totalModel.depositAmount = model?.depositAmount;
    totalModel.validBetAmount = model?.validBetAmount;
    totalModel.netAmount = model?.netAmount;
    //货币处理
    String currencyId = conditionModel.selectCoinModel?.data ?? "706";
    if (currencyId.isEmpty) {
      currencyId = "706";
    }
    totalModel.currencyId = currencyId;
    apiModelList.add(totalModel);
  }
}
