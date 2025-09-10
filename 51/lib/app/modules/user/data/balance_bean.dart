//钱包余额的实体类
class BalanceBean {
  BalanceBean({
    this.balance,
    this.freezeBalance,
    this.unWithdrawBalance,
    this.bonus,
    this.expiresBonus,
    this.markingQuantitySum,
    this.sysvalue,
    this.level,
    this.experienceGold,
  });

  BalanceBean.fromJson(dynamic json) {
    balance = json['balance'];
    freezeBalance = json['freezeBalance'];
    unWithdrawBalance = json['unWithdrawBalance'];
    bonus = json['bonus'];
    expiresBonus = json['expiresBonus'];
    markingQuantitySum = json['marking_quantity_sum'];
    sysvalue = json['sysvalue'];
    level = json['level'];
    experienceGold = json['experience_gold'];
  }
  int? balance;
  num? freezeBalance;
  num? unWithdrawBalance;
  num? bonus;
  num? expiresBonus;
  num? markingQuantitySum;
  String? sysvalue;
  int? level;
  num? experienceGold;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balance'] = balance;
    map['freezeBalance'] = freezeBalance;
    map['unWithdrawBalance'] = unWithdrawBalance;
    map['bonus'] = bonus;
    map['expiresBonus'] = expiresBonus;
    map['marking_quantity_sum'] = markingQuantitySum;
    map['sysvalue'] = sysvalue;
    map['level'] = level;
    map['experience_gold'] = experienceGold;
    return map;
  }
}
