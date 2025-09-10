// To parse this JSON data, do
//
//     final searchSportModel = searchSportModelFromJson(jsonString);

import 'dart:convert';

SearchSportModel searchSportModelFromJson(String str) => SearchSportModel.fromJson(json.decode(str));

String searchSportModelToJson(SearchSportModel data) => json.encode(data.toJson());

class SearchSportModel {
  List<SearchSportModelList>? list;

  SearchSportModel({
    this.list,
  });

  factory SearchSportModel.fromJson(Map<String, dynamic> json) => SearchSportModel(
    list: json["list"] == null ? [] : List<SearchSportModelList>.from(json["list"]!.map((x) => SearchSportModelList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class SearchSportModelList {
  int? si;
  String? sn;
  int? c;
  List<ListList>? list;

  SearchSportModelList({
    this.si,
    this.sn,
    this.c,
    this.list,
  });

  factory SearchSportModelList.fromJson(Map<String, dynamic> json) => SearchSportModelList(
    si: json["si"],
    sn: json["sn"],
    c: json["c"],
    list: json["list"] == null ? [] : List<ListList>.from(json["list"]!.map((x) => ListList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "sn": sn,
    "c": c,
    "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListList {
  String? pgid;
  String? pgn;
  String? ci;
  String? cn;
  String? ei;
  int? ed;
  String? htn;
  String? atn;

  ListList({
    this.pgid,
    this.pgn,
    this.ci,
    this.cn,
    this.ei,
    this.ed,
    this.htn,
    this.atn,
  });

  factory ListList.fromJson(Map<String, dynamic> json) => ListList(
    pgid: json["pgid"],
    pgn: json["pgn"],
    ci: json["ci"],
    cn: json["cn"],
    ei: json["ei"],
    ed: json["ed"],
    htn: json["htn"],
    atn: json["atn"],
  );

  Map<String, dynamic> toJson() => {
    "pgid": pgid,
    "pgn": pgn,
    "ci": ci,
    "cn": cn,
    "ei": ei,
    "ed": ed,
    "htn": htn,
    "atn": atn,
  };
}
