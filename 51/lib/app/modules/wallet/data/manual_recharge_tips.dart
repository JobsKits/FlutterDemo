class ManualRechargeTips {
  ManualRechargeTips({
    this.optionId,
    this.optionCode,
    this.value,
    this.text,
    this.sort,
    this.operCode,
    this.createTime,
    this.modifyTime,
    this.tid,
    this.value2,
    this.intValue,
    this.doubleValue,
  });

  ManualRechargeTips.fromJson(dynamic json) {
    optionId = json['option_id'];
    optionCode = json['option_code'];
    value = json['value'];
    text = json['text'];
    sort = json['sort'];
    operCode = json['oper_code'];
    createTime = json['create_time'];
    modifyTime = json['modify_time'];
    tid = json['tid'];
    value2 = json['value2'];
    intValue = json['intValue'];
    doubleValue = json['doubleValue'];
  }
  num? optionId;
  String? optionCode;
  String? value;
  String? text;
  num? sort;
  String? operCode;
  num? createTime;
  num? modifyTime;
  num? tid;
  String? value2;
  num? intValue;
  num? doubleValue;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['option_id'] = optionId;
    map['option_code'] = optionCode;
    map['value'] = value;
    map['text'] = text;
    map['sort'] = sort;
    map['oper_code'] = operCode;
    map['create_time'] = createTime;
    map['modify_time'] = modifyTime;
    map['tid'] = tid;
    map['value2'] = value2;
    map['intValue'] = intValue;
    map['doubleValue'] = doubleValue;
    return map;
  }
}
