import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'notice_marquee_model.g.dart';

@JsonSerializable()
class NoticeMarqueeModel {
  int? count;
  List<Datum>? data;

  NoticeMarqueeModel({this.count, this.data});

  @override
  String toString() => 'NoticeMarqueeModel(count: $count, data: $data)';

  factory NoticeMarqueeModel.fromJson(Map<String, dynamic> json) {
    return _$NoticeMarqueeModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$NoticeMarqueeModelToJson(this);

  NoticeMarqueeModel copyWith({
    int? count,
    List<Datum>? data,
  }) {
    return NoticeMarqueeModel(
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }
}
