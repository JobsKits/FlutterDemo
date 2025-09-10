import 'package:json_annotation/json_annotation.dart';

part 'loss_reward.g.dart';

@JsonSerializable()
class LossReward {
  dynamic loss;
  dynamic reward;
  dynamic maxReward;

  LossReward({this.loss, this.reward, this.maxReward});

  @override
  String toString() {
    return 'LossReward(loss: $loss, reward: $reward, maxReward: $maxReward)';
  }

  factory LossReward.fromJson(Map<String, dynamic> json) {
    return _$LossRewardFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LossRewardToJson(this);

  LossReward copyWith({
    dynamic loss,
    dynamic reward,
    dynamic maxReward,
  }) {
    return LossReward(
      loss: loss ?? this.loss,
      reward: reward ?? this.reward,
      maxReward: maxReward ?? this.maxReward,
    );
  }
}
