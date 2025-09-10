// To parse this JSON data, do
//
//     final vipFengluConfigModel = vipFengluConfigModelFromJson(jsonString);

// To parse this JSON data, do
//
//     final vipFengluModel = vipFengluModelFromJson(jsonString);

import 'dart:convert';

VipFengluModel vipFengluModelFromJson(String str) => VipFengluModel.fromJson(json.decode(str));

String vipFengluModelToJson(VipFengluModel data) => json.encode(data.toJson());

class VipFengluModel {
  Map<String, bool> nav;
  Map<String, List<VipFengluConfigModel>> data;

  VipFengluModel({
    required this.nav,
    required this.data,
  });

  factory VipFengluModel.fromJson(Map<String, dynamic> json) => VipFengluModel(
        nav: Map.from(json["nav"]).map((k, v) => MapEntry<String, bool>(k, v)),
        data: Map.from(json["data"]).map((k, v) => MapEntry<String, List<VipFengluConfigModel>>(
            k, List<VipFengluConfigModel>.from(v.map((x) => VipFengluConfigModel.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "nav": Map.from(nav).map((k, v) => MapEntry<String, dynamic>(k, v)),
        "data": Map.from(data).map(
            (k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
      };
}

class VipFengluConfigModel {
  int level;
  int cashType;
  String currencyId;
  String amount;

  VipFengluConfigModel({
    required this.level,
    required this.cashType,
    required this.currencyId,
    required this.amount,
  });

  factory VipFengluConfigModel.fromJson(Map<String, dynamic> json) => VipFengluConfigModel(
        level: json["level"],
        cashType: json["cash_type"],
        currencyId: json["currency_id"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "cash_type": cashType,
        "currency_id": currencyId,
        "amount": amount,
      };
}
