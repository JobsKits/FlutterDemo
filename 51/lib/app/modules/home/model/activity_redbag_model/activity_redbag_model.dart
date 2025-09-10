import 'package:json_annotation/json_annotation.dart';

part 'activity_redbag_model.g.dart';

@JsonSerializable()
class ActivityRedbagModel {
  int? money;
  int? integral;
  int? time;
  int? type;

  ActivityRedbagModel({this.money, this.integral, this.time, this.type});

  @override
  String toString() {
    return 'ActivityRedbagModel(money: $money, integral: $integral, time: $time, type: $type)';
  }

  factory ActivityRedbagModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityRedbagModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityRedbagModelToJson(this);

  ActivityRedbagModel copyWith({
    int? money,
    int? integral,
    int? time,
    int? type,
  }) {
    return ActivityRedbagModel(
      money: money ?? this.money,
      integral: integral ?? this.integral,
      time: time ?? this.time,
      type: type ?? this.type,
    );
  }
}
