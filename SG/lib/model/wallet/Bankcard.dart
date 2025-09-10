class Bankcard {
  Bankcard({
      this.id, 
      this.openName, 
      this.bankId, 
      this.bankAccount, 
      this.level, 
      this.clientType, 
      this.state, 
      this.bankAreaCpf,});

  Bankcard.fromJson(dynamic json) {
    id = json['id'];
    openName = json['open_name'];
    bankId = json['bank_id'];
    bankAccount = json['bank_account'];
    level = json['level'];
    clientType = json['client_type'];
    state = json['state'];
    bankAreaCpf = json['bank_area_cpf'];
  }
  String? id;
  String? openName;
  String? bankId;
  String? bankAccount;
  String? level;
  String? clientType;
  int? state;
  String? bankAreaCpf;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['open_name'] = openName;
    map['bank_id'] = bankId;
    map['bank_account'] = bankAccount;
    map['level'] = level;
    map['client_type'] = clientType;
    map['state'] = state;
    map['bank_area_cpf'] = bankAreaCpf;
    return map;
  }

}