

//推广活动
class MqttMessagePromoApiModel {
  String? currencyId;
  String? promoType;
  String? type;
  String? promoName;
  String? bonusAmount;
  String? fromBonusAmount;

  MqttMessagePromoApiModel({
    this.currencyId,
    this.promoType,
    this.type,
    this.promoName,
    this.bonusAmount,
    this.fromBonusAmount,
  });

  factory MqttMessagePromoApiModel.fromJson(Map<String, dynamic> json) => MqttMessagePromoApiModel(
    currencyId: json["currency_id"],
    promoType: json["promo_type"],
    type: json["type"],
    promoName: json["promo_name"],
    bonusAmount: json["bonus_amount"],
    fromBonusAmount: json["from_bonus_amount"],
  );

  Map<String, dynamic> toJson() => {
    "currency_id": currencyId,
    "promo_type": promoType,
    "type": type,
    "promo_name": promoName,
    "bonus_amount": bonusAmount,
    "from_bonus_amount": fromBonusAmount,
  };
}