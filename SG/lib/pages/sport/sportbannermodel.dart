// To parse this JSON data, do
//
//     final sportBannerModel = sportBannerModelFromJson(jsonString);

import 'dart:convert';

List<SportBannerModel> sportBannerModelFromJson(String str) => List<SportBannerModel>.from(json.decode(str).map((x) => SportBannerModel.fromJson(x)));

String sportBannerModelToJson(List<SportBannerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SportBannerModel {
    int? jumpType;
    int? jumpState;
    String? jumpUrl;
    int? bannerStyle;
    BannerInfo? bannerInfo;
    Content? bannerUrl;
    int? pcSeq;
    int? mobileSeq;

    SportBannerModel({
        this.jumpType,
        this.jumpState,
        this.jumpUrl,
        this.bannerStyle,
        this.bannerInfo,
        this.bannerUrl,
        this.pcSeq,
        this.mobileSeq,
    });

    factory SportBannerModel.fromJson(Map<String, dynamic> json) => SportBannerModel(
        jumpType: json["jump_type"],
        jumpState: json["jump_state"],
        jumpUrl: json["jump_url"],
        bannerStyle: json["banner_style"],
        bannerInfo: json["banner_info"] == null ? null : BannerInfo.fromJson(json["banner_info"]),
        bannerUrl: json["banner_url"] == null ? null : Content.fromJson(json["banner_url"]),
        pcSeq: json["pc_seq"],
        mobileSeq: json["mobile_seq"],
    );

    Map<String, dynamic> toJson() => {
        "jump_type": jumpType,
        "jump_state": jumpState,
        "jump_url": jumpUrl,
        "banner_style": bannerStyle,
        "banner_info": bannerInfo?.toJson(),
        "banner_url": bannerUrl?.toJson(),
        "pc_seq": pcSeq,
        "mobile_seq": mobileSeq,
    };
}

class BannerInfo {
    String? background;
    String? icon;
    Content? content;
    Content? title;
    Content? superscript;
    int? buttonState;
    Content? buttonContent;
    int? buttonJumpType;
    String? buttonJumpUrl;

    BannerInfo({
        this.background,
        this.icon,
        this.content,
        this.title,
        this.superscript,
        this.buttonState,
        this.buttonContent,
        this.buttonJumpType,
        this.buttonJumpUrl,
    });

    factory BannerInfo.fromJson(Map<String, dynamic> json) => BannerInfo(
        background: json["background"],
        icon: json["icon"],
        content: json["content"] == null ? null : Content.fromJson(json["content"]),
        title: json["title"] == null ? null : Content.fromJson(json["title"]),
        superscript: json["superscript"] == null ? null : Content.fromJson(json["superscript"]),
        buttonState: json["button_state"],
        buttonContent: json["button_content"] == null ? null : Content.fromJson(json["button_content"]),
        buttonJumpType: json["button_jump_type"],
        buttonJumpUrl: json["button_jump_url"],
    );

    Map<String, dynamic> toJson() => {
        "background": background,
        "icon": icon,
        "content": content?.toJson(),
        "title": title,
        "superscript": superscript,
        "button_state": buttonState,
        "button_content": buttonContent?.toJson(),
        "button_jump_type": buttonJumpType,
        "button_jump_url": buttonJumpUrl,
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
    "hi_In": hiIn,
  };
}
