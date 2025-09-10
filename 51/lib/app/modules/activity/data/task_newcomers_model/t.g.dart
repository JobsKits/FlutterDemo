// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

T _$TFromJson(Map<String, dynamic> json) => T(
      userLevelCfg: json['userLevelCfg'] as String?,
      taskDurationType: (json['taskDurationType'] as num?)?.toInt(),
      taskDurationDay: (json['taskDurationDay'] as num?)?.toInt(),
      taskDurationDisplay: (json['taskDurationDisplay'] as num?)?.toInt(),
      sendWay: (json['sendWay'] as num?)?.toInt(),
      deviceCfg: json['deviceCfg'] as String?,
      applyCfg: json['applyCfg'] as String?,
      collectionTime: (json['collectionTime'] as num?)?.toInt(),
      preLoginModal: json['preLoginModal'] as String?,
      postLoginModal: json['postLoginModal'] as String?,
      auditTimes: (json['auditTimes'] as num?)?.toInt(),
      activityRule: json['activityRule'] as String?,
      total: (json['total'] as num?)?.toInt(),
      received: (json['received'] as num?)?.toInt(),
      expiredDate: (json['expiredDate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TToJson(T instance) => <String, dynamic>{
      'userLevelCfg': instance.userLevelCfg,
      'taskDurationType': instance.taskDurationType,
      'taskDurationDay': instance.taskDurationDay,
      'taskDurationDisplay': instance.taskDurationDisplay,
      'sendWay': instance.sendWay,
      'deviceCfg': instance.deviceCfg,
      'applyCfg': instance.applyCfg,
      'collectionTime': instance.collectionTime,
      'preLoginModal': instance.preLoginModal,
      'postLoginModal': instance.postLoginModal,
      'auditTimes': instance.auditTimes,
      'activityRule': instance.activityRule,
      'total': instance.total,
      'received': instance.received,
      'expiredDate': instance.expiredDate,
    };
