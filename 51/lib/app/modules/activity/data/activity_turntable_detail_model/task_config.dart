import 'package:json_annotation/json_annotation.dart';

part 'task_config.g.dart';

@JsonSerializable()
class TaskConfig {
  String? type;
  int? target;
  int? source;
  dynamic gameType;

  TaskConfig({this.type, this.target, this.source, this.gameType});

  @override
  String toString() {
    return 'TaskConfig(type: $type, target: $target, source: $source, gameType: $gameType)';
  }

  factory TaskConfig.fromJson(Map<String, dynamic> json) {
    return _$TaskConfigFromJson(json);
  }

  Map<String, dynamic> toJson() => _$TaskConfigToJson(this);

  TaskConfig copyWith({
    String? type,
    int? target,
    int? source,
    dynamic gameType,
  }) {
    return TaskConfig(
      type: type ?? this.type,
      target: target ?? this.target,
      source: source ?? this.source,
      gameType: gameType ?? this.gameType,
    );
  }
}
