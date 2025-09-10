import 'package:json_annotation/json_annotation.dart';

import 'area.dart';

part 'lottery_handicp_model.g.dart';

@JsonSerializable()
class LotteryHandicpModel {
  String? id;
  List<Area>? areas;

  LotteryHandicpModel({this.id, this.areas});

  @override
  String toString() => 'LotteryHandicpModel(id: $id, areas: $areas)';

  factory LotteryHandicpModel.fromJson(Map<String, dynamic> json) {
    return _$LotteryHandicpModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LotteryHandicpModelToJson(this);

  LotteryHandicpModel copyWith({
    String? id,
    List<Area>? areas,
  }) {
    return LotteryHandicpModel(
      id: id ?? this.id,
      areas: areas ?? this.areas,
    );
  }
}
