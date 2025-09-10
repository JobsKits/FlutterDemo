// ignore_for_file: non_constant_identifier_names

class AgentCenterMemberDataBean {
  AgentCenterMemberDataBean({
    this.cust_count,
    this.day_active_count,
    this.day_charge_amount,
    this.mon_active_count,
    this.mon_charge_amount,
    this.mon_invalid_active_count,
    this.mon_register_count,
    this.profie_amount,
    this.today_register_count,
  });

  num? mon_charge_amount;
  num? day_active_count;
  num? cust_count;
  num? today_register_count;
  num? mon_register_count;
  num? mon_active_count;
  num? day_charge_amount;
  num? mon_invalid_active_count;
  num? profie_amount;

  AgentCenterMemberDataBean.fromJson(dynamic json) {
    mon_charge_amount = json['mon_charge_amount'];
    day_active_count = json['day_active_count'];
    cust_count = json['cust_count'];
    today_register_count = json['today_register_count'];
    mon_register_count = json['mon_register_count'];
    mon_active_count = json['mon_active_count'];
    day_charge_amount = json['day_charge_amount'];
    mon_invalid_active_count = json['mon_invalid_active_count'];
    profie_amount = json['profie_amount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mon_charge_amount'] = mon_charge_amount;
    map['day_active_count'] = day_active_count;
    map['cust_count'] = cust_count;
    map['today_register_count'] = today_register_count;
    map['mon_register_count'] = mon_register_count;
    map['mon_active_count'] = mon_active_count;
    map['day_charge_amount'] = day_charge_amount;
    map['mon_invalid_active_count'] = mon_invalid_active_count;
    map['profie_amount'] = profie_amount;

    return map;
  }
}
