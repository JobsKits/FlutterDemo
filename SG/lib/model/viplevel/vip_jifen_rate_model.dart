// To parse this JSON data, do
//
//     final vipJifenRateModel = vipJifenRateModelFromJson(jsonString);

import 'dart:convert';

VipJifenRateModel vipJifenRateModelFromJson(String str) =>
    VipJifenRateModel.fromJson(json.decode(str));

String vipJifenRateModelToJson(VipJifenRateModel data) => json.encode(data.toJson());

class VipJifenRateModel {
  String key;
  String value;
  int ty;

  VipJifenRateModel({
    required this.key,
    required this.value,
    required this.ty,
  });

  factory VipJifenRateModel.fromJson(Map<String, dynamic> json) => VipJifenRateModel(
        key: json["key"],
        value: json["value"],
        ty: json["ty"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
        "value": value,
        "ty": ty,
      };
}
