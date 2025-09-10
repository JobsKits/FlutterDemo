import 'package:json_annotation/json_annotation.dart';

import 'datum.dart';

part 'activity_apply_records_model.g.dart';

@JsonSerializable()
class ActivityApplyRecordsModel {
  int? count;
  List<Datum>? data;

  ActivityApplyRecordsModel({this.count, this.data});

  @override
  String toString() {
    return 'ActivityApplyRecordsModel(count: $count, data: $data)';
  }

  factory ActivityApplyRecordsModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityApplyRecordsModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityApplyRecordsModelToJson(this);

  ActivityApplyRecordsModel copyWith({
    int? count,
    List<Datum>? data,
  }) {
    return ActivityApplyRecordsModel(
      count: count ?? this.count,
      data: data ?? this.data,
    );
  }
}
