class BankcardBean {
  BankcardBean({
    this.fiatCurrency,
    this.coinIcon,
    this.name,
    this.id = "",
    this.uid,
    this.username,
    this.bankType,
    this.openName,
    this.bankName = "",
    this.bankAccount = "",
    this.bankAreaCpf,
    this.isDefault,
    this.state,
    this.createdAt,
    this.isSelect,
    this.updatedAt,
    this.bank_id,
    this.country,
  });

  BankcardBean.fromJson(dynamic json) {
    fiatCurrency = json['fiatCurrency'];
    coinIcon = json['coinIcon'];
    name = json['name'];
    id = json['id'];
    uid = json['uid'];
    username = json['username'];
    bankType = json['bank_type'];
    openName = json['open_name'];
    bankName = json['bank_name'] ?? "";
    bankAccount = json['bank_account'] ?? "";
    bankAreaCpf = json['bank_area_cpf'];
    isDefault = json['is_default'];
    state = json['state'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    currency_id = json['currency_id'];
    bank_id = json['bank_id'];
    country = json['country'];
  }

  String id = "";
  String? uid;
  String? username;
  String? bankType;
  String? openName;
  String bankName = "";
  String? bankAccount;
  String? bankAreaCpf;
  int? isDefault;

  int? state;
  int? createdAt;
  int? updatedAt;
  bool? fiatCurrency;

  String? coinIcon;

  String? name;

  String? currency_id;
  dynamic bank_id;
  String? country;
  bool? isSelect;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fiatCurrency'] = fiatCurrency;
    map['coinIcon'] = coinIcon;
    map['name'] = name;
    map['id'] = id;
    map['uid'] = uid;
    map['username'] = username;
    map['bank_type'] = bankType;
    map['open_name'] = openName;
    map['bank_name'] = bankName;
    map['bank_account'] = bankAccount;
    map['bank_area_cpf'] = bankAreaCpf;
    map['is_default'] = isDefault;
    map['state'] = state;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['currency_id'] = currency_id;
    map['bank_id'] = bank_id;
    map['country'] = country;
    return map;
  }
}
