import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/utils/l10n_language2.dart';
import 'package:get/get.dart';

import '../../generated/l10n.dart';
import '../../widget/expansion/expand_item_model.dart';
import '../../widget/expansion/expand_list_model.dart';
import '../../model/sport/search_sport_model.dart';
import '../../model/yulecheng/gamelist_model.dart';
import '../activity/a_model/activity_common_params.dart';
import 'amodel/home_common_params.dart.dart';
import 'amodel/navigation_item_info.dart';
import 'home_state_casino.dart';
import 'home_state_sport.dart';

class HomeState with HomeCasinoState, HomeSportState {
  late Map<int, String> selectedMap;

  ///活动id
  String pid = '';
  String currencyId = '';
  final rollTimes = 0.obs;
  final getRollData = false.obs;
  final getRollRecords = false.obs;
  
  LuckyRecordState luckyRecordState = LuckyRecordState.noData;

  ///缩放比例
  final scale = 1.0.obs;

  ///选中行的index
  // int selectIndex = -1;
  final RxInt selectIndex = RxInt(-1);

  ///当前选择的体育还是娱乐城 0: 娱乐城 1: 体育
  late RxInt selectedType;

  ///当前展示内容 0: 导航 1: 搜索详情页
  late RxInt showInfoType;

  ///搜索详情页展示内容 0：提示至少3个字符+搜索记录 1:搜索无结果+搜索记录 2:展示搜索结果（搜索记录与搜索结果与{selectedType}相关）
  late RxInt showSearchType;

  ///输入框已输入文本
  late RxString searchContent;

  ///输入框文本控制器
  late TextEditingController textController;

  ///娱乐城导游戏，注意第一个标题： 游戏
  List<NavigationItemInfo> casinoTwo = [
    NavigationItemInfo(title: RxString(S.current.home_game)),
  ].obs;

  ///公共的扩展数据map
  late Map<NavEnum, ExpandListModel> expandCommonData;

  late RxList<ExpandListModel> activityDataObs = <ExpandListModel>[].obs; //活动菜单
  // late List<ExpandListModel> activityDataObs = <ExpandListModel>[].obs; //活动菜单

  late RxBool isFocused; // 用于保存焦点状态
  ///搜索历史记录，从SP中取出动态生成
  late RxList<String> history;

  ///搜索娱乐城游戏结果
  late RxList<GameListModel> searchCasinoList;
  late RxList<SearchSportModelList> searchSportList;

  ///当前搜索体育列表数据
  late Rx<SearchSportModelList> searchItem;
  late RxList<ListList> listList;
  late RxString chooseSn;
  late RxInt chooseSi;
  late List<Tab> tabs = <Tab>[].obs;

  ///滚球赛事总数
  late RxString rcb;

  HomeState() {
    isFocused = false.obs;
    selectedType = 0.obs;
    searchContent = ''.obs;
    textController = TextEditingController(text: '');
    showInfoType = 0.obs;
    showSearchType = 0.obs;
    history = <String>[].obs;
    searchCasinoList = <GameListModel>[].obs;
    searchSportList = <SearchSportModelList>[].obs;
    listList = <ListList>[].obs;
    rcb = ''.obs;
    chooseSn = ''.obs;
    chooseSi = 0.obs;
  }

  ///初始化数据，静态数据
  buildData() {
    selectedMap = {0: S.current.tab_bar_ent, 1: S.current.tab_bar_sports};
    buildCommonStateData();
    buildCasinoStateData();
    buildSportStateData();
  }

  ///实例化 娱乐城 和 体育 公用的菜单数据
  buildCommonStateData() {
    expandCommonData = <NavEnum, ExpandListModel>{
      ///Odds：小数式[7]
      NavEnum.odds: ExpandListModel(
        showIcon: false,
        value: 11,
        headTitle: S.current.random_text_335,
        headIcon: 'assets/images/home/ic_language.webp',
        item: [
          ExpandItemModel(
              itemId: 5,
              itemTitle: S.current.odds_decimal,
              itemIcon: 'assets/images/home/ic_gift_one.webp'),
          ExpandItemModel(
              itemId: 6,
              itemTitle: S.current.odds_fractional,
              itemIcon: 'assets/images/home/ic_gift_two.webp'),
          ExpandItemModel(
              itemId: 7,
              itemTitle: S.current.odds_american,
              itemIcon: 'assets/images/home/ic_gift_three.webp'),
          ExpandItemModel(
              itemId: 8,
              itemTitle: S.current.odds_indonesian,
              itemIcon: 'assets/images/home/ic_gift_all.webp'),
          ExpandItemModel(
              itemId: 9,
              itemTitle: S.current.odds_hong_kong,
              itemIcon: 'assets/images/home/ic_gift_all.webp'),
          ExpandItemModel(
              itemId: 10,
              itemTitle: S.current.odds_malaysian,
              itemIcon: 'assets/images/home/ic_gift_all.webp'),
        ],
        showRadio: true,
      ),

      ///个人资料
      NavEnum.profile: ExpandListModel(
        showIcon: true,
        value: 0,
        headTitle: S.current.profile,
        headIcon: 'assets/images/home/ic_person_setting.webp',
        item: [
          ExpandItemModel(
              itemId: 1,
              itemTitle: S.current.wallet,
              itemIcon: 'assets/images/home/ic_ wallet.webp'),
          ExpandItemModel(
              itemId: 2, itemTitle: S.current.vault, itemIcon: 'assets/images/home/ic_vault.webp'),
          ExpandItemModel(
              itemId: 3, itemTitle: 'VIP', itemIcon: 'assets/images/home/ic_vip_club.webp'),
          ExpandItemModel(
              itemId: 4,
              itemTitle: S.current.data_count_data,
              itemIcon: 'assets/images/home/ic_statistical_data.webp'),
          ExpandItemModel(
              itemId: 5,
              itemTitle: S.current.notification,
              itemIcon: 'assets/images/home/ic_ notify.webp'),
          // ExpandItem(
          //     itemId: 6,
          //     itemTitle: S.current.sport_bet,
          //     itemIcon: 'assets/images/home/ic_sports_betting.webp'),
          ExpandItemModel(
              itemId: 7,
              itemTitle: S.current.setting,
              itemIcon: 'assets/images/home/ic_setting.webp'),
          ExpandItemModel(
              itemId: 8,
              itemTitle: S.current.logout_text,
              itemIcon: 'assets/images/home/ic_login_out.webp',
              showLine: true),
        ],
        showRadio: false,
      ),

      ///促销活动
      NavEnum.promotions: ExpandListModel(
        showIcon: true,
        value: 1,
        headTitle: S.current.promotions,
        headIcon: 'assets/images/home/ic_gift.webp',
        item: [
          // ExpandItem(
          //     itemId: PromotionsEnum.turntable.id,
          //     itemTitle: S.current.random_text_829,
          //     itemIcon: 'assets/images/home/ic_gift_activity.webp'),
          // ExpandItem(
          //     itemId: PromotionsEnum.lottery.id,
          //     itemTitle: S.current.random_text_296,
          //     itemIcon: 'assets/images/home/ic_gift_one.webp'),
          // ExpandItem(
          //     itemId: PromotionsEnum.race.id,
          //     itemTitle: S.current.random_text_297,
          //     itemIcon: 'assets/images/home/ic_gift_two.webp'),
          // ExpandItem(
          //     itemId:PromotionsEnum.airdrop.id,
          //     itemTitle: S.current.random_text_298,
          //     itemIcon: 'assets/images/home/ic_gift_three.webp'),
          ExpandItemModel(
              itemId: ActivityTypeEnum.all.type,
              itemTitle: S.current.chaKanQuanBu,
              itemIcon: 'assets/images/home/ic_gift_all.webp',
              showLine: true),
        ],
        showRadio: false,
      ),

      ///赞助活动
      NavEnum.sponsorships: ExpandListModel(
        showIcon: true,
        value: 2,
        headTitle: S.current.sponsorships,
        headIcon: 'assets/images/home/ic_sponsor.webp',
        item: [
          ExpandItemModel(
              itemId: 0, itemTitle: 'Drake', itemIcon: 'assets/images/home/ic_drake.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_300,
              itemIcon: 'assets/images/home/ic_alpha.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_301,
              itemIcon: 'assets/images/home/ic_everton.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_302,
              itemIcon: 'assets/images/home/ic_everton.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_303,
              itemIcon: 'assets/images/home/ic_easley.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_304,
              itemIcon: 'assets/images/home/ic_easley.webp'),
          ExpandItemModel(
              itemId: 0,
              itemTitle: S.current.random_text_305,
              itemIcon: 'assets/images/home/ic_volleyball.webp'),
        ],
        showRadio: false,
      ),

      ///语言
      NavEnum.language: ExpandListModel(
        showIcon: false,
        value: 3,
        headTitle: "${S.current.language}${S.current.random_text_306}",
        headIcon: 'assets/images/home/ic_language.webp',
        item: [
          ExpandItemModel(
              itemId: 1,
              itemTitle: L10nLanguage2.CHINESE,
              itemIcon: 'assets/images/home/ic_gift_one.webp'),
          ExpandItemModel(
              itemId: 2, itemTitle: 'English', itemIcon: 'assets/images/home/ic_gift_two.webp'),
          ExpandItemModel(
              itemId: 4, itemTitle: 'Tiếng Việt', itemIcon: 'assets/images/home/ic_gift_all.webp'),
          ExpandItemModel(
              itemId: 3, itemTitle: 'Português', itemIcon: 'assets/images/home/ic_gift_three.webp'),
          ExpandItemModel(
              itemId: 5, itemTitle: 'ภาษาไทย', itemIcon: 'assets/images/home/ic_gift_all.webp'),
          ExpandItemModel(
              itemId: 6, itemTitle: 'हिन्दी', itemIcon: 'assets/images/home/ic_gift_all.webp'),
        ],
        showRadio: true,
      ),
    };
  }
}
