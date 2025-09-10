
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

import '../../../generated/l10n.dart';
import '../sport_detail/model.dart';


class Sport_champion_detailState {
  Sport_champion_detailState() {
    ///Initialize variables
  }

  final GlobalStateController g = Get.find<GlobalStateController>();

  Rx<SportDetailModel> model = SportDetailModel(delta: -999).obs;
  RxList<Ml> list = <Ml>[].obs;
  RxList<Ml> searchinglist = <Ml>[].obs;
  final lock = Lock();

  Timer? myTimer;

  late TabController tabController;

  late TextEditingController textController;

  var expand = false.obs;
  int cagetoryTabbarInitIndex = 0;
  int chooseCid = -1;
  bool isSearching = false;

  var firstLoad = true.obs;

  var si = 1.obs;
  var ci = 0.obs;
  var ei = '54258177'.obs;

  var tabbarCategoryJson = [
    {
      "icon": 'assets/images/sport/sport_hall.webp',
      "name": S.current.sport_tabbar_hall,
    },
    {
      "icon": 'assets/images/sport/sport_bet.webp',
      "name": S.current.sport_tabbar_mybet,
    },
    {
      "icon": 'assets/images/sport/sport_collection.webp',
      "name": S.current.sport_tabbar_favorites,
    },
    {
      "icon": 'assets/images/sport/sport_rolling.webp',
      "name": S.current.sport_tabbar_rolling,
    },
    {
      "icon": 'assets/images/sport/sport_coming.webp',
      "name": S.current.sport_tabbar_coming,
    }
  ];

  late RxList<Tab> bottomTabs = [
    Tab(
      child: Text(S.current.all_bet, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: Text(S.current.billboard, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      // icon: CustomIcon(
      //   asset: 'assets/images/home/ic_drake.png',
      // ),
    ),
    Tab(
      child: <Widget>[
        Text(S.current.random_text_268, style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
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

  late TabController bottomTabController;
  late RxList<BetSlipData> betSlipList;
  late List<SportBetBean> betSportList;
  late List<CompetitionBean> competitonList;
}
