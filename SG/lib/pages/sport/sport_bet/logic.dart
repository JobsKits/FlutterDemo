import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/sport/sport_bet/widget/sport_my_bet_params.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';
import '../../../base/getx/base_controller.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/json_util.dart';
import '../../../widget/sport/custom_sport_odd_type.dart';
import '../../betting/sport/widget/sport_slip_odds_changes_mixin.dart';
import '../logic.dart';
import 'state.dart';

class SportBetLogic extends BaseController
    with GetSingleTickerProviderStateMixin, SportSlipOddsChangesMixin {
  //SingleGetTickerProviderMixin【过时类】
  //GetTickerProviderStateMixin
  //GetSingleTickerProviderStateMixin
  final SportBetState state = SportBetState();
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final logicSport = Get.find<MessageLogic>(); //体育界面

  late  TabController myBetTabController ;
  // final myBetTabController = Rxn();

  @override
  void showOddsChangesAnimation(BuildContext context, Offset startOffset, Size size, String type) {
    super.showOddsChangesAnimation(context, startOffset, size, type);
  }

  final selectTabIndex = 0.obs;


  @override
  void onInit() {
    super.onInit();
    log("我的投注...onInit...");
    myBetTabController = TabController(length: 2, vsync: this);
    // myBetTabController.addListener(() { });
    myBetTabController.addListener(() {
      if(myBetTabController.index.toDouble() == myBetTabController.animation!.value){
        selectTabIndex.value =myBetTabController.index;
      }
    });
    ever(globalController.currTypeSelected, (callback){
      loadActivityInfo(0);
    });
  }

  @override
  void onReady() {
    super.onReady();
    log("我的投注...onReady...");
    // myBetTabController.animateTo(1);
    // loadActivityInfo(0);
  }

  @override
  void onClose() {
    myBetTabController.dispose();
    super.onClose();
  }

  ///获取投注明细
  Future<void> loadActivityInfo(int settle) async {
    state.loading.value = true;
    await ApiService.instance.getBetList(
      page: 1,
      sttle: settle,
      cur: globalController.currTypeSelected.value.cur ?? '',
      success: (page) {
        if (settle == 0) {
          loadActivityInfo(1);
          state.betListActivity.clear();
          print('未结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betListActivity.addAll(page.content);
        } else {
          state.betListDone.clear();
          print('已结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betListDone.addAll(page.content);
          state.loading.value = false;
        }
      },
      fail: (String? message) {
        if (settle == 0) {
          loadActivityInfo(1);
        } else {
          state.loading.value = false;
        }
      },
    );
  }

  void showOddsChange(BuildContext context, Offset startOffset, Size size, String type) {
    print('点击了0');
    showOddsChangesAnimation(context, startOffset, size, type);
  }

  ///点击"立即开始下注"，  跳到到大厅
  void onClickGotoBetting(SportMyBetFromPage? fromPage){
    // logicSport.state.sportCategotyType.value = SportCategotyType.sport_hall;
    // logicSport.state.cagetoryTabbarInitIndex.value = 0;
    if(fromPage!=null && fromPage == SportMyBetFromPage.fromSportHome){
      logicSport.jumpTopTabPage(0);
    }

  }
}
