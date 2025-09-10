import 'package:json_annotation/json_annotation.dart';

import 'mail_reply_info.dart';

part 'feedback_detail_model.g.dart';

@JsonSerializable()
class FeedbackDetailModel {
  int? tid;
  @JsonKey(name: 'mail_id')
  int? mailId;
  @JsonKey(name: 'data_type')
  int? dataType;
  String? theme;
  String? content;
  @JsonKey(name: 'from_user')
  String? fromUser;
  @JsonKey(name: 'send_time')
  int? sendTime;
  @JsonKey(name: 'expiration_time')
  int? expirationTime;
  String? addresseeName;
  @JsonKey(name: 'is_websend')
  int? isWebsend;
  @JsonKey(name: 'oper_code')
  String? operCode;
  @JsonKey(name: 'is_annex')
  int? isAnnex;
  @JsonKey(name: 'annex_type')
  int? annexType;
  @JsonKey(name: 'code_multiple')
  int? codeMultiple;
  @JsonKey(name: 'gift_amount')
  double? giftAmount;
  @JsonKey(name: 'is_jpush')
  int? isJpush;
  @JsonKey(name: 'feedback_status')
  int? feedbackStatus;
  @JsonKey(name: 'send_num')
  int? sendNum;
  @JsonKey(name: 'send_ot_num')
  int? sendOtNum;
  @JsonKey(name: 'read_num')
  int? readNum;
  @JsonKey(name: 'send_agent_num')
  int? sendAgentNum;
  @JsonKey(name: 'send_group_num')
  int? sendGroupNum;
  @JsonKey(name: 'send_vip_num')
  int? sendVipNum;
  @JsonKey(name: 'mail_status')
  int? mailStatus;
  List<MailReplyInfo>? mailReplyInfos;
  List<dynamic>? feedbackReplyInfos;
  @JsonKey(name: 'cycle_sending_method')
  int? cycleSendingMethod;

  FeedbackDetailModel({
    this.tid,
    this.mailId,
    this.dataType,
    this.theme,
    this.content,
    this.fromUser,
    this.sendTime,
    this.expirationTime,
    this.addresseeName,
    this.isWebsend,
    this.operCode,
    this.isAnnex,
    this.annexType,
    this.codeMultiple,
    this.giftAmount,
    this.isJpush,
    this.feedbackStatus,
    this.sendNum,
    this.sendOtNum,
    this.readNum,
    this.sendAgentNum,
    this.sendGroupNum,
    this.sendVipNum,
    this.mailStatus,
    this.mailReplyInfos,
    this.feedbackReplyInfos,
    this.cycleSendingMethod,
  });

  @override
  String toString() {
    return 'FeedbackDetailModel(tid: $tid, mailId: $mailId, dataType: $dataType, theme: $theme, content: $content, fromUser: $fromUser, sendTime: $sendTime, expirationTime: $expirationTime, addresseeName: $addresseeName, isWebsend: $isWebsend, operCode: $operCode, isAnnex: $isAnnex, annexType: $annexType, codeMultiple: $codeMultiple, giftAmount: $giftAmount, isJpush: $isJpush, feedbackStatus: $feedbackStatus, sendNum: $sendNum, sendOtNum: $sendOtNum, readNum: $readNum, sendAgentNum: $sendAgentNum, sendGroupNum: $sendGroupNum, sendVipNum: $sendVipNum, mailStatus: $mailStatus, mailReplyInfos: $mailReplyInfos, feedbackReplyInfos: $feedbackReplyInfos, cycleSendingMethod: $cycleSendingMethod)';
  }

  factory FeedbackDetailModel.fromJson(Map<String, dynamic> json) {
    return _$FeedbackDetailModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$FeedbackDetailModelToJson(this);

  FeedbackDetailModel copyWith({
    int? tid,
    int? mailId,
    int? dataType,
    String? theme,
    String? content,
    String? fromUser,
    int? sendTime,
    int? expirationTime,
    String? addresseeName,
    int? isWebsend,
    String? operCode,
    int? isAnnex,
    int? annexType,
    int? codeMultiple,
    double? giftAmount,
    int? isJpush,
    int? feedbackStatus,
    int? sendNum,
    int? sendOtNum,
    int? readNum,
    int? sendAgentNum,
    int? sendGroupNum,
    int? sendVipNum,
    int? mailStatus,
    List<MailReplyInfo>? mailReplyInfos,
    List<dynamic>? feedbackReplyInfos,
    int? cycleSendingMethod,
  }) {
    return FeedbackDetailModel(
      tid: tid ?? this.tid,
      mailId: mailId ?? this.mailId,
      dataType: dataType ?? this.dataType,
      theme: theme ?? this.theme,
      content: content ?? this.content,
      fromUser: fromUser ?? this.fromUser,
      sendTime: sendTime ?? this.sendTime,
      expirationTime: expirationTime ?? this.expirationTime,
      addresseeName: addresseeName ?? this.addresseeName,
      isWebsend: isWebsend ?? this.isWebsend,
      operCode: operCode ?? this.operCode,
      isAnnex: isAnnex ?? this.isAnnex,
      annexType: annexType ?? this.annexType,
      codeMultiple: codeMultiple ?? this.codeMultiple,
      giftAmount: giftAmount ?? this.giftAmount,
      isJpush: isJpush ?? this.isJpush,
      feedbackStatus: feedbackStatus ?? this.feedbackStatus,
      sendNum: sendNum ?? this.sendNum,
      sendOtNum: sendOtNum ?? this.sendOtNum,
      readNum: readNum ?? this.readNum,
      sendAgentNum: sendAgentNum ?? this.sendAgentNum,
      sendGroupNum: sendGroupNum ?? this.sendGroupNum,
      sendVipNum: sendVipNum ?? this.sendVipNum,
      mailStatus: mailStatus ?? this.mailStatus,
      mailReplyInfos: mailReplyInfos ?? this.mailReplyInfos,
      feedbackReplyInfos: feedbackReplyInfos ?? this.feedbackReplyInfos,
      cycleSendingMethod: cycleSendingMethod ?? this.cycleSendingMethod,
    );
  }
}
