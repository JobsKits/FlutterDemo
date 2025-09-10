///推广活动有效推广人数 api model
///{{url}}/member/agency/valid/member/count?pid=40039904499718196
class ActivityPeopleApiModel {
  // "valid_member_count": 5, //有效推广人数
  // "received_member_count": 4, //已领取人数
  // "currency_id": "701",
  // "bonus_amount": "206.16",
  int? validMemberCount;
  int? receivedMemberCount;
  String? bonusAmount;
  String? currencyId;
  List<ReceiveRecord>? record; //领取记录

  ActivityPeopleApiModel({
    this.validMemberCount,
    this.receivedMemberCount,
    this.bonusAmount,
    this.record,
    this.currencyId,
  });

  factory ActivityPeopleApiModel.fromJson(Map<String, dynamic> json) =>
      ActivityPeopleApiModel(
        validMemberCount: json["valid_member_count"],
        receivedMemberCount: json["received_member_count"],
        bonusAmount: json["bonus_amount"],
        currencyId: json["currency_id"],
        record: json["record"] == null ? [] : List<ReceiveRecord>.from(
            json["record"]!.map((x) => ReceiveRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() =>
      {
        "valid_member_count": validMemberCount,
        "received_member_count": receivedMemberCount,
        "bonus_amount": bonusAmount,
        "currency_id": currencyId,
        "record": record == null ? [] : List<dynamic>.from(record!.map((x) => x.toJson())),
      };
}

///推广活动 福利 领取记录
class ReceiveRecord {
  // "lvl": 1, //发放梯级，从1开始
  // "state": 3, //状态 1:待审核 2:已审核 3:已发放(领取) 4:待领取 5:拒绝
  // "bonus_amount": "10.00000000", //发放奖金
  // "from_bonus_amount": "10", //原始发放奖金
  // "currency_id": "706" //发放货币
  int? lvl;
  int? state;
  String? bonusAmount;
  String? fromBonusAmount;
  String? currencyId;

  ReceiveRecord({
    this.lvl,
    this.state,
    this.bonusAmount,
    this.fromBonusAmount,
    this.currencyId,
  });

  factory ReceiveRecord.fromJson(Map<String, dynamic> json) =>
      ReceiveRecord(
        lvl: json["lvl"],
        state: json["state"],
        bonusAmount: json["bonus_amount"],
        fromBonusAmount: json["from_bonus_amount"],
        currencyId: json["currency_id"],
      );

  Map<String, dynamic> toJson() =>
      {
        "lvl": lvl,
        "state": state,
        "bonus_amount": bonusAmount,
        "from_bonus_amount": fromBonusAmount,
        "currency_id": currencyId,
      };
}