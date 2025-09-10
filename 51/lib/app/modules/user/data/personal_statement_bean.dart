class PersonalStatementBean {
  PersonalStatementBean({
    this.data,
    this.count,
  });

  PersonalStatementBean.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(PersonalStatementItemBean.fromJson(v));
      });
    }
    count = json['count'];
  }
  List<PersonalStatementItemBean>? data;
  num? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['count'] = count;
    return map;
  }
}

class PersonalStatementItemBean {
  PersonalStatementItemBean({
    this.platformType,
    this.planCount,
    this.dataType,
    this.playAmount,
    this.profit,
    this.playType,
    this.planCountPos,
    this.planProfitPos,
    this.planCountNeg,
    this.planProfitNeg,
    this.cpType,
    this.playName,
    this.dataTypeName,
  });

  PersonalStatementItemBean.fromJson(dynamic json) {
    platformType = json['platform_type'];
    planCount = json['plan_count'];
    dataType = json['data_type'];
    playAmount = json['play_amount'];
    profit = json['profit'];
    playType = json['play_type'];
    planCountPos = json['plan_count_pos'];
    planProfitPos = json['plan_profit_pos'];
    planCountNeg = json['plan_count_neg'];
    planProfitNeg = json['plan_profit_neg'];
    cpType = json['cp_type'];
    playName = json['play_name'];
    dataTypeName = json['data_type_name'];
  }
  num? platformType;
  num? planCount;
  num? dataType;
  num? playAmount;
  num? profit;
  String? playType;
  num? planCountPos;
  num? planProfitPos;
  num? planCountNeg;
  num? planProfitNeg;
  num? cpType;
  String? playName;
  String? dataTypeName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['platform_type'] = platformType;
    map['plan_count'] = planCount;
    map['data_type'] = dataType;
    map['play_amount'] = playAmount;
    map['profit'] = profit;
    map['play_type'] = playType;
    map['plan_count_pos'] = planCountPos;
    map['plan_profit_pos'] = planProfitPos;
    map['plan_count_neg'] = planCountNeg;
    map['plan_profit_neg'] = planProfitNeg;
    map['cp_type'] = cpType;
    map['play_name'] = playName;
    map['data_type_name'] = dataTypeName;
    return map;
  }
}
