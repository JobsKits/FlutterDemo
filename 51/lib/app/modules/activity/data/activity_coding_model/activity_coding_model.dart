import 'package:json_annotation/json_annotation.dart';

import 't.dart';

part 'activity_coding_model.g.dart';

@JsonSerializable()
class ActivityCodingModel {
  T? t;
  @JsonKey(name: 'response_code')
  String? responseCode;
  String? msg;

  ActivityCodingModel({this.t, this.responseCode, this.msg});

  @override
  String toString() {
    return 'ActivityCodingModel(t: $t, responseCode: $responseCode, msg: $msg)';
  }

  factory ActivityCodingModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityCodingModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityCodingModelToJson(this);

  ActivityCodingModel copyWith({
    T? t,
    String? responseCode,
    String? msg,
  }) {
    return ActivityCodingModel(
      t: t ?? this.t,
      responseCode: responseCode ?? this.responseCode,
      msg: msg ?? this.msg,
    );
  }
}
