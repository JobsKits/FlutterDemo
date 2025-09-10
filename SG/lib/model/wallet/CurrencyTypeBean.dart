class CurrencyTypeBean {
  CurrencyTypeBean({
      this.id, 
      this.name, 
      this.sortlevel, 
      this.pid,});

  CurrencyTypeBean.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    sortlevel = json['sortlevel'];
    pid = json['pid'];
  }
  String? id;
  String? name;
  String? sortlevel;
  String? pid;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['sortlevel'] = sortlevel;
    map['pid'] = pid;
    return map;
  }

}