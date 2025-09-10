import 'package:flutter_bet/generated/l10n.dart';

class StatisicalDataBean {
  StatisicalDataBean({
      this.currencyId, 
      this.validBetAmount, 
      this.netAmount, 
      this.betCount, 
      this.betTime,
      this.detail,
  });

  StatisicalDataBean.fromJson(dynamic json) {
    currencyId = json['currency_id'];
    validBetAmount = json['valid_bet_amount'];
    netAmount = json['net_amount'];
    betCount = json['bet_count'];
    betTime = json['bet_time'];
    detail = json['detail'];
  }
  String? currencyId;
  String? validBetAmount;
  String? netAmount;
  int? betCount;
  dynamic? betTime;
  dynamic?  detail;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency_id'] = currencyId;
    map['valid_bet_amount'] = validBetAmount;
    map['net_amount'] = netAmount;
    map['bet_count'] = betCount;
    map['bet_time'] = betTime;
    map['detail'] = detail;
    return map;
  }

}