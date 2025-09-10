// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_logredbag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityLogredbagModel _$ActivityLogredbagModelFromJson(
        Map<String, dynamic> json) =>
    ActivityLogredbagModel(
      receiveLogId: (json['receive_log_id'] as num?)?.toInt(),
      receiveType: (json['receive_type'] as num?)?.toInt(),
      receiveAmount: (json['receive_amount'] as num?)?.toInt(),
      custId: (json['cust_id'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
      levelName: json['level_name'] as String?,
      stateTime: (json['state_time'] as num?)?.toInt(),
      createTime: (json['create_time'] as num?)?.toInt(),
      operCode: json['oper_code'] as String?,
      tid: (json['tid'] as num?)?.toInt(),
      receiveLevel: (json['receive_level'] as num?)?.toInt(),
      missionObjectiveId: (json['mission_objective_id'] as num?)?.toInt(),
      standara: (json['standara'] as num?)?.toInt(),
      statProject: (json['statProject'] as num?)?.toInt(),
      activityName: json['activity_name'] as String?,
      isMoney: (json['is_money'] as num?)?.toInt(),
      activityStandardAmount:
          (json['activity_standard_amount'] as num?)?.toInt(),
      state: (json['state'] as num?)?.toInt(),
      needMobileValid: json['need_mobile_valid'] as String?,
      tasksId: (json['tasks_id'] as num?)?.toInt(),
      tasksName: json['tasks_name'] as String?,
      validDay: (json['valid_day'] as num?)?.toInt(),
      receiveIntegral: (json['receive_integral'] as num?)?.toInt(),
      playAmount: (json['playAmount'] as num?)?.toInt(),
      recharger: (json['recharger'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityLogredbagModelToJson(
        ActivityLogredbagModel instance) =>
    <String, dynamic>{
      'receive_log_id': instance.receiveLogId,
      'receive_type': instance.receiveType,
      'receive_amount': instance.receiveAmount,
      'cust_id': instance.custId,
      'level': instance.level,
      'level_name': instance.levelName,
      'state_time': instance.stateTime,
      'create_time': instance.createTime,
      'oper_code': instance.operCode,
      'tid': instance.tid,
      'receive_level': instance.receiveLevel,
      'mission_objective_id': instance.missionObjectiveId,
      'standara': instance.standara,
      'statProject': instance.statProject,
      'activity_name': instance.activityName,
      'is_money': instance.isMoney,
      'activity_standard_amount': instance.activityStandardAmount,
      'state': instance.state,
      'need_mobile_valid': instance.needMobileValid,
      'tasks_id': instance.tasksId,
      'tasks_name': instance.tasksName,
      'valid_day': instance.validDay,
      'receive_integral': instance.receiveIntegral,
      'playAmount': instance.playAmount,
      'recharger': instance.recharger,
    };
