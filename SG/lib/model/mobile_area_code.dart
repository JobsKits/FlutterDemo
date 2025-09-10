// To parse this JSON data, do
//
//     final mobileAreaCodeModel = mobileAreaCodeModelFromJson(jsonString);

import 'dart:convert';

MobileAreaCodeModel mobileAreaCodeModelFromJson(String str) => MobileAreaCodeModel.fromJson(json.decode(str));

String mobileAreaCodeModelToJson(MobileAreaCodeModel data) => json.encode(data.toJson());

class MobileAreaCodeModel {
  String? short;
  String? name;
  String? attr;
  String? id;
  String? en;
  String? tel;
  bool? isSelect;

  MobileAreaCodeModel({
    this.short,
    this.name,
    this.attr,
    this.id,
    this.en,
    this.tel,
    this.isSelect,
  });

  factory MobileAreaCodeModel.fromJson(Map<String, dynamic> json) => MobileAreaCodeModel(
    short: json["short"],
    name: json["name"],
    attr: json["attr"],
    id: json["id"],
    en: json["en"],
    tel: json["tel"],
    isSelect: json["isSelect"],
  );

  Map<String, dynamic> toJson() => {
    "short": short,
    "name": name,
    "attr": attr,
    "id": id,
    "en": en,
    "tel": tel,
    "isSelect": isSelect,
  };
}
