import 'package:json_annotation/json_annotation.dart';

import 'k3.dart';

part 'lottery_subplay_model.g.dart';

@JsonSerializable()
class LotterySubplayModel {
  @JsonKey(name: 'K3')
  K3? k3;

  LotterySubplayModel({this.k3});

  @override
  String toString() => 'LotterySubplayModel(k3: $k3)';

  factory LotterySubplayModel.fromJson(Map<String, dynamic> json) {
    return _$LotterySubplayModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LotterySubplayModelToJson(this);

  LotterySubplayModel copyWith({
    K3? k3,
  }) {
    return LotterySubplayModel(
      k3: k3 ?? this.k3,
    );
  }
}
