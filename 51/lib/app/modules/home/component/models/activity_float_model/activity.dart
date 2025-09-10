import 'package:json_annotation/json_annotation.dart';

part 'activity.g.dart';

@JsonSerializable()
class Activity {
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
  String? remark;
  String? currency;

  Activity({
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
    this.remark,
    this.currency,
  });

  @override
  String toString() {
    return 'Activity(id: $id, tid: $tid, activityName: $activityName, activityType: $activityType, activityCategory: $activityCategory, status: $status, auditVerify: $auditVerify, auditTimes: $auditTimes, startTime: $startTime, endTime: $endTime, showStartTime: $showStartTime, showEndTime: $showEndTime, showPic: $showPic, isShowPic: $isShowPic, isShowPicTime: $isShowPicTime, isShowDetailTime: $isShowDetailTime, isShowIndex: $isShowIndex, activityContent: $activityContent, activityRule: $activityRule, remark: $remark, currency: $currency)';
  }

  factory Activity.fromJson(Map<String, dynamic> json) {
    return _$ActivityFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityToJson(this);

  Activity copyWith({
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
    String? remark,
    String? currency,
  }) {
    return Activity(
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
      remark: remark ?? this.remark,
      currency: currency ?? this.currency,
    );
  }
}
