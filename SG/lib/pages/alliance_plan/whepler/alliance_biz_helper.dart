import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../generated/l10n.dart';
import '../../../utils/date_util.dart';
import '../../../widget/custom_toast.dart';

///联盟计划， 小逻辑处理辅助类
class AllianceBizHelper {
  ///是否显示上级
  ///0 = 隐藏
  // 1 = 显示
  static bool isShowAgency(String isShow) {
    return isShow == "1";
  }

  ///时间格式化, 对应特殊情况处理，如果没有时间 或者 为0 ，要显示什么？ 空文本emptyStr
  static String getTimeFormatTwoLines(int? time, bool firstRow, {String emptyStr = '--'}) {
    return firstRow
        ? (time != null && time > 0 ? DateUtil.formatDateMs(time, format: 'dd/MM/yyyy') : emptyStr)
        : (time != null && time > 0
            ? DateUtil.formatDateMs(time ?? 0, format: 'HH:mm:ss')
            : emptyStr);
  }

  ///一行显示
  static String getTimeFormatOneLines(int? time,
      {bool secondUnit = false, String emptyStr = '-'}) {
    return (time != null && time > 0)
        ? DateUtil.formatDateMs(secondUnit ? time * 1000 : time, format: 'yyyy/MM/dd HH:mm:ss')
        : emptyStr;
  }

  ///复制
  static void copyText(String? content,{bool toast=true}) {
    Clipboard.setData(ClipboardData(text: content));
    if(toast)CustomToast.show(S.current.random_text_151, Get.overlayContext!);
  }

  ///获取 等级level 标签
  ///使用网络图片

  static String getVipLevelAsset(int? level, {int maxLevel = 24}) {
    // if (level != null && (level > 0 && level <= maxLevel)) {
    //   return "assets/images/common/vip/ic_common_vip_level_$level.webp";
    // } else if (level != null && level > maxLevel) {
    //   return "assets/images/common/vip/ic_common_vip_level_$maxLevel.webp";
    // } else {
    //   return "assets/images/common/vip/ic_common_vip_level_0.webp";
    // }
    ///"${BranchService().current.asset_url}/images/vip/$vipLevel.webp"
    return "";
  }

  ///获取个人信息 的佣金等级icon
  static String getCommissionLevelAsset(int? level) {
    if (level != null && (level > 0 && level <= 20)) {
      return "assets/images/alliance/level/ic_alliance_commission_level_$level.webp";
    } else if (level != null && level > 20) {
      return "assets/images/alliance/level/ic_alliance_commission_level_20.webp";
    } else {
      return "assets/images/alliance/level/ic_alliance_commission_level_1.webp";
    }
  }
}
