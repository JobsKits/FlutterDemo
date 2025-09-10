// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<ActivitySidebarApiModel> sidebarFromJson(String str) => List<ActivitySidebarApiModel>.from(
    json.decode(str).map((x) => ActivitySidebarApiModel.fromJson(x)));

String sidebarToJson(List<ActivitySidebarApiModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

///活动侧边栏 api model
class ActivitySidebarApiModel {
  String? id;
  String? name;
  String? icon;
  int? ty;
  int? state;

  //新增配置字段
  String? displayType; //展示方式 1:内置页面 2:跳转外部链接
  int? buttonType; //跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  String? buttonRedirect;

  ActivitySidebarApiModel({
    this.id,
    this.name,
    this.icon,
    this.ty,
    this.state,
    this.displayType,
    this.buttonType,
    this.buttonRedirect,
  });

  factory ActivitySidebarApiModel.fromJson(Map<dynamic, dynamic> json) => ActivitySidebarApiModel(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
        ty: json["ty"],
        state: json["state"],
        displayType: json["display_type"],
        buttonType: json["button_type"],
        buttonRedirect: json["button_redirect"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
        "ty": ty,
        "state": state,
        "display_type": displayType,
        "button_type": buttonType,
        "button_redirect": buttonRedirect,
      };

  @override
  String toString() {
    return 'ActivitySidebarApiModel{id: $id, name: $name, icon: $icon, ty: $ty, state: $state}';
  }
}
