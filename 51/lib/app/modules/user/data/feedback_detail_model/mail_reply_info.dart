import 'package:json_annotation/json_annotation.dart';

part 'mail_reply_info.g.dart';

@JsonSerializable()
class MailReplyInfo {
  @JsonKey(name: 'cust_name')
  String? custName;
  @JsonKey(name: 'send_time')
  int? sendTime;
  @JsonKey(name: 'reply_content')
  String? replyContent;
  @JsonKey(name: 'code_multiple')
  int? codeMultiple;
  @JsonKey(name: 'gift_amount')
  double? giftAmount;
  @JsonKey(name: 'gift_status')
  int? giftStatus;
  String? currency;
  @JsonKey(name: 'reply_type')
  int? replyType;
  @JsonKey(name: 'reply_id')
  int? replyId;

  MailReplyInfo({
    this.custName,
    this.sendTime,
    this.replyContent,
    this.codeMultiple,
    this.giftAmount,
    this.giftStatus,
    this.currency,
    this.replyType,
    this.replyId,
  });

  @override
  String toString() {
    return 'MailReplyInfo(custName: $custName, sendTime: $sendTime, replyContent: $replyContent, codeMultiple: $codeMultiple, giftAmount: $giftAmount, giftStatus: $giftStatus, currency: $currency, replyType: $replyType, replyId: $replyId)';
  }

  factory MailReplyInfo.fromJson(Map<String, dynamic> json) {
    return _$MailReplyInfoFromJson(json);
  }

  Map<String, dynamic> toJson() => _$MailReplyInfoToJson(this);

  MailReplyInfo copyWith({
    String? custName,
    int? sendTime,
    String? replyContent,
    int? codeMultiple,
    double? giftAmount,
    int? giftStatus,
    String? currency,
    int? replyType,
    int? replyId,
  }) {
    return MailReplyInfo(
      custName: custName ?? this.custName,
      sendTime: sendTime ?? this.sendTime,
      replyContent: replyContent ?? this.replyContent,
      codeMultiple: codeMultiple ?? this.codeMultiple,
      giftAmount: giftAmount ?? this.giftAmount,
      giftStatus: giftStatus ?? this.giftStatus,
      currency: currency ?? this.currency,
      replyType: replyType ?? this.replyType,
      replyId: replyId ?? this.replyId,
    );
  }
}
