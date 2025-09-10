// To parse this JSON data, do
//
//     final sportTabModel = sportTabModelFromJson(jsonString);

import 'dart:convert';

SportTabModel sportTabModelFromJson(String str) => SportTabModel.fromJson(json.decode(str));

String sportTabModelToJson(SportTabModel data) => json.encode(data.toJson());

class SportTabModel {
  String? icon;
  String? selectedIcon;
  int? count;
  String? name;
  bool? selected;
  String? tgn;
  int? tgi;

  SportTabModel({
    this.icon,
    this.selectedIcon,
    this.count,
    this.name,
    this.selected,
    this.tgn,
    this.tgi,
  });

  factory SportTabModel.fromJson(Map<String, dynamic> json) => SportTabModel(
    icon: json["icon"] ?? '',
    selectedIcon: json["selectedIcon"] ?? '',
    count: json["count"] ?? 0,
    name: json["name"] ?? '',
    selected: json["selected"],
    tgn: json["tgn"] ?? '',
    tgi: json["tgi"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "selectedIcon": selectedIcon,
    "icon": icon,
    "count": count,
    "name": name,
    "selected": selected,
  };
}

