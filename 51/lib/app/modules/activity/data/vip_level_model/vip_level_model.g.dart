// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vip_level_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VipLevelModel _$VipLevelModelFromJson(Map<String, dynamic> json) =>
    VipLevelModel(
      hundred0: (json['100'] as num?)?.toInt(),
      hundred1: (json['101'] as num?)?.toInt(),
      hundred2: (json['102'] as num?)?.toInt(),
      hundred3: (json['103'] as num?)?.toInt(),
      hundred4: (json['104'] as num?)?.toInt(),
      hundred6: (json['106'] as num?)?.toInt(),
      hundred7: (json['107'] as num?)?.toInt(),
      hundred9: (json['109'] as num?)?.toInt(),
      level: (json['level'] as num?)?.toInt(),
    );

Map<String, dynamic> _$VipLevelModelToJson(VipLevelModel instance) =>
    <String, dynamic>{
      '100': instance.hundred0,
      '101': instance.hundred1,
      '102': instance.hundred2,
      '103': instance.hundred3,
      '104': instance.hundred4,
      '106': instance.hundred6,
      '107': instance.hundred7,
      '109': instance.hundred9,
      'level': instance.level,
    };
