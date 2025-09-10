import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/extentions/ex_list.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';
import 'package:flutter_bet/model/yulecheng/big_wins_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/betting/casino/betting_casino_state.dart';
import 'package:flutter_bet/pages/betting/sport/betting_sport_state.dart';
import 'package:flutter_bet/pages/find/YulechengCategoryPage/index.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/extension/wallet_api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/betting_list/logic.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';

import '../../../base/getx/base_controller.dart';
import '../../../services/api/api_service.dart';
import '../../web_browser/logic.dart';
import 'package:flutter_bet/routes/routes.dart';

class YulechenggamedetailsController extends BaseController with GetTickerProviderStateMixin {
  YulechenggamedetailsController();
  BuildContext? context;

  // 热门游戏
  late List<GameListModel> hotDataList;

  // 中间点击展开tabbar
  bool isShowDescription = true;
  final isCollect = false.obs; //是否收藏

  var currentPageTitle = "".obs; // 标题
  late GameLobbyModel lobbyModel; // = Get.arguments["model"];
  late GameListModel items; // = Get.arguments["listmodel"];
  String prePage = Get.arguments["prePage"];
  // 大赢家 tab 控制器
  late TabController bigWinsTabC;
  int bigWinsSelIndex = 0;
  var scale = 1.0;
  final List<List<BigWinsModel>> bigWinsInfos = [[], []];

  late String currency = "";

  late RxList<GameListModel> hotDataArray = <GameListModel>[].obs;

  late List<CurrencyBean> currencyList = <CurrencyBean>[];

  late List<YuLeChengChangGuanModel> changguanDataArray = [];
  bool isInitialized = false;

  ///娱乐城投注临时数据
  late RxList<BetSlipData> betSlipList;
  late List<SportBetBean> betSportList;
  late List<CompetitionBean> competitonList;
  late RxList<Tab> bottomTabs;
  // tab 控制器
  late TabController bottomTabController;
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  String? platformName = Get.arguments["platformName"] ?? "";

  ScrollController scrollController = ScrollController();

  _initData() {
    ever(globalController.isLogin, (isLogin) {
      update(["yulechenggamedetails"]);
    });
  }

  void onTap() {}

  ///点击收藏
  void onCollectTap() {
    updateCollect(items.isFav != 1);
  }

  @override
  void onInit() {
    isCollect.value = false;
    super.onInit();
    getHotList();
    initData();
    bigWinsTabC = TabController(length: 2, vsync: this, initialIndex: 0);
    bigWinsTabC.addListener(() {
      bigWinsSelIndex = bigWinsTabC.index;
      reqBigWins(bigWinsTabC.index);
      update(['yulechenggamedetails']);
    });
    bottomTabController = TabController(length: bottomTabs.length, vsync: this);
    if (prePage == "catePage") {
      print("shujulaidaozhelile--catePage");
      items = Get.arguments["listmodel"];
      currentPageTitle.value = items.name;
      getGameDetails(items.id, items.gameId, items.platformId);
      // getHotList(items.platformId);
    } else {
      final temModel = Get.arguments["model"];
      print("shujulaidaozhelile-0");

      if (temModel is GameListModel) {
        items = temModel;
        lobbyModel = GameLobbyModel(
          id: temModel.id,
          platformId: temModel.platformId,
          name: temModel.name,
          // gameType: "",
          gameId: temModel.gameId,
          img: temModel.img,
          // sorting: 0,
          // createdAt: 0,
          // isHot: 0,
          // isNew: 0,
          // isFav: 0
        );
        print("shujulaidaozhelile-1");
        currentPageTitle.value = lobbyModel.name;
        getGameDetails(lobbyModel.id, lobbyModel.gameId, lobbyModel.platformId);
      }
      if (temModel is GameLobbyModel) {
        print("shujulaidaozhelile-2");
        items = GameListModel(
            id: temModel.id,
            platformId: temModel.platformId,
            name: temModel.name,
            gameType: "",
            gameId: temModel.gameId,
            img: temModel.img,
            sorting: 0,
            createdAt: 0,
            isHot: 0,
            isNew: 0,
            isFav: 0);

        lobbyModel = temModel;
        currentPageTitle.value = lobbyModel.name;
        getGameDetails(lobbyModel.id, lobbyModel.gameId, lobbyModel.platformId);
      }
      print(temModel.runtimeType is GameLobbyModel);
      print("shujulaidaozhelile-1 ${temModel.runtimeType}");
      // lobbyModel = Get.arguments["model"];

      // getHotList(lobbyModel.platformId);
    }

    // TODO: 临时解决方案
    // final temModel = Get.arguments["model"];
    // if(temModel is GameLobbyModel) {
    //   items = GameListModel(
    //       id: temModel.id,
    //       platformId: temModel.platformId,
    //       name: temModel.name,
    //       gameType: "",
    //       gameId: temModel.gameId,
    //       img: temModel.img,
    //       sorting: 0,
    //       createdAt: 0,
    //       isHot: 0,
    //       isNew: 0,
    //       isFav: 0
    //   );
    // }else {
    //   items = temModel;
    // }

    // currentPageTitle.value = items.name;
    // getGameDetails(items.id, items.gameId, items.platformId);
    getPlatdata();
  }

  refreshDataCatePage(items) {
    scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    currentPageTitle.value = items.name;
    getGameDetails(items.type, items.gameId, items.platformId);
    // getHotList(items.platformId);
    getHotList();
  }

  refreshDataLobbyPage(lobbyModel) {
    scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    currentPageTitle.value = lobbyModel.name;
    getGameDetails(lobbyModel.type, lobbyModel.gameId, lobbyModel.platformId);
    // getHotList(lobbyModel.platformId);
    getHotList();
  }

  initData() {
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
    betSportList = [
      SportBetBean(
        betTitle: S.current.random_text_272,
        money: '-4423.42114....',
      ),
    ].obs;
    competitonList = [
      CompetitionBean(
          name: S.current.random_text_238,
          icon: 'assets/images/bet_slip/ic_no_one.webp',
          money: '\$19,782,2390',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
          bonusMoney: '35%'),
    ].obs;
    for (int i = 0; i < 20; i++) {
      betSportList.add(SportBetBean(
        betTitle: S.current.random_text_272,
        money: '-4423.42114....',
      ));
    }
    for (int i = 0; i < 20; i++) {
      competitonList.add(CompetitionBean(
          name: S.current.random_text_238,
          icon: 'assets/images/bet_slip/ic_no_two.webp',
          money: '\$19,782,2390',
          moneyIcon: 'assets/images/bet_slip/ic_eth_bet_icon.webp',
          bonusMoney: '35%'));
    }
    bottomTabs = [
      Tab(
        child: Text(S.current.casino_bet,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        // icon: CustomIcon(
        //   asset: 'assets/images/home/ic_drake.png',
        // ),
      ),
      Tab(
        child: Text(S.current.sport_bet,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        // icon: CustomIcon(
        //   asset: 'assets/images/home/ic_drake.png',
        // ),
      ),
      Tab(
        child: <Widget>[
          Text(S.current.random_text_268,
              style:
                  ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
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
  }

  // 获取平台数据
  getPlatdata() async {
    await ApiService.instance.getAllPlatForm(success: (dataInfo) {
      changguanDataArray.clear();
      changguanDataArray.addAll(dataInfo.games);
      update(['yulechenggamedetails']);
    }, fail: (message) {
      print(message);
    });
  }

  // 获取大赢家信息
  Future<void> reqBigWins(index) async {
    await ApiService.instance.getRankingList(
      gameClass: items.gameType,
      gameCode: items.gameId,
      type: index == 0 ? "1" : "0",
      success: (data) async {
        bigWinsInfos[index] = data.content;
        update(['yulechenggamedetails']);
      },
      fail: (message) {},
    );
  }

  @override
  void onReady() {
    super.onReady();

    _initData();
  }

  void openValueDidChange() {
    isShowDescription = !isShowDescription;
    update(["yulechenggamedetails"]);
  }

  List<String> getCurrencyList(string) {
    List currencyListMapList = jsonDecode(string);
    List<String> currencyList = [];
    for (var element in currencyListMapList) {
      currencyList.add(element);
    }
    return currencyList;
  }

  onCurrentChanged(currency) {
    this.currency = currency;
    update(["yulechenggamedetails"]);
  }

//货币信息
  void currencyConfig() {
    // Completer<List<CurrencyBean>> completer = Completer<List<CurrencyBean>>();
    ApiService.instance.currencyConfig<CurrencyBean>(
      success: (list) {
        // completer.complete(list);
        currencyList.addAll(list);
        update(["yulechenggamedetails"]);
      },
      fail: (errorMessage) {
        // completer.completeError(errorMessage ?? "");
      },
    );
    // return completer.future;
  }

  String getCoinUrlWithCoinName(String name) {
    var coinInfo = currencyList.firstWhere((element) => element.name == name);
    // print('"https://d2utx4nptvgikt.cloudfront.net/currency/${coinInfo.cur}.webp"');
    return "${AppValues.defaultBranch.asset_url}/currency/${coinInfo.cur}.webp";
  }

  /// 获取币种Cur
  String getCoinCurWithCoinName(String name) {
    var coinInfo = currencyList.firstWhere((element) => element.name == name);
    return coinInfo.cur ?? "";
  }

  onplayGame() {
    final coinCur = getCoinCurWithCoinName(currency);

    if (items.platformId == "801") {
      String lang = LangUtil().getLangType().substring(0, 2);
      String url = BranchService.instance.current.api_url +
          "/${lang}/casino/original-game-flutter/${items.name.toLowerCase()}?isFlutterApp=1&t=" +
          AccountService.sharedInstance.currentUser!.token!;
      WebEntity entity = WebEntity(link: url, title: items.name);
      Get.toNamed(Routes.webViewPage, arguments: {"detail": entity});
      return;
    }

    CustomProgressHUD.show(context!, content: S.current.random_text_4);
    ApiService.instance.getDetailsLink(
      platformId: items.platformId,
      code: items.gameId,
      cur: coinCur,
      success: (data) {
        print(data);
        WebEntity entity = WebEntity(link: data, title: items.name);
        Get.toNamed(Routes.webViewPage, arguments: {"detail": entity});
        CustomProgressHUD.dismiss(context!);
      },
      fail: (message) {
        CustomProgressHUD.dismiss(context!);
        CustomSnackBar.show(
            title: S.current.error_title_text,
            message!,
            context!,
            preIcon: CustomSnackBarIcons.error);
      },
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //getPlatFormBalance
  Future<void> getCurrentBalance() async {
    await ApiService.instance.getPlatFormBalance(
      code: '',
      cur: 'CNY',
      platformId: items.platformId,
      success: (balance) {},
      fail: (message) {
        print(message);
      },
    );
  }

  Future<void> getGameDetails(String id, String gameId, String pid) async {
    print("kaishiqingqiu----1");
    await ApiService.instance.getGameDetails(
      id: id,
      gameId: gameId,
      pid: pid,
      success: (gameDetailModel) {
        items = gameDetailModel;
        isCollect.value = items.isFav == 1;
        String currencyString = items.currencys![0]; //getCurrencyList(items.currency)[0];
        currency = currencyString;
        // getCurrentBalance();
        currencyConfig();
        isInitialized = true;

        update(["yulechenggamedetails"]);
      },
      fail: (message) {
        print(message);
      },
    );

    // 获取游戏之后获取大赢家数据
    reqBigWins(bigWinsSelIndex);
  }

  ///点击收藏
  Future<void> updateCollect(bool isCollect) async {
    await ApiService.instance.editCollect(
      gameId: items.id,
      success: (success) {
        items.isFav = isCollect ? 1 : 2;
        this.isCollect.value = isCollect ? true : false;
      },
      fail: (message) {
        print(message);
      },
      isCollect: isCollect,
    );
  }

  //获取热门列表
  Future<void> getHotList() async {
    // String path = "/member/game/lobby";
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // String cacheStringKey = "${path}1";
    // String cacheString = prefs.getString(cacheStringKey) ?? "";
    // if (cacheString.isNotEmpty) {
    //   Map<String, dynamic> data = jsonDecode(cacheString);
    //   final YuLeChengHotRecomentModel model = YuLeChengHotRecomentModel.fromJson(data);
    //   hotDataArray.clear();
    //   for (var element in model.games) {
    //     GameLobbyModel model = GameLobbyModel(
    //       platformId: element.platformId,
    //       id: element.id,
    //       gameId: element.gameId,
    //       img: element.img,
    //       name: element.name,
    //       maintained: element.zkOnline.toString(),
    //       playerAmount: (201 + Random().nextInt(100)).toString(),
    //     );

    //     hotDataArray.add(model);
    //   }
    //   update(['yulechenggamedetails']);
    // }
    await ApiService.instance.getRecomendGames(
      page: 1,
      platformId: "1",
      success: (pageModel) {
        hotDataArray.clear();
        hotDataArray.addAll(pageModel.games);
        // for (var element in pageModel.games) {
        //   GameLobbyModel model = GameLobbyModel(
        //     platformId: element.platformId,
        //     id: element.id,
        //     gameId: element.gameId,
        //     img: element.img,
        //     name: element.name,
        //     maintained: element.zkOnline.toString(),
        //     playerAmount: (201 + Random().nextInt(100)).toString(),
        //   );

        //   hotDataArray.add(model);
        // }
        update(['yulechenggamedetails']);
      },
      fail: (message) {
        print(message);
      },
    );
  }

  gotoShowFullList(index) {
    if (Get.isRegistered<YulechengcategorypageController>() == true) {
      Get.find<YulechengcategorypageController>().fromChangguanPage = 6;
      Get.find<YulechengcategorypageController>().title = S.current.yulecheng_hot_recoment;
      RouteUtil.popView();
      Get.find<YulechengcategorypageController>().backRefreshFromDetails();
      return;
    }
    RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
      "title": S.current.yulecheng_hot_recoment,
      "fromChangguanPage": 6,
      "platformId": ""
    });
  }

  updateCurretGame(GameListModel model, needshow, indexx) {
    prePage = "lobbyPage";
    items = model;
    currentPageTitle.value = items.name;
    getGameDetails(items.id, items.gameId, items.platformId);
    getHotList(/*lobbyModel.platformId*/);
    scrollController.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    // update(['yulechenggamedetails']);
  }

  //去场馆
  void goToPlatDetail(YuLeChengChangGuanModel items) {
    RouteUtil.pushToView(Routes.yulechengCategoryPage,
        arguments: {"model": items, "fromChangguanPage": 4});
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }
}
