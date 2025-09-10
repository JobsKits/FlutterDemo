class BankCardBean {
  BankCardBean({
    this.data,
  });

  List<BankCardItemBean>? data;

  BankCardBean.fromJson(List<dynamic> list) {
    data = list.map((e) => BankCardItemBean.fromJson(e)).toList();
  }
}

class BankCardItemBean {
  BankCardItemBean({
    this.aseqId,
    this.createTime,
    this.currency,
    this.describeinfo,
    this.isShow,
    this.mark,
    this.name,
    this.payOfflinePercentageOfYards,
    this.payOrgId,
    this.showFlag,
    this.sortV,
    this.sourcetype,
    this.state,
    this.stateTime,
    this.tid,
  });

  int? aseqId;
  int? createTime;
  String? currency;
  String? describeinfo;
  int? isShow;
  int? mark;
  String? name;
  num? payOfflinePercentageOfYards;
  int? payOrgId;
  int? showFlag;
  int? sortV;
  String? sourcetype;
  int? state;
  int? stateTime;
  int? tid;

  BankCardItemBean.fromJson(dynamic json) {
    aseqId = json['aseq_id'];
    createTime = json['create_time'];
    currency = json['currency'];
    describeinfo = json['describeinfo'];
    isShow = json['is_show'];
    mark = json['mark'];
    name = json['name'];
    payOfflinePercentageOfYards = json['pay_offline_percentage_of_yards'];
    payOrgId = json['pay_org_id'];
    showFlag = json['show_flag'];
    sortV = json['sort_v'];
    sourcetype = json['sourcetype'];
    state = json['state'];
    stateTime = json['state_time'];
    tid = json['tid'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['aseq_id'] = aseqId;
    map['create_time'] = createTime;
    map['currency'] = currency;
    map['describeinfo'] = describeinfo;
    map['is_show'] = isShow;
    map['mark'] = mark;
    map['name'] = name;
    map['pay_offline_percentage_of_yards'] = payOfflinePercentageOfYards;
    map['pay_org_id'] = payOrgId;
    map['show_flag'] = showFlag;
    map['sort_v'] = sortV;
    map['sourcetype'] = sourcetype;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['tid'] = tid;
    return map;
  }
}

/// 绑卡配置
class BindCardConfigBean {
  BindCardConfigBean({
    this.createTime,
    this.doubleValue,
    this.intValue,
    this.modifyTime,
    this.operCode,
    this.optionCode,
    this.optionId,
    this.sort,
    this.text,
    this.tid,
    this.value,
    this.value2,
  });

  int? createTime;
  num? doubleValue;
  num? intValue;
  int? modifyTime;
  String? operCode;
  String? optionCode;
  int? optionId;
  int? sort;
  String? text;
  int? tid;
  String? value;
  String? value2;

  BindCardConfigBean.fromJson(dynamic json) {
    createTime = json['create_time'];
    doubleValue = json['doubleValue'];
    intValue = json['intValue'];
    modifyTime = json['modify_time'];
    operCode = json['oper_code'];
    optionCode = json['option_code'];
    optionId = json['option_id'];
    sort = json['sort'];
    text = json['text'];
    tid = json['tid'];
    value = json['value'];
    value2 = json['value2'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['create_time'] = createTime;
    map['doubleValue'] = doubleValue;
    map['intValue'] = intValue;
    map['modify_time'] = modifyTime;
    map['oper_code'] = operCode;
    map['option_code'] = optionCode;
    map['option_id'] = optionId;
    map['sort'] = sort;
    map['text'] = text;
    map['tid'] = tid;
    map['value'] = value;
    map['value2'] = value2;
    return map;
  }
}
