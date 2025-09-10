import 'package:flutter/cupertino.dart';

///代理佣金的实体类
class AnnouncementBean {
  AnnouncementBean({
    this.imageProvider,
    this.html,
  });

  AnnouncementBean.fromJson(dynamic json) {
    imageProvider = json['imageProvider'];
    html = json['html'];
  }
  ImageProvider? imageProvider;
  String? html;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['imageProvider'] = imageProvider;
    map['html'] = html;
    return map;
  }
}
