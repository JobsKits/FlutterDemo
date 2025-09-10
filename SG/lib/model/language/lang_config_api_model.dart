///不同接口 会动态配置语言 显示
class LangConfigApiModel {
  String? zhCn;
  String? ptBr;
  String? viVn;
  String? thTh;
  String? enUs;
  String? hiIn;
  String? original;

  LangConfigApiModel({
    this.zhCn,
    this.ptBr,
    this.viVn,
    this.thTh,
    this.enUs,
    this.hiIn,
    this.original,
  });

  factory LangConfigApiModel.fromJson(Map<String, dynamic> json) => LangConfigApiModel(
        zhCn: json["zh_CN"],
        ptBr: json["pt_BR"],
        viVn: json["vi_VN"],
        thTh: json["th_TH"],
        enUs: json["en_US"],
        hiIn: json["hi_In"],
        original: json["original"],
      );

  Map<String, dynamic> toJson() => {
        "zh_CN": zhCn,
        "pt_BR": ptBr,
        "vi_VN": viVn,
        "th_TH": thTh,
        "en_US": enUs,
        "hi_In": hiIn,
        "original": original,
      };
}
