import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'activity_record_model.g.dart';

@JsonSerializable()
class ActivityRecordModel {
  int? count;
  List<Datum>? data;
  int? t;

  ActivityRecordModel({this.count, this.data, this.t});

  @override
  String toString() => 'ActivityRecordModel(count: $count, data: $data, t: $t)';

  factory ActivityRecordModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityRecordModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityRecordModelToJson(this);

  ActivityRecordModel copyWith({
    int? count,
    List<Datum>? data,
    int? t,
  }) {
    return ActivityRecordModel(
      count: count ?? this.count,
      data: data ?? this.data,
      t: t ?? this.t,
    );
  }
}
