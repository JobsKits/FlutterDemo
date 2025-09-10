// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_reply_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MailReplyInfo _$MailReplyInfoFromJson(Map<String, dynamic> json) =>
    MailReplyInfo(
      custName: json['cust_name'] as String?,
      sendTime: (json['send_time'] as num?)?.toInt(),
      replyContent: json['reply_content'] as String?,
      codeMultiple: (json['code_multiple'] as num?)?.toInt(),
      giftAmount: (json['gift_amount'] as num?)?.toDouble(),
      giftStatus: (json['gift_status'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      replyType: (json['reply_type'] as num?)?.toInt(),
      replyId: (json['reply_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MailReplyInfoToJson(MailReplyInfo instance) =>
    <String, dynamic>{
      'cust_name': instance.custName,
      'send_time': instance.sendTime,
      'reply_content': instance.replyContent,
      'code_multiple': instance.codeMultiple,
      'gift_amount': instance.giftAmount,
      'gift_status': instance.giftStatus,
      'currency': instance.currency,
      'reply_type': instance.replyType,
      'reply_id': instance.replyId,
    };
