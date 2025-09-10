
import 'commission_rate_model.dart';

///联盟计划-返佣比例 封装tab model
class CommissionRateTabModel {
  int index;
  String label;
  String? icon;

  List<CommissionRateModel>? data; //页面列表数据

  CommissionRateTabModel({
    required this.index,
    required this.label,
     this.icon,
     this.data,
  });
}
