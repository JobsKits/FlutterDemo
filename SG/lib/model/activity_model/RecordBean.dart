class RecordBean {
  RecordBean({
      this.id, 
      this.uid, 
      this.username, 
      this.topUid, 
      this.topName, 
      this.parentUid, 
      this.parentName, 
      this.pid, 
      this.subUid, 
      this.subUsername, 
      this.ty, 
      this.prize, 
      this.state, 
      this.currencyId, 
      this.createdAt,});

  RecordBean.fromJson(dynamic json) {
    id = json['id'];
    uid = json['uid'];
    username = json['username'];
    topUid = json['top_uid'];
    topName = json['top_name'];
    parentUid = json['parent_uid'];
    parentName = json['parent_name'];
    pid = json['pid'];
    subUid = json['sub_uid'];
    subUsername = json['sub_username'];
    ty = json['ty'];
    prize = json['prize'];
    state = json['state'];
    currencyId = json['currency_id'];
    createdAt = json['created_at'];
  }
  String? id;
  String? uid;
  String? username;
  String? topUid;
  String? topName;
  String? parentUid;
  String? parentName;
  String? pid;
  String? subUid;
  String? subUsername;
  num? ty;
  String? prize;
  num? state;
  String? currencyId;
  num? createdAt;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uid'] = uid;
    map['username'] = username;
    map['top_uid'] = topUid;
    map['top_name'] = topName;
    map['parent_uid'] = parentUid;
    map['parent_name'] = parentName;
    map['pid'] = pid;
    map['sub_uid'] = subUid;
    map['sub_username'] = subUsername;
    map['ty'] = ty;
    map['prize'] = prize;
    map['state'] = state;
    map['currency_id'] = currencyId;
    map['created_at'] = createdAt;
    return map;
  }

}