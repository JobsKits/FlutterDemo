import 'package:flutter/cupertino.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/dw_records_bean.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../data/home_game_tab_bean.dart';
import '../../../data/home_main_info_bean.dart';
import '../../user/widget/funding_type_pop_widget.dart';

class DwRecordsController extends GetxController {
  double typeWidgetHeight = 0; //类型组件的高度
  double timeWidgetHeight = 0; //时间组件的高度
  GlobalKey timeKey = GlobalKey(); //时间的key
  GlobalKey platformKey = GlobalKey(); //时间的key
  GlobalKey typeKey = GlobalKey(); //类型的key
  RxString currentTimeName = "今日".obs;
  RxString currentPlatformName = "全部类型".obs;
  int currentPlatformIndex = 0;

  RxString currentStatusName = "全部状态".obs;
  int currentStatusIndex = 0;

  RxInt currentTimeIndex = 0.obs;
  int currentDate = 0; //当前用于接口请求的日期
  int currentPage = 1; // 当前页
  int pageSize = 10; // 页码
  bool hasMore = false; //是否还有必要加载更多
  late ScrollController scrollController;
  List<Map<String, dynamic>> platformList = [
    {"platformTitle": "全部类型", "type": ""},
    {"platformTitle": "充值", "type": "chg"},
    {"platformTitle": "提现", "type": "with"},
  ];
  List<Map<String, dynamic>> statusList = [
    {"statusTitle": "全部状态", "type": 0},
    {"statusTitle": "处理中", "type": 1},
    {"statusTitle": "成功", "type": 2},
    {"statusTitle": "失败", "type": 3},
  ];
  List<Map<String, dynamic>> timeList = [
    {"timeTitle": "今日", "date": 0},
    {"timeTitle": "昨日", "date": 1},
    {"timeTitle": "近3日", "date": 3},
    {"timeTitle": "近7日", "date": 7},
    {"timeTitle": "近15日", "date": 15},
    {"timeTitle": "近30日", "date": 30},
  ];

  RxBool isLoading = false.obs;
  RxList<DwRecordsBean> recordsList = <DwRecordsBean>[].obs;
  bool isRecharge = true;
  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>;
    if (arguments != null) {
      isRecharge = arguments['isRecharge'] ?? false;
      if (isRecharge) {
        currentPlatformIndex = 1;
        currentPlatformName.value = "充值";
      } else {
        currentPlatformIndex = 2;
        currentPlatformName.value = "提现";
      }
    }
    refreshData();
    print(
        "输出一下关键信息：${LoginManager.instance.loginInfo?.custId}  ${LoginManager.instance.loginInfo?.accessToken}");
    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        loadMoreData();
      }
    });
    // 数据加载完成，调用计算高度的方法
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateWidgetHeights();
    });
  }

  void _calculateWidgetHeights() {
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
  }

  void changeTimeIndex(int index) {
    currentTimeIndex.value = index;
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(30); //这里传入具体的天数，当天：0，多少天前，就传多少天
    print("开始时间：${dayRange['startTime']}  结束时间:${dayRange['endTime']}");
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

  void changePlatformIndex(int index) {
    FundingTypePopWidget.instance.hide();
    resetStatus(); //切换tab后需要重置筛选状态
    currentPlatformIndex = index;
    // getCurrentPlatformList(index);
    refreshData();
  }

  //重置筛选条件
  void resetStatus() {
    currentStatusIndex = 0;
    currentPage = 1;
    currentStatusName.value = "全部状态";
  }

  void changeStatusIndex(int index) {
    currentStatusIndex = index;
    refreshData();
  }

  //切换平台
  void updateStatus() {
    if (currentStatusName.value ==
        platformList[currentStatusIndex]["typeTitle"]) {
      return;
    }

    currentStatusName.value = platformList[currentStatusIndex]["typeTitle"];
    currentPage = 1;
    refreshData();
  }

  //刷新数据
  Future<void> refreshData() async {
    currentPage = 1;
    recordsList.value = await UserApi().reqDwRecordsList(
      type: platformList[currentPlatformIndex]["type"],
      frontStatus: statusList[currentStatusIndex]["type"],
      time: currentDate,
      page: currentPage,
    );
    hasMore = recordsList.length == 10;
  }

  loadMoreData() async {
    if (hasMore) {
      //如果经过判断，有更多数据，才执行加载更多
      isLoading.value = true;
      currentPage += 1;
      var netList = await UserApi().reqDwRecordsList(
        type: platformList[currentPlatformIndex]["type"],
        frontStatus: statusList[currentStatusIndex]["type"],
        time: currentDate,
        page: currentPage,
      );
      hasMore = netList.length == 10;
      recordsList.addAll(netList);
      isLoading.value = false;
    }
  }
}
