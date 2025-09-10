// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      tid: (json['tid'] as num?)?.toInt(),
      aid: (json['aid'] as num?)?.toInt(),
      acctId: (json['acctId'] as num?)?.toInt(),
      account: json['account'] as String?,
      activityName: json['activityName'] as String?,
      awardName: json['awardName'] as String?,
      awardAmount: json['awardAmount'] as String?,
      chargeAmount: (json['chargeAmount'] as num?)?.toInt(),
      rankWay: (json['rankWay'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'tid': instance.tid,
      'aid': instance.aid,
      'acctId': instance.acctId,
      'account': instance.account,
      'activityName': instance.activityName,
      'awardName': instance.awardName,
      'awardAmount': instance.awardAmount,
      'chargeAmount': instance.chargeAmount,
      'rankWay': instance.rankWay,
    };
