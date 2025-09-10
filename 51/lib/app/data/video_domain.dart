class VideoDomain {
  VideoDomain({
    this.domainLineId,
    this.domainAddr,
    this.domainIp,
    this.domainType,
    this.callbackAddr,
    this.weight,
    this.chanCode,
    this.clustersId,
    this.state,
    this.stateTime,
    this.operCode,
    this.createTime,
    this.tid,
    this.spareAddr,
  });

  VideoDomain.fromJson(dynamic json) {
    domainLineId = json['domain_line_id'];
    domainAddr = json['domain_addr'];
    domainIp = json['domain_ip'];
    domainType = json['domain_type'];
    callbackAddr = json['callback_addr'];
    weight = json['weight'];
    chanCode = json['chan_code'];
    clustersId = json['clusters_id'];
    state = json['state'];
    stateTime = json['state_time'];
    operCode = json['oper_code'];
    createTime = json['create_time'];
    tid = json['tid'];
    spareAddr = json['spare_addr'];
  }
  int? domainLineId;
  String? domainAddr;
  String? domainIp;
  int? domainType;
  String? callbackAddr;
  int? weight;
  String? chanCode;
  int? clustersId;
  int? state;
  int? stateTime;
  String? operCode;
  int? createTime;
  int? tid;
  String? spareAddr;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['domain_line_id'] = domainLineId;
    map['domain_addr'] = domainAddr;
    map['domain_ip'] = domainIp;
    map['domain_type'] = domainType;
    map['callback_addr'] = callbackAddr;
    map['weight'] = weight;
    map['chan_code'] = chanCode;
    map['clusters_id'] = clustersId;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['oper_code'] = operCode;
    map['create_time'] = createTime;
    map['tid'] = tid;
    map['spare_addr'] = spareAddr;
    return map;
  }
}
