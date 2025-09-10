import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';
import 't.dart';

part 'vip_home_model.g.dart';

@JsonSerializable()
class VipHomeModel {
  T? t;
  List<Datum>? data;
  int? count;

  VipHomeModel({this.t, this.data, this.count});

  @override
  String toString() => 'VipHomeModel(t: $t, data: $data, count: $count)';

  factory VipHomeModel.fromJson(Map<String, dynamic> json) {
    return _$VipHomeModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VipHomeModelToJson(this);

  VipHomeModel copyWith({
    T? t,
    List<Datum>? data,
    int? count,
  }) {
    return VipHomeModel(
      t: t ?? this.t,
      data: data ?? this.data,
      count: count ?? this.count,
    );
  }
}
