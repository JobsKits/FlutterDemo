///代理佣金的实体类
class AgentCommissionBean {
  AgentCommissionBean({
    this.code,
    this.receiveRebate,
    this.rebate,
    this.rebateSum,
  });

  AgentCommissionBean.fromJson(dynamic json) {
    code = json['code'];
    receiveRebate = json['receive_rebate'];
    rebate = json['rebate'];
    rebateSum = json['rebate_sum'];
  }
  num? code;
  num? receiveRebate;
  num? rebate;
  num? rebateSum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['receive_rebate'] = receiveRebate;
    map['rebate'] = rebate;
    map['rebate_sum'] = rebateSum;
    return map;
  }
}
