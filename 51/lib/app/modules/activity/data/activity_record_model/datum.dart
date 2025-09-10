import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'receive_amount')
  int? receiveAmount;

  @JsonKey(name: 'state_time')
  int? stateTime;

  @JsonKey(name: 'create_time')
  int? createTime;

  @JsonKey(name: 'activity_name')
  String? activityName;

  @JsonKey(name: 'tasks_id')
  int? tasksId;

  @JsonKey(name: 'tasks_name')
  String? tasksName;

  @JsonKey(name: 'state')
  int? state;

  @JsonKey(name: 'receive_log_id')
  int? receiveLogId;

  Datum({
    this.receiveAmount,
    this.stateTime,
    this.createTime,
    this.activityName,
    this.tasksId,
    this.tasksName,
    this.state,
    this.receiveLogId,
  });

  @override
  String toString() {
    return 'Datum(receiveAmount: $receiveAmount, stateTime: $stateTime, createTime: $createTime, activityName: $activityName, tasksId: $tasksId, tasksName: $tasksName, state: $state, receiveLogId: $receiveLogId)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? receiveAmount,
    int? stateTime,
    int? createTime,
    String? activityName,
    int? tasksId,
    String? tasksName,
    int? state,
    int? receiveLogId,
  }) {
    return Datum(
      receiveAmount: receiveAmount ?? this.receiveAmount,
      stateTime: stateTime ?? this.stateTime,
      createTime: createTime ?? this.createTime,
      activityName: activityName ?? this.activityName,
      tasksId: tasksId ?? this.tasksId,
      tasksName: tasksName ?? this.tasksName,
      state: state ?? this.state,
      receiveLogId: receiveLogId ?? this.receiveLogId,
    );
  }
}
