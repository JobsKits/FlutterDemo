import 'dart:math';
import 'dart:ui';

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/page.dart';
import 'package:flutter_bet/model/yulecheng/casino_record_model.dart';
import 'package:flutter_bet/model/yulecheng/gamelist_model.dart';
import 'package:flutter_bet/model/yulecheng/index.dart';
import 'package:flutter_bet/pages/account/login/login_widget.dart';
import 'package:flutter_bet/pages/find/state.dart';
import 'package:flutter_bet/pages/find/yulechengtouzhurank/controller.dart';
import 'package:flutter_bet/pages/personal_center/vault/deposit_view.dart';
import 'package:flutter_bet/pages/sport/sportbannermodel.dart';
import 'package:flutter_bet/pages/web_browser/logic.dart';
import 'package:flutter_bet/routes/routes.dart';
import 'package:flutter_bet/services/account_service.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../services/api/api_service.dart';
import '../../services/api/extension/yulecheng_game_service.dart';
import '../../utils/route_util.dart';
import '../../widget/refresh/custom_pull_to_refresh_controller.dart';

class FindLogic extends BaseController with GetTickerProviderStateMixin {
  late CasinoState state;
  // tab 控制器
  late TabController tabController;
  // tab 控制器
  int tabIndex = 0;

  //是否是大厅选中
  bool isGameLobbby = false;
  final listSize = 30.obs;
// lobby data
  YulechengLobbyModel? yulechengModel;

  final CustomPullToRefreshController pullToRefreshController =
      CustomPullToRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

  final ScrollController scrollcontroller = ScrollController();

  bool isInitialized = false;

  String platformName = "";
  late RxList<YuLeChengChangGuanModel> changguanDataArray = <YuLeChengChangGuanModel>[].obs;
  bool isZhenRen = false;

// 规则
  bool miaoshuOpen = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state = CasinoState();
    getBanner();
    getMarquee();

    ever(globalController.isLogin, (isLogin) {
      state = CasinoState();

      getBanner();
      getMarquee();
      initData();
    });
    ever(globalController.langType, (langType) {
      state = CasinoState();

      getBanner();
      getMarquee();
      initData();
      onrefresh();
    });
  }

  initData() {
    refreshTabIconStatus();

    tabController = TabController(length: state.tabs.length, vsync: this);
    tabController.addListener(
      () {
        if (tabController.indexIsChanging) {
          tabIndex = tabController.index;
          state.showStatus.clear();
          state.showArrawStatus.clear();

          refreshTabIconStatus();
          state.isLoadingFinished = false;

          // if (tabIndex != 0) {
          state.dataArray.clear();
          state.ty2DataArray.clear();
          state.cgDataArray.clear();

          if (state.navs[tabIndex].cid == "1") {
            // "游戏提供商"
            isGameLobbby = true;
          } else {
            isGameLobbby = false;
            if (state.navs[tabIndex].cid == "5") {
              // "游戏提供商"
              loadDataCg(state.cgDataArray);
            } else if (state.navs[tabIndex].ty == 1) {
              if (state.lobbyData.containsKey(tabIndex.toString())) {
                YulechengLobbyCateModel pageModel = state.lobbyData[tabIndex.toString()];
                state.dataArray.clear();
                state.dataArrayNoLitems.clear();
                state.totalGame = pageModel.total.toInt();
                state.dataArray = pageModel.litems;
                int count = pageModel.games!.length;
                if (count > 9) {
                  count = 9;
                }
                for (int i = 0; i < count; i++) {
                  state.dataArrayNoLitems.add(pageModel.games![i]);
                }
                print("走缓存数据 ${state.dataArrayNoLitems.length}  ${pageModel.games!.length}");

                // state.dataArrayNoLitems.addAll(pageModel.games!);
                state.changguanSumArray.clear();
                state.changguanSumArray.addAll(pageModel?.sums ?? []);
                state.isLoadingFinished = true;

                update(['yulecheng_home_page']);

                // return;
              }
              loadData(state.dataArray.length ~/ AppValues.defaultPageSize + 1,
                  state.navs[tabIndex].cid, state.dataArray);
            } else {
              state.ty2DataArray.clear();
              if (state.lobbyData.containsKey(tabIndex.toString())) {
                // state.ty2DataArray = state.lobbyData[tabIndex.toString()];
                // state.dataArray.addAll(state.lobbyData[tabIndex.toString()]);
                PageModel<GameListModel> pageModel = state.lobbyData[tabIndex.toString()];
                state.totalGame = pageModel.total.toInt();
                state.ty2DataArray.clear();
                state.ty2DataArray = pageModel.content as RxList<GameListModel>;
                update(['yulecheng_home_page']);

                // return;
              }
              loadDataTy2(state.ty2DataArray.length ~/ AppValues.defaultPageSize + 1,
                  state.navs[tabIndex].platformId, state.ty2DataArray);
            }
          }
        }
        update(['yulecheng_home_page']);

        // }
      },
    );
    scrollcontroller.addListener(_scrollListener);

    isInitialized = true;
  }

  void _scrollListener() {
    if (scrollcontroller.position.userScrollDirection == ScrollDirection.reverse) {
      // 开始向下滚动

      if (state.navs[tabIndex].ty == 1) {
        if (state.lobbyData.containsKey(tabIndex.toString())) {
          YulechengLobbyCateModel pageModel = state.lobbyData[tabIndex.toString()];

          int count = pageModel.games!.length;
          if (count > 9) {
            count = 9;
          }
          if (state.dataArrayNoLitems.length == count) {
            for (int i = count; i < pageModel.games!.length; i++) {
              state.dataArrayNoLitems.add(pageModel.games![i]);
            }
            update(['yulecheng_home_page']);
          }

          return;
        }
      } else {
        state.ty2DataArray.clear();
        if (state.lobbyData.containsKey(tabIndex.toString())) {
          // state.ty2DataArray = state.lobbyData[tabIndex.toString()];
          // state.dataArray.addAll(state.lobbyData[tabIndex.toString()]);
          PageModel<GameListModel> pageModel = state.lobbyData[tabIndex.toString()];
          state.totalGame = pageModel.total.toInt();
          state.ty2DataArray.clear();
          state.ty2DataArray = pageModel.content as RxList<GameListModel>;
          update(['yulecheng_home_page']);

          return;
        }
        loadDataTy2(state.ty2DataArray.length ~/ AppValues.defaultPageSize + 1,
            state.navs[tabIndex].platformId, state.ty2DataArray);
      }

      update(['yulecheng_home_page']);
    } else if (scrollcontroller.position.userScrollDirection == ScrollDirection.reverse) {
      // 开始向上滚动
      print('Scrolling started-----up');
    }
  }

  void refreshTabIconStatus() {
    state.tabs.clear();
    // state.tabs.add(Tab(
    //   icon: ColorFiltered(
    //     colorFilter: ColorFilter.mode(
    //         tabIndex == 0 ? AppThemes.textColorWhite : Colors.transparent, BlendMode.srcATop),
    //     child: CustomNetWorkImage(
    //       imageUrl: BranchService.instance.current.asset_url + yulechengModel.icon!,
    //       width: 14,
    //       height: 14,
    //       errorWidget: const SizedBox(
    //         width: 14,
    //         height: 14,
    //       ),
    //     ),
    //   ),
    //   child: Text(yulechengModel.name!,
    //       style: ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
    // ));
    state.navs.clear();
    if (yulechengModel == null) return;
    int length = yulechengModel?.navs!.length ?? 0;
    for (var i = 0; i < length; i++) {
      var item = yulechengModel?.navs![i];
      if (item != null && (item.name.isEmpty || item.name.isEmpty)) {
        break;
      }
      state.navs.add(item!);
      state.tabs.add(Tab(
        icon: ColorFiltered(
          colorFilter: ColorFilter.mode(
              i == tabIndex ? AppThemes.textColorWhite : Colors.transparent, BlendMode.srcATop),
          child: CustomNetWorkImage(
            imageUrl: '${BranchService.instance.current.asset_url}${item?.icon ?? ''}',
            width: 14,
            height: 14,
            errorWidget: const SizedBox(
              width: 14,
              height: 14,
            ),
          ),
        ),
        child: Text(item.name,
            style:
                ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ));
    }
  }

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    getBanner();

    await ApiService.instance.getLobbyGameCate5(
      cid: "5",
      success: (pageModel) {
        //游戏场馆获取 cid == "5"
        changguanDataArray.clear();
        changguanDataArray.addAll(pageModel.content);
        update(['yulecheng_home_page']);
      },
      fail: (message) {
        update(['yulecheng_home_page']);
      },
    );
    await ApiService.instance.getLobbyGame(
      success: (data) {
        yulechengModel = data;

        // 游戏场馆获取 cid == "5"
        changguanDataArray.clear();
        data.items?.forEach(
          (element) {
            if (element.cid == "5") {
              element.games?.forEach((gameInfo) {
                // 转换为场馆Model
                final cgModel = YuLeChengChangGuanModel(
                    id: gameInfo.platformId,
                    name: gameInfo.name,
                    icon: gameInfo.img,
                    maintained: gameInfo.maintained ?? "");
                changguanDataArray.add(cgModel);
              });
            }
          },
        );

        initData();

        update(['yulecheng_home_page']);
        if (yulechengModel == null) return;
        int length = yulechengModel?.navs!.length ?? 0;
        for (int i = 0; i < length; i++) {
          if (yulechengModel?.navs![i].cid == "1") {
            tabController.animateTo(i);
            isGameLobbby = true;
            return;
          }
        }
      },
      fail: (message) {
        state.isLoadingFinished = true;
        yulechengModel = YulechengLobbyModel.fromJson({});
        update(['yulecheng_home_page']);
      },
    );
  }

  getBanner() async {
    state.bannnerList.clear();
    await ApiService.instance.getCasinoBanner(
        success: (res) {
          state.bannnerList.value = res.map((e) => SportBannerModel.fromJson(e)).toList();
          // state.bannnerList.refresh();
          update(['yulecheng_home_page']);
        },
        fail: (e) {});
  }

  //

  Future<void> getMarquee() async {
    await ApiService.instance.getGameMarquee(
      success: (data) {
        String marquee = '';
        for (var item in data.marquee!) {
          marquee = '$marquee${item.title}  ${item.content}  ';
        }
        state.marqueeText.value = marquee;
      },
      fail: (message) {},
    );
  }

  loadData(page, cid, dataAccept) async {
    await ApiService.instance.getLobbyGameCate(
      cid: cid,
      success: (pageModel) {
        // if (pageModel.over == true) {
        //   pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        // }
        dataAccept.clear();
        state.dataArrayNoLitems.clear();

        state.totalGame = pageModel.total.toInt();

        dataAccept.addAll(pageModel.litems);
        state.dataArrayNoLitems.addAll(pageModel.games!);
        if (pageModel.litems.length < 1) {
          isZhenRen = getNeedShowPlayerStatus(pageModel.games!);
        }
        state.changguanSumArray.clear();
        state.changguanSumArray.addAll(pageModel?.sums ?? []);
        state.isLoadingFinished = true;

        state.lobbyData[tabIndex.toString()] = pageModel;
        Future.delayed(const Duration(seconds: 1), () {
          update(['yulecheng_home_page']);
        });
      },
      fail: (message) {
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;
        update(['yulecheng_home_page']);
      },
    );
  }

  bool getNeedShowPlayerStatus(List itemsList) {
    bool isZhenren = true;
    for (var element in itemsList) {
      print("element.platformId = ${element.platformId}");
      if (element.platformId != "101") {
        isZhenren = false;
        break;
      }
    }
    return isZhenren;
  }

  loadDataTy2(page, platform_id, dataAccept) async {
    await ApiService.instance.getYulechengTy2Games(
      page_size: AppValues.defaultPageSize + 1,
      page: page,
      platformid: platform_id,
      success: (pageModel) {
        if (pageModel.over == true) {
          pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        }
        state.totalGame = pageModel.total.toInt();
        dataAccept.clear();

        dataAccept.addAll(pageModel.content);
        isZhenRen = getNeedShowPlayerStatus(dataAccept);

        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;

        state.lobbyData[tabIndex.toString()] = pageModel;

        Future.delayed(const Duration(seconds: 1), () {
          update(['yulecheng_home_page']);
        });
      },
      fail: (message) {
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;
        update(['yulecheng_home_page']);
      },
    );
  }

  // "游戏提供商数据加载"
  loadDataCg(dataAccept) async {
    await ApiService.instance.getAllPlatForm(
      success: (dataInfo) {
        pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        state.totalGame = dataInfo.games.length;
        dataAccept.clear();

        dataAccept.addAll(dataInfo.games);
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;

        Future.delayed(const Duration(seconds: 1), () {
          update(['yulecheng_home_page']);
        });
      },
      fail: (message) {
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;
        update(['yulecheng_home_page']);
      },
    );
  }

  loadMoreData(page, cid, dataAccept) async {
    await ApiService.instance.getLobbyGameCateMoreData(
      page_size: AppValues.defaultPageSize + 1,
      page: page,
      platform_id: "",
      cid: cid,
      success: (pageModel) {
        if (pageModel.over == true) {
          pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
        }
        dataAccept.addAll(pageModel.content);
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;

        Future.delayed(const Duration(seconds: 1), () {
          update(['yulecheng_home_page']);
        });
      },
      fail: (message) {
        pullToRefreshController.finishLoad();
        state.isLoadingFinished = true;
        update(['yulecheng_home_page']);
      },
    );
  }

  Future onrefresh() async {
    tabController.animateTo(0);
    onReady();
    await Future.delayed(const Duration(seconds: 2));
    pullToRefreshController.finishRefresh();
    // controller.listSize.value = 30;
  }

  Future onLoadMore() async {
    // await Future.delayed(const Duration(seconds: 3));
    // if (controller.listSize.value > 60) {
    // if (tabIndex == 0) {
    //   pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
    //   pullToRefreshController.finishLoad();
    // } else {
    //   if (yulechengModel.navs![tabIndex - 1].ty == 1) {
    //     loadMoreData(state.dataArray.length ~/ AppValues.defaultPageSize + 1,
    //         yulechengModel.navs![tabIndex - 1].cid, state.dataArray);
    //   } else {
    //     loadDataTy2(state.ty2DataArray.length ~/ (AppValues.defaultPageSize + 1) + 1,
    //         yulechengModel.navs![tabIndex - 1].platformId, state.ty2DataArray);
    //   }
    // pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
    pullToRefreshController.finishLoad(result: CustomIndicatorResult.noMore);
    pullToRefreshController.finishLoad();
    // }
    update(['yulecheng_home_page']);

    // } else {
    //   controller.listSize.value = controller.listSize.value + 30;
    // }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    tabController.dispose();
  }

  goToshowAll(index) {
    if (isGameLobbby) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
        "model": yulechengModel?.items![index],
        "fromChangguanPage": 5,
        "needShow2pages": true,
      });
    } else {
      RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
        "model": state.dataArray[index],
        "fromChangguanPage": 5,
        "needShow2pages": true,
      });
    }
  }

  void goToDetail(GameListModel items, needshowall, index) {
    if (needshowall == true) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
        "model": yulechengModel?.items![index],
        "fromChangguanPage": 5,
        "needShow2pages": true,
      });
    } else {
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
      if (tabIndex == 0) {
        RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
          "model": items,
          "prePage": "lobbyPage",
          "platformName": yulechengModel?.items![index].name
        });
      } else {
        print("点击了");
        RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
          "model": items,
          "prePage": "lobbyPage",
          "platformName": state.navs[tabIndex].name
        });
      }
    }
  }

  void ty2GoToDetail(GameListModel items) {
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
    RouteUtil.pushToView(Routes.yulechengDetailPage, arguments: {
      "listmodel": items,
      "prePage": "catePage",
      "platformName": state.navs[tabIndex].name
    });
  }

  void goToShowQuanBu(index) {
    if (yulechengModel == null || yulechengModel?.navs == null) return;
    int length = yulechengModel?.navs!.length ?? 0;
    if (index == length + 1) {
      RouteUtil.pushToView(Routes.yulechengCategoryPage,
          arguments: {"title": S.current.game_supplier, "fromChangguanPage": 3});
    } else {
      RouteUtil.pushToView(Routes.yulechengCategoryPage, arguments: {
        "model": yulechengModel?.navs![index],
        "fromChangguanPage": 2,
        "needShow2pages": true,
        "sumsList": state.changguanSumArray,
      });
    }
  }

  void goToPlatDetail(YuLeChengChangGuanModel items) {
    RouteUtil.pushToView(Routes.yulechengCategoryPage,
        arguments: {"model": items, "fromChangguanPage": 4});
  }

  void goToPage(int page) {
    state.pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  //处理大厅箭头显示问题
  int getShowArrowStatus(index) {
    if (state.showArrawStatus.containsKey(index.toString())) {
      return state.showArrawStatus[index.toString()]!;
    }
    int showStatus = 0;
    state.showArrawStatus[index.toString()] = showStatus;
    return showStatus;
  }

  //处理大厅左右滑动遇到的listview item 太少,需要下方页面缩上来的问题
  List<bool> getShowStatus(index, length) {
    if (state.showStatus.containsKey(index.toString())) {
      return state.showStatus[index.toString()]!;
    }
    List<bool> showStatus = [];
    for (int i = 0; i < length; i++) {
      showStatus.add(true);
    }
    state.showStatus[index.toString()] = showStatus;
    return showStatus;
  }

  changeShowStatus(currentKeyIndex, changedValue, ScrollController scrollController) {
    if (state.showStatus.containsKey(currentKeyIndex.toString())) {
      state.showStatus[currentKeyIndex.toString()] = changedValue;
      changeArrowShowStatus(currentKeyIndex, scrollController);
      update(['yulecheng_home_page']);
    }
  }

  changeArrowShowStatus(currentKeyIndex, scrollController) {
    double offset = scrollController.offset;
    var showType = 0;
    if (offset >= scrollController.position.maxScrollExtent) {
      showType = 1;
    } else if (offset <= 0) {
      showType = 0;
    } else {
      showType = 2;
    }
    state.showArrawStatus[currentKeyIndex.toString()] = showType;
  }

  updateMiaoshu() {
    if (miaoshuOpen == true) {
      scrollcontroller.animateTo(0.0,
          duration: const Duration(
            milliseconds: 300,
          ),
          curve: Curves.bounceInOut);
    }

    Future.delayed(const Duration(milliseconds: 300), () {
      miaoshuOpen = !miaoshuOpen;

      update(['yulecheng_miaoshu_page']);
    });
  }

  // 处理上线滑动的动画
  putAnimationIndex(index) {
    state.animationIndex = index;
    Future.delayed(
      const Duration(milliseconds: 200),
      (() {
        update(['yulecheng_home_page']);
      }),
    );
  }
}
