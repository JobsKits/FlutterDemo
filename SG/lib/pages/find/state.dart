import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';

import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/pages/sport/sportbannermodel.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../services/theme/theme_service.dart';
import '../betting/casino/betting_casino_state.dart';

class CasinoState {
  // 轮播
  RxList<SportBannerModel> bannnerList = <SportBannerModel>[].obs;
  // 跑马灯
  late RxString marqueeText = ''.obs;

  late RxList<Tab> tabs;
  List<Nav> navs = [];
  late RxList<String> imges;
  late List<Litem> dataArray = <Litem>[].obs;
  late List<GameLobbyModel> dataArrayNoLitems = <GameLobbyModel>[];

  late RxList<GameListModel> ty2DataArray = <GameListModel>[].obs;
  late RxList<YuLeChengChangGuanModel> cgDataArray = <YuLeChengChangGuanModel>[].obs;
  late RxList<Sum> changguanSumArray = <Sum>[].obs;

  late PageController pageController;
  late RxInt currentPage;

  late RxList<String> imagesOne;
  late RxList<String> imagesTwo;
  late RxList<Tab> tabsTwo;
  int totalGame = 0;
  //显示每个listview的状态
  late Map<String, List<bool>> showStatus = {};
  late Map<String, int> showArrawStatus = {};

  /// 判断收藏夹还是近期游戏记录
  ///
  String currentName = "";

  bool isLoadingFinished = false;

  // 缓存数据
  Map lobbyData = Map();

  String animationIndex = "";

  CasinoState() {
    pageController = PageController();
    // banner = [
    //   'assets/images/sport/sport_banner.webp',
    //   'assets/images/sport/sport_banner.webp',
    //   'assets/images/sport/sport_banner.webp',
    //   // 'https://via.placeholder.com/288x188',
    //   // 'https://via.placeholder.com/288x188',
    //   // 'https://via.placeholder.com/288x188',
    //   // 'https://via.placeholder.com/288x188',
    // ].obs;
    tabs = [
      Tab(
        child: Text(S.current.sport_tabbar_hall,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        // icon: CustomIcon(
        //   asset: 'assets/images/home/ic_drake.png',
        // ),
      ),
      Tab(
        child: Text(S.current.yulecheng_special_slot,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        // icon: CustomIcon(
        //   asset: 'assets/images/home/ic_drake.png',
        // ),
      ),
      Tab(
        child: Text(S.current.yulecheng_casino,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        // icon: CustomIcon(
        //   asset: 'assets/images/home/ic_drake.png',
        // ),
      ),
      // Tab(
      //   child: Text('游戏节目', style: ThemeService().theme.textTheme.bodyMedium),
      //   icon: CustomIcon(
      //     asset: 'assets/images/home/ic_drake.png',
      //   ),
      // ),
      // Tab(
      //   child: Text('Stake原创游戏', style: ThemeService().theme.textTheme.bodyMedium),
      //   icon: CustomIcon(
      //     asset: 'assets/images/home/ic_drake.png',
      //   ),
      // ),
    ].obs;

    imges = [
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
      'assets/images/home/ic_casino_image_one.webp',
    ].obs;
    tabsTwo = [
      Tab(
        child: Text(S.current.casino_bet, style: ThemeService().theme.textTheme.bodyMedium),
      ),
      Tab(
        child: Text(S.current.sport_bet, style: ThemeService().theme.textTheme.bodyMedium),
      ),
      Tab(
        child: Text(S.current.race_leaderboard, style: ThemeService().theme.textTheme.bodyMedium),
      ),
    ].obs;
    imagesOne = [
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
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
    ].obs;
    imagesTwo = [
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
}
