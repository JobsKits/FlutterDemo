import 'package:flutter_bet/generated/l10n.dart';
import 'dart:async';
import 'dart:developer';

import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:get/get.dart';
import '../../../controllers/global_state_controller.dart';
import '../../../model/page_common_model.dart';
import '../../../services/api/api_service.dart';
import '../../../utils/time/time_format.dart';
import '../../../widget/refresh/custom_refresh_controller.dart';
import '../../../widget/refresh/custom_refresh_state_mixin_helper.dart';
import '../common_helper/betting_biz_count_mixin.dart';
import '../common_model/betting_common_params.dart';
import '../common_model/betting_race_api_model.dart';

///娱乐城投注，竞赛列表 logic
class BettingCasinoRaceListLogic extends GetxController
    with CustomRefreshStateMixinHelper, BettingBizCountMixin {
  BettingCasinoRaceListLogic({required this.bettingType, this.fromPage});

  ///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  final BettingTypeEnum bettingType;

  ///主要是看来自哪里，需不需要分页
  final BettingFromPageType? fromPage; //浏览菜单"我的投注"， 不需要分页，默认加载个10

  ///分页数据
  final pageModelObs =
      PageCommonModel.init(curPage: 1, first: true, content: <BettingRaceApiModel>[]).obs;

  ///自定义方便取数据
  List<BettingRaceApiModel> get apiModelList => pageModelObs.value.content;

  ///listView 上下拉控制器
  final CustomRefreshController refreshController = CustomRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  ///===================倒计时处理参数===================
  int inHoursSave = 0; //保存距离小时， 可作为刷新的依据
  bool refreshData = false;
  late Timer dataTimer;
  final diffShowObs = "".obs;

  ///测试数据
  // final raceListTestObs = [
  //   CompetitionBean(
  //       name: S.current.random_text_238,
  //       icon: 'assets/images/bet_slip/ic_no_one.webp',
  //       money: '122390',
  //       moneyIcon: '702',
  //       bonusMoney: '35%'),
  // ].obs;

  @override
  void onInit() {
    super.onInit();
    //监听语言
    ever(
      GlobalStateController.of().langType,
      (callback) {
        loadNetData(isRefresh: true, isShowLoad: true, isFirst: true, preload: true);
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
    // getCasinoRecord();
    // loadNetData(isRefresh: true, isShowLoad: true, isFirst: true, preload: true);
    initTime();
    initListenPush();
  }

  //监听推送消息
  void initListenPush() {
    //不分页, 且是所有投注 或者 风云榜
    var cond = bettingType == BettingTypeEnum.allBet || bettingType == BettingTypeEnum.stormRanking;
    if (cond && !BettingFromPageType.isFromMainMenu(fromPage)) {
      ever(GlobalStateController.of().mqttCasinoRaceRankingObs, (mqttData) async {
        listenPushDataChange(mqttData);
      });
    }
  }

  ///监听推送的数据变换
  void listenPushDataChange(List<BettingRaceApiModel> dataList) {
    //去重 并 合并
    //最多显示10条数据
    var mqttData = dataList;
    var showData = apiModelList;

    ///获取不相同的id
    var diffData = mqttData.where((mqtt) {
      //every 判断List中是所有元素是否符合条件，即是新数据
      return showData.every((show) => mqtt.uid != show.uid);
    }).toList();
    if (diffData.isNotEmpty) {
      showData.insertAll(0, diffData);
      var newData = showData.sublist(0, 10);
      apiModelList.assignAll(newData);
      pageModelObs.refresh();
    }
    // log("合并数据...$bettingType...${JsonUtil.encodeObj(apiModelList)}");
  }

  @override
  void onClose() {
    if (dataTimer.isActive) dataTimer.cancel();
  }

  ///初始化定时器
  initTime() {
    //第一次进来先刷一下数据
    timeTask(true);
    //分钟计算一次，并一定是刷新数据
    dataTimer = Timer.periodic(const Duration(seconds: 60), (Timer timer) {
      // log("娱乐城竞赛排行榜...定时器...");
      timeTask(false);
    });
  }

  ///倒计时处理，并执行刷型
  void timeTask(bool isFirst) {
    var difference = diffTimeLogic();
    // print("结束时间...${diffShowObs.value}");
    //1小时刷新时间一次，什么时候刷新， 在整点吗？
    if (inHoursSave != difference.inHours) {
      inHoursSave = difference.inHours;
      refreshData = true;
    } else {
      refreshData = false;
    }
    //refreshData || minCountdown()
    if (refreshData) {
      // loadNetData(isRefresh: true, isShowLoad: true);
      loadNetData(isRefresh: true, isShowLoad: true, isFirst: isFirst, preload: isFirst);
    }
  }

  ///倒计时 时间计算落后
  ///在重新回到该页面时，可以在调一次， 为了国际化
  Duration diffTimeLogic() {
    // 获取今天 00:00:00 的时间
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    //获取明天 00:00:00 的时间
    DateTime tomorrowStart = todayStart.add(const Duration(days: 1));
    //1705999471124
    // DateTime tomorrowStart =  DateUtil.getDateTimeByMs(1705999471124).add(const Duration(minutes: 7));
    // log("当前时间：${now.millisecondsSinceEpoch}");

    // log("今天时间：${DateUtil.formatDate(todayStart)}");
    // log("明天时间：${DateUtil.formatDate(tomorrowStart)}");
    // [log] 今天时间：2024-01-23 00:00:00
    // [log] 明天时间：2024-01-23 00:50:00
    final difference = tomorrowStart.difference(now);
    //
    //特殊处理， 在23：xx; 会返回0， 转成分钟
    //注意倒计时 明天对 今天 的difference 是负数
    if (difference.inHours > 0) {
      diffShowObs.value = " ${difference.inHours} ${S.current.random_text_553}";
    } else if (difference.inMinutes > 0) {
      diffShowObs.value = " ${difference.inMinutes} ${S.current.random_text_554}";
    }
    // log("时间差：${difference}");
    //[log]时间差：12:46:50.453275  加.obs ;
    //[log] 时间差：-12:47:50.456373

    return difference;
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  Future<void> loadNetData({
    required bool isRefresh,
    bool isShowLoad = true,
    bool isFirst = false,
    bool preload = false,
  }) async {
    showLoading(isShowLoad, isFirst, preload);
    //【需求变更】【0306】这个接口开始时间跟结束时间 传0时区的时间
    // 一天时间00:00:00 到 23:59:59，本地时间的 转utc
    await ApiService.instance.getCompetitionList(
      //为为什么要这么多呢？就是为了请求失败的话还保留旧数据
      page: pageModelObs.value.pageIndex(isRefresh),
      page_size: PageCommonModel.pageSize10,
      // page_size: BettingFromPageType.isFromBrowseMenu(fromPage)
      //     ? pageModelObs.value.curPageSize
      //     : PageCommonModel.pageSize10,
      start_time: getParamTimeUtc(),
      end_time: getParamTimeUtc(isEndTime: true),
      success: (PageCommonModel<BettingRaceApiModel> resultData) {
        pageModelObs.value.copyWith(resultData, isRefresh);
        pageModelObs.refresh();
        log("娱乐城投注排行榜api...上层...${pageModelObs.toString()}");
        successFinish(isRefresh, pageModelObs.value, refreshController);
      },
      fail: (bool isConnect, String? message, candy) {
        // List<BettingRaceApiModel> testTemp = [];
        // testTemp.add(BettingRaceApiModel());
        // pageModelObs.value.addAllData(testTemp, isRefresh);
        // pageModelObs.refresh();
        failFinish(isConnect, isRefresh, isFirst, refreshController);
      },
    );
  }

  ///uct 处理
  ///本地一天时间2024-01-01 00:00:00 到 23:59:59， 转utc
  String getParamTimeUtc({bool isEndTime = false}) {
    var timeStr = DateUtil.formatDate(DateTime.now(),
        format: !isEndTime ? TimeFormatterEnum.start.formatter : TimeFormatterEnum.end.formatter);
    var timeUtcStr = DateUtil.formatDate(DateTime.parse(timeStr).toUtc());
    // log("timeUtcStr...$timeUtcStr");
    return timeUtcStr;
  }
}
