
///联盟计划-tab-我的业绩界面 item model
class MyPerformanceModel {
  String id;//详情id
  int time; //加入时间
  String  account; //账号
  int underNumber; //下级人数
  double performance; //业绩
  double commission; //贡献佣金

  MyPerformanceModel({
    required this.id,
    required this.time,
    required this.account,
    required this.underNumber,
    required this.performance,
    required this.commission,
  }); //代理佣金
}
