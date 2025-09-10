class LuckyWheelBean {
  LuckyWheelBean({
    this.lbwId,
    this.show,
    this.restrict,
    this.topUp,
    this.qipai,
    this.dianzi,
    this.caipiao,
    this.buyu,
    this.zhenren,
    this.tiyu,
    this.tId,
    this.details,
    this.state,
    this.markingTimes,
    this.type,
    this.zhishu,
    this.amount,
    this.integralNum,
    this.balance,
    this.luckyBigWheelSys,
  });

  LuckyWheelBean.fromJson(dynamic json) {
    lbwId = json['lbwId'];
    show = json['show'];
    restrict = json['restrict'];
    topUp = json['topUp'];
    qipai = json['qipai'];
    dianzi = json['dianzi'];
    caipiao = json['caipiao'];
    buyu = json['buyu'];
    zhenren = json['zhenren'];
    tiyu = json['tiyu'];
    tId = json['tId'];
    details = json['details'];
    state = json['state'];
    markingTimes = json['markingTimes'];
    type = json['type'];
    zhishu = json['zhishu'];
    amount = json['amount'];
    integralNum = json['integral_num'];
    balance = json['balance'];
    if (json['luckyBigWheelSys'] != null) {
      luckyBigWheelSys = [];
      json['luckyBigWheelSys'].forEach((v) {
        luckyBigWheelSys?.add(LuckyBigWheelSys.fromJson(v));
      });
    }
  }
  num? lbwId;
  num? show;
  num? restrict;
  num? topUp;
  num? qipai;
  num? dianzi;
  num? caipiao;
  num? buyu;
  num? zhenren;
  num? tiyu;
  num? tId;
  String? details;
  num? state;
  num? markingTimes;
  num? type;
  num? zhishu;
  num? amount;
  num? integralNum;
  num? balance;
  List<LuckyBigWheelSys>? luckyBigWheelSys;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lbwId'] = lbwId;
    map['show'] = show;
    map['restrict'] = restrict;
    map['topUp'] = topUp;
    map['qipai'] = qipai;
    map['dianzi'] = dianzi;
    map['caipiao'] = caipiao;
    map['buyu'] = buyu;
    map['zhenren'] = zhenren;
    map['tiyu'] = tiyu;
    map['tId'] = tId;
    map['details'] = details;
    map['state'] = state;
    map['markingTimes'] = markingTimes;
    map['type'] = type;
    map['zhishu'] = zhishu;
    map['amount'] = amount;
    map['integral_num'] = integralNum;
    map['balance'] = balance;
    if (luckyBigWheelSys != null) {
      map['luckyBigWheelSys'] =
          luckyBigWheelSys?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LuckyBigWheelSys {
  LuckyBigWheelSys({
    this.sysId,
    this.name,
    this.integral,
    this.lbwId,
    this.state,
    this.luckyBigWheeDetails,
    this.sysType,
  });

  LuckyBigWheelSys.fromJson(dynamic json) {
    sysId = json['sysId'];
    name = json['name'];
    integral = json['integral'];
    lbwId = json['lbwId'];
    state = json['state'];
    if (json['luckyBigWheeDetails'] != null) {
      luckyBigWheeDetails = [];
      json['luckyBigWheeDetails'].forEach((v) {
        luckyBigWheeDetails?.add(LuckyBigWheeDetails.fromJson(v));
      });
    }
    sysType = json['sys_type'];
  }
  int? sysId;
  String? name;
  num? integral;
  num? lbwId;
  num? state;
  List<LuckyBigWheeDetails>? luckyBigWheeDetails;
  num? sysType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sysId'] = sysId;
    map['name'] = name;
    map['integral'] = integral;
    map['lbwId'] = lbwId;
    map['state'] = state;
    if (luckyBigWheeDetails != null) {
      map['luckyBigWheeDetails'] =
          luckyBigWheeDetails?.map((v) => v.toJson()).toList();
    }
    map['sys_type'] = sysType;
    return map;
  }
}

class LuckyBigWheeDetails {
  LuckyBigWheeDetails({
    this.detailsId,
    this.prize,
    this.v,
    this.sysId,
    this.type,
    this.name,
    this.imgUrl,
    this.awartType,
  });

  LuckyBigWheeDetails.fromJson(dynamic json) {
    detailsId = json['detailsId'];
    prize = json['prize'];
    v = json['v'];
    sysId = json['sysId'];
    type = json['type'];
    name = json['name'];
    imgUrl = json['img_url'];
    awartType = json['awart_type'];
  }
  num? detailsId;
  num? prize;
  num? v;
  num? sysId;
  num? type;
  String? name;
  String? imgUrl;
  num? awartType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['detailsId'] = detailsId;
    map['prize'] = prize;
    map['v'] = v;
    map['sysId'] = sysId;
    map['type'] = type;
    map['name'] = name;
    map['img_url'] = imgUrl;
    map['awart_type'] = awartType;
    return map;
  }

  @override
  String toString() {
    return 'LuckyBigWheeDetails{detailsId: $detailsId, prize: $prize, v: $v, sysId: $sysId, type: $type, name: $name, imgUrl: $imgUrl, awartType: $awartType}';
  }
}

//大转盘积分的实体类
class LuckyPointsBean {
  LuckyPointsBean({
    this.usable,
    this.tomorrow,
  });

  LuckyPointsBean.fromJson(dynamic json) {
    usable = json['usable'];
    tomorrow = json['tomorrow'];
  }
  num? usable;
  num? tomorrow;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['usable'] = usable;
    map['tomorrow'] = tomorrow;
    return map;
  }
}

//大转盘选中的实体类
class LuckySelectBean {
  LuckySelectBean({
    this.detailsId,
    this.prize,
    this.v,
    this.sysId,
    this.type,
    this.name,
    this.imgUrl,
    this.awartType,
  });

  LuckySelectBean.fromJson(dynamic json) {
    detailsId = json['detailsId'];
    prize = json['prize'];
    v = json['v'];
    sysId = json['sysId'];
    type = json['type'];
    name = json['name'];
    imgUrl = json['img_url'];
    awartType = json['awart_type'];
  }
  num? detailsId;
  int? prize;
  num? v;
  num? sysId;
  num? type;
  String? name;
  String? imgUrl;
  num? awartType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['detailsId'] = detailsId;
    map['prize'] = prize;
    map['v'] = v;
    map['sysId'] = sysId;
    map['type'] = type;
    map['name'] = name;
    map['img_url'] = imgUrl;
    map['awart_type'] = awartType;
    return map;
  }
}
