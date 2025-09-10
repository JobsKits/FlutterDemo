import 'package:json_annotation/json_annotation.dart';

part 'redbag_rain_detail_model.g.dart';

@JsonSerializable()
class RedbagRainDetailModel {
  int? id;
  int? tid;
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
  String? actionCfg;
  String? createBy;
  int? createTime;
  String? updateBy;
  int? updateTime;
  String? remark;
  String? currency;

  RedbagRainDetailModel({
    this.id,
    this.tid,
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
    this.remark,
    this.currency,
  });

  @override
  String toString() {
    return 'RedbagRainDetailModel(id: $id, tid: $tid, activityName: $activityName, activityType: $activityType, activityCategory: $activityCategory, status: $status, auditVerify: $auditVerify, auditTimes: $auditTimes, startTime: $startTime, endTime: $endTime, showStartTime: $showStartTime, showEndTime: $showEndTime, showPic: $showPic, isShowPic: $isShowPic, isShowPicTime: $isShowPicTime, isShowDetailTime: $isShowDetailTime, isShowIndex: $isShowIndex, activityContent: $activityContent, activityRule: $activityRule, deviceCfg: $deviceCfg, applyCfg: $applyCfg, userlevelCfg: $userlevelCfg, actionCfg: $actionCfg, createBy: $createBy, createTime: $createTime, updateBy: $updateBy, updateTime: $updateTime, remark: $remark, currency: $currency)';
  }

  factory RedbagRainDetailModel.fromJson(Map<String, dynamic> json) {
    return _$RedbagRainDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RedbagRainDetailModelToJson(this);

  RedbagRainDetailModel copyWith({
    int? id,
    int? tid,
    String? activityName,
    String? activityType,
    String? activityCategory,
    String? status,
    int? auditVerify,
    int? auditTimes,
    String? startTime,
    String? endTime,
    String? showStartTime,
    String? showEndTime,
    String? showPic,
    String? isShowPic,
    String? isShowPicTime,
    String? isShowDetailTime,
    String? isShowIndex,
    String? activityContent,
    String? activityRule,
    String? deviceCfg,
    String? applyCfg,
    String? userlevelCfg,
    String? actionCfg,
    String? createBy,
    int? createTime,
    String? updateBy,
    int? updateTime,
    String? remark,
    String? currency,
  }) {
    return RedbagRainDetailModel(
      id: id ?? this.id,
      tid: tid ?? this.tid,
      activityName: activityName ?? this.activityName,
      activityType: activityType ?? this.activityType,
      activityCategory: activityCategory ?? this.activityCategory,
      status: status ?? this.status,
      auditVerify: auditVerify ?? this.auditVerify,
      auditTimes: auditTimes ?? this.auditTimes,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      showStartTime: showStartTime ?? this.showStartTime,
      showEndTime: showEndTime ?? this.showEndTime,
      showPic: showPic ?? this.showPic,
      isShowPic: isShowPic ?? this.isShowPic,
      isShowPicTime: isShowPicTime ?? this.isShowPicTime,
      isShowDetailTime: isShowDetailTime ?? this.isShowDetailTime,
      isShowIndex: isShowIndex ?? this.isShowIndex,
      activityContent: activityContent ?? this.activityContent,
      activityRule: activityRule ?? this.activityRule,
      deviceCfg: deviceCfg ?? this.deviceCfg,
      applyCfg: applyCfg ?? this.applyCfg,
      userlevelCfg: userlevelCfg ?? this.userlevelCfg,
      actionCfg: actionCfg ?? this.actionCfg,
      createBy: createBy ?? this.createBy,
      createTime: createTime ?? this.createTime,
      updateBy: updateBy ?? this.updateBy,
      updateTime: updateTime ?? this.updateTime,
      remark: remark ?? this.remark,
      currency: currency ?? this.currency,
    );
  }
}
