import 'dart:convert';

///活动快捷入口 api mdoel
///{{url}}/member/promo/shortcut
class ActivityQuickApiModel {
  String? id;
  String? name;
  int? state;
  int? ty;
  String? icon;
  List<String>? iconList; //自己定义字段、自己转换
  //新增配置字段
  String? displayType; //展示方式 1:内置页面 2:跳转外部链接
  int? buttonType; //跳转类型 1自定义 2娱乐城 3体育 4保险库 5VIP 6联盟计画 7优惠活动 8在线客服
  String? buttonRedirect;

  ActivityQuickApiModel({
    this.id,
    this.name,
    this.state,
    this.ty,
    this.icon,
    this.displayType,
    this.buttonType,
    this.buttonRedirect,
    this.iconList,
  });

  ///图标转换
  List<String>? iconConvert() {
    iconList = (icon == null) ? [] : List.from(json.decode(icon!));
    return iconList;
  }

  factory ActivityQuickApiModel.fromJson(Map<String, dynamic> json) => ActivityQuickApiModel(
        id: json["id"],
        name: json["name"],
        state: json["state"],
        ty: json["ty"],
        icon: json["icon"],
        displayType: json["display_type"],
        buttonType: json["button_type"],
        buttonRedirect: json["button_redirect"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "state": state,
        "ty": ty,
        "icon": icon,
        "display_type": displayType,
        "button_type": buttonType,
        "button_redirect": buttonRedirect,
      };
}
