import 'dart:developer';

import 'package:flutter_bet/base/getx/page_state.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/alliance_api_service.dart';
import 'dart:math' as math;

import 'package:get/get.dart';

import '../../../model/page.dart';
import '../../../model/page_common_model.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_pull_to_refresh_controller.dart';
import '../whepler/alliance_biz_mixin.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../widget/custom_select_model.dart';
import 'dicrect_receive_api_model.dart';
import 'direct_receive_model.dart';
import 'direct_receive_state.dart';

class DirectReceiveLogic extends GetxController
    with CustomRefreshStateMixinHelper, AllianceBizMixin {
  final DirectReceiveState state = DirectReceiveState();

  ///窗口列表可是最大框宽度
  final double windowListWidthMax = Get.width * 1.4;

  int currentPage = 0; //当第几页

  ///时间选择范围
  List<CustomSelectModel> selectTimeList = <CustomSelectModel>[
    // "一日", "一个星期", "一个月", "三个月", "六个月", "一年", "永久性",
    CustomSelectModel('2023-10-18 - 2023-1-18'),
    CustomSelectModel('2023-10-18 - 2023-2-18'),
    CustomSelectModel('2023-10-18 - 2023-3-18'),
    CustomSelectModel('2023-10-18 - 2023-4-18'),
    CustomSelectModel('2023-10-18 - 2023-5-18'),
    CustomSelectModel('2023-10-18 - 2023-6-18'),
  ];

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <DirectReceiveApiModel>[]).obs;

  ///自定义方便取数据
  List<DirectReceiveApiModel> get apiModelList => pageModelObs.value.content;


  // = PageModel.init(content: []);
  // final modelListObs = <DirectReceiveApiModel>[].obs;

  // final pageStateObs = PageState.DEFAULT.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadNetData(isRefresh: true, isFirst: true);
  }

  final modelList = <ReceiveDirectlyModel>[].obs;

  ///加载列表数据
  void loadListData() {
    var tempList = <ReceiveDirectlyModel>[];
    List.generate(math.Random().nextInt(10), (index) {
      var model = ReceiveDirectlyModel(
        time: 1698057515902,
        account: S.current.tab_bar_sports,
        total: 11111.11,
        activity: 2222.22,
        betrayal: 3333.33,
        commission: 44444.44,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局
  void loadNetData({required bool isRefresh, bool isFirst = false}) async {
    showLoading(isFirst);
    await ApiService.instance.getDirectReceive(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefresh),
      page_size: pageModelObs.value.curPageSize,
      start_time: conditionModel.getStartTime(),
      end_time: conditionModel.getEndTime(),
      currency_id: conditionModel.getCoin(),
      // model_id: conditionModel.getType(),
      username: conditionModel.getSearchWord(),
      sortModel: sortModel,
      success: (PageCommonModel<DirectReceiveApiModel> resultData) {
        //刷新请求成功
        // if (isRefresh) {
        //   pageModelList.assignAllData(data.content);
        // }else{
        //   pageModelList.addAllData(data.content,false);
        // }

        //todo: 网络模拟数据
        // var tempList = <DirectReceiveApiModel>[];
        // List.generate(
        //   8,
        //   (index) {
        //     var model = DirectReceiveApiModel(
        //       time: 1698057515902,
        //       username: S.current.tab_bar_sports,
        //       totalReceive: "11111.11",
        //       giftAmount: "2222.22",
        //       commissionAmount: "44444.44",
        //     );
        //     tempList.add(model);
        //   },
        // );
        // resultData.content = tempList;
        // modelList.addAll(loadListData());
        // loadListData();
        pageModelObs.value.copyWith(resultData, isRefresh);
        pageModelObs.refresh();
        log("直属领取api...上层...${pageModelObs.toString()}");
        // modelListObs.addAll(resultData.content);
        // modelListObs.refresh();
        // pageModelList.refresh();
        ///////
        // if (isRefresh) {
        //   refreshController.finishRefresh();
        // } else {
        //   //是否有更多
        //   refreshController.setLoadMoreFinish(pageModelObs.value.hasMore());
        // }
        // pageStateObs.value = PageState.FAILED;

        successFinish(isRefresh, pageModelObs.value, refreshController);
      },

      fail: (bool isConnect, String? message, candy) {
        // if (isRefresh && isFirst) {
        //   pageStateObs.value = PageState.FAILED;
        // } else if (isRefresh && !isFirst) {
        //   refreshController.setRefreshFinish();
        // } else {
        //   refreshController.setLoadMoreFinish(true);
        // }

        failFinish(isConnect, isRefresh, isFirst, refreshController);
      },
    );
  }
}
