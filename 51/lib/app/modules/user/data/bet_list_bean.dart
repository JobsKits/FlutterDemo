class BetListBean {
  BetListBean({
    this.t,
    this.data,
    this.count,
  });

  BetListBean.fromJson(dynamic json) {
    t = json['t'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BetItem.fromJson(v));
      });
    }
    count = json['count'];
  }
  String? t;
  List<BetItem>? data;
  int? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['t'] = t;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['count'] = count;
    return map;
  }
}

class BetResponseBean {
  BetResponseBean({
    required this.hasMore,
    required this.list,
  });

  bool hasMore;
  List<BetItem> list;
}

class BetItem {
  BetItem({
    this.playTypeId,
    this.platformOrderId,
    this.effectiveBets,
    this.betStartTime,
    this.profitLoss,
    this.custName,
    this.bets,
    this.orderId,
    this.gameTypeId,
    this.game_type_cname,
    this.play_cname,
    this.settle_flag,
  });

  BetItem.fromJson(dynamic json) {
    playTypeId = json['play_type_id'];
    platformOrderId = json['platform_order_id'];
    effectiveBets = json['effective_bets'] is String
        ? num.parse(json['effective_bets'])
        : json['effective_bets'];
    betStartTime = json['bet_start_time'];
    profitLoss = json['profit_loss'];
    custName = json['cust_name'];
    bets = json['bets'];
    orderId = json['order_id'];
    gameTypeId = json['game_type_id'].toString();
    state = json['state'];
    dispFlag = json['disp_flag'];
    gameId = json['game_id'];
    betType = json['betType'];
    game_type_cname = json['game_type_cname'];
    play_cname = json['play_cname'];
    settle_flag = json['settle_flag'];
  }
  String? playTypeId;
  String? play_cname;
  String? platformOrderId;
  num? effectiveBets;
  dynamic? betStartTime;
  dynamic? profitLoss;
  String? custName;
  dynamic? bets;
  int? state;
  String? orderId;
  String? gameTypeId;
  String? dispFlag;
  String? gameId;
  String? betType;
  String? settle_flag;
  String? game_type_cname;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['play_type_id'] = playTypeId;
    map['platform_order_id'] = platformOrderId;
    map['effective_bets'] = effectiveBets;
    map['bet_start_time'] = betStartTime;
    map['profit_loss'] = profitLoss;
    map['cust_name'] = custName;
    map['bets'] = bets;
    map['order_id'] = orderId;
    map['game_type_id'] = gameTypeId;
    map['state'] = state;
    map['disp_flag'] = dispFlag;
    map['game_id'] = gameId;
    map['betType'] = betType;
    map['game_type_cname'] = game_type_cname;
    map['play_cname'] = play_cname;
    map['settle_flag'] = settle_flag;
    return map;
  }

  @override
  String toString() {
    return 'BetItem{playTypeId: $playTypeId, platformOrderId: $platformOrderId, effectiveBets: $effectiveBets, betStartTime: $betStartTime, profitLoss: $profitLoss, custName: $custName, bets: $bets, orderId: $orderId, gameTypeId: $gameTypeId}';
  }
}
