import 'package:json_annotation/json_annotation.dart';

import 'wheel_grid.dart';

part 'wheel_config.g.dart';

@JsonSerializable()
class WheelConfig {
  int? wheelType;
  int? source;
  List<WheelGrid>? wheelGrids;

  WheelConfig({this.wheelType, this.source, this.wheelGrids});

  @override
  String toString() {
    return 'WheelConfig(wheelType: $wheelType, source: $source, wheelGrids: $wheelGrids)';
  }

  factory WheelConfig.fromJson(Map<String, dynamic> json) {
    return _$WheelConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$WheelConfigToJson(this);

  WheelConfig copyWith({
    int? wheelType,
    int? source,
    List<WheelGrid>? wheelGrids,
  }) {
    return WheelConfig(
      wheelType: wheelType ?? this.wheelType,
      source: source ?? this.source,
      wheelGrids: wheelGrids ?? this.wheelGrids,
    );
  }
}
