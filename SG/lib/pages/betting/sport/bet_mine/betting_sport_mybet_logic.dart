import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:get/get.dart';

import '../../../../controllers/global_state_controller.dart';
import '../../../../generated/l10n.dart';
import '../../../../model/sport/sport_bet_list_model.dart';
import '../../../../services/api/api_service.dart';
import '../../../../services/event/event_service.dart';
import '../../../../services/theme/theme_service.dart';
import '../../../../utils/json_util.dart';
import '../../../../widget/custom_icon.dart';
import '../../../main/code.dart';
import '../../../sport/logic.dart';
import '../../../sport/sport_detail/model.dart';
import '../../common_model/betting_common_params.dart';
import 'betting_sport_mybet_state.dart';

class BettingSportMyBetLogic extends BaseController with GetTickerProviderStateMixin {
  final BettingSportMyBetState state = BettingSportMyBetState();
  final GlobalStateController globalController = GlobalStateController.of();
  final logicSport = MessageLogic.of();

  ///获取实例， 多地方调用，单例模式；
  static BettingSportMyBetLogic of() {
    //判断是否注册，没有实例就实例一个，避免在内存中没有对象，抛异常
    bool isRegistered = Get.isRegistered<BettingSportMyBetLogic>();
    // log("BettingSportMyBetLogic...isRegistered...$isRegistered");
    if (isRegistered) {
      return Get.find<BettingSportMyBetLogic>();
    } else {
      return Get.put<BettingSportMyBetLogic>(BettingSportMyBetLogic());
    }
  }

  late TabController myBetTabController;

  ///我的投注tab
  final myBetTabs = [
    Tab(
      icon: const CustomIcon(
        asset: 'assets/images/bet_slip/ic_bet_sigle.webp',
      ),
      child: Text(S.current.active_bet,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
    Tab(
      icon: const CustomIcon(
        asset: 'assets/images/bet_slip/ic_bet_together.webp',
      ),
      child: Text(S.current.settled_bet,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    myBetTabController = TabController(length: myBetTabs.length, vsync: this);
    loadActivityInfo(0);
  }

  @override
  void onClose() {
    myBetTabController.dispose();
  }

  ///获取投注列表： 未结算  和  已结算
  Future<void> loadActivityInfo(int settle) async {
    await ApiService.instance.getBetList(
      page: 1,
      sttle: settle,
      cur: globalController.currTypeSelected.value.cur ?? '',
      success: (page) {
        if (settle == 0) {
          state.activityErro.value = false;
          loadActivityInfo(1);
          state.betUnBillListObs.clear();
          log('未结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betUnBillListObs.addAll(page.content);
          log('xiaoan-betlist 结束请求: ${DateTime.now()}');
          Future.delayed(Duration(milliseconds: 500), () {
            state.activityLoading.value = true;
          });
          globalController.unsettlement.value = page.total;
        } else {
          state.betBilledListObs.clear();
          log('已结算下注列表：${JsonUtil.encodeObj(page.content)}');
          state.betBilledListObs.addAll(page.content);
          Future.delayed(Duration(milliseconds: 500), () {
            state.doneLoading.value = true;
          });
        }
      },
      fail: (String? message) {
        state.betUnBillListObs.clear();
        state.betBilledListObs.clear();
        globalController.unsettlement.value = 0;
        if (settle == 0) {
          loadActivityInfo(1);
          Future.delayed(Duration(milliseconds: 500), () {
            state.activityLoading.value = true;
          });

          state.activityErro.value = true;
        } else {
          Future.delayed(Duration(milliseconds: 500), () {
            state.doneLoading.value = true;
          });
        }
      },
    );
  }

  // void onClickGotoBetting() {
  //   EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
  //   logicSport.jumpTopTabPage(0);
  // }

  ///我的投注页面中， 没有投注的情况下， 点击"立即开始下注" 跳转到首页的对应的 娱乐城 或者 体育见面
  Future<void> onClickEmptyBettingToHome(BettingFromPageType type) async {
    switch (type) {
      case BettingFromPageType.sideMenuBettingCasinoType:
        Get.back();
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
        globalController.buttonSelectIndex.value = 1;
        break;
      case BettingFromPageType.sideMenuBettingSportType:
        Get.back();
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
        globalController.buttonSelectIndex.value = 3;
        break;

      case BettingFromPageType.insideBettingSportType:
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
        logicSport.jumpTopTabPage(0);
        break;
      default:
        EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
        logicSport.jumpTopTabPage(0);
        break;
    }
  }

  ///未计算 订单中，订单详情， 点击复投
  void onClickDetailReBetting(List<M> list) {
    if (list.isNotEmpty) {
      for (var m in list) {
        m.isChoose = true;
      }
      globalController.bets.addAll(list);
    }
    Get.back();
  }
}
