// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      fortunePlanId: (json['fortune_plan_id'] as num?)?.toInt(),
      gameType: (json['game_type'] as num?)?.toInt(),
      playPlanId: json['play_plan_id'] as String?,
      playPlanAmount: (json['play_plan_amount'] as num?)?.toInt(),
      awardAmount: (json['award_amount'] as num?)?.toInt(),
      awardTime: (json['award_time'] as num?)?.toInt(),
      fortuneId: (json['fortune_id'] as num?)?.toInt(),
      playName: json['play_name'] as String?,
      cplayName: json['cplay_name'] as String?,
      fortuneAmount: (json['fortune_amount'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      tailNum: json['tail_num'] as String?,
      custId: (json['cust_id'] as num?)?.toInt(),
      createTime: (json['create_time'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      getAwardTime: (json['get_award_time'] as num?)?.toInt(),
      partMon: (json['part_mon'] as num?)?.toInt(),
      ip: json['ip'] as String?,
      phone: json['phone'] as String?,
      playId: (json['play_id'] as num?)?.toInt(),
      grantType: (json['grant_type'] as num?)?.toInt(),
      platformOrderId: json['platform_order_id'] as String?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'fortune_plan_id': instance.fortunePlanId,
      'game_type': instance.gameType,
      'play_plan_id': instance.playPlanId,
      'play_plan_amount': instance.playPlanAmount,
      'award_amount': instance.awardAmount,
      'award_time': instance.awardTime,
      'fortune_id': instance.fortuneId,
      'play_name': instance.playName,
      'cplay_name': instance.cplayName,
      'fortune_amount': instance.fortuneAmount,
      'state': instance.state,
      'tail_num': instance.tailNum,
      'cust_id': instance.custId,
      'create_time': instance.createTime,
      'tid': instance.tid,
      'get_award_time': instance.getAwardTime,
      'part_mon': instance.partMon,
      'ip': instance.ip,
      'phone': instance.phone,
      'play_id': instance.playId,
      'grant_type': instance.grantType,
      'platform_order_id': instance.platformOrderId,
    };
