import 'dart:ffi';

import 'package:json_annotation/json_annotation.dart';

part 'wheel_grid.g.dart';

@JsonSerializable()
class WheelGrid {
  int? gridId;
  int? rewordAmount;
  double? probability;
  String? giftIcon;

  WheelGrid({
    this.gridId,
    this.rewordAmount,
    this.probability,
    this.giftIcon,
  });

  @override
  String toString() {
    return 'WheelGrid(gridId: $gridId, rewordAmount: $rewordAmount, probability: $probability, giftIcon: $giftIcon)';
  }

  factory WheelGrid.fromJson(Map<String, dynamic> json) {
    return _$WheelGridFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WheelGridToJson(this);

  WheelGrid copyWith({
    int? gridId,
    int? rewordAmount,
    double? probability,
    String? giftIcon,
  }) {
    return WheelGrid(
      gridId: gridId ?? this.gridId,
      rewordAmount: rewordAmount ?? this.rewordAmount,
      probability: probability ?? this.probability,
      giftIcon: giftIcon ?? this.giftIcon,
    );
  }
}
