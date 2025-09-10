import 'dart:convert';

SportHallCountModel sportHallCountModelFromJson(String str) => SportHallCountModel.fromJson(json.decode(str));

String sportHallCountModelToJson(SportHallCountModel data) => json.encode(data.toJson());

class SportHallCountModel {
  int? si;
  String? sn;
  String? spic;
  int? lc;
  int? nc;
  int? c;
  int? cc;
  int? tc;
  int? ec;
  int? oc;
  int? vsc;

  SportHallCountModel({
    this.si,
    this.sn,
    this.lc,
    this.nc,
    this.c,
    this.cc,
    this.spic,
    this.tc,
    this.ec,
    this.oc,
    this.vsc,
  });

  factory SportHallCountModel.fromJson(Map<String, dynamic> json) => SportHallCountModel(
    si: json["si"],
    sn: json["sn"],
    lc: json["lc"],
    nc: json["nc"],
    c: json["c"],
    spic: json["spic"],
    cc: json["cc"],
    tc: json["tc"],
    ec: json["ec"],
    oc: json["oc"],
    vsc: json["vsc"],
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "sn": sn,
    "lc": lc,
    "nc": nc,
    "c": c,
    "cc": cc,
    "spic": spic,
    "tc": tc,
    "ec": ec,
    "oc": oc,
    "vsc": vsc,
  };
}