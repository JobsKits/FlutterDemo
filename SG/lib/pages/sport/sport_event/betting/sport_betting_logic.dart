import 'dart:async';
import 'dart:developer';

import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/json_util.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_model/sport_competition_api_model.dart';
import '../../common_model/sport_outrihgt_api_model.dart';
import 'sport_betting_state.dart';

class SportBettingLogic extends GetxController {
  SportBettingLogic(this.pageParams);

  final SportBettingState state = SportBettingState();
  late int sportId = 0; // 体育类型 ID

  final apiDataModelObs = SportCompetitionApiModel(hot: [], list: []).obs; //赛区联赛列表
  final SportOpenPageParams pageParams; //打开页面参数

  final areaOurRightPageHotStateObs = PageState.LOADING.obs; //所有地区盘口，热门xx冠军投注 多状态管理
  final areaOurRightPageAllStateObs = PageState.LOADING.obs; //所有地区盘口，所有xx冠军投注 多状态管理
  final leagueOurRightPageStateObs = PageState.LOADING.obs; //冠军投注页面多状态布局管理
  late Timer dataTimer;

  @override
  void onClose() {
    if (dataTimer.isActive) dataTimer.cancel();
  }

  @override
  void onInit() {
    super.onInit();
    sportId = pageParams.si;
    requestDataAndStartTimer();
    // //判断请求类型
    // switch (pageParams.sportOpenType) {
    //   case SportOpenType.live:
    //   case SportOpenType.outright:
    //   case SportOpenType.sport:
    //     //所有体育
    //     getAreaListData();
    //     break;
    //   case SportOpenType.league:
    //     //联赛的 的冠军投注
    //     getOneLeagueOutrightListData();
    //     break;
    //   default:
    //     break;
    // }
  }

  ///开始请求数据，并启动定时器
  requestDataAndStartTimer() {
    //进来先请求一次
    if (!pageParams.isLeagueEvent()) {
      getAreaListData();
    } else {
      getOneLeagueOutrightListData();
    }

    dataTimer =
        Timer.periodic(const Duration(seconds: SportCommonConfig.sportEventTime_20s), (Timer timer) {
          //所有体育
          if (!pageParams.isLeagueEvent()) {
            getAreaListData();
          } else {
            getOneLeagueOutrightListData();
          }
        });
  }

  ///是否是联赛的 冠军投注
  bool isLeagueOutright() {
    return pageParams.sportOpenType == SportOpenType.league;
  }

  ///【情况一】 获取地区 的冠军投注
  void getAreaListData() async {
    // areaOurRightPageHotStateObs.value = PageState.LOADING;
    // areaOurRightPageAllStateObs.value = PageState.LOADING;
    await ApiService.instance.getCompetitionList(
      si: sportId,
      kind: "outright",
      success: (apiModel) {
        log("冠军投注...联赛列表：${JsonUtil.encodeObj(apiModel)}");
        //排序处理
        apiModel.sortAb();
        apiDataModelObs.value = apiModel;

        if(apiModel.hot.isNotEmpty){
          areaOurRightPageHotStateObs.value = PageState.SUCCESS;
        }else{
          areaOurRightPageHotStateObs.value = PageState.EMPTY;
        }
        if(apiModel.list.isNotEmpty){
          areaOurRightPageAllStateObs.value = PageState.SUCCESS;
        }else{
          areaOurRightPageAllStateObs.value = PageState.EMPTY;
        }
      },
      fail: (String? error) {
        areaOurRightPageHotStateObs.value = PageState.FAILED;
        areaOurRightPageAllStateObs.value = PageState.FAILED;
      },
    );
  }

  final leagueOutrightModelObs = <SportOutRightModel>[].obs;

  ///【情况二】给某个联赛 调用
  void getOneLeagueOutrightListData() async {
    // leagueOurRightPageStateObs.value = PageState.LOADING;
    getOutrightListData(
      si: sportId,
      pgid: pageParams.pgid,
      ci: pageParams.ci,
      successCall: (data) {
        if(data.isNotEmpty){
          leagueOutrightModelObs.value = data;
          leagueOurRightPageStateObs.value = PageState.SUCCESS;
        }else{
          leagueOurRightPageStateObs.value = PageState.EMPTY;
        }
      },
      failCall: (message) {
        leagueOurRightPageStateObs.value = PageState.FAILED;
      },
    );
  }


  ///【公共接口】冠军投注接口, 给某个地区下联赛 调用, 也可以给某个联赛调用
  Future<List<SportOutRightModel>> getOutrightListData({
    required int si,
    String? pgid,
    String? ci,
    Success<List<SportOutRightModel>>? successCall,
    Fail? failCall,
  }) async {
    List<SportOutRightModel> modelList = [];
    await ApiService.instance.getOutright(
      si: si,
      pgid: pgid ?? "",
      ci: ci ?? "",
      page: 1,
      page_size: 50,
      success: (apiModel) {
        if (successCall != null) {
          successCall(apiModel);
        }
        modelList=apiModel;
      },
      fail: (message) {
        if (failCall != null) {
          failCall(message);
        }
      },
    );
    return modelList;
  }
}
