// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lucky_bet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LuckyBetModel _$LuckyBetModelFromJson(Map<String, dynamic> json) =>
    LuckyBetModel(
      id: (json['id'] as num?)?.toInt(),
      fortuneId: (json['fortune_id'] as num?)?.toInt(),
      gameType: (json['game_type'] as num?)?.toInt(),
      gameName: json['game_name'] as String?,
      tailNum: json['tail_num'] as String?,
      lowestAwardAmount: (json['lowest_award_amount'] as num?)?.toInt(),
      awardType: (json['award_type'] as num?)?.toInt(),
      awardAmount: (json['award_amount'] as num?)?.toInt(),
      markingMultix: (json['marking_multix'] as num?)?.toInt(),
      grantType: (json['grant_type'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      beginTime: (json['begin_time'] as num?)?.toInt(),
      endTime: (json['end_time'] as num?)?.toInt(),
      dBeginTime: (json['d_begin_time'] as num?)?.toInt(),
      dEndTime: (json['d_end_time'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      detailContent: json['detail_content'] as String?,
      ipLimit: (json['ip_limit'] as num?)?.toInt(),
      phoneLimit: (json['phone_limit'] as num?)?.toInt(),
      vipLimit: (json['vip_limit'] as num?)?.toInt(),
      rewardType: (json['reward_type'] as num?)?.toInt(),
      quota: (json['quota'] as num?)?.toInt(),
      restrictionType: (json['restriction_type'] as num?)?.toInt(),
      typeRecharges: json['type_recharges'] as String?,
      typePlays: json['type_plays'] as String?,
      timesLimit: (json['times_limit'] as num?)?.toInt(),
      timesLimitTotal: (json['times_limit_total'] as num?)?.toInt(),
      activityRule: json['activity_rule'] as String?,
      isShowDetailTime: json['isShowDetailTime'] as String?,
      showTime: (json['show_time'] as num?)?.toInt(),
      elotActivityPg: json['elotActivityPg'],
    );

Map<String, dynamic> _$LuckyBetModelToJson(LuckyBetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fortune_id': instance.fortuneId,
      'game_type': instance.gameType,
      'game_name': instance.gameName,
      'tail_num': instance.tailNum,
      'lowest_award_amount': instance.lowestAwardAmount,
      'award_type': instance.awardType,
      'award_amount': instance.awardAmount,
      'marking_multix': instance.markingMultix,
      'grant_type': instance.grantType,
      'state': instance.state,
      'begin_time': instance.beginTime,
      'end_time': instance.endTime,
      'd_begin_time': instance.dBeginTime,
      'd_end_time': instance.dEndTime,
      'tid': instance.tid,
      'detail_content': instance.detailContent,
      'ip_limit': instance.ipLimit,
      'phone_limit': instance.phoneLimit,
      'vip_limit': instance.vipLimit,
      'reward_type': instance.rewardType,
      'quota': instance.quota,
      'restriction_type': instance.restrictionType,
      'type_recharges': instance.typeRecharges,
      'type_plays': instance.typePlays,
      'times_limit': instance.timesLimit,
      'times_limit_total': instance.timesLimitTotal,
      'activity_rule': instance.activityRule,
      'isShowDetailTime': instance.isShowDetailTime,
      'show_time': instance.showTime,
      'elotActivityPg': instance.elotActivityPg,
    };
