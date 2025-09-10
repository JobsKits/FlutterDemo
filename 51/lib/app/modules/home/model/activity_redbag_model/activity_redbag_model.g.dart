// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_redbag_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityRedbagModel _$ActivityRedbagModelFromJson(Map<String, dynamic> json) =>
    ActivityRedbagModel(
      money: (json['money'] as num?)?.toInt(),
      integral: (json['integral'] as num?)?.toInt(),
      time: (json['time'] as num?)?.toInt(),
      type: (json['type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityRedbagModelToJson(
        ActivityRedbagModel instance) =>
    <String, dynamic>{
      'money': instance.money,
      'integral': instance.integral,
      'time': instance.time,
      'type': instance.type,
    };
