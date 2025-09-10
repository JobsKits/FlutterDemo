import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/data/home_game_tab_bean.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/home_view_const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/public_util.dart';
import '../../../../utils/CommonRipple.dart';
import '../controllers/new_home_controller.detail.dart';
import '../widget/new_home_game_second_list_widget.dart';
import '../widget/new_home_game_second_list_widget2.dart';

class NewHomeViewDetail extends StatefulWidget {
  NewHomeViewDetail({
    super.key,
    required this.pageKey,
    required this.globalKey,
  });

  // 存储传递的 pageKey
  final HomePageDetailEnum pageKey;
  GlobalKey globalKey;

  @override
  State<NewHomeViewDetail> createState() => _NewHomeViewDetailState();
}

class _NewHomeViewDetailState extends State<NewHomeViewDetail> {
  NewHomeController homeController = Get.find();
  late NewHomeControllerDetail controller = Get.put(NewHomeControllerDetail());
  @override
  Widget build(BuildContext context) {
    // 检查控制器是否已经注册，如果没有注册过，则注册
    // if (!Get.isRegistered<NewHomeControllerDetail>(tag: '${widget.pageKey}')) {
    //   controller = Get.put(NewHomeControllerDetail(),
    //       tag: '${widget.pageKey}'); // 只在第一次使用时注册
    // } else {
    //   controller = Get.find(tag: '${widget.pageKey}');
    // }
    // print("这里会执行多少次：build");

    controller.pageKey.value = widget.pageKey; // 更新响应式变量
    return _buildBody();
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          key: widget.globalKey,
          padding: EdgeInsets.zero,
          child: test(),
        ));
  }

  Widget test() {
    if (widget.pageKey == HomePageDetailEnum.live ||
        widget.pageKey == HomePageDetailEnum.sports) {
      bool isLive = widget.pageKey == HomePageDetailEnum.live;
      return Obx(() => _buildPageView1(
            gameList: isLive
                ? controller.homeController.gameLive
                : controller.homeController.gameSports,
          ));
    }

    // 彩票
    if (widget.pageKey == HomePageDetailEnum.lottery) {
      return Obx(() => _buildPageView5(
            gameList: controller.homeController.gameLottery,
          ));
    }

    // 电子
    if (widget.pageKey == HomePageDetailEnum.electronic) {
      return _buildPageView2(
        tabController: controller.electronicTabController,
        tabList: controller.electronicTabList,
        tabIndex: controller.currentElectronicTabIndex,
        gameDataMap: controller.electronicData,
      );
    }
    // 区块链
    if (widget.pageKey == HomePageDetailEnum.blockChain) {
      return _buildPageView2(
        tabController: controller.blockChainTabController,
        tabList: controller.blockChainTabList,
        tabIndex: controller.currentBlockChainTabIndex,
        gameDataMap: controller.blockChainData,
      );
    }
    // 棋牌
    if (widget.pageKey == HomePageDetailEnum.chess) {
      return _buildPageView2(
        tabController: controller.chessTabController,
        tabList: controller.chessTabList,
        tabIndex: controller.currentChessTabIndex,
        gameDataMap: controller.chessData,
      );
    }

    // 捕鱼
    if (widget.pageKey == HomePageDetailEnum.fishing) {
      return _buildPageView2(
        tabController: controller.fishTabController,
        tabList: controller.fishTabList,
        tabIndex: controller.currentFishTabIndex,
        gameDataMap: controller.fishData,
      );
    }

    // 收藏
    if (widget.pageKey == HomePageDetailEnum.collect) {
      return Obx(() {
        if (controller.collectionList.isEmpty) {
          return buildEmptyView();
        }

        return _buildPageView4(
          isRecord: false,
          gameList: controller.collectionList,
        );
      });
    }

    // 最近
    if (widget.pageKey == HomePageDetailEnum.recent) {
      return Obx(() {
        if (homeController.gameRecords.isEmpty) {
          return buildEmptyView();
        }
        return _buildPageView4(
          isRecord: true,
          gameList: homeController.gameRecords,
        );
      });
    }
    // 返回空视图
    return buildEmptyView();
  }

  /// 构建TabBar
  Widget _buildTabBar({
    required TabController tabController,
    required List<NewHomeGameDetailTabBean> tabList,
    required RxInt tabIndex,
  }) {
    return Container(
      height: 180.h,
      color: Colors.white,
      padding: EdgeInsets.only(left: 10.w),
      child: Row(
        children: [
          Expanded(
              child: TabBar(
            onTap: (index) {
              if (tabIndex.value != index) {
                AppManager.instance.tapVibrate();
              }
              tabIndex.value = index;
              controller.changeThirdTabIndex(0);
              controller.homeController.updateHeight();
            },
            tabAlignment: TabAlignment.start,
            indicatorPadding: EdgeInsets.zero, // 去除指示器的边距
            labelPadding: EdgeInsets.symmetric(horizontal: 10.w),
            padding: EdgeInsets.zero, // 去除整体的边距
            controller: tabController,
            isScrollable: true,
            dividerHeight: 0,
            indicator: const BoxDecoration(color: Colors.transparent),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.red,
            tabs: List.generate(tabList.length, (index) {
              return Obx(() {
                var iconPath = tabList[index].iconPath;
                var isNetImg = iconPath.contains("http");
                return Container(
                  decoration: tabIndex.value == index
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r), // 圆角
                          color: const Color(0xFF10C8E3), // 指示器颜色
                        )
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r), // 圆角
                          color: const Color(0xFFF6F6F7),
                        ),
                  constraints: BoxConstraints(
                    minWidth: 190.w,
                  ),
                  height: 96.h,
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isNetImg
                          ? Image.network(
                              iconPath,
                              height: 50.h,
                            )
                          : Image.asset(
                              iconPath,
                              height: 50.h,
                            ),
                      // SvgPicture.asset(tabList[index].iconPath,
                      //     width: 52.w, height: 52.h),
                      SizedBox(
                        width: 10.w,
                      ),
                      Text(
                        tabList[index].title,
                        style: TextStyle(
                          color: tabIndex.value == index
                              ? Colors.white
                              : Colors.grey,
                          fontSize: 36.sp,
                        ),
                      )
                    ],
                  ),
                );
              });
            }),
          )),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              _showPlatformSelectView(tabIndex: tabIndex, tabList: tabList);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30.w,
              ),
              child: SvgPicture.asset(
                Assets.theme1.images.home.iconTabMenu,
                width: 58.w,
                height: 58.h,
              ),
            ),
          )
        ],
      ),
    );
  }

  //体育、真人
  Widget _buildPageView1({
    required RxList<ThirdGamesItem> gameList,
  }) {
    List<ThirdGamesItem> tempData = [];
    switch (controller.thirdTabIndex.value) {
      case 1: //热门
        tempData =
            gameList.where((game) => (game.play_is_hot ?? 0) == 1).toList();
        tempData.sort(
            (a, b) => (a.hot_play_sort ?? 0).compareTo(b.hot_play_sort ?? 0));
        if (controller.searchName.value.isNotEmpty) {
          tempData = tempData
              .where((element) =>
                  element.play_cname!.contains(controller.searchName.value))
              .toList();
        }
        break;
      case 2: //最新
        tempData = gameList
            .where((element1) => controller.homeController.recentGameList
                .any((id) => element1.play_id == id))
            .toSet()
            .toList();
        if (controller.searchName.value.isNotEmpty) {
          tempData = tempData
              .where((element) =>
                  element.play_cname!.contains(controller.searchName.value))
              .toList();
        }
        break;
      case 3: //收藏
        tempData =
            gameList.where((game) => (game.play_collection ?? 0) == 2).toList();
        if (controller.searchName.value.isNotEmpty) {
          tempData = tempData
              .where((element) =>
                  element.play_cname!.contains(controller.searchName.value))
              .toList();
        }
        break;
      default:
        tempData = gameList
            .where((element) =>
                element.play_cname!.contains(controller.searchName.value))
            .toList();
        break;
    }
    return Column(
      children: [
        _buildSearchView(),
        Padding(
          padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
          child: NewHomeGameSecondListWidget1(
            tag: widget.pageKey,
            dataList1: tempData,
            gameType: GameTypeEnum.gameType1,
            thirdTabIndex: controller.thirdTabIndex.value,
            imageType: AssetsTypeEnum.local,
            clickCollect: (index) {
              // controller.collectGameAndVenues(index: index);
              controller.collectGameAndVenues(
                  index: index, playIds: tempData[index].play_id!.toInt());
            },
            clickItem: (index) {
              var gameItem = tempData[index];
              controller.homeController.openThirdGame(gameItem);

              homeController.addGameRecord(HomeCollectionListItemBean(
                collectionId: gameItem.play_collection == 2
                    ? gameItem.play_id?.toInt()
                    : null,
                play_id: gameItem.play_id?.toInt(),
                upper_play_id: gameItem.upper_id?.toInt(),
                big_type: gameItem.big_type?.toInt(),
                playName: gameItem.play_name,
                playCname: gameItem.play_cname,
                play_cat: gameItem.play_cat?.toInt(),
                play_state: gameItem.state?.toInt(),
                play_big_type: gameItem.big_type?.toInt(),
                gameImgUrl: gameItem.thumbnail_img_url ?? gameItem.gameImgUrl,
                gtype: gameItem.gtype,
                isRecord: false,
              ));
            },
          ),
        )
      ],
    );
  }

  Widget _buildPageView2(
      {required TabController tabController,
      required List<NewHomeGameDetailTabBean> tabList,
      required RxInt tabIndex,
      required RxMap<int, List<GameBeanItem>> gameDataMap}) {
    return Obx(() {
      var currentTabItem = tabList[tabIndex.toInt()];
      var gameData = gameDataMap[currentTabItem.playId.toInt()] ?? [];
      bool isHotTab = false;
      switch (widget.pageKey) {
        case HomePageDetailEnum.electronic:
          isHotTab = controller
                  .electronicTabList[
                      controller.currentElectronicTabIndex.value]!
                  .playId ==
              -1;
          break;
        case HomePageDetailEnum.chess:
          isHotTab = controller
                  .chessTabList[controller.currentChessTabIndex.value]!
                  .playId ==
              -1;
          break;
        case HomePageDetailEnum.fishing:
          isHotTab = controller
                  .fishTabList[controller.currentFishTabIndex.value]!.playId! ==
              -1;
          break;
        case HomePageDetailEnum.blockChain:
          isHotTab = controller
                  .blockChainTabList[
                      controller.currentBlockChainTabIndex.value]!
                  .playId ==
              -1;
          break;
        default:
          isHotTab = false;
          break;
      }

      return Column(
        children: [
          _buildTabBar(
            tabController: tabController,
            tabList: tabList,
            tabIndex: tabIndex,
          ),
          _buildSearchView(isHotTab: isHotTab, isShowRecent: true),
          Container(
            padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
            child: Obx(() {
              List<GameBeanItem> tempData = [];
              switch (controller.thirdTabIndex.value) {
                case 1: //热门
                  if (isHotTab) {
                    tempData = gameData
                        .where((element1) => controller
                            .homeController.recentGameList
                            .any((id) => element1.play_id == id))
                        .toSet()
                        .toList();
                    tempData.sort((a, b) =>
                        (a.hot_play_sort ?? 0).compareTo(b.hot_play_sort ?? 0));
                  } else {
                    tempData = gameData
                        .where((game) => (game.play_is_hot ?? 0) == 1)
                        .toList();
                    tempData.sort((a, b) =>
                        (a.hot_play_sort ?? 0).compareTo(b.hot_play_sort ?? 0));
                  }
                  if (controller.searchName.value.isNotEmpty) {
                    tempData = tempData
                        .where((element) => element.play_cname!
                            .contains(controller.searchName.value))
                        .toList();
                  }
                  break;
                case 2: //最新
                  if (isHotTab) {
                    tempData = gameData
                        .where((game) => (game.play_collection ?? 0) == 2)
                        .toList();
                  } else {
                    tempData = gameData
                        .where((element1) => controller
                            .homeController.recentGameList
                            .any((id) => element1.play_id == id))
                        .toSet()
                        .toList();
                  }
                  if (controller.searchName.value.isNotEmpty) {
                    tempData = tempData
                        .where((element) => element.play_cname!
                            .contains(controller.searchName.value))
                        .toList();
                  }
                  break;
                case 3: //收藏
                  tempData = gameData
                      .where((game) => (game.play_collection ?? 0) == 2)
                      .toList();
                  if (controller.searchName.value.isNotEmpty) {
                    tempData = tempData
                        .where((element) => element.play_cname!
                            .contains(controller.searchName.value))
                        .toList();
                  }
                  break;
                default:
                  tempData = gameData
                      .where((element) => element.play_cname!
                          .contains(controller.searchName.value))
                      .toList();
                  break;
              }
              return NewHomeGameSecondListWidget1(
                  dataList2: tempData,
                  tag: widget.pageKey,
                  tabIndex: tabIndex.value,
                  thirdTabIndex: controller.thirdTabIndex.value,
                  gameType: GameTypeEnum.gameType2,
                  imageType: AssetsTypeEnum.netWork,
                  clickCollect: (index) {
                    controller.collectGameAndVenues(
                        index: index, playIds: tempData[index].play_id);
                  },
                  clickItem: (index) {
                    var gameItem = tempData[index];
                    controller.homeController.openHotGame(gameItem);
                    homeController.addGameRecord(HomeCollectionListItemBean(
                      collectionId: gameItem.play_collection == 2
                          ? gameItem.play_id?.toInt()
                          : null,
                      play_id: gameItem.play_id?.toInt(),
                      upper_play_id: gameItem.upper_play_id?.toInt(),
                      big_type: gameItem.big_type?.toInt(),
                      playName: gameItem.play_name,
                      playCname: gameItem.play_cname,
                      play_cat: gameItem.play_cat?.toInt(),
                      play_state: gameItem.state?.toInt(),
                      // play_big_type: controller.pageKey.value.index - 1,
                      play_big_type: gameItem.big_type?.toInt(),
                      gameImgUrl:
                          gameItem.thumbnail_img_url ?? gameItem.gameImgUrl,
                      gtype: gameItem.gtype,
                      isRecord: false,
                    ));
                  });
            }),
            //   !controller.isSubPageLoading.value &&
            //           gameData.isEmpty //加载中，并且本身没有数据，才显示
            //       ? SizedBox(
            //           height: 400.h,
            //           child: Center(
            //             child: SizedBox(
            //               width: 100.w,
            //               height: 100.h,
            //               child: const LoadingIndicator(
            //                 indicatorType: Indicator.ballSpinFadeLoader,
            //                 colors: [Color(theme01MainColor)],
            //               ),
            //             ),
            //           ),
            //         )
            //       : const SizedBox()
            // ],
            // ),
          )
        ],
      );
    });
  }

  // 构建收藏视图
  Widget _buildPageView4({
    required bool isRecord,
    required List<HomeCollectionListItemBean> gameList,
  }) {
    return Padding(
        padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
        child: NewHomeGameSecondListWidget1(
          dataList4: gameList,
          tag: widget.pageKey,
          gameType: GameTypeEnum.gameType4,
          thirdTabIndex: controller.thirdTabIndex.value,
          imageType: AssetsTypeEnum.local,
          isRecord: isRecord,
          clickCollect: (index) {
            controller.collectGameAndVenues(
                index: index, playIds: gameList[index].play_id);
          },
          clickItem: (index) {
            var gameItem = gameList[index];
            controller.homeController.openCollectGame(gameItem);
            gameItem.isRecord = true;
            homeController.addGameRecord(gameItem);
          },
        ));
  }

  // 彩票视图
  Widget _buildPageView5({
    required List<ThirdGamesItem> gameList,
  }) {
    List<ThirdGamesItem> tempData = [];
    switch (controller.thirdTabIndex.value) {
      case 1: //热门
        tempData =
            gameList.where((game) => (game.play_is_hot ?? 0) == 1).toList();
        tempData.sort(
            (a, b) => (a.hot_play_sort ?? 0).compareTo(b.hot_play_sort ?? 0));
        break;
      case 2: //最新
        tempData = gameList
            .where((element1) => controller.homeController.recentGameList
                .any((id) => element1.play_id == id))
            .toSet()
            .toList();
        break;
      case 3: //收藏
        tempData =
            gameList.where((game) => (game.play_collection ?? 0) == 2).toList();
        break;
      default:
        tempData = gameList
            .where((element) =>
                element.play_cname!.contains(controller.searchName.value))
            .toList();
        break;
    }
    return Column(
      children: [
        _buildSearchView(),
        Container(
          padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
          child: Stack(
            children: [
              NewHomeGameSecondListWidget2(
                  dataList: tempData,
                  tag: "${widget.pageKey}",
                  gameType: GameTypeEnum.gameType2,
                  imageType: AssetsTypeEnum.netWork,
                  clickCollect: (index) {
                    controller.collectGameAndVenues(index: index);
                  },
                  clickItem: (index) {
                    var gameItem = gameList[index];
                    controller.homeController.openLotteryGame(gameItem);
                    homeController.addGameRecord(HomeCollectionListItemBean(
                      collectionId: gameItem.play_collection == 2
                          ? gameItem.play_id?.toInt()
                          : null,
                      play_id: gameItem.play_id?.toInt(),
                      upper_play_id: gameItem.upper_id?.toInt(),
                      big_type: gameItem.big_type?.toInt(),
                      playName: gameItem.play_name,
                      playCname: gameItem.play_cname,
                      play_cat: gameItem.play_cat?.toInt(),
                      play_state: gameItem.state?.toInt(),
                      play_big_type: gameItem.big_type?.toInt(),
                      gameImgUrl:
                          gameItem.thumbnail_img_url ?? gameItem.gameImgUrl,
                      gtype: gameItem.gtype,
                      isRecord: false,
                    ));
                  })
            ],
          ),
        ),
      ],
    );
  }

  //构建平台选择器
  void _showPlatformSelectView({
    required RxInt tabIndex,
    required List<NewHomeGameDetailTabBean> tabList,
  }) {
    var platformList = List.from(tabList);
    int platformIndex = tabIndex.value - 1;
    platformList.removeAt(0);
    Get.bottomSheet(
        ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50.r), topRight: Radius.circular(50.r)),
          child: SingleChildScrollView(
            child: Container(
              height: 0.5.sh,
              width: double.infinity,
              color: Colors.white,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Text(
                        "平台选择",
                        style: TextStyle(
                            fontSize: 54.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 80.h,
                      ),
                      Expanded(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 30.w),
                            child: GridView.builder(
                                itemCount: platformList.length,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisSpacing: 29.h,
                                        mainAxisSpacing: 23.w,
                                        childAspectRatio: 3,
                                        crossAxisCount: 2),
                                itemBuilder: (context, index) {
                                  String iconPath =
                                      platformList[index].iconPath;
                                  bool isNetImg = iconPath.contains("http");
                                  return CommonRipple(
                                    onTap: () {
                                      AppManager.instance.tapVibrate();
                                      tabIndex.value = index + 1;
                                      controller.changeTabIndex2(index);
                                      controller.homeController.updateHeight();
                                      Get.back();
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(left: 70.w),
                                      decoration: platformIndex == index
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.r), // 圆角
                                              color: const Color.fromARGB(
                                                  255, 105, 196, 210), // 指示器颜色
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20.r), // 圆角
                                              color: const Color(0xFFF6F6F7),
                                            ),
                                      height: 172.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          isNetImg
                                              ? Image.network(
                                                  iconPath,
                                                  width: 80.w,
                                                  height: 80.h,
                                                )
                                              : Image.asset(
                                                  iconPath,
                                                  width: 80.w,
                                                  height: 80.h,
                                                ),
                                          // SvgPicture.asset(tabList[index].iconPath,
                                          //     width: 52.w, height: 52.h),
                                          SizedBox(
                                            width: 40.w,
                                          ),
                                          Expanded(
                                              child: Text(
                                            platformList[index].title,
                                            style: TextStyle(
                                              color: platformIndex == index
                                                  ? Colors.white
                                                  : Colors.grey,
                                              fontSize: 48.sp,
                                            ),
                                          ))
                                        ],
                                      ),
                                    ),
                                  );
                                })),
                      )
                    ],
                  ),
                  Positioned(
                      top: 40.h,
                      right: 40.w,
                      child: CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          Get.back();
                        },
                        child: const Icon(
                          Icons.close,
                          color: Color(colorB7B7B7),
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
        isDismissible: false);
  }

  Widget _buildSearchTabItem(String title, bool isSelect) {
    return Text(
      title,
      style: isSelect
          ? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45.sp,
              color: const Color(theme01MainColor))
          : TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 45.sp,
              color: const Color(colorAFAFAF)),
    );
  }

  var thirdTabType1 = [
    "全部",
    "最近",
    "收藏",
  ];

  var thirdTabType2 = [
    "全部",
    "热门",
    "最近",
    "收藏",
  ];

  Widget _buildSearchView({bool isHotTab = false, bool isShowRecent = false}) {
    return Obx(() {
      return DefaultTabController(
          length: isHotTab ? 3 : 4, // 选项卡的数量
          child: Container(
            padding:
                EdgeInsets.only(bottom: 20.h, top: isShowRecent ? 0 : 20.h),
            color: Colors.white,
            child: Row(
              children: [
                Obx(() => Visibility(
                    visible: !controller.isSearch.value,
                    child: Expanded(
                      child: TabBar(
                        onTap: (index) {
                          if (isHotTab &&
                              [1, 2].contains(index) &&
                              !LoginManager.instance.isLogin.value) {
                            showLoginDialog();
                            return;
                          }
                          if (!isHotTab &&
                              [2, 3].contains(index) &&
                              !LoginManager.instance.isLogin.value) {
                            showLoginDialog();
                            return;
                          }
                          if (controller.thirdTabIndex.value != index) {
                            AppManager.instance.tapVibrate();
                          }
                          controller.changeThirdTabIndex(index);
                          controller.homeController.updateHeight();
                        },
                        labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45.sp,
                            color: const Color(theme01MainColor)),
                        unselectedLabelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 45.sp,
                            color: const Color(colorAFAFAF)),
                        tabs: isHotTab
                            ? List.generate(thirdTabType1.length, (index) {
                                return _buildSearchTabItem(thirdTabType1[index],
                                    index == controller.thirdTabIndex.value);
                              }).toList()
                            : List.generate(thirdTabType2.length, (index) {
                                return _buildSearchTabItem(thirdTabType2[index],
                                    index == controller.thirdTabIndex.value);
                              }).toList(),
                        padding: EdgeInsets.zero,
                        indicator: const BoxDecoration(),
                        dividerHeight: 0,
                        labelPadding: EdgeInsets.zero,
                        indicatorSize: TabBarIndicatorSize.label,
                      ),
                    ))),
                Container(
                    height: 100.h,
                    width: controller.isSearch.value
                        ? (1.sw - 60.w)
                        : (isHotTab ? 0.53.sw : 0.4.sw),
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: BoxDecoration(
                        border: Border.all(color: const Color(colorEDEDED)),
                        borderRadius: BorderRadius.circular(45.r)),
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller
                            .changeSearchStatus(!controller.isSearch.value);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            Assets.theme1.images.video.iconSearch,
                            width: 46.w,
                            height: 46.h,
                          ),
                          Expanded(
                              child: TextField(
                            controller: controller.searchNameController,
                            focusNode: controller.searchFocusNode,
                            cursorColor: const Color(theme01MainColor),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: "搜索",
                              contentPadding: EdgeInsets.only(left: 10.w),
                              hintStyle: TextStyle(
                                  fontSize: 45.sp,
                                  color: const Color(colorBCBCBC)),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                            ),
                          )),
                          Visibility(
                              visible: controller.isSearch.value,
                              child: CommonRipple(
                                onTap: () {
                                  AppManager.instance.tapVibrate();
                                  Get.focusScope?.unfocus();
                                  controller.searchNameController.text = "";
                                  controller.homeController.updateHeight();
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.black26,
                                  radius: 26.w,
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 40.w,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    )),
              ],
            ),
          ));
    });
  }
}
