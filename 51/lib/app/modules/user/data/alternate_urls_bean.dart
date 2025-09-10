class AlternateUrlsBean {
  AlternateUrlsBean({
    this.count,
    this.data,
  });

  AlternateUrlsBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(AlternateUrlsItem.fromJson(v));
      });
    }
  }
  int? count;
  List<AlternateUrlsItem>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class AlternateUrlsItem {
  AlternateUrlsItem({
    this.domainTenantId,
    this.domainAddr,
    this.des,
    this.tid,
    this.state,
    this.createTime,
    this.stateTime,
    this.kidnapCollocation,
    this.xmppOuter,
    this.chanCode,
    this.weight,
    this.clustersId,
    this.isPromote,
    this.proxy,
    this.isSpare,
    this.todaycount,
    this.zrcount,
    this.moncount,
    this.zctodaycount,
    this.zczrcount,
    this.zcmoncount,
    this.all,
    this.liveSys,
  });

  AlternateUrlsItem.fromJson(dynamic json) {
    domainTenantId = json['domain_tenant_id'];
    domainAddr = json['domain_addr'];
    des = json['des'];
    tid = json['tid'];
    state = json['state'];
    createTime = json['create_time'];
    stateTime = json['state_time'];
    kidnapCollocation = json['kidnap_collocation'];
    xmppOuter = json['xmpp_outer'];
    chanCode = json['chan_code'];
    weight = json['weight'];
    clustersId = json['clusters_id'];
    isPromote = json['is_promote'];
    proxy = json['proxy'];
    isSpare = json['is_spare'];
    todaycount = json['todaycount'];
    zrcount = json['zrcount'];
    moncount = json['moncount'];
    zctodaycount = json['zctodaycount'];
    zczrcount = json['zczrcount'];
    zcmoncount = json['zcmoncount'];
    all = json['all'];
    liveSys = json['liveSys'];
  }
  int? domainTenantId;
  String? domainAddr;
  String? des;
  int? tid;
  int? state;
  int? createTime;
  int? stateTime;
  String? kidnapCollocation;
  String? xmppOuter;
  String? chanCode;
  int? weight;
  int? clustersId;
  int? isPromote;
  int? proxy;
  String? isSpare;
  int? todaycount;
  int? zrcount;
  int? moncount;
  int? zctodaycount;
  int? zczrcount;
  int? zcmoncount;
  int? all;
  bool? liveSys;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['domain_tenant_id'] = domainTenantId;
    map['domain_addr'] = domainAddr;
    map['des'] = des;
    map['tid'] = tid;
    map['state'] = state;
    map['create_time'] = createTime;
    map['state_time'] = stateTime;
    map['kidnap_collocation'] = kidnapCollocation;
    map['xmpp_outer'] = xmppOuter;
    map['chan_code'] = chanCode;
    map['weight'] = weight;
    map['clusters_id'] = clustersId;
    map['is_promote'] = isPromote;
    map['proxy'] = proxy;
    map['is_spare'] = isSpare;
    map['todaycount'] = todaycount;
    map['zrcount'] = zrcount;
    map['moncount'] = moncount;
    map['zctodaycount'] = zctodaycount;
    map['zczrcount'] = zczrcount;
    map['zcmoncount'] = zcmoncount;
    map['all'] = all;
    map['liveSys'] = liveSys;
    return map;
  }
}
