// To parse this JSON data, do
//
//     final sportOddsModel = sportOddsModelFromJson(jsonString);

import 'dart:convert';

SportOddsModel sportOddsModelFromJson(String str) => SportOddsModel.fromJson(json.decode(str));

String sportOddsModelToJson(SportOddsModel data) => json.encode(data.toJson());

class SportOddsModel {
  List<Wsi>? wsi;
  List<Bi>? bi;
  int? status;
  int? dl;
  List<num>? qck; //todo: 0513 快捷投注金额

  SportOddsModel({
    required this.wsi,
    required this.bi,
    this.status,
    this.dl,
    this.qck,
  });

  factory SportOddsModel.fromJson(Map<String, dynamic> json) => SportOddsModel(
    wsi: json["wsi"] == null ? [] : List<Wsi>.from(json["wsi"]!.map((x) => Wsi.fromJson(x))),
    bi: json["bi"] == null ? [] : List<Bi>.from(json["bi"]!.map((x) => Bi.fromJson(x))),
    status: json["status"],dl: json["dl"],
    qck: json["qck"] == null ? [] : List<num>.from(json["qck"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "wsi": wsi == null ? [] : List<dynamic>.from(wsi!.map((x) => x.toJson())),
    "bi": bi == null ? [] : List<dynamic>.from(bi!.map((x) => x.toJson())),
    "status": status,"dl": dl,
    "qck": qck == null ? [] : List<dynamic>.from(qck!.map((x) => x)),
  };
}

class Bi {
  String wid;
  num maa; //	最大下注额
  num mia; // 最小下注额
  String ov;
  int pt;
  int bc;

  Bi({
    required this.wid,
    required this.maa,
    required this.mia,
    required this.ov,
    required this.pt,
    required this.bc,
  });

  factory Bi.fromJson(Map<String, dynamic> json) => Bi(
    wid: json["wid"],
    maa: json["maa"],
    mia: json["mia"],
    ov: json["ov"],
    pt: json["pt"],
    bc: json["bc"],
  );

  Map<String, dynamic> toJson() => {
    "wid": wid,
    "maa": maa,
    "mia": mia,
    "ov": ov,
    "pt": pt,
    "bc": bc,
  };
}

class Wsi {
  String wid;// 对应到的投注项id
  String new_wid;
  String ov; // 最新赔率
  int os;// os 目前有的状态：  0:关盘 1:开盘 2:不支援串关 3:赔率<1.1，不支援串关

  Wsi({
    required this.wid,
    required this.new_wid,
    required this.ov,
    required this.os,
  });

  factory Wsi.fromJson(Map<String, dynamic> json) => Wsi(
    wid: json["wid"],
    new_wid: json["new_wid"],
    ov: json["ov"],
    os: json["os"],
  );

  Map<String, dynamic> toJson() => {
    "wid": wid,
    "new_wid": new_wid,
    "ov": ov,
    "os": os,
  };
}
