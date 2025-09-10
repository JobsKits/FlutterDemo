class YmPickerDataBean {
  YmPickerDataBean({
    required this.label,
    required this.value,
  });

  late String label;
  late int value;

  YmPickerDataBean.fromJson(dynamic json) {
    label = json['label'];
    value = json['value'];
  }

  @override
  String toString() {
    return 'YmPickerDataBean{label: $label, value: $value}';
  }
}
