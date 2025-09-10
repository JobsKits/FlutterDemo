// ignore_for_file: non_constant_identifier_names

/// 线下充值配置
class RechargeOfflineConfigBean {
  RechargeOfflineConfigBean({
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

  RechargeOfflineConfigBean.fromJson(dynamic json) {
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
