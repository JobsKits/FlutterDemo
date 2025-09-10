//账号列表的临时使用的实体类

class RechargeAccountItemBean {
  RechargeAccountItemBean({
    required this.label,
    required this.value,
  });

  String? label;
  String? value;

  RechargeAccountItemBean.fromJson(dynamic json) {
    label = json['label'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = label;
    map['value'] = value;

    return map;
  }
}
