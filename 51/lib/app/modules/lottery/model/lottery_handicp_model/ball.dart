import 'package:json_annotation/json_annotation.dart';

part 'ball.g.dart';

@JsonSerializable()
class Ball {
  String? id;
  String? name;
  String? cmd;
  String? odds;

  Ball({this.id, this.name, this.cmd, this.odds});

  @override
  String toString() => 'Ball(id: $id, name: $name, cmd: $cmd, odds: $odds)';

  factory Ball.fromJson(Map<String, dynamic> json) => _$BallFromJson(json);

  Map<String, dynamic> toJson() => _$BallToJson(this);

  Ball copyWith({
    String? id,
    String? name,
    String? cmd,
    String? odds,
  }) {
    return Ball(
      id: id ?? this.id,
      name: name ?? this.name,
      cmd: cmd ?? this.cmd,
      odds: odds ?? this.odds,
    );
  }
}
