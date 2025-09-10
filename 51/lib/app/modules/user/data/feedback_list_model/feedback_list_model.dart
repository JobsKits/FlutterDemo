import 'package:json_annotation/json_annotation.dart';

import 'last_sys_reply.dart';

part 'feedback_list_model.g.dart';

@JsonSerializable()
class FeedbackListModel {
  int? tid;
  @JsonKey(name: 'mail_id')
  int? mailId;
  String? theme;
  String? content;
  @JsonKey(name: 'send_time')
  int? sendTime;
  @JsonKey(name: 'from_user')
  String? fromUser;
  @JsonKey(name: 'put_cust_name')
  String? putCustName;
  @JsonKey(name: 'send_cust_name')
  String? sendCustName;
  int? type;
  @JsonKey(name: 'is_annex')
  int? isAnnex;
  @JsonKey(name: 'annex_type')
  int? annexType;
  @JsonKey(name: 'code_multiple')
  int? codeMultiple;
  @JsonKey(name: 'gift_amount')
  double? giftAmount;
  @JsonKey(name: 'is_receive')
  int? isReceive;
  @JsonKey(name: 'is_reply')
  int? isReply;
  @JsonKey(name: 'feedback_status')
  int? feedbackStatus;
  @JsonKey(name: 'last_sys_reply')
  LastSysReply? lastSysReply;
  @JsonKey(name: 'data_type')
  int? dataType;

  FeedbackListModel({
    this.tid,
    this.mailId,
    this.theme,
    this.content,
    this.sendTime,
    this.fromUser,
    this.putCustName,
    this.sendCustName,
    this.type,
    this.isAnnex,
    this.annexType,
    this.codeMultiple,
    this.giftAmount,
    this.isReceive,
    this.isReply,
    this.feedbackStatus,
    this.lastSysReply,
    this.dataType,
  });

  @override
  String toString() {
    return 'FeedbackListModel(tid: $tid, mailId: $mailId, theme: $theme, content: $content, sendTime: $sendTime, fromUser: $fromUser, putCustName: $putCustName, sendCustName: $sendCustName, type: $type, isAnnex: $isAnnex, annexType: $annexType, codeMultiple: $codeMultiple, giftAmount: $giftAmount, isReceive: $isReceive, isReply: $isReply, feedbackStatus: $feedbackStatus, lastSysReply: $lastSysReply, dataType: $dataType)';
  }

  factory FeedbackListModel.fromJson(Map<String, dynamic> json) {
    return _$FeedbackListModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FeedbackListModelToJson(this);

  FeedbackListModel copyWith({
    int? tid,
    int? mailId,
    String? theme,
    String? content,
    int? sendTime,
    String? fromUser,
    String? putCustName,
    String? sendCustName,
    int? type,
    int? isAnnex,
    int? annexType,
    int? codeMultiple,
    double? giftAmount,
    int? isReceive,
    int? isReply,
    int? feedbackStatus,
    LastSysReply? lastSysReply,
    int? dataType,
  }) {
    return FeedbackListModel(
      tid: tid ?? this.tid,
      mailId: mailId ?? this.mailId,
      theme: theme ?? this.theme,
      content: content ?? this.content,
      sendTime: sendTime ?? this.sendTime,
      fromUser: fromUser ?? this.fromUser,
      putCustName: putCustName ?? this.putCustName,
      sendCustName: sendCustName ?? this.sendCustName,
      type: type ?? this.type,
      isAnnex: isAnnex ?? this.isAnnex,
      annexType: annexType ?? this.annexType,
      codeMultiple: codeMultiple ?? this.codeMultiple,
      giftAmount: giftAmount ?? this.giftAmount,
      isReceive: isReceive ?? this.isReceive,
      isReply: isReply ?? this.isReply,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      lastSysReply: lastSysReply ?? this.lastSysReply,
      dataType: dataType ?? this.dataType,
    );
  }
}
