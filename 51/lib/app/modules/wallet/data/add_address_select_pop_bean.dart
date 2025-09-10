// 下拉选择临时使用的实体类 （如银行卡/虚拟币 等等）
import 'package:json_annotation/json_annotation.dart';
part 'add_address_select_pop_bean.g.dart';

@JsonSerializable()
class AddAddressSelectPopBean {
  AddAddressSelectPopBean({
    required this.name,
    required this.value,
  });

  String name;
  String value;
  factory AddAddressSelectPopBean.fromJson(Map<String, dynamic> json) =>
      _$AddAddressSelectPopBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AddAddressSelectPopBeanToJson(this);
}
