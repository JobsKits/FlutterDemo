import '../../../utils/date_util.dart';
import '../../../utils/time/time_format.dart';
import '../../../utils/time/time_utils.dart';

class SportUtil {
  ///时间格式化
  static String getTimeFormat(int? time) {
    // print(time);
    // var dataTime =  DateTime.fromMicrosecondsSinceEpoch(time??0);
    var dataTime = DateTime.fromMillisecondsSinceEpoch(time != null ? time * 1000 : 0);
    return TimeUtils.dateTimeToTime(dataTime, YMDzh);
  }

  ///比较时间
  ///lastTime 上个时间
  ///thisTime , 接口返回的数据是 秒单位
  static List showSortTime(String? lastTimeLabel, int thisTime) {
    // 按照日期时间排序
    var dataList = [true, ""];
    String thisTimeStr = DateUtil.formatDateMs(thisTime * 1000, format: DateFormats.zh_y_mo_d);
    if (lastTimeLabel == null) {
      dataList = [true, thisTimeStr];
    }
    // String lastTimeStr = DateUtil.formatDateMs(lastTime);
    // dates.sort((a, b) => a.compareTo(b));
    // 如果相等就不 显示了， 直接给null
    if (thisTimeStr == lastTimeLabel) {
      dataList = [false, thisTimeStr];
    } else {
      dataList = [true, thisTimeStr];
    }
    return dataList;
  }


}
