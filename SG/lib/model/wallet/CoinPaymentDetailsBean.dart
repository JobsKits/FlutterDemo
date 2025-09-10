import 'DepositCoin.dart';

class CoinPaymentDetailsBean {
  CoinPaymentDetailsBean({
      this.id, 
      this.amount, 
      this.currencyId, 
      this.depositCoin,
      this.address
  });

  CoinPaymentDetailsBean.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    currencyId = json['currency_id'];
    address = json['address'];
    depositCoin = json['deposit_coin'] != null ? DepositCoin.fromJson(json['deposit_coin']) : null;
  }
  String? id;
  String? amount;
  String? currencyId;
  String? address ;
  DepositCoin? depositCoin;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['currency_id'] = currencyId;
    map['address'] = address;
    if (depositCoin != null) {
      map['deposit_coin'] = depositCoin?.toJson();
    }
    return map;
  }

}