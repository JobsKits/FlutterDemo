import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';

import '../../controllers/global_state_controller.dart';
import '../../services/api/api_service.dart';
import '../../services/event/event_service.dart';
import '../../utils/json_util.dart';
import '../main/code.dart';
import '../sport/logic.dart';
import 'bet_list_state.dart';

class BetListLogicTwo extends BaseController with GetTickerProviderStateMixin{
  final BetListState state = BetListState();
  TabController? myBetTabController;
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final logicSport = Get.find<MessageLogic>();
  @override
  void onInit() {
    myBetTabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    loadActivityInfo(0);
  }

  ///获取投注明细
  Future<void> loadActivityInfo(int settle) async {
    await ApiService.instance.getBetList(
      page: 1,
      sttle: settle,
      cur: globalController.currTypeSelected.value.cur ?? '',
      success: (page) {
        if(settle==0){
          state.activityErro.value=false;
          loadActivityInfo(1);
          state.betListActivity.clear();
          print('未结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betListActivity.addAll(page.content);
          print('xiaoan-betlist 结束请求: ${DateTime.now()}');
          state.activityLoading.value=true;
          globalController.unsettlement.value=page.total;
        }else{
          state.betListDone.clear();
          print('已结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betListDone.addAll(page.content);
          state.doneLoading.value=true;
        }
      },
      fail: (String? message) {
        if(settle==0){
          loadActivityInfo(1);
          state.activityLoading.value=true;
          state.activityErro.value=true;
        }else{
          state.doneLoading.value=true;
        }
      },
    );
  }

  void onChickGotoBetting(){
    logicSport.jumpTopTabPage(0);
  }

  void goToMain(String name) {
    Get.back();
    onArticleCollect(name);
  }

  Future<void> onArticleCollect(name) async {
    if (name == 'casino') {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
    } else {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
    }
  }

}
