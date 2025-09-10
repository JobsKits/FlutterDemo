// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_tasks_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyTasksModel _$DailyTasksModelFromJson(Map<String, dynamic> json) =>
    DailyTasksModel(
      week: (json['week'] as List<dynamic>?)
          ?.map((e) => TaskDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      month: (json['month'] as List<dynamic>?)
          ?.map((e) => TaskDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      day: (json['day'] as List<dynamic>?)
          ?.map((e) => TaskDateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      getAmount: (json['getAmount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DailyTasksModelToJson(DailyTasksModel instance) =>
    <String, dynamic>{
      'week': instance.week,
      'month': instance.month,
      'day': instance.day,
      'getAmount': instance.getAmount,
    };
