
///联盟计划-tab-直属投注 model
class DirectBettingModel {
  int time; //加入时间
  String account; //账号
  // double deposit; //存款金额
  double validBet; //有效投注
  int amountBet; //投注数量
  double totalWinOrLoss; //总输赢

  DirectBettingModel({
    required this.time,
    required this.account,
    required this.validBet,
    required this.amountBet,
    required this.totalWinOrLoss,
  });
}
