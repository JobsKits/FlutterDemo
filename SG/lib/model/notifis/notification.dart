// To parse this JSON data, do
//
//     final notifsInfo = notifsInfoFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/transactions/wallet.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/money_util.dart';

NotifsInfo notifsInfoFromJson(String str) => NotifsInfo.fromJson(json.decode(str));

class NotifsInfo {
  String id;
  String type;
  String title;
  String content;
  int isRead;
  int timestamp;
  String target;
  String targetId;
  String payload;

  NotifsInfo({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.isRead,
    required this.timestamp,
    required this.target,
    required this.targetId,
    required this.payload,
  });

  factory NotifsInfo.fromJson(Map<String, dynamic> json) => NotifsInfo(
        id: json["id"],
        type: json["type"],
        title: json["title"],
        content: json["content"],
        isRead: json["is_read"],
        timestamp: json["timestamp"],
        target: json["target"],
        targetId: json["target_id"],
        payload: json["payload"],
  );

  /// 消息类型icon
  /// return: icon路径/货币名字(如:USDT)
  String get typeNameAsset {
    // 失败
    if(title == "withdraw_fail" || title == "deposit_fail") {
      return "assets/images/snack_bar/ic_snack_bar_error.png";
    }
    // 进行中 (返回货币名称用于查找icon)
    if(title == "withdraw_in_process" || title == "deposit_in_process") {
      if(trWalletModel != null) {
        return trWalletModel!.currencyName;
      }
    }
    return "assets/images/snack_bar/ic_snack_bar_commission_success.webp";
  }

  /// 是否有未读消息
  bool get isUnread {
    // 1 未读，2 已读
    return isRead == 1;
  }

  /// title
  String get itemTitle {
    switch (title) {
      case "withdraw_success":
        return S.current.random_text_782;
      case "withdraw_fail":
        return S.current.random_text_783;
      case "withdraw_in_process":
        return S.current.random_text_789;
      case "deposit_success":
        return S.current.random_text_784;
      case "deposit_fail":
        return S.current.random_text_785;
      case "deposit_in_process":
        return S.current.random_text_786;
      default:
        return "";
    }
  }

  /// content
  String get itemContent {
    if(title == "deposit_success") {
      return S.current.random_text_790;
    }
    return itemTitle;
  }

  /// 列表内容
  List<String> get contentInfos {

    List<String> textInfos = [];
    // finance处理
    if(type == "finance" && trWalletModel != null) {
      // 默认语序: 金额 货币icon
      textInfos.add(S.current.vault_amount);
      textInfos.add(amountTitle);
      textInfos.add(trWalletModel!.currencyName);

      // // (泰语)语序处理: 金额 你好 货币icon 状态
      // if(LangUtil().isTh() || LangUtil().isViVn()) {
      //   textInfos = [];
      //   textInfos.add(amountTitle);
      //   textInfos.add(trWalletModel!.currencyName);
      //   textInfos.add(S.current.random_text_796);
      //   // textInfos.add(itemContent.toLowerCase());
      // }
      //
      // // (越南)语序处理,转小写字母: 金额 你好 货币icon 状态
      // if(LangUtil().isViVn()) {
      //   textInfos = [];
      //   textInfos.add(amountTitle);
      //   textInfos.add(trWalletModel!.currencyName);
      //   textInfos.add(S.current.random_text_796.toLowerCase());
      //   // textInfos.add(itemContent.toLowerCase());
      // }

      return textInfos;
    }

    return content.split(",");
  }


  /// 日期title
  String get timeTitle {
    return CommonUtil.getLocalRecentTime(timestamp);
  }

  /// 存取款数据模型
  TrWalletModel? get trWalletModel {
    if(payload.isEmpty || payload == "") {
      return null;
    }
    return TrWalletModel.fromJson(json.decode(payload));
  }

  /// 存取款金额值获取
  String get amountTitle {
    return MoneyUtil.toCoinAmountFormat(trWalletModel?.currencyId, trWalletModel?.amountTitle);
  }

}
