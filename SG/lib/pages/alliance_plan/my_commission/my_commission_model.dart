import 'package:flutter_bet/utils/date_util.dart';

import '../../../utils/money_util.dart';
import '../../../utils/time/time_utils.dart';
import '../wmodel/alliance_common_params.dart';

///联盟计划-tab-我的佣金界面 item model
class MyCommissionModel {
  String id; //详情id
  int time; //结算时间
  int type; //类型
  double performance; //业绩
  int contributeMans; //贡献人数
  double commission; //佣金

  MyCommissionModel({
    required this.id,
    required this.time,
    required this.type,
    required this.performance,
    required this.contributeMans,
    required this.commission,
  }); //代理佣金

  String getTimeFirst() {
    return DateUtil.formatDateMs(time, format: "dd/MM/yyyy");
  }

  String getTimeSecond() {
    return DateUtil.formatDateMs(time, format: "HH:mm:ss");
  }

  String getTypeName() {
    return TypeEnum.getTypeNme(type);
  }

  ///金额 格式化
  get performanceTo => MoneyUtil.toFormatCny(performance, false);
  get commissionTo => MoneyUtil.toFormatCny(commission, false);
}
