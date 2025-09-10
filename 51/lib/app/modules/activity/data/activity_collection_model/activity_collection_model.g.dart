// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_collection_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityCollectionModel _$ActivityCollectionModelFromJson(
        Map<String, dynamic> json) =>
    ActivityCollectionModel(
      receiveId: (json['receiveId'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      custId: (json['custId'] as num?)?.toInt(),
      receiveType: json['receiveType'] as String?,
      receiveName: json['receiveName'] as String?,
      receiveEndTime: json['receiveEndTime'],
      receiveStartTime: (json['receiveStartTime'] as num?)?.toInt(),
      reward: (json['reward'] as num?)?.toInt(),
      rewardSource: json['rewardSource'] as String?,
      elotActivityPgForSysConfig: json['elotActivityPgForSysConfig'] == null
          ? null
          : T.fromJson(
              json['elotActivityPgForSysConfig'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivityCollectionModelToJson(
        ActivityCollectionModel instance) =>
    <String, dynamic>{
      'receiveId': instance.receiveId,
      'tid': instance.tid,
      'custId': instance.custId,
      'receiveType': instance.receiveType,
      'receiveName': instance.receiveName,
      'receiveEndTime': instance.receiveEndTime,
      'receiveStartTime': instance.receiveStartTime,
      'reward': instance.reward,
      'rewardSource': instance.rewardSource,
      'elotActivityPgForSysConfig': instance.elotActivityPgForSysConfig,
    };
