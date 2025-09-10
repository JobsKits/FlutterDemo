import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  dynamic custId;
  String? taskCode;
  String? taskName;
  int? rewardAmount;
  dynamic activityScore;
  int? status;
  dynamic receiveLogId;

  Datum({
    this.custId,
    this.taskCode,
    this.taskName,
    this.rewardAmount,
    this.activityScore,
    this.status,
    this.receiveLogId,
  });

  @override
  String toString() {
    return 'Datum(custId: $custId, taskCode: $taskCode, taskName: $taskName, rewardAmount: $rewardAmount, activityScore: $activityScore, status: $status, receiveLogId: $receiveLogId)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    dynamic custId,
    String? taskCode,
    String? taskName,
    int? rewardAmount,
    dynamic activityScore,
    int? status,
    dynamic receiveLogId,
  }) {
    return Datum(
      custId: custId ?? this.custId,
      taskCode: taskCode ?? this.taskCode,
      taskName: taskName ?? this.taskName,
      rewardAmount: rewardAmount ?? this.rewardAmount,
      activityScore: activityScore ?? this.activityScore,
      status: status ?? this.status,
      receiveLogId: receiveLogId ?? this.receiveLogId,
    );
  }
}
