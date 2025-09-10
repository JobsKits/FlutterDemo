import 'package:json_annotation/json_annotation.dart';

import 'data.dart';

part 'area.g.dart';

@JsonSerializable()
class Area {
  String? show;
  int? baseballid;
  int? ballpanid;
  Data? data;

  Area({this.show, this.baseballid, this.ballpanid, this.data});

  @override
  String toString() {
    return 'Area(show: $show, baseballid: $baseballid, ballpanid: $ballpanid, data: $data)';
  }

  factory Area.fromJson(Map<String, dynamic> json) => _$AreaFromJson(json);

  Map<String, dynamic> toJson() => _$AreaToJson(this);

  Area copyWith({
    String? show,
    int? baseballid,
    int? ballpanid,
    Data? data,
  }) {
    return Area(
      show: show ?? this.show,
      baseballid: baseballid ?? this.baseballid,
      ballpanid: ballpanid ?? this.ballpanid,
      data: data ?? this.data,
    );
  }
}
