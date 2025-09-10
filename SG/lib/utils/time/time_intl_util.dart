import 'package:flutter_bet/services/lang_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

/// 时间国际话统一处理
class TimeIntlUtil {
  //todo: 不需要翻译
  static const pattern_zhCN = "yyyy年MM月dd日";

  ///初始化一下 国际化
  ///在使用任何格式化的方法之前，都应加载环境内容。
  static void initIntl() {
    initializeDateFormatting();
  }

  ///普通的 年月日  格式
  static String getTimeYMD({
    required int? time,
    bool addHms = false,
    bool secondUnit = false,
    String nonStr = "-",
  }) {
    if (time == null) {
      return nonStr;
    }
    var lang = LangService().lang;
    var flag = lang.label;
    var timeValue = secondUnit ? time * 1000 : time;
    var timeDate = DateTime.fromMillisecondsSinceEpoch(timeValue);
    // 泰语 和 印度 使用 28/05/2024

    // zh_CN：2024年6月3日
    // en_US：Jun 3, 2024
    // pt_BR：3 de jun de 2024
    // vi_VN：3 thg 6, 2024
    // th_TH：3 มิ.ย. 2024
    // hi_IN：3 जून 2024
    if (lang == LangType.th || lang == LangType.hi) {
      return !addHms
          ? DateFormat.yMd(flag).format(timeDate)
          : DateFormat.yMd(flag).add_Hms().format(timeDate);
    } else {
      var pattern = "dd/MM/yyyy"; //默认使用英文
      switch (lang) {
        case LangType.zhCN:
          pattern = pattern_zhCN;
          break;
        case LangType.en:
          pattern = 'MMM dd,yyyy';
          break;
        case LangType.vi:
          pattern = "'ngày' dd 'tháng' M,yyyy";
          break;
        case LangType.pt:
          pattern = "dd 'de' MMMM 'de' yyyy";
          break;
        default:
          break;
      }
      return !addHms
          ? DateFormat(pattern, flag).format(timeDate)
          : DateFormat(pattern, flag).add_Hms().format(timeDate);
    }

    // var lang = LangService().lang;
    // switch (lang) {
    //   case LangType.zhCN:
    //     return DateFormat.yMMMd('zh_CN').format(timeDate);
    //   default:
    //     return DateFormat.yMMMd('en_US').format(timeDate);
    // }
    // print("zh_CN：${DateFormat.yMMMd('zh_CN').format(DateTime.now())}");
    // print("en_US：${DateFormat.yMMMd('en_US').format(DateTime.now())}");
    // print("pt_BR：${DateFormat.yMMMd('pt_BR').format(DateTime.now())}");
    // print("vi_VN：${DateFormat.yMMMd('vi_VN').format(DateTime.now())}");
    // print("th_TH：${DateFormat.yMMMd('th_TH').format(DateTime.now())}");
    // print("hi_IN：${DateFormat.yMMMd('hi_IN').format(DateTime.now())}");
    return "";
  }
}
