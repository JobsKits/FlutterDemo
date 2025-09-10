import 'package:flutter_bet/generated/l10n.dart';
import 'dart:developer';

import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:get/get.dart';

import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../all_promotions/all_promotions_api_model.dart';
import '../a_helper/activity_biz_mixin.dart';
import '../a_model/activity_common_params.dart';
import '../all_promotions/all_promotions_logic.dart';

class SinglePromotionsLogic extends BaseController
    with CustomRefreshStateMixinHelper, ActivityBizMixin {
  SinglePromotionsLogic({this.typeEnum}); //

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <AllPromotionsApiModel>[]).obs;

  ///自定义方便取数据
  List<AllPromotionsApiModel> get apiModelList => pageModelObs.value.content;

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ActivityListTypeEnum? typeEnum;

  final typeTopLabelObs = "".obs;
  late Worker tabIndexObsWork;

  static SinglePromotionsLogic? of(ActivityListTypeEnum typeEnum) {
    if (Get.isRegistered<SinglePromotionsLogic>(tag: typeEnum.name)) {
      return Get.find<SinglePromotionsLogic>(tag: typeEnum.name);
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();
    typeEnum ??= Get.arguments["typeEnum"];
    if (typeEnum == ActivityListTypeEnum.casino) {
      typeTopLabelObs.value = S.current.tab_bar_ent;
    } else if (typeEnum == ActivityListTypeEnum.sport) {
      typeTopLabelObs.value = S.current.random_text_826;
    }
    tabIndexObsWork = ever(AllPromotionsLogic.of().tabIndexObs, (index) {
      if (index == 0) {
        typeEnum = ActivityListTypeEnum.casino;
      } else if (index == 1) {
        typeEnum = ActivityListTypeEnum.sport;
      }
      log("tabIndexObsWork...$index.....${typeEnum}");
      loadNetData(isRefresh: true, isFirst: false, isShowLoad: false);
    });
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData(isRefresh: true, isFirst: true, isShowLoad: true);
  }

  @override
  void onClose() {
    tabIndexObsWork.dispose(); //销毁
    super.onClose();
  }

  ///执行刷新 页面 ,供外面使用
  void doRefreshPage(bool refresh) {
    if (refresh) {
      loadNetData(isRefresh: true, isFirst: true, isShowLoad: true);
    }
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  void loadNetData({required bool isRefresh, bool isShowLoad = true, bool isFirst = false}) async {
    showLoading(isShowLoad, isFirst);
    await ApiService.instance.getAllPromotions(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefresh),
      page_size: pageModelObs.value.curPageSize,
      category: typeEnum?.category ?? "",

      success: (PageCommonModel<AllPromotionsApiModel> resultData) {
        pageModelObs.value.copyWith(resultData, isRefresh);
        pageModelObs.refresh();
        log("所有活动api...上层...${pageModelObs.toString()}");
        successFinish(isRefresh, pageModelObs.value, refreshController);
      },
      fail: (bool isConnect, String? message, candy) {
        failFinish(isConnect, isRefresh, isFirst, refreshController);
      },
    );
  }
}
