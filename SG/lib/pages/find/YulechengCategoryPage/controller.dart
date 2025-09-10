import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/find/YulechengCategoryPage/yulecheng_category_state.dart';
import 'package:flutter_bet/pages/find/yulecheng_details/index.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/index.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/pages/personal_center/wallet/cardbag_exoansion.dart';
import 'package:flutter_bet/pages/web_browser/logic.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:image/image.dart';

import '../../../model/yulecheng/gamelist_model.dart';
import '../../../routes/routes.dart';
import '../../../services/api/api_service.dart';

import '../../../utils/route_util.dart';
import '../../../generated/l10n.dart';

class YulechengcategorypageController extends BaseController {
  YulechengcategorypageController();

  late String title;
  var currentPageTitle = "".obs;
  late YuLeChengChangGuanModel model;
  late Nav navModel;
  late Nav itemModel;

  late int fromChangguanPage;
  late YuLeChengChangGuanModel changguanModel;
  late Litem lobbbModel;
  bool needShow2pages = false;
  String platFormIds = "";
  String imagenName = "default";

  List<YuLeChengChangGuanModel> changguanDataArray = [];

  /// 判断是不是收藏夹和近期游戏(1) 或者是 游戏大厅(2) 或 场馆(3) ,

  YulechengCategoryState state = YulechengCategoryState();
  final GlobalStateController globalController = Get.find<GlobalStateController>();

  late FocusNode focusNode;

  // 是不是真人视讯

  bool isZhenRen = false;

  _initData() {
    // state.isLoading = true;
    state.showQieHuanPage = false;
    update(['yulechengcategorypage']);

    if (fromChangguanPage == 1) {
      if (title == S.current.sport_tabbar_favorites) {
        state.showSorttype = false;
        state.showQieHuanPage = true;
        update(['yulechengcategorypage']);

        getFavoriteGameList();
      } else if (title == S.current.random_text_260) {
        state.showSorttype = false;
        state.isLoading = true;
        update(['yulechengcategorypage']);

        loadRecentGames(state.dataArray);
      } else if (title == S.current.game_supplier) {
        fromChangguanPage = 3;
      } else {
        // 默认情况
      }
    } else if (fromChangguanPage == 2) {
      state.showSorttype = true;
      needShow2pages = Get.arguments["needShow2pages"];

      if (navModel.ty == 1) {
        loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), navModel.cid,
            state.ty1DataArray, platFormIds);
      } else {
        loadDataTy2(state.dataArray.length ~/ (AppValues.defaultPageSize + 1), navModel.platformId,
            state.dataArray);
      }
    } else if (fromChangguanPage == 21) {
      state.showSorttype = true;
      needShow2pages = Get.arguments["needShow2pages"];

      if (itemModel.ty == 1) {
        loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), itemModel.cid,
            state.ty1DataArray, platFormIds);
      } else {
        loadDataTy2(state.dataArray.length ~/ (AppValues.defaultPageSize + 1), itemModel.platformId,
            state.dataArray);
      }
    } else if (fromChangguanPage == 3) {
      state.showSorttype = false;
      getPlatList("0");
    } else if (fromChangguanPage == 4) {
      state.showSorttype = true;

      loadDataTy2(state.dataArray.length ~/ (AppValues.defaultPageSize + 1), changguanModel.id,
          state.dataArray);
    } else if (fromChangguanPage == 41) {
      state.showSorttype = true;

      loadDataTy2(state.dataArray.length ~/ (AppValues.defaultPageSize + 1),
          Get.arguments["platformId"], state.dataArray);
    } else if (fromChangguanPage == 6) {
      loadHotRecomentData(state.dataArray.length ~/ (AppValues.defaultPageSize + 1), platFormIds,
          state.dataArray, 0);
    } else {
      state.showSorttype = true;

      needShow2pages = Get.arguments["needShow2pages"];
      if (lobbbModel.ty == 1) {
        loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), lobbbModel.cid,
            state.ty1DataArray, platFormIds);
      } else {
        loadDataTy2(state.dataArray.length ~/ (AppValues.defaultPageSize + 1),
            lobbbModel.platformId, state.dataArray);
      }
    }

    update(["yulechengcategorypage"]);
  }

  backRefreshFromDetails() {
    name = S.current.yulecheng_hot_recoment;
    currentPageTitle.value = S.current.yulecheng_hot_recoment;
    state.changguanSumArray.clear();
    state.dataArray.clear();
    state.ty1DataArray.clear();
    getPlatList("");
    loadHotRecomentData(
        state.dataArray.length ~/ (AppValues.defaultPageSize + 1), "", state.dataArray, 0);
  }

  void onTap() {}

  @override
  void onInit() {
    super.onInit();

    focusNode = FocusNode();
    focusNode.addListener(onFocusChange);
    state.textController = TextEditingController(text: '');
    state.showSearchType = 0.obs;
    state.history = <String>[].obs;
    state.searchCasinoList = <GameListModel>[].obs;
    state.showInfoType = 0.obs;
    state.isFocused = false.obs;
    state.searchContent = ''.obs;

    state.isLoading = true;
    update(['yulechengcategorypage']);

    notifySearchHistory();

    getPlatList("0");

    fromChangguanPage = Get.arguments["fromChangguanPage"];
    if (fromChangguanPage == 1) {
      title = Get.arguments["title"];
      currentPageTitle.value = title;
    } else if (fromChangguanPage == 2) {
      navModel = Get.arguments["model"];
      print(navModel.ty);
      title = "";
      currentPageTitle.value = navModel.name;
      if (navModel.ty == 1) {
        loadSumListData(navModel.cid);
      }
      state.dataArray.clear();
      state.ty1DataArray.clear();
    } else if (fromChangguanPage == 21) {
      itemModel = Get.arguments["model"];
      print(itemModel.ty);
      title = "";
      currentPageTitle.value = itemModel.name;
      if (itemModel.ty == 1) {
        loadSumListData(itemModel.cid);
      }
      state.dataArray.clear();
      state.ty1DataArray.clear();
    } else if (fromChangguanPage == 3) {
      // model = Get.arguments["model"];
      title = "";
      currentPageTitle.value = S.current.game_supplier;
    } else if (fromChangguanPage == 4) {
      changguanModel = Get.arguments["model"];
      title = changguanModel.name;
      currentPageTitle.value = title;
    } else if (fromChangguanPage == 41) {
      title = Get.arguments["title"];
      currentPageTitle.value = title;
    } else if (fromChangguanPage == 6) {
      title = Get.arguments["title"];
      currentPageTitle.value = title;
    } else {
      lobbbModel = Get.arguments["model"];
      title = "";
      currentPageTitle.value = lobbbModel.name;
      if (lobbbModel.ty == 1) {
        loadSumListData(lobbbModel.cid);
      }
      state.dataArray.clear();
      state.ty1DataArray.clear();
    }
  }

  @override
  void onReady() {
    super.onReady();
    state.dataArray.clear();
    state.ty1DataArray.clear();
    platFormIds = "";
    _initData();
  }

//获取对应分类切换的场馆列表
  loadSumListData(cid) async {
    await ApiService.instance.getLobbyGameCate(
      cid: cid,
      success: (pageModel) {
        state.changguanSumArray.clear();
        state.changguanSumArray.addAll(pageModel?.sums ?? []);
        Future.delayed(const Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        update(['yulechengcategorypage']);
      },
    );
  }

// 获取收藏列表
  Future<void> getFavoriteGameList() async {
    await ApiService.instance.getFavoriteGames(
      page: 1,
      success: (pageModel) {
        state.dataArray.clear();
        state.dataArray.addAll(pageModel.content);
        state.isLoading = false;
        state.showLoadMore = true;
        if (state.totalGame == 0) {
          state.totalGame = pageModel.total.toInt();
        }
        if (pageModel.over == true || pageModel.content.length < AppValues.defaultPageSize + 1) {
          state.showLoadMore = false;
        }
        Future.delayed(const Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        print(message);
      },
    );
  }

  /// 获取搜索列表
  /// [w关键词]
  void getSearchGames(keyword) async {
    await ApiService.instance.getSearchCasinoGame(
      page: 1,
      pageSize: AppValues.defaultPageSize,
      keyword: keyword,
      success: (pageModel) {
        state.dataArray.clear();
        state.dataArray.addAll(pageModel.content);
        state.isLoading = false;
        state.showLoadMore = true;
        if (state.totalGame == 0) {
          state.totalGame = pageModel.total.toInt();
        }
        if (pageModel.over == true || pageModel.content.length < AppValues.defaultPageSize + 1) {
          state.showLoadMore = false;
        }
        Future.delayed(Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {},
    );
  }

  void loadMoreData() {
    // state.isLoading = true;
    update(['yulechengcategorypage']);

    _initData();
  }

  /// 获取游戏列表
  loadGameListData(page, game_type, dataAccept) async {
    await ApiService.instance.getAllGames(
      page: page,
      game_type: game_type,
      sort: sortTypeWithString(state.currentSortType),
      success: (pageModel) {
        if (pageModel.over == true) {
          // pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        }
        state.dataArray.addAll(pageModel.content);
        state.isLoading = false;
        state.showLoadMore = true;
        if (state.totalGame == 0) {
          state.totalGame = pageModel.total.toInt();
        }
        if (pageModel.over == true || pageModel.content.length < AppValues.defaultPageSize + 1) {
          state.showLoadMore = false;
        }
        Future.delayed(Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        // pullToRefreshController.finishLoad();

        print(message);
      },
    );
  }

  loadData(page, cid, dataAccept, platformId) async {
    imagenName = cid.toString();
    await ApiService.instance.getLobbyGameCateMoreData(
      cid: cid,
      page: page + 1,
      platform_id: platformId,
      sort: sortTypeWithString(state.currentSortType),
      page_size: needShow2pages == true && dataAccept.length < 1
          ? (AppValues.defaultPageSize + 1) * 2
          : AppValues.defaultPageSize + 1,
      success: (pageModel) {
        // if (pageModel.over == true) {
        //   pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        // }
        state.isLoading = false;
        state.showLoadMore = true;
        if (pageModel.total != 0) {
          state.totalGame = pageModel.total.toInt();
        }
        // dataAccept.clear();
        dataAccept.addAll(pageModel.content);
        isZhenRen = getNeedShowPlayerStatus(dataAccept);
        Future.delayed(Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        // pullToRefreshController.finishLoad();

        print(message);
      },
    );
  }

  bool getNeedShowPlayerStatus(List itemsList) {
    bool isZhenren = true;
    for (var element in itemsList) {
      print("element.platformId = ${element.platformId}");
      if (element.platformId != "101" && element.platformId != "102") {
        isZhenren = false;
        break;
      }
    }
    return isZhenren;
  }

  loadDataTy2(page, platform_id, dataAccept) async {
    imagenName = platform_id.toString();
    await ApiService.instance.getYulechengTy2Games(
      page: page + 1,
      page_size: needShow2pages == true && dataAccept.length < 1
          ? (AppValues.defaultPageSize + 1) * 2
          : AppValues.defaultPageSize + 1,
      platformid: platform_id,
      sort: sortTypeWithString(state.currentSortType),
      success: (pageModel) {
        state.showLoadMore = true;
        if (state.totalGame == 0) {
          state.totalGame = pageModel.total.toInt();
        }
        // if (pageModel.over == true || pageModel.content.length < AppValues.defaultPageSize + 1) {
        //   state.showLoadMore = false;
        // }
        state.isLoading = false;
        dataAccept.addAll(pageModel.content);
        isZhenRen = getNeedShowPlayerStatus(dataAccept);

        // pullToRefreshController.finishLoad();

        Future.delayed(Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        // pullToRefreshController.finishLoad();
      },
    );
  }

  loadRecentGames(dataAccept) async {
    await ApiService.instance.getRecentGames(
      success: (pageModel) {
        dataAccept.clear();
        dataAccept.addAll(pageModel);
        Future.delayed(Duration(seconds: 1), () {
          state.isLoading = false;
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        state.isLoading = false;

        // pullToRefreshController.finishLoad();
      },
    );
  }

  loadHotRecomentData(page, platformId, dataAccept, count) async {
    await ApiService.instance.getRecomendGames(
      page: page + 1,
      platformId: platformId,
      sort: sortTypeWithString(state.currentSortType),
      success: (pageModel) {
        state.showLoadMore = true;
        state.totalGame = pageModel.total.toInt();

        // if (pageModel.over == true || pageModel.content.length < AppValues.defaultPageSize + 1) {
        //   state.showLoadMore = false;
        // }
        state.isLoading = false;
        dataAccept.addAll(pageModel.games);
        // pullToRefreshController.finishLoad();

        Future.delayed(Duration(seconds: 1), () {
          update(['yulechengcategorypage']);
        });
      },
      fail: (message) {
        // pullToRefreshController.finishLoad();
      },
    );
  }

  /// 获取场馆列表
  void getPlatList(gameType) async {
    await ApiService.instance.getAllPlatForm(success: (dataInfo) {
      changguanDataArray.clear();
      changguanDataArray.addAll(dataInfo.games);
      if (fromChangguanPage == 3 || fromChangguanPage == 1 && title == S.current.random_text_260) {
        state.isLoading = false;
      }
      if (fromChangguanPage == 6) {
        state.changguanSumArray.clear();
        for (var element in changguanDataArray) {
          Sum sum = Sum(
              platformId: element.id,
              platformName: element.name,
              venueId: element.id,
              total: element.gameNum);
          state.changguanSumArray.add(sum);
        }
      }
      update(['yulechengcategorypage']);
    }, fail: (message) {
      print(message);
    });
  }

  void goToDetail(GameListModel items) {
    // 原创游戏直接进入游戏
    if (items.platformId == "801") {
      String lang = LangUtil().getLangType().substring(0, 2);
      String url = BranchService.instance.current.api_url +
          "/${lang}/casino/original-game-flutter/${items.name.toLowerCase()}?isFlutterApp=1&t=" +
          AccountService.sharedInstance.currentUser!.token!;
      WebEntity entity = WebEntity(link: url, title: items.name);
      Get.toNamed(Routes.webViewPage, arguments: {"detail": entity});
      return;
    }
    if (Get.isRegistered<YulechenggamedetailsController>() == true) {
      Get.find<YulechenggamedetailsController>().prePage = "catePage";
      Get.find<YulechenggamedetailsController>().platformName = currentPageTitle.value;
      RouteUtil.popView();
      Get.find<YulechenggamedetailsController>().refreshDataCatePage(items);
      return;
    }
    RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
      "listmodel": items,
      "prePage": "catePage",
      "platformName": currentPageTitle.value
    });
  }

  void goToTy1Detail(GameLobbyModel items) {
    // 原创游戏直接进入游戏
    if (items.platformId == "801") {
      String lang = LangUtil().getLangType().substring(0, 2);
      String url = BranchService.instance.current.api_url +
          "/${lang}/casino/original-game-flutter/${items.name.toLowerCase()}?isFlutterApp=1&t=" +
          AccountService.sharedInstance.currentUser!.token!;
      WebEntity entity = WebEntity(link: url, title: items.name);
      Get.toNamed(Routes.webViewPage, arguments: {"detail": entity});
      return;
    }
    if (Get.isRegistered<YulechenggamedetailsController>() == true) {
      Get.find<YulechenggamedetailsController>().prePage = "catePage";
      Get.find<YulechenggamedetailsController>().platformName = currentPageTitle.value;
      RouteUtil.popView();
      Get.find<YulechenggamedetailsController>().refreshDataLobbyPage(items);
      return;
    }
    RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
      "model": items,
      "prePage": "lobbyPage",
      "platformName": currentPageTitle.value
    });
  }

  void goToChangguanList() {
    fromChangguanPage = 3;
    needShow2pages = false;
    title = S.current.game_supplier;
    currentPageTitle.value = S.current.game_supplier;
    state.showLoadMore = false;
    state.dataArray.clear();
    state.ty1DataArray.clear();
    platFormIds = "";
    _initData();
    update(['yulechengcategorypage']);
  }

  void goToPlatDetail(YuLeChengChangGuanModel items) {
    RouteUtil.pushToView(Routes.yulechengCategoryPage,
        arguments: {"model": items, "fromChangguanPage": 4});
  }

  changeToPlatGameList(YuLeChengChangGuanModel model) {
    if (model.maintained == "2") {
      return;
    }
    if (model.id.toString() == "101") {
      isZhenRen = true;
    } else {
      isZhenRen = false;
    }
    print("model.id.toString() " + model.id.toString());
    fromChangguanPage = 4;
    changguanModel = model;
    title = changguanModel.name;
    currentPageTitle.value = title;
    needShow2pages = false;

    state.showLoadMore = false;
    state.showSorttype = false;

    state.isLoading = true;

    state.dataArray.clear();
    state.ty1DataArray.clear();
    platFormIds = "";
    _initData();
  }

  void selectedSortType(sortType) {
    state.currentSortType = sortType;
    needShow2pages = false;
    state.showLoadMore = false;
    state.isLoading = true;
    state.dataArray.clear();
    state.ty1DataArray.clear();
    _initData();
  }

  bool getSelectedNumber() {
    for (var element in state.changguanSumArray) {
      if (element.selected == true) {
        return false;
      }
    }
    return true;
  }

  void selectedCheckBox(index) {
    state.changguanSumArray[index].selected = !state.changguanSumArray[index].selected;
    update(['show_list']);

    platFormIds = "";
    for (var element in state.changguanSumArray) {
      if (element.selected == true) {
        platFormIds += element.platformId;
        platFormIds += ",";
      }
    }
    needShow2pages = false;
    state.isLoading = true;
    update(['yulechengcategorypage']);

    state.ty1DataArray.clear();
    state.dataArray.clear();
    print("fromChangguanPage ${fromChangguanPage}");
    if (fromChangguanPage == 2) {
      loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), navModel.cid,
          state.ty1DataArray, platFormIds);
    } else if (fromChangguanPage == 21) {
      loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), itemModel.cid,
          state.ty1DataArray, platFormIds);
    } else if (fromChangguanPage == 6) {
      loadHotRecomentData(state.dataArray.length ~/ (AppValues.defaultPageSize + 1), platFormIds,
          state.dataArray, state.changguanSumArray[index].total);
    } else {
      loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), lobbbModel.cid,
          state.ty1DataArray, platFormIds);
    }
  }

  void quanBuQingChu() {
    for (int i = 0; i < state.changguanSumArray.length; i++) {
      state.changguanSumArray[i].selected = false;
    }

    platFormIds = "";
    needShow2pages = false;
    loadData(state.ty1DataArray.length ~/ (AppValues.defaultPageSize + 1), navModel.cid,
        state.ty1DataArray, platFormIds);
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
  ///搜索相关
  void onFocusChange() {
    state.isFocused.value = focusNode.hasFocus;
    if (state.isFocused.value) state.showInfoType.value = 1;
    print("开始搜索了" + state.showInfoType.value.toString());
    update(['yulechengcategorypage']);
  }

  void closeSearchView() {
    state.showInfoType.value = 0;
    // ..textController.text = '';
    // ..searchCasinoList.value = [];
    focusNode.unfocus();
    update(['yulechengcategorypage']);
  }

  void onClean() {
    if (state.textController.text.isNotEmpty) {
      ///当输入框有内容时，1:清空输入框数据，2:清除搜索结果数据，showSearchType=0，3:取消输入框焦点
      state
        ..textController.text = ''
        ..showSearchType.value = 0
        ..searchCasinoList.value = [];

      focusNode.unfocus();
    } else {
      ///当输入框没有内容时，1:关闭搜索内容页 showInfoType=0
      state.showInfoType.value = 0;
      focusNode.unfocus();
    }
    update(['yulechengcategorypage']);
  }

  void search() {
    ///搜索结果如果为空 showSearchType=1，
    ///如果不为空 showSearchType=2 ，然后selectedType=0，展示娱乐城搜索结果，
    ///并将搜素的关键词加入搜索历史列表
    loadSearchData(state.searchCasinoList.length ~/ AppValues.defaultPageSize + 1,
        state.textController.text, state.dataArray);
  }

  loadSearchData(page, keyword, List<GameListModel> dataAccept) async {
    await ApiService.instance.getSearchCasinoGame(
      page: page,
      pageSize: 100,
      keyword: keyword,
      success: (pageModel) {
        dataAccept.clear();
        dataAccept.addAll(pageModel.content);
        if (pageModel.content.isNotEmpty) {
          saveSearchHistory(keyword);
          notifySearchHistory();
          print('搜索结果${dataAccept}');
          state.showSearchType.value = 2;
        } else {
          state.showSearchType.value = 1;
        }
        update(['yulechengcategorypage']);
      },
      fail: (message) {
        // pullToRefreshController.finishLoad();
        print(message);
      },
    );
  }

  void searchByClick(String content) {
    state.searchContent.value = content;
    state.textController.text = content;
    search();
    update(['yulechengcategorypage']);
  }

  void cleanHistory() {
    deleteSearchHistory();
    notifySearchHistory();
  }

  void removeWord(String word) {
    removeHistoryWord(word);
    notifySearchHistory();
  }

  ///刷新搜索历史，截取前十个搜索词
  void notifySearchHistory() {
    var searchHistory = getSearchHistory();
    if (searchHistory.length > 10) {
      searchHistory = searchHistory.sublist(0, 10);
    }
    state.history.value = searchHistory;
  }

  @override
  void onEvent(String eventId, event) {
    // TODO: implement onEvent
    if (eventId == kDidArticleCollectEvent) {
      print('跨页面传参：$event');
    }
  }

  void changePlay(int selectedType) {
    state.selectedType.value = selectedType;
  }

  @override
  onClose() {
    /// 移除事件监听
    // EventService.instance.removeListener(kDidArticleCollectEvent, this);
    focusNode.removeListener(onFocusChange);
    focusNode.dispose();
    super.onClose();
  }

  /// 搜索历史记录
  /// [word] 搜索记录
  static saveSearchHistory(String word) {
    List<String> history = getSearchHistory();
    if (history.contains(word)) {
      return;
    }
    history.insert(0, word);
    SPUtil().setStringList(CacheKey.searchHistory, history);
  }

  ///清空搜索历史
  static void deleteSearchHistory() {
    SPUtil().remove(CacheKey.searchHistory);
  }

  ///获取搜索历史记录
  static List<String> getSearchHistory() {
    try {
      var json = SPUtil().getStringList(CacheKey.searchHistory);
      // var json = sp.getStringList(SPKey.searchHistory);
      if (json == null) {
        return [];
      } else {
        return json;
      }
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  /// 搜索历史记录
  /// [word] 搜索记录
  static removeHistoryWord(String word) {
    List<String> history = getSearchHistory();
    if (history.contains(word)) {
      history.remove(word);
      SPUtil().setStringList(CacheKey.searchHistory, history);
    }
  }

  String sortTypeWithString(sort) {
    switch (sort) {
      case 0:
        return "name:asc";
      case 1:
        return "name:desc";
      case 2:
        return "sorting:asc";
      case 3:
        return "created_at:desc";
      default:
        return "created_at:desc";
    }
  }

  String getTotalGameText(int s1, int s2) {
    var text = S.current.showingContentNow(s1, s2);
    if (LangUtil().isTh()) {
      text = S.current.showingContentNow(s2, s1);
    }
    return text;
  }
}
