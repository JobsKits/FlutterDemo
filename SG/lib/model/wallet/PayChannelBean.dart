class PayChannelBean {
  PayChannelBean(
      {this.id,
      this.name,
      this.amountMax,
      this.amountMin,
      this.amountType,
      this.amountFixed,
      this.oftenAmount,
      this.isSelect,
      this.methodId,
      this.paymentType,
      this.bankcardId});

  PayChannelBean.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    amountMax = json['amount_max'];
    amountMin = json['amount_min'];
    amountType = json['amount_type'];
    amountFixed = json['amount_fixed'];
    oftenAmount = json['often_amount'];
    isSelect = json['isSelect'];
    methodId = json['method_id'];
    paymentType = json['payment_type'];
    bankcardId = json['bankcard_id'];
    alias = json['alias'];
  }

  String? id;
  String? name;
  String? amountMax;
  String? amountMin;
  int? amountType;
  String? amountFixed;
  String? oftenAmount;
  bool? isSelect;
  String? methodId;
  int? paymentType;
  String? bankcardId;
  String? alias;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['amount_max'] = amountMax;
    map['amount_min'] = amountMin;
    map['amount_type'] = amountType;
    map['amount_fixed'] = amountFixed;
    map['often_amount'] = oftenAmount;
    map['isSelect'] = isSelect;
    map['method_id'] = methodId;
    map['payment_type'] = paymentType;
    map['bankcard_id'] = bankcardId;
    map['alias'] = alias;
    return map;
  }
}
