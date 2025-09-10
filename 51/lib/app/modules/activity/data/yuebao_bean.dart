// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'yuebao_bean.g.dart';

/// 保险箱相关数据
@JsonSerializable()
class YueBaoSafeDataBean {
  YueBaoSafeDataBean({
    this.acctBalance,
    this.balanceTreasure,
    this.genAmount,
    this.reciveAmount,
    this.activityStandard,
    this.remark,
  });

  num? acctBalance; // 余额宝余额
  num? balanceTreasure; // 钱包金币
  num? genAmount; // 钱包金币
  num? reciveAmount; // 钱包金币
  int? activityStandard; // 钱包金币
  String? remark;

  factory YueBaoSafeDataBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoSafeDataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoSafeDataBeanToJson(this);
}

/// 余额宝数据配置
@JsonSerializable()
class YueBaoDataConfigBean {
  YueBaoDataConfigBean({
    this.activity_standard,
    this.answer_reward,
    this.balance,
    this.borrow_code,
    this.borrow_day,
    this.charge_reward,
    this.content,
    this.content_type,
    this.create_time,
    this.cumulative_coding,
    this.cumulative_recharge,
    this.cumulative_recharge_cnt,
    this.cust_reward,
    this.custom_name,
    this.deposit_amount_mini,
    this.eff_time,
    this.exp_time,
    this.game_reward,
    this.ip_limit,
    this.is_automatic,
    this.is_bank_card,
    this.is_money,
    this.is_multiple,
    this.level_reward,
    this.limit_type,
    this.loss_reward,
    this.lucky_reward,
    this.marking_quantity,
    this.min_balance,
    this.month_reward,
    this.oper_code,
    this.percentage,
    this.play_amount,
    this.play_amount_compare,
    this.play_ids,
    this.play_reward,
    this.receiver_type,
    this.recharge_type,
    this.red_reward,
    this.reward_type,
    this.set_time,
    this.share_reward,
    this.sign_reward,
    this.sign_type,
    this.sort_v,
    this.state,
    this.state_time,
    this.sub_limit,
    this.tid,
    this.title,
    this.type,
    this.valid_days,
    this.virtual_reward,
    this.week_reward,
  });

  int? activity_standard;
  bool? answer_reward;
  bool? balance;
  int? borrow_code;
  int? borrow_day;
  bool? charge_reward;
  String? content;
  int? content_type;
  num? create_time;
  num? cumulative_coding;
  num? cumulative_recharge;
  num? cumulative_recharge_cnt;
  bool? cust_reward;
  String? custom_name;
  num? deposit_amount_mini;
  num? eff_time;
  num? exp_time;
  bool? game_reward;
  int? ip_limit;
  int? is_automatic;
  int? is_bank_card;
  int? is_money;
  int? is_multiple;
  bool? level_reward;
  String? limit_type;
  bool? loss_reward;
  bool? lucky_reward;
  num? marking_quantity;
  num? min_balance;
  bool? month_reward;
  String? oper_code;
  num? percentage;
  num? play_amount;
  num? play_amount_compare;
  String? play_ids;
  bool? play_reward;
  String? receiver_type;
  int? recharge_type;
  bool? red_reward;
  num? reward_type;
  num? set_time;
  bool? share_reward;
  bool? sign_reward;
  int? sign_type;
  int? sort_v;
  int? state;
  num? state_time;
  int? sub_limit;
  int? tid;
  String? title;
  int? type;
  int? valid_days;
  bool? virtual_reward;
  bool? week_reward;

  factory YueBaoDataConfigBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoDataConfigBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoDataConfigBeanToJson(this);
}

/// 余额宝利息相关
@JsonSerializable()
class YueBaoInterestDataBean {
  YueBaoInterestDataBean({
    this.acctBalance,
    this.acct_id,
    this.acct_treasure_id,
    this.balance, // 计息金币
    this.before_interest, // 上次收益
    this.change_balance,
    this.cust_id,
    this.day_skill, // 日利息
    this.eff_date,
    this.exp_date,
    this.interest_marking_quantity,
    this.is_show,
    this.mark,
    this.orig_treasure_serial,
    this.principal, // 总本金
    this.state,
    this.tid,
    this.total_balance, // 总金币
    this.total_interest, // 累计收益
    this.treasure_type,
    this.type,
  });

  num? acctBalance;
  num? acct_id;
  num? acct_treasure_id;
  num? balance;
  num? before_interest;
  num? change_balance;
  int? cust_id;
  num? day_skill;
  num? eff_date;
  num? exp_date;
  num? interest_marking_quantity;
  String? is_show;
  num? mark;
  num? orig_treasure_serial;
  num? principal;
  int? state;
  int? tid;
  num? total_balance;
  num? total_interest;
  num? treasure_type;
  int? type;

  factory YueBaoInterestDataBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoInterestDataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoInterestDataBeanToJson(this);
}

/// 余额宝利息方案
@JsonSerializable()
class YueBaoInterestPlanBean {
  YueBaoInterestPlanBean({
    this.count,
    this.data,
  });

  int? count;
  List<YueBaoInterestPlanItemBean>? data;

  factory YueBaoInterestPlanBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoInterestPlanBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoInterestPlanBeanToJson(this);
}

/// 余额宝利息方案子项
@JsonSerializable()
class YueBaoInterestPlanItemBean {
  YueBaoInterestPlanItemBean({
    this.cover_url,
    this.create_time,
    this.cust_group_id,
    this.cust_id,
    this.daily_rate,
    this.handling_fee_ratio,
    this.interest_cycle,
    this.interest_type,
    this.is_auto_maturity,
    this.max_balance_limit,
    this.max_orders,
    this.member_count,
    this.min_balance,
    this.no_ransom_day,
    this.operator,
    this.plan_id,
    this.plan_name,
    this.play_amount,
    this.play_amount_compare,
    this.product_cycle,
    this.remark,
    this.return_type,
    this.state,
    this.tid,
    this.total_balance_limit,
    this.update_time,
  });

  String? cover_url;
  num? create_time;
  int? cust_group_id;
  int? cust_id;
  num? daily_rate;
  num? handling_fee_ratio;
  num? interest_cycle;
  int? interest_type;
  int? is_auto_maturity;
  num? max_balance_limit;
  num? max_orders;
  num? member_count;
  num? min_balance;
  int? no_ransom_day;
  String? operator;
  int? plan_id;
  String? plan_name;
  num? play_amount;
  num? play_amount_compare;
  num? product_cycle;
  String? remark;
  int? return_type;
  int? state;
  int? tid;
  num? total_balance_limit;
  num? update_time;

  factory YueBaoInterestPlanItemBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoInterestPlanItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoInterestPlanItemBeanToJson(this);

  @override
  String toString() {
    return '''
      YueBaoInterestPlanItemBean{cover_url: ${cover_url}, create_time: ${create_time}, cust_group_id: ${cust_group_id}, cust_id: ${cust_id}, daily_rate: ${daily_rate}, handling_fee_ratio: ${handling_fee_ratio}, interest_cycle: ${interest_cycle}, interest_type: ${interest_type}, is_auto_maturity: ${is_auto_maturity}, max_balance_limit: ${max_balance_limit}, max_orders: ${max_orders}, 
      member_count: ${member_count}, min_balance: ${min_balance}, no_ransom_day: ${no_ransom_day}, operator: ${operator}, plan_id: ${plan_id}, plan_name: ${plan_name}, play_amount: ${play_amount}, play_amount_compare: ${play_amount_compare}, product_cycle: ${product_cycle}, remark: ${remark}, return_type: ${return_type}, state: ${state}, total_balance_limit: ${total_balance_limit}}
    ''';
  }
}

/// 余额宝记录数据
@JsonSerializable()
class YueBaoRecordDataBean {
  YueBaoRecordDataBean({
    this.count,
    this.data,
  });

  int? count;
  List<YueBaoRecordDataItemBean>? data;

  factory YueBaoRecordDataBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoRecordDataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoRecordDataBeanToJson(this);
}

/// 余额宝记录数据 - 子项
@JsonSerializable()
class YueBaoRecordDataItemBean {
  YueBaoRecordDataItemBean({
    this.acct_id,
    this.acct_treasure_id,
    this.acct_treasure_serial,
    this.amount,
    this.aseq_id,
    this.balance,
    this.before_balance,
    this.crt_datetime,
    this.cust_code,
    this.gen_amount,
    this.gen_marking,
    this.marking_quantity,
    this.oper_code,
    this.rear_balance,
    this.remark,
    this.tid,
    this.time,
    this.trans_type,
    this.treasure_type,
    this.type,
    this.upd_datetime,
  });

  int? acct_id;
  int? acct_treasure_id;
  num? acct_treasure_serial;
  num? amount;
  num? aseq_id;
  num? balance;
  num? before_balance;
  num? crt_datetime;
  String? cust_code;
  num? gen_amount;
  num? gen_marking;
  num? marking_quantity;
  String? oper_code;
  num? rear_balance;
  String? remark;
  int? tid;
  String? time;
  String? trans_type;
  int? treasure_type;
  String? type;
  num? upd_datetime;

  factory YueBaoRecordDataItemBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoRecordDataItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoRecordDataItemBeanToJson(this);
}

/// 已购买方案数据
@JsonSerializable()
class YueBaoHasBuyPlanBean {
  YueBaoHasBuyPlanBean({
    this.count,
    this.data,
  });

  int? count;
  List<YueBaoHasBuyPlanItemBean>? data;

  factory YueBaoHasBuyPlanBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoHasBuyPlanBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoHasBuyPlanBeanToJson(this);
}

/// 已购买方案数据 - 子项
@JsonSerializable()
class YueBaoHasBuyPlanItemBean {
  YueBaoHasBuyPlanItemBean({
    this.acct_id,
    this.acct_product_id,
    this.balance,
    this.create_time,
    this.cust_id,
    this.cust_name,
    this.daily_rate,
    this.diff_days,
    this.end_amount,
    this.handling_fee,
    this.handling_fee_ratio,
    this.income,
    this.interest,
    this.new_state,
    this.partner_name,
    this.plan_id,
    this.plan_name,
    this.product_cycle,
    this.start_amount,
    this.state,
    this.state_time,
    this.tid,
  });

  int? acct_id;
  int? acct_product_id;
  num? balance;
  num? create_time;
  int? cust_id;
  String? cust_name;
  num? daily_rate;
  int? diff_days;
  num? end_amount;
  num? handling_fee;
  num? handling_fee_ratio;
  num? income;
  num? interest;
  int? new_state;
  String? partner_name;
  int? plan_id;
  String? plan_name;
  int? product_cycle;
  num? start_amount;
  int? state;
  num? state_time;
  int? tid;

  factory YueBaoHasBuyPlanItemBean.fromJson(Map<String, dynamic> json) =>
      _$YueBaoHasBuyPlanItemBeanFromJson(json);

  Map<String, dynamic> toJson() => _$YueBaoHasBuyPlanItemBeanToJson(this);

  @override
  String toString() {
    return 'YueBaoHasBuyPlanItemBean {acct_id: ${acct_id}, acct_product_id:${acct_product_id}, balance: ${balance}, create_time: ${create_time}, cust_id: ${cust_id}, cust_name: ${cust_name}, daily_rate: ${daily_rate}, diff_days: ${diff_days}, end_amount: ${end_amount}, ${handling_fee}, handling_fee_ratio: ${handling_fee_ratio}, income: ${income}, interest: ${interest}, new_state: ${new_state}, partner_name: ${partner_name}, plan_id: ${plan_id}, plan_name: ${plan_name}, product_cycle: ${product_cycle}, start_amount: ${start_amount}, state: ${state}, state_time: ${state_time}}';
  }
}
