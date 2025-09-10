import 'dart:developer';

import 'package:flutter_bet/utils/date_util.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  initTime();
}

///初始化定时器
initTime() {
  // TimeUtils.
  // var nowTime = DateTime.now();
  // const YMDzh = [yyyy, '年', mm, '月', dd, '日 '];
  //const YMD = [yyyy, '-', mm, '-', dd];
  // var time  = TimeUtils.getCurrentTime(YMD);

  DateTime now = DateTime.now();
  // 获取今天 00:00:00 的时间
  DateTime todayStart = DateTime(now.year, now.month, now.day);
  DateTime tomorrowStart = todayStart.add(const Duration(hours: 22));
  int todayStartTimestamp = todayStart.millisecondsSinceEpoch;
  int tomorrowStartTimestamp = tomorrowStart.millisecondsSinceEpoch;
  final difference = tomorrowStart.difference(now);
  int nowTime = DateUtil.getNowDateMs();
  //'yyyy/MM/dd HH:mm:ss'
  // String nowTimeYmd = DateUtil.formatDateMs(nowTime, format: "yyyy/MM/dd");
  String nowTimeYmd = DateUtil.formatDateMs(nowTime, format: "yyyy/MM/dd HH:mm:ss");

  String nowTimeYmd_hms = DateUtil.formatDateStr(nowTimeYmd, format: 'yyyy/MM/dd HH:mm:ss');

  print("nowTimeYmd:$nowTimeYmd");
  print("nowTimeYmd_hms:$nowTimeYmd_hms");
  print("getNowDateStr:${DateUtil.getNowDateStr()}");
  print("todayStart:${DateUtil.formatDateMs(todayStartTimestamp)}");
  print("tomorrowStart:${DateUtil.formatDateMs(tomorrowStartTimestamp)}");
  var diff;
  if (difference.inHours > 0) {
    diff = difference.inHours;
  } else if (difference.inMinutes > 0) {
    diff = difference.inMinutes;
  }
  print("difference:${diff}");
  print("difference:${difference.inMinutes}");
  // nowTime.difference(endData).inDays;

  initializeDateFormatting();
  print("zh_CN：d：${DateFormat.d('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：EEEE：${DateFormat.EEEE('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：LLLL：${DateFormat.LLLL('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：QQQQ：${DateFormat.QQQQ('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yM：${DateFormat.yM('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMd：${DateFormat.yMd('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMEd：${DateFormat.yMEd('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMMMEd：${DateFormat.yMMMEd('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMMMM：${DateFormat.yMMMM('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMMMMEEEEd：${DateFormat.yMMMMEEEEd('zh_CN').add_Hms().format(DateTime.now())}");

  print("=========================================================");
  print("=========================================================");

  DateFormat dateFormat = DateFormat.yMMMd('zh_CN');
  // dateFormat.useNativeDigits;
  // DateFormat.useNativeDigitsByDefaultFor('zh_CN', true);
  // dateFormat.usesAsciiDigits;

  print("zh_CN：yyyy年MM月dd日：${DateFormat('yyyy年MM月dd日').add_Hms().format(DateTime.now())}");
  print("zh_CN：yMMMd：${DateFormat.yMMMd('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：Hms：${DateFormat.Hms('zh_CN').add_Hms().format(DateTime.now())}");
  print("zh_CN：jms：${DateFormat.jms('zh_CN').add_Hms().format(DateTime.now())}");
  print("en_US：${DateFormat.yMMMd('en_US').add_Hms().format(DateTime.now())}");
  print("pt_BR：${DateFormat.yMMMd('pt_BR').add_Hms().format(DateTime.now())}");
  print("vi_VN：${DateFormat.yMMMd('vi_VN').add_Hms().format(DateTime.now())}");
  print("th_TH：${DateFormat.yMMMd('th_TH').add_Hms().format(DateTime.now())}");
  print("hi_IN：yMMMd：${DateFormat.yMMMd(
    'hi_IN',
  ).add_Hms().format(DateTime.now())}");
  print("hi_IN：yMd：${DateFormat.yMd(
    'hi_IN',
  ).add_Hms().format(DateTime.now())}");
  print("hi_IN：yyyy-MM-dd：${DateFormat('yyyy-MM-dd').add_Hms().format(DateTime.now())}");
  print("hi_IN：dd/MM/yyyy：${DateFormat('dd/MM/yyyy').add_Hms().format(DateTime.now())}");
  print("=========================================================");
  print("=======================目标处理===========================");
  print("=========================================================");
  print("zh_CN：###：${DateFormat('yyyy年MM月dd日', 'zh_CN').add_Hms().format(DateTime.now())}");
  print("en_US：###：${DateFormat('MMM dd,yyyy', 'en_US').add_Hms().format(DateTime.now())}");
  print("vi_VN：${DateFormat('MMM d,yyyy', 'vi_VN').add_Hms().format(DateTime.now())}");
  print("vi_VN：yMd：${DateFormat.yMd('vi_VN').add_LLL().add_Hms().format(DateTime.now())}");
  print("vi_VN：LLL：${DateFormat.LLL('vi_VN').add_Hms().format(DateTime.now())}");
  print("vi_VN：###：${DateFormat("'ngày' dd 'tháng' M,yyyy",'vi_VN').add_Hms().format(DateTime.now())}");
  print("pt_BR：yMMMMd：${DateFormat.yMMMMd('pt_BR').add_Hms().format(DateTime.now())}");
  print("pt_BR：###：${DateFormat("dd 'de' MMMM 'de' yyyy",'pt_BR').add_Hms().format(DateTime.now().subtract(Duration(days: 10)))}");
}
