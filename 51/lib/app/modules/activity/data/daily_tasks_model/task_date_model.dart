import 'package:json_annotation/json_annotation.dart';

part 'task_date_model.g.dart';

@JsonSerializable()
class TaskDateModel {
  int? rewardAmount;
  String? taskName;
  String? taskRemark;
  String? taskType;
  String? taskIcon;
  String? status;
  int? id;
  @JsonKey(name: 'receive_log_id')
  int? receiveLogId;

  TaskDateModel({
    this.rewardAmount,
    this.taskName,
    this.taskRemark,
    this.taskType,
    this.taskIcon,
    this.status,
    this.id,
    this.receiveLogId,
  });

  @override
  String toString() {
    return 'Day(rewardAmount: $rewardAmount, taskName: $taskName, taskRemark: $taskRemark, taskType: $taskType, taskIcon: $taskIcon, status: $status, id: $id, receiveLogId: $receiveLogId)';
  }

  factory TaskDateModel.fromJson(Map<String, dynamic> json) =>
      _$TaskDateModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskDateModelToJson(this);

  TaskDateModel copyWith({
    int? rewardAmount,
    String? taskName,
    String? taskRemark,
    String? taskType,
    String? taskIcon,
    String? status,
    int? id,
    int? receiveLogId,
  }) {
    return TaskDateModel(
      rewardAmount: rewardAmount ?? this.rewardAmount,
      taskName: taskName ?? this.taskName,
      taskRemark: taskRemark ?? this.taskRemark,
      taskType: taskType ?? this.taskType,
      taskIcon: taskIcon ?? this.taskIcon,
      status: status ?? this.status,
      id: id ?? this.id,
      receiveLogId: receiveLogId ?? this.receiveLogId,
    );
  }
}
