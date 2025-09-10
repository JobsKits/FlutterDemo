import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/tenant_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_turntable_detail.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/announcement_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_utils.dart';
import 'package:flutter_tiyu_app/app/widget/app_line_error_dialog.dart';
import 'package:flutter_tiyu_app/app/widget/app_update_dialog.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/dialog_manager.dart';
import 'package:flutter_tiyu_app/utils/string_utils.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../api/activity_api.dart';
import '../../../../api/home_api.dart';
import '../../../../api/login_api.dart';
import '../../../../api/user_api.dart';
import '../../../../constants/game_constants.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/network/service.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../theme/theme.service.dart';
import '../../../../native_utils.dart';
import '../../../../utils/game_manager.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/public_util.dart';
import '../../../../utils/recent_games_util.dart';
import '../../../../utils/sp_util.dart';
import '../../../../utils/tenant_manager.dart';
import '../../../../utils/url_utils.dart';
import '../../../data/home_game_tab_bean.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../data/home_rank_list_bean.dart';
import '../../../data/home_tab_data.dart';
import '../../../data/new_home_game_tab_bean.dart';
import '../../../data/real_time_prizes_bean.dart';
import '../../../data/tenant_bean.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_loading_view.dart';
import '../../../widget/game_try_tips_dialog.dart';
import '../../../widget/system_announcement_dialog.dart';
import '../../activity/controllers/activity_controller.dart';
import '../../activity/data/activity_bean.dart';
import '../../activity/data/yuebao_bean.dart';
import '../../login/views/login_dialog.dart';
import '../../tabs/controllers/tabs_controller.dart';
import '../../user/data/InboxMsgItemBean.dart';
import '../../user/data/my_message_bean.dart';
import '../../wallet/data/recharge_type_bean.dart';
import '../../wallet/data/recharge_type_tab_bean.dart';
import '../home_view_const.dart';
import '../new_home_const.dart';
import '../views/hot_game_detail_view.dart';
import 'home_controller_data_process.dart';
import 'home_data_manager.dart';
import 'new_home_controller.detail.dart';

class NewHomeController extends GetxController
    with GetTickerProviderStateMixin {
  late CarouselSliderController buttonCarouselController =
      CarouselSliderController(); //banner和指示器的Controller
  late CarouselSliderController realTimePrizesController =
      CarouselSliderController(); //爆奖游戏滚动的Controller
  late ScrollController scrollController; //首页滚动Controller
  RxInt currentBannerIndex = 0.obs; //当前选中banner的index
  RxInt currentTabIndex = 0.obs; //当前选中tab对应的页面的index
  RxString marqueeTitle = "".obs; //跑马灯title
  RxList<BannerAndAnnouncementItem> mAnnouncementList =
      <BannerAndAnnouncementItem>[].obs; //公告列表
  RxList<BannerAndAnnouncementItem> mMarqueeList =
      <BannerAndAnnouncementItem>[].obs; //跑马灯列表
  RxList<ActivityListItemBean> mBannerList =
      <ActivityListItemBean>[].obs; //banner列表
  RxBool isShowScrollTopButton = false.obs; //是否显示滚动到顶部的按钮游戏列表假数据
  late TabsController tabsController = Get.find();
  RxList<GameBeanItem> hotGameList = <GameBeanItem>[].obs; // 热门游戏数据
  List<GameBeanItem> oldHotGameList = <GameBeanItem>[]; // 热门游戏数据
  // 子类的游戏列表
  RxList<GameBeanItem> hotGameElectronic = <GameBeanItem>[].obs; // 热门电子游戏
  RxList<GameBeanItem> hotGameFishing = <GameBeanItem>[].obs; // 热门捕鱼
  RxList<GameBeanItem> hotGameChess = <GameBeanItem>[].obs; // 热门棋牌
  RxList<GameBeanItem> hotGameBlockChain = <GameBeanItem>[].obs; // 热门区块链
  RxList<String> menuList = <String>[].obs; // 首页显示菜单
  // 场馆数据
  RxList<ThirdGamesItem> gameElectronic = <ThirdGamesItem>[].obs; // 电子游戏
  RxList<ThirdGamesItem> gameFishing = <ThirdGamesItem>[].obs; // 捕鱼
  RxList<ThirdGamesItem> gameChess = <ThirdGamesItem>[].obs; // 棋牌
  RxList<ThirdGamesItem> gameLive = <ThirdGamesItem>[].obs; // 真人
  RxList<ThirdGamesItem> gameLottery = <ThirdGamesItem>[].obs; // 彩票
  RxList<ThirdGamesItem> gameSports = <ThirdGamesItem>[].obs; // 体育
  RxList<ThirdGamesItem> gameBlockchain = <ThirdGamesItem>[].obs; // 区块链
  Rxn<TabController> tabController = Rxn();
  // 是否首页 电子等 数据请求完成
  RxBool isRequestHomeData = false.obs;
  RxBool displayMenu = false.obs;
  late RxBool isClickCollect = false.obs;
  // 是否需要浮动TabBar
  late RxBool isFloating = false.obs;
  // 存储游戏ID
  RxInt gameId = 0.obs;
  late ActivityController activityController = Get.find();
  late AnimationController animationController; // 动画控制器
  late Animation<Offset> slideAnimation; // 菜单滑动动画
  List<Map> homeMenuList = [
    {'name': '投注记录', 'icon': Assets.theme1.images.home.homeMenuBet.path},
    {'name': '任务中心', 'icon': Assets.theme1.images.home.homeMenuTask.path},
    {'name': '福利中心', 'icon': Assets.theme1.images.home.homeMenuBouns.path},
    {'name': '自助返水', 'icon': Assets.theme1.images.home.iconRebates.path},
    {'name': '找回余额', 'icon': Assets.theme1.images.home.homeMenuRetrieve.path},
    {'name': '消息中心', 'icon': Assets.theme1.images.home.homeMenuNotic.path},
    {'name': '推广赚钱', 'icon': Assets.theme1.images.home.homeMenuPromotion.path},
    {'name': '备用网址', 'icon': Assets.theme1.images.home.homeMenuBet.path}
  ];
  // 用于点击打开游戏防抖
  late RxBool isClickOpenGame = false.obs;
  RxList<HomeRankListBean> rankList = <HomeRankListBean>[].obs;
  RxList<NewHomeGameTabBean> homeCategoryList = <NewHomeGameTabBean>[].obs;
  RxString iconPath = "".obs;
  List<ThirdGamesItem> thirdGameList = <ThirdGamesItem>[];
  var topHeight = 472.h; //顶部偏移量 = banner + 公告的高度
  // app名字
  RxString appName = ''.obs;
  bool waittingForBalance = false;
  bool announcementShowed = false;
  RxDouble balanceTreasure = 0.00.obs; // 钱包金币
  NewHomeGameTabBean? currentSelectTab;
  RxBool isTabBarFixed = false.obs;
  bool hasPwd = false; //是否有支付密码，默认false
  Rxn<GameBeanItem> gameBeanItem = Rxn();
  RxInt unReadCount = 0.obs;
  List<int> recentGameList = [];
  // 最近列表
  RxList<HomeCollectionListItemBean> gameRecords =
      <HomeCollectionListItemBean>[].obs;
  RxInt isShowBulletinId = 0.obs; // 点击了当前子项目
  PageController pageController = PageController();
  RxString homeFloatIconPath = "".obs;
  RxString homeFloatIconName = "".obs;

  late NewHomeControllerDetail controller;
  GlobalKey bottomViewKey = GlobalKey();
  var callbackChannel = MethodChannel('native_webview_callback');
  bool isGameTry = false; //是否是试玩打开游戏，默认false
  void initNativeCallbackListener() {
    callbackChannel.setMethodCallHandler((call) async {
      if (call.method == 'onExitConfirmed') {
        if (isGameTry) {
          Get.dialog(
            LoginDialog(
              isShowLogin: false,
              callback: () {
                Get.back();
              },
            ),
            barrierDismissible: false,
          );
          isGameTry = false;
          return;
        }
        if (tempPlayId > 0) {
          String playIds = '${tempPlayId}';
          waittingForBalance = true;
          // 延迟2秒调回收余额接口
          Future.delayed(
            const Duration(seconds: 2),
            () async {
              retrieveAndCheckBalance(
                false,
                playIds,
              );
            },
          );
        }
        reqMoney(true);
      }
    });
  }

  bool isFirstLoadHomeFinish = false; //是否首次加载首页结束
  @override
  void onInit() {
    super.onInit();
    initTabKey();
    // if (Platform.isIOS) {
    initNativeCallbackListener();
    // }
    LogoManage? logoManage = TenantManager.instance.tenantBean?.logoManage
        ?.firstWhereOrNull((value) => value.messageId == 29);
    if (logoManage != null) {
      iconPath.value = logoManage.picAddr!;
    }
    if (TenantManager.instance.tenantBean?.tenant?.tenantName != null) {
      appName.value = TenantManager.instance.tenantBean!.tenant!.tenantName!;
    }
    scrollController = ScrollController();
    scrollController.addListener(() {
      isTabBarFixed.value = scrollController.offset > 200; // 根据滚动偏移量判断是否悬停
      isShowScrollTopButton.value = scrollController.position.pixels > 1000.h;
    });
    // 初始化动画控制器
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    // 初始化滑动动画
    slideAnimation = Tween<Offset>(
      begin: const Offset(-0.7, 0.0), // 菜单从屏幕左侧外部开始
      end: const Offset(0.0, 0.0), // 菜单最终停留在屏幕左侧
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    loadHomeFloatIcon();
    loadHomeData(HomeRequestManager.to.homeMainInfoBean.value);

    // ever(HomeRequestManager.to.homeMainInfoBean, (value) {
    //   loadHomeData(value);
    // });
    ever(TenantManager.instance.appImgDomainPath, (count) {
      //如果检测到地址变更的时候,首页已经加载完成,那么进入执行
      if (isFirstLoadHomeFinish &&
          TenantManager.instance.appImgDomainPath.isNotEmpty &&
          TenantManager.instance.errorImgCount.value > 1) {
        if (isShowChangeLineDialog) {
          return;
        }
        isShowChangeLineDialog = true;
        //显示弹窗
        DialogManager.showDialogWithQueue(
            dialog: (AppLineErrorDialog(
          changeLine: () {
            AppManager.instance.tapVibrate();
            if (homeMainBean != null) {
              TenantManager.instance.resetErrorImgCount(); //清空报错数量
              loadHomeData(homeMainBean!);
            }
            // isShowChangeLineDialog = false; 暂时不置为false,避免图片有问题,重复加载重复弹出,所以只执行一次逻辑
          },
        )));
      }
    });
    ever(TenantManager.instance.errorImgCount, (count) {
      //如果检测到地址变更的时候,首页已经加载完成,那么进入执行
      if (isFirstLoadHomeFinish &&
          TenantManager.instance.appImgDomainPath.isNotEmpty &&
          TenantManager.instance.errorImgCount.value > 1) {
        if (isShowChangeLineDialog) {
          return;
        }
        isShowChangeLineDialog = true;
        //显示弹窗
        DialogManager.showDialogWithQueue(
            dialog: (AppLineErrorDialog(
          changeLine: () {
            AppManager.instance.tapVibrate();
            if (homeMainBean != null) {
              TenantManager.instance.resetErrorImgCount(); //清空报错数量
              loadHomeData(homeMainBean!);
            }
            // isShowChangeLineDialog = false; 暂时不置为false,避免图片有问题,重复加载重复弹出,所以只执行一次逻辑
          },
        )));
      }
    });
    loadRankList();
    loadGameRecords();
    reqBanner();
    reqRealTimePrizes(); //请求实时爆奖数据
    if (LoginManager.instance.isLogin.value) {
      reqMoney(false);
    }
    // 使用 ever 方法监听 登录状态，状态发生改变，重新请求首页数据
    ever(LoginManager.instance.isLogin, (value) async {
      if (value) {
        initTabKey();
        reqHomeData();
        reqMoney(false);
        // reqMessage();
        checkPwdStatus();
        loadYuebaoMoney();
      } else {
        initTabKey();
        reqHomeData();
      }
    });

    ever(tabsController.currentIndex, (value) async {
      if (value == 0) {
        // reqMessage();
        reqMoney(false);
        checkPwdStatus();
      }
    });
  }

  bool isShowChangeLineDialog = false; //是有已经显示弹窗
  int getType(int bigType) {
    var type = bigType;
    switch (bigType) {
      case HomeGameCategory.CHESS:
        type = 17;
        break;
      case HomeGameCategory.ELECTRONIC:
        type = 12;
        break;
      case HomeGameCategory.FISHING:
        type = 13;
        break;
      case HomeGameCategory.LIVE:
        type = 11;
        break;
      case HomeGameCategory.SPORTS:
        type = 15;
        break;
      case HomeGameCategory.LOTTERY:
        type = 16;
        break;
    }
    return type;
  }

  reqBanner() async {
    mBannerList.value = await UserApi().reqBanner(isHome: true);
  }

  RxList<GamesTryBean> gameTryCategory = <GamesTryBean>[].obs; //试玩分类集合
  RxList<GamesTryItemBean> gameTryList = <GamesTryItemBean>[].obs; //单个分类的试玩集合
  List<GamesTryItemBean> oldGameTryList = <GamesTryItemBean>[]; //用于还原初始状态的集合

  //设置试玩数据
  void setGameTryData(HomeMainInfoBean homeMainInfoBean) {
    gameTryCategory.value = homeMainInfoBean.gamesTry ?? [];
    gameTryList.clear();
    for (var item in gameTryCategory) {
      if (item.subList != null && item.subList!.isNotEmpty) {
        gameTryList.addAll(item.subList!);
      }
    }
    oldGameTryList = gameTryList.value;
  }

  Future<void> loadHomeData(HomeMainInfoBean homeMainInfoBean) async {
    // Map<String, dynamic>? bannersInfo = homeMainInfoBean.banners;
    // if (bannersInfo != null && bannersInfo['data'] is List) {
    //   List<ActivityListItemBean> tempList = [];
    //   for (var item in bannersInfo['data']) {
    //     if (item['content1'] == '1') {
    //       tempList.add(ActivityListItemBean.fromJson(item));
    //     }
    //   }
    //   mBannerList.value = tempList;
    // }
    gameBeanItem.value = await HomeApi.reqNewHotGame();
    if (gameBeanItem.value != null) {
      //转换type
      gameBeanItem.value?.type =
          getType(gameBeanItem.value!.big_type?.toInt() ?? 0);
    }
    homeMainBean = homeMainInfoBean;
    var announcementList = homeMainBean!.news?.data ?? [];
    var marqueeList =
        announcementList.where((item) => item.message_id == 13).toList() ?? [];
    announcementList.removeWhere((item) => item.message_id == 13);
    var versionType = (homeMainBean!.version_type ?? [])
        .where((item) => HomeGameCategory.supportList.contains(item.type))
        .toList();
    // 存储信息
    TenantManager.instance.setVersionType(versionType);
    // 筛选出 type 在 supportList 中的对象
    homeCategoryList.value = [
      NewHomeGameTabBean(
          title: "推荐",
          iconPath: NewHomeUtils.getHomeTabIcon(
              tabList: homeTabList,
              bigType: HomeGameCategory.RECOMMEND_KEY,
              name: "推荐"),
          key: HomeGameCategory.RECOMMEND_KEY),
    ];
    // if (!LoginManager.instance.isLogin.value) {
    //   tabPageKeys.add(GlobalKey());
    //   homeCategoryList.add(NewHomeGameTabBean(
    //       title: "试玩",
    //       iconPath: NewHomeUtils.getHomeTabIcon(
    //           tabList: homeTabList,
    //           bigType: HomeGameCategory.GAME_TRY_KEY,
    //           name: "试玩"),
    //       key: HomeGameCategory.GAME_TRY_KEY));
    // }
    // 将 categoryList 中的对象添加到 homeCategoryList
    for (var category in versionType) {
      if (category.state == 1) {
        homeCategoryList.add(NewHomeGameTabBean(
          title: category.play_name!,
          pageKey: getPageKey(category.type!),
          key: category.type!,
          iconPath: NewHomeUtils.getHomeTabIcon(
              bigType: category.type!,
              tabList: homeTabList,
              name: category.play_name!),
        ));
      }
    }
    if (LoginManager.instance.isLogin.value) {
      homeCategoryList
          .removeWhere((item) => item.key == HomeGameCategory.GAME_TRY_KEY);
    }
    homeCategoryList.add(NewHomeGameTabBean(
        title: "收藏",
        iconPath: NewHomeUtils.getHomeTabIcon(
            bigType: HomeGameCategory.COLLECT_KEY,
            tabList: homeTabList,
            name: "收藏"),
        key: HomeGameCategory.COLLECT_KEY));
    homeCategoryList.add(NewHomeGameTabBean(
        title: "最近",
        iconPath: NewHomeUtils.getHomeTabIcon(
            bigType: HomeGameCategory.RECENT_KEY,
            tabList: homeTabList,
            name: "最近"),
        key: HomeGameCategory.RECENT_KEY));

    // tabController.value?.dispose();
    tabController.value =
        TabController(length: homeCategoryList.length, vsync: this);
    // scrollToTab(currentTabIndex.value);
    mMarqueeList.value = marqueeList;
    mAnnouncementList.value = announcementList;
    _checkAndShowPopup();
    //拿到集合的数据，拼接 title
    marqueeTitle.value = marqueeList
        .map((item) =>
            (parse(item.content).body?.text ?? "").replaceAll("\n", ""))
        .join(',');
    GameManager.instance.setGameState(homeMainBean!.gameState?.data ?? {});
    _buildMenuList(versionType);
    thirdGameList = homeMainBean!.thirdGames ?? [];
    _buildGameDataList(
      thirdGames: thirdGameList,
      hotGameBean: homeMainBean!.homeHotGames,
    );

    isRequestHomeData.value = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateHeight();
      isFirstLoadHomeFinish = true;
    });
  }

  void loadRankList() async {
    rankList.value = HomeRequestManager.to.rankList;
  }

  HomeMainInfoBean? homeMainBean;
  //请求首页数据，包含banner、公告、游戏
  Future<void> reqHomeData() async {
    isRequestHomeData.value = false;
    reqRankList();
    final res = await HomeApi.reqHomeData();
    if (res.type == NetworkService.networkTypeSuccess) {
      homeMainBean = HomeMainInfoBean.fromJson(res.data);
      if (homeMainBean != null) {
        SpUtil.saveBean<HomeMainInfoBean>(
            "homeBean", homeMainBean!); //只要请求了最新的，并且不为空，就覆盖
      }
      loadHomeData(homeMainBean!);
    }
  }

  Future<void> reqAseqInfo() async {
    final res = await TenantApi.reqAseq();
    if (res.type == NetworkService.networkTypeSuccess) {
      TenantManager.instance.setAseqBean(AseqBean.fromJson(res.data));

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      int localVersionSerial = int.tryParse(packageInfo.buildNumber) ?? 0;
      // print('本地版本号: $localVersionSerial');
      int remoteVersionSerial = ensureInt(res.data['version_serial']);
      // print('远端版本号: $remoteVersionSerial');
      if (remoteVersionSerial > localVersionSerial) {
        String title = res.data['version_digest'];
        String content = res.data['renewal_content'];
        bool force = res.data['is_mandatory_upate'] == 1;
        String url = '';
        if (Platform.isIOS) {
          url = res.data['ios_download_url'];
        } else if (Platform.isAndroid) {
          url = res.data['download_url'];
        }
        DialogManager.showDialogWithQueue(
          dialog: AppUpdateDialog(
            title: title,
            updateContent: content,
            forceUpdate: force,
            downloadUrl: url,
          ),
          barrierDismissible: false,
          priority: 5,
        );
      }
    }
  }

  // 获取账户余额
  Future<void> reqMoney(bool isLoading) async {
    if (isLoading) {
      EasyLoading.show(indicator: const CommonLoadingView());
    }
    if (TenantManager.instance.tenantBean != null &&
        LoginManager.instance.loginInfo != null) {
      await LoginManager.instance.reqMoney();
    }
    if (isLoading) {
      EasyLoading.dismiss();
    }
  }

  // void reqMessage() async {
  //   int unReadCount = 0; //未读数量
  //
  //   List<InboxMsgItemBean> inboxList = await UserApi().reqInboxMsg();
  //   unReadCount += inboxList
  //       .where((item) => item.type == 0 || item.type == 4)
  //       .toList()
  //       .length;
  //   MyMessageBean? messageBean = await UserApi().reqMyMsg();
  //   if (messageBean != null && messageBean.data != null) {
  //     List<MyMessageItemBean> myMsgList = messageBean.data!;
  //     unReadCount += myMsgList.where((item) => item.state != 9).length;
  //   }
  //   this.unReadCount.value = unReadCount;
  // }

  void checkPwdStatus() async {
    hasPwd = await UserApi().checkPwdStatus(2);
  }

  // 获取保险箱相关数据
  Future<void> loadYuebaoMoney() async {
    final response = await ActivityApi.reqSafeData();
    if (response.type == NetworkService.networkTypeSuccess) {
      var data = YueBaoSafeDataBean.fromJson(response.data);
      balanceTreasure.value =
          double.tryParse('${(data.balanceTreasure ?? 0) / 1000}') ?? 0;
    }
  }

//根据请求到的数据，构建游戏数据列表
  void _buildGameDataList({
    required List<ThirdGamesItem> thirdGames,
    HomeHotGameBean? hotGameBean,
  }) async {
    //如果有三方游戏列表 进行判断
    // 存在假PG的时候不显示真pg 假PG=1382,真PG=1380
    bool hasFakePG = false;
    if (thirdGames.isNotEmpty) {
      hasFakePG = thirdGames.any((game) => game.play_id == 1382);
    }

    /// 热门游戏数据处理
    hotGameList.value = HomeControllerDataProcess.getHomeGames(
      hasFakePG: hasFakePG,
      hotGameBean: hotGameBean,
    );
    oldHotGameList = hotGameList.value;

    ///  小类游戏数据处理
    if (hotGameBean != null) {
      // 热门电子
      // if (hotGameElectronic.value == null || hotGameElectronic.isEmpty) {
      hotGameElectronic.value = HomeControllerDataProcess.getGameElectronic(
        hotGameBean: hotGameBean,
        hasFakePG: hasFakePG,
      );
      // }
      // 捕鱼
      // if (hotGameFishing.value == null || hotGameFishing.isEmpty) {
      hotGameFishing.value = HomeControllerDataProcess.getGameFishing(
        hotGameBean: hotGameBean,
        hasFakePG: hasFakePG,
      );
      // }

      // if (hotGameChess.value == null || hotGameChess.isEmpty) {
      // 棋牌
      hotGameChess.value = HomeControllerDataProcess.getGameChess(
        hotGameBean: hotGameBean,
        hasFakePG: hasFakePG,
      );
      // }
      // if (hotGameBlockChain.value == null || hotGameBlockChain.isEmpty) {
      // 区块链
      hotGameBlockChain.value = HomeControllerDataProcess.getGameBlockChain(
        hotGameBean: hotGameBean,
        hasFakePG: hasFakePG,
      );
      // }
    }

    List<ThirdGamesItem> sportData = []; // 体育
    List<ThirdGamesItem> liveData = []; // 真人
    List<ThirdGamesItem> fishData = []; // 捕鱼
    List<ThirdGamesItem> electronicData = []; // 电子
    List<ThirdGamesItem> chessData = []; // 棋牌
    List<ThirdGamesItem> lotteryData = []; // 彩票
    List<ThirdGamesItem> blockchainData = []; // 区块链
    /// 热度排序
    // thirdGames.sort((a, b) => b.hot_val!.compareTo(a.hot_val!));

    /// 处理体育和真人游戏数据
    for (int i = 0; i < thirdGames.length; i++) {
      var item = thirdGames[i];
      // 体育
      if (item.big_type == 5) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        sportData.add(item);
      }

      // 彩票
      if (item.big_type!.toInt() == 7) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        lotteryData.add(item);
      }
      // 真人
      if (item.big_type == 4) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        liveData.add(item);
      }
      // 捕鱼
      if (item.big_type == 3) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        fishData.add(item);
      }

      // 电子
      if (item.big_type == 2) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        electronicData.add(item);
      }

      // 棋牌
      if (item.big_type == 1) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );

        chessData.add(item);
      }
      // 区块链
      if (item.big_type == 10) {
        item.gameImgUrl = GameUtils.getHotGameImageUrl(
          playName: item.play_name!,
          upperPlayId: item.play_id!,
          playId: item.play_id!,
          bigType: item.big_type!,
        );
        blockchainData.add(item);
      }
    }
    var tempBlockData = hotGameList
        .where((item) => item.big_type == HomeGameCategory.BLOCKCHAIN_KEY)
        .toList();
    tempBlockData.map((item) {
      return ThirdGamesItem();
    }).toList();

    sportData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    lotteryData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    liveData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    electronicData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    fishData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    chessData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    blockchainData.sort((a, b) {
      final aSort = a.play_sort ?? 0;
      final bSort = b.play_sort ?? 0;
      return aSort.compareTo(bSort);
    });
    gameSports.value = sportData;
    gameLottery.value = lotteryData;
    gameLive.value = liveData;
    gameElectronic.value = electronicData;
    gameFishing.value = fishData;
    gameChess.value = chessData;
    gameBlockchain.value = blockchainData;
  }

  //切换banner的index
  void changeBannerIndex(int index) {
    currentBannerIndex.value = index;
  }

  // 回收余额 然后 查询余额
  Future<void> retrieveAndCheckBalance(bool isLoading, String playIds) async {
    if (LoginManager.instance.loginInfo == null) {
      waittingForBalance = false;
      return;
    }
    if (isLoading) {
      EasyLoading.show(indicator: const CommonLoadingView());
    }

    final timeoutFuture = Future.delayed(const Duration(seconds: 5), () {
      return 'timeout';
    });
    final requestFuture = UserApi().findMoney2(playIds).then((_) {
      return 'completed';
    }).catchError((_) {
      return 'failed';
    });
    final result = await Future.any([timeoutFuture, requestFuture]);
    waittingForBalance = false;
    // print('等待余额回收结束: $result');

    LoginManager.instance.reqMoney();

    if (isLoading) {
      EasyLoading.dismiss();
    }
  }

  // 构建首页菜单
  void _buildMenuList(List<VersionTypeItem> versionType) async {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    versionType.sort((a, b) => b.sort_v!.compareTo(a.sort_v!));

    List<String> menuData = [];

    for (int i = 0; i < versionType.length; i++) {
      var item = versionType[i];
      if (HomeGameCategory.supportList.contains(item.type!.toInt())) {
        menuData.add(gameMenuSortMap[item.type!.toInt()] as String);
      }
    }

    // 设置菜单
    menuList.value = menuData;
  }

  void pushToActivity(String name) {
    var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
    tabsController.jumpToPage(isOpenVideo ? 3 : 2);
    final signInIndex = activityController.activityData.indexWhere(
      (activity) => activity.title == name,
    );
    Future.delayed(Duration(milliseconds: 100), () {
      activityController.jumpToPage(signInIndex);
    });
  }

  //切换二级tab的index
  void changeTabIndex(int index, {int? currentGameId}) {
    if (homeCategoryList[index].key == HomeGameCategory.GAME_TRY_KEY &&
        ThemeService.to.currentTheme.value?.model != 'blackGold') {
      //点击了试玩
      Get.toNamed(Routes.GAME_TRY);
      scrollToTab(currentTabIndex.value);
      return;
    }
    if ((homeCategoryList[index].key == HomeGameCategory.COLLECT_KEY ||
            homeCategoryList[index].key == HomeGameCategory.RECENT_KEY) &&
        !LoginManager.instance.isLogin.value) {
      //如果没登陆，不让跳转登录
      showLoginDialog();
      scrollToTab(currentTabIndex.value);
      return;
    }
    scrollTop();

    currentTabIndex.value = index;
    currentSelectTab = homeCategoryList[index];
    scrollToTab(index);
    Future.delayed(Duration(milliseconds: 300), () {
      //延迟赋值
      gameId.value = currentGameId ?? 0;
    });
    updateHeight();
  }

  //滚动到顶部
  void scrollTop() {
    scrollController.animateTo(0 + topHeight,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  void scrollToTab(int index) {
    var currentIndex = 0;
    if (currentSelectTab != null) {
      currentIndex = findTabIndex(currentSelectTab!.key);
      currentTabIndex.value = currentIndex;
      tabController.value?.index = currentIndex;
      tabController.value?.animateTo(currentIndex);
    } else {
      tabController.value?.animateTo(index);
    }
    pageController.jumpToPage(currentIndex);
  }

  int findTabIndex(int tabKey) {
    return homeCategoryList.indexWhere((item) => item.key == tabKey);
  }

  void handleNavigation(int index) {
    var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
    switch (index) {
      case 0:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        Get.toNamed(Routes.BET);
        break;
      case 1:
        pushToActivity('任务');
        break;
      case 2:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        Get.toNamed(Routes.BOUNS_CENTER);
        break;
      case 3:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        pushToActivity('返水');
        break;
      case 4:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        Get.toNamed(Routes.FIND_BALANCE);
        break;
      case 5:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        Get.toNamed(Routes.MESSAGE_NOTIFY);
        break;
      case 6:
        if (!LoginManager.instance.isLogin.value) {
          showLoginDialog(callback: () {});
          return;
        }
        // 推广赚钱 到 代理中心
        Get.toNamed(Routes.AGENT_CENTER);
        break;
      case 7:
        Get.toNamed(Routes.ALTERNATE_URLS);
        break;
      default:
        print("未定义的索引：$index");
    }
  }

  // 刷新
  Future<void> refreshData() async {
    reqHomeData();
    reqMoney(true);
    // reqMessage();
  }

  void reqRankList() async {
    HomeRequestManager.to.reqRankList();
    rankList.value = HomeRequestManager.to.rankList;
  }

  Future<void> _checkAndShowPopup() async {
    if (mAnnouncementList.isNotEmpty && !announcementShowed) {
      //公告不为空才需要弹窗
      announcementShowed = true;
      List<AnnouncementBean> tempList = [];
      for (var item in mAnnouncementList) {
        if ((item.content ?? "").isImageUrl()) {
          CachedNetworkImageProvider imageProvider =
              CachedNetworkImageProvider(item.content ?? "");
          await precacheImage(imageProvider, Get.context!);
          tempList.add(AnnouncementBean(imageProvider: imageProvider));
        } else {
          tempList.add(AnnouncementBean(html: (item.content ?? "")));
        }
      }
      DialogManager.showDialogWithQueue(
        dialog: SystemAnnouncementDialog(
          title: "公告",
          sAnnouncementList: mAnnouncementList,
          announcementList: tempList,
        ),
        priority: 3,
      );
    }
  }

  /*
  * collectStatus：收藏状态
  * playCat：play_cat
  * type：type
  * playId：play_id
  * */
  void collectGame({required GameBeanItem gameIem}) async {
    if (!LoginManager.instance.isLogin.value) {
      EasyLoading.showToast('请登录账号！');
      return; //没有登录不执行
    }

    // 未请求完时防重复点击
    if (isClickCollect.value == true) {
      print('====> Repeat Click');
      return;
    }

    isClickCollect.value = true;

    final res = await HomeApi.reqCollectGame(
      playId: gameIem.play_id,
      type: gameIem.type,
      playCat: gameIem.play_cat,
      status: gameIem.play_collection,
      msg: jsonEncode(gameIem),
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      await reqHomeData();
      EasyLoading.showToast(gameIem.play_collection == 1 ? '收藏成功' : '取消收藏成功');
    }

    isClickCollect.value = false;
  }

  //打开试玩游戏
  Future<void> openGameTry(dynamic gameItem) async {
    EasyLoading.show(
      indicator: const CommonLoadingView(),
    );

    /// 检测3方游戏
    final res = await HomeApi.checking3Game(gameItem.play_id!.toInt());

    if (res.type == NetworkService.networkTypeSuccess &&
        res.data['response_code'] == '9999') {
      var payload = HomeControllerDataProcess.getPayload(
        playId: gameItem.play_id!.toInt(),
        playName: gameItem.play_name ?? '',
        gameType: gameItem.big_type,
        upperPlayId: gameItem is GameBeanItem
            ? gameItem?.upper_play_id?.toInt()
            : gameItem?.upper_id?.toInt(),
        gtype: GameUtils.determineTypeConst2(gameItem.play_id!.toInt()),
      );

      payload['isMobileOpen'] = 1;
      payload['isMobileOpenNew'] = 1;

      final result = await HomeApi.reqTryGameUrl(payload);
      if (result.type == NetworkService.networkTypeSuccess) {
        String? url = result.data['url'];

        // debugPrint('第三方游戏URL: ${url}');
        if (url?.isNotEmpty ?? false) {
          String? linkUrl =
              url!.contains('https:') ? url : url.replaceAll('http:', 'https:');
          NativeWebView.open(
            linkUrl,
            gameItem.play_cname ?? '',
          );
          isGameTry = true;
        } else {
          EasyLoading.showToast('未获取到三方平台地址');
        }
      } else {
        EasyLoading.showToast('${result.data}');
      }
    }

    EasyLoading.dismiss();
  }

  // 打开热门游戏
  void openHotGame(GameBeanItem hotGameItem) {
    // 打开游戏
    openGame(
      hotGameItem,
      playId: hotGameItem.play_id!,
      playName: hotGameItem.play_name ?? "",
      playCName: hotGameItem.play_cname!,
      gameType: hotGameItem.big_type,
      originState: hotGameItem.state?.toInt() ?? 1,
      upperPlayId: hotGameItem.upper_play_id?.toInt(),
      gtype: hotGameItem.gtype,
    );
  }

  var tempPlayId;
  // 打开游戏
  Future<void> openGame(
    dynamic gameItem, {
    required int playId,
    required String playName,
    required String playCName,
    num? gameType,
    required int originState,
    int? upperPlayId,
    String? gtype,
  }) async {
    // print(
    //     '打开游戏 playCName:${playCName}, playId:${playId}, upperPlayId:${upperPlayId}, gameType:${gameType}, gtype: ${gtype}, gameItem: ${gameItem}');
    if (waittingForBalance) {
      EasyLoading.showToast('等待余额回收');
      return;
    }
    RecentGamesUtil.saveGameId(playId); //保存点击了的游戏到最近游戏集合
    if (!LoginManager.instance.isLogin.value) {
      //没有登录才执行这里的逻辑
      bool isCanTry = await checkGameTryStatus(playId); //是否支持试玩
      if (isCanTry) {
        Get.dialog(GameTryTipsDialog(
          clickTry: () {
            // print("输出游戏数据:${gameItem.toString()}");
            if (gameItem is ThirdGamesItem) {
              openGameTry(gameItem);
            } else {
              openGameTry(gameItem);
            }
          },
          clickLogin: () {
            showLoginDialog();
          },
        ));
        return;
      }
    }
    // 暂时不考虑彩票逻辑
    if (gameType == HomeGameCategory.LOTTERY) {
      openLotteryGame(ThirdGamesItem(play_id: playId, play_cname: playCName));
      return;
    }

    // 验证通过
    if (commonGameValid(gameItem, playId: playId, originState: originState)) {
      /// 真人
      if (gameType == GameTypeConstants.live) {
        try {
          final liveRes = await HomeApi.checking3GameLimited(playId);

          // 个人余额
          double blance = 100;
          double minLimit = liveRes.data['deposit_min_money'] ?? 0;
          if (blance < minLimit) {
            EasyLoading.showToast('余额低于$minLimit，暂时无法游戏');
            return;
          }
        } catch (err) {
          isClickOpenGame.value = false;
        }
      }

      isClickOpenGame.value = true;
      EasyLoading.show(
        indicator: const CommonLoadingView(),
      );

      try {
        /// 检测3方游戏
        NetworkResponse res = await HomeApi.checking3Game(playId);

        if (res.type == NetworkService.networkTypeSuccess &&
            res.data['response_code'] == '9999') {
          var payload = HomeControllerDataProcess.getPayload(
            playId: playId,
            playName: playName,
            gameType: gameType,
            upperPlayId: upperPlayId,
            gtype: gtype,
          );
          var tempUpperPlayId = (upperPlayId ?? 0);
          String params = jsonEncode({
            'big_type': (gameItem is RealTimePrizesItemBean)
                ? gameItem.bigType
                : (gameItem?.big_type ?? gameItem?.type),
            'play_id': playId,
            'upper_id': tempUpperPlayId == 0 ? playId : tempUpperPlayId,
            'main_id': tempUpperPlayId == 0 ? playId : tempUpperPlayId,
            'play_cat': (gameItem is RealTimePrizesItemBean)
                ? gameItem.bigType
                : gameItem.play_cat,
            'play_name': playName,
          });
          payload['isMobileOpen'] = 1;
          payload['isMobileOpenNew'] = 1;

          final result = await HomeApi.req3GameUrl(payload, params);
          if (result.type == NetworkService.networkTypeSuccess) {
            String? url = result.data['url'];

            // debugPrint('第三方游戏URL: ${url}');
            if (url?.isNotEmpty ?? false) {
              String? linkUrl = url!.contains('https:')
                  ? url
                  : url.replaceAll('http:', 'https:');
              tempPlayId = upperPlayId ?? playId;
              // 路由跳转
              NativeWebView.open(linkUrl, playCName);
            } else {
              EasyLoading.showToast('未获取到三方平台地址');
            }
          } else {
            EasyLoading.showToast('${result.data ?? "服务器繁忙，请稍后重试"}');
          }
        } else {
          EasyLoading.showToast("服务器繁忙，请稍后重试");
        }
      } finally {
        EasyLoading.dismiss();
        isClickOpenGame.value = false;
      }
      recentGameList = await RecentGamesUtil.getRecentGameIds();
    }
  }

  // 打开彩票游戏
  Future<void> openLotteryGame(ThirdGamesItem gameItem) async {
    if (commonGameValid(gameItem, playId: gameItem.play_id!, originState: 0)) {
      isClickOpenGame.value = true;
      EasyLoading.show(
        indicator: const CommonLoadingView(),
      );
      RecentGamesUtil.saveGameId(gameItem.play_id!); //保存点击了的游戏到最近游戏集合
      /// 检测3方游戏
      NetworkResponse res = await HomeApi.checking3Game(gameItem.play_id ?? 0);
      if (res.type == NetworkService.networkTypeSuccess &&
          res.data['response_code'] == '9999') {
        var payload = HomeControllerDataProcess.getPayload(
          playId: gameItem.play_id ?? 0,
          playName: "",
          gameType: gameItem.big_type,
        );

        payload['isMobileOpen'] = 1;
        payload['isMobileOpenNew'] = 1;
        // 天成彩票 添加参数type = 'Lobby'
        if (payload['play_id'] == 468) {
          payload['type'] = 'Lobby';
        }
        var tempUpperPlayId = (gameItem.upper_id ?? 0);
        var params = jsonEncode({
          'big_type': gameItem.big_type,
          'play_id': gameItem.play_id,
          'upper_id': tempUpperPlayId == 0 ? gameItem.play_id : tempUpperPlayId,
          'main_id': tempUpperPlayId == 0 ? gameItem.play_id : tempUpperPlayId,
          'play_cat': gameItem.play_cat,
          'play_name': gameItem.play_name,
        });
        final result = await HomeApi.req3GameUrl(payload, params);
        if (result.type == NetworkService.networkTypeSuccess) {
          String? url = result.data['url'];
          if (url != null) {
            String linkUrl = url.contains('https:')
                ? url
                : url.replaceAll('http:', 'https:');
            // 路由跳转
            NativeWebView.open(linkUrl, gameItem.play_cname ?? '');
          }
        } else {
          EasyLoading.showToast('${result.data}');
        }
      }
      isClickOpenGame.value = false;
      EasyLoading.dismiss();
      recentGameList = await RecentGamesUtil.getRecentGameIds();
    }
  }

  //检测游戏试玩状态
  Future<bool> checkGameTryStatus(int playId) async {
    final gameTryList = homeMainBean?.gamesTry ?? [];
    for (final item in gameTryList) {
      final subList = item.subList ?? [];
      if (subList.any((e) => e.play_id == playId)) {
        return true;
      }
    }

    return false;
  }

  // 共用游戏前置验证
  bool commonGameValid(
    dynamic gameItem, {
    required int playId,
    required int originState,
  }) {
    // 未登录
    if (!LoginManager.instance.isLogin.value) {
      showLoginDialog();
      EasyLoading.showToast('亲，请先登录哦');
      return false;
    }

    // 防重复点击
    if (isClickOpenGame.value) {
      EasyLoading.showToast('操作过于频繁');
      return false;
    }

    // 试玩账号
    if (LoginManager.instance.isFreeUser.value) {
      EasyLoading.showToast('试玩账号不能进入该游戏、请注册正式会员');
      return false;
    }

    // 无彩种信息
    if (gameItem == null) {
      EasyLoading.showToast('彩种信息缺失');
      return false;
    }

    // 1 正常销售2 暂停销售3 停止销售4 内部测试5 归档，前端只处理1、2、4
    if (originState == 2) {
      EasyLoading.showToast('暂停销售');
      return false;
    }

    if (originState == 4) {
      EasyLoading.showToast('该游戏为内部测试');
      return false;
    }

    // 判断游戏状态
    var gameState = GameManager.instance.gameState;
    int? state = gameState[playId];
    if (state != null) {
      if (state == 2) {
        EasyLoading.showToast('暂停销售');
        return false;
      }

      if (state == 3) {
        EasyLoading.showToast('停止销售');
        return false;
      }
    }

    return true;
  }

  // 三方数据打开游戏
  void openThirdGame(ThirdGamesItem gameItem) {
    int playId = gameItem.play_id!.toInt();
    // 打开游戏
    openGame(
      gameItem,
      playId: playId,
      playName: gameItem.play_name!,
      playCName: gameItem.play_cname!,
      gameType: gameItem.big_type,
      originState: gameItem.state!.toInt(),
    );
  }

  // 收藏打开游戏
  void openCollectGame(HomeCollectionListItemBean gameItem) {
    int bigType = gameItem.play_big_type!;
    String gameType = '';
    String playId = gameItem.play_id!.toString();

    // 判断大类是否有值
    if (bigType == 11) {
      // 真人
      gameType = GameTypeConstants.live;
    } else if (bigType == 12) {
      // 电子
      gameType = GameTypeConstants.electronic;
    } else if (bigType == 13) {
      // 捕鱼
      gameType = GameTypeConstants.fishing;
    } else if (bigType == 17) {
      // 棋牌
      gameType = GameTypeConstants.chess;
    } else if (bigType == 15) {
      // 体育
      gameType = GameTypeConstants.sports;
    } else if (bigType == 16) {
      // 彩票
      gameType = GameTypeConstants.lottery;
    }

    // playId = playId.length >= 6 ? playId.substring(0, 3) : playId;
    gameType = GameUtils.determineTypeConst(gameItem.upper_play_id != null
        ? gameItem.upper_play_id!.toInt()
        : gameItem.play_id!);
    openGame(
      gameItem,
      playId: gameType == 'fishing'
          ? int.parse(gameItem.play_id.toString())
          : int.parse(playId),
      playName: gameItem.playName ?? "",
      playCName: gameItem.playCname!,
      gameType: gameItem.play_big_type,
      originState: gameItem.play_state?.toInt() ?? 1,
      upperPlayId: gameItem.upper_play_id,
      gtype: gameItem.gtype,
    );
  }

  // 点击游戏或者场馆图
  void handleGameBanner({
    required String gameType,
    required int index,
    int? playId,
  }) async {
    // 场馆集合
    List<String> openGameList = [
      GameTypeConstants.live,
      GameTypeConstants.sports
    ];
    List<String> jumpDetailList = [
      GameTypeConstants.chess,
      GameTypeConstants.electronic,
      GameTypeConstants.fishing,
      GameTypeConstants.blockchain,
    ];

    var gameDataMap = {
      GameTypeConstants.live: gameLive,
      GameTypeConstants.sports: gameSports,
      GameTypeConstants.chess: gameChess,
      GameTypeConstants.electronic: gameElectronic,
      GameTypeConstants.fishing: gameFishing,
      GameTypeConstants.blockchain: gameBlockchain,
    };

    var gameData = gameDataMap[gameType];
    if (gameData == null) {
      return;
    }
    var currentIndex = gameData.indexWhere((item) => item.play_id == playId);
    var gameItem = gameData[currentIndex];
    // 需要打开游戏
    if (openGameList.contains(gameType)) {
      openThirdGame(gameItem);
    }

    // 需要跳转详情
    if (jumpDetailList.contains(gameType)) {
      changeTabIndex(
        findIndexByEName(gameType),
        currentGameId: gameData[currentIndex].play_id!.toInt(),
      );
    }
  }

  int findIndexByEName(String pageKey) {
    return homeCategoryList
        .indexWhere((NewHomeGameTabBean element) => element.pageKey == pageKey);
  }

  RxDouble pageViewHeight = 860.h.obs;
  late List<GlobalKey> tabPageKeys;

  initTabKey() async {
    tabPageKeys = [
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
      GlobalKey(),
    ];
    await reqAseqInfo();
    homeTabList = await HomeApi.reqHomeTab() ?? [];
  }

  List<HomeTabData> homeTabList = [];
  // 更新高度
  void updateHeight() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = tabPageKeys[currentTabIndex.value].currentContext;
      if (context != null) {
        final newHeight = context.size?.height ?? 800.h;
        pageViewHeight.value = newHeight;
      }
    });
    update();
  }

  // 点击全部
  void clickAll(String pageKey) {
    changeTabIndex(findIndexByEName(pageKey));
  }

  void toggleMenu() {
    if (animationController.status == AnimationStatus.completed) {
      animationController.reverse().then((_) {
        displayMenu.value = false;
      });
    } else if (animationController.status == AnimationStatus.dismissed) {
      displayMenu.value = true;
      animationController.forward();
      loadYuebaoMoney();
    }
  }

  void addGameRecord(HomeCollectionListItemBean newItem) async {
    // 先检查 gameRecords 中是否已经存在相同的 play_id
    int index =
        gameRecords.indexWhere((item) => item.play_id == newItem.play_id);
    if (index != -1) {
      gameRecords.removeAt(index);
      gameRecords.insert(0, newItem);
      gameRecords.refresh();
    } else {
      gameRecords.insert(0, newItem);
    }
    saveGameRecords();
  }

  void updateGameRecord(int playId, num? collectionId) {
    int index = gameRecords.indexWhere((item) => item.play_id == playId);
    if (index != -1) {
      HomeCollectionListItemBean item = gameRecords[index];
      item.collectionId = collectionId;
      saveGameRecords();
    }
  }

  Future<void> saveGameRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 将对象列表转换为 JSON 字符串
    List<Map<String, dynamic>> jsonList =
        gameRecords.map((item) => item.toJson()).toList();
    // print({'jsonList ===========${jsonList}'});
    String jsonString = jsonEncode(jsonList);
    // 保存 JSON 字符串到 SharedPreferences
    await prefs.setString('gameRecords', jsonString);
  }

  Future<void> loadGameRecords() async {
    // gameRecords.value = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 从 SharedPreferences 中获取 JSON 字符串
    String? jsonString = prefs.getString('gameRecords');
    if (jsonString != null) {
      // 将 JSON 字符串解析为对象列表
      List<dynamic> jsonList = jsonDecode(jsonString);
      gameRecords.value = jsonList
          .map((item) => HomeCollectionListItemBean.fromJson(item))
          .toList();
    }
    recentGameList = await RecentGamesUtil.getRecentGameIds();
  }

  void loadHomeFloatIcon() async {
    Map<String, String> settings = await HomeApi.reqHomeFloatIcon();
    homeFloatIconPath.value = settings['img'] ?? ""; //请求首页百万福利活动图片
    homeFloatIconName.value = settings['name'] ?? ""; //请求首页百万福利活动图片
  }

  String? switchGameType(num? bigType) {
    String? type;
    switch (bigType) {
      case HomeGameCategory.CHESS:
        type = GameTypeConstants.chess;
        break;
      case HomeGameCategory.ELECTRONIC:
        type = GameTypeConstants.electronic;
        break;
      case HomeGameCategory.FISHING:
        type = GameTypeConstants.fishing;
        break;
      case HomeGameCategory.LIVE:
        type = GameTypeConstants.live;
        break;
      case HomeGameCategory.SPORTS:
        type = GameTypeConstants.sports;
        break;
      case HomeGameCategory.LOTTERY:
        type = GameTypeConstants.lottery;
        break;
      case HomeGameCategory.BLOCK_THIRD:
        type = GameTypeConstants.blockchain;
        break;
      default:
        type = null;
        break;
    }
    return type;
  }

  RxList<RealTimePrizesItemBean> realTimePrizesList =
      <RealTimePrizesItemBean>[].obs;
  void reqRealTimePrizes() async {
    realTimePrizesList.value = await HomeApi.reqRealTimePrizesData() ?? [];
  }
}
