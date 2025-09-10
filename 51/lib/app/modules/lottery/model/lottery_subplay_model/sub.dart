import 'package:json_annotation/json_annotation.dart';

part 'sub.g.dart';

@JsonSerializable()
class Sub {
  String? groupName;
  List<int>? playids;

  Sub({this.groupName, this.playids});

  @override
  String toString() => 'Sub(groupName: $groupName, playids: $playids)';

  factory Sub.fromJson(Map<String, dynamic> json) => _$SubFromJson(json);

  Map<String, dynamic> toJson() => _$SubToJson(this);

  Sub copyWith({
    String? groupName,
    List<int>? playids,
  }) {
    return Sub(
      groupName: groupName ?? this.groupName,
      playids: playids ?? this.playids,
    );
  }
}
