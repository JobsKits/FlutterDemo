import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';
import 't.dart';

part 'activity_ranklist_model.g.dart';

@JsonSerializable()
class ActivityRanklistModel {
  T? t;
  List<Datum>? data;
  int? count;

  ActivityRanklistModel({this.t, this.data, this.count});

  @override
  String toString() {
    return 'ActivityRanklistModel(t: $t, data: $data, count: $count)';
  }

  factory ActivityRanklistModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityRanklistModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityRanklistModelToJson(this);

  ActivityRanklistModel copyWith({
    T? t,
    List<Datum>? data,
    int? count,
  }) {
    return ActivityRanklistModel(
      t: t ?? this.t,
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }
}
