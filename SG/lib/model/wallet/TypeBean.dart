class TypeBean {
  TypeBean({
    this.id = "",
    this.alias = "",
    this.name = "",
    this.type = 0,
  });

  TypeBean.fromJson(dynamic json) {
    id = json['id'] ?? "";
    alias = json['alias'] ?? "";
    name = json['name'] ?? "";
    type = json['type'] ?? 0;
  }

  late String id;
  late String alias;
  late String name;
  late num type;
  bool isSelect = false;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['alias'] = alias;
    map['name'] = name;
    map['type'] = type;
    return map;
  }
}
