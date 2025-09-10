// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackListModel _$FeedbackListModelFromJson(Map<String, dynamic> json) =>
    FeedbackListModel(
      tid: (json['tid'] as num?)?.toInt(),
      mailId: (json['mail_id'] as num?)?.toInt(),
      theme: json['theme'] as String?,
      content: json['content'] as String?,
      sendTime: (json['send_time'] as num?)?.toInt(),
      fromUser: json['from_user'] as String?,
      putCustName: json['put_cust_name'] as String?,
      sendCustName: json['send_cust_name'] as String?,
      type: (json['type'] as num?)?.toInt(),
      isAnnex: (json['is_annex'] as num?)?.toInt(),
      annexType: (json['annex_type'] as num?)?.toInt(),
      codeMultiple: (json['code_multiple'] as num?)?.toInt(),
      giftAmount: (json['gift_amount'] as num?)?.toDouble(),
      isReceive: (json['is_receive'] as num?)?.toInt(),
      isReply: (json['is_reply'] as num?)?.toInt(),
      feedbackStatus: (json['feedback_status'] as num?)?.toInt(),
      lastSysReply: json['last_sys_reply'] == null
          ? null
          : LastSysReply.fromJson(
              json['last_sys_reply'] as Map<String, dynamic>),
      dataType: (json['data_type'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FeedbackListModelToJson(FeedbackListModel instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'mail_id': instance.mailId,
      'theme': instance.theme,
      'content': instance.content,
      'send_time': instance.sendTime,
      'from_user': instance.fromUser,
      'put_cust_name': instance.putCustName,
      'send_cust_name': instance.sendCustName,
      'type': instance.type,
      'is_annex': instance.isAnnex,
      'annex_type': instance.annexType,
      'code_multiple': instance.codeMultiple,
      'gift_amount': instance.giftAmount,
      'is_receive': instance.isReceive,
      'is_reply': instance.isReply,
      'feedback_status': instance.feedbackStatus,
      'last_sys_reply': instance.lastSysReply,
      'data_type': instance.dataType,
    };
