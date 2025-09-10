class LegLotteryData {
  LegLotteryData({
    this.gameGroupId,
    this.displayName,
    this.remark,
    this.sorting,
    this.games,
  });

  LegLotteryData.fromJson(dynamic json) {
    gameGroupId = json['gameGroupId'];
    displayName = json['displayName'];
    remark = json['remark'];
    sorting = json['sorting'];
    if (json['games'] != null) {
      games = [];
      json['games'].forEach((v) {
        games?.add(LotteryGames.fromJson(v));
      });
    }
  }
  String? gameGroupId;
  String? displayName;
  String? remark;
  String? sorting;
  List<LotteryGames>? games;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['gameGroupId'] = gameGroupId;
    map['displayName'] = displayName;
    map['remark'] = remark;
    map['sorting'] = sorting;
    if (games != null) {
      map['games'] = games?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LotteryGames {
  LotteryGames({
    this.upperId,
    this.playId,
    this.playCat,
    this.code,
    this.remark,
    this.hotVal,
    this.playCollection,
  });

  LotteryGames.fromJson(dynamic json) {
    upperId = json['upperId'];
    playId = json['playId'];
    playCat = json['play_cat'];
    code = json['code'];
    remark = json['remark'];
    hotVal = json['hot_val'];
    playCollection = json['play_collection'];
  }
  num? upperId;
  num? playId;
  num? playCat;
  String? code;
  String? remark;
  num? hotVal;
  num? playCollection;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['upperId'] = upperId;
    map['playId'] = playId;
    map['play_cat'] = playCat;
    map['code'] = code;
    map['remark'] = remark;
    map['hot_val'] = hotVal;
    map['play_collection'] = playCollection;
    return map;
  }
}
