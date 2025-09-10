import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/pages/sport/sport_detail/model.dart';
import 'package:flutter_bet/pages/sport/tabmodel.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/sport/custom_sport_odd_type.dart';
import 'package:get/get.dart';
import 'package:synchronized/synchronized.dart';

class SportSideState {
  SportSideState() {
    ///Initialize variables
  }
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  late TabController tabController;
  final lock = Lock();
  ///娱乐城投注临时数据
  late RxList<BetSlipData> betSlipList;
  late List<SportBetBean> betSportList;
  late List<CompetitionBean> competitonList;
  RxInt hall_hall_index = 0.obs;
  RxInt hall_hot_index = 0.obs;
  RxInt fav_hot_index = 0.obs;
  RxInt fav_comming_index = 0.obs;
  RxInt rolling_index = 0.obs;
  RxInt comming_index = 0.obs;

  int chall_hall_index = 0;
  int chall_hot_index = 0;
  int cfav_hot_index = 0;
  int cfav_comming_index = 0;
  int crolling_index = 0;
  int ccomming_index = 0;

  int m = 3;

  SportHallCountModel cfm = SportHallCountModel(si: 0,sn: 'all',c: 0,lc:0,nc: 0);

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

// tab 控制器
  late TabController bottomTabController;

  Rx<SportCategotyType> sportCategotyType = SportCategotyType.sport_hall.obs;
  Rx<int> cagetoryTabbarInitIndex = 0.obs;

  RxList<SportHallCountModel> tabs = <SportHallCountModel>[].obs;
  RxList<SportHallCountModel> favTabs = <SportHallCountModel>[].obs;
  RxList<SportHallCountModel> commingTabs = <SportHallCountModel>[].obs;

  RxList<SportMatchModel> oldRollingMatchList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> oldHotMatchList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> oldComingMatchList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> rollingMatchList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> hotMatchList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> comingMatchList = <SportMatchModel>[].obs;

  RxList<SportMatchModel> oldFavHotList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> oldFavCommingList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> favHotList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> favCommingList = <SportMatchModel>[].obs;
  RxList<SportMatchModel> updateList = <SportMatchModel>[].obs;

  int rollingCount = 20;
  int hotCount = 20;
  int commingCount = 20;
  int rollingMoreCount = 100;
  int hotMoreCount = 100;
  int commingMoreCount = 100;


  bool rollingShowMore = true;
  bool hotShowMore = true;
  bool commingShowMore = true;

  RxList<String> favedList = <String>[].obs;

  Rx<bool> isShimmerView = false.obs;//是否显示骨架屏

  Timer? myTimer;
  int sit = 0;
  int favHotSit = 0;
  int favComminghSit = 0;
  int commingSit = 0;

  var tabbarCategoryJson = [
    {
      "icon": 'assets/images/sport/sport_hall.webp',
      "name": S.current.sport_tabbar_hall,
      // "tgn": S.current.sport_tabbar_hall,
      // "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_bet.webp',
      "name": S.current.sport_tabbar_mybet,
      // "tgn": S.current.sport_tabbar_mybet,
      // "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_collection.webp',
      "name": S.current.sport_tabbar_favorites,
      // "tgn": S.current.sport_tabbar_favorites,
      // "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_rolling.webp',
      "name": S.current.sport_tabbar_rolling,
      // "tgn": S.current.sport_tabbar_rolling,
      // "tgi": 0,
    },
    {
      "icon": 'assets/images/sport/sport_coming.webp',
      "name": S.current.sport_tabbar_coming,
      // "tgn": S.current.sport_tabbar_coming,
      // "tgi": 0,
    }
  ];




  // var bottomTabs = [
  //   Tab(
  //     child: Text('娱乐城投注', style: ThemeService().theme.textTheme.bodyMedium),
  //     // icon: CustomIcon(
  //     //   asset: 'assets/images/home/ic_drake.png',
  //     // ),
  //   ),
  //   Tab(
  //     child: Text('体育投注', style: ThemeService().theme.textTheme.bodyMedium),
  //     // icon: CustomIcon(
  //     //   asset: 'assets/images/home/ic_drake.png',
  //     // ),
  //   ),
  //   Tab(
  //     child: Text('竞赛类排行榜', style: ThemeService().theme.textTheme.bodyMedium),
  //     // icon: CustomIcon(
  //     //   asset: 'assets/images/home/ic_drake.png',
  //     // ),
  //   ),
  // ].obs;

  // var betSlipList = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
  //     .map((e) => BetSlipData(
  //         name: 'Blackjack',
  //         icon: 'assets/images/bet_slip/ic_bet_list_icon.webp',
  //         money: '4423.42114....',
  //         moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp'))
  //     .toList()
  //     .obs;

  var imagesTwo = [
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
    'assets/images/home/ic_casino_image_two.webp',
  ].obs;
}
