import 'package:json_annotation/json_annotation.dart';

part 'last_sys_reply.g.dart';

@JsonSerializable()
class LastSysReply {
  int? tid;
  @JsonKey(name: 'reply_id')
  int? replyId;
  String? content;
  @JsonKey(name: 'mail_info_id')
  int? mailInfoId;
  @JsonKey(name: 'put_cust_name')
  String? putCustName;
  @JsonKey(name: 'send_cust_name')
  String? sendCustName;
  @JsonKey(name: 'mail_id')
  int? mailId;
  String? theme;
  @JsonKey(name: 'send_time')
  int? sendTime;
  @JsonKey(name: 'reply_content')
  String? replyContent;
  @JsonKey(name: 'data_type')
  int? dataType;
  @JsonKey(name: 'code_multiple')
  int? codeMultiple;
  @JsonKey(name: 'gift_amount')
  double? giftAmount;
  @JsonKey(name: 'gift_status')
  int? giftStatus;
  String? currency;
  @JsonKey(name: 'oper_code')
  String? operCode;
  @JsonKey(name: 'reply_type')
  int? replyType;
  @JsonKey(name: 'reply_system_state')
  int? replySystemState;

  LastSysReply({
    this.tid,
    this.replyId,
    this.content,
    this.mailInfoId,
    this.putCustName,
    this.sendCustName,
    this.mailId,
    this.theme,
    this.sendTime,
    this.replyContent,
    this.dataType,
    this.codeMultiple,
    this.giftAmount,
    this.giftStatus,
    this.currency,
    this.operCode,
    this.replyType,
    this.replySystemState,
  });

  @override
  String toString() {
    return 'LastSysReply(tid: $tid, replyId: $replyId, content: $content, mailInfoId: $mailInfoId, putCustName: $putCustName, sendCustName: $sendCustName, mailId: $mailId, theme: $theme, sendTime: $sendTime, replyContent: $replyContent, dataType: $dataType, codeMultiple: $codeMultiple, giftAmount: $giftAmount, giftStatus: $giftStatus, currency: $currency, operCode: $operCode, replyType: $replyType, replySystemState: $replySystemState)';
  }

  factory LastSysReply.fromJson(Map<String, dynamic> json) {
    return _$LastSysReplyFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LastSysReplyToJson(this);

  LastSysReply copyWith({
    int? tid,
    int? replyId,
    String? content,
    int? mailInfoId,
    String? putCustName,
    String? sendCustName,
    int? mailId,
    String? theme,
    int? sendTime,
    String? replyContent,
    int? dataType,
    int? codeMultiple,
    double? giftAmount,
    int? giftStatus,
    String? currency,
    String? operCode,
    int? replyType,
    int? replySystemState,
  }) {
    return LastSysReply(
      tid: tid ?? this.tid,
      replyId: replyId ?? this.replyId,
      content: content ?? this.content,
      mailInfoId: mailInfoId ?? this.mailInfoId,
      putCustName: putCustName ?? this.putCustName,
      sendCustName: sendCustName ?? this.sendCustName,
      mailId: mailId ?? this.mailId,
      theme: theme ?? this.theme,
      sendTime: sendTime ?? this.sendTime,
      replyContent: replyContent ?? this.replyContent,
      dataType: dataType ?? this.dataType,
      codeMultiple: codeMultiple ?? this.codeMultiple,
      giftAmount: giftAmount ?? this.giftAmount,
      giftStatus: giftStatus ?? this.giftStatus,
      currency: currency ?? this.currency,
      operCode: operCode ?? this.operCode,
      replyType: replyType ?? this.replyType,
      replySystemState: replySystemState ?? this.replySystemState,
    );
  }
}
