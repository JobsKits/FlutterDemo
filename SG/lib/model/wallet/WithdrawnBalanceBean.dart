class WithdrawnBalanceBean {
  WithdrawnBalanceBean({
      this.withdrawBalance, 
      this.remainingBalance, 
      this.totalBalance,});

  WithdrawnBalanceBean.fromJson(dynamic json) {
    withdrawBalance = json['withdraw_balance'];
    remainingBalance = json['remaining_balance'];
    totalBalance = json['total_balance'];
  }
  String? withdrawBalance;
  String? remainingBalance;
  String? totalBalance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['withdraw_balance'] = withdrawBalance;
    map['remaining_balance'] = remainingBalance;
    map['total_balance'] = totalBalance;
    return map;
  }

}