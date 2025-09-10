// To parse this JSON data, do
//
//     final announcementModel = announcementModelFromJson(jsonString);

import 'dart:convert';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/lang_util.dart';
import 'package:flutter_bet/utils/common_util.dart';
import 'package:get/get.dart';

List<AnnouncementModel> announcementModelFromJson(String str) => List<AnnouncementModel>.from(json.decode(str).map((x) => AnnouncementModel.fromJson(x)));

/// 公告 跑马灯 站内信
class AnnouncementModel {
  String id;
  int? noticeType;
  dynamic lgTitle;
  int startTime;
  int? endTime;
  int? bounceLocation;
  int? bounceFrequency;
  int? bounceFrequencyLimit;
  int? popUpType;
  Map? lgContent;
  Map? lgImageUrl;
  int? isLimit;
  RxBool? selected;

  /// 站内信/公告 1已读/2未读
  int? state;

  AnnouncementModel({
    required this.id,
    this.noticeType,
    this.lgTitle,
    required this.startTime,
    this.endTime,
    this.bounceLocation,
    this.bounceFrequency,
    this.bounceFrequencyLimit,
    this.popUpType,
    this.lgContent,
    this.lgImageUrl,
    this.isLimit,
    this.selected,
    this.state,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => AnnouncementModel(
    id: json["id"],
    noticeType: json["notice_type"],
    lgTitle: json["title"],
    startTime: json["start_time"] ?? json["created_at"],
    endTime: json["end_time"],
    bounceLocation: json["bounce_location"],
    bounceFrequency: json["bounce_frequency"],
    bounceFrequencyLimit: json["bounce_frequency_limit"],
    popUpType: json["pop_up_type"],
    lgContent: json["content"],
    lgImageUrl: json["image_url"],
    isLimit: json["is_limit"],
    selected: false.obs,
    state: json["state"] ?? json["is_read"] ?? 1
  );

  /// 消息类型icon
  String get typeNameAsset {
    // 公告
    if(noticeType != null) {
      return isUnread ? "assets/images/notice/announcement_d.webp"
          : "assets/images/notice/announcement_e.webp";
    }
    // 站内信
    return isUnread ? "assets/images/notice/email_d.webp"
        : "assets/images/notice/email_e.webp";
  }

  /// 消息类型icon Size
  double get typeNameAssetSize {
    // noticeType != null ? 公告 : 站内信
    return noticeType != null ? AppValues.iconSize_20 : 20;
  }

  /// 是否有未读消息
  bool get isUnread {
    return state == 2;
  }

  /// 是否为图像内容
  /// 1/null文字，2图片
  bool get isImgType {
    return popUpType == 2;
  }

  /// 图像获取
  String get imgUrl {
    final url = "${BranchService.instance.current.asset_url}/${lgImageUrl?[languageCode]}";
    return url;
  }

  String get itemContent {
    return content;
  }

  String get title {
    if(lgTitle == null) {
      return "";
    }
    if (lgTitle is String) {
      return lgTitle;
    }
    return lgTitle![languageCode] ?? "";
  }

  String get content {
    var content = lgContent?[languageCode] ?? "";
    if (languageCode == 'zh_CN' && content == '') {
      content = lgContent?['cn_zh'] ?? "";
    }
    content = content.replaceAll('</p>', '');
    content = content.replaceAll('<p>', '');
    return content;
  }

  // 语言对应code
  String get languageCode {
    return LangUtil().getLangType();
  }

  // 日期title
  String get timeTitle {
    return CommonUtil.getLocalRecentTime(startTime);
  }

}
