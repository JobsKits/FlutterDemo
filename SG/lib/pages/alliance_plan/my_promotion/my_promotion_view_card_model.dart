import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../wmodel/alliance_common_params.dart';

///联盟计划-tab-我的推广界面-数据详情card model
class MyPromotionCardItemModel {
  bool isTitle;
  String label;
  String content;
  String? contentSub;//后面的 显示233.00 /23人
  ContentType contentType;
  ColorType? colorType;
  AlliancePageEnum? actionPage;
  dynamic data; //额外数据

  MyPromotionCardItemModel({
    this.isTitle = false,
    required this.label,
    required this.content,
    this.contentSub,
    this.contentType = ContentType.text,
    this.colorType,
    this.actionPage,
  });

  ///是否是 金额带coin
  bool isMoneyWithCoin() {
    return contentType == ContentType.moneyWithCoin;
  }

  ///是否显示,//后面的 显示233.00 /23人
  bool isShowContentSub(){
    return contentSub!=null && contentSub!.isNotEmpty;
  }
}

enum ContentType {
  text, //普通文本
  moneyWithCoin, //金额带 货币图标
}

enum ColorType {
  //是否切换不同颜色，比如总输/赢。
  colorSwitch(0, Colors.white),
  white(1, Colors.white),
  yellow(2, Color(0xFFFF9800)),
  green(3, Color(0xFF1FFF20));


  final int type;
  final Color color;

  const ColorType(this.type, this.color);
}
