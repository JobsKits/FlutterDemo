class UserInfoBean2 {
  UserInfoBean2({
    this.custId,
    this.custCode,
    this.contactName,
    this.gender,
    this.contactAddr,
    this.mobileCountry,
    this.mobilePhone,
    this.email,
    this.qq,
    this.weixin,
    this.createTime,
    this.state,
    this.stateTime,
    this.tid,
    this.zalo,
    this.facebook,
    this.whatsApp,
    this.line,
    this.rzState,
    this.rz2State,
    this.telegram,
    this.certificationLevel,
    this.googleSecret,
  });

  UserInfoBean2.fromJson(dynamic json) {
    custId = json['cust_id'];
    custCode = json['cust_code'];
    contactName = json['contact_name'];
    gender = json['gender'];
    contactAddr = json['contact_addr'];
    mobileCountry = json['mobile_country'];
    mobilePhone = json['mobile_phone'];
    email = json['email'];
    qq = json['qq'];
    weixin = json['weixin'];
    createTime = json['create_time'];
    state = json['state'];
    stateTime = json['state_time'];
    tid = json['tid'];
    zalo = json['zalo'];
    facebook = json['facebook'];
    whatsApp = json['whatsApp'];
    line = json['line'];
    rzState = json['rz_state'];
    rz2State = json['rz2_state'];
    telegram = json['telegram'];
    certificationLevel = json['certification_level'];
    googleSecret = json['google_secret'];
    birthday = json['birthday'];
    birthday_set = json['birthday_set'];
  }
  num? custId;
  String? custCode;
  String? contactName;
  int? gender;
  String? contactAddr;
  String? mobileCountry;
  String? mobilePhone;
  String? email;
  String? birthday;
  String? birthday_set;
  String? qq;
  String? weixin;
  num? createTime;
  num? state;
  num? stateTime;
  num? tid;
  String? zalo;
  String? facebook;
  String? whatsApp;
  String? line;
  num? rzState;
  num? rz2State;
  String? telegram;
  num? certificationLevel;
  String? googleSecret;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_id'] = custId;
    map['cust_code'] = custCode;
    map['contact_name'] = contactName;
    map['gender'] = gender;
    map['contact_addr'] = contactAddr;
    map['mobile_country'] = mobileCountry;
    map['mobile_phone'] = mobilePhone;
    map['email'] = email;
    map['qq'] = qq;
    map['weixin'] = weixin;
    map['create_time'] = createTime;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['tid'] = tid;
    map['zalo'] = zalo;
    map['facebook'] = facebook;
    map['whatsApp'] = whatsApp;
    map['line'] = line;
    map['rz_state'] = rzState;
    map['rz2_state'] = rz2State;
    map['telegram'] = telegram;
    map['certification_level'] = certificationLevel;
    map['google_secret'] = googleSecret;
    map['birthday_set'] = birthday_set;
    map['birthday'] = birthday;
    return map;
  }
}
