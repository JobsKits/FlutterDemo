import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:get/get.dart';

import '../../../app/modules/rotary/views/lucky_wheel/index.dart';
import '../../../generated/l10n.dart';
import '../../../model/page_common_model.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';
import '../../../services/theme/theme_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../../home/home_logic.dart';
import '../../home/home_state.dart';
import '../a_helper/activity_biz_mixin.dart';
import '../a_model/activity_common_params.dart';
import '../a_model/activty_sidebar_api_model.dart';
import '../single_promontions/single_promotions_view.dart';
import 'all_promotions_api_model.dart';

///促销活动 查看全部
class AllPromotionsLogic extends BaseController
    with CustomRefreshStateMixinHelper, ActivityBizMixin, GetTickerProviderStateMixin {
  late TabController tabController;
  late List<Tab> tabList;

  //一共有11
  var tabLabel = [
    S.current.tab_bar_ent_copy, //娱乐城
    S.current.random_text_826_copy, //体育
  ];

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

  static AllPromotionsLogic of(){
   return Get.find<AllPromotionsLogic>();
  }

  ///todo:0612.【促销活动】活动列表切换tab要请求接口获取最新活动数据，现在后台取消体育下的数据前端切换tab数据没有刷新
  final tabIndexObs = 0.obs;

  @override
  void onInit() {
    super.onInit();
    initView();
  }

  void initView() {
    tabList = tabLabel
        .map(
          (label) => Tab(
            child: CustomText(
              label,
              style: ThemeService().theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        )
        .toList();
    tabController = TabController(length: tabList.length, initialIndex: 0, vsync: this);
    tabController.addListener(() {
      if (tabController.index.toDouble() == tabController.animation!.value) {
        log("======tabController.index.....${tabController.index}");
        tabIndexObs.value = tabController.index;
      }
    });
  }

  ///切换获取不同的view
  Widget getTabBarView(int index) {
    switch (index) {
      case 0:
        return SinglePromotionsPage(typeEnum: ActivityListTypeEnum.casino);
      case 1:
        return SinglePromotionsPage(typeEnum: ActivityListTypeEnum.sport);

      default:
        return Container();
    }
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData(isRefresh: true, isFirst: true, isShowLoad: true);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    super.onClose();
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  void loadNetData({required bool isRefresh, bool isShowLoad = true, bool isFirst = false}) async {
    showLoading(isShowLoad, isFirst);
    await ApiService.instance.getAllPromotions(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefresh),
      page_size: pageModelObs.value.curPageSize,
      category: ActivityListTypeEnum.all.category,
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
