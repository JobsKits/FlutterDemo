// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
    String? summary;
    int? ruleType;
    String? detail;
    int? button;
    int? buttonType;
    String? buttonText;
    String? buttonRedirect;
    int? startAt;
    int? endAt;
    String? images;
    String? automatic;
    int? countStartAt;
    int? countEndAt;
    int? receiveStartAt;
    int? receiveEndAt;
    int? giveAt;
    int? period;
    int? applyPeriod;
    String? currencyId;
    List<String>? currencyIds;
    String? prizeLimit;
    PrizeConfig? prizeConfig;

    ConfigModel({
        this.summary,
        this.ruleType,
        this.detail,
        this.button,
        this.buttonType,
        this.buttonText,
        this.buttonRedirect,
        this.startAt,
        this.endAt,
        this.images,
        this.automatic,
        this.countStartAt,
        this.countEndAt,
        this.receiveStartAt,
        this.receiveEndAt,
        this.giveAt,
        this.period,
        this.applyPeriod,
        this.currencyId,
        this.currencyIds,
        this.prizeLimit,
        this.prizeConfig,
    });

    factory ConfigModel.fromJson(Map<dynamic, dynamic> json) => ConfigModel(
        summary: json["summary"],
        ruleType: json["rule_type"],
        detail: json["detail"],
        button: json["button"],
        buttonType: json["button_type"],
        buttonText: json["button_text"],
        buttonRedirect: json["button_redirect"],
        startAt: json["start_at"],
        endAt: json["end_at"],
        images: json["images"],
        automatic: json["automatic"],
        countStartAt: json["count_start_at"],
        countEndAt: json["count_end_at"],
        receiveStartAt: json["receive_start_at"],
        receiveEndAt: json["receive_end_at"],
        giveAt: json["give_at"],
        period: json["period"],
        applyPeriod: json["apply_period"],
        currencyId: json["currency_id"],
        currencyIds: json["currency_ids"] == null ? [] : List<String>.from(json["currency_ids"]!.map((x) => x)),
        prizeLimit: json["prize_limit"],
        prizeConfig: json["prize_config"] == null ? null : PrizeConfig.fromJson(json["prize_config"]),
    );

    Map<String, dynamic> toJson() => {
        "summary": summary,
        "rule_type": ruleType,
        "detail": detail,
        "button": button,
        "button_type": buttonType,
        "button_text": buttonText,
        "button_redirect": buttonRedirect,
        "start_at": startAt,
        "end_at": endAt,
        "images": images,
        "automatic": automatic,
        "count_start_at": countStartAt,
        "count_end_at": countEndAt,
        "receive_start_at": receiveStartAt,
        "receive_end_at": receiveEndAt,
        "give_at": giveAt,
        "period": period,
        "apply_period": applyPeriod,
        "currency_id": currencyId,
        "currency_ids": currencyIds == null ? [] : List<dynamic>.from(currencyIds!.map((x) => x)),
        "prize_limit": prizeLimit,
        "prize_config": prizeConfig?.toJson(),
    };
}

class PrizeConfig {
    String? currencyId;
    String? prizeLimit;
    List<ProfitPrizeConfig>? profitPrizeConfig;

    PrizeConfig({
        this.currencyId,
        this.prizeLimit,
        this.profitPrizeConfig,
    });

    factory PrizeConfig.fromJson(Map<dynamic, dynamic> json) => PrizeConfig(
        currencyId: json["currency_id"],
        prizeLimit: json["prize_limit"],
        profitPrizeConfig: json["profit_prize_config"] == null ? [] : List<ProfitPrizeConfig>.from(json["profit_prize_config"]!.map((x) => ProfitPrizeConfig.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "currency_id": currencyId,
        "prize_limit": prizeLimit,
        "profit_prize_config": profitPrizeConfig == null ? [] : List<dynamic>.from(profitPrizeConfig!.map((x) => x.toJson())),
    };
}

class ProfitPrizeConfig {
    String? level;
    String? validBetAmount;
    String? bonusRate;
    bool? receive;

    ProfitPrizeConfig({
        this.level,
        this.validBetAmount,
        this.bonusRate,
        this.receive,
    });

    factory ProfitPrizeConfig.fromJson(Map<String, dynamic> json) => ProfitPrizeConfig(
        level: json["level"],
        validBetAmount: json["valid_bet_amount"],
        bonusRate: json["bonus_rate"],
        receive: json["receive"],
    );

    Map<String, dynamic> toJson() => {
        "level": level,
        "valid_bet_amount": validBetAmount,
        "bonus_rate": bonusRate,
        "receive": receive,
    };
}

class Content {
  String? viVn;
  String? thTh;
  String? zhCn;
  String? contentZhCn;
  String? enUs;
  String? ptBr;
  String? hiIn;

  Content({
    this.viVn,
    this.thTh,
    this.zhCn,
    this.contentZhCn,
    this.enUs,
    this.ptBr,
    this.hiIn,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    viVn: json["vi_VN"],
    thTh: json["th_TH"],
    zhCn: json["zh-CN"],
    contentZhCn: json["zh_CN"],
    enUs: json["en_US"],
    ptBr: json["pt_BR"],
    hiIn: json["hi_IN"],
  );

  Map<String, dynamic> toJson() => {
    "vi_VN": viVn,
    "th_TH": thTh,
    "zh-CN": zhCn,
    "zh_CN": contentZhCn,
    "en_US": enUs,
    "pt_BR": ptBr,
    "hi_IN": hiIn,
  };
}

