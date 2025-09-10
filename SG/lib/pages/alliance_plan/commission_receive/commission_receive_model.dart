class CommissionReceiveModel {
  int walletType; //钱包货币类型
  double walletMoney; //钱包余额
  double exchangeRate;

  CommissionReceiveModel({
    required this.walletType,
    required this.walletMoney,
    required this.exchangeRate,
  }); //兑换汇率
}
