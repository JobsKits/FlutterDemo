import 'Bankcard.dart';

class PaymentDetails {
  PaymentDetails({
      this.id, 
      this.amount, 
      this.currencyId, 
      this.bankcard,});

  PaymentDetails.fromJson(dynamic json) {
    id = json['id'];
    amount = json['amount'];
    currencyId = json['currency_id'];
    bankcard = json['bankcard'] != null ? Bankcard.fromJson(json['bankcard']) : null;
  }
  String? id;
  String? amount;
  String? currencyId;
  Bankcard? bankcard;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['amount'] = amount;
    map['currency_id'] = currencyId;
    if (bankcard != null) {
      map['bankcard'] = bankcard?.toJson();
    }
    return map;
  }

}