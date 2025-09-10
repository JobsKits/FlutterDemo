// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_coding_table_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityCodingTableModel _$ActivityCodingTableModelFromJson(
        Map<String, dynamic> json) =>
    ActivityCodingTableModel(
      rewardType: json['rewardType'] as String?,
      expireDay: (json['expireDay'] as num?)?.toInt(),
      sendWay: json['sendWay'] as String?,
      statisticalPeriod: json['statisticalPeriod'] as String?,
      lossRewards: (json['lossRewards'] as List<dynamic>?)
          ?.map((e) => LossReward.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ActivityCodingTableModelToJson(
        ActivityCodingTableModel instance) =>
    <String, dynamic>{
      'rewardType': instance.rewardType,
      'expireDay': instance.expireDay,
      'sendWay': instance.sendWay,
      'statisticalPeriod': instance.statisticalPeriod,
      'lossRewards': instance.lossRewards,
    };
