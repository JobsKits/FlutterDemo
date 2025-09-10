import 'package:json_annotation/json_annotation.dart';

import 'task_date_model.dart';

part 'daily_tasks_model.g.dart';

@JsonSerializable()
class DailyTasksModel {
  List<TaskDateModel>? week;
  List<TaskDateModel>? month;
  List<TaskDateModel>? day;
  int? getAmount;

  DailyTasksModel({this.week, this.month, this.day, this.getAmount});

  @override
  String toString() {
    return 'DailyTasksModel(week: $week, month: $month, day: $day, getAmount: $getAmount)';
  }

  factory DailyTasksModel.fromJson(Map<String, dynamic> json) {
    return _$DailyTasksModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DailyTasksModelToJson(this);

  DailyTasksModel copyWith({
    List<TaskDateModel>? week,
    List<TaskDateModel>? month,
    List<TaskDateModel>? day,
    int? getAmount,
  }) {
    return DailyTasksModel(
      week: week ?? this.week,
      month: month ?? this.month,
      day: day ?? this.day,
      getAmount: getAmount ?? this.getAmount,
    );
  }
}
