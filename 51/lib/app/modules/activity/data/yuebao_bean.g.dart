// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yuebao_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

YueBaoSafeDataBean _$YueBaoSafeDataBeanFromJson(Map<String, dynamic> json) =>
    YueBaoSafeDataBean(
      acctBalance: json['acctBalance'] as num?,
      balanceTreasure: json['balanceTreasure'] as num?,
      genAmount: json['genAmount'] as num?,
      reciveAmount: json['reciveAmount'] as num?,
      activityStandard: (json['activityStandard'] as num?)?.toInt(),
      remark: json['remark'] as String?,
    );

Map<String, dynamic> _$YueBaoSafeDataBeanToJson(YueBaoSafeDataBean instance) =>
    <String, dynamic>{
      'acctBalance': instance.acctBalance,
      'balanceTreasure': instance.balanceTreasure,
      'genAmount': instance.genAmount,
      'reciveAmount': instance.reciveAmount,
      'activityStandard': instance.activityStandard,
      'remark': instance.remark,
    };

YueBaoDataConfigBean _$YueBaoDataConfigBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoDataConfigBean(
      activity_standard: (json['activity_standard'] as num?)?.toInt(),
      answer_reward: json['answer_reward'] as bool?,
      balance: json['balance'] as bool?,
      borrow_code: (json['borrow_code'] as num?)?.toInt(),
      borrow_day: (json['borrow_day'] as num?)?.toInt(),
      charge_reward: json['charge_reward'] as bool?,
      content: json['content'] as String?,
      content_type: (json['content_type'] as num?)?.toInt(),
      create_time: json['create_time'] as num?,
      cumulative_coding: json['cumulative_coding'] as num?,
      cumulative_recharge: json['cumulative_recharge'] as num?,
      cumulative_recharge_cnt: json['cumulative_recharge_cnt'] as num?,
      cust_reward: json['cust_reward'] as bool?,
      custom_name: json['custom_name'] as String?,
      deposit_amount_mini: json['deposit_amount_mini'] as num?,
      eff_time: json['eff_time'] as num?,
      exp_time: json['exp_time'] as num?,
      game_reward: json['game_reward'] as bool?,
      ip_limit: (json['ip_limit'] as num?)?.toInt(),
      is_automatic: (json['is_automatic'] as num?)?.toInt(),
      is_bank_card: (json['is_bank_card'] as num?)?.toInt(),
      is_money: (json['is_money'] as num?)?.toInt(),
      is_multiple: (json['is_multiple'] as num?)?.toInt(),
      level_reward: json['level_reward'] as bool?,
      limit_type: json['limit_type'] as String?,
      loss_reward: json['loss_reward'] as bool?,
      lucky_reward: json['lucky_reward'] as bool?,
      marking_quantity: json['marking_quantity'] as num?,
      min_balance: json['min_balance'] as num?,
      month_reward: json['month_reward'] as bool?,
      oper_code: json['oper_code'] as String?,
      percentage: json['percentage'] as num?,
      play_amount: json['play_amount'] as num?,
      play_amount_compare: json['play_amount_compare'] as num?,
      play_ids: json['play_ids'] as String?,
      play_reward: json['play_reward'] as bool?,
      receiver_type: json['receiver_type'] as String?,
      recharge_type: (json['recharge_type'] as num?)?.toInt(),
      red_reward: json['red_reward'] as bool?,
      reward_type: json['reward_type'] as num?,
      set_time: json['set_time'] as num?,
      share_reward: json['share_reward'] as bool?,
      sign_reward: json['sign_reward'] as bool?,
      sign_type: (json['sign_type'] as num?)?.toInt(),
      sort_v: (json['sort_v'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      sub_limit: (json['sub_limit'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      title: json['title'] as String?,
      type: (json['type'] as num?)?.toInt(),
      valid_days: (json['valid_days'] as num?)?.toInt(),
      virtual_reward: json['virtual_reward'] as bool?,
      week_reward: json['week_reward'] as bool?,
    );

Map<String, dynamic> _$YueBaoDataConfigBeanToJson(
        YueBaoDataConfigBean instance) =>
    <String, dynamic>{
      'activity_standard': instance.activity_standard,
      'answer_reward': instance.answer_reward,
      'balance': instance.balance,
      'borrow_code': instance.borrow_code,
      'borrow_day': instance.borrow_day,
      'charge_reward': instance.charge_reward,
      'content': instance.content,
      'content_type': instance.content_type,
      'create_time': instance.create_time,
      'cumulative_coding': instance.cumulative_coding,
      'cumulative_recharge': instance.cumulative_recharge,
      'cumulative_recharge_cnt': instance.cumulative_recharge_cnt,
      'cust_reward': instance.cust_reward,
      'custom_name': instance.custom_name,
      'deposit_amount_mini': instance.deposit_amount_mini,
      'eff_time': instance.eff_time,
      'exp_time': instance.exp_time,
      'game_reward': instance.game_reward,
      'ip_limit': instance.ip_limit,
      'is_automatic': instance.is_automatic,
      'is_bank_card': instance.is_bank_card,
      'is_money': instance.is_money,
      'is_multiple': instance.is_multiple,
      'level_reward': instance.level_reward,
      'limit_type': instance.limit_type,
      'loss_reward': instance.loss_reward,
      'lucky_reward': instance.lucky_reward,
      'marking_quantity': instance.marking_quantity,
      'min_balance': instance.min_balance,
      'month_reward': instance.month_reward,
      'oper_code': instance.oper_code,
      'percentage': instance.percentage,
      'play_amount': instance.play_amount,
      'play_amount_compare': instance.play_amount_compare,
      'play_ids': instance.play_ids,
      'play_reward': instance.play_reward,
      'receiver_type': instance.receiver_type,
      'recharge_type': instance.recharge_type,
      'red_reward': instance.red_reward,
      'reward_type': instance.reward_type,
      'set_time': instance.set_time,
      'share_reward': instance.share_reward,
      'sign_reward': instance.sign_reward,
      'sign_type': instance.sign_type,
      'sort_v': instance.sort_v,
      'state': instance.state,
      'state_time': instance.state_time,
      'sub_limit': instance.sub_limit,
      'tid': instance.tid,
      'title': instance.title,
      'type': instance.type,
      'valid_days': instance.valid_days,
      'virtual_reward': instance.virtual_reward,
      'week_reward': instance.week_reward,
    };

YueBaoInterestDataBean _$YueBaoInterestDataBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoInterestDataBean(
      acctBalance: json['acctBalance'] as num?,
      acct_id: json['acct_id'] as num?,
      acct_treasure_id: json['acct_treasure_id'] as num?,
      balance: json['balance'] as num?,
      before_interest: json['before_interest'] as num?,
      change_balance: json['change_balance'] as num?,
      cust_id: (json['cust_id'] as num?)?.toInt(),
      day_skill: json['day_skill'] as num?,
      eff_date: json['eff_date'] as num?,
      exp_date: json['exp_date'] as num?,
      interest_marking_quantity: json['interest_marking_quantity'] as num?,
      is_show: json['is_show'] as String?,
      mark: json['mark'] as num?,
      orig_treasure_serial: json['orig_treasure_serial'] as num?,
      principal: json['principal'] as num?,
      state: (json['state'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      total_balance: json['total_balance'] as num?,
      total_interest: json['total_interest'] as num?,
      treasure_type: json['treasure_type'] as num?,
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$YueBaoInterestDataBeanToJson(
        YueBaoInterestDataBean instance) =>
    <String, dynamic>{
      'acctBalance': instance.acctBalance,
      'acct_id': instance.acct_id,
      'acct_treasure_id': instance.acct_treasure_id,
      'balance': instance.balance,
      'before_interest': instance.before_interest,
      'change_balance': instance.change_balance,
      'cust_id': instance.cust_id,
      'day_skill': instance.day_skill,
      'eff_date': instance.eff_date,
      'exp_date': instance.exp_date,
      'interest_marking_quantity': instance.interest_marking_quantity,
      'is_show': instance.is_show,
      'mark': instance.mark,
      'orig_treasure_serial': instance.orig_treasure_serial,
      'principal': instance.principal,
      'state': instance.state,
      'tid': instance.tid,
      'total_balance': instance.total_balance,
      'total_interest': instance.total_interest,
      'treasure_type': instance.treasure_type,
      'type': instance.type,
    };

YueBaoInterestPlanBean _$YueBaoInterestPlanBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoInterestPlanBean(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              YueBaoInterestPlanItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YueBaoInterestPlanBeanToJson(
        YueBaoInterestPlanBean instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };

YueBaoInterestPlanItemBean _$YueBaoInterestPlanItemBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoInterestPlanItemBean(
      cover_url: json['cover_url'] as String?,
      create_time: json['create_time'] as num?,
      cust_group_id: (json['cust_group_id'] as num?)?.toInt(),
      cust_id: (json['cust_id'] as num?)?.toInt(),
      daily_rate: json['daily_rate'] as num?,
      handling_fee_ratio: json['handling_fee_ratio'] as num?,
      interest_cycle: json['interest_cycle'] as num?,
      interest_type: (json['interest_type'] as num?)?.toInt(),
      is_auto_maturity: (json['is_auto_maturity'] as num?)?.toInt(),
      max_balance_limit: json['max_balance_limit'] as num?,
      max_orders: json['max_orders'] as num?,
      member_count: json['member_count'] as num?,
      min_balance: json['min_balance'] as num?,
      no_ransom_day: (json['no_ransom_day'] as num?)?.toInt(),
      operator: json['operator'] as String?,
      plan_id: (json['plan_id'] as num?)?.toInt(),
      plan_name: json['plan_name'] as String?,
      play_amount: json['play_amount'] as num?,
      play_amount_compare: json['play_amount_compare'] as num?,
      product_cycle: json['product_cycle'] as num?,
      remark: json['remark'] as String?,
      return_type: (json['return_type'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      total_balance_limit: json['total_balance_limit'] as num?,
      update_time: json['update_time'] as num?,
    );

Map<String, dynamic> _$YueBaoInterestPlanItemBeanToJson(
        YueBaoInterestPlanItemBean instance) =>
    <String, dynamic>{
      'cover_url': instance.cover_url,
      'create_time': instance.create_time,
      'cust_group_id': instance.cust_group_id,
      'cust_id': instance.cust_id,
      'daily_rate': instance.daily_rate,
      'handling_fee_ratio': instance.handling_fee_ratio,
      'interest_cycle': instance.interest_cycle,
      'interest_type': instance.interest_type,
      'is_auto_maturity': instance.is_auto_maturity,
      'max_balance_limit': instance.max_balance_limit,
      'max_orders': instance.max_orders,
      'member_count': instance.member_count,
      'min_balance': instance.min_balance,
      'no_ransom_day': instance.no_ransom_day,
      'operator': instance.operator,
      'plan_id': instance.plan_id,
      'plan_name': instance.plan_name,
      'play_amount': instance.play_amount,
      'play_amount_compare': instance.play_amount_compare,
      'product_cycle': instance.product_cycle,
      'remark': instance.remark,
      'return_type': instance.return_type,
      'state': instance.state,
      'tid': instance.tid,
      'total_balance_limit': instance.total_balance_limit,
      'update_time': instance.update_time,
    };

YueBaoRecordDataBean _$YueBaoRecordDataBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoRecordDataBean(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              YueBaoRecordDataItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YueBaoRecordDataBeanToJson(
        YueBaoRecordDataBean instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };

YueBaoRecordDataItemBean _$YueBaoRecordDataItemBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoRecordDataItemBean(
      acct_id: (json['acct_id'] as num?)?.toInt(),
      acct_treasure_id: (json['acct_treasure_id'] as num?)?.toInt(),
      acct_treasure_serial: json['acct_treasure_serial'] as num?,
      amount: json['amount'] as num?,
      aseq_id: json['aseq_id'] as num?,
      balance: json['balance'] as num?,
      before_balance: json['before_balance'] as num?,
      crt_datetime: json['crt_datetime'] as num?,
      cust_code: json['cust_code'] as String?,
      gen_amount: json['gen_amount'] as num?,
      gen_marking: json['gen_marking'] as num?,
      marking_quantity: json['marking_quantity'] as num?,
      oper_code: json['oper_code'] as String?,
      rear_balance: json['rear_balance'] as num?,
      remark: json['remark'] as String?,
      tid: (json['tid'] as num?)?.toInt(),
      time: json['time'] as String?,
      trans_type: json['trans_type'] as String?,
      treasure_type: (json['treasure_type'] as num?)?.toInt(),
      type: json['type'] as String?,
      upd_datetime: json['upd_datetime'] as num?,
    );

Map<String, dynamic> _$YueBaoRecordDataItemBeanToJson(
        YueBaoRecordDataItemBean instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'acct_treasure_id': instance.acct_treasure_id,
      'acct_treasure_serial': instance.acct_treasure_serial,
      'amount': instance.amount,
      'aseq_id': instance.aseq_id,
      'balance': instance.balance,
      'before_balance': instance.before_balance,
      'crt_datetime': instance.crt_datetime,
      'cust_code': instance.cust_code,
      'gen_amount': instance.gen_amount,
      'gen_marking': instance.gen_marking,
      'marking_quantity': instance.marking_quantity,
      'oper_code': instance.oper_code,
      'rear_balance': instance.rear_balance,
      'remark': instance.remark,
      'tid': instance.tid,
      'time': instance.time,
      'trans_type': instance.trans_type,
      'treasure_type': instance.treasure_type,
      'type': instance.type,
      'upd_datetime': instance.upd_datetime,
    };

YueBaoHasBuyPlanBean _$YueBaoHasBuyPlanBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoHasBuyPlanBean(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              YueBaoHasBuyPlanItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$YueBaoHasBuyPlanBeanToJson(
        YueBaoHasBuyPlanBean instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };

YueBaoHasBuyPlanItemBean _$YueBaoHasBuyPlanItemBeanFromJson(
        Map<String, dynamic> json) =>
    YueBaoHasBuyPlanItemBean(
      acct_id: (json['acct_id'] as num?)?.toInt(),
      acct_product_id: (json['acct_product_id'] as num?)?.toInt(),
      balance: json['balance'] as num?,
      create_time: json['create_time'] as num?,
      cust_id: (json['cust_id'] as num?)?.toInt(),
      cust_name: json['cust_name'] as String?,
      daily_rate: json['daily_rate'] as num?,
      diff_days: (json['diff_days'] as num?)?.toInt(),
      end_amount: json['end_amount'] as num?,
      handling_fee: json['handling_fee'] as num?,
      handling_fee_ratio: json['handling_fee_ratio'] as num?,
      income: json['income'] as num?,
      interest: json['interest'] as num?,
      new_state: (json['new_state'] as num?)?.toInt(),
      partner_name: json['partner_name'] as String?,
      plan_id: (json['plan_id'] as num?)?.toInt(),
      plan_name: json['plan_name'] as String?,
      product_cycle: (json['product_cycle'] as num?)?.toInt(),
      start_amount: json['start_amount'] as num?,
      state: (json['state'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      tid: (json['tid'] as num?)?.toInt(),
    );

Map<String, dynamic> _$YueBaoHasBuyPlanItemBeanToJson(
        YueBaoHasBuyPlanItemBean instance) =>
    <String, dynamic>{
      'acct_id': instance.acct_id,
      'acct_product_id': instance.acct_product_id,
      'balance': instance.balance,
      'create_time': instance.create_time,
      'cust_id': instance.cust_id,
      'cust_name': instance.cust_name,
      'daily_rate': instance.daily_rate,
      'diff_days': instance.diff_days,
      'end_amount': instance.end_amount,
      'handling_fee': instance.handling_fee,
      'handling_fee_ratio': instance.handling_fee_ratio,
      'income': instance.income,
      'interest': instance.interest,
      'new_state': instance.new_state,
      'partner_name': instance.partner_name,
      'plan_id': instance.plan_id,
      'plan_name': instance.plan_name,
      'product_cycle': instance.product_cycle,
      'start_amount': instance.start_amount,
      'state': instance.state,
      'state_time': instance.state_time,
      'tid': instance.tid,
    };
