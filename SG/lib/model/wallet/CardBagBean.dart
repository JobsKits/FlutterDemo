import 'BankcardBean.dart';
import 'CoinBean.dart';

class CardBagBean {
  CardBagBean({this.coin, this.bankcard});

  CardBagBean.fromJson(dynamic json) {
    coin = CoinBean.fromJson(json['coin']);
    bankcard =BankcardBean.fromJson(json['bankcard']);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['coin'] = coin;
    map['bankcard'] = bankcard;
    return map ;
  }
  CoinBean? coin;
  BankcardBean? bankcard;
}
