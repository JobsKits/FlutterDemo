
import 'package:json_annotation/json_annotation.dart';

///接收 接口数据的 model
class CoinRateApiModel{
  int date;
  Map<String, CoinRate> rates;

  CoinRateApiModel({
    required this.date,
    required this.rates,
  });

  factory CoinRateApiModel.fromJson(Map<String, dynamic> json) => CoinRateApiModel(
    date: json["date"],
    rates: Map.from(json["rates"]).map((k, v) => MapEntry<String, CoinRate>(k, CoinRate.fromJson(v))),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
  };
}


/// 货币汇率 model
@JsonSerializable()
class CoinRate {
  // "BNB": "0.000000164", //VND兑换BNB
  // "BTC": "0.0000000011355238861021984",
  // "ETH": "0.00000002044650423230871",
  // "USDT": "0.00004114689946061837",
  // "INR": "0.0034198104190046575",
  // "BRL": "0.0002000621970945001",
  // "THB": "0.0014611010064655774",
  // "CNY": "0.0002981089026649456" //基础币
  // "VND":"0.000000164"
  @JsonKey(name: '701')
  String? field701;

  @JsonKey(name: '702')
  String? field702;

  @JsonKey(name: '703')
  String? field703;

  @JsonKey(name: '704')
  String? field704;

  @JsonKey(name: '705')
  String? field705;

  @JsonKey(name: '706')
  String? field706;

  @JsonKey(name: '707')
  String? field707;

  @JsonKey(name: '708')
  String? field708;

  @JsonKey(name: '709')
  String? field709;

  @JsonKey(name: '710')
  String? field710 ="0.0";

  @JsonKey(name: '711')
  String? field711 ="0.0";

  @JsonKey(name: '712')
  String? field712 ="0.0";

  @JsonKey(name: '713')
  String? field713 ="0.0";

  @JsonKey(name: '714')
  String? field714 ="0.0";

  @JsonKey(name: '715')
  String? field715 ="0.0";

  @JsonKey(name: '716')
  String? field716 ="0.0";

  @JsonKey(name: '717')
  String? field717 ="0.0";

  @JsonKey(name: '718')
  String? field718 ="0.0";

  @JsonKey(name: '719')
  String? field719 ="0.0";

  @JsonKey(name: '720')
  String? field720 ="0.0";

  @JsonKey(name: '721')
  String? field721 ="0.0";

  @JsonKey(name: '722')
  String? field722 ="0.0";

  @JsonKey(name: '723')
  String? field723 ="0.0";

  @JsonKey(name: '724')
  String? field724 ="0.0";


  @JsonKey(name: '725')
  String? field725 ="0.0";

  @JsonKey(name: '726')
  String? field726 ="0.0";

  @JsonKey(name: '727')
  String? field727 ="0.0";

  @JsonKey(name: '728')
  String? field728 ="0.0";

  @JsonKey(name: '729')
  String? field729 ="0.0";

  @JsonKey(name: '730')
  String? field730 ="0.0";

  @JsonKey(name: '731')
  String? field731 ="0.0";

  @JsonKey(name: '732')
  String? field732 ="0.0";

  CoinRate({
    this.field701,
    this.field702,
    this.field703,
    this.field704,
    this.field705,
    this.field706,
    this.field707,
    this.field708,
    this.field709,
    this.field710,
    this.field711,
    this.field712,
    this.field713,
    this.field714,
    this.field715,
    this.field716,
    this.field717,
    this.field718,
    this.field719,
    this.field720,
    this.field721,
    this.field722,
    this.field723,
    this.field724,
    this.field725,
    this.field726,
    this.field727,
    this.field728,
    this.field729,
    this.field730,
    this.field731,
    this.field732,
  });

  factory CoinRate.fromJson(Map<String, dynamic> json) => CoinRate(
    field701: json["701"],
    field702: json["702"],
    field703: json["703"],
    field704: json["704"],
    field705: json["705"],
    field706: json["706"],
    field707: json["707"],
    field708: json["708"],
    field709: json["709"],
    field710: json["710"] ,
    field711: json["711"],
    field712: json["712"],
    field713: json["713"],
    field714: json["714"],
    field715: json["715"],
    field716: json["716"],
    field717: json["717"],
    field718: json["718"],
    field719: json["719"],
    field720: json["720"],
    field721: json["721"],
    field722: json["722"],
    field723: json["723"],
    field724: json["724"],
    field725: json["725"],
    field726: json["726"],
    field727: json["727"],
    field728: json["728"],
    field729: json["729"],
    field730: json["730"],
    field731: json["731"],
    field732: json["732"],
  );

  Map<String, dynamic> toJson() => {
        "701": field701,
        "702": field702,
        "703": field703,
        "704": field704,
        "705": field705,
        "706": field706,
        "707": field707,
        "708": field708,
        "709": field709,
        "710": field710,
        "711": field711,
        "712": field712,
        "713": field713,
        "714": field714,
        "715": field715,
        "716": field716,
        "717": field717,
        "718": field718,
        "719": field719,
        "720": field720,
        "721": field721,
        "722": field722,
        "723": field723,
        "724": field724,
        "725": field725,
        "726": field726,
        "727": field727,
        "728": field728,
        "729": field729,
        "730": field730,
        "731": field731,
        "732": field732,
      };
}
