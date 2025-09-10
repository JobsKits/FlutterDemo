//提现方式临时使用的实体类

class WithdrawMethodBean {
  WithdrawMethodBean({
    required this.label,
    required this.value,
    required this.payType,
    required this.add,
    required this.key,
    required this.icon,
  });

  final String label;
  final int value;
  final int payType;
  final String add;
  final String key;
  final String icon;

  @override
  String toString() {
    return 'WithdrawMethodBean{label: $label, value: $value, payType: $payType, add: $add, key: $key, icon: $icon}';
  }
}
