import 'package:json_annotation/json_annotation.dart';

part 'activity_logredbag_model.g.dart';

@JsonSerializable()
class ActivityLogredbagModel {
  @JsonKey(name: 'receive_log_id')
  int? receiveLogId;
  @JsonKey(name: 'receive_type')
  int? receiveType;
  @JsonKey(name: 'receive_amount')
  int? receiveAmount;
  @JsonKey(name: 'cust_id')
  int? custId;
  int? level;
  @JsonKey(name: 'level_name')
  String? levelName;
  @JsonKey(name: 'state_time')
  int? stateTime;
  @JsonKey(name: 'create_time')
  int? createTime;
  @JsonKey(name: 'oper_code')
  String? operCode;
  int? tid;
  @JsonKey(name: 'receive_level')
  int? receiveLevel;
  @JsonKey(name: 'mission_objective_id')
  int? missionObjectiveId;
  int? standara;
  int? statProject;
  @JsonKey(name: 'activity_name')
  String? activityName;
  @JsonKey(name: 'is_money')
  int? isMoney;
  @JsonKey(name: 'activity_standard_amount')
  int? activityStandardAmount;
  int? state;
  @JsonKey(name: 'need_mobile_valid')
  String? needMobileValid;
  @JsonKey(name: 'tasks_id')
  int? tasksId;
  @JsonKey(name: 'tasks_name')
  String? tasksName;
  @JsonKey(name: 'valid_day')
  int? validDay;
  @JsonKey(name: 'receive_integral')
  int? receiveIntegral;
  @JsonKey(name: 'playAmount')
  int? playAmount;
  @JsonKey(name: 'recharger')
  int? recharger;

  ActivityLogredbagModel({
    this.receiveLogId,
    this.receiveType,
    this.receiveAmount,
    this.custId,
    this.level,
    this.levelName,
    this.stateTime,
    this.createTime,
    this.operCode,
    this.tid,
    this.receiveLevel,
    this.missionObjectiveId,
    this.standara,
    this.statProject,
    this.activityName,
    this.isMoney,
    this.activityStandardAmount,
    this.state,
    this.needMobileValid,
    this.tasksId,
    this.tasksName,
    this.validDay,
    this.receiveIntegral,
    this.playAmount,
    this.recharger,
  });

  @override
  String toString() {
    return 'ActivityLogredbagModel(receiveLogId: $receiveLogId, receiveType: $receiveType, receiveAmount: $receiveAmount, custId: $custId, level: $level, levelName: $levelName, stateTime: $stateTime, createTime: $createTime, operCode: $operCode, tid: $tid, receiveLevel: $receiveLevel, missionObjectiveId: $missionObjectiveId, standara: $standara, statProject: $statProject, activityName: $activityName, isMoney: $isMoney, activityStandardAmount: $activityStandardAmount, state: $state, needMobileValid: $needMobileValid, tasksId: $tasksId, tasksName: $tasksName, validDay: $validDay, receiveIntegral: $receiveIntegral, playAmount: $playAmount, recharger: $recharger)';
  }

  factory ActivityLogredbagModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityLogredbagModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityLogredbagModelToJson(this);

  ActivityLogredbagModel copyWith(
      {int? receiveLogId,
      int? receiveType,
      int? receiveAmount,
      int? custId,
      int? level,
      String? levelName,
      int? stateTime,
      int? createTime,
      String? operCode,
      int? tid,
      int? receiveLevel,
      int? missionObjectiveId,
      int? standara,
      int? statProject,
      String? activityName,
      int? isMoney,
      int? activityStandardAmount,
      int? state,
      String? needMobileValid,
      int? tasksId,
      String? tasksName,
      int? validDay,
      int? receiveIntegral,
      int? playAmount,
      int? recharger}) {
    return ActivityLogredbagModel(
      receiveLogId: receiveLogId ?? this.receiveLogId,
      receiveType: receiveType ?? this.receiveType,
      receiveAmount: receiveAmount ?? this.receiveAmount,
      custId: custId ?? this.custId,
      level: level ?? this.level,
      levelName: levelName ?? this.levelName,
      stateTime: stateTime ?? this.stateTime,
      createTime: createTime ?? this.createTime,
      operCode: operCode ?? this.operCode,
      tid: tid ?? this.tid,
      receiveLevel: receiveLevel ?? this.receiveLevel,
      missionObjectiveId: missionObjectiveId ?? this.missionObjectiveId,
      standara: standara ?? this.standara,
      statProject: statProject ?? this.statProject,
      activityName: activityName ?? this.activityName,
      isMoney: isMoney ?? this.isMoney,
      activityStandardAmount:
          activityStandardAmount ?? this.activityStandardAmount,
      state: state ?? this.state,
      needMobileValid: needMobileValid ?? this.needMobileValid,
      tasksId: tasksId ?? this.tasksId,
      tasksName: tasksName ?? this.tasksName,
      validDay: validDay ?? this.validDay,
      receiveIntegral: receiveIntegral ?? this.receiveIntegral,
      playAmount: playAmount ?? this.playAmount,
      recharger: recharger ?? this.recharger,
    );
  }
}
