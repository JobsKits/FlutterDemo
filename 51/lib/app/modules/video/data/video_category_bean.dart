class VideoCategoryBean {
  VideoCategoryBean({
    this.id,
    this.classify,
    this.addTime,
    this.updateTime,
    this.sort,
    this.operatename,
    this.isList,
    this.type,
    this.status,
  });

  VideoCategoryBean.fromJson(dynamic json) {
    id = json['id'];
    classify = json['classify'];
    addTime = json['add_time'];
    updateTime = json['update_time'];
    sort = json['sort'];
    operatename = json['operatename'];
    isList = json['is_list'];
    type = json['type'];
    status = json['status'];
  }
  num? id;
  String? classify;
  String? addTime;
  num? updateTime;
  num? sort;
  String? operatename;
  num? isList;
  num? type;
  num? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['classify'] = classify;
    map['add_time'] = addTime;
    map['update_time'] = updateTime;
    map['sort'] = sort;
    map['operatename'] = operatename;
    map['is_list'] = isList;
    map['type'] = type;
    map['status'] = status;
    return map;
  }

  @override
  String toString() {
    return 'VideoCategoryBean{id: $id, classify: $classify, addTime: $addTime, updateTime: $updateTime, sort: $sort, operatename: $operatename, isList: $isList, type: $type, status: $status}';
  }
}
