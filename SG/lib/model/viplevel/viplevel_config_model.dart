// To parse this JSON data, do
//
//     final vipLevelModel = vipLevelModelFromJson(jsonString);

import 'dart:convert';

VipLevelModel vipLevelModelFromJson(String str) => VipLevelModel.fromJson(json.decode(str));

String vipLevelModelToJson(VipLevelModel data) => json.encode(data.toJson());

class VipLevelModel {
  int level;
  int total;
  String upgrade;
  String retain;
  int isDefault;
  int isDelete;
  String multiple;
  int createdAt;
  int updatedAt;

  VipLevelModel({
    required this.level,
    required this.total,
    required this.upgrade,
    required this.retain,
    required this.isDefault,
    required this.isDelete,
    required this.multiple,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VipLevelModel.fromJson(Map<String, dynamic> json) => VipLevelModel(
        level: json["level"],
        total: json["total"],
        upgrade: json["upgrade"],
        retain: json["retain"],
        isDefault: json["is_default"],
        isDelete: json["is_delete"],
        multiple: json["multiple"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "level": level,
        "total": total,
        "upgrade": upgrade,
        "retain": retain,
        "is_default": isDefault,
        "is_delete": isDelete,
        "multiple": multiple,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
