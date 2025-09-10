import 'package:json_annotation/json_annotation.dart';

import 'ball.dart';

part 'data.g.dart';

@JsonSerializable()
class Data {
  String? id;
  List<Ball>? balls;

  Data({this.id, this.balls});

  @override
  String toString() => 'Data(id: $id, balls: $balls)';

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);

  Data copyWith({
    String? id,
    List<Ball>? balls,
  }) {
    return Data(
      id: id ?? this.id,
      balls: balls ?? this.balls,
    );
  }
}
