// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action_cfg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionCfg _$ActionCfgFromJson(Map<String, dynamic> json) => ActionCfg(
      gameType: (json['gameType'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      popupContent: json['popupContent'] as String?,
      postLoginModal: json['postLoginModal'] as String?,
      preLoginModal: json['preLoginModal'] as String?,
      singleRechargeConfigs: (json['singleRechargeConfigs'] as List<dynamic>?)
          ?.map((e) => SingleRechargeConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      taskConfigs: json['taskConfigs'] as List<dynamic>?,
      type: (json['type'] as num?)?.toInt(),
      validityTime: (json['validityTime'] as num?)?.toInt(),
      wheelConfigs: (json['wheelConfigs'] as List<dynamic>?)
          ?.map((e) => WheelConfig.fromJson(e as Map<String, dynamic>))
          .toList(),
      wheelSwitch: (json['wheelSwitch'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      betSource: json['betSource'],
    );

Map<String, dynamic> _$ActionCfgToJson(ActionCfg instance) => <String, dynamic>{
      'gameType': instance.gameType,
      'popupContent': instance.popupContent,
      'postLoginModal': instance.postLoginModal,
      'preLoginModal': instance.preLoginModal,
      'singleRechargeConfigs': instance.singleRechargeConfigs,
      'taskConfigs': instance.taskConfigs,
      'type': instance.type,
      'validityTime': instance.validityTime,
      'wheelConfigs': instance.wheelConfigs,
      'wheelSwitch': instance.wheelSwitch,
      'betSource': instance.betSource,
    };

SingleRechargeConfig _$SingleRechargeConfigFromJson(
        Map<String, dynamic> json) =>
    SingleRechargeConfig(
      amount: (json['amount'] as num?)?.toInt(),
      configId: (json['configId'] as num?)?.toInt(),
      giftPercentage: (json['giftPercentage'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$SingleRechargeConfigToJson(
        SingleRechargeConfig instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'configId': instance.configId,
      'giftPercentage': instance.giftPercentage,
    };
