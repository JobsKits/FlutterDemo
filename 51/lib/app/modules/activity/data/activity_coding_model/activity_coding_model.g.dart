// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_coding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityCodingModel _$ActivityCodingModelFromJson(Map<String, dynamic> json) =>
    ActivityCodingModel(
      t: json['t'] == null
          ? null
          : T.fromJson(json['t'] as Map<String, dynamic>),
      responseCode: json['response_code'] as String?,
      msg: json['msg'] as String?,
    );

Map<String, dynamic> _$ActivityCodingModelToJson(
        ActivityCodingModel instance) =>
    <String, dynamic>{
      't': instance.t,
      'response_code': instance.responseCode,
      'msg': instance.msg,
    };
