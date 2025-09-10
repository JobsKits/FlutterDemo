import 'package:json_annotation/json_annotation.dart';

import 'sub.dart';

part 'k3.g.dart';

@JsonSerializable()
class K3 {
  List<Sub>? subs;

  K3({this.subs});

  @override
  String toString() => 'K3(subs: $subs)';

  factory K3.fromJson(Map<String, dynamic> json) => _$K3FromJson(json);

  Map<String, dynamic> toJson() => _$K3ToJson(this);

  K3 copyWith({
    List<Sub>? subs,
  }) {
    return K3(
      subs: subs ?? this.subs,
    );
  }
}
