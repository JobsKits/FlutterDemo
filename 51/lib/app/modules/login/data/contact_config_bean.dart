// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'contact_config_bean.g.dart';

Map<String, dynamic> parseJson(String? msg) {
  if (msg == null || msg.isEmpty) {
    return {};
  }

  try {
    return json.decode(msg);
  } catch (e) {
    // 处理解析错误，可以记录日志或返回一个默认值
    print('解析 JSON 时出错: $e');
    return {};
  }
}

/// 租户注册联系人配置
@JsonSerializable()
class ContactConfigBean {
  ContactConfigBean({
    this.all,
    this.clusters_id,
    this.domain_tenant_id,
    this.is_promote,
    this.liveSys,
    this.moncount,
    this.proxy,
    this.state,
    this.tid,
    this.todaycount,
    this.weight,
    this.zcmoncount,
    this.zctodaycount,
    this.zczrcount,
    this.zrcount,
  });

  num? all;
  num? clusters_id;
  num? domain_tenant_id;
  num? is_promote;
  bool? liveSys;
  num? moncount;
  num? proxy;
  num? state;
  num? tid;
  num? todaycount;
  num? weight;
  num? zcmoncount;
  num? zctodaycount;
  num? zczrcount;
  num? zrcount;
  SysLoginOptionsBean? sysLoginOptions;
  SysRegisterOptionsBean? sysOptions;

  factory ContactConfigBean.fromJson(Map<String, dynamic> json) =>
      _$ContactConfigBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ContactConfigBeanToJson(this);
}

@JsonSerializable()
class SysLoginOptionsBean {
  SysLoginOptionsBean({
    this.YIDUN_CAPTCHA_ID,
    this.CUST_LOGIN_CAPTCHA_MODE,
    this.CUST_LOGIN_SPECIAL_CAPTCHA,
  });
  Map<String, String>? YIDUN_CAPTCHA_ID;
  CustLoginCaptchaMode? CUST_LOGIN_CAPTCHA_MODE;
  CustLoginMode? CUST_LOGIN_MODE;
  Map<String, String>? SMS_OPEN_COUNTRY;
  String? CUST_LOGIN_SPECIAL_CAPTCHA;

  factory SysLoginOptionsBean.fromJson(Map<String, dynamic> json) {
    json['YIDUN_CAPTCHA_ID'] = parseJson(json['YIDUN_CAPTCHA_ID']);
    json['CUST_LOGIN_CAPTCHA_MODE'] =
        parseJson(json['CUST_LOGIN_CAPTCHA_MODE']);
    json['CUST_LOGIN_MODE'] = parseJson(json['CUST_LOGIN_MODE']);
    json['SMS_OPEN_COUNTRY'] = parseJson(json['SMS_OPEN_COUNTRY']);
    return _$SysLoginOptionsBeanFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SysLoginOptionsBeanToJson(this);
}

@JsonSerializable()
class CustLoginCaptchaMode {
  CustLoginCaptchaMode({
    this.H2_M_PICTURE_CAPTCHA_MODE,
    this.H2_M_SMART_CAPTCHA_MODE,
    this.H2_PC_PICTURE_CAPTCHA_MODE,
    this.H2_PC_SMART_CAPTCHA_MODE,
    this.H_SPECIAL_1,
    this.H_SPECIAL_2,
    this.H_SPECIAL_3,
    this.H_SPECIAL_4,
    this.H_SPECIAL_5,
    this.H_SPECIAL_SWITCH,
    this.PICTURE_SWITCH,
    this.SMART_SWITCH,
    this.W2_M_PICTURE_CAPTCHA_MODE,
    this.W2_M_SMART_CAPTCHA_MODE,
    this.W2_PC_PICTURE_CAPTCHA_MODE,
    this.W2_PC_SMART_CAPTCHA_MODE,
    this.W_SPECIAL_1,
    this.W_SPECIAL_2,
    this.W_SPECIAL_3,
    this.W_SPECIAL_4,
    this.W_SPECIAL_5,
    this.W_SPECIAL_SWITCH,
    this.Z2_M_PICTURE_CAPTCHA_MODE,
    this.Z2_M_SMART_CAPTCHA_MODE,
    this.Z2_PC_PICTURE_CAPTCHA_MODE,
    this.Z2_PC_SMART_CAPTCHA_MODE,
    this.Z_SPECIAL_1,
    this.Z_SPECIAL_2,
    this.Z_SPECIAL_3,
    this.Z_SPECIAL_4,
    this.Z_SPECIAL_5,
    this.Z_SPECIAL_SWITCH,
    this.m_qp_account,
    this.m_qp_auto,
    this.m_qp_email_captcha,
    this.m_qp_email_pwd_captcha,
    this.m_qp_phone_captcha,
    this.m_w_account,
    this.m_w_auto,
    this.m_w_email_captcha,
    this.m_w_email_pwd_captcha,
    this.m_w_phone_captcha,
    this.m_z_account,
    this.m_z_auto,
    this.m_z_email_captcha,
    this.m_z_email_pwd_captcha,
    this.m_z_phone_captcha,
    this.pc_qp_account,
    this.pc_qp_auto,
    this.pc_qp_email_captcha,
    this.pc_qp_email_pwd_captcha,
    this.pc_qp_phone_captcha,
    this.pc_qp_transaction_password,
    this.pc_w_account,
    this.pc_w_auto,
    this.pc_w_email_captcha,
    this.pc_w_email_pwd_captcha,
  });

  String? H2_M_PICTURE_CAPTCHA_MODE;
  String? H2_M_SMART_CAPTCHA_MODE;
  String? H2_PC_PICTURE_CAPTCHA_MODE;
  String? H2_PC_SMART_CAPTCHA_MODE;
  dynamic H_SPECIAL_1;
  dynamic H_SPECIAL_2;
  dynamic H_SPECIAL_3;
  dynamic H_SPECIAL_4;
  dynamic H_SPECIAL_5;
  String? H_SPECIAL_SWITCH;
  String? PICTURE_SWITCH;
  String? SMART_SWITCH;
  String? W2_M_PICTURE_CAPTCHA_MODE;
  String? W2_M_SMART_CAPTCHA_MODE;
  String? W2_PC_PICTURE_CAPTCHA_MODE;
  String? W2_PC_SMART_CAPTCHA_MODE;
  dynamic W_SPECIAL_1;
  dynamic W_SPECIAL_2;
  dynamic W_SPECIAL_3;
  dynamic W_SPECIAL_4;
  dynamic W_SPECIAL_5;
  String? W_SPECIAL_SWITCH;
  String? Z2_M_PICTURE_CAPTCHA_MODE;
  String? Z2_M_SMART_CAPTCHA_MODE;
  String? Z2_PC_PICTURE_CAPTCHA_MODE;
  String? Z2_PC_SMART_CAPTCHA_MODE;
  dynamic Z_SPECIAL_1;
  dynamic Z_SPECIAL_2;
  dynamic Z_SPECIAL_3;
  dynamic Z_SPECIAL_4;
  dynamic Z_SPECIAL_5;
  String? Z_SPECIAL_SWITCH;
  String? m_qp_account;
  String? m_qp_auto;
  String? m_qp_email_captcha;
  String? m_qp_email_pwd_captcha;
  String? m_qp_phone_captcha;
  String? m_w_account;
  String? m_w_auto;
  String? m_w_email_captcha;
  String? m_w_email_pwd_captcha;
  String? m_w_phone_captcha;
  String? m_z_account;
  String? m_z_auto;
  String? m_z_email_captcha;
  String? m_z_email_pwd_captcha;
  String? m_z_phone_captcha;
  String? pc_qp_account;
  String? pc_qp_auto;
  String? pc_qp_email_captcha;
  String? pc_qp_email_pwd_captcha;
  String? pc_qp_phone_captcha;
  String? pc_qp_transaction_password;
  String? pc_w_account;
  String? pc_w_auto;
  String? pc_w_email_captcha;
  String? pc_w_email_pwd_captcha;

  factory CustLoginCaptchaMode.fromJson(Map<String, dynamic> json) =>
      _$CustLoginCaptchaModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustLoginCaptchaModeToJson(this);
}

@JsonSerializable()
class CustLoginMode {
  CustLoginMode({
    this.account,
    this.email_captcha,
    this.email_expire,
    this.email_pwd_captcha,
    this.phone_captcha,
    this.phone_pwd_captcha,
  });

  String? account;
  String? email_captcha;
  num? email_expire;
  String? email_pwd_captcha;
  String? phone_captcha;
  String? phone_pwd_captcha;

  factory CustLoginMode.fromJson(Map<String, dynamic> json) =>
      _$CustLoginModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustLoginModeToJson(this);
}

@JsonSerializable()
class SysRegisterOptionsBean {
  SysRegisterOptionsBean({
    this.CUST_CONTACT_LIST,
    this.CUST_REGISTER_CAPTCHA_MODE,
    this.CUST_REGISTER_MODE,
    this.YIDUN_CAPTCHA_ID,
  });

  String? CUST_CONTACT_LIST;
  CustRegisterCaptachaMode? CUST_REGISTER_CAPTCHA_MODE;
  CustRegisterMode? CUST_REGISTER_MODE;
  CustRegisterPasswordMode? CUST_REGISTER_PASSWORD_MODE;
  Map<String, String>? SMS_OPEN_COUNTRY;
  Map<String, String>? YIDUN_CAPTCHA_ID;

  factory SysRegisterOptionsBean.fromJson(Map<String, dynamic> json) {
    json['CUST_REGISTER_CAPTCHA_MODE'] =
        parseJson(json['CUST_REGISTER_CAPTCHA_MODE']);
    json['CUST_REGISTER_MODE'] = parseJson(json['CUST_REGISTER_MODE']);
    json['CUST_REGISTER_PASSWORD_MODE'] =
        parseJson(json['CUST_REGISTER_PASSWORD_MODE']);
    json['SMS_OPEN_COUNTRY'] = parseJson(json['SMS_OPEN_COUNTRY']);
    json['YIDUN_CAPTCHA_ID'] = parseJson(json['YIDUN_CAPTCHA_ID']);
    return _$SysRegisterOptionsBeanFromJson(json);
  }

  Map<String, dynamic> toJson() => _$SysRegisterOptionsBeanToJson(this);
}

@JsonSerializable()
class CustRegisterCaptachaMode {
  CustRegisterCaptachaMode({
    this.H2_M_PICTURE_CAPTCHA_MODE,
    this.H2_M_SMART_CAPTCHA_MODE,
    this.H2_PC_PICTURE_CAPTCHA_MODE,
    this.H2_PC_SMART_CAPTCHA_MODE,
    this.PICTURE_SWITCH,
    this.SMART_SWITCH,
    this.W2_M_PICTURE_CAPTCHA_MODE,
    this.W2_M_SMART_CAPTCHA_MODE,
    this.W2_PC_PICTURE_CAPTCHA_MODE,
    this.W2_PC_SMART_CAPTCHA_MODE,
    this.Z2_M_PICTURE_CAPTCHA_MODE,
    this.Z2_M_SMART_CAPTCHA_MODE,
    this.Z2_PC_PICTURE_CAPTCHA_MODE,
    this.Z2_PC_SMART_CAPTCHA_MODE,
    this.m_qp_account,
    this.m_qp_email_captcha,
    this.m_qp_phone_captcha,
    this.m_qp_transaction_password,
    this.m_w_account,
    this.m_w_email_captcha,
    this.m_w_phone_captcha,
    this.m_w_transaction_password,
    this.m_z_account,
    this.m_z_email_captcha,
    this.m_z_phone_captcha,
    this.m_z_transaction_password,
    this.pc_qp_account,
    this.pc_qp_email_captcha,
    this.pc_qp_phone_captcha,
    this.pc_qp_transaction_password,
    this.pc_w_account,
    this.pc_w_email_captcha,
    this.pc_w_phone_captcha,
    this.pc_w_transaction_password,
    this.pc_z_account,
    this.pc_z_email_captcha,
    this.pc_z_phone_captcha,
    this.pc_z_transaction_password,
  });

  String? H2_M_PICTURE_CAPTCHA_MODE;
  String? H2_M_SMART_CAPTCHA_MODE;
  String? H2_PC_PICTURE_CAPTCHA_MODE;
  String? H2_PC_SMART_CAPTCHA_MODE;
  String? PICTURE_SWITCH;
  String? SMART_SWITCH;
  String? W2_M_PICTURE_CAPTCHA_MODE;
  String? W2_M_SMART_CAPTCHA_MODE;
  String? W2_PC_PICTURE_CAPTCHA_MODE;
  String? W2_PC_SMART_CAPTCHA_MODE;
  String? Z2_M_PICTURE_CAPTCHA_MODE;
  String? Z2_M_SMART_CAPTCHA_MODE;
  String? Z2_PC_PICTURE_CAPTCHA_MODE;
  String? Z2_PC_SMART_CAPTCHA_MODE;
  String? m_qp_account;
  String? m_qp_email_captcha;
  String? m_qp_phone_captcha;
  String? m_qp_transaction_password;
  String? m_w_account;
  String? m_w_email_captcha;
  String? m_w_phone_captcha;
  String? m_w_transaction_password;
  String? m_z_account;
  String? m_z_email_captcha;
  String? m_z_phone_captcha;
  String? m_z_transaction_password;
  String? pc_qp_account;
  String? pc_qp_email_captcha;
  String? pc_qp_phone_captcha;
  String? pc_qp_transaction_password;
  String? pc_w_account;
  String? pc_w_email_captcha;
  String? pc_w_phone_captcha;
  String? pc_w_transaction_password;
  String? pc_z_account;
  String? pc_z_email_captcha;
  String? pc_z_phone_captcha;
  String? pc_z_transaction_password;

  factory CustRegisterCaptachaMode.fromJson(Map<String, dynamic> json) =>
      _$CustRegisterCaptachaModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustRegisterCaptachaModeToJson(this);
}

@JsonSerializable()
class CustRegisterMode {
  CustRegisterMode({
    this.account,
    this.email_captcha,
    this.phone_captcha,
    this.transaction_password,
    this.phone_pwd_captcha,
  });

  String? account;
  String? email_captcha;
  String? phone_captcha;
  String? transaction_password;
  String? phone_pwd_captcha;

  factory CustRegisterMode.fromJson(Map<String, dynamic> json) =>
      _$CustRegisterModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustRegisterModeToJson(this);
}

@JsonSerializable()
class CustRegisterPasswordMode {
  CustRegisterPasswordMode({
    this.PASSWORD_MODE,
  });

  String? PASSWORD_MODE;

  factory CustRegisterPasswordMode.fromJson(Map<String, dynamic> json) =>
      _$CustRegisterPasswordModeFromJson(json);

  Map<String, dynamic> toJson() => _$CustRegisterPasswordModeToJson(this);
}
