import 'package:flutter/material.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

import '../../generated/l10n.dart';
import '../../model/yulecheng/gamelist_model.dart';
import '../../model/yulecheng/yulecheng_changguan_model.dart';
import '../../services/theme/theme_service.dart';
import '../../widget/custom_icon.dart';
import '../betting/casino/betting_casino_state.dart';

class FrontState {
  late RxList<String> banner;
  late RxList<Tab> tabs;
  late RxString casinoContentOne;
  late RxString casinoContentTwo;
  late RxString sportContentOne;
  late RxString sportContentTwo;
  late TabController? tabController;
  late TabController? tabControllerTwo;
  late RxList<String> imagesOne;
  late RxList<String> imagesTwo;
  late RxList<Tab> tabsTwo;

  ///娱乐城投注临时数据
  late RxList<BetSlipData> betSlipList;

  ///娱乐城列表临时数据
  late RxList<GameListModel> dataArray;
  late RxList<GameListModel> zhenrendataArray;
  late RxList<YuLeChengChangGuanModel> changguanDataArray =
      <YuLeChengChangGuanModel>[].obs;
  late RxString marqueeText = ''.obs;
  late RxDouble xOffset = 0.0.obs;

  FrontState() {
    dataArray = <GameListModel>[].obs;
    zhenrendataArray = <GameListModel>[].obs;
    banner = [
      'https://via.placeholder.com/288x188',
      'https://via.placeholder.com/288x188',
      'https://via.placeholder.com/288x188',
      'https://via.placeholder.com/288x188',
      'https://via.placeholder.com/288x188',
    ].obs;
    tabs = [
      Tab(
        child: Text('Slot', style: ThemeService().theme.textTheme.bodyMedium),
        icon: CustomAssetIcon(
          name: 'assets/images/home/ic_slot.webp',
        ),
      ),
      Tab(
        child: Text('Live', style: ThemeService().theme.textTheme.bodyMedium),
        icon: CustomAssetIcon(
          name: 'assets/images/home/ic_live_icon.webp',
        ),
      ),
    ].obs;
    tabsTwo = [
      Tab(
        child: Text(S.current.casino_bet,
            style: ThemeService().theme.textTheme.bodyMedium),
      ),
      Tab(
        child: Text(S.current.sport_bet,
            style: ThemeService().theme.textTheme.bodyMedium),
      ),
      Tab(
        child: Text(S.current.race_leaderboard,
            style: ThemeService().theme.textTheme.bodyMedium),
      ),
    ].obs;
    casinoContentOne = S.current.casino_des_one.obs;
    casinoContentTwo = S.current.casino_des_two.obs;
    sportContentOne = S.current.sport_des_one.obs;
    sportContentTwo = S.current.sport_des_two.obs;
    imagesOne = [
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
      'assets/images/home/ic_casino_image_two.webp',
      'assets/images/home/ic_game_image_two.webp',
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
    betSlipList = [
      BetSlipData(
          name: 'Blackjack',
          icon: 'assets/images/bet_slip/ic_bet_list_icon.webp',
          money: '4423.42114....',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp'),
    ].obs;
    for (int i = 0; i < 20; i++) {
      betSlipList.add(BetSlipData(
          name: 'Blackjack',
          icon: 'assets/images/bet_slip/ic_bet_list_icon.webp',
          money: '4423.42114....',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp'));
    }
  }
}
