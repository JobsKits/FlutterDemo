// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'last_sys_reply.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LastSysReply _$LastSysReplyFromJson(Map<String, dynamic> json) => LastSysReply(
      tid: (json['tid'] as num?)?.toInt(),
      replyId: (json['reply_id'] as num?)?.toInt(),
      content: json['content'] as String?,
      mailInfoId: (json['mail_info_id'] as num?)?.toInt(),
      putCustName: json['put_cust_name'] as String?,
      sendCustName: json['send_cust_name'] as String?,
      mailId: (json['mail_id'] as num?)?.toInt(),
      theme: json['theme'] as String?,
      sendTime: (json['send_time'] as num?)?.toInt(),
      replyContent: json['reply_content'] as String?,
      dataType: (json['data_type'] as num?)?.toInt(),
      codeMultiple: (json['code_multiple'] as num?)?.toInt(),
      giftAmount: (json['gift_amount'] as num?)?.toDouble(),
      giftStatus: (json['gift_status'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      operCode: json['oper_code'] as String?,
      replyType: (json['reply_type'] as num?)?.toInt(),
      replySystemState: (json['reply_system_state'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LastSysReplyToJson(LastSysReply instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'reply_id': instance.replyId,
      'content': instance.content,
      'mail_info_id': instance.mailInfoId,
      'put_cust_name': instance.putCustName,
      'send_cust_name': instance.sendCustName,
      'mail_id': instance.mailId,
      'theme': instance.theme,
      'send_time': instance.sendTime,
      'reply_content': instance.replyContent,
      'data_type': instance.dataType,
      'code_multiple': instance.codeMultiple,
      'gift_amount': instance.giftAmount,
      'gift_status': instance.giftStatus,
      'currency': instance.currency,
      'oper_code': instance.operCode,
      'reply_type': instance.replyType,
      'reply_system_state': instance.replySystemState,
    };
