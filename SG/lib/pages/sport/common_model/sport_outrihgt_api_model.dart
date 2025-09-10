// To parse this JSON data, do
//
//     final sportChampionModel = sportChampionModelFromJson(jsonString);

import 'dart:convert';

SportOutRightApiModel sportChampionModelFromJson(String str) =>
    SportOutRightApiModel.fromJson(json.decode(str));

String sportChampionModelToJson(SportOutRightApiModel data) => json.encode(data.toJson());

///冠军赛事列表，接口接收数据model
class SportOutRightApiModel {
  //{"t":0,"d":null}
  int t;
  List<SportOutRightModel>? d;

  SportOutRightApiModel({
    this.t = 0,
    this.d,
  });

  factory SportOutRightApiModel.fromJson(Map<String, dynamic> json) => SportOutRightApiModel(
        t: json["t"],
        d: json["d"] == null
            ? []
            : List<SportOutRightModel>.from(
                json["d"]!.map((x) => SportOutRightModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "t": t,
        "d": d == null ? [] : List<dynamic>.from(d!.map((x) => x.toJson())),
      };
}

/// 冠军赛事 model
class SportOutRightModel {
  // "si": 1, //球种Id
  // "sn": "足球", //球种名称
  // "pgid": "1", //地區id
  // "pgn": "其他", //地区名称
  // "ci": "35405", //聯賽id
  // "cn": "QAtest CHS 华语", //联赛名称
  // "ei": "54089692", //赛事ID
  // "oen": "qatesting", //优胜冠军赛事名称
  // "ed": 1701840600, //赛事开始时间
  // "mc": 1, //盘口數量
  int? si;
  String? sn;
  String? pgid;
  String? pgn;
  String? ci;
  String? cn;
  String? ei;
  String? oen;
  int? ed;
  int? mc;
  List<Ml> ml;

  SportOutRightModel({
    this.si,
    this.sn,
    this.pgid,
    this.pgn,
    this.ci,
    this.cn,
    this.ei,
    this.oen,
    this.ed,
    this.mc,
   required this.ml,
  });

  factory SportOutRightModel.fromJson(Map<String, dynamic> json) => SportOutRightModel(
        si: json["si"],
        sn: json["sn"],
        pgid: json["pgid"],
        pgn: json["pgn"],
        ci: json["ci"],
        cn: json["cn"],
        ei: json["ei"],
        oen: json["oen"],
        ed: json["ed"],
        mc: json["mc"],
        ml: json["ml"] == null ? [] : List<Ml>.from(json["ml"]!.map((x) => Ml.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "si": si,
        "sn": sn,
        "pgid": pgid,
        "pgn": pgn,
        "ci": ci,
        "cn": cn,
        "ei": ei,
        "oen": oen,
        "ed": ed,
        "mc": mc,
        "ml": ml == null ? [] : List<dynamic>.from(ml!.map((x) => x.toJson())),
      };
}

class Ml {
  String? mlid;
  int? bt;
  String? btn;
  int? pid;
  String? pn;
  int? mll;
  int? mls;
  List<OutRightM> ms;

  Ml({
    this.mlid,
    this.bt,
    this.btn,
    this.pid,
    this.pn,
    this.mll,
    this.mls,
   required this.ms,
  });

  factory Ml.fromJson(Map<String, dynamic> json) => Ml(
        mlid: json["mlid"],
        bt: json["bt"],
        btn: json["btn"],
        pid: json["pid"],
        pn: json["pn"],
        mll: json["mll"],
        mls: json["mls"],
        ms: json["ms"] == null ? [] : List<OutRightM>.from(json["ms"]!.map((x) => OutRightM.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mlid": mlid,
        "bt": bt,
        "btn": btn,
        "pid": pid,
        "pn": pn,
        "mll": mll,
        "mls": mls,
        "ms": ms == null ? [] : List<dynamic>.from(ms!.map((x) => x.toJson())),
      };
}

class OutRightM {
  String? wid;
  String? sid;
  String? sn;
  String? hdp;
  dynamic sp;
  String? ov;

  OutRightM({
    this.wid,
    this.sid,
    this.sn,
    this.hdp,
    this.sp,
    this.ov,
  });

  factory OutRightM.fromJson(Map<String, dynamic> json) => OutRightM(
        wid: json["wid"],
        sid: json["sid"],
        sn: json["sn"],
        hdp: json["hdp"],
        sp: json["sp"],
        ov: json["ov"],
      );

  Map<String, dynamic> toJson() => {
        "wid": wid,
        "sid": sid,
        "sn": sn,
        "hdp": hdp,
        "sp": sp,
        "ov": ov,
      };
}
