// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_newcomers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskNewcomersModel _$TaskNewcomersModelFromJson(Map<String, dynamic> json) =>
    TaskNewcomersModel(
      t: json['t'] == null
          ? null
          : T.fromJson(json['t'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TaskNewcomersModelToJson(TaskNewcomersModel instance) =>
    <String, dynamic>{
      't': instance.t,
      'data': instance.data,
      'count': instance.count,
    };
