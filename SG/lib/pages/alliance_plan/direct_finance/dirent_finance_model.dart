
///联盟计划-tab-直属财务 model
class DirectFinanceModel {
  int time; //加入时间
  String account; //账号
  double deposit; //存款金额
  int depositCount; //存款金额(次数)
  double withdraw; //取款金额
  int withdrawCount; //取款金额(次数)
  double differ; //存取款差额
  double balance; //当前余额

  DirectFinanceModel({
    required this.time,
    required this.account,
    required this.deposit,
    required this.depositCount,
    required this.withdraw,
    required this.withdrawCount,
    required this.differ,
    required this.balance,
  });
}
