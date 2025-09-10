import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';
import 't.dart';

part 'task_newcomers_model.g.dart';

@JsonSerializable()
class TaskNewcomersModel {
  T? t;
  List<Datum>? data;
  int? count;

  TaskNewcomersModel({this.t, this.data, this.count});

  @override
  String toString() {
    return 'TaskNewcomersModel(t: $t, data: $data, count: $count)';
  }

  factory TaskNewcomersModel.fromJson(Map<String, dynamic> json) {
    return _$TaskNewcomersModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TaskNewcomersModelToJson(this);

  TaskNewcomersModel copyWith({
    T? t,
    List<Datum>? data,
    int? count,
  }) {
    return TaskNewcomersModel(
      t: t ?? this.t,
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }
}
