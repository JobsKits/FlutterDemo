// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'area.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Area _$AreaFromJson(Map<String, dynamic> json) => Area(
      show: json['show'] as String?,
      baseballid: (json['baseballid'] as num?)?.toInt(),
      ballpanid: (json['ballpanid'] as num?)?.toInt(),
      data: json['data'] == null
          ? null
          : Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AreaToJson(Area instance) => <String, dynamic>{
      'show': instance.show,
      'baseballid': instance.baseballid,
      'ballpanid': instance.ballpanid,
      'data': instance.data,
    };
