// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityRecordModel _$ActivityRecordModelFromJson(Map<String, dynamic> json) =>
    ActivityRecordModel(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      t: (json['t'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityRecordModelToJson(
        ActivityRecordModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
      't': instance.t,
    };
