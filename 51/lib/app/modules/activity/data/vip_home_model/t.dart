import 'package:json_annotation/json_annotation.dart';

part 't.g.dart';

@JsonSerializable()
class T {
  @JsonKey(name: 'level_balance_lower')
  int? levelBalanceLower;
  @JsonKey(name: 'week_reward_sum')
  int? weekRewardSum;
  @JsonKey(name: 'week_reward_state')
  int? weekRewardState;
  @JsonKey(name: 'must_required_amount_sum')
  int? mustRequiredAmountSum;
  @JsonKey(name: 'total_bet')
  int? totalBet;
  @JsonKey(name: 'total_recharge')
  int? totalRecharge;
  @JsonKey(name: 'plan_amount')
  int? planAmount;
  @JsonKey(name: 'day_reward_sum')
  int? dayRewardSum;
  @JsonKey(name: 'day_reward_state')
  int? dayRewardState;
  @JsonKey(name: 'exclusive_diff_sum')
  int? exclusiveDiffSum;
  @JsonKey(name: 'birthday_state')
  int? birthdayState;
  @JsonKey(name: 'level_value_lower_sum')
  int? levelValueLowerSum;
  @JsonKey(name: 'must_required_amount_bet')
  int? mustRequiredAmountBet;
  @JsonKey(name: 'must_required_amount1')
  int? mustRequiredAmount1;
  @JsonKey(name: 'exclusive_packet_reward_sum')
  int? exclusivePacketRewardSum;
  @JsonKey(name: 'total_reward_sum')
  int? totalRewardSum;
  @JsonKey(name: 'month_reward_state')
  int? monthRewardState;
  @JsonKey(name: 'level_reward_sum')
  int? levelRewardSum;
  @JsonKey(name: 'month_reward_sum')
  int? monthRewardSum;
  @JsonKey(name: 'charge_amount')
  int? chargeAmount;

  T({
    this.levelBalanceLower,
    this.weekRewardSum,
    this.weekRewardState,
    this.mustRequiredAmountSum,
    this.totalBet,
    this.totalRecharge,
    this.planAmount,
    this.dayRewardSum,
    this.dayRewardState,
    this.exclusiveDiffSum,
    this.birthdayState,
    this.levelValueLowerSum,
    this.mustRequiredAmountBet,
    this.mustRequiredAmount1,
    this.exclusivePacketRewardSum,
    this.totalRewardSum,
    this.monthRewardState,
    this.levelRewardSum,
    this.monthRewardSum,
    this.chargeAmount,
  });

  @override
  String toString() {
    return 'T(levelBalanceLower: $levelBalanceLower, weekRewardSum: $weekRewardSum, weekRewardState: $weekRewardState, mustRequiredAmountSum: $mustRequiredAmountSum, totalBet: $totalBet, totalRecharge: $totalRecharge, planAmount: $planAmount, dayRewardSum: $dayRewardSum, dayRewardState: $dayRewardState, exclusiveDiffSum: $exclusiveDiffSum, birthdayState: $birthdayState, levelValueLowerSum: $levelValueLowerSum, mustRequiredAmountBet: $mustRequiredAmountBet, mustRequiredAmount1: $mustRequiredAmount1, exclusivePacketRewardSum: $exclusivePacketRewardSum, totalRewardSum: $totalRewardSum, monthRewardState: $monthRewardState, levelRewardSum: $levelRewardSum, monthRewardSum: $monthRewardSum, chargeAmount: $chargeAmount)';
  }

  factory T.fromJson(Map<String, dynamic> json) => _$TFromJson(json);

  Map<String, dynamic> toJson() => _$TToJson(this);

  T copyWith({
    int? levelBalanceLower,
    int? weekRewardSum,
    int? weekRewardState,
    int? mustRequiredAmountSum,
    int? totalBet,
    int? totalRecharge,
    int? planAmount,
    int? dayRewardSum,
    int? dayRewardState,
    int? exclusiveDiffSum,
    int? birthdayState,
    int? levelValueLowerSum,
    int? mustRequiredAmountBet,
    int? mustRequiredAmount1,
    int? exclusivePacketRewardSum,
    int? totalRewardSum,
    int? monthRewardState,
    int? levelRewardSum,
    int? monthRewardSum,
    int? chargeAmount,
  }) {
    return T(
      levelBalanceLower: levelBalanceLower ?? this.levelBalanceLower,
      weekRewardSum: weekRewardSum ?? this.weekRewardSum,
      weekRewardState: weekRewardState ?? this.weekRewardState,
      mustRequiredAmountSum:
          mustRequiredAmountSum ?? this.mustRequiredAmountSum,
      totalBet: totalBet ?? this.totalBet,
      totalRecharge: totalRecharge ?? this.totalRecharge,
      planAmount: planAmount ?? this.planAmount,
      dayRewardSum: dayRewardSum ?? this.dayRewardSum,
      dayRewardState: dayRewardState ?? this.dayRewardState,
      exclusiveDiffSum: exclusiveDiffSum ?? this.exclusiveDiffSum,
      birthdayState: birthdayState ?? this.birthdayState,
      levelValueLowerSum: levelValueLowerSum ?? this.levelValueLowerSum,
      mustRequiredAmountBet:
          mustRequiredAmountBet ?? this.mustRequiredAmountBet,
      mustRequiredAmount1: mustRequiredAmount1 ?? this.mustRequiredAmount1,
      exclusivePacketRewardSum:
          exclusivePacketRewardSum ?? this.exclusivePacketRewardSum,
      totalRewardSum: totalRewardSum ?? this.totalRewardSum,
      monthRewardState: monthRewardState ?? this.monthRewardState,
      levelRewardSum: levelRewardSum ?? this.levelRewardSum,
      monthRewardSum: monthRewardSum ?? this.monthRewardSum,
      chargeAmount: chargeAmount ?? this.chargeAmount,
    );
  }
}
