import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:get/get.dart';

import '../../../base/getx/base_controller.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/betting_list/logic.dart';
import '../../../widget/custom_text.dart';
import '../common_model/bet_slip_type_model.dart';
import '../sport/betting_sport_state.dart';
import 'betting_casino_state.dart';

class BettingCasinoLogic extends BaseController with GetTickerProviderStateMixin {
  final BettingCasinoState state = BettingCasinoState();
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final allPageTag = DateTime.now().toString(); //所有投注
  final stormPageTag = DateTime.now().toString(); //风云
  final racePageTag = DateTime.now().toString(); //竞赛

  ///用来监听 是否为空， 在登陆状态下， 为空的话 下拉框中也不显示 "我的投注"
  final myBetLength = 0.obs;

  ///当前已选择投注单类型
  // final chooseTypeModelObs = BetSlipTypeModel(title: '', type: BetSlipTypeEnum.betBill,icon:'assets/images/bet_slip/ic_casino_my_bet.webp' ).obs;
  final chooseTypeModelObs = BetSlipTypeModel(
          title: '',
          type: BettingTypeEnum.myBet,
          icon: 'assets/images/bet_slip/casino/ic_betting_casino_mybet.webp')
      .obs;
  final casinoTypeListObs = <BetSlipTypeModel>[
    BetSlipTypeModel(
        type: BettingTypeEnum.myBet,
        title: S.current.sport_tabbar_mybet,
        isHide: false,
        icon: 'assets/images/bet_slip/casino/ic_betting_casino_mybet.webp'),
    BetSlipTypeModel(
        type: BettingTypeEnum.allBet,
        title: S.current.all_bet,
        icon: 'assets/images/bet_slip/casino/ic_betting_casino_mybet.webp'),
    BetSlipTypeModel(
        type: BettingTypeEnum.stormRanking,
        title: S.current.billboard,
        icon: 'assets/images/bet_slip/casino/ic_betting_casino_storm.webp'),
    BetSlipTypeModel(
        type: BettingTypeEnum.raceRanking,
        title: S.current.data_count_race,
        icon: 'assets/images/bet_slip/casino/ic_betting_casino_race.webp'),
  ].obs;

  ///配置index 索引。下拉选择，对应的页面索引
  final Map<BettingTypeEnum, int> indexMapConfig = {
    BettingTypeEnum.myBet: 0,
    BettingTypeEnum.allBet: 1,
    BettingTypeEnum.stormRanking: 2,
    BettingTypeEnum.raceRanking: 3,
  };

  ///娱乐城投注单分类
  // final  casinoTypeList = <BetSlipType>[].obs;
  // chooseType =
  // BetSlipType(title: S.current.sport_tabbar_mybet, typeId: 1, icon: 'assets/images/bet_slip/ic_casino_my_bet.webp')
  //     .obs;

  @override
  void onInit() {
    super.onInit();
    log("BettingCasinoLogic...onInit()...");
    chooseTypeModelObs.value = casinoTypeListObs[0];

    initSelectStatusWithShow(globalController.isLogin.value);
    ever(globalController.isLogin, (isLogin) {
      initSelectStatusWithShow(isLogin);
    });
  }

  @override
  void onReady() {
    super.onReady();
    // log("BettingCasinoLogic...onReady()...");
  }

  @override
  void dispose() {
    super.dispose();
    // log("BettingCasinoLogic...dispose()...");
  }

  ///【情况一：】未登录状态下，“投注”页，默认显示“所有投注”，没有“我的投注”这个选项
  ///【情况二：】需求：投注-有数据的情况下有“我的投注”，反之隐藏这个菜单【登录状态下】
  void initSelectStatusWithShow(bool isShow) {
    if (isShow) {
      casinoTypeListObs[0].isHide = false;

      ///是否是被选中的
      if (chooseTypeModelObs.value.type == BettingTypeEnum.myBet) {
        chooseTypeModelObs.value = casinoTypeListObs[0];
      } else if (chooseTypeModelObs.value.type == BettingTypeEnum.allBet) {
        chooseTypeModelObs.value = casinoTypeListObs[1];
      }
    } else {
      casinoTypeListObs[0].isHide = true;
      if (chooseTypeModelObs.value.type == BettingTypeEnum.myBet) {
        chooseTypeModelObs.value = casinoTypeListObs[1];
      }
    }
  }

  buildData() {
    casinoTypeListObs.value = [
      BetSlipTypeModel(
          type: BettingTypeEnum.myBet,
          title: S.current.sport_tabbar_mybet,
          isHide: !globalController.isLogin.value || myBetLength.value == 0,
          icon: 'assets/images/bet_slip/casino/ic_betting_casino_mybet.webp'),
      BetSlipTypeModel(
          type: BettingTypeEnum.allBet,
          title: S.current.all_bet,
          icon: 'assets/images/bet_slip/casino/ic_betting_casino_mybet.webp'),
      BetSlipTypeModel(
          type: BettingTypeEnum.stormRanking,
          title: S.current.billboard,
          icon: 'assets/images/bet_slip/casino/ic_betting_casino_storm.webp'),
      BetSlipTypeModel(
          type: BettingTypeEnum.raceRanking,
          title: S.current.data_count_race,
          icon: 'assets/images/bet_slip/casino/ic_betting_casino_race.webp'),
    ].obs;
    for (var element in casinoTypeListObs) {
      if (chooseTypeModelObs.value.type == element.type) {
        chooseTypeModelObs.value = element;
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
