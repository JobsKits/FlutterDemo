import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'activity_float_model.g.dart';

@JsonSerializable()
class ActivityFloatModel {
  int? count;
  List<Datum>? data;

  ActivityFloatModel({this.count, this.data});

  @override
  String toString() => 'ActivityFloatModel(count: $count, data: $data)';

  factory ActivityFloatModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityFloatModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityFloatModelToJson(this);

  ActivityFloatModel copyWith({
    int? count,
    List<Datum>? data,
  }) {
    return ActivityFloatModel(
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }
}
