class RegisterBean {
  RegisterBean({
    this.custId,
    this.custCode,
    this.custName,
    this.nickname,
    this.head,
    this.custType,
    this.custGrade,
    this.custLevel,
    this.vipFlag,
    this.vipCard,
    this.chanCode,
    this.admCode,
    this.uid,
    this.password1st,
    this.inviteCode,
    this.promoteCode,
    this.inTime,
    this.createTime,
    this.state,
    this.stateTime,
    this.fictFlag,
    this.acctId,
    this.acctStateTime,
    this.acctState,
    this.tid,
    this.pwdAcctPwd,
    this.rebate,
    this.rebateFt,
    this.rebateSc,
    this.rebateK3,
    this.rebate115,
    this.rebateZr,
    this.rebateDz,
    this.rebateTy,
    this.rebateQp,
    this.rebateMs,
    this.rebateBy,
    this.rebateTcl,
    this.partnerFlag,
    this.custTag,
    this.scope,
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.isShow,
    this.isService,
    this.liveLeve,
    this.is3rd,
    this.isBet,
    this.isYuan,
    this.rzOtc,
    this.custContact,
    this.roomNickname,
    this.custAccountType,
    this.isNewRegister,
    this.walletStatus,
  });

  RegisterBean.fromJson(dynamic json) {
    custId = json['cust_id'];
    custCode = json['cust_code'];
    custName = json['cust_name'];
    nickname = json['nickname'];
    head = json['head'];
    custType = json['cust_type'];
    custGrade = json['cust_grade'];
    custLevel = json['cust_level'];
    vipFlag = json['vip_flag'];
    vipCard = json['vip_card'];
    chanCode = json['chan_code'];
    admCode = json['adm_code'];
    uid = json['uid'];
    password1st = json['password1st'];
    inviteCode = json['invite_code'];
    promoteCode = json['promote_code'];
    inTime = json['in_time'];
    createTime = json['create_time'];
    state = json['state'];
    stateTime = json['state_time'];
    fictFlag = json['fict_flag'];
    acctId = json['acct_id'];
    acctStateTime = json['acct_state_time'];
    acctState = json['acct_state'];
    tid = json['tid'];
    pwdAcctPwd = json['pwd_acct_pwd'];
    rebate = json['rebate'];
    rebateFt = json['rebate_ft'];
    rebateSc = json['rebate_sc'];
    rebateK3 = json['rebate_k3'];
    rebate115 = json['rebate_115'];
    rebateZr = json['rebate_zr'];
    rebateDz = json['rebate_dz'];
    rebateTy = json['rebate_ty'];
    rebateQp = json['rebate_qp'];
    rebateMs = json['rebate_ms'];
    rebateBy = json['rebate_by'];
    rebateTcl = json['rebate_tcl'];
    partnerFlag = json['partner_flag'];
    custTag = json['cust_tag'];
    scope = json['scope'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    isShow = json['is_show'];
    isService = json['isService'];
    liveLeve = json['live_leve'];
    is3rd = json['is_3rd'];
    isBet = json['is_bet'];
    isYuan = json['is_yuan'];
    rzOtc = json['rz_otc'];
    custContact = json['custContact'] != null
        ? CustContact.fromJson(json['custContact'])
        : null;
    roomNickname = json['room_nickname'];
    custAccountType = json['cust_account_type'];
    isNewRegister = json['is_new_register'];
    walletStatus = json['wallet_status'];
  }
  num? custId;
  String? custCode;
  String? custName;
  String? nickname;
  String? head;
  num? custType;
  num? custGrade;
  num? custLevel;
  num? vipFlag;
  num? vipCard;
  String? chanCode;
  String? admCode;
  num? uid;
  String? password1st;
  String? inviteCode;
  String? promoteCode;
  num? inTime;
  num? createTime;
  num? state;
  num? stateTime;
  num? fictFlag;
  num? acctId;
  num? acctStateTime;
  num? acctState;
  num? tid;
  num? pwdAcctPwd;
  num? rebate;
  num? rebateFt;
  num? rebateSc;
  num? rebateK3;
  num? rebate115;
  num? rebateZr;
  num? rebateDz;
  num? rebateTy;
  num? rebateQp;
  num? rebateMs;
  num? rebateBy;
  num? rebateTcl;
  num? partnerFlag;
  num? custTag;
  String? scope;
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  num? expiresIn;
  num? isShow;
  num? isService;
  num? liveLeve;
  num? is3rd;
  num? isBet;
  String? isYuan;
  num? rzOtc;
  CustContact? custContact;
  String? roomNickname;
  num? custAccountType;
  num? isNewRegister;
  num? walletStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_id'] = custId;
    map['cust_code'] = custCode;
    map['cust_name'] = custName;
    map['nickname'] = nickname;
    map['head'] = head;
    map['cust_type'] = custType;
    map['cust_grade'] = custGrade;
    map['cust_level'] = custLevel;
    map['vip_flag'] = vipFlag;
    map['vip_card'] = vipCard;
    map['chan_code'] = chanCode;
    map['adm_code'] = admCode;
    map['uid'] = uid;
    map['password1st'] = password1st;
    map['invite_code'] = inviteCode;
    map['promote_code'] = promoteCode;
    map['in_time'] = inTime;
    map['create_time'] = createTime;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['fict_flag'] = fictFlag;
    map['acct_id'] = acctId;
    map['acct_state_time'] = acctStateTime;
    map['acct_state'] = acctState;
    map['tid'] = tid;
    map['pwd_acct_pwd'] = pwdAcctPwd;
    map['rebate'] = rebate;
    map['rebate_ft'] = rebateFt;
    map['rebate_sc'] = rebateSc;
    map['rebate_k3'] = rebateK3;
    map['rebate_115'] = rebate115;
    map['rebate_zr'] = rebateZr;
    map['rebate_dz'] = rebateDz;
    map['rebate_ty'] = rebateTy;
    map['rebate_qp'] = rebateQp;
    map['rebate_ms'] = rebateMs;
    map['rebate_by'] = rebateBy;
    map['rebate_tcl'] = rebateTcl;
    map['partner_flag'] = partnerFlag;
    map['cust_tag'] = custTag;
    map['scope'] = scope;
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    map['refresh_token'] = refreshToken;
    map['expires_in'] = expiresIn;
    map['is_show'] = isShow;
    map['isService'] = isService;
    map['live_leve'] = liveLeve;
    map['is_3rd'] = is3rd;
    map['is_bet'] = isBet;
    map['is_yuan'] = isYuan;
    map['rz_otc'] = rzOtc;
    if (custContact != null) {
      map['custContact'] = custContact?.toJson();
    }
    map['room_nickname'] = roomNickname;
    map['cust_account_type'] = custAccountType;
    map['is_new_register'] = isNewRegister;
    map['wallet_status'] = walletStatus;
    return map;
  }
}

class CustContact {
  CustContact({
    this.custId,
    this.contactName,
    this.gender,
    this.mobilePhone,
    this.email,
    this.qq,
    this.state,
    this.tid,
    this.zalo,
    this.facebook,
    this.whatsApp,
    this.line,
    this.rzState,
    this.rz2State,
    this.certificationLevel,
  });

  CustContact.fromJson(dynamic json) {
    custId = json['cust_id'];
    contactName = json['contact_name'];
    gender = json['gender'];
    mobilePhone = json['mobile_phone'];
    email = json['email'];
    qq = json['qq'];
    state = json['state'];
    tid = json['tid'];
    zalo = json['zalo'];
    facebook = json['facebook'];
    whatsApp = json['whatsApp'];
    line = json['line'];
    rzState = json['rz_state'];
    rz2State = json['rz2_state'];
    certificationLevel = json['certification_level'];
  }
  num? custId;
  String? contactName;
  num? gender;
  String? mobilePhone;
  String? email;
  String? qq;
  num? state;
  num? tid;
  String? zalo;
  String? facebook;
  String? whatsApp;
  String? line;
  num? rzState;
  num? rz2State;
  num? certificationLevel;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_id'] = custId;
    map['contact_name'] = contactName;
    map['gender'] = gender;
    map['mobile_phone'] = mobilePhone;
    map['email'] = email;
    map['qq'] = qq;
    map['state'] = state;
    map['tid'] = tid;
    map['zalo'] = zalo;
    map['facebook'] = facebook;
    map['whatsApp'] = whatsApp;
    map['line'] = line;
    map['rz_state'] = rzState;
    map['rz2_state'] = rz2State;
    map['certification_level'] = certificationLevel;
    return map;
  }
}
