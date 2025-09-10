class ProtocolBean {
  ProtocolBean({
    this.name,
      this.id,
      this.pid,
      this.attr,
      this.sortLevel,});

  ProtocolBean.fromJson(dynamic json) {
    name = json['name'];
    id = json['id'];
    pid = json['pid'];
    attr = json['attr'];
    sortLevel = json['sortlevel'];
  }
  String? id;
  String? pid;
  String? attr;
  String? sortLevel;
  String? name ;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['name'] = name ;
    map['id'] = id;
    map['pid'] = pid;
    map['attr'] = attr;
    map['sortlevel'] = sortLevel;
    return map;
  }

}