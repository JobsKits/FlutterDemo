import 'package:intl/intl.dart';

class DateTimeUtils {
  /// 将 ISO 8601 格式的时间字符串转换为 "年:月:日 时:分:秒" 的格式
  static String formatDateTime(String isoDateTime,
      {String? temp = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      // 解析 ISO 8601 时间字符串
      DateTime dateTime = DateTime.parse(isoDateTime);

      // 格式化日期和时间
      String formattedDateTime = DateFormat(temp).format(dateTime);

      return formattedDateTime;
    } catch (e) {
      // 返回错误信息
      return 'Invalid date format';
    }
  }

  /// 获取 [daysAgo] 天前当前时间到现在的时间范围
  static Map<String, int> getTimeRange(int daysAgo) {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day).toLocal();
    DateTime startTime;
    DateTime endTime;
    if (daysAgo == 0) {
      startTime = todayStart;
      endTime = now;
    } else if (daysAgo == 1) {
      startTime = todayStart.subtract(Duration(days: 1));
      endTime = todayStart.subtract(Duration(seconds: 1));
    } else {
      startTime = todayStart.subtract(Duration(days: daysAgo));
      endTime = now;
    }

    // 返回开始时间和结束时间的时间戳（毫秒）
    return {
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
    };
  }

  /// 将时间戳转换为 yyyy-MM-dd HH:mm:ss 格式的日期字符串
  static String formatTimestamp(
    int timestamp, {
    String? temp = 'yyyy-MM-dd HH:mm:ss',
  }) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateFormat formatter = DateFormat(temp);
    return formatter.format(date);
  }
}
