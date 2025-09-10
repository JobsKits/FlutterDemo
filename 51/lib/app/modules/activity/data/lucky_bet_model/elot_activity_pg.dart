import 'package:json_annotation/json_annotation.dart';

part 'elot_activity_pg.g.dart';

@JsonSerializable()
class ElotActivityPg {
  final int? id;
  final int? tid;
  final String? activityName;
  final String? activityType;
  final String? activityCategory;
  final String? status;
  final int? auditVerify;
  final int? auditTimes;
  final String? startTime;
  final String? endTime;
  final String? showStartTime;
  final String? showEndTime;
  final String? showPic;
  final String? isShowPic;
  final String? isShowPicTime;
  final String? isShowDetailTime;
  final String? isShowIndex;
  final String? activityContent;
  final String? activityRule;
  final String? userlevelCfg;
  final String? currency;
  final String? isShowAvatar;
  final String? showAvatar;

  const ElotActivityPg({
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
    this.userlevelCfg,
    this.currency,
    this.isShowAvatar,
    this.showAvatar,
  });

  factory ElotActivityPg.fromJson(Map<String, dynamic> json) {
    return _$ElotActivityPgFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ElotActivityPgToJson(this);

  ElotActivityPg copyWith({
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
    String? userlevelCfg,
    String? currency,
    String? isShowAvatar,
    String? showAvatar,
  }) {
    return ElotActivityPg(
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
      userlevelCfg: userlevelCfg ?? this.userlevelCfg,
      currency: currency ?? this.currency,
      isShowAvatar: isShowAvatar ?? this.isShowAvatar,
      showAvatar: showAvatar ?? this.showAvatar,
    );
  }
}
