// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_winning_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityWinningModel _$ActivityWinningModelFromJson(
        Map<String, dynamic> json) =>
    ActivityWinningModel(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      t: (json['t'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ActivityWinningModelToJson(
        ActivityWinningModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      't': instance.t,
      'data': instance.data,
    };
