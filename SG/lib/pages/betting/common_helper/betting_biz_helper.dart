import 'dart:developer';

import 'package:flutter_bet/pages/betting/common_model/betting_common_params.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/text_util.dart';
import 'package:get/get.dart';
import 'package:money2/money2.dart';

import '../../../constant/app_themes.dart';
import '../../../generated/l10n.dart';
import '../../../model/sport/sport_bet_list_model.dart';
import '../../../utils/date_util.dart';
import '../../../utils/num_util.dart';
import '../../../widget/custom_text.dart';
import '../../../widget/custom_toast.dart';
import '../../../widget/dialog/dialog_utils.dart';
import '../../../widget/refresh/widget/cupertino/easy_refresh_path.dart';
import '../../sport/sport_detail/model.dart';

///体育投注， 额外业务 小逻辑处理工具类
class BettingBizHelper {
  ///把num类型转成double 类型，也可能出现精度丢失， 建议使用decimal方案
  ///如果计算防止 精度丢失， 建议使用NumUtil 工具类，是基于 decimal。
  static double toDouble(num? num) {
    if (num != null) {
      return num.toDouble();
    } else {
      return 0.00;
    }
  }

  ///处理投注单， 金额小数位数太多， 保留2为小数
  ///为了适配奇葩的代码风格。 使用dynamic 类型
  static String dealBetMoneyFormat(dynamic money, {int? decimals = 2}) {
    if (money is int || money is double) {
      return NumUtil.keepDecimals(money, digits: decimals);
    } else if (money is String) {
      var moneyDouble = double.tryParse(money) ?? 0.00;
      return NumUtil.keepDecimals(moneyDouble, digits: decimals);
    } else {
      return 0.toStringAsFixed(decimals ?? 2);
    }
  }

  ///获取投注信息，主客队名称, 优先显示主队名
  static String getBetInfoTeamNameLabel(M bean) {
    // return '${bean.homeTeamName} - ${bean.awayTeamName}';
    if (bean.htn != null && bean.atn != null) {
      return '${bean.htn} - ${bean.atn}';
    } else if (bean.htn != null && bean.atn == null) {
      return '${bean.htn}';
    } else if (bean.htn == null && bean.atn != null) {
      return '${bean.atn}';
    } else {
      //全部没有
      return '';
    }
  }

  ///  et = 1 显示主客队名称 (维持现状)
  ///  et = 2 显示联赛名称
  ///  int? et;// "et": 2, //1:一般赛事 2:冠军赛
  ///  "cn": "英格兰冠军联赛",
  static String getBetDetailTeamNameLabel(Bi biModel) {
    if (biModel.et == 1) {
      return '${biModel.htn} - ${biModel.atn}';
    } else if (biModel.et == 2) {
      return '${biModel.cn}';
    } else {
      return "";
    }
  }

  ///获取可以复投的列表
  static List<M> getSupportReBettingCount(ListElement? betList) {
    if (betList == null || betList.ms.isEmpty) {
      return [];
    } else {
      List<M> list = betList.ms.where((ms) => isSupportReBetting(ms.reb)).toList();
      return list;
    }
  }

  ///盘口是否开盘中
  static bool isBetOpening(M bean) {
    //todo： 0106 是否显示赔率。原本是这样判断的，widget.bean.es == 1 && widget.bean.os != 0 && widget.bean.rbts != 3
    //应为投注接口 {{sport_url}}{{sport_platId}}/place/betinfo
    //实时更新， 有返回 "os": 1 //盘口状态 0:关盘 1:开盘 2:开盘，但赔率小于1.1不支援串关
    //所以使用该字段来判断
    return bean.os != 0;
  }

  ///盘口是否关闭
  static bool isBetClosed(M bean) {
    //todo： 0106是否显示关闭。原本是这样判断的，widget.bean.rbts == 3 || widget.bean.es == 2 || widget.bean.os == 0
    //还是使用原来的判断
    // return bean.rbts == 3 || bean.es == 2 || bean.os == 0;
    return bean.os == 0 || bean.mls == 0;
  }

  ///投注列表明细， Bi model
  /// int? reb; 是否支持重投 1:支持 0:不支持
  static bool isSupportReBetting(int? reb) {
    return reb == 1;
  }

  ///投注列表明细， Bi model
  ///是否取得串关数量 0:全部 1:只限串关
  ///int? ic;
  static bool isOnlyCollusion(int? ic) {
    return ic == 1;
  }

  ///是否不支持复式投注
  ///3:赔率<1.1，不支援串关
  static bool isUnSupportDuplexBet(M bean) {
    return bean.es == 2 ||
        bean.os == 0 ||
        bean.showState == 2 ||
        bean.ic != 1 ||
        bean.os == 2 ||
        (bean.osDuplex == 3 &&
            double.parse(bean.ov ?? '0') < BettingCommonConfig.unSupportDuplexOv);
  }

  ///根据币种配置，保留小数长度
  ///未登录状态下，待投注项金额输入框内的提示金额显示样式我们统一显示0.00...，
  ///小数的位数根据币种保留的金额小数位数来显示（用暗色的字体颜色）
  static String dealSingleInputDecimal(num? amount, int decimalLength) {
    if (amount == null || amount == 0) {
      return 0.toStringAsFixed(decimalLength);
    }
    return amount.toString();
  }

  static String dealSingleInputDecimalWithStr(String? input, int decimalLength) {
    if (input == null || input == '0' || input == '0.') {
      return 0.toStringAsFixed(decimalLength);
    } else {
      //会丢失精度
      return NumUtil.keepDecimals(double.parse(input), digits: decimalLength, do45: false);
      return double.parse(input).toStringAsFixed(decimalLength);
    }
  }

  //复制 并提示
  static void onClickCopyToast(String? content, {bool showToast = true}) {
    Clipboard.setData(ClipboardData(text: content));
    if (showToast) {
      CustomToast.show(S.current.random_text_151, Get.overlayContext!);
    }

    // log("复制成功");
  }

  //复制 并提示
  static void onClickCopyTip(
      {required GlobalKey globalKey, required String? content, String? message}) {
    Clipboard.setData(ClipboardData(text: content));
    DialogUtils.showCustomBubbleCopyDialog(
      Get.overlayContext!,
      Padding(
        padding: const EdgeInsets.all(3.0),
        child: CustomText(
          message ?? S.current.successfullyCopi,
          textColorStyle: CustomTextColorStyle.dark,
        ),
      ),
      250,
      key: globalKey,
      backgroundColor: AppThemes.widgetColorWhite,
      bubbleArrowHeight: 6,
      bubbleArrowWidth: 8,
      arrowBasisOffset: -50.0,
    );
  }

  ///娱乐城 我的投注- 对话框详情的投注时间格式
  static String getDialogCasinoDetailBetTime(int? betTime) {
    if (betTime != null && betTime > 0) {
      String ymd = DateUtil.formatDateMs(betTime, format: 'yyyy/MM/dd');
      String hm = DateUtil.formatDateMs(betTime, format: 'HH:mm');
      var timeText = "${S.current.random_text_797}$hm $ymd";
      if (LangUtil().isTh()) {
        timeText = "${S.current.random_text_797}$hm $ymd";
      } else if (LangUtil().isEnIn()) {
        timeText = "${S.current.random_text_797} $hm $ymd ";
      }
      return timeText;
    } else {
      return "${S.current.random_text_223} --/--/-- ${S.current.random_text_244} --:--";
    }
  }

  ///把文本千分逗号隔开，3未隔开 14733173030874860000.0
  static String getFormatComma(String? content, {int digit = 3}) {
    // log("content...$content");
    if (content != null && content.isNotEmpty) {
      var formatStr = TextUtil.formatDigitPatternEnd(content, digit: digit, pattern: ',');
      // log("formatStr...$formatStr");
      return formatStr;
    } else {
      return "";
    }
  }

  ///获取 乘数 保留2位小时点
  static String getDetailFactor(String? factor) {
    String factorStr = NumUtil.keepDecimals(double.tryParse(factor ?? "0"),digits: 2);
    return factorStr;
  }
}
