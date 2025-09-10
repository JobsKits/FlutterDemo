// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WheelConfig _$WheelConfigFromJson(Map<String, dynamic> json) => WheelConfig(
      wheelType: (json['wheelType'] as num?)?.toInt(),
      source: (json['source'] as num?)?.toInt(),
      wheelGrids: (json['wheelGrids'] as List<dynamic>?)
          ?.map((e) => WheelGrid.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WheelConfigToJson(WheelConfig instance) =>
    <String, dynamic>{
      'wheelType': instance.wheelType,
      'source': instance.source,
      'wheelGrids': instance.wheelGrids,
    };
