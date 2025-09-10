import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_bet/generated/l10n.dart' as l10n;
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/utils/common_util.dart';

FeedbackModel feedbackModelFromJson(String str) => FeedbackModel.fromJson(json.decode(str));

String feedbackModelToJson(FeedbackModel data) => json.encode(data.toJson());

/// 反馈列表
class FeedbackModel {
  String id;
  String uid;
  String username;
  int replys;
  int newest;
  int newestM;
  int createdAt;
  int updatdAt;
  String images;
  String description;
  String updatdBy;
  int state;
  String amount;
  int bonusState;

  FeedbackModel({
    required this.id,
    required this.uid,
    required this.username,
    required this.replys,
    required this.newest,
    required this.newestM,
    required this.createdAt,
    required this.updatdAt,
    required this.images,
    required this.description,
    required this.updatdBy,
    required this.state,
    required this.amount,
    required this.bonusState,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) => FeedbackModel(
    id: json["id"],
    uid: json["uid"],
    username: json["username"],
    replys: json["replys"],
    newest: json["newest"],
    newestM: json["newest_m"],
    createdAt: json["created_at"],
    updatdAt: json["updatd_at"],
    images: json["images"],
    description: json["description"],
    updatdBy: json["updatd_by"],
    state: json["state"],
    amount: json["amount"],
    bonusState: json["bonusState"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "uid": uid,
    "username": username,
    "replys": replys,
    "newest": newest,
    "newest_m": newestM,
    "created_at": createdAt,
    "updatd_at": updatdAt,
    "images": images,
    "description": description,
    "updatd_by": updatdBy,
    "state": state,
    "amount": amount,
    "bonusState": bonusState,
  };

  /// 状态title
  String get stateTitle {

    switch (state) {
      case 1:
        return l10n.S.current.state_pending;
      case 2:
      case 3:
        return l10n.S.current.state_processed;
      default:
        return "Unknown";
    }
  }

  // 是否有未读消息
  bool get isUnread {
    return newestM > 0;
  }

  // 未读栏目Title
  String get isUnreadTitle {
    return isUnread ? l10n.S.current.message_unread : l10n.S.current.message_read;
  }

  // 日期title
  String get timeTitle {
    return CommonUtil.getLocalRecentTime(createdAt);
  }

  // 日期title
  String get timeTitle2 {
    return CommonUtil.getLocalTimeTitle(createdAt, cIncludeFormats:[yyyy, mm, dd, HH, nn, ss]);
  }


}

/// 反馈详情消息
class FeedbackMessageModel {
  String id;
  String feedId;
  String content;
  int createdAt;
  String uid;
  String images;

  /// 是否为空投奖励
  var isBonusDrop = false;

  FeedbackMessageModel({
    required this.id,
    required this.feedId,
    required this.content,
    required this.createdAt,
    required this.uid,
    required this.images,
  });

  factory FeedbackMessageModel.fromJson(Map<String, dynamic> json) => FeedbackMessageModel(
    id: json["id"],
    feedId: json["feed_id"],
    content: json["content"],
    createdAt: json["created_at"],
    uid: json["uid"],
    images: json["images"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "feed_id": feedId,
    "content": content,
    "created_at": createdAt,
    "uid": uid,
    "images": images,
  };

  List<dynamic> get imgUrls {
    List<dynamic> imagePath = json.decode(images);
    var imgUrls = [];
    for (var element in imagePath) {
      final url = "${BranchService.instance.current.asset_url}/${element.toString()}";
      imgUrls.add(url);
    }
    return imgUrls;
  }

}
