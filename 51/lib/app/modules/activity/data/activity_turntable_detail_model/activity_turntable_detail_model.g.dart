// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_turntable_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityTurntableDetailModel _$ActivityTurntableDetailModelFromJson(
        Map<String, dynamic> json) =>
    ActivityTurntableDetailModel(
      tid: (json['tid'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
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
      actionCfg: const ActionCfgConverter().fromJson(json['actionCfg']),
      createBy: json['createBy'] as String?,
      createTime: (json['createTime'] as num?)?.toInt(),
      updateBy: json['updateBy'] as String?,
      updateTime: (json['updateTime'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      preLoginModal: json['preLoginModal'] as String?,
      postLoginModal: json['postLoginModal'] as String?,
    );

Map<String, dynamic> _$ActivityTurntableDetailModelToJson(
        ActivityTurntableDetailModel instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'id': instance.id,
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
      'actionCfg': const ActionCfgConverter().toJson(instance.actionCfg),
      'createBy': instance.createBy,
      'createTime': instance.createTime,
      'updateBy': instance.updateBy,
      'updateTime': instance.updateTime,
      'currency': instance.currency,
      'preLoginModal': instance.preLoginModal,
      'postLoginModal': instance.postLoginModal,
    };
