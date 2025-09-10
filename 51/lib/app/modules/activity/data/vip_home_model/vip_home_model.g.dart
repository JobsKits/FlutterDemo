// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VipHomeModel _$VipHomeModelFromJson(Map<String, dynamic> json) => VipHomeModel(
      t: json['t'] == null
          ? null
          : T.fromJson(json['t'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VipHomeModelToJson(VipHomeModel instance) =>
    <String, dynamic>{
      't': instance.t,
      'data': instance.data,
      'count': instance.count,
    };
