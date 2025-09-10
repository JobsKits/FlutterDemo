// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_config_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactConfigBean _$ContactConfigBeanFromJson(Map<String, dynamic> json) =>
    ContactConfigBean(
      all: json['all'] as num?,
      clusters_id: json['clusters_id'] as num?,
      domain_tenant_id: json['domain_tenant_id'] as num?,
      is_promote: json['is_promote'] as num?,
      liveSys: json['liveSys'] as bool?,
      moncount: json['moncount'] as num?,
      proxy: json['proxy'] as num?,
      state: json['state'] as num?,
      tid: json['tid'] as num?,
      todaycount: json['todaycount'] as num?,
      weight: json['weight'] as num?,
      zcmoncount: json['zcmoncount'] as num?,
      zctodaycount: json['zctodaycount'] as num?,
      zczrcount: json['zczrcount'] as num?,
      zrcount: json['zrcount'] as num?,
    )
      ..sysLoginOptions = json['sysLoginOptions'] == null
          ? null
          : SysLoginOptionsBean.fromJson(
              json['sysLoginOptions'] as Map<String, dynamic>)
      ..sysOptions = json['sysOptions'] == null
          ? null
          : SysRegisterOptionsBean.fromJson(
              json['sysOptions'] as Map<String, dynamic>);

Map<String, dynamic> _$ContactConfigBeanToJson(ContactConfigBean instance) =>
    <String, dynamic>{
      'all': instance.all,
      'clusters_id': instance.clusters_id,
      'domain_tenant_id': instance.domain_tenant_id,
      'is_promote': instance.is_promote,
      'liveSys': instance.liveSys,
      'moncount': instance.moncount,
      'proxy': instance.proxy,
      'state': instance.state,
      'tid': instance.tid,
      'todaycount': instance.todaycount,
      'weight': instance.weight,
      'zcmoncount': instance.zcmoncount,
      'zctodaycount': instance.zctodaycount,
      'zczrcount': instance.zczrcount,
      'zrcount': instance.zrcount,
      'sysLoginOptions': instance.sysLoginOptions,
      'sysOptions': instance.sysOptions,
    };

SysLoginOptionsBean _$SysLoginOptionsBeanFromJson(Map<String, dynamic> json) =>
    SysLoginOptionsBean(
      YIDUN_CAPTCHA_ID:
          (json['YIDUN_CAPTCHA_ID'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      CUST_LOGIN_CAPTCHA_MODE: json['CUST_LOGIN_CAPTCHA_MODE'] == null
          ? null
          : CustLoginCaptchaMode.fromJson(
              json['CUST_LOGIN_CAPTCHA_MODE'] as Map<String, dynamic>),
      CUST_LOGIN_SPECIAL_CAPTCHA: json['CUST_LOGIN_SPECIAL_CAPTCHA'] as String?,
    )
      ..CUST_LOGIN_MODE = json['CUST_LOGIN_MODE'] == null
          ? null
          : CustLoginMode.fromJson(
              json['CUST_LOGIN_MODE'] as Map<String, dynamic>)
      ..SMS_OPEN_COUNTRY =
          (json['SMS_OPEN_COUNTRY'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$SysLoginOptionsBeanToJson(
        SysLoginOptionsBean instance) =>
    <String, dynamic>{
      'YIDUN_CAPTCHA_ID': instance.YIDUN_CAPTCHA_ID,
      'CUST_LOGIN_CAPTCHA_MODE': instance.CUST_LOGIN_CAPTCHA_MODE,
      'CUST_LOGIN_MODE': instance.CUST_LOGIN_MODE,
      'SMS_OPEN_COUNTRY': instance.SMS_OPEN_COUNTRY,
      'CUST_LOGIN_SPECIAL_CAPTCHA': instance.CUST_LOGIN_SPECIAL_CAPTCHA,
    };

CustLoginCaptchaMode _$CustLoginCaptchaModeFromJson(
        Map<String, dynamic> json) =>
    CustLoginCaptchaMode(
      H2_M_PICTURE_CAPTCHA_MODE: json['H2_M_PICTURE_CAPTCHA_MODE'] as String?,
      H2_M_SMART_CAPTCHA_MODE: json['H2_M_SMART_CAPTCHA_MODE'] as String?,
      H2_PC_PICTURE_CAPTCHA_MODE: json['H2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      H2_PC_SMART_CAPTCHA_MODE: json['H2_PC_SMART_CAPTCHA_MODE'] as String?,
      H_SPECIAL_1: json['H_SPECIAL_1'],
      H_SPECIAL_2: json['H_SPECIAL_2'],
      H_SPECIAL_3: json['H_SPECIAL_3'],
      H_SPECIAL_4: json['H_SPECIAL_4'],
      H_SPECIAL_5: json['H_SPECIAL_5'],
      H_SPECIAL_SWITCH: json['H_SPECIAL_SWITCH'] as String?,
      PICTURE_SWITCH: json['PICTURE_SWITCH'] as String?,
      SMART_SWITCH: json['SMART_SWITCH'] as String?,
      W2_M_PICTURE_CAPTCHA_MODE: json['W2_M_PICTURE_CAPTCHA_MODE'] as String?,
      W2_M_SMART_CAPTCHA_MODE: json['W2_M_SMART_CAPTCHA_MODE'] as String?,
      W2_PC_PICTURE_CAPTCHA_MODE: json['W2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      W2_PC_SMART_CAPTCHA_MODE: json['W2_PC_SMART_CAPTCHA_MODE'] as String?,
      W_SPECIAL_1: json['W_SPECIAL_1'],
      W_SPECIAL_2: json['W_SPECIAL_2'],
      W_SPECIAL_3: json['W_SPECIAL_3'],
      W_SPECIAL_4: json['W_SPECIAL_4'],
      W_SPECIAL_5: json['W_SPECIAL_5'],
      W_SPECIAL_SWITCH: json['W_SPECIAL_SWITCH'] as String?,
      Z2_M_PICTURE_CAPTCHA_MODE: json['Z2_M_PICTURE_CAPTCHA_MODE'] as String?,
      Z2_M_SMART_CAPTCHA_MODE: json['Z2_M_SMART_CAPTCHA_MODE'] as String?,
      Z2_PC_PICTURE_CAPTCHA_MODE: json['Z2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      Z2_PC_SMART_CAPTCHA_MODE: json['Z2_PC_SMART_CAPTCHA_MODE'] as String?,
      Z_SPECIAL_1: json['Z_SPECIAL_1'],
      Z_SPECIAL_2: json['Z_SPECIAL_2'],
      Z_SPECIAL_3: json['Z_SPECIAL_3'],
      Z_SPECIAL_4: json['Z_SPECIAL_4'],
      Z_SPECIAL_5: json['Z_SPECIAL_5'],
      Z_SPECIAL_SWITCH: json['Z_SPECIAL_SWITCH'] as String?,
      m_qp_account: json['m_qp_account'] as String?,
      m_qp_auto: json['m_qp_auto'] as String?,
      m_qp_email_captcha: json['m_qp_email_captcha'] as String?,
      m_qp_email_pwd_captcha: json['m_qp_email_pwd_captcha'] as String?,
      m_qp_phone_captcha: json['m_qp_phone_captcha'] as String?,
      m_w_account: json['m_w_account'] as String?,
      m_w_auto: json['m_w_auto'] as String?,
      m_w_email_captcha: json['m_w_email_captcha'] as String?,
      m_w_email_pwd_captcha: json['m_w_email_pwd_captcha'] as String?,
      m_w_phone_captcha: json['m_w_phone_captcha'] as String?,
      m_z_account: json['m_z_account'] as String?,
      m_z_auto: json['m_z_auto'] as String?,
      m_z_email_captcha: json['m_z_email_captcha'] as String?,
      m_z_email_pwd_captcha: json['m_z_email_pwd_captcha'] as String?,
      m_z_phone_captcha: json['m_z_phone_captcha'] as String?,
      pc_qp_account: json['pc_qp_account'] as String?,
      pc_qp_auto: json['pc_qp_auto'] as String?,
      pc_qp_email_captcha: json['pc_qp_email_captcha'] as String?,
      pc_qp_email_pwd_captcha: json['pc_qp_email_pwd_captcha'] as String?,
      pc_qp_phone_captcha: json['pc_qp_phone_captcha'] as String?,
      pc_qp_transaction_password: json['pc_qp_transaction_password'] as String?,
      pc_w_account: json['pc_w_account'] as String?,
      pc_w_auto: json['pc_w_auto'] as String?,
      pc_w_email_captcha: json['pc_w_email_captcha'] as String?,
      pc_w_email_pwd_captcha: json['pc_w_email_pwd_captcha'] as String?,
    );

Map<String, dynamic> _$CustLoginCaptchaModeToJson(
        CustLoginCaptchaMode instance) =>
    <String, dynamic>{
      'H2_M_PICTURE_CAPTCHA_MODE': instance.H2_M_PICTURE_CAPTCHA_MODE,
      'H2_M_SMART_CAPTCHA_MODE': instance.H2_M_SMART_CAPTCHA_MODE,
      'H2_PC_PICTURE_CAPTCHA_MODE': instance.H2_PC_PICTURE_CAPTCHA_MODE,
      'H2_PC_SMART_CAPTCHA_MODE': instance.H2_PC_SMART_CAPTCHA_MODE,
      'H_SPECIAL_1': instance.H_SPECIAL_1,
      'H_SPECIAL_2': instance.H_SPECIAL_2,
      'H_SPECIAL_3': instance.H_SPECIAL_3,
      'H_SPECIAL_4': instance.H_SPECIAL_4,
      'H_SPECIAL_5': instance.H_SPECIAL_5,
      'H_SPECIAL_SWITCH': instance.H_SPECIAL_SWITCH,
      'PICTURE_SWITCH': instance.PICTURE_SWITCH,
      'SMART_SWITCH': instance.SMART_SWITCH,
      'W2_M_PICTURE_CAPTCHA_MODE': instance.W2_M_PICTURE_CAPTCHA_MODE,
      'W2_M_SMART_CAPTCHA_MODE': instance.W2_M_SMART_CAPTCHA_MODE,
      'W2_PC_PICTURE_CAPTCHA_MODE': instance.W2_PC_PICTURE_CAPTCHA_MODE,
      'W2_PC_SMART_CAPTCHA_MODE': instance.W2_PC_SMART_CAPTCHA_MODE,
      'W_SPECIAL_1': instance.W_SPECIAL_1,
      'W_SPECIAL_2': instance.W_SPECIAL_2,
      'W_SPECIAL_3': instance.W_SPECIAL_3,
      'W_SPECIAL_4': instance.W_SPECIAL_4,
      'W_SPECIAL_5': instance.W_SPECIAL_5,
      'W_SPECIAL_SWITCH': instance.W_SPECIAL_SWITCH,
      'Z2_M_PICTURE_CAPTCHA_MODE': instance.Z2_M_PICTURE_CAPTCHA_MODE,
      'Z2_M_SMART_CAPTCHA_MODE': instance.Z2_M_SMART_CAPTCHA_MODE,
      'Z2_PC_PICTURE_CAPTCHA_MODE': instance.Z2_PC_PICTURE_CAPTCHA_MODE,
      'Z2_PC_SMART_CAPTCHA_MODE': instance.Z2_PC_SMART_CAPTCHA_MODE,
      'Z_SPECIAL_1': instance.Z_SPECIAL_1,
      'Z_SPECIAL_2': instance.Z_SPECIAL_2,
      'Z_SPECIAL_3': instance.Z_SPECIAL_3,
      'Z_SPECIAL_4': instance.Z_SPECIAL_4,
      'Z_SPECIAL_5': instance.Z_SPECIAL_5,
      'Z_SPECIAL_SWITCH': instance.Z_SPECIAL_SWITCH,
      'm_qp_account': instance.m_qp_account,
      'm_qp_auto': instance.m_qp_auto,
      'm_qp_email_captcha': instance.m_qp_email_captcha,
      'm_qp_email_pwd_captcha': instance.m_qp_email_pwd_captcha,
      'm_qp_phone_captcha': instance.m_qp_phone_captcha,
      'm_w_account': instance.m_w_account,
      'm_w_auto': instance.m_w_auto,
      'm_w_email_captcha': instance.m_w_email_captcha,
      'm_w_email_pwd_captcha': instance.m_w_email_pwd_captcha,
      'm_w_phone_captcha': instance.m_w_phone_captcha,
      'm_z_account': instance.m_z_account,
      'm_z_auto': instance.m_z_auto,
      'm_z_email_captcha': instance.m_z_email_captcha,
      'm_z_email_pwd_captcha': instance.m_z_email_pwd_captcha,
      'm_z_phone_captcha': instance.m_z_phone_captcha,
      'pc_qp_account': instance.pc_qp_account,
      'pc_qp_auto': instance.pc_qp_auto,
      'pc_qp_email_captcha': instance.pc_qp_email_captcha,
      'pc_qp_email_pwd_captcha': instance.pc_qp_email_pwd_captcha,
      'pc_qp_phone_captcha': instance.pc_qp_phone_captcha,
      'pc_qp_transaction_password': instance.pc_qp_transaction_password,
      'pc_w_account': instance.pc_w_account,
      'pc_w_auto': instance.pc_w_auto,
      'pc_w_email_captcha': instance.pc_w_email_captcha,
      'pc_w_email_pwd_captcha': instance.pc_w_email_pwd_captcha,
    };

CustLoginMode _$CustLoginModeFromJson(Map<String, dynamic> json) =>
    CustLoginMode(
      account: json['account'] as String?,
      email_captcha: json['email_captcha'] as String?,
      email_expire: json['email_expire'] as num?,
      email_pwd_captcha: json['email_pwd_captcha'] as String?,
      phone_captcha: json['phone_captcha'] as String?,
      phone_pwd_captcha: json['phone_pwd_captcha'] as String?,
    );

Map<String, dynamic> _$CustLoginModeToJson(CustLoginMode instance) =>
    <String, dynamic>{
      'account': instance.account,
      'email_captcha': instance.email_captcha,
      'email_expire': instance.email_expire,
      'email_pwd_captcha': instance.email_pwd_captcha,
      'phone_captcha': instance.phone_captcha,
      'phone_pwd_captcha': instance.phone_pwd_captcha,
    };

SysRegisterOptionsBean _$SysRegisterOptionsBeanFromJson(
        Map<String, dynamic> json) =>
    SysRegisterOptionsBean(
      CUST_CONTACT_LIST: json['CUST_CONTACT_LIST'] as String?,
      CUST_REGISTER_CAPTCHA_MODE: json['CUST_REGISTER_CAPTCHA_MODE'] == null
          ? null
          : CustRegisterCaptachaMode.fromJson(
              json['CUST_REGISTER_CAPTCHA_MODE'] as Map<String, dynamic>),
      CUST_REGISTER_MODE: json['CUST_REGISTER_MODE'] == null
          ? null
          : CustRegisterMode.fromJson(
              json['CUST_REGISTER_MODE'] as Map<String, dynamic>),
      YIDUN_CAPTCHA_ID:
          (json['YIDUN_CAPTCHA_ID'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    )
      ..CUST_REGISTER_PASSWORD_MODE =
          json['CUST_REGISTER_PASSWORD_MODE'] == null
              ? null
              : CustRegisterPasswordMode.fromJson(
                  json['CUST_REGISTER_PASSWORD_MODE'] as Map<String, dynamic>)
      ..SMS_OPEN_COUNTRY =
          (json['SMS_OPEN_COUNTRY'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      );

Map<String, dynamic> _$SysRegisterOptionsBeanToJson(
        SysRegisterOptionsBean instance) =>
    <String, dynamic>{
      'CUST_CONTACT_LIST': instance.CUST_CONTACT_LIST,
      'CUST_REGISTER_CAPTCHA_MODE': instance.CUST_REGISTER_CAPTCHA_MODE,
      'CUST_REGISTER_MODE': instance.CUST_REGISTER_MODE,
      'CUST_REGISTER_PASSWORD_MODE': instance.CUST_REGISTER_PASSWORD_MODE,
      'SMS_OPEN_COUNTRY': instance.SMS_OPEN_COUNTRY,
      'YIDUN_CAPTCHA_ID': instance.YIDUN_CAPTCHA_ID,
    };

CustRegisterCaptachaMode _$CustRegisterCaptachaModeFromJson(
        Map<String, dynamic> json) =>
    CustRegisterCaptachaMode(
      H2_M_PICTURE_CAPTCHA_MODE: json['H2_M_PICTURE_CAPTCHA_MODE'] as String?,
      H2_M_SMART_CAPTCHA_MODE: json['H2_M_SMART_CAPTCHA_MODE'] as String?,
      H2_PC_PICTURE_CAPTCHA_MODE: json['H2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      H2_PC_SMART_CAPTCHA_MODE: json['H2_PC_SMART_CAPTCHA_MODE'] as String?,
      PICTURE_SWITCH: json['PICTURE_SWITCH'] as String?,
      SMART_SWITCH: json['SMART_SWITCH'] as String?,
      W2_M_PICTURE_CAPTCHA_MODE: json['W2_M_PICTURE_CAPTCHA_MODE'] as String?,
      W2_M_SMART_CAPTCHA_MODE: json['W2_M_SMART_CAPTCHA_MODE'] as String?,
      W2_PC_PICTURE_CAPTCHA_MODE: json['W2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      W2_PC_SMART_CAPTCHA_MODE: json['W2_PC_SMART_CAPTCHA_MODE'] as String?,
      Z2_M_PICTURE_CAPTCHA_MODE: json['Z2_M_PICTURE_CAPTCHA_MODE'] as String?,
      Z2_M_SMART_CAPTCHA_MODE: json['Z2_M_SMART_CAPTCHA_MODE'] as String?,
      Z2_PC_PICTURE_CAPTCHA_MODE: json['Z2_PC_PICTURE_CAPTCHA_MODE'] as String?,
      Z2_PC_SMART_CAPTCHA_MODE: json['Z2_PC_SMART_CAPTCHA_MODE'] as String?,
      m_qp_account: json['m_qp_account'] as String?,
      m_qp_email_captcha: json['m_qp_email_captcha'] as String?,
      m_qp_phone_captcha: json['m_qp_phone_captcha'] as String?,
      m_qp_transaction_password: json['m_qp_transaction_password'] as String?,
      m_w_account: json['m_w_account'] as String?,
      m_w_email_captcha: json['m_w_email_captcha'] as String?,
      m_w_phone_captcha: json['m_w_phone_captcha'] as String?,
      m_w_transaction_password: json['m_w_transaction_password'] as String?,
      m_z_account: json['m_z_account'] as String?,
      m_z_email_captcha: json['m_z_email_captcha'] as String?,
      m_z_phone_captcha: json['m_z_phone_captcha'] as String?,
      m_z_transaction_password: json['m_z_transaction_password'] as String?,
      pc_qp_account: json['pc_qp_account'] as String?,
      pc_qp_email_captcha: json['pc_qp_email_captcha'] as String?,
      pc_qp_phone_captcha: json['pc_qp_phone_captcha'] as String?,
      pc_qp_transaction_password: json['pc_qp_transaction_password'] as String?,
      pc_w_account: json['pc_w_account'] as String?,
      pc_w_email_captcha: json['pc_w_email_captcha'] as String?,
      pc_w_phone_captcha: json['pc_w_phone_captcha'] as String?,
      pc_w_transaction_password: json['pc_w_transaction_password'] as String?,
      pc_z_account: json['pc_z_account'] as String?,
      pc_z_email_captcha: json['pc_z_email_captcha'] as String?,
      pc_z_phone_captcha: json['pc_z_phone_captcha'] as String?,
      pc_z_transaction_password: json['pc_z_transaction_password'] as String?,
    );

Map<String, dynamic> _$CustRegisterCaptachaModeToJson(
        CustRegisterCaptachaMode instance) =>
    <String, dynamic>{
      'H2_M_PICTURE_CAPTCHA_MODE': instance.H2_M_PICTURE_CAPTCHA_MODE,
      'H2_M_SMART_CAPTCHA_MODE': instance.H2_M_SMART_CAPTCHA_MODE,
      'H2_PC_PICTURE_CAPTCHA_MODE': instance.H2_PC_PICTURE_CAPTCHA_MODE,
      'H2_PC_SMART_CAPTCHA_MODE': instance.H2_PC_SMART_CAPTCHA_MODE,
      'PICTURE_SWITCH': instance.PICTURE_SWITCH,
      'SMART_SWITCH': instance.SMART_SWITCH,
      'W2_M_PICTURE_CAPTCHA_MODE': instance.W2_M_PICTURE_CAPTCHA_MODE,
      'W2_M_SMART_CAPTCHA_MODE': instance.W2_M_SMART_CAPTCHA_MODE,
      'W2_PC_PICTURE_CAPTCHA_MODE': instance.W2_PC_PICTURE_CAPTCHA_MODE,
      'W2_PC_SMART_CAPTCHA_MODE': instance.W2_PC_SMART_CAPTCHA_MODE,
      'Z2_M_PICTURE_CAPTCHA_MODE': instance.Z2_M_PICTURE_CAPTCHA_MODE,
      'Z2_M_SMART_CAPTCHA_MODE': instance.Z2_M_SMART_CAPTCHA_MODE,
      'Z2_PC_PICTURE_CAPTCHA_MODE': instance.Z2_PC_PICTURE_CAPTCHA_MODE,
      'Z2_PC_SMART_CAPTCHA_MODE': instance.Z2_PC_SMART_CAPTCHA_MODE,
      'm_qp_account': instance.m_qp_account,
      'm_qp_email_captcha': instance.m_qp_email_captcha,
      'm_qp_phone_captcha': instance.m_qp_phone_captcha,
      'm_qp_transaction_password': instance.m_qp_transaction_password,
      'm_w_account': instance.m_w_account,
      'm_w_email_captcha': instance.m_w_email_captcha,
      'm_w_phone_captcha': instance.m_w_phone_captcha,
      'm_w_transaction_password': instance.m_w_transaction_password,
      'm_z_account': instance.m_z_account,
      'm_z_email_captcha': instance.m_z_email_captcha,
      'm_z_phone_captcha': instance.m_z_phone_captcha,
      'm_z_transaction_password': instance.m_z_transaction_password,
      'pc_qp_account': instance.pc_qp_account,
      'pc_qp_email_captcha': instance.pc_qp_email_captcha,
      'pc_qp_phone_captcha': instance.pc_qp_phone_captcha,
      'pc_qp_transaction_password': instance.pc_qp_transaction_password,
      'pc_w_account': instance.pc_w_account,
      'pc_w_email_captcha': instance.pc_w_email_captcha,
      'pc_w_phone_captcha': instance.pc_w_phone_captcha,
      'pc_w_transaction_password': instance.pc_w_transaction_password,
      'pc_z_account': instance.pc_z_account,
      'pc_z_email_captcha': instance.pc_z_email_captcha,
      'pc_z_phone_captcha': instance.pc_z_phone_captcha,
      'pc_z_transaction_password': instance.pc_z_transaction_password,
    };

CustRegisterMode _$CustRegisterModeFromJson(Map<String, dynamic> json) =>
    CustRegisterMode(
      account: json['account'] as String?,
      email_captcha: json['email_captcha'] as String?,
      phone_captcha: json['phone_captcha'] as String?,
      transaction_password: json['transaction_password'] as String?,
      phone_pwd_captcha: json['phone_pwd_captcha'] as String?,
    );

Map<String, dynamic> _$CustRegisterModeToJson(CustRegisterMode instance) =>
    <String, dynamic>{
      'account': instance.account,
      'email_captcha': instance.email_captcha,
      'phone_captcha': instance.phone_captcha,
      'transaction_password': instance.transaction_password,
      'phone_pwd_captcha': instance.phone_pwd_captcha,
    };

CustRegisterPasswordMode _$CustRegisterPasswordModeFromJson(
        Map<String, dynamic> json) =>
    CustRegisterPasswordMode(
      PASSWORD_MODE: json['PASSWORD_MODE'] as String?,
    );

Map<String, dynamic> _$CustRegisterPasswordModeToJson(
        CustRegisterPasswordMode instance) =>
    <String, dynamic>{
      'PASSWORD_MODE': instance.PASSWORD_MODE,
    };
