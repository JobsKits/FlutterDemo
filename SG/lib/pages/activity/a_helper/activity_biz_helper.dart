import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/pages/alliance/index/view.dart';
import 'package:flutter_bet/services/lang_service.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/wallet/CurrencyBean.dart';
import '../../../utils/date_util.dart';
import '../../../utils/num_util.dart';
import '../../../utils/url_launch_util.dart';
import '../../../widget/custom_toast.dart';
import '../../alliance_plan/alliance_plan_view.dart';
import '../a_model/activity_common_params.dart';
import '../all_promotions/all_promotions_view.dart';

///活动模块 公共的 逻辑处理 辅助类
class ActivityBizHelper {
  ///时间转换
  ///结束于 20:56 2024/2/12
  static String getFormatTime(int? time, {bool isSec = true}) {
    if (time != null) {
      return DateUtil.formatDateMs(time * (isSec ? 1000 : 1), format: 'HH:mm dd/MM/yyyy');
    } else {
      return "";
    }
  }

  ///一行显示
  static String getTimeFormatOneLines(int? time,
      {bool secondUnit = false, String emptyStr = '--'}) {
    return time != null
        ? DateUtil.formatDateMs(secondUnit ? time * 1000 : time, format: 'yyyy/MM/dd HH:mm:ss')
        : emptyStr;
  }

  /// 显示 2024/03/18. 红包时间格式
  static String getTimeFormat(String? timeStr) {
    if (timeStr != null) {
      return DateUtil.formatDateStr(timeStr, format: "yyyy/MM/dd");
    } else {
      return "";
    }
  }

  /// 显示 2024/03/18.
  static String getIntTimeFormat(int? time, {bool secondUnit = true}) {
    if (time != null) {
      return DateUtil.formatDateMs(secondUnit ? time * 1000 : time, format: 'yyyy/MM/dd');
    } else {
      return "";
    }
  }

  /// 显示 2024-03-18.
  static String getIntTimeFormat2(int? time, {bool secondUnit = true}) {
    if (time != null) {
      return DateUtil.formatDateMs(secondUnit ? time * 1000 : time, format: 'yyyy-MM-dd');
    } else {
      return "";
    }
  }

  ///获取邀请人数 的福利 金额, 保留2位
  ///todo:【0529】不需要保留小数点
  static String getRedPacketMoney(String? money) {
    // return NumUtil.keepDecimals(double.tryParse(money ?? '0'), digits: 2);
    return money ?? "0";
  }

  ///是否是外部链接
  /// display_type 展示方式 1:内置页面 2:跳转外部链接
  static bool isOutsideLink(String? disPlayType) {
    return disPlayType == "2";
  }

// * 处理跳转自定义链接
// * 1.没带http开头的链接，前端自己将当前域名+语言+自定义链接组合成完整的url
// * 2.带了http开头的链接，不需要组合
  static void launchBtnURL(String? url, {LaunchMode? launchMode = LaunchMode.inAppWebView}) {
    if (url == null || url.isEmpty) {
      return;
    }
    var launchUrl = "";
    if (url.startsWith("http") || url.startsWith("https")) {
      launchUrl = url;
    } else {
      launchUrl = "${AppValues.defaultBranch.api_url}/${LangService().lang.label}/${url}";
    }
    UrlLaunchUtil.launchURL(launchUrl, mode: launchMode).then((message) {
      if (message.isNotEmpty) {
        CustomToast.show(message, Get.overlayContext!);
      }
    });
  }
}
