import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'activity_winning_model.g.dart';

@JsonSerializable()
class ActivityWinningModel {
  int? count;
  int? t;
  List<Datum>? data;

  ActivityWinningModel({this.count, this.data, int? t});

  @override
  String toString() => 'ActivityWinningModel(count: $count, data: $data)';

  factory ActivityWinningModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityWinningModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityWinningModelToJson(this);

  ActivityWinningModel copyWith({
    int? count,
    int? t,
    List<Datum>? data,
  }) {
    return ActivityWinningModel(
      count: count ?? this.count,
      t: t ?? this.t,
      data: data ?? this.data,
    );
  }
}
