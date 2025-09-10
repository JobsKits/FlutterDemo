
class CoinBean {
  CoinBean({
      this.fiatCurrency,
      this.coinIcon,
      this.name,
      this.id = "",
      this.uid, 
      this.username, 
      this.address = "",
      this.contractType, 
      this.contract_name,
      this.currencyId,
      this.isDefault, 
      this.state, 
      this.createdAt, 
      this.updatedAt,
    this.bankType,
    this.openName,
    this.bankName,
    this.bankAccount,
    this.bankAreaCpf,
    this.typeId,
    this.typeName,
    this.payPassword,
    this.isSelect
  });

  CoinBean.fromJson(dynamic json) {
    fiatCurrency = json['fiatCurrency'];
    coinIcon = json['coinIcon'];
    id = json['id'] ?? "";
    uid = json['uid'];
    username = json['username'];
    name = json['name'];
    address = json['address'] ?? "";
    contractType = json['contract_type'];
    contract_name = json['contract_name'];
    currencyId = json['currency_id'];
    isDefault = json['is_default'];
    state = json['state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    bankType = json['bank_type'];
    openName = json['open_name'];
    bankName = json['bank_name'];
    bankAccount = json['bank_account'];
    bankAreaCpf = json['bank_area_cpf'];
    //虚拟币列表中需要使用
    typeId = json['type_id'];
    typeName = json['type_name'];
    payPassword = json['pay_password'];
  }
  String  id = "";
  String? uid;
  String? username;
  String address = "";
  int? contractType;
  String? contract_name;
  String? currencyId;
  int? isDefault;
  int? state;
  int? createdAt;
  int? updatedAt;
  String? name ;
  bool? fiatCurrency ;
  String? coinIcon ;
  String? bankType;
  String? openName;
  String? bankName;
  String? bankAccount;
  String? bankAreaCpf;

  String? typeId;
  String? typeName;
  String? payPassword;
  bool? isSelect ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fiatCurrency'] = fiatCurrency ;
    map['coinIcon'] = coinIcon ;
    map['id'] = id;
    map['uid'] = uid;
    map['username'] = username;
    map['name'] = name;
    map['address'] = address;
    map['contract_type'] = contractType;
    map['currency_id'] = currencyId;
    map['contract_name'] = contract_name;
    map['is_default'] = isDefault;
    map['state'] = state;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['bank_type'] = bankType;
    map['open_name'] = openName;
    map['bank_name'] = bankName;
    map['bank_account'] = bankAccount;
    map['bank_area_cpf'] = bankAreaCpf;

    map['type_id'] = typeId;
    map['type_name'] = typeName;
    map['pay_password'] = payPassword;

    return map;
  }

}