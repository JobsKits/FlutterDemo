import 'DepositPrpmo.dart';
import 'PayChannelBean.dart';

class PayWayBean {
  PayWayBean({
      this.id, 
      this.pname, 
      this.promo, 
      this.alias, 
      this.name,
      this.isSelect,
      this.payment_type,
      this.ptype,
      this.merchants,
      this.depositPromo
  });

  PayWayBean.fromJson(dynamic json) {
    payment_type= json['payment_type'];
    id = json['id'];
    pname = json['pname'];
    promo = json['promo'];
    alias = json['alias'];
    name = json['name'];
    isSelect = json['isSelect'];
    bank = json['bank'];
    zkId = json['zkId'];
    ptype = json['ptype'];
    merchants = (json['merchants'] as List<dynamic>?)?.map((merchantJson) => PayChannelBean.fromJson(merchantJson)).toList();
    depositPromo = (json['deposit_promo'] as List<dynamic>?)?.map((depositPromoJson) => DepositPrpmo.fromJson(depositPromoJson)).toList();
  }

  String? id;
  String? pname;
  String? promo;
  String? alias;
  String? name;
  bool? bank;
  String? zkId;
  bool? isSelect;
  int? payment_type;
  int? ptype ;
  List<PayChannelBean>? merchants;
  List<DepositPrpmo>? depositPromo;
  bool showAllCh  = false  ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['pname'] = pname;
    map['promo'] = promo;
    map['alias'] = alias;
    map['name'] = name;
    map['isSelect'] = isSelect;
    map['bank'] = bank;
    map['zkId'] = zkId;
    map['payment_type'] = payment_type;
    map['ptype'] = ptype;
    map['merchants'] = merchants?.map((merchant) => merchant.toJson()).toList();
    map['deposit_promo'] = depositPromo?.map((depositPromos) => depositPromos.toJson()).toList();
    return map;
  }

}