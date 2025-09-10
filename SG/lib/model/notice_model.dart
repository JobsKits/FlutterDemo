// To parse this JSON data, do
//
//     final noticeModel = noticeModelFromJson(jsonString);

import 'dart:convert';
import 'package:get/get.dart';
import '../services/branch/branch_service.dart';
import '../utils/lang_util.dart';

NoticeModel noticeModelFromJson(String str) => NoticeModel.fromJson(json.decode(str));

String noticeModelToJson(NoticeModel data) => json.encode(data.toJson());

class NoticeModel {
  List<Marquee>? notice;
  List<Marquee>? marquee;

  NoticeModel({
    this.notice,
    this.marquee,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) => NoticeModel(
        notice: json["notice"] == null
            ? []
            : List<Marquee>.from(json["notice"]!.map((x) => Marquee.fromJson(x))),
        marquee: json["marquee"] == null
            ? []
            : List<Marquee>.from(json["marquee"]!.map((x) => Marquee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "notice": notice == null ? [] : List<dynamic>.from(notice!.map((x) => x.toJson())),
        "marquee": marquee == null ? [] : List<dynamic>.from(marquee!.map((x) => x.toJson())),
      };
}

class Marquee {
  String? id;
  int? noticeType;
  dynamic lgTitle;
  int? startTime;
  int? endTime;
  int? bounceLocation;
  int? bounceFrequency;
  int? bounceFrequencyLimit;
  int? popUpType;
  Map? lgContent;
  Map? lgImageUrl;
  int? isLimit;
  RxBool? selected;

  Marquee({
    this.id,
    this.noticeType,
    this.lgTitle,
    this.startTime,
    this.endTime,
    this.bounceLocation,
    this.bounceFrequency,
    this.bounceFrequencyLimit,
    this.popUpType,
    this.lgContent,
    this.lgImageUrl,
    this.isLimit,
    this.selected,
  });

  factory Marquee.fromJson(Map<String, dynamic> json) => Marquee(
        id: json["id"],
        noticeType: json["notice_type"],
        lgTitle: json["title"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        bounceLocation: json["bounce_location"],
        bounceFrequency: json["bounce_frequency"],
        bounceFrequencyLimit: json["bounce_frequency_limit"],
        popUpType: json["pop_up_type"],
        lgContent: json["content"],
        lgImageUrl: json["image_url"],
        isLimit: json["is_limit"],
        selected: false.obs,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "notice_type": noticeType,
        "start_time": startTime,
        "end_time": endTime,
        "bounce_location": bounceLocation,
        "bounce_frequency": bounceFrequency,
        "bounce_frequency_limit": bounceFrequencyLimit,
        "pop_up_type": popUpType,
        "is_limit": isLimit,
      };
  
  /// 图像获取
  String get imgUrl {
    final url = "${BranchService.instance.current.asset_url}/${lgImageUrl?[languageCode]}";
    return url;
  }
  
  String get title {
    if (lgTitle is String) {
      return lgTitle;
    }
    return lgTitle![languageCode] ?? "";
  }

  String get content {
    var content = lgContent![languageCode] ?? "";
    if (languageCode == 'zh_CN' && content == '') {
      content = lgContent!['cn_zh'] ?? "";
    }
    content = content.replaceAll('</p>', '');
    content = content.replaceAll('<p>', '');
    return content;
  }

  // 语言对应code
  String get languageCode {
    return LangUtil().getLangType();
  }
}

class Content {
  String? thTh;
  String? zhCn;
  String? contentZhCn;
  String? enUs;
  String? ptBr;
  String? viVn;

  Content({
    this.thTh,
    this.zhCn,
    this.contentZhCn,
    this.enUs,
    this.ptBr,
    this.viVn,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        thTh: json["th_TH"],
        zhCn: json["zh_CN"],
        contentZhCn: json["zh_CN"],
        enUs: json["en_US"],
        ptBr: json["pt_BR"],
        viVn: json["vi_VN"],
      );

  Map<String, dynamic> toJson() => {
        "th_TH": thTh,
        "zh-CN": zhCn,
        "zh_CN": contentZhCn,
        "en_US": enUs,
        "pt_BR": ptBr,
        "vi_VN": viVn,
      };
}
