class HomeTabData {
  HomeTabData({
    this.playTypeUrlId,
    this.playName,
    this.type,
    this.playState,
    this.operCode,
    this.createTime,
    this.tid,
    this.sortV,
    this.logoUrl1,
    this.logoUrl2,
    this.operTime,
  });

  HomeTabData.fromJson(dynamic json) {
    playTypeUrlId = json['play_type_url_id'];
    playName = json['play_name'];
    type = json['type'];
    playState = json['play_state'];
    operCode = json['oper_code'];
    createTime = json['create_time'];
    tid = json['tid'];
    sortV = json['sort_v'];
    logoUrl1 = json['logo_url1'];
    logoUrl2 = json['logo_url2'];
    operTime = json['oper_time'];
  }
  num? playTypeUrlId;
  String? playName;
  num? type;
  num? playState;
  String? operCode;
  num? createTime;
  num? tid;
  num? sortV;
  String? logoUrl1;
  String? logoUrl2;
  num? operTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['play_type_url_id'] = playTypeUrlId;
    map['play_name'] = playName;
    map['type'] = type;
    map['play_state'] = playState;
    map['oper_code'] = operCode;
    map['create_time'] = createTime;
    map['tid'] = tid;
    map['sort_v'] = sortV;
    map['logo_url1'] = logoUrl1;
    map['logo_url2'] = logoUrl2;
    map['oper_time'] = operTime;
    return map;
  }

  @override
  String toString() {
    return 'HomeTabData{playTypeUrlId: $playTypeUrlId, playName: $playName, type: $type, playState: $playState, operCode: $operCode, createTime: $createTime, tid: $tid, sortV: $sortV, logoUrl1: $logoUrl1, logoUrl2: $logoUrl2, operTime: $operTime}';
  }
}
