import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:flutter_bet/pages/betting/common_model/betting_race_api_model.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/yulecheng_game_service.dart';
import 'package:flutter_bet/utils/date_util.dart';
import 'package:flutter_bet/utils/time/time_format.dart';
import 'package:flutter_bet/widget/refresh/widget/cupertino/easy_refresh_path.dart';
import 'package:get/get.dart';

class RankListCompetitionLogic extends BaseController {
  final List<BettingRaceApiModel> list4 = [];
  bool isLoading = false;

  late Timer dataTimer;
  int inHoursSave = 0; //保存距离小时， 可作为刷新的依据
  bool refreshData = false;
  final diffShowObs = "".obs;


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initData();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    //获取竞赛排行版
    initData();

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
      diffShowObs.value = "${difference.inHours} ${S.current.random_text_553}";
    } else if (difference.inMinutes > 0) {
      diffShowObs.value = "${difference.inMinutes} ${S.current.random_text_554}";
    }
    // log("时间差：${difference}");
    //[log]时间差：12:46:50.453275  加.obs ;
    //[log] 时间差：-12:47:50.456373

    return difference;
  }

  ///请求网络数据
  ///isRefresh 是否是刷新， isFirst是否是第一次刷新，为了状态布局, isShow 是否显示loading
  Future<void> loadNetData(
      {required bool isRefresh,
        bool isShowLoad = true,
        bool isFirst = false,
        bool preload = false}) async {
    await ApiService.instance.getRankingListCompetite(
      startTime: getParamTimeUtc(),
      endTime: getParamTimeUtc(isEndTime: true),
      success: (data) async {
        isLoading = false;

        list4.clear();
        list4.addAll(data.content);
        Future.delayed(const Duration(milliseconds: 150), () {
          update(['Rank_list_competition']);
        });
      },
      fail: (message) {
        isLoading = false;
        update(['Rank_list_competition']);
      },
    );

  }

  initData() async {

    if(isLoading == true) return;
    isLoading = true;

    timeTask(true);
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

  // String getHours() {
  //   int leftHour = 24 - int.parse(formatDate(DateTime.now(), ['HH']));
  //   return leftHour.toString();
  // }

  @override
  void onClose() {
    if (dataTimer.isActive) dataTimer.cancel();
    super.onClose();

  }
}
