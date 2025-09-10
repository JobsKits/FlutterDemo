///推广界面 推广条件item model
class PromotionCondItemModel {
  String title;
  String content;
  String? moneyOrTime;
  String? currencyId;
  String? unit; //单位

  PromotionCondItemModel({
    required this.title,
    required this.content,
    this.moneyOrTime,
    this.currencyId,
    this.unit,
  });

  ///是否是货币
  bool isCoin() {
    return currencyId != null;
  }

  ///为0 不显示
  bool isShowRow() {
    return moneyOrTime != null && moneyOrTime!.isNotEmpty && double.parse(moneyOrTime ?? "0") != 0;
  }
}
