import 'dart:convert';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/action_cfg_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'action_cfg.dart';

part 'activity_turntable_detail_model.g.dart';

@JsonSerializable()
class ActivityTurntableDetailModel {
  int? tid;
  int? id;
  String? activityName;
  String? activityType;
  String? activityCategory;
  String? status;
  int? auditVerify;
  int? auditTimes;
  String? startTime;
  String? endTime;
  String? showStartTime;
  String? showEndTime;
  String? showPic;
  String? isShowPic;
  String? isShowPicTime;
  String? isShowDetailTime;
  String? isShowIndex;
  String? activityContent;
  String? activityRule;
  String? deviceCfg;
  String? applyCfg;
  String? userlevelCfg;

  @ActionCfgConverter() // ✅ 兼容 Map / String 两种返回
  ActionCfg? actionCfg;

  String? createBy;
  int? createTime;
  String? updateBy;
  int? updateTime;
  String? currency;
  String? preLoginModal;
  String? postLoginModal;

  ActivityTurntableDetailModel({
    this.tid,
    this.id,
    this.activityName,
    this.activityType,
    this.activityCategory,
    this.status,
    this.auditVerify,
    this.auditTimes,
    this.startTime,
    this.endTime,
    this.showStartTime,
    this.showEndTime,
    this.showPic,
    this.isShowPic,
    this.isShowPicTime,
    this.isShowDetailTime,
    this.isShowIndex,
    this.activityContent,
    this.activityRule,
    this.deviceCfg,
    this.applyCfg,
    this.userlevelCfg,
    this.actionCfg,
    this.createBy,
    this.createTime,
    this.updateBy,
    this.updateTime,
    this.currency,
    this.preLoginModal,
    this.postLoginModal,
  });

  factory ActivityTurntableDetailModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityTurntableDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityTurntableDetailModelToJson(this);
}
