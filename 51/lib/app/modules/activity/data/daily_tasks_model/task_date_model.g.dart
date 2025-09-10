// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_date_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskDateModel _$TaskDateModelFromJson(Map<String, dynamic> json) =>
    TaskDateModel(
      rewardAmount: (json['rewardAmount'] as num?)?.toInt(),
      taskName: json['taskName'] as String?,
      taskRemark: json['taskRemark'] as String?,
      taskType: json['taskType'] as String?,
      taskIcon: json['taskIcon'] as String?,
      status: json['status'] as String?,
      id: (json['id'] as num?)?.toInt(),
      receiveLogId: (json['receive_log_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskDateModelToJson(TaskDateModel instance) =>
    <String, dynamic>{
      'rewardAmount': instance.rewardAmount,
      'taskName': instance.taskName,
      'taskRemark': instance.taskRemark,
      'taskType': instance.taskType,
      'taskIcon': instance.taskIcon,
      'status': instance.status,
      'id': instance.id,
      'receive_log_id': instance.receiveLogId,
    };
