// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_float_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityFloatModel _$ActivityFloatModelFromJson(Map<String, dynamic> json) =>
    ActivityFloatModel(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityFloatModelToJson(ActivityFloatModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };
