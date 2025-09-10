class DepositPrpmo {


  DepositPrpmo.fromJson(dynamic json) {
    min = double.parse(json['min'] ?? "0");
    max = double.parse(json['max'] ?? "0");
    ratio =double.parse(json['ratio'] ?? "0") ;
    bonusMax = json['bonus_max'];
  }

  double  min = 0;
  double  max = 0;
  double  ratio = 0;
  String? bonusMax;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['min'] = min;
    map['max'] = max;
    map['ratio'] = ratio;
    map['bonus_max'] = bonusMax;
    return map;
  }
}
