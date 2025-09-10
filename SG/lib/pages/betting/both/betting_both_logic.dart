import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../generated/l10n.dart';
import '../../../model/sport/sport_bet_list_model.dart';
import '../../../services/theme/theme_service.dart';
import '../../../widget/betting_list/logic.dart';
import '../../../widget/custom_icon.dart';
import '../../alliance_plan/widget/custom_select_model.dart';
import '../sport/betting_sport_state.dart';

class BettingBothLogic extends BaseController with GetTickerProviderStateMixin {
  ///投注活跃数据
  var betListDone = <ListElement>[].obs;
  var betListActivity = <ListElement>[].obs;

  final isShowSelectWidget = false.obs;

  late TabController myBetTabController;
  late TabController bottomTabController;

  final myBetTabs = [
    Tab(
      child: Text(S.current.tab_bar_ent,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/bet_slip/ic_bet_sigle.webp',
      // ),
    ),
    Tab(
      child: Text(S.current.tab_bar_sports,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/bet_slip/ic_bet_together.webp',
      // ),
    ),
  ].obs;

  final List<CustomSelectModel> selectModelList = [
    CustomSelectModel(S.current.active_bet, type: 0),
    CustomSelectModel(S.current.settled_bet, type: 1),
  ];

  final bottomTabs = [
    // Tab(
    // child: Text(S.current.sport_tabbar_mybet, style: ThemeService().theme.textTheme.bodyMedium),
    // // icon: CustomIcon(
    // //   asset: 'assets/images/home/ic_drake.png',
    // // ),
    // ),
    Tab(
      child: Text(S.current.all_bet,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: Text(S.current.billboard,
          style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: <Widget>[
        Text(S.current.random_text_268, style: ThemeService().theme.textTheme.bodyMedium),
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(
            color: ThemeService().colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(4),
          ),
        ).paddingLeft(AppValues.halfPadding),
      ].toRow(),
    ),
  ].obs;

  final betSportList = [
    SportBetBean(
      betTitle: S.current.random_text_272,
      money: '-4423.42114....',
    ),
  ].obs;
  final competitonList = [
    CompetitionBean(
        name: S.current.random_text_238,
        icon: 'assets/images/bet_slip/ic_no_one.webp',
        money: '\$19,782,2390',
        moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
        bonusMoney: '35%'),
  ].obs;

  final ScrollController rankListScrollCtrl = ScrollController();

  @override
  void dispose() {
    rankListScrollCtrl.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    GlobalState.instance.index = 7;
    var tabIndex = GlobalStateController.of().menuSelectType.value;
    // log("我的投注...tabIndex...$tabIndex");
    isShowSelectWidget.value = tabIndex != 0;
    myBetTabController =
        TabController(initialIndex: tabIndex, length: myBetTabs.length, vsync: this);
    myBetTabController.addListener(
      () {
        if (myBetTabController.index.toDouble() == myBetTabController.animation?.value) {
          ///第一个是娱乐城的 我的订单，隐藏
          isShowSelectWidget.value = myBetTabController.index != 0;
        }
      },
    );

    intBottomTab();
  }

  void intBottomTab() {
    bottomTabController = TabController(length: bottomTabs.length, vsync: this);
  }

  @override
  void onClose() {
    GlobalState.instance.index = -1;
    myBetTabController.dispose();
    bottomTabController.dispose();
    super.onClose();
  }
}
