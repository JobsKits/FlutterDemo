import 'package:json_annotation/json_annotation.dart';

import 'loss_reward.dart';

part 'activity_coding_table_model.g.dart';

@JsonSerializable()
class ActivityCodingTableModel {
  String? rewardType;
  int? expireDay;
  String? sendWay;
  String? statisticalPeriod;
  List<LossReward>? lossRewards;

  ActivityCodingTableModel({
    this.rewardType,
    this.expireDay,
    this.sendWay,
    this.statisticalPeriod,
    this.lossRewards,
  });

  @override
  String toString() {
    return 'ActivityCodingTableModel(rewardType: $rewardType, expireDay: $expireDay, sendWay: $sendWay, statisticalPeriod: $statisticalPeriod, lossRewards: $lossRewards)';
  }

  factory ActivityCodingTableModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityCodingTableModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityCodingTableModelToJson(this);

  ActivityCodingTableModel copyWith({
    String? rewardType,
    int? expireDay,
    String? sendWay,
    String? statisticalPeriod,
    List<LossReward>? lossRewards,
  }) {
    return ActivityCodingTableModel(
      rewardType: rewardType ?? this.rewardType,
      expireDay: expireDay ?? this.expireDay,
      sendWay: sendWay ?? this.sendWay,
      statisticalPeriod: statisticalPeriod ?? this.statisticalPeriod,
      lossRewards: lossRewards ?? this.lossRewards,
    );
  }
}
