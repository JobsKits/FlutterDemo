import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/vault/views/vault_dialog_view.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_cache_key.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/sport/sport_menu_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/chat_room/user_info/view.dart';
import 'package:flutter_bet/pages/home/home_state.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/pages/personal_center/vip/view.dart';
import 'package:flutter_bet/pages/sport/common_model/sport_common_params.dart';
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/services/api/extension/sport_api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/services/event/event_service.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:flutter_bet/utils/json_util.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/url_launch_util.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/expansion/expand_list_model.dart';
import 'package:get/get.dart';

import '../../app/modules/wallet/views/wallet_dialog_view.dart';
import '../../constant/app_values.dart';
import '../../controllers/global_state_controller.dart';
import '../../model/page_common_model.dart';
import '../../routes/routes.dart';
import '../../services/api/api_service.dart';
import '../../utils/route_util.dart';
import '../../utils/sp_util.dart';
import '../../widget/expansion/expand_item_model.dart';
import '../../widget/refresh/custom_pull_to_refresh_controller.dart';
import '../account/logout/view.dart';
import '../activity/a_helper/activity_biz_mixin.dart';
import '../activity/a_model/activity_common_params.dart';
import '../activity/a_model/activty_sidebar_api_model.dart';
import '../activity/all_promotions/all_promotions_api_model.dart';
import '../alliance_plan/alliance_plan_view.dart';
import '../main/code.dart';
import '../personal_center/about_us/widgets/responsible_for_gambling/index.dart';
import '../personal_center/vip_club/vip_club_view.dart';
import 'amodel/home_common_params.dart.dart';
import 'amodel/navigation_item_info.dart';

const kDidArticleCollectEvent = 'kDidArticleCollectEvent';

class HomeLogic extends BaseController
    with EventListener, GetTickerProviderStateMixin, ActivityBizMixin {
  late HomeState state;
  late YulechengLobbyModel yulechengModel;
  late SportMenuModel sportMenuModel;
  late FocusNode focusNode;
  final CustomPullToRefreshController pullToRefreshController =
      CustomPullToRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
  final currencyLocal = const Locale("en", "US").obs;
  final GlobalStateController globalController = GlobalStateController.of();
  late TabController tabController;

  ///获取 实例对象
  static HomeLogic of() {
    return Get.find<HomeLogic>();
  }

  @override
  void onInit() {
    super.onInit();
    state = HomeState();

    EventService.instance.addListener(kDidArticleCollectEvent, this);
    focusNode = FocusNode();
    focusNode.addListener(onFocusChange);
    notifySearchHistory();
    loadGameMenuData();
    loadSportMenuData();
    getAllPromotions();
    loadActivitySidebarMenuData();

    currencyLocal.value = LangService.sharedInstance.lang.toLocaleValue;

    ///监听语言切换
    ///currencyLocal
    ever(currencyLocal, (locale) {
      log("监听语言切换...$locale");
      changeSelectedCurrencyType(locale);
      loadGameMenuData();
      loadSportMenuData();
      loadActivitySidebarMenuData();
    });
    ever(globalController.isLogin, (callback) => getAllPromotions());
  }

  changeSelectedCurrencyType(locale) {
    if (globalController.isLogin.value == true) {
      return;
    }
    Map<String, String> lang = {
      "zh_CN": "701",
      "pt_BR": "702",
      "hi_IN": "703",
      "vi_VN": "704",
      "th_TH": "705",
      "en_US": "706"
    };

    String? currentSelectLang = lang[locale.toString()];
    for (var element in globalController.currTypeInitialLists) {
      if (element.cur == currentSelectLang) {
        globalController.saveSelected(element);
      }
    }

    ///监听【娱乐城】【体育】顶部菜单切换
    ever(globalController.menuSelectType, (callback) {
      if (state.textController.text.length > 2) {
        search();
      }
    });

    /// 监听登录状态
    ever(globalController.isLogin, (callback) => getRecord());
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> onArticleCollect(name) async {
    if (name == 'casino') {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.GAME);
    } else {
      EventService.instance.dispatchEvent(kChangeMainPageEvent, MenuCode.MSG);
    }
  }

  /// 加载首页game娱乐城分类数据
  Future<void> loadGameMenuData() async {
    await ApiService.instance.getLobbyGame(
      success: (YulechengLobbyModel apiModel) {
        // log("娱乐城menu...${JsonUtil.encodeObj(data)}");

        yulechengModel = apiModel;
        state.casinoTwo.clear();
        state.casinoTwo.add(NavigationItemInfo(title: RxString(S.current.home_game)));

        //todo：1230，接口变更，添加sidebars字段，主要用来显示侧边菜单; //1220.接口变更，添加该字段
        for (var element in yulechengModel.sidebars!) {
          //todo：[0530]过滤掉游戏提供商，cid = 5; 游戏提供商单独的菜单；
          // if (apiModel.items != null) {
          //   apiModel.items!.removeWhere((element) => element.cid == HomeCommonConfig.gameCategoryCid);
          // }
          if (element.cid == HomeCommonConfig.gameCategoryCid) {
            continue;
          }
          state.casinoTwo.add(NavigationItemInfo(
            title: RxString(element.name),
            icon: element.icon,
            data: element,
          ));
        }
      },
      fail: (message) {},
    );
  }

  /// 加载首页sport分类数据, 包括顶级体育项目 和 体育项目
  Future<void> loadSportMenuData() async {
    await ApiService.instance.getSportMenu(
      success: (data) {
        // log('体育菜单数据...${JsonUtil.encodeObj(data)}');
        state.rcb.value = data.rbc.toString();
        sportMenuModel = data;
        // log('体育菜单数据：${sportMenuModel.menu[0].name}');
        state.topSportData.clear();
        state.allSportData.clear();
        // 需要考虑接口异常问题{"status":true,"data":{"menu":[{"menu_id":3,"name":"Top Sports Events","list":null}]
        // ,"all":null,"rbc":0}}
        ///顶级体育,
        if (sportMenuModel.menu[0].list.isNotEmpty) {
          for (var element in sportMenuModel.menu[0].list) {
            //"si": 1, //球种Id
            //"sn": "足球", //球种名称
            var expandStateBean = ExpandListModel(
              showIcon: true,
              value: element.si,
              headTitle: element.sn,
              headIcon: 'assets/images/home/ic_football.webp',
              headNetIcon: element.spic.substring(1),
              item: [],
              showRadio: false,
            );
            //todo: 临时添加live 、 outright 、viewAll 做测试
            ///live
            var expandItem01 = ExpandItemModel(
              itemId: element.si,
              data: SportOpenPageParams(
                sportOpenType: SportOpenType.live,
                title: element.sn,
                si: element.si,
                categoryTitle: element.sn,
              ),
              itemTitle: "Live & Upcoming",
              itemIcon: 'assets/images/home/ic_live.webp',
            );
            expandStateBean.item?.add(expandItem01);

            ///outright
            var expandItem02 = ExpandItemModel(
                itemId: element.si,
                data: SportOpenPageParams(
                  sportOpenType: SportOpenType.outright,
                  title: element.sn,
                  si: element.si,
                  categoryTitle: element.sn,
                ),
                itemTitle: "Outrights",
                itemIcon: 'assets/images/home/ic_outrights.webp');
            expandStateBean.item?.add(expandItem02);
            //接口数据
            for (var item in element.list) {
              //"ci": "15186", //联赛id
              expandStateBean.item?.add(ExpandItemModel(
                  itemId: element.si,
                  data: SportOpenPageParams(
                    sportOpenType: SportOpenType.league,
                    si: element.si, //球种Id
                    title: item.cn, //联赛名称
                    ci: item.ci, //联赛id
                    categoryTitle: element.sn,
                  ),
                  itemTitle: item.cn,
                  itemNetIcon: item.cpic.isNotEmpty ? item.cpic.substring(1) : "",
                  itemIcon: 'assets/images/home/ic_live.webp'));
            }

            ///viewAll
            var expandItem03 = ExpandItemModel(
                itemId: element.si,
                data: SportOpenPageParams(
                  sportOpenType: SportOpenType.viewAll,
                  title: element.sn,
                  si: element.si,
                  categoryTitle: element.sn,
                ),
                itemTitle: "View All",
                // itemIcon: 'assets/images/home/ic_baskball.webp');
                itemIcon: 'assets/images/home/ic_view_all.webp');
            expandStateBean.item?.add(expandItem03);
            state.topSportData.add(expandStateBean);
          }
        }

        //体育项目
        var expandStateBean = ExpandListModel(
          showIcon: true,
          value: 10,
          headTitle: S.current.all_sports,
          headIcon: 'assets/images/home/ic_baskball.webp',
          item: [],
          showRadio: false,
        );
        for (var element in sportMenuModel.all) {
          expandStateBean.item?.add(ExpandItemModel(
              itemTitle: element.sn,
              itemId: element.si,
              itemNetIcon: element.spic.substring(1),
              // 没有地区的 和 联赛
              data: SportOpenPageParams(
                sportOpenType: SportOpenType.sport,
                si: element.si, //球种Id
                title: element.sn, //体育名称
                categoryTitle: element.sn,
              ),
              itemIcon: 'assets/images/home/ic_live.webp'));
        }
        state.allSportData.add(expandStateBean);
      },
      fail: (message) {},
    );
  }

  ///选中语言，逻辑处理
  changeLang(int index) {
    switch (index) {
      case 1:
        currencyLocal.value = const Locale('zh', 'CN');
        LangService.sharedInstance.switchLang(LangType.zhCN);
        break;
      case 2:
        currencyLocal.value = const Locale('en', 'US');
        LangService.sharedInstance.switchLang(LangType.en);
        break;
      case 3:
        currencyLocal.value = const Locale('pt', 'BR');
        LangService.sharedInstance.switchLang(LangType.pt);
        break;
      case 4:
        currencyLocal.value = const Locale("vi", "VN");
        LangService.sharedInstance.switchLang(LangType.vi);
        break;
      case 5:
        currencyLocal.value = const Locale("th", "TH");
        LangService.sharedInstance.switchLang(LangType.th);
        break;
      case 6:
        currencyLocal.value = const Locale("hi", "IN");
        LangService.sharedInstance.switchLang(LangType.hi);
        break;
    }
    Get.updateLocale(currencyLocal.value);
  }

  void goToDetail(GameListModel items) {
    RouteUtil.pushToView(Routes.yulechengDetailPage,
        arguments: {"listmodel": items, "prePage": "catePage"});
  }

  void goTorRoute(String route, {String? arg}) {
    if (route == Routes.sport_side) {
      RouteUtil.pushToView(route, arguments: {'m': arg});
    } else {
      RouteUtil.pushToView(route);
    }
  }

  void onFocusChange() {
    state.isFocused.value = focusNode.hasFocus;
    if (state.isFocused.value) state.showInfoType.value = 1;
  }

  void closeSearchView() {
    state.showInfoType.value = 0;
    // ..textController.text = '';
    // ..searchCasinoList.value = [];
    focusNode.unfocus();
  }

  void onClean() {
    if (state.textController.text.isNotEmpty) {
      ///当输入框有内容时，1:清空输入框数据，2:清除搜索结果数据，showSearchType=0，3:取消输入框焦点
      state
        ..textController.text = ''
        ..showSearchType.value = 0
        ..searchCasinoList.value = []
        ..searchSportList.value = [];

      focusNode.unfocus();
    } else {
      ///当输入框没有内容时，1:关闭搜索内容页 showInfoType=0
      state.showInfoType.value = 0;
      focusNode.unfocus();
    }
  }

  void unfocus() {
    focusNode.unfocus();
  }

  void search() {
    ///搜索结果如果为空 showSearchType=1，
    ///如果不为空 showSearchType=2 ，然后selectedType=0，展示娱乐城搜索结果，
    ///并将搜素的关键词加入搜索历史列表
    if (globalController.menuSelectType.value == 0) {
      loadData(state.searchCasinoList.length ~/ AppValues.defaultPageSize + 1,
          state.textController.text, state.searchCasinoList);
    } else {
      ///搜索体育
      searchSport(state.textController.text);
    }
  }

  Future<void> searchSport(String keyword) async {
    await ApiService.instance.searchSport(
      keyword: keyword,
      success: (data) {
        state.searchSportList.clear();
        state.searchSportList.addAll(data.list ?? []);
        state.tabs.clear();
        if (data.list!.isNotEmpty) {
          saveSearchHistory(keyword);
          notifySearchHistory();
          state.showSearchType.value = 2;
          data.list?.forEach((element) {
            state.tabs.add(Tab(
              text: '${element.sn}/${element.c}',
            ));
          });
          tabController = TabController(length: state.tabs.length, vsync: this);
          state.listList.clear();
          state.chooseSi.value = state.searchSportList[0].si ?? 0;
          state.chooseSn.value = state.searchSportList[0].sn ?? '';
          state.listList.addAll(state.searchSportList[0].list!);
          tabController.addListener(() {
            state.chooseSn.value = state.searchSportList[tabController.index].sn ?? '';
            state.chooseSi.value = state.searchSportList[tabController.index].si ?? 0;
            state.listList.clear();
            state.listList.addAll(state.searchSportList[tabController.index].list!);
          });
        } else {
          state.showSearchType.value = 1;
        }
      },
      fail: (message) {},
    );
  }

  loadData(page, keyword, List<GameListModel> dataAccept) async {
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
      },
      fail: (message) {
        pullToRefreshController.finishLoad();
        print(message);
      },
    );
  }

  void searchByClick(String content) {
    state.searchContent.value = content;
    state.textController.text = content;
    search();
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
    if (searchHistory.length > 5) {
      searchHistory = searchHistory.sublist(0, 5);
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
    // state.selectedType.value = selectedType;
    globalController.menuSelectType.value = selectedType;
  }

  @override
  onClose() {
    /// 移除事件监听
    EventService.instance.removeListener(kDidArticleCollectEvent, this);
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

  ///navigation点击事件
  ///
  onNavigationListoneClicked(index) {
    if (index == 0) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage,
          arguments: {"title": S.current.sport_tabbar_favorites, "fromChangguanPage": 1});
    } else if (index == 1) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage,
          arguments: {"title": S.current.random_text_260, "fromChangguanPage": 1});
    } else if (index == 2) {
      if (globalController.isLogin.value) {
        goTorRoute(state.casinoOne[index].route ?? '');
      }
    }
  }

  void onNavgationlistTwoClicked(int index, NavigationItemInfo itemInfo) {
    // if (index == yulechengModel.sidebars!.length + 1) {
    //   //跳转游戏提供商
    //   RouteUtil.pushToView(Routes.yulechengCategoryPage,
    //       arguments: {"title": S.current.game_supplier, "fromChangguanPage": 3});
    // } else {
    //   if (yulechengModel.sidebars![index - 1].ty == 1) {
    //     loadty1Data(
    //         yulechengModel.sidebars![index - 1], 1, yulechengModel.sidebars![index - 1].cid);
    //   } else {
    //     RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
    //       "model": yulechengModel.sidebars![index - 1],
    //       "fromChangguanPage": 21,
    //       "needShow2pages": true,
    //       "sumsList": <Sum>[],
    //     });
    //   }
    // }

    if (itemInfo.data != null) {
      Nav nav = itemInfo.data;
      if (nav.cid == HomeCommonConfig.gameCategoryCid) {
        //跳转游戏提供商
        RouteUtil.pushToView(
          Routes.yulechengCategoryPage,
          arguments: {"title": S.current.game_supplier, "fromChangguanPage": 3},
        );
      } else {
        //非游戏提供商
        if (nav.ty == 1) {
          loadty1Data(nav, 1, nav.cid);
        } else {
          RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
            "model": nav,
            "fromChangguanPage": 21,
            "needShow2pages": true,
            "sumsList": <Sum>[],
          });
        }
      }
    }
  }

  loadty1Data(model, page, cid) async {
    await ApiService.instance.getLobbyGameCate(
      cid: cid,
      success: (pageModel) {
        RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
          "model": model,
          "fromChangguanPage": 21,
          "needShow2pages": true,
          "sumsList": pageModel?.sums ?? <Sum>[],
        });
      },
      fail: (message) {},
    );
  }

  onNavigationClicked(title, context) {
    if (title == S.current.game_supplier) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage,
          arguments: {"title": title, "fromChangguanPage": 3});
    } else if (title == S.current.alliance_program) {
      // showAlliancePlanDialog(context: context);
      AlliancePlanPage.openPage();
      //负责任博彩
    } else if (title == S.current.vip_club) {
      VipClubPage.openPage();
    } else if (title == S.current.home_blog) {
      // Logic for S.current.home_blog
    } else if (title == S.current.home_forum) {
      // Logic for S.current.home_forum
    } else if (title == S.current.live_support) {
      if (globalController.csUrl.isEmpty) {
        globalController.brandCS();
        return;
      }
      UrlLaunchUtil.jumpCs();
    } else if (title == S.current.responsible_gaming) {
      // showResponsibleWidget(context: context);
      //负责任博彩
      ResponsibleForGamblingPage.openPage();
    } else {
      // 默认情况
    }
  }

  ///个人资料 点击事件
  void onClickNavProfile(int itemId, BuildContext context) {
    switch (itemId) {
      case 1: //钱包
        // RouteUtil.pushToView(Routes.personalWallet);
        WalletDialogView.openDialog();
        // showCustomWalletWidget(context: context);
        break;
      case 2: //保险库
        // RouteUtil.pushToView(Routes.personalVault);
        // showCustomVaultWidget(context: context);
        VaultDialogView.openDialog();
        break;
      case 3: //VIP
        Timer(const Duration(milliseconds: 500), () {
          GlobalState.instance.index = 3;
          var globalStateController = GlobalStateController.of();
          int index = globalStateController.buttonSelectIndex.value;
          globalStateController.buttonSelectIndex.value = -1;
          RouteUtil.pushToView(Routes.personalVip, arguments: {"pageType": "vipRank"}, onBack: (d) {
            globalStateController.buttonSelectIndex.value = index;
          });
        });
        break;
      case 4: //统计数据
        // showDataCountWidget(context: context);
        // DataCountPage.openPage();
        // StatisticalDataView.openPage();
        showCustomChatRoomUserInfoWidget(context: context);
        break;
      case 5: //通知
        int index = globalController.buttonSelectIndex.value;
        globalController.buttonSelectIndex.value = -1;
        RouteUtil.pushToView(Routes.notifsPage, onBack: (d) {
          globalController.showOverlayView();
          globalController.buttonSelectIndex.value = index;
        });
        globalController.showOverlayView(isShowTopBarView: false);
        break;
      case 6: //体育投注
        RouteUtil.pushToView(Routes.betListPage);
        break;
      case 7:
        GlobalState.instance.index = 8;
        DialogUtils.goToPage(Routes.setupPage);
        break;
      case 8:
        showCustomLogoutWidget(context: context);
        break;
    }
  }

  void getAllPromotions() async {
    await ApiService.instance.getAllPromotions(
      page: 1,
      page_size: 20,
      category: ActivityListTypeEnum.all.category,
      success: (PageCommonModel<AllPromotionsApiModel> resultData) {
        for (var element in resultData.content) {
          if (element.ty == 1) {
            AllPromotionsApiModel model = element;
            state.pid = model.id!;
            getConfig();
            getRecord();
            break;
          }
        }
      },
      fail: (isConnect, message, candy) {},
    );
  }

  getConfig() async {
    state.getRollData.value = false;
    await ApiService.instance.getConfig(
        pid: state.pid,
        cur: globalController.currTypeSelected.value.cur ?? '701',
        success: (res) {
          state.currencyId = res['currency_id'];
          state.rollTimes.value = res['daily_roll_times'];
          state.getRollData.value = true;
        },
        fail: (e) {});
  }

  getRecord() async {
    state.luckyRecordState = LuckyRecordState.noData;
    state.getRollRecords.value = false;
    await ApiService.instance.getRecord(
        pid: state.pid,
        success: (res) {
          if (res.containsKey('data')) {
            SPUtil().remove(state.pid);
            state.luckyRecordState = LuckyRecordState.first;
          } else {
            state.luckyRecordState = LuckyRecordState.records;
          }
          state.getRollRecords.value = true;
        },
        fail: (e) {
          state.luckyRecordState = LuckyRecordState.first;
          state.getRollRecords.value = true;
        });
  }

  ///促销活动 点击事件
  ///itemId 是id
  void onClickNavPromotions(int itemId, ActivitySidebarApiModel itemModel) {
    //{
    //   "id": "39501624986258877",
    //   "name": "小猫咪喵喵喵",
    //   "ty": 1,
    //   "icon": "/promos/icons/1.webp"
    // }
    // log('点击了...促销活动...itemModel.ty...${itemModel.ty}');
    //获取活动类型
    onClickActivityMenuMixin(itemModel);
  }

  // final activitySidebarObs = <ActivitySidebarApiModel>[].obs;

  ///更新菜单， 手动刷新。例如：领取活动之后， 活动id需要变动
  ///调用如下： HomeLogic.of().updateActivityMenu();
  void updateActivityMenu() {
    loadActivitySidebarMenuData();
  }

  ///活动侧边栏
  void loadActivitySidebarMenuData() async {
    // await Future.delayed(Duration(seconds: 2));
    await ApiService.instance.getAllActivitySidebar(
      success: (List<ActivitySidebarApiModel> resultData) {
        // log("活动侧边栏api上层...${JsonUtil.encodeObj(resultData)}");
        _dealActivitySidebarMenu(resultData);
      },
      fail: (bool isConnect, String? message, candy) {
        _dealActivitySidebarMenu(null);
      },
    );
  }

  ///处理活动返回的数据
  void _dealActivitySidebarMenu(List<ActivitySidebarApiModel>? resultData) {
    //如果请求失败， 不更新菜单，保留就数据
    // if (resultData == null && state.activityDataObs.isNotEmpty) return;

    //请求成功，有数据，即使是[] 也算
    state.activityDataObs.clear();
    //体育项目
    var expandStateBean = ExpandListModel(
      showIcon: true,
      value: 1,
      headTitle: S.current.promotions,
      headIcon: 'assets/images/activity/menu/ic_activity_menu.webp',
      item: [],
      showRadio: false,
    );
    if (resultData != null) {
      for (var model in resultData) {
        var typeEnum = ActivityTypeEnum.adaptor(model.ty);
        expandStateBean.item?.add(ExpandItemModel(
          itemId: int.parse(model.id ?? "0"),
          // itemTitle: "${model.name}${math.Random().nextInt(10).toString()}",
          itemTitle: model.name,
          // itemTitle:model.name,
          itemIcon: typeEnum?.localIcon,
          // itemNetIcon: "${AppValues.defaultBranch.asset_url}${model.icon}",
          showIcon: true,
          // itemNetIcon: model.icon ?? "",
          // itemNetIcon: "/sports/im/m/1.webp",
          // itemNetIcon: "/promos/zh_CN/1711982004843.webp",// "/promos/icons/2.webp"
          // itemIcon: "assets/images/activity/ic_activity_menu_default.webp",
          showLine: false,
          data: model,
        ));
        // log("活动侧边栏...icon...${AppValues.defaultBranch.asset_url}${model.icon}");
      }
    }

    //查看全部
    expandStateBean.item?.add(ExpandItemModel(
      itemId: ActivityTypeEnum.all.type,
      itemTitle: S.current.chaKanQuanBu,
      itemIcon: 'assets/images/activity/menu/ic_activity_menu.webp',
      showLine: resultData != null,
      data: ActivitySidebarApiModel(ty: ActivityTypeEnum.all.type),
    ));

    state.activityDataObs.add(expandStateBean);
    log("state.activityDataObs...${expandStateBean.toString()}");
    state.activityDataObs.refresh();
  }

  ///关闭搜索页面view
  void doGotoCloseSearchView() {
    //如果是搜索状态
    if (state.showInfoType.value == 1) {
      onClean();
      state.showInfoType.value = 0;
    }
  }
}
