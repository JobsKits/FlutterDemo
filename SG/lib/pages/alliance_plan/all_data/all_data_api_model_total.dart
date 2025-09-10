
///联盟计划，所有数据总计
class AllDataTotalApiModel {
  int? num;
  String? depositAmount;
  String? validBetAmount;
  String? netAmount;

  AllDataTotalApiModel({
    this.num,
    this.depositAmount,
    this.validBetAmount,
    this.netAmount,
  });

  factory AllDataTotalApiModel.fromJson(Map<String, dynamic> json) => AllDataTotalApiModel(
    num: json["num"],
    depositAmount: json["deposit_amount"],
    validBetAmount: json["valid_bet_amount"],
    netAmount: json["net_amount"],
  );

  Map<String, dynamic> toJson() => {
    "num": num,
    "deposit_amount": depositAmount,
    "valid_bet_amount": validBetAmount,
    "net_amount": netAmount,
  };
}
