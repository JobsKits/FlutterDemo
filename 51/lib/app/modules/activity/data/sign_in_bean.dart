// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sign_in_bean.g.dart';

/// 签到tab数据
@JsonSerializable()
class SignInBean {
  SignInBean({
    this.activityRuleConf,
    this.elotActivityPg,
    this.asse_price,
    this.balance_differ_amount,
    this.balance_lower,
    this.balance_upper,
    this.borrow_amount,
    this.channel,
    this.create_time,
    this.cumulative_attendance,
    this.daily_withdrawal_limit,
    this.day_bet_cnt,
    this.day_skill,
    this.day_type,
    this.differ_amount,
    this.friday,
    this.groups,
    this.isLevelReward,
    this.isMonth_Reward,
    this.isWeekReward,
    this.is_auto,
    this.is_automatic,
    this.level,
    this.level_id,
    this.level_name,
    this.level_reward,
    this.level_reward_total,
    this.level_type,
    this.manager,
    this.monday,
    this.month_reward,
    this.month_salary,
    this.oper_code,
    this.points_bonus,
    this.quantify_amount_max,
    this.quantify_amount_min,
    this.quantify_income_rate,
    this.quantify_income_rate_show,
    this.quantify_income_scale,
    this.rebate_bonus,
    this.rebate_scale,
    this.refresh_type,
    this.relegation_bet_lower,
    this.relegation_bet_upper,
    this.relegation_charge_lower,
    this.relegation_charge_upper,
    this.relegation_day,
    this.relegation_mode,
    this.return_water_bonus,
    this.robot_price,
    this.robot_valid,
    this.saturday,
    this.scale,
    this.sign_day,
    this.sign_type,
    this.state,
    this.state_time,
    this.sunday,
    this.thursday,
    this.tid,
    this.today_order_cnt,
    this.tuesday,
    this.value_lower,
    this.value_upper,
    this.vip_log_url,
    this.web_state,
    this.wednesday,
    this.week_reward,
    this.week_salary,
    this.withdraw_cnt,
    this.withdraw_free,
    this.withdraw_free_cnt,
    this.withdraw_limit,
    this.withdraw_upper_limit,
    this.after_login_modal,
    this.before_login_modal,
    this.hasVipConfig,
  });

  num? asse_price;
  num? balance_differ_amount;
  num? balance_lower;
  num? balance_upper;
  num? borrow_amount;
  num? channel;
  num? create_time;
  num? cumulative_attendance;
  num? daily_withdrawal_limit;
  num? day_bet_cnt;
  num? day_skill;
  int? day_type;
  num? differ_amount;
  num? friday;
  String? groups;
  int? isLevelReward;
  int? isMonth_Reward;
  int? isWeekReward;
  int? is_auto;
  int? is_automatic;
  int? level;
  int? level_id;
  String? level_name;
  num? level_reward;
  num? level_reward_total;
  int? level_type;
  num? manager;
  num? monday;
  num? month_reward;
  num? month_salary;
  String? oper_code;
  String? points_bonus;
  num? quantify_amount_max;
  num? quantify_amount_min;
  String? quantify_income_rate;
  String? quantify_income_rate_show;
  String? quantify_income_scale;
  String? rebate_bonus;
  String? rebate_scale;
  int? refresh_type;
  num? relegation_bet_lower;
  num? relegation_bet_upper;
  num? relegation_charge_lower;
  num? relegation_charge_upper;
  num? relegation_day;
  int? relegation_mode;
  String? return_water_bonus;
  num? robot_price;
  num? robot_valid;
  num? saturday;
  num? scale;
  int? sign_day;
  int? sign_type;
  int? state;
  num? state_time;
  num? sunday;
  num? thursday;
  int? tid;
  num? today_order_cnt;
  num? tuesday;
  num? value_lower;
  num? value_upper;
  String? vip_log_url;
  int? web_state;
  num? wednesday;
  num? week_reward;
  num? week_salary;
  num? withdraw_cnt;
  String? withdraw_free;
  num? withdraw_free_cnt;
  num? withdraw_limit;
  num? withdraw_upper_limit;
  SignInRuleConfBean? activityRuleConf;
  String? after_login_modal;
  String? before_login_modal;
  num? hasVipConfig;
  ActivityPgList? elotActivityPg;

  factory SignInBean.fromJson(Map<String, dynamic> json) =>
      _$SignInBeanFromJson(json);

  Map<String, dynamic> toJson() => _$SignInBeanToJson(this);
}

@JsonSerializable()
class SignInRuleConfBean {
  SignInRuleConfBean({
    this.activity_id,
    this.activity_name,
    this.amount,
    this.cat,
    this.current_amount,
    this.current_marking_quantity,
    this.end_time,
    this.limit_ip_num,
    this.limit_type,
    this.marking_quantity,
    this.oper_code,
    this.profit,
    this.red_packet_id,
    this.sign_rules,
    this.start_time,
    this.state_time,
    this.tid,
    this.vipSignDaConfigs,
    this.reward_method,
  });

  int? activity_id;
  String? activity_name;
  num? amount;
  num? current_amount;
  int? cat;
  num? end_time;
  int? limit_ip_num;
  int? limit_type;
  num? marking_quantity;
  num? current_marking_quantity;
  String? oper_code;
  num? profit;
  int? red_packet_id;
  String? sign_rules;
  num? start_time;
  num? state_time;
  int? tid;
  int? reward_method;
  Map<String, dynamic>? vipSignDaConfigs;

  factory SignInRuleConfBean.fromJson(Map<String, dynamic> json) =>
      _$SignInRuleConfBeanFromJson(json);

  Map<String, dynamic> toJson() => _$SignInRuleConfBeanToJson(this);
}
