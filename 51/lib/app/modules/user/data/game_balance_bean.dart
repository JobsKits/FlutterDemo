//游戏余额实体类
class GameBalanceBean {
  GameBalanceBean({
    this.playId,
    this.playName,
    this.total,
    this.lower,
    this.isKickout,
    this.eName,
    this.eId,
    this.playCname,
    this.newestChangTime,
    this.bigType,
  });

  GameBalanceBean.fromJson(dynamic json) {
    playId = json['play_id'];
    playName = json['play_name'];
    total = json['total'];
    lower = json['lower'];
    isKickout = json['is_kickout'];
    eName = json['eName'];
    eId = json['eId'];
    playCname = json['play_cname'];
    newestChangTime = json['newest_chang_time'];
    bigType = json['big_type'];
  }
  num? playId;
  String? playName;
  num? total;
  num? lower;
  num? isKickout;
  String? eName; //大的分类的名称，用于获取图标
  String? playCname;
  num? newestChangTime; //newest_chang_time
  int? bigType; //
  int? eId; //大的分类的名称，用于获取图标

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['play_id'] = playId;
    map['play_name'] = playName;
    map['total'] = total;
    map['lower'] = lower;
    map['is_kickout'] = isKickout;
    map['eName'] = eName;
    map['eId'] = eId;
    map['play_cname'] = playCname;
    map['newest_chang_time'] = newestChangTime;
    map['big_type'] = bigType;
    return map;
  }

  @override
  String toString() {
    return 'GameBalanceBean{playId: $playId, playName: $playName, total: $total, lower: $lower, isKickout: $isKickout, eName: $eName, playCname: $playCname, newestChangTime: $newestChangTime, bigType: $bigType, eId: $eId}';
  }
}
