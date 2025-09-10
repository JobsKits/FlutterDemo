///联盟计划-拥挤比例tab-详细页面item model
class CommissionRateModel {
  int level; //级别
  String validBet; //有效投注
  String rebateAmount; //佣金比例

  CommissionRateModel({
    required this.level,
    required this.validBet,
    required this.rebateAmount,
  }); //返佣金额
}
