// To parse this JSON data, do
//
//     final vipRebateConfigModel = vipRebateConfigModelFromJson(jsonString);

import 'dart:convert';

VipRebateConfigModel vipRebateConfigModelFromJson(String str) =>
    VipRebateConfigModel.fromJson(json.decode(str));

String vipRebateConfigModelToJson(VipRebateConfigModel data) => json.encode(data.toJson());

class VipRebateConfigModel {
  List<String> menu;
  String t;
  List<String> name;
  List<Datum> data;

  VipRebateConfigModel({
    required this.menu,
    required this.t,
    required this.name,
    required this.data,
  });

  factory VipRebateConfigModel.fromJson(Map<String, dynamic> json) => VipRebateConfigModel(
        menu: List<String>.from(json["menu"].map((x) => x)),
        t: json["t"],
        name: List<String>.from(json["name"].map((x) => x)),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu": List<dynamic>.from(menu.map((x) => x)),
        "t": t,
        "name": List<dynamic>.from(name.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String v;
  List<String> r;

  Datum({
    required this.v,
    required this.r,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        v: json["v"],
        r: List<String>.from(json["r"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "v": v,
        "r": List<dynamic>.from(r.map((x) => x)),
      };
}
