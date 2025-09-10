// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'upload_image_bean.g.dart';

///首页游戏信息的主体类，banner、公告、游戏都在里面

/// 上传线路
@JsonSerializable()
class UploadImageUrlBean {
  UploadImageUrlBean({
    this.token,
    this.url,
  });

  String? token;
  List<UploadImageUrlItem>? url;

  factory UploadImageUrlBean.fromJson(Map<String, dynamic> json) =>
      _$UploadImageUrlBeanFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageUrlBeanToJson(this);
}

@JsonSerializable()
class UploadImageUrlItem {
  UploadImageUrlItem({
    this.callback_addr,
    this.chan_code,
    this.clusters_id,
    this.create_time,
    this.domain_addr,
    this.domain_ip,
    this.domain_line_id,
    this.domain_type,
    this.oper_code,
    this.spare_addr,
    this.state,
    this.state_time,
    this.tid,
    this.weight,
  });

  String? callback_addr;
  String? chan_code;
  int? clusters_id;
  num? create_time;
  String? domain_addr;
  String? domain_ip;
  num? domain_line_id;
  int? domain_type;
  String? oper_code;
  String? spare_addr;
  int? state;
  num? state_time;
  int? tid;
  int? weight;

  factory UploadImageUrlItem.fromJson(Map<String, dynamic> json) =>
      _$UploadImageUrlItemFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageUrlItemToJson(this);
}

/// 上传线路
@JsonSerializable()
class AliyunOssConfigBean {
  AliyunOssConfigBean({
    this.create_time,
    this.doubleValue,
    this.intValue,
    this.modify_time,
    this.oper_code,
    this.option_code,
    this.option_id,
    this.sort,
    this.text,
    this.tid,
    this.value,
    this.value2,
  });

  num? create_time;
  num? doubleValue;
  num? intValue;
  num? modify_time;
  String? oper_code;
  String? option_code;
  int? option_id;
  int? sort;
  String? text;
  int? tid;
  String? value;
  String? value2;

  factory AliyunOssConfigBean.fromJson(Map<String, dynamic> json) =>
      _$AliyunOssConfigBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AliyunOssConfigBeanToJson(this);
}

/// 获取oss凭证
@JsonSerializable()
class AliyunOssSecretBean {
  AliyunOssSecretBean({
    this.accessKeyId,
    this.accessKeySecret,
    this.tokenSecret,
  });

  String? accessKeyId;
  String? accessKeySecret;
  String? tokenSecret;

  factory AliyunOssSecretBean.fromJson(Map<String, dynamic> json) =>
      _$AliyunOssSecretBeanFromJson(json);

  Map<String, dynamic> toJson() => _$AliyunOssSecretBeanToJson(this);
}
