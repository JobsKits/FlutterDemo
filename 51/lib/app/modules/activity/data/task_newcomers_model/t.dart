import 'package:json_annotation/json_annotation.dart';

part 't.g.dart';

@JsonSerializable()
class T {
  String? userLevelCfg;
  int? taskDurationType;
  int? taskDurationDay;
  int? taskDurationDisplay;
  int? sendWay;
  String? deviceCfg;
  String? applyCfg;
  int? collectionTime;
  String? preLoginModal;
  String? postLoginModal;
  int? auditTimes;
  String? activityRule;
  int? total;
  int? received;
  int? expiredDate;
  T({
    this.userLevelCfg,
    this.taskDurationType,
    this.taskDurationDay,
    this.taskDurationDisplay,
    this.sendWay,
    this.deviceCfg,
    this.applyCfg,
    this.collectionTime,
    this.preLoginModal,
    this.postLoginModal,
    this.auditTimes,
    this.activityRule,
    this.total,
    this.received,
    this.expiredDate,
  });

  @override
  String toString() {
    return 'T(userLevelCfg: $userLevelCfg, taskDurationType: $taskDurationType, taskDurationDay: $taskDurationDay, taskDurationDisplay: $taskDurationDisplay, sendWay: $sendWay, deviceCfg: $deviceCfg, applyCfg: $applyCfg, collectionTime: $collectionTime, preLoginModal: $preLoginModal, postLoginModal: $postLoginModal, auditTimes: $auditTimes, activityRule: $activityRule, total: $total, received: $received, expiredDate: $expiredDate)';
  }

  factory T.fromJson(Map<String, dynamic> json) => _$TFromJson(json);

  Map<String, dynamic> toJson() => _$TToJson(this);

  T copyWith({
    String? userLevelCfg,
    int? taskDurationType,
    int? taskDurationDay,
    int? taskDurationDisplay,
    int? sendWay,
    String? deviceCfg,
    String? applyCfg,
    int? collectionTime,
    String? preLoginModal,
    String? postLoginModal,
    int? auditTimes,
    String? activityRule,
    int? total,
    int? received,
    int? expiredDate,
  }) {
    return T(
      userLevelCfg: userLevelCfg ?? this.userLevelCfg,
      taskDurationType: taskDurationType ?? this.taskDurationType,
      taskDurationDay: taskDurationDay ?? this.taskDurationDay,
      taskDurationDisplay: taskDurationDisplay ?? this.taskDurationDisplay,
      sendWay: sendWay ?? this.sendWay,
      deviceCfg: deviceCfg ?? this.deviceCfg,
      applyCfg: applyCfg ?? this.applyCfg,
      collectionTime: collectionTime ?? this.collectionTime,
      preLoginModal: preLoginModal ?? this.preLoginModal,
      postLoginModal: postLoginModal ?? this.postLoginModal,
      auditTimes: auditTimes ?? this.auditTimes,
      activityRule: activityRule ?? this.activityRule,
      total: total ?? this.total,
      received: received ?? this.received,
      expiredDate: expiredDate ?? this.expiredDate
    );
  }
}
