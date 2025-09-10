
import '../../../utils/date_util.dart';

class CommissionHistoryModel {
  int time; //领取时间
  int numberPeople; //贡献人数
  double money; //金额

  CommissionHistoryModel({
    required this.time,
    required this.numberPeople,
    required this.money,
  }); //兑换汇率


  String getTimeFirst() {
    return DateUtil.formatDateMs(time, format: "dd/MM/yyyy");
  }

  String getTimeSecond() {
    return DateUtil.formatDateMs(time, format: "HH:mm:ss");
  }

}
