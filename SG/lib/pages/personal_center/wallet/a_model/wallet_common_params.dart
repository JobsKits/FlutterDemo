import 'package:get/get.dart';

///钱包 绑定 银行卡 或者 加密货币的类型
enum CardBandingTypeEnum {
  brl(id: "702"), //巴西币
  vnd(id: "704"), //越南盾
  cny(id: "701"), //人民币
  fiat(id: "-11"), //法币
  crypto(id: "-22"); //加密货币
  final String id;
  const CardBandingTypeEnum({required this.id});
  ///String 匹配 状态
  static CardBandingTypeEnum adaptor(String? value, int currency_type) {
    var state = CardBandingTypeEnum.values.firstWhereOrNull((element) => element.id == value);
    //1 是法币， 2 是加密货币
    return state ?? (currency_type == 1 ? fiat : crypto);
  }
}
