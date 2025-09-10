
///佣金记录- 佣金分类列表(下拉)/agency/commission/records/class
class CommissionTypeApiModel  {
  String? cashType;
  String? cashTypeName;

  CommissionTypeApiModel({
    this.cashType,
    this.cashTypeName,
  });

  factory CommissionTypeApiModel.fromJson(Map<String, dynamic> json) => CommissionTypeApiModel(
    cashType: json["CashType"],
    cashTypeName: json["CashTypeName"],
  );

  Map<String, dynamic> toJson() => {
    "CashType": cashType,
    "CashTypeName": cashTypeName,
  };
}
