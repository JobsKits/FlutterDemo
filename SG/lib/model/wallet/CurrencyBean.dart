import 'package:flutter_bet/services/branch/branch_service.dart';

class CurrencyBean {
  String? uid;
  String? name;
  String? amount;
  // RxString? amountTest;
  String? symbol;// 货币符号
  String? cur;// 货币代号
  int? currency_type;
  List<dynamic>? contract_type;
  String? bank_tree;
  dynamic contentText;
  String? coinIc;
  bool? isSelected = false;
  int? decimal_places; //小数点,默认2位
/*  {
  "cur": "707",
  "cur_name": "BTC",
  "decimal_places": 8,
  "symbol": "₿",
  "bank_tree": "",
  "contract_type": [
  "BTC"
  ],
  "currency_type": 2
  }*/
  CurrencyBean({
    this.uid,
    this.name,
    this.amount,
    // this.amountTest,
    this.symbol,
    this.cur,
    this.currency_type,
    this.contract_type,
    this.bank_tree,
    this.contentText,
    this.coinIc,
    this.isSelected,
    this.decimal_places = 2, //小数点,默认2位
  });

  CurrencyBean.fromJson(dynamic json) {
    uid = json['uid'];
    name = json['name'];
    amount = json['amount'];
    // amountTest = json['amount'];
    symbol = json['symbol'];
    cur = json['cur'];
    currency_type = json['currency_type'];
    contract_type = json['contract_type'];
    bank_tree = json['bank_tree'];
    contentText = json['content_text'];
    coinIc = json['coinIc'];
    isSelected = json['isSelected'];
    decimal_places = json['decimal_places'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = uid;
    map['name'] = name;
    map['amount'] = amount;
    map['symbol'] = symbol;
    map['cur'] = cur;
    map['bank_tree'] = bank_tree;
    map['content_text'] = contentText;
    map['coinIc'] = coinIc;
    map['currency_type'] = currency_type;
    map['contract_type'] = contract_type;
    map['isSelected'] = isSelected;
    map['decimal_places'] = decimal_places;
    return map;
  }
  ///是否是加密货币， true 是， false 否 ，则是法币
  ///currency_type 1:法币， 2：加密货币
  bool isCryptoCoin() {
    return currency_type == 2;
  }
  /// 货币对应iconUrl
  String get coinImgUrl {
    return "${BranchService.instance.current.asset_url}/currency/$cur.webp";
  }
}
