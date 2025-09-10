// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rebate_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RebateProportionItemBean _$RebateProportionItemBeanFromJson(
        Map<String, dynamic> json) =>
    RebateProportionItemBean(
      (json['data'] as List<dynamic>?)
          ?.map((e) =>
              RebateProportionChildItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RebateProportionItemBeanToJson(
        RebateProportionItemBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

RebateProportionChildItemBean _$RebateProportionChildItemBeanFromJson(
        Map<String, dynamic> json) =>
    RebateProportionChildItemBean(
      scale: json['scale'] as num?,
      shuffle_lower: json['shuffle_lower'] as num?,
      vip: json['vip'] as String?,
    );

Map<String, dynamic> _$RebateProportionChildItemBeanToJson(
        RebateProportionChildItemBean instance) =>
    <String, dynamic>{
      'scale': instance.scale,
      'shuffle_lower': instance.shuffle_lower,
      'vip': instance.vip,
    };

RebateDataBean _$RebateDataBeanFromJson(Map<String, dynamic> json) =>
    RebateDataBean(
      cust_id: (json['cust_id'] as num?)?.toInt(),
      cust_name: json['cust_name'] as String?,
      end_time: json['end_time'] as num?,
      is_auto: (json['is_auto'] as num?)?.toInt(),
      list: (json['list'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
            int.parse(k),
            (e as List<dynamic>)
                .map((e) =>
                    RebateDataChildItemBean.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      play_amount_sum: json['play_amount_sum'] as num?,
      settle_time: json['settle_time'] as String?,
      shuffle_amount_sum: json['shuffle_amount_sum'] as num?,
      t_shuffle_amount_sum: json['t_shuffle_amount_sum'] as num?,
      rule: json['rule'] as String?,
      rebate_time: (json['rebate_time'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      upper_id: (json['upper_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RebateDataBeanToJson(RebateDataBean instance) =>
    <String, dynamic>{
      'cust_id': instance.cust_id,
      'cust_name': instance.cust_name,
      'end_time': instance.end_time,
      'is_auto': instance.is_auto,
      'play_amount_sum': instance.play_amount_sum,
      'settle_time': instance.settle_time,
      'shuffle_amount_sum': instance.shuffle_amount_sum,
      't_shuffle_amount_sum': instance.t_shuffle_amount_sum,
      'rule': instance.rule,
      'rebate_time': instance.rebate_time,
      'tid': instance.tid,
      'upper_id': instance.upper_id,
      'list': instance.list?.map((k, e) => MapEntry(k.toString(), e)),
    };

RebateDataChildItemBean _$RebateDataChildItemBeanFromJson(
        Map<String, dynamic> json) =>
    RebateDataChildItemBean(
      end_time: json['end_time'] as num?,
      game_type: json['game_type'] as String?,
      play_amount: json['play_amount'] as num?,
      play_id: json['play_id'] as String?,
      play_name: json['play_name'] as String?,
      scale: json['scale'] as num?,
      sgame_type: json['sgame_type'] as String?,
      shuffle_amount: json['shuffle_amount'] as num?,
      next_scale: json['next_scale'] as num?,
      up_amount: json['up_amount'] as num?,
    );

Map<String, dynamic> _$RebateDataChildItemBeanToJson(
        RebateDataChildItemBean instance) =>
    <String, dynamic>{
      'end_time': instance.end_time,
      'game_type': instance.game_type,
      'play_amount': instance.play_amount,
      'play_id': instance.play_id,
      'play_name': instance.play_name,
      'scale': instance.scale,
      'sgame_type': instance.sgame_type,
      'shuffle_amount': instance.shuffle_amount,
      'next_scale': instance.next_scale,
      'up_amount': instance.up_amount,
    };

RebateHistoryBean _$RebateHistoryBeanFromJson(Map<String, dynamic> json) =>
    RebateHistoryBean(
      (json['data'] as List<dynamic>?)
          ?.map(
              (e) => RebateHistoryItemBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RebateHistoryBeanToJson(RebateHistoryBean instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

RebateHistoryItemBean _$RebateHistoryItemBeanFromJson(
        Map<String, dynamic> json) =>
    RebateHistoryItemBean(
      amount: json['amount'] as num?,
      create_time: (json['create_time'] as num?)?.toInt(),
      cust_id: (json['cust_id'] as num?)?.toInt(),
      cust_name: json['cust_name'] as String?,
      data_type: (json['data_type'] as num?)?.toInt(),
      game_name: json['game_name'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      part_mon: json['part_mon'] as num?,
      scale: json['scale'] as num?,
      shuffle_amount: json['shuffle_amount'] as num?,
      tid: (json['tid'] as num?)?.toInt(),
      upper_id: (json['upper_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RebateHistoryItemBeanToJson(
        RebateHistoryItemBean instance) =>
    <String, dynamic>{
      'create_time': instance.create_time,
      'amount': instance.amount,
      'shuffle_amount': instance.shuffle_amount,
      'tid': instance.tid,
      'scale': instance.scale,
      'part_mon': instance.part_mon,
      'upper_id': instance.upper_id,
      'data_type': instance.data_type,
      'log_id': instance.log_id,
      'cust_id': instance.cust_id,
      'game_name': instance.game_name,
      'cust_name': instance.cust_name,
    };

RebateHistoryDetailBean _$RebateHistoryDetailBeanFromJson(
        Map<String, dynamic> json) =>
    RebateHistoryDetailBean(
      g100: (json['g100'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g101: (json['g101'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g102: (json['g102'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g103: (json['g103'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g104: (json['g104'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g105: (json['g105'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g106: (json['g106'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
      g109: (json['g109'] as List<dynamic>)
          .map(RebateHistoryDetailItemBean.fromJson)
          .toList(),
    );

Map<String, dynamic> _$RebateHistoryDetailBeanToJson(
        RebateHistoryDetailBean instance) =>
    <String, dynamic>{
      'g100': instance.g100,
      'g101': instance.g101,
      'g102': instance.g102,
      'g103': instance.g103,
      'g104': instance.g104,
      'g105': instance.g105,
      'g106': instance.g106,
      'g109': instance.g109,
    };

RebateHistoryDetailItemBean _$RebateHistoryDetailItemBeanFromJson(
        Map<String, dynamic> json) =>
    RebateHistoryDetailItemBean(
      amount: json['amount'] as num?,
      create_time: (json['create_time'] as num?)?.toInt(),
      cust_id: (json['cust_id'] as num?)?.toInt(),
      cust_name: json['cust_name'] as String?,
      data_type: json['data_type'] as num?,
      game_name: json['game_name'] as String?,
      log_id: (json['log_id'] as num?)?.toInt(),
      part_mon: json['part_mon'] as num?,
      scale: json['scale'] as num?,
      shuffle_amount: json['shuffle_amount'] as num?,
      tid: (json['tid'] as num?)?.toInt(),
      upper_id: (json['upper_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RebateHistoryDetailItemBeanToJson(
        RebateHistoryDetailItemBean instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'create_time': instance.create_time,
      'cust_id': instance.cust_id,
      'cust_name': instance.cust_name,
      'data_type': instance.data_type,
      'game_name': instance.game_name,
      'log_id': instance.log_id,
      'part_mon': instance.part_mon,
      'scale': instance.scale,
      'shuffle_amount': instance.shuffle_amount,
      'tid': instance.tid,
      'upper_id': instance.upper_id,
    };
