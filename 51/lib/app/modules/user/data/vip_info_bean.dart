///vip的实体类
class VipInfoBean {
  VipInfoBean({
    this.count,
    this.data,
    this.t,
  });

  VipInfoBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(VipLevelItemBean.fromJson(v));
      });
    }
    if (json['t'] != null) {
      t = VipTotalBean.fromJson(json['t']);
    }
  }

  int? count;
  List<VipLevelItemBean>? data;
  VipTotalBean? t;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;

    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (t != null) {
      map['t'] = t?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'VipInfoBean{count: $count, data: $data, t: $t}';
  }
}

class VipLevelItemBean {
  VipLevelItemBean({
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
    this.cumulativeAttendance,
    this.differAmount,
    this.balanceDifferAmount,
    this.isLevelReward,
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
    this.birthdayRedPacket,
  });

  VipLevelItemBean.fromJson(dynamic json) {
    levelId = json['level_id'];
    levelType = json['level_type'];
    level = json['level'];
    levelName = json['level_name'];
    valueLower = json['value_lower'];
    valueUpper = json['value_upper'];
    state = json['state'];
    stateTime = json['state_time'];
    createTime = json['create_time'];
    operCode = json['oper_code'];
    tid = json['tid'];
    levelReward = json['level_reward'];
    levelRewardTotal = json['level_reward_total'];
    dayReward = json['day_reward'];
    weekReward = json['week_reward'];
    monthReward = json['month_reward'];
    groups = json['groups'];
    channel = json['channel'];
    manager = json['manager'];
    signDay = json['sign_day'];
    dayType = json['day_type'];
    monday = json['monday'];
    tuesday = json['tuesday'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    saturday = json['saturday'];
    sunday = json['sunday'];
    cumulativeAttendance = json['cumulative_attendance'];
    differAmount = json['differ_amount'];
    balanceDifferAmount = json['balance_differ_amount'];
    isLevelReward = json['isLevelReward'];
    isDayReward = json['isDayReward'];
    isWeekReward = json['isWeekReward'];
    webState = json['web_state'];
    isMonthReward = json['isMonth_Reward'];
    daySkill = json['day_skill'];
    scale = json['scale'];
    borrowAmount = json['borrow_amount'];
    assePrice = json['asse_price'];
    signType = json['sign_type'];
    todayOrderCnt = json['today_order_cnt'];
    isAuto = json['is_auto'];
    balanceLower = json['balance_lower'];
    balanceUpper = json['balance_upper'];
    rebateScale = json['rebate_scale'];
    dayBetCnt = json['day_bet_cnt'];
    quantifyIncomeRate = json['quantify_income_rate'];
    quantifyIncomeScale = json['quantify_income_scale'];
    quantifyIncomeRateShow = json['quantify_income_rate_show'];
    quantifyAmountMin = json['quantify_amount_min'];
    quantifyAmountMax = json['quantify_amount_max'];
    robotPrice = json['robot_price'];
    robotValid = json['robot_valid'];
    daySalary = json['day_salary'];
    weekSalary = json['week_salary'];
    monthSalary = json['month_salary'];
    withdrawLimit = json['withdraw_limit'];
    withdrawCnt = json['withdraw_cnt'];
    isAutomatic = json['is_automatic'];
    relegationDay = json['relegation_day'];
    relegationBetLower = json['relegation_bet_lower'];
    relegationBetUpper = json['relegation_bet_upper'];
    relegationChargeLower = json['relegation_charge_lower'];
    relegationChargeUpper = json['relegation_charge_upper'];
    withdrawFreeCnt = json['withdraw_free_cnt'];
    withdrawFree = json['withdraw_free'];
    pointsBonus = json['points_bonus'];
    rebateBonus = json['rebate_bonus'];
    returnWaterBonus = json['return_water_bonus'];
    vipLogUrl = json['vip_log_url'];
    withdrawUpperLimit = json['withdraw_upper_limit'];
    relegationMode = json['relegation_mode'];
    refreshType = json['refresh_type'];
    dailyWithdrawalLimit = json['daily_withdrawal_limit'];
    birthdayRedPacket = json['birthday_red_packet'];
  }
  int? levelId;
  int? levelType;
  int? level;
  String? levelName;
  int? valueLower;
  int? valueUpper;
  int? state;
  int? stateTime;
  int? createTime;
  String? operCode;
  int? tid;
  int? levelReward;
  int? levelRewardTotal;
  int? dayReward;
  int? weekReward;
  int? monthReward;
  String? groups;
  int? channel;
  int? manager;
  int? signDay;
  int? dayType;
  int? monday;
  int? tuesday;
  int? wednesday;
  int? thursday;
  int? friday;
  int? saturday;
  int? sunday;
  int? cumulativeAttendance;
  int? differAmount;
  int? balanceDifferAmount;
  int? isLevelReward;
  int? isDayReward;
  int? isWeekReward;
  int? webState;
  int? isMonthReward;
  int? daySkill;
  int? scale;
  int? borrowAmount;
  int? assePrice;
  int? signType;
  int? todayOrderCnt;
  int? isAuto;
  int? balanceLower;
  int? balanceUpper;
  String? rebateScale;
  int? dayBetCnt;
  String? quantifyIncomeRate;
  String? quantifyIncomeScale;
  String? quantifyIncomeRateShow;
  int? quantifyAmountMin;
  int? quantifyAmountMax;
  int? robotPrice;
  int? robotValid;
  int? daySalary;
  int? weekSalary;
  int? monthSalary;
  int? withdrawLimit;
  int? withdrawCnt;
  int? isAutomatic;
  int? relegationDay;
  int? relegationBetLower;
  int? relegationBetUpper;
  int? relegationChargeLower;
  int? relegationChargeUpper;
  int? withdrawFreeCnt;
  String? withdrawFree;
  String? pointsBonus;
  String? rebateBonus;
  String? returnWaterBonus;
  String? vipLogUrl;
  int? withdrawUpperLimit;
  int? relegationMode;
  int? refreshType;
  int? dailyWithdrawalLimit;
  int? birthdayRedPacket;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['level_id'] = levelId;
    map['level_type'] = levelType;
    map['level'] = level;
    map['level_name'] = levelName;
    map['value_lower'] = valueLower;
    map['value_upper'] = valueUpper;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['create_time'] = createTime;
    map['oper_code'] = operCode;
    map['tid'] = tid;
    map['level_reward'] = levelReward;
    map['level_reward_total'] = levelRewardTotal;
    map['day_reward'] = dayReward;
    map['week_reward'] = weekReward;
    map['month_reward'] = monthReward;
    map['groups'] = groups;
    map['channel'] = channel;
    map['manager'] = manager;
    map['sign_day'] = signDay;
    map['day_type'] = dayType;
    map['monday'] = monday;
    map['tuesday'] = tuesday;
    map['wednesday'] = wednesday;
    map['thursday'] = thursday;
    map['friday'] = friday;
    map['saturday'] = saturday;
    map['sunday'] = sunday;
    map['cumulative_attendance'] = cumulativeAttendance;
    map['differ_amount'] = differAmount;
    map['balance_differ_amount'] = balanceDifferAmount;
    map['isLevelReward'] = isLevelReward;
    map['isDayReward'] = isDayReward;
    map['isWeekReward'] = isWeekReward;
    map['web_state'] = webState;
    map['isMonth_Reward'] = isMonthReward;
    map['day_skill'] = daySkill;
    map['scale'] = scale;
    map['borrow_amount'] = borrowAmount;
    map['asse_price'] = assePrice;
    map['sign_type'] = signType;
    map['today_order_cnt'] = todayOrderCnt;
    map['is_auto'] = isAuto;
    map['balance_lower'] = balanceLower;
    map['balance_upper'] = balanceUpper;
    map['rebate_scale'] = rebateScale;
    map['day_bet_cnt'] = dayBetCnt;
    map['quantify_income_rate'] = quantifyIncomeRate;
    map['quantify_income_scale'] = quantifyIncomeScale;
    map['quantify_income_rate_show'] = quantifyIncomeRateShow;
    map['quantify_amount_min'] = quantifyAmountMin;
    map['quantify_amount_max'] = quantifyAmountMax;
    map['robot_price'] = robotPrice;
    map['robot_valid'] = robotValid;
    map['day_salary'] = daySalary;
    map['week_salary'] = weekSalary;
    map['month_salary'] = monthSalary;
    map['withdraw_limit'] = withdrawLimit;
    map['withdraw_cnt'] = withdrawCnt;
    map['is_automatic'] = isAutomatic;
    map['relegation_day'] = relegationDay;
    map['relegation_bet_lower'] = relegationBetLower;
    map['relegation_bet_upper'] = relegationBetUpper;
    map['relegation_charge_lower'] = relegationChargeLower;
    map['relegation_charge_upper'] = relegationChargeUpper;
    map['withdraw_free_cnt'] = withdrawFreeCnt;
    map['withdraw_free'] = withdrawFree;
    map['points_bonus'] = pointsBonus;
    map['rebate_bonus'] = rebateBonus;
    map['return_water_bonus'] = returnWaterBonus;
    map['vip_log_url'] = vipLogUrl;
    map['withdraw_upper_limit'] = withdrawUpperLimit;
    map['relegation_mode'] = relegationMode;
    map['refresh_type'] = refreshType;
    map['daily_withdrawal_limit'] = dailyWithdrawalLimit;
    map['birthday_red_packet'] = birthdayRedPacket;
    return map;
  }

  @override
  String toString() {
    return 'VipLevelItemBean{levelId: $levelId, levelType: $levelType, level: $level, levelName: $levelName, valueLower: $valueLower, valueUpper: $valueUpper, state: $state, stateTime: $stateTime, createTime: $createTime, operCode: $operCode, tid: $tid, levelReward: $levelReward, levelRewardTotal: $levelRewardTotal, dayReward: $dayReward, weekReward: $weekReward, monthReward: $monthReward, groups: $groups, channel: $channel, manager: $manager, signDay: $signDay, dayType: $dayType, monday: $monday, tuesday: $tuesday, wednesday: $wednesday, thursday: $thursday, friday: $friday, saturday: $saturday, sunday: $sunday, cumulativeAttendance: $cumulativeAttendance, differAmount: $differAmount, balanceDifferAmount: $balanceDifferAmount, isLevelReward: $isLevelReward, isDayReward: $isDayReward, isWeekReward: $isWeekReward, webState: $webState, isMonthReward: $isMonthReward, daySkill: $daySkill, scale: $scale, borrowAmount: $borrowAmount, assePrice: $assePrice, signType: $signType, todayOrderCnt: $todayOrderCnt, isAuto: $isAuto, balanceLower: $balanceLower, balanceUpper: $balanceUpper, rebateScale: $rebateScale, dayBetCnt: $dayBetCnt, quantifyIncomeRate: $quantifyIncomeRate, quantifyIncomeScale: $quantifyIncomeScale, quantifyIncomeRateShow: $quantifyIncomeRateShow, quantifyAmountMin: $quantifyAmountMin, quantifyAmountMax: $quantifyAmountMax, robotPrice: $robotPrice, robotValid: $robotValid, daySalary: $daySalary, weekSalary: $weekSalary, monthSalary: $monthSalary, withdrawLimit: $withdrawLimit, withdrawCnt: $withdrawCnt, isAutomatic: $isAutomatic, relegationDay: $relegationDay, relegationBetLower: $relegationBetLower, relegationBetUpper: $relegationBetUpper, relegationChargeLower: $relegationChargeLower, relegationChargeUpper: $relegationChargeUpper, withdrawFreeCnt: $withdrawFreeCnt, withdrawFree: $withdrawFree, pointsBonus: $pointsBonus, rebateBonus: $rebateBonus, returnWaterBonus: $returnWaterBonus, vipLogUrl: $vipLogUrl, withdrawUpperLimit: $withdrawUpperLimit, relegationMode: $relegationMode, refreshType: $refreshType, dailyWithdrawalLimit: $dailyWithdrawalLimit, birthdayRedPacket: $birthdayRedPacket}';
  }
}

class VipTotalBean {
  VipTotalBean({
    this.dayRewardSum,
    this.levelRewardSum,
    this.monthRewardSum,
    this.totalRewardSum,
    this.weekRewardSum,
    this.totalBet,
    this.totalRecharge,
  });

  num? totalRewardSum; // 待领取总奖金
  num? levelRewardSum; // 晋级奖金
  num? dayRewardSum; // 日俸禄
  num? weekRewardSum; // 周俸禄
  num? monthRewardSum; // 月俸禄
  num? totalBet; // 月俸禄
  num? totalRecharge; // 月俸禄

  VipTotalBean.fromJson(dynamic json) {
    dayRewardSum = json['day_reward_sum'];
    levelRewardSum = json['level_reward_sum'];
    monthRewardSum = json['month_reward_sum'];
    totalRewardSum = json['total_reward_sum'];
    weekRewardSum = json['week_reward_sum'];
    totalBet = json['total_bet'];
    totalRecharge = json['total_recharge'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['day_reward_sum'] = dayRewardSum;
    map['level_reward_sum'] = levelRewardSum;
    map['month_reward_sum'] = monthRewardSum;
    map['total_reward_sum'] = totalRewardSum;
    map['week_reward_sum'] = weekRewardSum;
    map['total_bet'] = totalBet;
    map['total_recharge'] = totalRecharge;
    return map;
  }
}
