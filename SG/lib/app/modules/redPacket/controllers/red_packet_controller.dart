import 'package:date_format/date_format.dart';
import 'package:flutter_bet/generated/l10n.dart' as l10n;
import 'package:flutter_bet/services/api/extension/activity_api_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/time/time_utils.dart';
import 'package:flutter_bet/widget/sport/custom_sport_banner.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../../controllers/global_biz_lang_mixin.dart';
import '../../../../pages/activity/a_helper/activity_biz_helper.dart';
import '../../../../services/api/api_service.dart';
import '../../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../../../widget/snack_bar/custom_snack_bar.dart';
import '../../../../widget/snack_bar/custom_snack_bar_icons.dart';
import 'exchange_controller.dart';

const hm = [HH, ':', nn];
class RedPacketController extends GetxController with ExchangeCurrencyMixin, GlobalBizLangMixin {
  final base = <dynamic>[].obs;
  final custom = <dynamic>[].obs;
  final redDetails = {}.obs;
  final redPacketDetail = {}.obs;
  final time = "".obs;
  final periodTime = "".obs;
  final periodEndTime = "".obs;
  final periodBonusTime = "".obs;
  final periodEndBonusTime = "".obs;
  var pid = "36514323170050598";
  final ruleType = 0.obs;
  final term = "".obs;
  final imageUrl = "".obs;
  final bottomText = "".obs;
  final eventTimeDes = "".obs;
  final weekly = "".obs;
  final tongue = "".obs;
  final bonusAmount = "10".obs;
  final bonusState = 0.obs;
  final showOverlay = false.obs;
  TextEditingController? exChangeCurrencyTextController;
  final ScrollController exchangeCurrscrollController = ScrollController(initialScrollOffset: 0.0);
  final openState = false.obs;/// 活动是否开启
  late Timer _timer;
  int hour = 0;
  final parts = <String>[].obs;
  final isRoundRequest = false.obs;
  String symbol = LangUtil().isZhCn()?'、':', ';

  @override
  void onInit() {
    super.onInit();
    exChangeCurrencyTextController = TextEditingController();
    initExchangeData();
    var arguments = Get.arguments;
    if (arguments != null) {
      if (arguments.containsKey('pid')) {
        pid = arguments['pid'];
      }
    }

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (redPacketDetail['period'] != null) {
        getPeriodTimeV2(
            "${redPacketDetail['period']?[0]?['t']}", "${redPacketDetail['period']?[0]?['d']}");
      }
    });

    ever(globalController.currTypeSelected, (callback) => {getBonus()});
  }

  @override
  void onReady() {
    super.onReady();
    /// 红包详情
    getRedDetail();
    ///红包奖金
    getBonus();
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
  /// 1、红包奖金
  Future<void> getBonus() async {
    // 这里走的是假数据，推代码的时候需要被注释
    // {
    //   // bonusState : 1 本场红包已被领完
    //   // bonusState : 2 本场红包已参与
    //   // bonusState : 3 立即领取
    //   // bonusState.value = 1;//result['state'];
    //   // bonusAmount.value = "100";//result['amount'];
    //   // tongue.value = "";// 从没有领过红包
    //   // tongue.value = "pt_BR";//result['tongue'];
    //   // tongue.value = "vi_VN";//result['tongue'];
    //   // tongue.value = "th_TH";//result['tongue'];
    //   // tongue.value = "en_US";//result['tongue'];
    //   // tongue.value = "hi_IN";//result['tongue'];
    //   // tongue.value = "zh_CN";//result['tongue'];
    //   // openState.value = true;
    //   // isRoundRequest.value = false;
    //   // showOverlay.value = true;
    // }return;// 先暂时不准兑换红包，方便调试。推代码的时候进行注释

    if (isRoundRequest.value) {
      return;
    }
    isRoundRequest.value = true;
    await ApiService.instance.bonus(
        success: (result) {

          print('Jobs.state      ${result['state']}');
          print('Jobs.amount     ${result['amount']}');
          print('Jobs.tongue     ${result['tongue']}');

          print(bonusAmount.value);
          // bonusState : 1 本场红包已被领完
          // bonusState : 2 本场红包已参与
          // bonusState : 3 立即领取
          bonusState.value = result['state'];
          // 红包金额
          bonusAmount.value = result['amount'];
          // tongue : "pt_BR"; 葡萄牙语
          // tongue : "vi_VN"; 越南语
          // tongue : "th_TH"; 泰语
          // tongue : "en_US"; 英语
          // tongue : "hi_IN"; 印地语
          // tongue : "zh_CN"; 中文
          tongue.value = result['tongue'];
          isRoundRequest.value = false;
          showOverlay.value = false;// 这个值为false的时候，才走点击事件
        },
        pid: pid,
        currencyId: globalController.currTypeSelected.value.cur,
        fail: (String? message) {
          isRoundRequest.value = false;
        });
  }
  /// 2、红包详情
  Future<void> getRedDetail() async {
    // 这里走的是假数据，推代码的时候需要被注释
    // {
    //   // bonusState : 1 本场红包已被领完
    //   // bonusState : 2 本场红包已参与
    //   // bonusState : 3 立即领取
    //   bonusState.value = 3;//result['state']; /// ✅ 这三个值显示的正中间红包UI正常 这里只能是1、本场红包已被领完 和 2、本场红包已参与。状态3需要手动点击
    //   bonusAmount.value = "315";//result['amount'];
    //   // tongue.value = "";// 从没有领过红包
    //   tongue.value = "pt_BR";//result['tongue'];
    //   // tongue.value = "vi_VN";//result['tongue'];
    //   // tongue.value = "th_TH";//result['tongue'];
    //   // tongue.value = "en_US";//result['tongue'];
    //   // tongue.value = "hi_IN";//result['tongue'];
    //   // tongue.value = "zh_CN";//result['tongue'];
    //   showOverlay.value = false;// 这个值为false的时候，才走点击事件
    //   openState.value = true;
    //   isRoundRequest.value = false;
    // }return;// 先暂时不准兑换红包，方便调试。推代码的时候进行注释

    await ApiService.instance.redDetail(
        success: (details) {
          var date = details['date'];
          ruleType.value = details['rule_type'];
          dataTrans(date['base'], 'base');
          dataTrans(date['custom'], 'custom');
          term.value = getTerm(details['detail']);
          redPacketDesc(term.value);
          imageUrl.value = getImage(details['images']);
          bottomText.value = getBottomText(details['button']['text']);
          weekly.value = getWeekly(date['weekly']);
          eventTimeDes.value =
              "${l10n.S.current.random_text_987}${date['monthly']?[0]}${l10n.S.current.random_text_988}${l10n.S.current.random_text_719}${date['monthly']?[1]}${l10n.S.current.random_text_988}";
          if (LangUtil().isTh()) {
            eventTimeDes.value =
                l10n.S.current.random_text_988cpoy2(date['monthly']?[0], date['monthly']?[1]);
          } else if (LangUtil().isPtBr()) {
            eventTimeDes.value = "De ${date['monthly']?[0]} a ${date['monthly']?[1]} de cada mês";
          } else if (LangUtil().isHiIN()) {
            eventTimeDes.value =
                "प्रत्येक माह की ${date['monthly']?[0]} से ${date['monthly']?[1]} तारीख तक";
          }else if (LangUtil().isViVn()) {
            eventTimeDes.value =
            "${l10n.S.current.random_text_987}${date['monthly']?[0]}${l10n.S.current.random_text_988}${l10n.S.current.random_text_719}${date['monthly']?[1]} Hàng Tháng";
          }else if (LangUtil().isEnIn()) {
            eventTimeDes.value =
            "From the ${date['monthly']?[0]}st to the ${date['monthly']?[1]}th of each month";
          }
          // time.value = "${ details['display_time']['s']}  - ${details['display_time']['e']}" ;
          time.value =
              "${ActivityBizHelper.getTimeFormat(details['display_time']['s'])} - ${ActivityBizHelper.getTimeFormat(details['display_time']['e'])}";
          redPacketDetail.value = details;
          periodTime.value = ActivityBizHelper.getTimeFormat(redPacketDetail['period'][0]?['t']);
          getPeriodTimeV2(
              "${redPacketDetail['period'][0]?['t']}", "${redPacketDetail['period'][0]?['d']}");
          periodEndTime.value = (redPacketDetail['period'][0]?['d'] as String).replaceAll("~", "-");

          periodBonusTime.value =
              "${ActivityBizHelper.getTimeFormat(redPacketDetail['period'][1]?['t'])}";
          periodEndBonusTime.value =
              "${(redPacketDetail['period'][1]?['d'] as String).replaceAll("~", "-")}";
        },
        pid: pid,
        fail: (String? message) {});
  }
  /// 红包兑换
  Future<void> getReceive() async {
    // 这里走的是假数据，推代码的时候需要被注释
    // {
    //   // state : 1 本场红包已被领完
    //   // state : 2 本场红包已参与
    //   // state : 3 立即领取
    //   // bonusState.value = 1;//result['state'];
    //   // bonusAmount.value = "100";//result['amount'];
    //   // tongue.value = "pt_BR";//result['tongue'];
    //   // tongue.value = "vi_VN";//result['tongue'];
    //   // tongue.value = "th_TH";//result['tongue'];
    //   // tongue.value = "en_US";//result['tongue'];
    //   // tongue.value = "hi_IN";//result['tongue'];
    //   // tongue.value = "zh_CN";//result['tongue'];
    //   // openState.value = true;
    //   // showOverlay.value = false;
    //   // isRoundRequest.value = false;
    // }return;// 先暂时不准兑换红包，方便调试。推代码的时候进行注释

    // await ApiService.instance.receive(success: (result) {}, pid: pid, fail: (String? message) {});
    redPacketExchange(Get.context!);
  }
  /// 红包兑换 走的是这个
  Future<void> redPacketExchange(
      BuildContext context,
      // CustomButtonController btnCtr,
      ) async {

    // // 这里走的是假数据，推代码的时候需要被注释
    // {
    //   // bonusState : 1 本场红包已被领完
    //   // bonusState : 2 本场红包已参与
    //   // bonusState : 3 立即领取
    //   bonusState.value = 3;//result['state'];
    //   bonusAmount.value = "100";//result['amount'];
    //   tongue.value = "";// 从没有领过红包
    //   // tongue.value = "pt_BR";//result['tongue'];
    //   // tongue.value = "vi_VN";//result['tongue'];
    //   // tongue.value = "th_TH";//result['tongue'];
    //   // tongue.value = "en_US";//result['tongue'];
    //   // tongue.value = "hi_IN";//result['tongue'];
    //   // tongue.value = "zh_CN";//result['tongue'];
    //   openState.value = true;
    //   showOverlay.value = false;
    //   isRoundRequest.value = false;
    // }return;// 先暂时不准兑换红包，方便调试。推代码的时候进行注释

    // btnCtr.showAnimation();
    await ApiService.instance.exchange(
        success: (result) {
          // btnCtr.hideAnimation();
          showOverlay.value = false;
          ///红包奖金
          getBonus();
          /// 兑换成功
          CustomSnackBar.show(l10n.S.current.random_text_96, context,
              preIcon: CustomSnackBarIcons.verifySucceed);
        },
        pid: pid,
        fail: (String? message) {
          // btnCtr.hideAnimation();
          // 兑换失败
          CustomSnackBar.show("${l10n.S.current.random_text_997}$message", context,
              preIcon: CustomSnackBarIcons.verifySucceed);
        },
        currencyId: globalController.currTypeSelected.value.cur ?? "706");
  }
  /// 点击按钮跳转逻辑
  ///  * 处理跳转自定义链接
  ///  * 1.没带http开头的链接，前端自己将当前域名+语言+自定义链接组合成完整的url
  ///  * 2.带了http开头的链接，不需要组合
  ///  * 3.h5的全部在当前页面打开链接
  ///  * 4.PC组合链接当前页面打开，http开头的新标签打开
  void goToPageView() {
    String redirect = redPacketDetail['button']?['redirect'] ?? '';
    int button = redPacketDetail['button']?['button'] ?? 0;
    int button_type = redPacketDetail['button']?['button_type'] ?? 0;
    // 展示方式 button
    // 1、内置页面
    // 2、跳转外部链接
    if (button == 1) {
      // 跳转类型 button_type
      // 1、自定义URL
      // 2、娱乐城
      // 3、体育
      // 4、保险库
      // 5、VIP
      // 6、联盟计画
      // 7、优惠活动
      // 8、在线客服
      if (button_type == 1) {
        ActivityBizHelper.launchBtnURL(redirect);
      } else {
        CustomSportBannerState().customSportBanner_onTap(button_type, redirect,true);
      }
    } else {
      ActivityBizHelper.launchBtnURL(redirect);
    }
  }

  String eventTimeTrans(int timestamp) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var dateTime2 = DateTime.utc(dateTime.year, dateTime.month, dateTime.day, dateTime.hour,
        dateTime.minute, dateTime.second);
    var local = dateTime2.toLocal();
    return TimeUtils.dateTimeToTime(local);
  }

  // getPeriodTime(var timestamp) {
  //   // DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  //   // DateTime dtMinus8Hours = dt.subtract(const Duration(hours: 8));
  //   // int t = dtMinus8Hours.millisecondsSinceEpoch ~/ 1000 ;
  //   //2024-04-06 01:00:00  17:00~17:59
  //   String startTimeMinuteStr = TimeUtils.timeStampToTimeMinute(timestamp);
  //   int startTimeMinute = int.parse(startTimeMinuteStr.isEmpty ? "0" : startTimeMinuteStr); //分
  //
  //   DateTime dt = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true);
  //   int endTimestamp = timestamp, startTimestamp = timestamp;
  //   if (startTimeMinute <= 0) {
  //     DateTime df = dt.add(const Duration(minutes: 59));
  //     endTimestamp = (df.millisecondsSinceEpoch ~/ 1000);
  //   } else {
  //     DateTime df = dt.subtract(const Duration(minutes: 59));
  //     startTimestamp = (df.millisecondsSinceEpoch ~/ 1000); // 减后的时间戳，转为秒级
  //   }
  //   if (TimeUtils.getTimeStampTenDigits() >= startTimestamp &&
  //       TimeUtils.getTimeStampTenDigits() <= endTimestamp) {
  //     openState.value = true;
  //   } else {
  //     openState.value = false;
  //   }
  // }

  getPeriodTimeV2(String t, String d) {
    var start = "0", end = "0";
    if (d.isNotEmpty) {
      if (d.contains("~")) {
        var split = d.split("~");
        start = split[0];
        end = split[1];
      }
    }

    String sTime = "$t ${_addLeadingZero(start)}";
    String eTime = "$t ${_addLeadingZero(end)}";

    var getCurrentTime = _getCurentTime();
    var getStartTime = _getTime(sTime);
    var getEndTime = _getTime(eTime);

    if (getCurrentTime >= getStartTime &&
        getCurrentTime <= getEndTime) {
      openState.value = true;
    } else {
      openState.value = false;
    }
  }
  /// 获取当前时间
  int _getTime(String time) {
    DateTime inputTime = DateTime.parse(time); // 将传入的 time 字符串解析为 DateTime 对象
    var dateTimeToTime;
    // 根据语言选时区
    String timeZones = getTimeZones();
    if (timeZones.isNotEmpty) {
      var detroit = tz.getLocation(timeZones);
      tz.setLocalLocation(detroit);
      DateTime newNowTime = tz.TZDateTime.from(inputTime, detroit); // 使用传入的时间
      dateTimeToTime = TimeUtils.dateTimeToTime(newNowTime);
    } else {
      DateTime nowUtc = inputTime.toUtc(); // 将传入的时间转换为 UTC 时间
      DateTime nowUtc0 = DateTime.utc(nowUtc.year, nowUtc.month, nowUtc.day, nowUtc.hour,
          nowUtc.minute, nowUtc.second); // 将 UTC 时间转换为 UTC+0 时间
      dateTimeToTime = TimeUtils.dateTimeToTime(nowUtc0);
    }return TimeUtils.getTimestamp(dateTimeToTime);
  }


  int _getCurentTime (){
   return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
  // 根据语言选时区
  String getTimeZones() {
    var currentLocale = LangUtil().getLangType();
    switch (currentLocale) {
      case "pt_BR":
        return "Europe/Lisbon";
      case "vi_VN":
        return "Asia/Ho_Chi_Minh";
      case "th_TH":
        return "Asia/Bangkok";
      case "en_US":
        return "Europe/London";
      case "zh_CN":
        return "Asia/Shanghai";
      case "hi_IN":
        return "Asia/Kolkata";
      default:
        return "";
    }
  }

  String _addLeadingZero(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    // 根据条件添加前导零
    return '${hour < 10 ? '0$hour' : hour}:'
        '${minute < 10 ? '0$minute' : minute}';
  }

  dataTrans(List<dynamic> list, String flag) {
    for (var value in list) {
      if (flag == "base") {
        base.add({"time": value, "num": timeTransGetHour(value)});
      } else {
        custom.add({'time': value, 'num': timeTransGetHour(value)});
      }
    }
    base.sort((obj1, obj2) => obj1["num"].compareTo(obj2["num"]));
    custom.sort((obj1, obj2) => obj1['num'].compareTo(obj2['num']));
  }

  String timeTrans(String time) {
    List<String> startTime = ["0", "0"];
    List<String> endTime = ["0", "0"];
    if (time.contains("~")) {
      List<String> splitTime = time.split('~');
      startTime = splitTime[0].split(':');
      endTime = splitTime[1].split(':');
    }
    DateTime now = DateTime.now();
    int startHour = int.parse(startTime[0]);
    int startMinute = int.parse(startTime[1]);
    int endHour = int.parse(endTime[0]);
    int endMinute = int.parse(endTime[1]);
    // 加上UTC时间的小时和分钟，创建UTC时间对象
    DateTime utcStartTime = DateTime.utc(now.year, now.month, now.day, startHour, startMinute, 0);
    DateTime utcEndTime = DateTime.utc(now.year, now.month, now.day, endHour, endMinute, 0);
    // 转为本地时间
    DateTime localStartTime = utcStartTime.toLocal();
    DateTime localEndTime = utcEndTime.toLocal();
    hour = localStartTime.hour;
    return "${localStartTime.hour.toString().padLeft(2, '0')}:${localStartTime.minute.toString().padLeft(2, '0')}-"
        "${localEndTime.hour.toString().padLeft(2, '0')}:${localEndTime.minute.toString().padLeft(2, '0')}";
  }

  int timeTransGetHour(String time) {
    List<String> startTime = ["0", "0"];
    if (time.contains("~")) {
      List<String> splitTime = time.split('~');
      startTime = splitTime[0].split(':');
    }
    int startHour = int.parse(startTime[0]);
    return startHour;
  }

  String getTerm(var detail) {
    String langType = LangUtil().getLangType();
    switch (langType) {
      case "zh_CN":
        return detail['zh_CN'] ?? "";
      case "pt_BR":
        return detail['pt_BR'] ?? "";
      case "vi_VN":
        return detail['vi_VN'] ?? "";
      case "th_TH":
        return detail['th_TH'] ?? "";
      case "en_US":
        return detail['en_US'] ?? "";
      case "hi_IN":
        return detail['hi_IN'] ?? "";
      default:
        return detail['original'] ?? "";
    }
  }

  String getImage(var detail) {
    String langType = LangUtil().getLangType();
    switch (langType) {
      case "zh_CN":
        return detail['zh_CN'] ?? "";
      case "pt_BR":
        return detail['pt_BR'] ?? "";
      case "vi_VN":
        return detail['vi_VN'] ?? "";
      case "th_TH":
        return detail['th_TH'] ?? "";
      case "en_US":
        return detail['en_US'] ?? "";
      case "hi_IN":
        return detail['hi_IN'] ?? "";
      default:
        return detail['original'] ?? "";
    }
  }

  String getBottomText(var detail) {
    String langType = LangUtil().getLangType();
    switch (langType) {
      case "zh_CN":
        return detail['zh_CN'] ?? "";
      case "pt_BR":
        return detail['pt_BR'] ?? "";
      case "vi_VN":
        return detail['vi_VN'] ?? "";
      case "th_TH":
        return detail['th_TH'] ?? "";
      case "en_US":
        return detail['en_US'] ?? "";
      case "hi_IN":
        return detail['hi_IN'] ?? "";
      default:
        return detail['original'] ?? "";
    }
  }
  /// 字符串拼接为周数据
  String getWeekly(var detail) {
    List<String> weekList = [];
    bool friday = detail['friday'];
    bool monday = detail['monday'];
    bool sunday = detail['sunday'];
    bool tuesday = detail['tuesday'];
    bool saturday = detail['saturday'];
    bool thursday = detail['thursday'];
    bool wednesday = detail['wednesday'];
    if (monday) {
      weekList.add(l10n.S.current.random_text_989 + symbol);
    }
    if (tuesday) {
      weekList.add(l10n.S.current.random_text_990 + symbol);
    }
    if (wednesday) {
      weekList.add(l10n.S.current.random_text_991 + symbol);
    }
    if (thursday) {
      weekList.add(l10n.S.current.random_text_992 + symbol);
    }
    if (friday) {
      weekList.add(l10n.S.current.random_text_993 + symbol);
    }
    if (saturday) {
      weekList.add(l10n.S.current.random_text_994 + symbol);
    }
    if (sunday) {
      weekList.add(l10n.S.current.random_text_995 + symbol);
      if (LangUtil().isViVn()) {
        String result = weekList.join('');
        String result1 = result.isNotEmpty ? result.substring(0, result.length - 2) : result;
        return replaceLastCommaWithAnd(result1);
      }
    }

    String result = "${l10n.S.current.random_text_996}${weekList.join('')}";
    String result1 = result.isNotEmpty ? result.substring(0, result.length - (LangUtil().isZhCn()?1:2)) : result;
    return replaceLastCommaWithAnd(result1);
  }
  /// 字符串替换：将最后一个字符替换为"和"
  String replaceLastCommaWithAnd(String input) {
    // 查找最后一个逗号的位置
    int lastCommaIndex = input.lastIndexOf(symbol);
    if (lastCommaIndex == -1) {
      // 如果找不到逗号，直接返回原字符串
      return input;
    }
    // 将最后一个逗号替换为“和”
    return input.substring(0, lastCommaIndex) +
        l10n.S.current.random_text_166 +
        input.substring(lastCommaIndex + 1);
  }
  /// 红包描述
  List<String> redPacketDesc(String? detail) {
    if (detail != null && detail.isNotEmpty) {
      List<String> tempList = detail.split('\n').where((item) => (item.trim().isNotEmpty)).toList();
      parts.assignAll(tempList);
    }return [];
  }
  /// 更新红包描述
  String updateDesc(String desc) {
    if (desc.isNotEmpty) {
      return desc.replaceAllMapped(RegExp(r'(USDT\$\$currency\$\$)'), (match) {
        return "";
      });
    } else {
      return '';
    }
  }
}