// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ball.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ball _$BallFromJson(Map<String, dynamic> json) => Ball(
      id: json['id'] as String?,
      name: json['name'] as String?,
      cmd: json['cmd'] as String?,
      odds: json['odds'] as String?,
    );

Map<String, dynamic> _$BallToJson(Ball instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cmd': instance.cmd,
      'odds': instance.odds,
    };
