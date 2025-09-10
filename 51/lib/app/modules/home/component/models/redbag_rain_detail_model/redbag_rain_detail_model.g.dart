// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'redbag_rain_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedbagRainDetailModel _$RedbagRainDetailModelFromJson(
        Map<String, dynamic> json) =>
    RedbagRainDetailModel(
      id: (json['id'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      activityName: json['activityName'] as String?,
      activityType: json['activityType'] as String?,
      activityCategory: json['activityCategory'] as String?,
      status: json['status'] as String?,
      auditVerify: (json['auditVerify'] as num?)?.toInt(),
      auditTimes: (json['auditTimes'] as num?)?.toInt(),
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
      showStartTime: json['showStartTime'] as String?,
      showEndTime: json['showEndTime'] as String?,
      showPic: json['showPic'] as String?,
      isShowPic: json['isShowPic'] as String?,
      isShowPicTime: json['isShowPicTime'] as String?,
      isShowDetailTime: json['isShowDetailTime'] as String?,
      isShowIndex: json['isShowIndex'] as String?,
      activityContent: json['activityContent'] as String?,
      activityRule: json['activityRule'] as String?,
      deviceCfg: json['deviceCfg'] as String?,
      applyCfg: json['applyCfg'] as String?,
      userlevelCfg: json['userlevelCfg'] as String?,
      actionCfg: json['actionCfg'] as String?,
      createBy: json['createBy'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateBy: json['updateBy'] as String?,
      updateTime: (json['updateTime'] as num?)?.toInt(),
      remark: json['remark'] as String?,
      currency: json['currency'] as String?,
    );

Map<String, dynamic> _$RedbagRainDetailModelToJson(
        RedbagRainDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tid': instance.tid,
      'activityName': instance.activityName,
      'activityType': instance.activityType,
      'activityCategory': instance.activityCategory,
      'status': instance.status,
      'auditVerify': instance.auditVerify,
      'auditTimes': instance.auditTimes,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'showStartTime': instance.showStartTime,
      'showEndTime': instance.showEndTime,
      'showPic': instance.showPic,
      'isShowPic': instance.isShowPic,
      'isShowPicTime': instance.isShowPicTime,
      'isShowDetailTime': instance.isShowDetailTime,
      'isShowIndex': instance.isShowIndex,
      'activityContent': instance.activityContent,
      'activityRule': instance.activityRule,
      'deviceCfg': instance.deviceCfg,
      'applyCfg': instance.applyCfg,
      'userlevelCfg': instance.userlevelCfg,
      'actionCfg': instance.actionCfg,
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'remark': instance.remark,
      'currency': instance.currency,
    };
