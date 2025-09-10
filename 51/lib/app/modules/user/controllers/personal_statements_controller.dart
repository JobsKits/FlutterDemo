import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/personal_statement_bean.dart';
import 'package:get/get.dart';

import '../../../../api/home_api.dart';
import '../../../../api/user_api.dart';
import '../../../../constants/game_constants.dart';
import '../../../../kernel/network/service.dart';
import '../../../../kernel/utils/game_utils.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../../utils/sp_util.dart';
import '../../../data/home_game_tab_bean.dart';
import '../../../data/home_main_info_bean.dart';
import '../../../widget/common_loading_view.dart';
import '../../home/controllers/new_home_controller.dart';
import '../../home/new_home_const.dart';
import '../data/bet_list_bean.dart';

class PersonalStatementsController extends GetxController {
  RxList<HomeGameTabBean> tabList = <HomeGameTabBean>[].obs;

  late NewHomeController homeController = Get.find();
  GlobalKey typeKey = GlobalKey(); //类型的key
  GlobalKey timeKey = GlobalKey(); //时间的key
  GlobalKey bigGameTypeKey = GlobalKey(); //游戏大类的key
  double typeWidgetHeight = 0; //类型组件的高度
  double timeWidgetHeight = 0; //时间组件的高度
  double bigGameTypeWidgetHeight = 0; //游戏大类组件的高度
  RxInt currentTypeIndex = 0.obs;
  RxInt currentTimeIndex = 0.obs;
  RxString currentTypeName = "全部平台".obs;
  int currentDate = 0; //当前用于接口请求的日期
  RxString currentTimeName = "今日".obs;
  RxString currentBigGameTypeName = "全部类型".obs;
  RxString itemTime = "".obs;
  // ----------------------------------------
  int currentPage = 1; // 当前页
  int pageSize = 10; // 页码
  bool hasMore = false; //是否还有必要加载更多
  late ScrollController scrollController;
  RxBool isLoadingMore = false.obs;
  // ----------------------------------------

  RxInt currentTabIndex = 0.obs;
  RxList<ThirdGamesItem> platformList = <ThirdGamesItem>[].obs; // 电子游戏

  List<Map<String, dynamic>> timeList = [
    {"timeTitle": "今日", "date": 0},
    {"timeTitle": "昨日", "date": 1},
    {"timeTitle": "近3日", "date": 3},
    {"timeTitle": "近7日", "date": 7},
    {"timeTitle": "近15日", "date": 15},
    {"timeTitle": "近30日", "date": 30},
  ];

  RxBool isBetLoading = false.obs;

  RxList<PersonalStatementItemBean> itemList =
      <PersonalStatementItemBean>[].obs;
  RxInt listSortType = 0.obs; //列表排序类型，0：默认，1：倒序，2：正序
  RxString listSortText = "排序".obs; //列表排序类型，0：默认，1：倒序，2：正序
  @override
  void onInit() {
    super.onInit();
    reqTabList();
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoadingMore.value) {
        loadMoreData();
      }
    });
  }

  void changeSort() {
    switch (listSortType.value) {
      case 0:
        listSortType.value = 1;
        listSortText.value = "倒序";
        break;
      case 1:
        listSortType.value = 2;
        listSortText.value = "正序";
        break;
      case 2:
        listSortType.value = 1;
        listSortText.value = "倒序";
        break;
    }
    refreshData();
  }

  void _calculateWidgetHeights() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (typeKey.currentContext != null) {
        // 在构建完成后执行
        var typeBox = (typeKey.currentContext!.findRenderObject() as RenderBox);
        typeWidgetHeight =
            typeBox.localToGlobal(Offset.zero).dy + typeBox.size.height;
      }

      if (timeKey.currentContext != null) {
        var timeBox = (timeKey.currentContext!.findRenderObject() as RenderBox);
        timeWidgetHeight =
            timeBox.localToGlobal(Offset.zero).dy + timeBox.size.height;
      }
      if (bigGameTypeKey.currentContext != null) {
        var bigGameTypeBox =
            (bigGameTypeKey.currentContext!.findRenderObject() as RenderBox);
        bigGameTypeWidgetHeight = bigGameTypeBox.localToGlobal(Offset.zero).dy +
            bigGameTypeBox.size.height;
      }
    });
  }

  void changeTypeIndex(int index) {
    currentTypeIndex.value = index;
  }

  void changeTimeIndex(int index) {
    currentTimeIndex.value = index;
  }

  String getBetItem(BetItem item) {
    return getBetItemName(int.parse(item.gameTypeId!));
  }

  // void changeStatusIndex(int index) {
  //   currentStatusIndex.value = index;
  // }

  //切换平台
  void updateType() {
    if (currentTypeName.value ==
        platformList[currentTypeIndex.value].play_cname!) {
      return;
    }

    currentTypeName.value = platformList[currentTypeIndex.value].play_cname!;
    currentPage = 1;
    refreshData();
  }

  void updateTime() {
    if (currentDate == timeList[currentTimeIndex.value]["date"] &&
        currentTimeName == timeList[currentTimeIndex.value]["timeTitle"]) {
      return; //如果名字和类型都是之前的，就没必要更新
    }
    currentTimeName.value = timeList[currentTimeIndex.value]["timeTitle"];
    currentDate = timeList[currentTimeIndex.value]["date"];
    print("当前选择的时间为：${currentDate}");
    currentPage = 1;
    refreshData();
  }

  int getReqTypeId() {
    int requestTypeId = 0;
    //对首页的typeId进行充新映射
    switch (tabList[currentTabIndex.value].key) {
      case HomeGameCategory.CHESS_AND_CARDS_KEY: // 棋牌
        requestTypeId = 2;
        break;
      // case HomeGameCategory.LOTTERY_KEY: // 彩票
      //   requestTypeId = 1;
      //   break;
      case HomeGameCategory.ELECTRONIC_KEY: // 电子
        requestTypeId = 4;
        break;
      case HomeGameCategory.FISHING_KEY: // 捕鱼
        requestTypeId = 5;
        break;
      case HomeGameCategory.LIVE_KEY: // 真人
        requestTypeId = 3;
        break;
      case HomeGameCategory.SPORTS_KEY: // 体育
        requestTypeId = 6;
        break;
      case 8: // 三方彩票
        requestTypeId = 8;
        break;
      case HomeGameCategory.BLOCKCHAIN_KEY: // 区块链
        requestTypeId = 10; //暂定
        break;
    }
    return requestTypeId;
  }

  //刷新数据
  Future<void> refreshData({bool? needLoading = true}) async {
    if (needLoading == true) {
      isBetLoading.value = true;
    }
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(currentDate); //这里传入具体的天数，当天：0，多少天前，就传多少天

    itemTime.value =
        "${DateTimeUtils.formatTimestamp(dayRange['startTime']!, temp: 'yyyy-MM-dd')} - ${DateTimeUtils.formatTimestamp(dayRange['endTime']!, temp: 'yyyy-MM-dd')}";
    var gameStudioId = 0;
    if (tabList[currentTabIndex.value].key == 2 ||
        tabList[currentTabIndex.value].key == 0) {
      gameStudioId = 0;
    } else {
      gameStudioId = platformList.isNotEmpty
          ? platformList[currentTypeIndex.value].play_id!.toInt()
          : 0;
    }

    itemList.value = await UserApi().reqPersonalStatementList(
        gameTypeId: getReqTypeId(),
        gameStudioId: gameStudioId,
        time: currentDate,
        sort: listSortType.value);
  }

  // 加载更多
  loadMoreData() async {
    if (hasMore) {
      isLoadingMore.value = true;
      currentPage += 1;
      await refreshData(needLoading: false);
      isLoadingMore.value = false;
    }
  }

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
    _calculateWidgetHeights();
    if (currentBigGameTypeName.value == tabList[currentTabIndex.value].title!) {
      return;
    }
    currentBigGameTypeName.value = tabList[currentTabIndex.value].title!;
    resetStatus(); //切换tab后需要重置筛选状态
    getCurrentPlatformList(index);
    refreshData();
  }

  //切换平台
  void updateBigGameType() {
    currentPage = 1;
    refreshData();
  }

  Future<void> reqTabList() async {
    try {
      EasyLoading.show(indicator: const CommonLoadingView());
      HomeMainInfoBean? spHomeData;
      spHomeData = await SpUtil.getBean<HomeMainInfoBean>("homeBean", (json) {
        return HomeMainInfoBean.fromJson(json);
      });
      var versionType = spHomeData?.version_type ?? [];
      versionType.removeWhere((item) => item.sort_v == 0);
      versionType.sort((a, b) => b.sort_v!.compareTo(a.sort_v!));
      // 1: 棋牌， 2: 彩票, 3: 电子，4：捕鱼 5: 真人 6: 体育
      versionType = versionType
          .where((item) => HomeGameCategory.supportList.contains(item.type))
          .toList();
      tabList.add(HomeGameTabBean(
        title: "全部类型",
        key: 0,
        pageKey: "0",
        iconPath: "",
      ));
      for (var category in versionType) {
        tabList.add(HomeGameTabBean(
          title: category.play_name!,
          key: category.type!,
          pageKey: GameUtils.getTabEName(category.type!),
          iconPath: GameUtils.getTabIconPath(category.type!),
        ));
        // 三方彩票
        if (category.type == 2) {
          tabList.add(HomeGameTabBean(
            title: '彩票',
            key: 8,
            pageKey: 'thirdLottery',
            iconPath: GameUtils.getTabIconPath(2),
          ));
        }
      }
      tabList.removeWhere((item) => item.key == HomeGameCategory.GAME_TRY_KEY);
      tabList.removeWhere((item) => item.key == HomeGameCategory.LOTTERY_KEY);
      if (tabList.isNotEmpty) {
        currentBigGameTypeName.value = tabList[0].title;
      }
      getCurrentPlatformList(0);
      await refreshData();
    } finally {
      // 数据加载完成，调用计算高度的方法
      _calculateWidgetHeights();
      EasyLoading.dismiss();
    }
  }

  void getCurrentPlatformList(int index) {
    HomeGameTabBean tabBean = tabList[index];

    List<ThirdGamesItem> newPlatformList = [];
    switch (tabBean.key) {
      case 1: //棋牌
        newPlatformList = homeController.gameChess;
        break;
      case 2: //彩票
        newPlatformList = [];
        break;
      case 3: //电子
        newPlatformList = homeController.gameElectronic;
        break;
      case 4: //捕鱼
        newPlatformList = homeController.gameFishing;
        break;
      case 5: //真人
        newPlatformList = homeController.gameLive;
        break;
      case 6: //体育
        newPlatformList = homeController.gameSports;
        break;
      case 8: //三方彩票
        newPlatformList = homeController.gameLottery;
        break;
      case 39: //体育
        newPlatformList = homeController.gameBlockchain;
        break;
      default:
        break;
    }

    if (newPlatformList.isNotEmpty) {
      newPlatformList = [
        ThirdGamesItem(
          play_cname: '全部平台',
          play_id: 0,
        ),
        ...newPlatformList,
      ];
    }

    platformList.value = newPlatformList;
  }

  //重置筛选条件
  void resetStatus() {
    currentTypeIndex.value = 0;
    currentPage = 1;
    currentTypeName.value = "全部平台";

    // currentTimeIndex.value = 0;
    // currentTimeName.value = "今日";
    // currentDate = 0; //当前用于接口请求的日期

    // currentStatusName.value = "全部状态";
  }

  //通过玩法id匹配对应的名字
  String getBetItemName(int playTypeId) {
    String tempStr = '';
    tempStr = platformList
            .firstWhere((item) => item.play_id!.toInt() == playTypeId)
            .play_cname ??
        "";
    return tempStr;
  }
}
