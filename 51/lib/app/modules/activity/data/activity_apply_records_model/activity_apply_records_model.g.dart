// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_apply_records_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityApplyRecordsModel _$ActivityApplyRecordsModelFromJson(
        Map<String, dynamic> json) =>
    ActivityApplyRecordsModel(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityApplyRecordsModelToJson(
        ActivityApplyRecordsModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };
