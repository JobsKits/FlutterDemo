// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      custId: json['custId'],
      taskCode: json['taskCode'] as String?,
      taskName: json['taskName'] as String?,
      rewardAmount: (json['rewardAmount'] as num?)?.toInt(),
      activityScore: json['activityScore'],
      status: (json['status'] as num?)?.toInt(),
      receiveLogId: json['receiveLogId'],
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'custId': instance.custId,
      'taskCode': instance.taskCode,
      'taskName': instance.taskName,
      'rewardAmount': instance.rewardAmount,
      'activityScore': instance.activityScore,
      'status': instance.status,
      'receiveLogId': instance.receiveLogId,
    };
