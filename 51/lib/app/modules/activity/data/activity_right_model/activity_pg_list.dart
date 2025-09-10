import 'package:json_annotation/json_annotation.dart';

part 'activity_pg_list.g.dart';

@JsonSerializable()
class ActivityPgList {
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
  String? preLoginModal;
  String? postLoginModal;
  String? isShowAvatar;
  String? showAvatar;
  @JsonKey(name: 'content_type')
  int? contentType;

  ActivityPgList({
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
    this.preLoginModal,
    this.postLoginModal,
    this.isShowAvatar,
    this.showAvatar,
    this.contentType,
  });

  @override
  String toString() {
    return 'ActivityPgList(id: $id, tid: $tid, activityName: $activityName, activityType: $activityType, activityCategory: $activityCategory, status: $status, auditVerify: $auditVerify, auditTimes: $auditTimes, startTime: $startTime, endTime: $endTime, showStartTime: $showStartTime, showEndTime: $showEndTime, showPic: $showPic, isShowPic: $isShowPic, isShowPicTime: $isShowPicTime, isShowDetailTime: $isShowDetailTime, isShowIndex: $isShowIndex, activityContent: $activityContent, activityRule: $activityRule, deviceCfg: $deviceCfg, applyCfg: $applyCfg, userlevelCfg: $userlevelCfg, actionCfg: $actionCfg, createBy: $createBy, createTime: $createTime, updateBy: $updateBy, updateTime: $updateTime, remark: $remark, currency: $currency, preLoginModal: $preLoginModal, postLoginModal: $postLoginModal, isShowAvatar: $isShowAvatar, showAvatar: $showAvatar, contentType: $contentType)';
  }

  factory ActivityPgList.fromJson(Map<String, dynamic> json) {
    return _$ActivityPgListFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityPgListToJson(this);

  ActivityPgList copyWith({
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
    String? preLoginModal,
    String? postLoginModal,
    String? isShowAvatar,
    String? showAvatar,
    int? contentType,
  }) {
    return ActivityPgList(
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
      preLoginModal: preLoginModal ?? this.preLoginModal,
      postLoginModal: postLoginModal ?? this.postLoginModal,
      isShowAvatar: isShowAvatar ?? this.isShowAvatar,
      showAvatar: showAvatar ?? this.showAvatar,
      contentType: contentType ?? this.contentType,
    );
  }
}
