// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskConfig _$TaskConfigFromJson(Map<String, dynamic> json) => TaskConfig(
      type: json['type'] as String?,
      target: (json['target'] as num?)?.toInt(),
      source: (json['source'] as num?)?.toInt(),
      gameType: json['gameType'],
    );

Map<String, dynamic> _$TaskConfigToJson(TaskConfig instance) =>
    <String, dynamic>{
      'type': instance.type,
      'target': instance.target,
      'source': instance.source,
      'gameType': instance.gameType,
    };
