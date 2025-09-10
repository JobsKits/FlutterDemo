// To parse this JSON data, do
//
//     final vipRateMultiple = vipRateMultipleFromJson(jsonString);

import 'dart:convert';

VipRateMultiple vipRateMultipleFromJson(String str) => VipRateMultiple.fromJson(json.decode(str));

String vipRateMultipleToJson(VipRateMultiple data) => json.encode(data.toJson());

class VipRateMultiple {
  int gameType;
  String rate;
  int updatedAt;
  String updatedUid;
  String updatedName;

  VipRateMultiple({
    required this.gameType,
    required this.rate,
    required this.updatedAt,
    required this.updatedUid,
    required this.updatedName,
  });

  factory VipRateMultiple.fromJson(Map<String, dynamic> json) => VipRateMultiple(
        gameType: json["game_type"],
        rate: json["rate"],
        updatedAt: json["updated_at"],
        updatedUid: json["updated_uid"],
        updatedName: json["updated_name"],
      );

  Map<String, dynamic> toJson() => {
        "game_type": gameType,
        "rate": rate,
        "updated_at": updatedAt,
        "updated_uid": updatedUid,
        "updated_name": updatedName,
      };
}
