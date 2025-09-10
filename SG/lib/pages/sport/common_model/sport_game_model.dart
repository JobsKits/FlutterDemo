

///联赛列表
///体育赛事二级列表的model
///接口：competition/list
///范例：
///  List<SportGameModel>? hot;
//   List<SportGameModel>? list;
class SportGameModel {
  String? pgid;
  String? pgn;
  String? ppic;
  int? c; //总数
  List<SportGameItemModel>? cl;

  SportGameModel({
    this.pgid,
    this.pgn,
    this.ppic,
    this.c,
    this.cl,
  });

  factory SportGameModel.fromJson(Map<String, dynamic> json) => SportGameModel(
    pgid: json["pgid"],
    pgn: json["pgn"],
    ppic: json["ppic"],
    c: json["c"],
    cl: json["cl"] == null ? [] : List<SportGameItemModel>.from(json["cl"]!.map((x) => SportGameItemModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pgid": pgid,
    "pgn": pgn,
    "ppic": ppic,
    "c": c,
    "cl": cl == null ? [] : List<dynamic>.from(cl!.map((x) => x.toJson())),
  };
}

class SportGameItemModel {
  String? ci;
  String? cn;
  int? c;

  SportGameItemModel({
    this.ci,
    this.cn,
    this.c,
  });

  factory SportGameItemModel.fromJson(Map<String, dynamic> json) => SportGameItemModel(
    ci: json["ci"],
    cn: json["cn"],
    c: json["c"],
  );

  Map<String, dynamic> toJson() => {
    "ci": ci,
    "cn": cn,
    "c": c,
  };
}
