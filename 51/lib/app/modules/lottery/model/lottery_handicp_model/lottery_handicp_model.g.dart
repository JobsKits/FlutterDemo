// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lottery_handicp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LotteryHandicpModel _$LotteryHandicpModelFromJson(Map<String, dynamic> json) =>
    LotteryHandicpModel(
      id: json['id'] as String?,
      areas: (json['areas'] as List<dynamic>?)
          ?.map((e) => Area.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LotteryHandicpModelToJson(
        LotteryHandicpModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'areas': instance.areas,
    };
