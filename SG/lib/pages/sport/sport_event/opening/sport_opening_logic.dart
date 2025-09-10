import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:get/get.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../../../base/getx/page_state.dart';
import '../../../../services/api/api_service.dart';
import '../../../../utils/json_util.dart';
import '../../../alliance_plan/widget/custom_select_model.dart';
import '../../common_model/sport_common_params.dart';
import '../../common_model/sport_competition_api_model.dart';
import '../../common_model/sport_handicap_api_model.dart';
import '../../common_model/sport_handicap_select_model.dart';
import '../../sport_detail/model.dart';
import 'sport_opening_state.dart';

/// 滚球盘与即将开赛盘口 logic
class SportOpeningLogic extends GetxController {
  SportOpeningLogic(this.pageParams);

  final SportOpeningState state = SportOpeningState();

  late int sportId = 0; // 体育类型 ID
  final apiDataModel = SportCompetitionApiModel(hot: [], list: []).obs;

  final openingSportList = <SportMatchModel>[].obs; //某个联赛，赛事

  ///联赛列表

  final ScrollController scrollController = ScrollController();

  final SportOpenPageParams pageParams; //打开页面参数
  late SportOpenType sportOpenType; //页面类型
  late Timer dataTimer;

  final areaPageHotStateObs = PageState.LOADING.obs; //所有地区盘口，热门xx 多状态管理
  final areaPageAllStateObs = PageState.LOADING.obs; //所有地区盘口，所有xx 多状态管理
  final leaguePageStateObs = PageState.LOADING.obs; //某个联赛盘口，多状态管理
  // ///盘口类型选择范围
  // List<SportHandicapSelectModel> selectTypeList = <SportHandicapSelectModel>[
  //   SportHandicapSelectModel(handicapType: SportHandicapType.hsHandicap),
  //   SportHandicapSelectModel(handicapType: SportHandicapType.rfHandicap),
  //   SportHandicapSelectModel(handicapType: SportHandicapType.zfHandicap),
  // ];

  ///盘口类型选择范围
  final handicapTypeListObs = <CustomSelectModel>[].obs;

  ///默认盘口类型， 取值取 type 字段
  final handicapTypeObs = CustomSelectModel(S.current.random_text_682, type: 0).obs;
  final handicapTypeIndexObs = Rxn<int>();

  @override
  void onInit() {
    // pageParams = controllerFather.pageParams;
    sportOpenType = pageParams.sportOpenType;
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

  ///是否显示重试
  final showRetry = false.obs;

  ///开始请求数据，并启动定时器
  requestDataAndStartTimer() async {
    handicapLoadState(PageState.LOADING);
    //需要 盘口类型数据
    if (handicapTypeListObs.isEmpty) {
      var hasData = await loadHandicapNetData();
      if (hasData) {
        showRetry.value = false;
      } else {
        showRetry.value = true;
        handicapLoadState(PageState.FAILED);
        return; //下面不执行了
      }
    }
    //进来先请求一次
    loadNetDataSportTask();
    dataTimer = Timer.periodic(const Duration(seconds: SportCommonConfig.sportEventTime_20s),
        (Timer timer) {
      loadNetDataSportTask();
    });
  }

  ///加载盘口是的加载ui
  void handicapLoadState(PageState state){
    if(!pageParams.isLeagueEvent()){
      areaPageHotStateObs.value = state; //所有地区盘口，热门xx 多状态管理
      areaPageAllStateObs.value = state; //所有地区盘口，所有xx 多状态管理
    }else{
      leaguePageStateObs.value = state; //某个联赛盘口，多状态管理
    }
  }

  ///请求网络数据任务
  void loadNetDataSportTask() {
    //所有体育
    if (!pageParams.isLeagueEvent()) {
      getAreaListData();
    } else {
      getOneLeagueListData();
    }
  }

  ///页面类型判断方法, 是否是联赛页面
  bool isSportLeague() {
    return sportOpenType == SportOpenType.league;
  }

  ///获取数据 - 即将开赛及滚球
  ///需要请求两次接口：
  ///1、联赛列表 competition/list
  ///2、赛事列表 event/delta
  /// 获取所有地区 赛事
  void getAreaListData() async {
    // await Future.delayed(Duration(seconds: 2),() {
    //   areaPageStateObs.value =  PageState.UPDATED;
    // },);
    // return;
    await ApiService.instance.getCompetitionList(
      si: sportId,
      kind: "normal",
      success: (result) {
        //排序处理
        result.sortAb();
        apiDataModel.value = result;
        log("联赛列表data：${JsonUtil.encodeObj(apiDataModel.value)}");
        if (result.hot.isNotEmpty) {
          areaPageHotStateObs.value = PageState.SUCCESS;
        } else {
          areaPageHotStateObs.value = PageState.EMPTY;
        }
        if (result.list.isNotEmpty) {
          areaPageAllStateObs.value = PageState.SUCCESS;
        } else {
          areaPageAllStateObs.value = PageState.EMPTY;
        }
      },
      fail: (error) {
        areaPageHotStateObs.value = PageState.FAILED;
        areaPageAllStateObs.value = PageState.FAILED;
      },
    );
  }

  ///某个联赛的 滚球与即将开赛的盘口 列表
  void getOneLeagueListData() async {
    var requestParams = SportGameParams(
      si: pageParams.si,
      m: SportMarketApiType.comingAndRolling.type,
      ci: [pageParams.ci ?? ""],
    );
    await getListData(
      requestParams,
      successCall: (listData) {
        if (listData.isNotEmpty) {
          openingSportList.value = listData;
          leaguePageStateObs.value = PageState.SUCCESS;
        } else {
          leaguePageStateObs.value = PageState.EMPTY;
        }
      },
      failCall: (message) {
        leaguePageStateObs.value = PageState.FAILED;
      },
    );
  }

  ///获取某个体育类别 的赛事列表 :event/list
  // {
  // "si": 1, //球种Id
  // "m": 3, //market 0:取所有 1:早盘 2:今日 3:滚球 4:即将开赛 5:即将开赛及滚球
  // "ci": [
  // "1111",
  // "2222"
  // ], //联赛id
  // "page": 1, //page
  // "page_size": 100 //page_size
  // }
  ///给某个地区联赛 调用
  ///两种回调方式
  Future<List<SportMatchModel>> getListData(
    SportGameParams params, {
    Success<List<SportMatchModel>>? successCall,
    Fail? failCall,
  }) async {
    Completer<List<SportMatchModel>> completer = Completer<List<SportMatchModel>>();
    try {
      await ApiService.instance.getSportList(
        si: params.si,
        m: params.m,
        ci: params.ci,
        hot: params.hot,
        pgid: params.pgid,
        page: params.page,
        page_size: params.pageSize,
        success: (Map<dynamic, dynamic> data) {
          if (data['d'] == null && successCall != null) successCall([]);
          List listData = data['d'];
          log("赛事列表...event/list：${JsonUtil.encodeObj(data)}");
          var sportList = listData.map((e) => SportMatchModel.fromJson(e)).toList();
          completer.complete(sportList);
          if (successCall != null) {
            successCall(sportList);
          }
        },
        fail: (String? message) {
          completer.complete([]);
          if (failCall != null) {
            failCall(message);
          }
        },
      );
    } catch (e) {
      completer.complete([]);
    }

    return completer.future;
  }

  // final handicapApiModelObs = SportHandicapApiModel().obs;
  SportHandicapApiModel? handicapApiModel;

  ///获取盘口类型数据
  Future<bool> loadHandicapNetData() async {
    var hasData = false;
    await ApiService.instance.getSportHandicapType(
      success: (SportHandicapApiModel data) {
        if (data.d != null) {
          //获取当前球中的 对应盘口
          var targetHandicap = data.d!.firstWhere((element) => pageParams.si == element.si);
          if (targetHandicap != null &&
              targetHandicap.btl != null &&
              targetHandicap.btl!.isNotEmpty) {
            var tempList = <CustomSelectModel>[];
            for (var handicap in targetHandicap.btl!) {
              tempList.add(CustomSelectModel(handicap.btn ?? '', type: handicap.egi ?? 0, data: handicap));
            }
            handicapTypeListObs.assignAll(tempList);
            //默认选中第一个
            handicapTypeObs.value = handicapTypeListObs.first;
            handicapTypeIndexObs.value = 0;
            log("球种：${targetHandicap.si}...selectTypeList：${handicapTypeListObs.toString()}");
          }
        }
        //是否为空，不为空就是请求成功，为空默认为请求失败， 需要重新执行请求
        hasData = handicapTypeListObs.isNotEmpty;
        // hasData = false;
      },
      fail: (bool isConnect, String? message, candy) {
        hasData = false;
      },
    );

    return hasData;
  }
}
