// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wheel_grid.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WheelGrid _$WheelGridFromJson(Map<String, dynamic> json) => WheelGrid(
      gridId: (json['gridId'] as num?)?.toInt(),
      rewordAmount: (json['rewordAmount'] as num?)?.toInt(),
      probability: (json['probability'] as num?)?.toDouble(),
      giftIcon: json['giftIcon'] as String?,
    );

Map<String, dynamic> _$WheelGridToJson(WheelGrid instance) => <String, dynamic>{
      'gridId': instance.gridId,
      'rewordAmount': instance.rewordAmount,
      'probability': instance.probability,
      'giftIcon': instance.giftIcon,
    };
