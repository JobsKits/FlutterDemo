
import 'package:get/get.dart';

import 'home_common_params.dart.dart';

class NavigationItemInfo {
  ///按钮名称
  RxString title;

  ///跳转路由
  String? route;

  ///按钮标识
  String? tag;

  ///按钮标识
  bool? showTag;

  ///正常情况图标
  String? icon;

  ///类型 枚举
  NavEnum navEnum;

  dynamic data;

  NavigationItemInfo({
    required this.title,
    this.route,
    this.tag,
    this.icon,
    this.showTag,
    this.data,
    this.navEnum = NavEnum.undefine,
  });

  @override
  String toString() {
    return 'NavigationItemInfo{title: $title, route: $route, tag: $tag, showTag: $showTag, icon: $icon, data: $data}';
  } //万能数据
}