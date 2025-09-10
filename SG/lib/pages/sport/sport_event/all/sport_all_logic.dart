import 'dart:async';
import 'dart:developer';

import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../routes/routes.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/json_util.dart';
import '../../../../utils/route_util.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_model/sport_competition_api_model.dart';
import '../../common_model/sport_game_model.dart';
import '../sport_event_logic.dart';
import '../../common_model/sport_outrihgt_api_model.dart';
import '../sport_event_view.dart';
import 'sport_all_state.dart';

class SportAllLogic extends GetxController {
  SportAllLogic(this.pageParams);

  final SportAllState state = SportAllState();

  late int sportId = 0; // 体育类型 ID
  RxList<SportOutRightModel> championList = <SportOutRightModel>[].obs; //冠军

  final apiDataModel = SportCompetitionApiModel(hot: [], list: []).obs;
  final SportOpenPageParams pageParams; //打开页面参数
  final allSportPageStateObs = PageState.LOADING.obs; //冠军投注页面多状态布局管理

  late Timer dataTimer;


  @override
  void onInit() {
    super.onInit();
    sportId = pageParams.si;
    requestDataAndStartTimer();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    if (dataTimer.isActive) dataTimer.cancel();
  }



  ///开始请求数据，并启动定时器
  requestDataAndStartTimer() {
    //进来先请求一次
    getListData();
    dataTimer =
        Timer.periodic(const Duration(seconds: SportCommonConfig.sportEventTime_60s), (Timer timer) {
          //所有体育
          getListData();
        });
  }

  ///联赛列表 - 体育类型 全部赛事
  ///直接一次接口，1、联赛列表 competition/list
  ///取 list全部
  getListData() async {
    log("联赛列表id：$sportId");
    await ApiService.instance.getCompetitionList(
      si: sportId,
      kind: "normal",
      success: (result) {
        if(result.list.isNotEmpty){
          //排序处理
          result.sortAb();
          apiDataModel.value = result;
          log("全部界面api：${JsonUtil.encodeObj(apiDataModel.value)}");
          allSportPageStateObs.value = PageState.SUCCESS;
        }else{
          allSportPageStateObs.value = PageState.EMPTY;
        }

      },
      fail: (error) {
        allSportPageStateObs.value = PageState.FAILED;
      },
    );
  }

  ///点击跳转页面
  onClickToPage(String pgid, SportGameItemModel model) {
    log("联赛...点击跳转页面...");
    SportOpenPageParams pageParams = SportOpenPageParams(
      sportOpenType: SportOpenType.league,
      si: sportId,
      title: model.cn ?? "",
      ci: model.ci,
      pgid: pgid,
    );
    // RouteUtil.popView();
    // SportEventPage.openPage(pageParams);
    // RouteUtil.pushToView(Routes.personalResponsible);
    // RouteUtil.popView();
    SportEventPage.openPage(pageParams);
    // RouteUtil.pushToView(Routes.sport_event_detail,offLast: true, arguments: {'pageParams': pageParams});
  }
}
