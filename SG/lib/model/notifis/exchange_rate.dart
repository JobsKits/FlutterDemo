import 'package:decimal/decimal.dart';
import 'package:flutter_bet/model/wallet/CurrencyBean.dart';

///接收 接口数据的 model
class ExchangeRateModel{
  int date;
  Map<String, dynamic> rates;

  ExchangeRateModel({
    required this.date,
    required this.rates,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) => ExchangeRateModel(
    date: json["date"],
    rates: Map.from(json["rates"]),
  );

  /// 获取汇率
  /// return iCoin : oCoin 汇率
  Decimal getRate(CurrencyBean iCoin, CurrencyBean oCoin) {
    if(iCoin.cur == oCoin.cur) {
      return Decimal.parse('1.0');
    }
    final rateString = rates[iCoin.cur][oCoin.cur] ?? "0";
    return Decimal.parse(rateString);
  }

}
