import 'dart:convert';

SportMenuModel sportMenuModelFromJson(String str) => SportMenuModel.fromJson(json.decode(str));

String sportMenuModelToJson(SportMenuModel data) => json.encode(data.toJson());

class SportMenuModel {
  List<Menu> menu;
  List<All> all;
  int rbc;

  SportMenuModel({
    required this.menu,
    required this.all,
    required this.rbc,
  });

  factory SportMenuModel.fromJson(Map<String, dynamic> json) => SportMenuModel(
    menu: json["menu"]==null?[]:List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
    all: json["all"]==null?[]:List<All>.from(json["all"].map((x) => All.fromJson(x))),
    rbc: json["rbc"],
  );

  Map<String, dynamic> toJson() => {
    "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
    "all": List<dynamic>.from(all.map((x) => x.toJson())),
    "rbc": rbc,
  };


}

class All {
  int si;
  String sn;
  String spic;

  All({
    required this.si,
    required this.sn,
    required this.spic,
  });

  factory All.fromJson(Map<String, dynamic> json) => All(
    si: json["si"],
    sn: json["sn"],
    spic: json["spic"],
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "sn": sn,
    "spic": spic,
  };
}

class Menu {
  String name;
  int menu_id;
  List<MenuList> list;

  Menu({
    required this.name,
    required this.menu_id,
    required this.list,
  });

  ///list 空处理
  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
    name: json["name"],
    menu_id: json["menu_id"],
    list: json["list"]==null?[]: List<MenuList>.from(json["list"].map((x) => MenuList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "menu_id": menu_id,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };

}

class MenuList {
  int si;
  String sn;
  String spic;
  List<ListList> list;

  MenuList({
    required this.si,
    required this.sn,
    required this.spic,
    required this.list,
  });

  factory MenuList.fromJson(Map<String, dynamic> json) => MenuList(
    si: json["si"],
    sn: json["sn"],
    spic: json["spic"],
    list:  json["list"]==null?[]: List<ListList>.from(json["list"].map((x) => ListList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "sn": sn,
    "spic": spic,
    "list": List<dynamic>.from(list.map((x) => x.toJson())),
  };
}

class ListList {
  String ci;
  String cn;
  String cpic;
  String pgid;

  ListList({
    required this.ci,
    required this.cn,
    required this.cpic,
    required this.pgid,
  });

  factory ListList.fromJson(Map<String, dynamic> json) => ListList(
    ci: json["ci"],
    cpic: json["cpic"],
    cn: json["cn"],
    pgid: json["pgid"],
  );

  Map<String, dynamic> toJson() => {
    "ci": ci,
    "cn": cn,
    "pgid": pgid,
    "cpic": cpic,
  };
}

class Rbl {
  int si;
  String sn;
  int c;

  Rbl({
    required this.si,
    required this.sn,
    required this.c,
  });

  factory Rbl.fromJson(Map<String, dynamic> json) => Rbl(
    si: json["si"],
    sn: json["sn"],
    c: json["c"],
  );

  Map<String, dynamic> toJson() => {
    "si": si,
    "sn": sn,
    "c": c,
  };
}
