class ValidCurrencyBean {
  ValidCurrencyBean({
    this.currencyId,
    this.contractId,
  });

  ValidCurrencyBean.fromJson(dynamic json) {
    currencyId = json['currency_id'];
    if (json['contract_id'] != null) {
      contractId = [];
      json['contract_id'].forEach((v) {
        contractId?.add(ContractId.fromJson(v));
      });
    }
  }

  String? currencyId;
  List<ContractId>? contractId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['currency_id'] = currencyId;
    if (contractId != null) {
      map['contract_id'] = contractId?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ContractId {
  ContractId({
    this.id,
  });

  ContractId.fromJson(dynamic json) {
    id = json['id'];
  }

  String? id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    return map;
  }
}
