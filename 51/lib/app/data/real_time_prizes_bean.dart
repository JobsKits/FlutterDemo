///实时爆奖数据bean
class RealTimePrizesBean {
  RealTimePrizesBean({
    this.count,
    this.data,
  });

  RealTimePrizesBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RealTimePrizesItemBean.fromJson(v));
      });
    }
  }
  num? count;
  List<RealTimePrizesItemBean>? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['count'] = count;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class RealTimePrizesItemBean {
  RealTimePrizesItemBean({
    this.logId,
    this.tid,
    this.custId,
    this.custName,
    this.bigType,
    this.upperPlayId,
    this.playUpName,
    this.playCname,
    this.playId,
    this.betAmount,
    this.odds,
    this.payoutAmount,
    this.operCode,
    this.creatTime,
    this.updateTime,
    this.indexDay,
    this.thumbnailImgUrl,
    this.head,
  });

  RealTimePrizesItemBean.fromJson(dynamic json) {
    logId = json['log_id'];
    tid = json['tid'];
    custId = json['cust_id'];
    custName = json['cust_name'];
    bigType = json['big_type'];
    upperPlayId = json['upper_play_id'];
    playUpName = json['play_up_name'];
    playCname = json['play_cname'];
    playId = json['play_id'];
    betAmount = json['bet_amount'];
    odds = json['odds'];
    payoutAmount = json['payout_amount'];
    operCode = json['oper_code'];
    creatTime = json['creat_time'];
    updateTime = json['update_time'];
    indexDay = json['index_day'];
    thumbnailImgUrl = json['thumbnail_img_url'];
    head = json['head'];
  }
  num? logId;
  num? tid;
  num? custId;
  String? custName;
  int? bigType;
  String? head;
  num? upperPlayId;
  String? playUpName;
  String? playCname;
  num? playId;
  num? betAmount;
  num? odds;
  num? payoutAmount;
  num? operCode;
  num? creatTime;
  String? updateTime;
  num? indexDay;
  String? thumbnailImgUrl;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['log_id'] = logId;
    map['tid'] = tid;
    map['cust_id'] = custId;
    map['cust_name'] = custName;
    map['big_type'] = bigType;
    map['upper_play_id'] = upperPlayId;
    map['play_up_name'] = playUpName;
    map['play_cname'] = playCname;
    map['play_id'] = playId;
    map['bet_amount'] = betAmount;
    map['odds'] = odds;
    map['payout_amount'] = payoutAmount;
    map['oper_code'] = operCode;
    map['creat_time'] = creatTime;
    map['update_time'] = updateTime;
    map['index_day'] = indexDay;
    map['thumbnail_img_url'] = thumbnailImgUrl;
    map['head'] = head;
    return map;
  }

  @override
  String toString() {
    return 'RealTimePrizesItemBean{logId: $logId, tid: $tid, custId: $custId, custName: $custName, bigType: $bigType, upperPlayId: $upperPlayId, playUpName: $playUpName, playCname: $playCname, playId: $playId, betAmount: $betAmount, odds: $odds, payoutAmount: $payoutAmount, operCode: $operCode, creatTime: $creatTime, updateTime: $updateTime, indexDay: $indexDay, thumbnailImgUrl: $thumbnailImgUrl}';
  }
}
