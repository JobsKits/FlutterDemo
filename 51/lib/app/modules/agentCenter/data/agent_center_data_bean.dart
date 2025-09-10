// ignore_for_file: non_constant_identifier_names

class AgentCenterDataBean {
  AgentCenterDataBean({
    this.active_count,
    this.charge_first_amount_rs,
    this.charge_sum_cust_amount,
    this.correction_surplus_amount,
    this.eff_active_count,
    this.estimate_amount,
    this.fund_amount_fee,
    this.last_mon_surplus_amount,
    this.mon_profit,
    this.partner_reward_amount,
    this.plan_amount,
    this.site_amount_fee,
    this.sub_cust_count,
    this.team_cust_count,
    this.team_profit,
    this.total_agent_rebate,
    this.withdraw_amount,
    this.xz_cust_count,
    this.yh_total_amount,
    this.charge_rs,
  });

  num? active_count;
  num? charge_first_amount_rs;
  num? charge_sum_cust_amount;
  num? correction_surplus_amount;
  num? eff_active_count;
  num? estimate_amount;
  num? fund_amount_fee;
  num? last_mon_surplus_amount;
  num? mon_profit;
  num? partner_reward_amount;
  num? plan_amount;
  num? site_amount_fee;
  num? sub_cust_count;
  num? team_cust_count;
  num? team_profit;
  num? total_agent_rebate;
  num? withdraw_amount;
  num? xz_cust_count;
  num? yh_total_amount;
  num? charge_rs;

  AgentCenterDataBean.fromJson(dynamic json) {
    active_count = json['active_count'];
    charge_first_amount_rs = json['charge_first_amount_rs'];
    charge_sum_cust_amount = json['charge_sum_cust_amount'];
    correction_surplus_amount = json['correction_surplus_amount'];
    eff_active_count = json['eff_active_count'];
    estimate_amount = json['estimate_amount'];
    fund_amount_fee = json['fund_amount_fee'];
    last_mon_surplus_amount = json['last_mon_surplus_amount'];
    mon_profit = json['mon_profit'];
    partner_reward_amount = json['partner_reward_amount'];
    plan_amount = json['plan_amount'];
    site_amount_fee = json['site_amount_fee'];
    sub_cust_count = json['sub_cust_count'];
    team_cust_count = json['team_cust_count'];
    team_profit = json['team_profit'];
    total_agent_rebate = json['total_agent_rebate'];
    withdraw_amount = json['withdraw_amount'];
    xz_cust_count = json['xz_cust_count'];
    yh_total_amount = json['yh_total_amount'];
    charge_rs = json['charge_rs'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['active_count'] = active_count;
    map['charge_first_amount_rs'] = charge_first_amount_rs;
    map['charge_sum_cust_amount'] = charge_sum_cust_amount;
    map['correction_surplus_amount'] = correction_surplus_amount;
    map['eff_active_count'] = eff_active_count;
    map['estimate_amount'] = estimate_amount;
    map['fund_amount_fee'] = fund_amount_fee;
    map['last_mon_surplus_amount'] = last_mon_surplus_amount;
    map['mon_profit'] = mon_profit;
    map['partner_reward_amount'] = partner_reward_amount;
    map['plan_amount'] = plan_amount;
    map['site_amount_fee'] = site_amount_fee;
    map['sub_cust_count'] = sub_cust_count;
    map['team_cust_count'] = team_cust_count;
    map['team_profit'] = team_profit;
    map['total_agent_rebate'] = total_agent_rebate;
    map['withdraw_amount'] = withdraw_amount;
    map['xz_cust_count'] = xz_cust_count;
    map['yh_total_amount'] = yh_total_amount;
    map['charge_rs'] = charge_rs;

    return map;
  }
}
