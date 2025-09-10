// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'sport_handicap.dart';

///获取列表投注項  -  盘口类型 - 下拉框  model
///{{sport_url}}{{sport_platId}}/bettype/filter
///网络接收接口
class SportHandicapApiModel {
  List<HandicapSiModel>? d;

  SportHandicapApiModel({
    this.d,
  });

  factory SportHandicapApiModel.fromJson(Map<String, dynamic> json) => SportHandicapApiModel(
    d: json["d"] == null ? [] : List<HandicapSiModel>.from(json["d"]!.map((x) => HandicapSiModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "d": d == null ? [] : List<dynamic>.from(d!.map((x) => x.toJson())),
  };
}

///球种对应的盘口；
class HandicapSiModel {
  int? si; //球种Id
  List<Handicap>? btl;

  HandicapSiModel({
    this.si,
    this.btl,
  });

  factory HandicapSiModel.fromJson(Map<String, dynamic> json) => HandicapSiModel(
    si: json["si"],
    btl: json["btl"] == null ? [] : List<Handicap>.from(json["btl"]!.map((x) => Handicap.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "btl": btl == null ? [] : List<dynamic>.from(btl!.map((x) => x.toJson())),
  };
}


