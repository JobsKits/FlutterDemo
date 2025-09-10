///三方钱包的实体类
class ThirdWalletBean {
  ThirdWalletBean({
    this.field,
    this.isBind,
    this.walletAddress,
  });

  ThirdWalletBean.fromJson(dynamic json) {
    field = json['field'] != null ? Field.fromJson(json['field']) : null;
    isBind = json['isBind'];
    walletAddress = json['walletAddress'];
  }
  Field? field;
  String? isBind;
  String? walletAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (field != null) {
      map['field'] = field?.toJson();
    }
    map['isBind'] = isBind;
    map['walletAddress'] = walletAddress;
    return map;
  }

  @override
  String toString() {
    return 'ThirdWalletBean{field: $field, isBind: $isBind, walletAddress: $walletAddress}';
  }
}

class Field {
  Field({this.charge, this.bind});

  Field.fromJson(dynamic json) {
    if (json['charge'] != null) {
      charge = [];
      json['charge'].forEach((v) {
        charge?.add(Charge.fromJson(v));
      });
    }
    if (json['bind'] != null) {
      bind = [];
      json['bind'].forEach((v) {
        bind?.add(WalletBind.fromJson(v));
      });
    }
  }
  List<Charge>? charge;
  List<WalletBind>? bind;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (charge != null) {
      map['charge'] = charge?.map((v) => v.toJson()).toList();
    }
    if (bind != null) {
      map['bind'] = bind?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'Field{charge: $charge,bind: $bind}';
  }
}

class WalletBind {
  WalletBind({
    this.name,
    this.key,
    this.desc,
    this.isAreaCode,
  });

  WalletBind.fromJson(dynamic json) {
    name = json['name'];
    key = json['key'];
    desc = json['desc'];
    isAreaCode = json['isAreaCode'];
  }
  String? name;
  String? key;
  String? desc;
  String? isAreaCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['key'] = key;
    map['desc'] = desc;
    map['isAreaCode'] = isAreaCode;
    return map;
  }
}

class Charge {
  Charge({
    this.name,
    this.key,
    this.desc,
  });

  Charge.fromJson(dynamic json) {
    name = json['name'];
    key = json['key'];
    desc = json['desc'];
  }
  String? name;
  String? key;
  String? desc;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['key'] = key;
    map['desc'] = desc;
    return map;
  }

  @override
  String toString() {
    return 'Charge{name: $name, key: $key, desc: $desc}';
  }
}
