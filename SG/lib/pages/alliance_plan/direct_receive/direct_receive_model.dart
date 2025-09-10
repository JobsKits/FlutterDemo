class ReceiveDirectlyModel {
  int time; //统计时间
  String account; //账号
  double total; //领取总额
  double activity; //活动
  double betrayal; // 反水
  double commission; //代理佣金

  ReceiveDirectlyModel({
    required this.time,
    required this.account,
    required this.total,
    required this.activity,
    required this.betrayal,
    required this.commission,
  }); //代理佣金
}
