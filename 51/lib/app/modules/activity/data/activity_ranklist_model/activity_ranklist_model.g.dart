// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_ranklist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityRanklistModel _$ActivityRanklistModelFromJson(
        Map<String, dynamic> json) =>
    ActivityRanklistModel(
      t: json['t'] == null
          ? null
          : T.fromJson(json['t'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityRanklistModelToJson(
        ActivityRanklistModel instance) =>
    <String, dynamic>{
      't': instance.t,
      'data': instance.data,
      'count': instance.count,
    };
