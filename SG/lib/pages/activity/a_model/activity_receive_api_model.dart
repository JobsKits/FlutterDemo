

///推广活动领取 api model
///{{url}}/member/agency/bonus/apply?pid=911065750483031&currency_id=701
class ActivityReceiveApiModel {
  // "message": "领取成功", //返回文字，预计  领取成功|未符合条件|审核中
  // "state": 1, //状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
  // "bonus_amount": "206.16" //(预计)领取金额
  // "currency_id": "701",
  String? message;
  int? state;
  String? bonusAmount;
  String? currencyId;

  ActivityReceiveApiModel({
    this.message,
    this.state,
    this.bonusAmount,
    this.currencyId,
  });

  factory ActivityReceiveApiModel.fromJson(Map<String, dynamic> json) => ActivityReceiveApiModel(
    message: json["message"],
    state: json["state"],
    bonusAmount: json["bonus_amount"],
    currencyId: json["currency_id"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "state": state,
    "bonus_amount": bonusAmount,
    "currency_id": currencyId,
  };
}
