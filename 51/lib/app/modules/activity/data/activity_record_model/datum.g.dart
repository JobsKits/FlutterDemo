// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      receiveAmount: (json['receive_amount'] as num?)?.toInt(),
      stateTime: (json['state_time'] as num?)?.toInt(),
      createTime: (json['create_time'] as num?)?.toInt(),
      activityName: json['activity_name'] as String?,
      tasksId: (json['tasks_id'] as num?)?.toInt(),
      tasksName: json['tasks_name'] as String?,
      state: (json['state'] as num?)?.toInt(),
      receiveLogId: (json['receive_log_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'receive_amount': instance.receiveAmount,
      'state_time': instance.stateTime,
      'create_time': instance.createTime,
      'activity_name': instance.activityName,
      'tasks_id': instance.tasksId,
      'tasks_name': instance.tasksName,
      'state': instance.state,
      'receive_log_id': instance.receiveLogId,
    };
