// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_marquee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeMarqueeModel _$NoticeMarqueeModelFromJson(Map<String, dynamic> json) =>
    NoticeMarqueeModel(
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Datum.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NoticeMarqueeModelToJson(NoticeMarqueeModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'data': instance.data,
    };
