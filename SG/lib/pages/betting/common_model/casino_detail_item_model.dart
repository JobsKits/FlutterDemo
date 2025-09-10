import 'package:flutter/material.dart';

///娱乐城- 我的投注 - 对话框，投注详情中的 底部item
class CasinoDetailItemModel {
  String? label;
  String? content;
  bool showLabel; //是否显示label 行
  bool showAction; //右边 交互icon
  ContentActionEnum actionEnum;
  Color? contentColor;
  Color? iconColor;

  CasinoDetailItemModel({
    this.label,
    this.content,
    this.showLabel = true,
    this.showAction = true,
    this.actionEnum = ContentActionEnum.copy,
    this.contentColor,
    this.iconColor,
  });
}

///对话框 ，里面的 item  右边的action 类型
enum ContentActionEnum {
  // none(type: 0, icon: ""),//不显示图标
  multiplier(type: 1, icon: "assets/images/common/ic_common_multiplier_gray.webp"), //乘数
  remainder(type: 2, icon: "assets/images/common/ic_common_remainder_gray.webp"), //获胜机率
  loop(type: 3, icon: "assets/images/common/ic_common_loop_gray.webp"), //掷小于
  copy(type: 4, icon: "assets/images/common/ic_common_copy_gray.webp"); //复制

  final int type;
  final String icon;

  const ContentActionEnum({required this.type, required this.icon});

  bool isActionCopy(){
    return this == copy;
  }
}
