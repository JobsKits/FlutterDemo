// To parse this JSON data, do
//
//     final trOtherModel = trOtherModelFromJson(jsonString);

import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:get/get.dart';

List<TrOtherModel> trOtherModelFromJson(String str) => List<TrOtherModel>.from(json.decode(str).map((x) => TrOtherModel.fromJson(x)));

String trOtherModelToJson(List<TrOtherModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

/// 交易记录-其他ItemModel
class TrOtherModel {
  int state;
  int createdAt;
  String amount;
  String currencyId;
  String cashType;
  String cashTypeName;

  TrOtherModel({
    required this.state,
    required this.createdAt,
    required this.amount,
    required this.currencyId,
    required this.cashType,
    required this.cashTypeName,
  });

  factory TrOtherModel.fromJson(Map<String, dynamic> json) => TrOtherModel(
    state: json["state"],
    createdAt: json["created_at"],
    amount: json["amount"],
    currencyId: json["currency_id"],
    cashType: json["cash_type"],
    cashTypeName: json["cash_type_name"],
  );

  Map<String, dynamic> toJson() => {
    "state": state,
    "created_at": createdAt,
    "amount": amount,
    "currency_id": currencyId,
    "cash_type": cashType,
    "cash_type_name": cashTypeName,
  };

  /// TODO: 状态title
  String get stateTitle {
    final title = [
      "",
    ][state];
    return title;
  }

  /// 金额格式Title
  String get amountTitle {
    return MoneyUtil.toCoinAmountFormat(currencyId, amount);
  }

  /// 货币iconUrl
  String get coinUrlPath {
    final GlobalStateController globalController = Get.find<GlobalStateController>();
    return "${globalController.coinIcDomain}$currencyId.webp";
  }

  /// 日期title
  String get timeTitle {
    // var customFormat = [HH, nn, " ", dd, mm, yyyy];
    // if(LangUtil().isZhCn()) {
    //   customFormat = [HH, nn, " ", yyyy, mm, dd];
    // }
    // return CommonUtil.getLocalTimeTitle(createdAt, cIncludeFormats:[yyyy, mm, dd, HH, nn],
    //     customFormat: customFormat);
    return CommonUtil.getLocalTimeTitle(createdAt, cIncludeFormats:[yyyy, mm, dd, HH, nn, ss]);
  }
}

/*
*       {
        "state": 0,
        "created_at": 1702021571,
        "amount": "1.00000000",
        "currency_id": "707",
        "cash_type": "807",
        "cash_type_name": ""
      },
      {
        "state": 0,
        "created_at": 1702021504,
        "amount": "0.50000000",
        "currency_id": "707",
        "cash_type": "806",
        "cash_type_name": ""
      },
      {
        "state": 0,
        "created_at": 1701866991,
        "amount": "1.00000000",
        "currency_id": "702",
        "cash_type": "817",
        "cash_type_name": ""
      },
*
*
* */