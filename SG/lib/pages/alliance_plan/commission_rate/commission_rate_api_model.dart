


///返佣比例 /agency/commission/scale
class CommissionRateApiModel {
  ConfGlobal? confGlobal;
  List<CommissionConf>? conf;

  CommissionRateApiModel({
    this.confGlobal,
    this.conf,
  });

  factory CommissionRateApiModel.fromJson(Map<String, dynamic> json) => CommissionRateApiModel(
    confGlobal: json["conf_global"] == null ? null : ConfGlobal.fromJson(json["conf_global"]),
    conf: json["conf"] == null ? [] : List<CommissionConf>.from(json["conf"]!.map((x) => CommissionConf.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "conf_global": confGlobal?.toJson(),
    "conf": conf == null ? [] : List<dynamic>.from(conf!.map((x) => x.toJson())),
  };
}

///佣金配置
class CommissionConf {
  String? id;
  String? modelIds; //1真人 2捕鱼 3电子 4体育 5棋牌 6电竞
  List<CommissionLevel>? levels;
  List<String>? ico; //图标
  // "ico": [
  // "/images/CATE/fishing.webp",
  // "/images/CATE/live.webp"
  // ],
  dynamic performances;

  CommissionConf({
    this.id,
    this.modelIds,
    this.ico,
    this.levels,
    this.performances,

  });

  factory CommissionConf.fromJson(Map<String, dynamic> json) => CommissionConf(
    id: json["id"],
    modelIds: json["model_ids"],
    levels: json["levels"] == null ? [] : List<CommissionLevel>.from(json["levels"]!.map((x) => CommissionLevel.fromJson(x))),
    ico: json["ico"] == null ? [] : List<String>.from(json["ico"]!.map((x) => x)),
    performances: json["performances"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "model_ids": modelIds,
    "levels": levels == null ? [] : List<dynamic>.from(levels!.map((x) => x.toJson())),
    "ico": ico == null ? [] : List<dynamic>.from(ico!.map((x) => x)),
    "performances": performances,
  };
}

///佣金等级
class CommissionLevel {
  String? id;
  String? commissionId;
  int? level;
  String? effectiveAmount; //有效投注≥(单位：万)
  String? rebateRatio; //返佣比例%
  String? updatedBy;
  int? updatedAt;
  String? uid;

  CommissionLevel({
    this.id,
    this.commissionId,
    this.level,
    this.effectiveAmount,
    this.rebateRatio,
    this.updatedBy,
    this.updatedAt,
    this.uid,
  });

  factory CommissionLevel.fromJson(Map<String, dynamic> json) => CommissionLevel(
    id: json["id"],
    commissionId: json["commission_id"],
    level: json["level"],
    effectiveAmount: json["effective_amount"],
    rebateRatio: json["rebate_ratio"],
    updatedBy: json["updated_by"],
    updatedAt: json["updated_at"],
    uid: json["uid"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "commission_id": commissionId,
    "level": level,
    "effective_amount": effectiveAmount,
    "rebate_ratio": rebateRatio,
    "updated_by": updatedBy,
    "updated_at": updatedAt,
    "uid": uid,
  };
}

class ConfGlobal {
  String? id;
  int? sendType;
  String? commissionMaxLimit;
  int? commissionSettlementType;

  ConfGlobal({
    this.id,
    this.sendType,
    this.commissionMaxLimit,
    this.commissionSettlementType,
  });

  factory ConfGlobal.fromJson(Map<String, dynamic> json) => ConfGlobal(
    id: json["id"],
    sendType: json["send_type"],
    commissionMaxLimit: json["commission_max_limit"],
    commissionSettlementType: json["commission_settlement_type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "send_type": sendType,
    "commission_max_limit": commissionMaxLimit,
    "commission_settlement_type": commissionSettlementType,
  };
}
