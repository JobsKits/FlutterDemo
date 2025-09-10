

import 'betting_common_params.dart';

class BetSlipTypeModel {
  // int typeId; //0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
  // int index;// 页面位置索引
  BettingTypeEnum type;
  String? icon;
  String title;
  String? count;
  bool isEnable;//是否可用，不可用置灰并且不可点击
  bool isHide;//是否隐藏

  BetSlipTypeModel({
    required this.title,
    this.icon,
    this.count,
    required this.type,
    this.isEnable = true,
    this.isHide =false ,
  });

  @override
  String toString() {
    return 'BetSlipTypeModel{type: $type, icon: $icon, title: $title, count: $count, isEnable: $isEnable, isHide: $isHide}';
  }
}