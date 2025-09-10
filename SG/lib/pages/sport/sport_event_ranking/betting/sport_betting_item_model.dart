

class SportBettingItemModel {
  int type; //投注类型
  String title; //标题
  double money; //金额
  int coinType;

  SportBettingItemModel({
    required this.type,
    required this.title,
    required this.money,
    required this.coinType,
  }); //币种
}
