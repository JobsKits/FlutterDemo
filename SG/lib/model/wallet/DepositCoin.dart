class DepositCoin {
  DepositCoin({
      this.id, 
      this.currencyId, 
      this.contractType, 
      this.currencyName, 
      this.walletAddress, 
      this.state, 
      this.remarks,
      this.contractTypeName
  });

  DepositCoin.fromJson(dynamic json) {
    id = json['id'];
    currencyId = json['currency_id'];
    contractType = json['contract_type'];
    contractTypeName = json['contract_type_name'];
    currencyName = json['currency_name'];
    walletAddress = json['wallet_address'];
    state = json['state'];
    remarks = json['remarks'];
  }
  String? id;
  String? currencyId;
  String? contractType;
  String? contractTypeName;
  String? currencyName;
  String? walletAddress;
  int? state;
  String? remarks;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['currency_id'] = currencyId;
    map['contract_type'] = contractType;
    map['contract_type_name'] = contractTypeName;
    map['currency_name'] = currencyName;
    map['wallet_address'] = walletAddress;
    map['state'] = state;
    map['remarks'] = remarks;
    return map;
  }

}