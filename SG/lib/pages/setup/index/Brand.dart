class Brand {
  Brand({
      this.bet, 
      this.check, 
      this.commissionAmount,
      this.url,
      this.mobile,
  });

  Brand.fromJson(dynamic json) {
    bet = json['bet'];
    check = json['check'];
    commissionAmount = json['commission_amount'];
    url = json['url'];
    mobile = json['mobile'];
  }
  int? bet;
  int? check;
  String? commissionAmount;
  String? url;
  String? mobile;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['bet'] = bet;
    map['check'] = check;
    map['commission_amount'] = commissionAmount;
    map['url'] = url;
    map['mobile'] = mobile;
    return map;
  }

}