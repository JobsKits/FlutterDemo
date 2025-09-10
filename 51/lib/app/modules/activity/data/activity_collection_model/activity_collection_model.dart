import 'package:flutter_tiyu_app/app/modules/activity/data/activity_coding_model/t.dart';
import 'package:json_annotation/json_annotation.dart';
part 'activity_collection_model.g.dart';

@JsonSerializable()
class ActivityCollectionModel {
  int? receiveId;
  int? tid;
  int? custId;
  String? receiveType;
  String? receiveName;
  dynamic receiveEndTime;
  int? receiveStartTime;
  int? reward;
  String? rewardSource;
  T? elotActivityPgForSysConfig;

  ActivityCollectionModel({
    this.receiveId,
    this.tid,
    this.custId,
    this.receiveType,
    this.receiveName,
    this.receiveEndTime,
    this.receiveStartTime,
    this.reward,
    this.rewardSource,
    this.elotActivityPgForSysConfig,
  });

  @override
  String toString() {
    return 'ActivityCollectionModel(receiveId: $receiveId, tid: $tid, custId: $custId, receiveType: $receiveType, receiveName: $receiveName, receiveEndTime: $receiveEndTime, receiveStartTime: $receiveStartTime, reward: $reward, rewardSource: $rewardSource, elotActivityPgForSysConfig: $elotActivityPgForSysConfig)';
  }

  factory ActivityCollectionModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityCollectionModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityCollectionModelToJson(this);

  ActivityCollectionModel copyWith({
    int? receiveId,
    int? tid,
    int? custId,
    String? receiveType,
    String? receiveName,
    dynamic receiveEndTime,
    int? receiveStartTime,
    int? reward,
    String? rewardSource,
    T? elotActivityPgForSysConfig,
  }) {
    return ActivityCollectionModel(
      receiveId: receiveId ?? this.receiveId,
      tid: tid ?? this.tid,
      custId: custId ?? this.custId,
      receiveType: receiveType ?? this.receiveType,
      receiveName: receiveName ?? this.receiveName,
      receiveEndTime: receiveEndTime ?? this.receiveEndTime,
      receiveStartTime: receiveStartTime ?? this.receiveStartTime,
      reward: reward ?? this.reward,
      rewardSource: rewardSource ?? this.rewardSource,
      elotActivityPgForSysConfig:
          elotActivityPgForSysConfig ?? this.elotActivityPgForSysConfig,
    );
  }
}
