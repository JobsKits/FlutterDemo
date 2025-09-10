
///联盟计划-tab-所有数据model
class AllDataModel {
  int time; //加入时间
  String account; //账号
  double deposit; //存款
  double validBet; //有效投注
  double totalWinOrLoss; //总输赢

  AllDataModel({
    required this.time,
    required this.account,
    required this.deposit,
    required this.validBet,
    required this.totalWinOrLoss,
  });
}
