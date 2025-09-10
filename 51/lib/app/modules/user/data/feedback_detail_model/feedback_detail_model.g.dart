// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedbackDetailModel _$FeedbackDetailModelFromJson(Map<String, dynamic> json) =>
    FeedbackDetailModel(
      tid: (json['tid'] as num?)?.toInt(),
      mailId: (json['mail_id'] as num?)?.toInt(),
      dataType: (json['data_type'] as num?)?.toInt(),
      theme: json['theme'] as String?,
      content: json['content'] as String?,
      fromUser: json['from_user'] as String?,
      sendTime: (json['send_time'] as num?)?.toInt(),
      expirationTime: (json['expiration_time'] as num?)?.toInt(),
      addresseeName: json['addresseeName'] as String?,
      isWebsend: (json['is_websend'] as num?)?.toInt(),
      operCode: json['oper_code'] as String?,
      isAnnex: (json['is_annex'] as num?)?.toInt(),
      annexType: (json['annex_type'] as num?)?.toInt(),
      codeMultiple: (json['code_multiple'] as num?)?.toInt(),
      giftAmount: (json['gift_amount'] as num?)?.toDouble(),
      isJpush: (json['is_jpush'] as num?)?.toInt(),
      feedbackStatus: (json['feedback_status'] as num?)?.toInt(),
      sendNum: (json['send_num'] as num?)?.toInt(),
      sendOtNum: (json['send_ot_num'] as num?)?.toInt(),
      readNum: (json['read_num'] as num?)?.toInt(),
      sendAgentNum: (json['send_agent_num'] as num?)?.toInt(),
      sendGroupNum: (json['send_group_num'] as num?)?.toInt(),
      sendVipNum: (json['send_vip_num'] as num?)?.toInt(),
      mailStatus: (json['mail_status'] as num?)?.toInt(),
      mailReplyInfos: (json['mailReplyInfos'] as List<dynamic>?)
          ?.map((e) => MailReplyInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
      feedbackReplyInfos: json['feedbackReplyInfos'] as List<dynamic>?,
      cycleSendingMethod: (json['cycle_sending_method'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FeedbackDetailModelToJson(
        FeedbackDetailModel instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'mail_id': instance.mailId,
      'data_type': instance.dataType,
      'theme': instance.theme,
      'content': instance.content,
      'from_user': instance.fromUser,
      'send_time': instance.sendTime,
      'expiration_time': instance.expirationTime,
      'addresseeName': instance.addresseeName,
      'is_websend': instance.isWebsend,
      'oper_code': instance.operCode,
      'is_annex': instance.isAnnex,
      'annex_type': instance.annexType,
      'code_multiple': instance.codeMultiple,
      'gift_amount': instance.giftAmount,
      'is_jpush': instance.isJpush,
      'feedback_status': instance.feedbackStatus,
      'send_num': instance.sendNum,
      'send_ot_num': instance.sendOtNum,
      'read_num': instance.readNum,
      'send_agent_num': instance.sendAgentNum,
      'send_group_num': instance.sendGroupNum,
      'send_vip_num': instance.sendVipNum,
      'mail_status': instance.mailStatus,
      'mailReplyInfos': instance.mailReplyInfos,
      'feedbackReplyInfos': instance.feedbackReplyInfos,
      'cycle_sending_method': instance.cycleSendingMethod,
    };
