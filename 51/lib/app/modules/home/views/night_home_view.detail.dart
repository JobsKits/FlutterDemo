import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/data/home_game_tab_bean.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/home_view_const.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../controllers/new_home_controller.detail.dart';
import '../widget/DotIndicator.dart';
import '../widget/night_home_game_second_list_widget.dart';
import '../widget/night_home_game_second_list_widget2.dart';

class NightHomeViewDetail extends StatefulWidget {
  NightHomeViewDetail({
    super.key,
    required this.pageKey,
    required this.globalKey,
  });

  // 存储传递的 pageKey
  final HomePageDetailEnum pageKey;
  GlobalKey globalKey;

  @override
  State<NightHomeViewDetail> createState() => _NewHomeViewDetailState();
}

class _NewHomeViewDetailState extends State<NightHomeViewDetail> {
  NewHomeController homeController = Get.find();
  late NewHomeControllerDetail controller = Get.put(NewHomeControllerDetail());
  @override
  Widget build(BuildContext context) {
    controller.pageKey.value = widget.pageKey; // 更新响应式变量
    return Container(
      color: Get.context?.customTheme?.pageBg,
      key: widget.globalKey,
      padding: EdgeInsets.zero,
      child: getView(),
    );
  }

  Widget getView() {
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
            context,
            gameList: controller.homeController.gameLottery,
          ));
    }

    // 电子
    if (widget.pageKey == HomePageDetailEnum.electronic) {
      return _buildPageView2(
        context,
        tabController: controller.electronicTabController,
        tabList: controller.electronicTabList,
        tabIndex: controller.currentElectronicTabIndex,
        gameDataMap: controller.electronicData,
      );
    }
    // 区块链
    if (widget.pageKey == HomePageDetailEnum.blockChain) {
      return _buildPageView2(
        context,
        tabController: controller.blockChainTabController,
        tabList: controller.blockChainTabList,
        tabIndex: controller.currentBlockChainTabIndex,
        gameDataMap: controller.blockChainData,
      );
    }
    // 棋牌
    if (widget.pageKey == HomePageDetailEnum.chess) {
      return _buildPageView2(
        context,
        tabController: controller.chessTabController,
        tabList: controller.chessTabList,
        tabIndex: controller.currentChessTabIndex,
        gameDataMap: controller.chessData,
      );
    }

    // 捕鱼
    if (widget.pageKey == HomePageDetailEnum.fishing) {
      return _buildPageView2(
        context,
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
          return JobsBuildEmptyView();
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
          return JobsBuildEmptyView();
        }
        return _buildPageView4(
          isRecord: true,
          gameList: homeController.gameRecords,
        );
      });
    }
    // 返回空视图
    return JobsBuildEmptyView();
  }

  /// 构建TabBar
  Widget _buildTabBar({
    required TabController tabController,
    required List<NewHomeGameDetailTabBean> tabList,
    required RxInt tabIndex,
  }) {
    return Container(
      height: 180.h,
      color: context.customTheme?.pageTwoBg,
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
                          color: context.theme.primaryColor, // 指示器颜色
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
          GestureDetector(
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

  /// 构建TabBar
  Widget _buildLeftTabBar({
    required TabController tabController,
    required List<NewHomeGameDetailTabBean> tabList,
    required RxInt tabIndex,
  }) {
    return Container(
      width: 162.w,
      height: 1.sh,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: controller.electronicTabList.length,
          itemBuilder: (context, index) {
            var item = controller.electronicTabList[index];

            var iconPath = item.iconPath;
            var isNetImg = iconPath.contains("http");
            return GestureDetector(
              onTap: () {
                if (tabIndex.value != index) {
                  AppManager.instance.tapVibrate();
                }
                tabIndex.value = index;
                controller.changeThirdTabIndex(0);
                controller.homeController.updateHeight();
              },
              child: Obx(() => Container(
                    margin: EdgeInsets.only(top: 20.h),
                    width: 162.w,
                    decoration: BoxDecoration(
                        color: tabIndex.value == index
                            ? const Color(0xff272A39)
                            : const Color(0xff1E212E),
                        borderRadius: BorderRadius.circular(20.r)),
                    height: 162.w,
                    child: Column(
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
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "${item.title}",
                          style: TextStyle(
                              color: tabIndex.value == index
                                  ? context.theme.primaryColor
                                  : const Color(0xff8C90A2)),
                        )
                      ],
                    ),
                  )),
            );
          }),
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
            gameList.where((game) => (game.game_fever ?? 0) == 1).toList();
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
        _buildSearchView(context),
        Expanded(
            child: Container(
          padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
          child: NightHomeGameSecondListWidget2(
            dataList: tempData,
            isSport: true,
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
        ))
      ],
    );
  }

  Widget _buildPageView2(BuildContext context,
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

      return Row(
        children: [
          _buildLeftTabBar(
            tabController: tabController,
            tabList: tabList,
            tabIndex: tabIndex,
          ),
          Expanded(
              child: Column(
            children: [
              // _buildTabBar(
              //   tabController: tabController,
              //   tabList: tabList,
              //   tabIndex: tabIndex,
              // ),
              _buildSearchView(context, isHotTab: isHotTab, isShowRecent: true),
              Expanded(
                  child: Container(
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
                      } else {
                        tempData = gameData
                            .where((game) => (game.game_fever ?? 0) == 1)
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

                      break;
                    case 3: //收藏
                      tempData = gameData
                          .where((game) => (game.play_collection ?? 0) == 2)
                          .toList();
                      break;
                    default:
                      tempData = gameData
                          .where((element) => element.play_cname!
                              .contains(controller.searchName.value))
                          .toList();
                      break;
                  }
                  return NightHomeGameSecondListWidget(
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
              ))
            ],
          ))
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
        child: NightHomeGameSecondListWidget(
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
  Widget _buildPageView5(
    BuildContext context, {
    required List<ThirdGamesItem> gameList,
  }) {
    List<ThirdGamesItem> tempData = [];
    switch (controller.thirdTabIndex.value) {
      case 1: //热门
        tempData =
            gameList.where((game) => (game.game_fever ?? 0) == 1).toList();
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
    return Expanded(
        child: Column(
      children: [
        _buildSearchView(context),
        // CommonGameSearchView(
        //   isShowAll: true,
        // ),
        Expanded(
            child: Container(
          padding: EdgeInsets.fromLTRB(30.w, 40.h, 30.w, 40.h),
          child: Stack(
            children: [
              NightHomeGameSecondListWidget2(
                  dataList: tempData,
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
        )),
      ],
    ));
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
                                  return GestureDetector(
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
                      child: GestureDetector(
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

  Widget _buildSearchTabItem(
      BuildContext context, String title, bool isSelect) {
    return Text(
      title,
      style: isSelect
          ? TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.sp,
              color: context.theme.primaryColor)
          : TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40.sp,
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

  Widget _buildSearchView(BuildContext context,
      {bool isHotTab = false, bool isShowRecent = false}) {
    return Obx(() {
      return DefaultTabController(
          length: isHotTab ? 3 : 4, // 选项卡的数量
          child: Container(
            padding:
                EdgeInsets.only(bottom: 20.h, top: isShowRecent ? 0 : 20.h),
            color: Get.context?.customTheme?.pageBg,
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    indicator: DotIndicator(),
                    onTap: (index) {
                      if (controller.thirdTabIndex.value != index) {
                        AppManager.instance.tapVibrate();
                      }
                      controller.changeThirdTabIndex(index);
                      controller.homeController.updateHeight();
                    },
                    labelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.sp,
                        color: context.theme.primaryColor),
                    unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40.sp,
                        color: const Color(colorAFAFAF)),
                    tabs: isHotTab
                        ? List.generate(thirdTabType1.length, (index) {
                            return _buildSearchTabItem(
                                context,
                                thirdTabType1[index],
                                index == controller.thirdTabIndex.value);
                          }).toList()
                        : List.generate(thirdTabType2.length, (index) {
                            return _buildSearchTabItem(
                                context,
                                thirdTabType2[index],
                                index == controller.thirdTabIndex.value);
                          }).toList(),
                    padding: EdgeInsets.zero,
                    // indicator: const BoxDecoration(),
                    dividerHeight: 0,
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
                Container(
                    height: 100.h,
                    width: isHotTab
                        ? 0.5.sw
                        : isShowRecent
                            ? 0.4.sw
                            : 0.5.sw,
                    margin: EdgeInsets.symmetric(horizontal: 30.w),
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    decoration: BoxDecoration(
                        color: context.customTheme!.homeGameSearchBgColor,
                        borderRadius: BorderRadius.circular(20.r)),
                    child: GestureDetector(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller
                            .changeSearchStatus(!controller.isSearch.value);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                              child: TextField(
                            controller: controller.searchNameController,
                            focusNode: controller.searchFocusNode,
                            cursorColor: context.theme.primaryColor,
                            textInputAction: TextInputAction.search,
                            style: TextStyle(
                                color: context
                                    .customTheme?.homeGameSearchTxtColor),
                            decoration: InputDecoration(
                              hintText: "搜索游戏",
                              contentPadding: EdgeInsets.only(left: 10.w),
                              hintStyle: TextStyle(
                                  fontSize: 45.sp,
                                  color: context
                                      .customTheme?.homeGameSearchHintTxtColor),
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
                          Image.asset(
                            Assets.theme1.images.home.iconHomeGameSearch.path,
                            width: 46.w,
                            height: 46.h,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ));
    });
  }
}
