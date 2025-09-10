// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageUrlBean _$UploadImageUrlBeanFromJson(Map<String, dynamic> json) =>
    UploadImageUrlBean(
      token: json['token'] as String?,
      url: (json['url'] as List<dynamic>?)
          ?.map((e) => UploadImageUrlItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$UploadImageUrlBeanToJson(UploadImageUrlBean instance) =>
    <String, dynamic>{
      'token': instance.token,
      'url': instance.url,
    };

UploadImageUrlItem _$UploadImageUrlItemFromJson(Map<String, dynamic> json) =>
    UploadImageUrlItem(
      callback_addr: json['callback_addr'] as String?,
      chan_code: json['chan_code'] as String?,
      clusters_id: (json['clusters_id'] as num?)?.toInt(),
      create_time: json['create_time'] as num?,
      domain_addr: json['domain_addr'] as String?,
      domain_ip: json['domain_ip'] as String?,
      domain_line_id: json['domain_line_id'] as num?,
      domain_type: (json['domain_type'] as num?)?.toInt(),
      oper_code: json['oper_code'] as String?,
      spare_addr: json['spare_addr'] as String?,
      state: (json['state'] as num?)?.toInt(),
      state_time: json['state_time'] as num?,
      tid: (json['tid'] as num?)?.toInt(),
      weight: (json['weight'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UploadImageUrlItemToJson(UploadImageUrlItem instance) =>
    <String, dynamic>{
      'callback_addr': instance.callback_addr,
      'chan_code': instance.chan_code,
      'clusters_id': instance.clusters_id,
      'create_time': instance.create_time,
      'domain_addr': instance.domain_addr,
      'domain_ip': instance.domain_ip,
      'domain_line_id': instance.domain_line_id,
      'domain_type': instance.domain_type,
      'oper_code': instance.oper_code,
      'spare_addr': instance.spare_addr,
      'state': instance.state,
      'state_time': instance.state_time,
      'tid': instance.tid,
      'weight': instance.weight,
    };

AliyunOssConfigBean _$AliyunOssConfigBeanFromJson(Map<String, dynamic> json) =>
    AliyunOssConfigBean(
      create_time: json['create_time'] as num?,
      doubleValue: json['doubleValue'] as num?,
      intValue: json['intValue'] as num?,
      modify_time: json['modify_time'] as num?,
      oper_code: json['oper_code'] as String?,
      option_code: json['option_code'] as String?,
      option_id: (json['option_id'] as num?)?.toInt(),
      sort: (json['sort'] as num?)?.toInt(),
      text: json['text'] as String?,
      tid: (json['tid'] as num?)?.toInt(),
      value: json['value'] as String?,
      value2: json['value2'] as String?,
    );

Map<String, dynamic> _$AliyunOssConfigBeanToJson(
        AliyunOssConfigBean instance) =>
    <String, dynamic>{
      'create_time': instance.create_time,
      'doubleValue': instance.doubleValue,
      'intValue': instance.intValue,
      'modify_time': instance.modify_time,
      'oper_code': instance.oper_code,
      'option_code': instance.option_code,
      'option_id': instance.option_id,
      'sort': instance.sort,
      'text': instance.text,
      'tid': instance.tid,
      'value': instance.value,
      'value2': instance.value2,
    };

AliyunOssSecretBean _$AliyunOssSecretBeanFromJson(Map<String, dynamic> json) =>
    AliyunOssSecretBean(
      accessKeyId: json['accessKeyId'] as String?,
      accessKeySecret: json['accessKeySecret'] as String?,
      tokenSecret: json['tokenSecret'] as String?,
    );

Map<String, dynamic> _$AliyunOssSecretBeanToJson(
        AliyunOssSecretBean instance) =>
    <String, dynamic>{
      'accessKeyId': instance.accessKeyId,
      'accessKeySecret': instance.accessKeySecret,
      'tokenSecret': instance.tokenSecret,
    };
