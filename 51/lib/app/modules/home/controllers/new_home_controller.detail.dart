import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/data/home_game_tab_bean.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/home_view_const.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/recent_games_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../utils/public_util.dart';
import '../../../../utils/sp_util.dart';
import '../../../widget/common_loading_view.dart';
import '../new_home_const.dart';
import 'home_data_manager.dart';
import 'new_home_controller.dart';

///首页的Controller
class NewHomeControllerDetail extends GetxController
    with GetTickerProviderStateMixin {
  late Rx<HomePageDetailEnum> pageKey = HomePageDetailEnum.live.obs; // 使用 Rx 变量

  late NewHomeController homeController = Get.find();

  late RxBool isSubPageLoading = false.obs;
  late RxBool isClickCollect = false.obs;
  // // 最近列表
  // RxList<HomeCollectionListItemBean> gameRecords =
  //     <HomeCollectionListItemBean>[].obs;

  RxList<GameLotteryItemBean> gameLotteryList =
      <GameLotteryItemBean>[].obs; // 彩票
  List<GameLotteryItemBean> allLotteryList = []; // 彩票

  // 棋牌tab相关
  late TabController chessTabController;
  RxInt currentChessTabIndex = 0.obs; //当前选中tab对应的页面的index
  RxList<NewHomeGameDetailTabBean> chessTabList =
      <NewHomeGameDetailTabBean>[].obs;
  RxMap<int, List<GameBeanItem>> chessData = <int, List<GameBeanItem>>{}.obs;

  // 电子tab相关
  late TabController electronicTabController;
  RxInt currentElectronicTabIndex = 0.obs; //当前选中tab对应的页面的index
  RxList<NewHomeGameDetailTabBean> electronicTabList =
      <NewHomeGameDetailTabBean>[].obs;
  RxMap<int, List<GameBeanItem>> electronicData =
      <int, List<GameBeanItem>>{}.obs;

  // 区块链tab相关
  late TabController blockChainTabController;
  RxInt currentBlockChainTabIndex = 0.obs; //当前选中tab对应的页面的index
  RxList<NewHomeGameDetailTabBean> blockChainTabList =
      <NewHomeGameDetailTabBean>[].obs;
  RxMap<int, List<GameBeanItem>> blockChainData =
      <int, List<GameBeanItem>>{}.obs;

  // 彩票相关
  late TabController lotteryTabController;
  RxInt currentLotteryTabIndex = 0.obs; //当前选中tab对应的页面的index
  // 捕鱼tab相关
  late TabController fishTabController;
  RxInt currentFishTabIndex = 0.obs; //当前选中tab对应的页面的index
  RxList<NewHomeGameDetailTabBean> fishTabList =
      <NewHomeGameDetailTabBean>[].obs;
  RxMap<int, List<GameBeanItem>> fishData = <int, List<GameBeanItem>>{}.obs;

  // 收藏列表
  RxList<HomeCollectionListItemBean> collectionList =
      <HomeCollectionListItemBean>[].obs;

  late RxBool isSearch = false.obs; // 是否是搜索状态
  late FocusNode searchFocusNode; // 创建 FocusNode
  // 最近玩过 （改数据为本地数据， 点击过就存储）
  late RxInt thirdTabIndex = 0.obs; //全部、热门、最新、收藏的tab切换index
  late RxString searchName = "".obs; //搜索关键词
  late TextEditingController searchNameController;
  GameChessAndElectronicBean? gameChessAndElectronicBean;
  bool isFirstE = true;
  bool isFirstC = true;
  bool isFirstF = true;
  bool isFirstB = true;
  @override
  void onInit() async {
    super.onInit();
    // 初始化动画控制器
    initData();
    // print('NewHomeControllerDetail 初始化 ${identityHashCode(gameRecords)}');
    searchFocusNode = FocusNode(); // 初始化 FocusNode
    searchNameController = TextEditingController();
    searchNameController.addListener(() {
      searchName.value = searchNameController.text;
    });
    // 监听焦点变化
    searchFocusNode.addListener(() {
      changeSearchStatus(searchFocusNode.hasFocus);
    });

    ever(homeController.currentTabIndex, (value) async {
      searchName.value = ""; //切换tab，清空搜索
      searchNameController.text = "";
      currentLotteryTabIndex.value = 0;
    });
    //监听首页点击的游戏栏目，切换到对应页面的对应tab
    ever(homeController.gameId, (gameId) {
      changeTabIndex();
    });
    ever(homeController.isRequestHomeData, (value) {
      if (value) {
        initData();
        if (pageKey.value == HomePageDetailEnum.chess &&
            homeController.currentSelectTab?.key ==
                HomeGameCategory.CHESS_AND_CARDS_KEY) {
          currentChessTabIndex.value =
              currentChessTabIndex.value < chessTabList.length
                  ? currentChessTabIndex.value
                  : 0;
          loadData(pageKey.value, isRefresh: true);
        } else if (pageKey.value == HomePageDetailEnum.electronic &&
            homeController.currentSelectTab?.key ==
                HomeGameCategory.ELECTRONIC_KEY) {
          currentElectronicTabIndex.value =
              currentElectronicTabIndex.value < electronicTabList.length
                  ? currentElectronicTabIndex.value
                  : 0;
          loadData(pageKey.value, isRefresh: true);
        } else if (pageKey.value == HomePageDetailEnum.fishing &&
            homeController.currentSelectTab?.key ==
                HomeGameCategory.FISHING_KEY) {
          currentFishTabIndex.value =
              currentFishTabIndex.value < fishTabList.length
                  ? currentFishTabIndex.value
                  : 0;
          loadData(pageKey.value, isRefresh: true);
        } else if (pageKey.value == HomePageDetailEnum.blockChain &&
            homeController.currentSelectTab?.key ==
                HomeGameCategory.BLOCKCHAIN_KEY) {
          currentBlockChainTabIndex.value =
              currentBlockChainTabIndex.value < blockChainTabList.length
                  ? currentBlockChainTabIndex.value
                  : 0;
          loadData(pageKey.value, isRefresh: true);
        }
      }
    });

    /// 监听玩家登录，同步 玩家的 收藏数据
    ever(LoginManager.instance.isLogin, (isLogin) async {
      if (isLogin) {
        reqCollectionList();
      } else {
        collectionList.value = [];
      }
      isFirstC = true;
      isFirstE = true;
      isFirstF = true;
      isFirstB = true;
    });
    ever(pageKey, (pageKeyValue) async {
      //避免卡顿，只首次打开APP、首次切换到对应tab，进行请求
      if (pageKeyValue == HomePageDetailEnum.chess) {
        loadData(pageKeyValue, isRefresh: isFirstC);
        isFirstC = false;
      } else if (pageKeyValue == HomePageDetailEnum.electronic) {
        loadData(pageKeyValue, isRefresh: isFirstE);
        isFirstE = false;
      } else if (pageKeyValue == HomePageDetailEnum.fishing) {
        loadData(pageKeyValue, isRefresh: isFirstF);
        isFirstF = false;
      } else if (pageKeyValue == HomePageDetailEnum.blockChain) {
        loadData(pageKeyValue, isRefresh: isFirstB);
        isFirstB = false;
      } else if (pageKeyValue == HomePageDetailEnum.collect) {
        if (!LoginManager.instance.isLogin.value) return;
        reqCollectionList();
      }
    });
    ever(homeController.currentTabIndex, (index) async {
      changeThirdTabIndex(0); //切换了大类，这里需要变为0
    });
  }

  void loadData(pageKeyValue, {bool isRefresh = false}) async {
    String spKey = "";
    switch (pageKeyValue) {
      case HomePageDetailEnum.chess:
        spKey = "chessGameBean";
        break;
      case HomePageDetailEnum.electronic:
        spKey = "electronicGameBean";
        break;
      case HomePageDetailEnum.fishing:
        spKey = "fishingGameBean";
        break;
      case HomePageDetailEnum.blockChain:
        spKey = "blockChainGameBean";
        break;
    }
    gameChessAndElectronicBean =
        await SpUtil.getBean<GameChessAndElectronicBean>(spKey, (json) {
      return GameChessAndElectronicBean.fromJson(json);
    });
    reqChessOrElectronicData(pageKeyValue, isRefresh);
  }

  getIndex(RxList<NewHomeGameDetailTabBean> list) {
    int index = 0;
    for (int i = 0; i < list.length; i++) {
      if (list[i].playId == homeController.gameId.value) {
        index = i;
      }
    }
    return index;
  }

  // 修改当前选中的页面
  changeTabIndex() {
    if (homeController.gameId.value != 0) {
      if (pageKey.value == HomePageDetailEnum.electronic) {
        currentElectronicTabIndex.value = getIndex(electronicTabList);
        electronicTabController.animateTo(currentElectronicTabIndex.value);
      }
      if (pageKey.value == HomePageDetailEnum.blockChain) {
        currentBlockChainTabIndex.value = getIndex(blockChainTabList);
        blockChainTabController.animateTo(currentBlockChainTabIndex.value);
      }
      if (pageKey.value == HomePageDetailEnum.chess) {
        currentChessTabIndex.value = getIndex(chessTabList);
        chessTabController.animateTo(currentChessTabIndex.value);
      }

      if (pageKey.value == HomePageDetailEnum.fishing) {
        currentFishTabIndex.value = getIndex(fishTabList);
        fishTabController.animateTo(currentFishTabIndex.value);
      }
      homeController.updateHeight();
    }
  }

  // 修改当前选中的页面
  changeTabIndex2(int index) {
    if (pageKey.value == HomePageDetailEnum.electronic) {
      electronicTabController.animateTo(index);
    }
    if (pageKey.value == HomePageDetailEnum.blockChain) {
      blockChainTabController.animateTo(index);
    }
    if (pageKey.value == HomePageDetailEnum.chess) {
      chessTabController.animateTo(index);
    }

    if (pageKey.value == HomePageDetailEnum.fishing) {
      fishTabController.animateTo(index);
    }
    homeController.updateHeight();
  }

  initData() {
    // 电子
    electronicTabList.value = combHomeDetailTabData1(
      homeController.gameElectronic,
      gameType: 'electronic',
    );
    electronicTabController =
        TabController(length: electronicTabList.length, vsync: this);
    electronicData[-1] = homeController.hotGameElectronic;

    // 棋牌
    chessTabList.value = combHomeDetailTabData1(
      homeController.gameChess,
      gameType: 'chess',
    );
    chessTabController =
        TabController(length: chessTabList.length, vsync: this);
    chessData[-1] = homeController.hotGameChess;
// 区块链
    blockChainTabList.value = combHomeDetailTabData1(
      homeController.gameBlockchain,
      gameType: 'blockChain',
    );
    blockChainTabController =
        TabController(length: blockChainTabList.length, vsync: this);
    blockChainData[-1] = homeController.hotGameBlockChain;
    // 捕鱼
    fishTabList.value = combHomeDetailTabData1(
      homeController.gameFishing,
      gameType: 'fishing',
    );
    fishTabController = TabController(length: fishTabList.length, vsync: this);
    fishData[-1] = homeController.hotGameFishing;
  }

  // 组装tab数据
  combHomeDetailTabData1(
    List<ThirdGamesItem> gameData, {
    required String gameType,
  }) {
    List<NewHomeGameDetailTabBean> gameTabData = [
      NewHomeGameDetailTabBean(
        title: "热门",
        play_sort: 0,
        iconPath: GameUtils.getHomeTabDefaultColorIcon(
            playId: -1, gameType: gameType),
        playId: -1, // 代表热门
      ),
    ];

    for (int i = 0; i < gameData.length; i++) {
      var item = gameData[i];
      var playId = item.play_id!.toInt();
      gameTabData.add(NewHomeGameDetailTabBean(
        title: item.play_cname!,
        play_sort: item.play_sort!,
        iconPath: item.logo3_img_url ??
            GameUtils.getHomeTabDefaultColorIcon(
                playId: playId, gameType: gameType),
        playId: playId,
      ));
    }
    gameTabData.sort((a, b) => a.play_sort.compareTo(b.play_sort));
    return gameTabData;
  }

  // 请求棋牌 或 电子数据
  reqChessOrElectronicData(
      HomePageDetailEnum homePageEnum, bool isRefresh) async {
    if (isRefresh) {
      isSubPageLoading.value = false;
      var res = await HomeApi.reqChessOrElectronicGameData(homePageEnum);
      if (res.type == NetworkService.networkTypeSuccess) {
        gameChessAndElectronicBean =
            GameChessAndElectronicBean.fromJson(res.data);
        isSubPageLoading.value = true;
      }
    }
    buildGameData(homePageEnum);
  }

  bool loadFinish = false;
  void buildGameData(HomePageDetailEnum homePageEnum) {
    loadFinish = false;
    if (gameChessAndElectronicBean != null) {
      final result = gameChessAndElectronicBean!.data!;
      if (result != null) {
        switch (homePageEnum) {
          case HomePageDetailEnum.chess:
            SpUtil.saveBean<GameChessAndElectronicBean>("chessGameBean",
                gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖
            break;
          case HomePageDetailEnum.electronic:
            SpUtil.saveBean<GameChessAndElectronicBean>("electronicGameBean",
                gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
            break;
          case HomePageDetailEnum.fishing:
            SpUtil.saveBean<GameChessAndElectronicBean>("fishingGameBean",
                gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
            break;
          case HomePageDetailEnum.blockChain:
            SpUtil.saveBean<GameChessAndElectronicBean>("blockChainGameBean",
                gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
            break;
          case HomePageDetailEnum.collect:
          case HomePageDetailEnum.recent:
          case HomePageDetailEnum.live:
          case HomePageDetailEnum.sports:
          case HomePageDetailEnum.lottery:
            break;
        }
      }
      switch (homePageEnum) {
        case HomePageDetailEnum.chess:
          result.forEach((key, value) {
            var tempList = GameUtils.dealDZList(value);
            chessData[key] = tempList;
          });
          break;
        case HomePageDetailEnum.electronic:
          result.forEach((key, value) {
            var tempList = GameUtils.dealDZList(value);
            electronicData[key] = tempList;
          });
          break;
        case HomePageDetailEnum.fishing:
          result.forEach((key, value) {
            var tempList = GameUtils.dealDZList(value);
            fishData[key] = tempList;
          });
          break;
        case HomePageDetailEnum.blockChain:
          result.forEach((key, value) {
            var tempList = GameUtils.dealDZList(value);
            blockChainData[key] = tempList;
          });
          break;
        case HomePageDetailEnum.collect:
        case HomePageDetailEnum.recent:
        case HomePageDetailEnum.live:
        case HomePageDetailEnum.sports:
        case HomePageDetailEnum.lottery:
          break;
      }
      loadFinish = true;
    }
  }

  // 请求收藏列表
  Future<void> reqCollectionList() async {
    try {
      /// 未登录
      if (!LoginManager.instance.isLogin.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLoginDialog(callback: () {
            reqCollectData();
          });
        });
        EasyLoading.showToast('亲，请先登录哦');
        return;
      } else {
        reqCollectData();
      }
    } catch (err) {
      //
    }
  }

  void reqCollectData() async {
    collectionList.value = await HomeApi.reqCollectionList();
    homeController.updateHeight();
  }

  /// 收藏以及取消 体育/真人
  void collectGameAndVenues({required int index, int? playIds}) async {
    if (!LoginManager.instance.isLogin.value) {
      EasyLoading.showToast('请登录账号！');
      return; //没有登录不执行
    }

    // 未请求完时防重复点击
    if (isClickCollect.value == true) {
      print('====> Repeat Click');
      return;
    }

    dynamic playId;
    dynamic type;
    dynamic playCat;
    dynamic status;
    String msg = '';

    isClickCollect.value = true;
    num? bigType = 0;
    num? upperPlayId = 0;
    // 体育/真人
    if ([HomePageDetailEnum.live, HomePageDetailEnum.sports]
        .contains(pageKey.value)) {
      var venuesData = pageKey.value == HomePageDetailEnum.live
          ? homeController.gameLive
          : homeController.gameSports;
      // var venuesItem = venuesData[index];
      var venuesItem =
          venuesData!.firstWhere((item) => item.play_id == playIds);
      bigType = venuesItem.big_type;
      upperPlayId = venuesItem.upper_id;
      playId = venuesItem.play_id!;
      type = homePageDetailCollectType[pageKey.value];
      playCat = venuesItem.play_cat!;
      status = venuesItem.play_collection!;
      msg = jsonEncode(venuesItem);
    }

    // 收藏 (执行的取消收藏)
    if (pageKey.value == HomePageDetailEnum.collect) {
      var gameItem = collectionList[index];
      bigType = gameItem.big_type;
      playId = gameItem.play_id!;
      type = gameItem.type!;
      upperPlayId = gameItem.upper_play_id;

      playCat = gameItem.play_cat!;
      status = 2; // 取消收藏
      msg = gameItem.msg!;
    }

    // 捕鱼
    if (pageKey.value == HomePageDetailEnum.fishing) {
      var currentTabItem = fishTabList[currentFishTabIndex.toInt()];
      var gameData = fishData[currentTabItem.playId];
      // var gameItem = gameData![index];
      var gameItem = gameData!.firstWhere((item) => item.play_id == playIds);
      bigType = gameItem.big_type;
      playId = gameItem.play_id!;
      upperPlayId = gameItem.upper_play_id;
      type = homePageDetailCollectType[pageKey.value];
      playCat = gameItem.play_cat!;
      status = gameItem.play_collection!;
      msg = jsonEncode(gameItem);
    }

    // 电子
    if (pageKey.value == HomePageDetailEnum.electronic) {
      var currentTabItem = electronicTabList[currentElectronicTabIndex.toInt()];
      var gameData = electronicData[currentTabItem.playId];
      // var gameItem = gameData![index];
      var gameItem = gameData!.firstWhere((item) => item.play_id == playIds);
      bigType = gameItem.big_type;
      playId = gameItem.play_id!;
      upperPlayId = gameItem.upper_play_id;
      type = homePageDetailCollectType[pageKey.value];
      playCat = gameItem.play_cat!;
      upperPlayId = gameItem.upper_play_id;
      status = gameItem.play_collection!;
      msg = jsonEncode(gameItem);
    }
    // 区块链
    if (pageKey.value == HomePageDetailEnum.blockChain) {
      var currentTabItem = blockChainTabList[currentBlockChainTabIndex.toInt()];
      var gameData = blockChainData[currentTabItem.playId];
      // var gameItem = gameData![index];
      var gameItem = gameData!.firstWhere((item) => item.play_id == playIds);
      bigType = gameItem.big_type;
      playId = gameItem.play_id!;
      upperPlayId = gameItem.upper_play_id;
      type = homePageDetailCollectType[pageKey.value];
      playCat = gameItem.play_cat!;
      status = gameItem.play_collection!;
      msg = jsonEncode(gameItem);
    }
    // 棋牌
    if (pageKey.value == HomePageDetailEnum.chess) {
      var currentTabItem = chessTabList[currentChessTabIndex.toInt()];
      var gameData = chessData[currentTabItem.playId];
      var gameItem = gameData!.firstWhere((item) => item.play_id == playIds);
      // var gameItem = gameData![index];
      bigType = gameItem.big_type;
      playId = gameItem.play_id!;
      upperPlayId = gameItem.upper_play_id;
      type = homePageDetailCollectType[pageKey.value];
      playCat = gameItem.play_cat!;
      status = gameItem.play_collection!;
      msg = jsonEncode(gameItem);
    }
    // 彩票
    if (pageKey.value == HomePageDetailEnum.lottery) {
      var currentTabItem = homeController.gameLottery[index];
      playId = currentTabItem.play_id!;
      upperPlayId = currentTabItem.upper_id;
      type = homePageDetailCollectType[pageKey.value];
      playCat = currentTabItem.play_cat!;
      status = currentTabItem.play_collection!;
      bigType = currentTabItem.big_type;
      msg = jsonEncode(currentTabItem);
    }

    // 最近
    if (pageKey.value == HomePageDetailEnum.recent) {
      var currentTabItem = homeController.gameRecords[index];
      bigType = currentTabItem.big_type;
      var oldtype = GameUtils.determineTypeConst(
          currentTabItem.upper_play_id != null
              ? currentTabItem.upper_play_id!.toInt()
              : currentTabItem.play_id!);
      playId = currentTabItem.play_id!;
      upperPlayId = currentTabItem.upper_play_id;

      type = homePageDetailCollectType[getEnumFromString(oldtype)];
      playCat = currentTabItem.play_cat!;
      status = currentTabItem.collectionId == null ? 1 : 2;
      msg = jsonEncode(currentTabItem);
    }
    if (playId == null) {
      return;
    }

    final res = await HomeApi.reqCollectGame(
      playId: playId,
      type: type,
      playCat: playCat,
      status: status,
      msg: msg,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      await doLocalCollect(playIds, bigType, upperPlayId);
      EasyLoading.showToast(status == 1 ? '收藏成功' : '取消收藏成功');
      if ([
        HomePageDetailEnum.electronic,
        HomePageDetailEnum.chess,
        HomePageDetailEnum.fishing,
        HomePageDetailEnum.blockChain
      ].contains(pageKey.value)) {
        reqChessOrElectronicData(pageKey.value, false);
      }

      // 收藏
      if (pageKey.value == HomePageDetailEnum.collect) {
        reqCollectionList();
      }

      // 更新最近列表的收藏状态
      num? collectionId;
      if (status == 1) {
        collectionId = 2;
      }
      homeController.updateGameRecord(playId, collectionId);
    }

    isClickCollect.value = false;
  }

  //执行本地收藏
  Future<void> doLocalCollect(
      int? playIds, num? bigType, num? upperPlayId) async {
    List<GameBeanItem> gameData = [];

    switch (bigType) {
      case HomeGameCategory.FISHING:
        var currentTabItem = fishTabList[currentFishTabIndex.toInt()];

        var hotData = fishData[-1] ?? []; //拿到热门数据
        bool hasData =
            hotData.any((item) => item.play_id == playIds); //热门是否有同样的数据
        if (hasData) {
          gameData = fishData[-1] ?? [];
        } else {
          gameData = fishData[currentTabItem.playId] ?? [];
        }

        for (var item in gameData!) {
          if (item.play_id == playIds) {
            item.play_collection = item.play_collection == 2 ? 1 : 2;
            break;
          }
        }
        //拿到对应数据
        List<GameChessAndElectronicItemBean>? tempList =
            gameChessAndElectronicBean!.data![(upperPlayId ?? 0).toInt()];
        if (tempList != null && tempList.isNotEmpty) {
          for (var item in tempList) {
            if (item.play_id == playIds) {
              item.play_collection = item.play_collection == 2 ? 1 : 2;
              break;
            }
          }
        }
        SpUtil.saveBean<GameChessAndElectronicBean>("fishingGameBean",
            gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
        break;
      case HomeGameCategory.CHESS:
        var currentTabItem = chessTabList[currentChessTabIndex.toInt()];

        var hotData = chessData[-1] ?? []; //拿到热门数据
        bool hasData =
            hotData.any((item) => item.play_id == playIds); //热门是否有同样的数据
        if (hasData) {
          gameData = chessData[-1] ?? [];
        } else {
          gameData = chessData[currentTabItem.playId] ?? [];
        }

        for (var item in gameData!) {
          if (item.play_id == playIds) {
            item.play_collection = item.play_collection == 2 ? 1 : 2;
            break;
          }
        }
        //拿到对应数据
        List<GameChessAndElectronicItemBean>? tempList =
            gameChessAndElectronicBean!.data![(upperPlayId ?? 0).toInt()];
        if (tempList != null && tempList.isNotEmpty) {
          for (var item in tempList) {
            if (item.play_id == playIds) {
              item.play_collection = item.play_collection == 2 ? 1 : 2;
              break;
            }
          }
        }
        SpUtil.saveBean<GameChessAndElectronicBean>("chessGameBean",
            gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
        break;
      case HomeGameCategory.ELECTRONIC:
        var currentTabItem =
            electronicTabList[currentElectronicTabIndex.toInt()];
        var hotData = electronicData[-1] ?? []; //拿到热门数据
        bool hasData =
            hotData.any((item) => item.play_id == playIds); //热门是否有同样的数据
        if (hasData) {
          gameData = electronicData[-1] ?? [];
        } else {
          gameData = electronicData[currentTabItem.playId] ?? [];
        }
        for (var item in gameData!) {
          if (item.play_id == playIds) {
            item.play_collection = item.play_collection == 2 ? 1 : 2;
            break;
          }
        }
        //拿到对应数据
        List<GameChessAndElectronicItemBean>? tempList =
            gameChessAndElectronicBean!.data![(upperPlayId ?? 0).toInt()];
        if (tempList != null && tempList.isNotEmpty) {
          for (var item in tempList) {
            if (item.play_id == playIds) {
              item.play_collection = item.play_collection == 2 ? 1 : 2;
              break;
            }
          }
        }
        SpUtil.saveBean<GameChessAndElectronicBean>("electronicGameBean",
            gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
        break;
      case HomeGameCategory.BLOCK_THIRD:
        var currentTabItem =
            blockChainTabList[currentBlockChainTabIndex.toInt()];

        var hotData = blockChainData[-1] ?? []; //拿到热门数据
        bool hasData =
            hotData.any((item) => item.play_id == playIds); //热门是否有同样的数据
        if (hasData) {
          gameData = blockChainData[-1] ?? [];
        } else {
          gameData = blockChainData[currentTabItem.playId] ?? [];
        }
        for (var item in gameData!) {
          if (item.play_id == playIds) {
            item.play_collection = item.play_collection == 2 ? 1 : 2;
            break;
          }
        }
        //拿到对应数据
        List<GameChessAndElectronicItemBean>? tempList =
            gameChessAndElectronicBean!.data![(upperPlayId ?? 0).toInt()];
        if (tempList != null && tempList.isNotEmpty) {
          for (var item in tempList) {
            if (item.play_id == playIds) {
              item.play_collection = item.play_collection == 2 ? 1 : 2;
              break;
            }
          }
        }
        SpUtil.saveBean<GameChessAndElectronicBean>("blockChainGameBean",
            gameChessAndElectronicBean!); //只要请求了最新的，并且不为空，就覆盖 棋牌
        break;
      case HomeGameCategory.LIVE:
      case HomeGameCategory.SPORTS:
        var venuesData = pageKey.value == HomePageDetailEnum.live
            ? homeController.gameLive
            : homeController.gameSports;
        for (var item in venuesData!) {
          if (item.play_id == playIds) {
            item.play_collection = item.play_collection == 2 ? 1 : 2;
            break;
          }
        }
        venuesData.refresh();
        // homeController.gameSports.refresh();
        break;
      case HomeGameCategory.LOTTERY: //彩票暂无数据，继续走请求home接口
        homeController.reqHomeData();
        break;
      default:
        gameData = [];
        break;
    }
    if (pageKey.value == HomePageDetailEnum.lottery) return;
  }

  HomePageDetailEnum getEnumFromString(String value) {
    return HomePageDetailEnum.values.firstWhere(
      (e) => e.toString().split('.').last == value,
      orElse: () => HomePageDetailEnum.collect, // Default value if not found
    );
  }

  void changeSearchStatus(bool isSearch) {
    this.isSearch.value = isSearch;
  }

  void changeThirdTabIndex(int index) async {
    thirdTabIndex.value = index;

    ///真人、体育、彩票加载完成设置loading状态
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if ([
        HomePageDetailEnum.live,
        HomePageDetailEnum.sports,
        HomePageDetailEnum.lottery
      ].contains(pageKey.value)) {
        isSubPageLoading.value = true;
      }
    });
  }
}
