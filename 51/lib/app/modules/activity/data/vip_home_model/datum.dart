import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'level_id')
  int? levelId;
  @JsonKey(name: 'level_type')
  int? levelType;
  int? level;
  @JsonKey(name: 'level_name')
  String? levelName;
  @JsonKey(name: 'value_lower')
  int? valueLower;
  @JsonKey(name: 'value_upper')
  int? valueUpper;
  int? state;
  @JsonKey(name: 'state_time')
  int? stateTime;
  @JsonKey(name: 'create_time')
  int? createTime;
  @JsonKey(name: 'oper_code')
  String? operCode;
  int? tid;
  @JsonKey(name: 'level_reward')
  int? levelReward;
  @JsonKey(name: 'level_reward_total')
  int? levelRewardTotal;
  @JsonKey(name: 'day_reward')
  int? dayReward;
  @JsonKey(name: 'week_reward')
  int? weekReward;
  @JsonKey(name: 'month_reward')
  int? monthReward;
  String? groups;
  int? channel;
  int? manager;
  @JsonKey(name: 'sign_day')
  int? signDay;
  @JsonKey(name: 'day_type')
  int? dayType;
  int? monday;
  int? tuesday;
  int? wednesday;
  int? thursday;
  int? friday;
  int? saturday;
  int? sunday;
  int? monday2;
  int? tuesday2;
  int? wednesday2;
  int? thursday2;
  int? friday2;
  int? saturday2;
  int? sunday2;
  @JsonKey(name: 'cumulative_attendance')
  int? cumulativeAttendance;
  @JsonKey(name: 'differ_amount')
  int? differAmount;
  @JsonKey(name: 'balance_differ_amount')
  int? balanceDifferAmount;
  int? isLevelReward;
  int? isExclusiveReward;
  int? isDayReward;
  int? isWeekReward;
  @JsonKey(name: 'web_state')
  int? webState;
  @JsonKey(name: 'isMonth_Reward')
  int? isMonthReward;
  @JsonKey(name: 'day_skill')
  int? daySkill;
  int? scale;
  @JsonKey(name: 'borrow_amount')
  int? borrowAmount;
  @JsonKey(name: 'asse_price')
  int? assePrice;
  @JsonKey(name: 'sign_type')
  int? signType;
  @JsonKey(name: 'today_order_cnt')
  int? todayOrderCnt;
  @JsonKey(name: 'is_auto')
  int? isAuto;
  @JsonKey(name: 'balance_lower')
  int? balanceLower;
  @JsonKey(name: 'balance_upper')
  int? balanceUpper;
  @JsonKey(name: 'rebate_scale')
  String? rebateScale;
  @JsonKey(name: 'day_bet_cnt')
  int? dayBetCnt;
  @JsonKey(name: 'quantify_income_rate')
  String? quantifyIncomeRate;
  @JsonKey(name: 'quantify_income_scale')
  String? quantifyIncomeScale;
  @JsonKey(name: 'quantify_income_rate_show')
  String? quantifyIncomeRateShow;
  @JsonKey(name: 'quantify_amount_min')
  int? quantifyAmountMin;
  @JsonKey(name: 'quantify_amount_max')
  int? quantifyAmountMax;
  @JsonKey(name: 'robot_price')
  int? robotPrice;
  @JsonKey(name: 'robot_valid')
  int? robotValid;
  @JsonKey(name: 'day_salary')
  int? daySalary;
  @JsonKey(name: 'week_salary')
  int? weekSalary;
  @JsonKey(name: 'month_salary')
  int? monthSalary;
  @JsonKey(name: 'withdraw_limit')
  int? withdrawLimit;
  @JsonKey(name: 'withdraw_cnt')
  int? withdrawCnt;
  @JsonKey(name: 'is_automatic')
  int? isAutomatic;
  @JsonKey(name: 'relegation_day')
  int? relegationDay;
  @JsonKey(name: 'relegation_bet_lower')
  int? relegationBetLower;
  @JsonKey(name: 'relegation_bet_upper')
  int? relegationBetUpper;
  @JsonKey(name: 'relegation_charge_lower')
  int? relegationChargeLower;
  @JsonKey(name: 'relegation_charge_upper')
  int? relegationChargeUpper;
  @JsonKey(name: 'withdraw_free_cnt')
  int? withdrawFreeCnt;
  @JsonKey(name: 'withdraw_free')
  String? withdrawFree;
  @JsonKey(name: 'points_bonus')
  String? pointsBonus;
  @JsonKey(name: 'rebate_bonus')
  String? rebateBonus;
  @JsonKey(name: 'return_water_bonus')
  String? returnWaterBonus;
  @JsonKey(name: 'vip_log_url')
  String? vipLogUrl;
  @JsonKey(name: 'withdraw_upper_limit')
  int? withdrawUpperLimit;
  @JsonKey(name: 'relegation_mode')
  int? relegationMode;
  @JsonKey(name: 'refresh_type')
  int? refreshType;
  @JsonKey(name: 'daily_withdrawal_limit')
  int? dailyWithdrawalLimit;
  @JsonKey(name: 'lottery_odds')
  int? lotteryOdds;
  @JsonKey(name: 'birthday_red_packet')
  int? birthdayRedPacket;
  int? hasVipConfig;
  @JsonKey(name: 'exclusive_red_packet')
  int? exclusiveRedPacket;
  @JsonKey(name: 'exclusive_red_packet_bet')
  int? exclusiveRedPacketBet;

  Datum({
    this.levelId,
    this.levelType,
    this.level,
    this.levelName,
    this.valueLower,
    this.valueUpper,
    this.state,
    this.stateTime,
    this.createTime,
    this.operCode,
    this.tid,
    this.levelReward,
    this.levelRewardTotal,
    this.dayReward,
    this.weekReward,
    this.monthReward,
    this.groups,
    this.channel,
    this.manager,
    this.signDay,
    this.dayType,
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
    this.monday2,
    this.tuesday2,
    this.wednesday2,
    this.thursday2,
    this.friday2,
    this.saturday2,
    this.sunday2,
    this.cumulativeAttendance,
    this.differAmount,
    this.balanceDifferAmount,
    this.isLevelReward,
    this.isExclusiveReward,
    this.isDayReward,
    this.isWeekReward,
    this.webState,
    this.isMonthReward,
    this.daySkill,
    this.scale,
    this.borrowAmount,
    this.assePrice,
    this.signType,
    this.todayOrderCnt,
    this.isAuto,
    this.balanceLower,
    this.balanceUpper,
    this.rebateScale,
    this.dayBetCnt,
    this.quantifyIncomeRate,
    this.quantifyIncomeScale,
    this.quantifyIncomeRateShow,
    this.quantifyAmountMin,
    this.quantifyAmountMax,
    this.robotPrice,
    this.robotValid,
    this.daySalary,
    this.weekSalary,
    this.monthSalary,
    this.withdrawLimit,
    this.withdrawCnt,
    this.isAutomatic,
    this.relegationDay,
    this.relegationBetLower,
    this.relegationBetUpper,
    this.relegationChargeLower,
    this.relegationChargeUpper,
    this.withdrawFreeCnt,
    this.withdrawFree,
    this.pointsBonus,
    this.rebateBonus,
    this.returnWaterBonus,
    this.vipLogUrl,
    this.withdrawUpperLimit,
    this.relegationMode,
    this.refreshType,
    this.dailyWithdrawalLimit,
    this.lotteryOdds,
    this.birthdayRedPacket,
    this.hasVipConfig,
    this.exclusiveRedPacket,
    this.exclusiveRedPacketBet,
  });

  @override
  String toString() {
    return 'Datum(levelId: $levelId, levelType: $levelType, level: $level, levelName: $levelName, valueLower: $valueLower, valueUpper: $valueUpper, state: $state, stateTime: $stateTime, createTime: $createTime, operCode: $operCode, tid: $tid, levelReward: $levelReward, levelRewardTotal: $levelRewardTotal, dayReward: $dayReward, weekReward: $weekReward, monthReward: $monthReward, groups: $groups, channel: $channel, manager: $manager, signDay: $signDay, dayType: $dayType, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, monday2: $monday2, tuesday2: $tuesday2, wednesday2: $wednesday2, thursday2: $thursday2, friday2: $friday2, saturday2: $saturday2, sunday2: $sunday2, cumulativeAttendance: $cumulativeAttendance, differAmount: $differAmount, balanceDifferAmount: $balanceDifferAmount, isLevelReward: $isLevelReward, isExclusiveReward: $isExclusiveReward, isDayReward: $isDayReward, isWeekReward: $isWeekReward, webState: $webState, isMonthReward: $isMonthReward, daySkill: $daySkill, scale: $scale, borrowAmount: $borrowAmount, assePrice: $assePrice, signType: $signType, todayOrderCnt: $todayOrderCnt, isAuto: $isAuto, balanceLower: $balanceLower, balanceUpper: $balanceUpper, rebateScale: $rebateScale, dayBetCnt: $dayBetCnt, quantifyIncomeRate: $quantifyIncomeRate, quantifyIncomeScale: $quantifyIncomeScale, quantifyIncomeRateShow: $quantifyIncomeRateShow, quantifyAmountMin: $quantifyAmountMin, quantifyAmountMax: $quantifyAmountMax, robotPrice: $robotPrice, robotValid: $robotValid, daySalary: $daySalary, weekSalary: $weekSalary, monthSalary: $monthSalary, withdrawLimit: $withdrawLimit, withdrawCnt: $withdrawCnt, isAutomatic: $isAutomatic, relegationDay: $relegationDay, relegationBetLower: $relegationBetLower, relegationBetUpper: $relegationBetUpper, relegationChargeLower: $relegationChargeLower, relegationChargeUpper: $relegationChargeUpper, withdrawFreeCnt: $withdrawFreeCnt, withdrawFree: $withdrawFree, pointsBonus: $pointsBonus, rebateBonus: $rebateBonus, returnWaterBonus: $returnWaterBonus, vipLogUrl: $vipLogUrl, withdrawUpperLimit: $withdrawUpperLimit, relegationMode: $relegationMode, refreshType: $refreshType, dailyWithdrawalLimit: $dailyWithdrawalLimit, lotteryOdds: $lotteryOdds, birthdayRedPacket: $birthdayRedPacket, hasVipConfig: $hasVipConfig, exclusiveRedPacket: $exclusiveRedPacket, exclusiveRedPacketBet: $exclusiveRedPacketBet)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? levelId,
    int? levelType,
    int? level,
    String? levelName,
    int? valueLower,
    int? valueUpper,
    int? state,
    int? stateTime,
    int? createTime,
    String? operCode,
    int? tid,
    int? levelReward,
    int? levelRewardTotal,
    int? dayReward,
    int? weekReward,
    int? monthReward,
    String? groups,
    int? channel,
    int? manager,
    int? signDay,
    int? dayType,
    int? monday,
    int? tuesday,
    int? wednesday,
    int? thursday,
    int? friday,
    int? saturday,
    int? sunday,
    int? monday2,
    int? tuesday2,
    int? wednesday2,
    int? thursday2,
    int? friday2,
    int? saturday2,
    int? sunday2,
    int? cumulativeAttendance,
    int? differAmount,
    int? balanceDifferAmount,
    int? isLevelReward,
    int? isExclusiveReward,
    int? isDayReward,
    int? isWeekReward,
    int? webState,
    int? isMonthReward,
    int? daySkill,
    int? scale,
    int? borrowAmount,
    int? assePrice,
    int? signType,
    int? todayOrderCnt,
    int? isAuto,
    int? balanceLower,
    int? balanceUpper,
    String? rebateScale,
    int? dayBetCnt,
    String? quantifyIncomeRate,
    String? quantifyIncomeScale,
    String? quantifyIncomeRateShow,
    int? quantifyAmountMin,
    int? quantifyAmountMax,
    int? robotPrice,
    int? robotValid,
    int? daySalary,
    int? weekSalary,
    int? monthSalary,
    int? withdrawLimit,
    int? withdrawCnt,
    int? isAutomatic,
    int? relegationDay,
    int? relegationBetLower,
    int? relegationBetUpper,
    int? relegationChargeLower,
    int? relegationChargeUpper,
    int? withdrawFreeCnt,
    String? withdrawFree,
    String? pointsBonus,
    String? rebateBonus,
    String? returnWaterBonus,
    String? vipLogUrl,
    int? withdrawUpperLimit,
    int? relegationMode,
    int? refreshType,
    int? dailyWithdrawalLimit,
    int? lotteryOdds,
    int? birthdayRedPacket,
    int? hasVipConfig,
    int? exclusiveRedPacket,
    int? exclusiveRedPacketBet,
  }) {
    return Datum(
      levelId: levelId ?? this.levelId,
      levelType: levelType ?? this.levelType,
      level: level ?? this.level,
      levelName: levelName ?? this.levelName,
      valueLower: valueLower ?? this.valueLower,
      valueUpper: valueUpper ?? this.valueUpper,
      state: state ?? this.state,
      stateTime: stateTime ?? this.stateTime,
      createTime: createTime ?? this.createTime,
      operCode: operCode ?? this.operCode,
      tid: tid ?? this.tid,
      levelReward: levelReward ?? this.levelReward,
      levelRewardTotal: levelRewardTotal ?? this.levelRewardTotal,
      dayReward: dayReward ?? this.dayReward,
      weekReward: weekReward ?? this.weekReward,
      monthReward: monthReward ?? this.monthReward,
      groups: groups ?? this.groups,
      channel: channel ?? this.channel,
      manager: manager ?? this.manager,
      signDay: signDay ?? this.signDay,
      dayType: dayType ?? this.dayType,
      monday: monday ?? this.monday,
      tuesday: tuesday ?? this.tuesday,
      wednesday: wednesday ?? this.wednesday,
      thursday: thursday ?? this.thursday,
      friday: friday ?? this.friday,
      saturday: saturday ?? this.saturday,
      sunday: sunday ?? this.sunday,
      monday2: monday2 ?? this.monday2,
      tuesday2: tuesday2 ?? this.tuesday2,
      wednesday2: wednesday2 ?? this.wednesday2,
      thursday2: thursday2 ?? this.thursday2,
      friday2: friday2 ?? this.friday2,
      saturday2: saturday2 ?? this.saturday2,
      sunday2: sunday2 ?? this.sunday2,
      cumulativeAttendance: cumulativeAttendance ?? this.cumulativeAttendance,
      differAmount: differAmount ?? this.differAmount,
      balanceDifferAmount: balanceDifferAmount ?? this.balanceDifferAmount,
      isLevelReward: isLevelReward ?? this.isLevelReward,
      isExclusiveReward: isExclusiveReward ?? this.isExclusiveReward,
      isDayReward: isDayReward ?? this.isDayReward,
      isWeekReward: isWeekReward ?? this.isWeekReward,
      webState: webState ?? this.webState,
      isMonthReward: isMonthReward ?? this.isMonthReward,
      daySkill: daySkill ?? this.daySkill,
      scale: scale ?? this.scale,
      borrowAmount: borrowAmount ?? this.borrowAmount,
      assePrice: assePrice ?? this.assePrice,
      signType: signType ?? this.signType,
      todayOrderCnt: todayOrderCnt ?? this.todayOrderCnt,
      isAuto: isAuto ?? this.isAuto,
      balanceLower: balanceLower ?? this.balanceLower,
      balanceUpper: balanceUpper ?? this.balanceUpper,
      rebateScale: rebateScale ?? this.rebateScale,
      dayBetCnt: dayBetCnt ?? this.dayBetCnt,
      quantifyIncomeRate: quantifyIncomeRate ?? this.quantifyIncomeRate,
      quantifyIncomeScale: quantifyIncomeScale ?? this.quantifyIncomeScale,
      quantifyIncomeRateShow:
          quantifyIncomeRateShow ?? this.quantifyIncomeRateShow,
      quantifyAmountMin: quantifyAmountMin ?? this.quantifyAmountMin,
      quantifyAmountMax: quantifyAmountMax ?? this.quantifyAmountMax,
      robotPrice: robotPrice ?? this.robotPrice,
      robotValid: robotValid ?? this.robotValid,
      daySalary: daySalary ?? this.daySalary,
      weekSalary: weekSalary ?? this.weekSalary,
      monthSalary: monthSalary ?? this.monthSalary,
      withdrawLimit: withdrawLimit ?? this.withdrawLimit,
      withdrawCnt: withdrawCnt ?? this.withdrawCnt,
      isAutomatic: isAutomatic ?? this.isAutomatic,
      relegationDay: relegationDay ?? this.relegationDay,
      relegationBetLower: relegationBetLower ?? this.relegationBetLower,
      relegationBetUpper: relegationBetUpper ?? this.relegationBetUpper,
      relegationChargeLower:
          relegationChargeLower ?? this.relegationChargeLower,
      relegationChargeUpper:
          relegationChargeUpper ?? this.relegationChargeUpper,
      withdrawFreeCnt: withdrawFreeCnt ?? this.withdrawFreeCnt,
      withdrawFree: withdrawFree ?? this.withdrawFree,
      pointsBonus: pointsBonus ?? this.pointsBonus,
      rebateBonus: rebateBonus ?? this.rebateBonus,
      returnWaterBonus: returnWaterBonus ?? this.returnWaterBonus,
      vipLogUrl: vipLogUrl ?? this.vipLogUrl,
      withdrawUpperLimit: withdrawUpperLimit ?? this.withdrawUpperLimit,
      relegationMode: relegationMode ?? this.relegationMode,
      refreshType: refreshType ?? this.refreshType,
      dailyWithdrawalLimit: dailyWithdrawalLimit ?? this.dailyWithdrawalLimit,
      lotteryOdds: lotteryOdds ?? this.lotteryOdds,
      birthdayRedPacket: birthdayRedPacket ?? this.birthdayRedPacket,
      hasVipConfig: hasVipConfig ?? this.hasVipConfig,
      exclusiveRedPacket: exclusiveRedPacket ?? this.exclusiveRedPacket,
      exclusiveRedPacketBet:
          exclusiveRedPacketBet ?? this.exclusiveRedPacketBet,
    );
  }
}
