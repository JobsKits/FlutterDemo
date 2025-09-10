// ignore_for_file: non_constant_identifier_names

import 'package:flutter_tiyu_app/utils/app_json_serializable.dart';

class UserLocalBean implements AppJsonSerializable {
  UserLocalBean({
    this.userInputName,
    this.userInputEmail,
    this.userInputPhone,
    this.userInputPwd,
    this.userIsRememberPwd,
  });

  String? userInputName;
  String? userInputEmail;
  bool? userIsRememberPwd;
  String? userInputPwd;
  String? userInputPhone;

  UserLocalBean.fromJson(dynamic json) {
    userInputName = json['userInputName'];
    userInputEmail = json['userInputEmail'];
    userIsRememberPwd = json['userIsRememberPwd'];
    userInputPwd = json['userInputPwd'];
    userInputPhone = json['userInputPhone'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['userInputName'] = userInputName;
    map['userInputEmail'] = userInputEmail;
    map['userIsRememberPwd'] = userIsRememberPwd;
    map['userInputPwd'] = userInputPwd;
    map['userInputPhone'] = userInputPhone;
    return map;
  }
}

class LoginBean implements AppJsonSerializable {
  LoginBean({
    required this.custId,
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
    this.partner,
    this.custTag,
    this.scope,
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.expiresIn,
    this.pwdIsExpired,
    this.levelInfo,
    this.isShow,
    this.blacklistGame,
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
    this.isFrozen,
  });

  LoginBean.fromJson(dynamic json) {
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
    partner =
        json['partner'] != null ? LoginPartner.fromJson(json['partner']) : null;
    custTag = json['cust_tag'];
    scope = json['scope'];
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    refreshToken = json['refresh_token'];
    expiresIn = json['expires_in'];
    pwdIsExpired = json['pwd_is_expired'];
    levelInfo = json['level_info'] != null
        ? LevelInfo.fromJson(json['level_info'])
        : null;
    isShow = json['is_show'];
    blacklistGame = json['blacklist_game'];
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
    isFrozen = json['is_frozen'];
  }
  late final int custId;
  String? custCode;
  String? custName;
  String? nickname;
  String? head;
  int? custType;
  int? custGrade;
  int? custLevel;
  int? vipFlag;
  int? vipCard;
  String? chanCode;
  String? admCode;
  int? uid;
  String? password1st;
  String? inviteCode;
  String? promoteCode;
  int? inTime;
  int? createTime;
  int? state;
  int? stateTime;
  int? fictFlag;
  int? acctId;
  int? acctStateTime;
  int? acctState;
  int? tid;
  int? pwdAcctPwd;
  int? rebate;
  int? rebateFt;
  int? rebateSc;
  int? rebateK3;
  int? rebate115;
  int? rebateZr;
  int? rebateDz;
  int? rebateTy;
  int? rebateQp;
  int? rebateMs;
  int? rebateBy;
  int? rebateTcl;
  int? partnerFlag;
  LoginPartner? partner;
  int? custTag;
  String? scope;
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  int? expiresIn;
  String? pwdIsExpired;
  LevelInfo? levelInfo;
  int? isShow;
  String? blacklistGame;
  int? isService;
  int? liveLeve;
  int? is3rd;
  int? isBet;
  String? isYuan;
  int? rzOtc;
  CustContact? custContact;
  String? roomNickname;
  int? custAccountType;
  int? isNewRegister;
  dynamic? walletStatus;
  int? isFrozen;

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
    map['partner'] = partner;
    map['cust_tag'] = custTag;
    map['scope'] = scope;
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    map['refresh_token'] = refreshToken;
    map['expires_in'] = expiresIn;
    map['pwd_is_expired'] = pwdIsExpired;
    if (levelInfo != null) {
      map['level_info'] = levelInfo?.toJson();
    }
    map['is_show'] = isShow;
    map['blacklist_game'] = blacklistGame;
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
    map['is_frozen'] = isFrozen;
    return map;
  }

  @override
  String toString() {
    return 'LoginBean{custId: $custId, custCode: $custCode, custName: $custName, nickname: $nickname, head: $head, custType: $custType, custGrade: $custGrade, custLevel: $custLevel, vipFlag: $vipFlag, vipCard: $vipCard, chanCode: $chanCode, admCode: $admCode, uid: $uid, password1st: $password1st, inviteCode: $inviteCode, promoteCode: $promoteCode, inTime: $inTime, createTime: $createTime, state: $state, stateTime: $stateTime, fictFlag: $fictFlag, acctId: $acctId, acctStateTime: $acctStateTime, acctState: $acctState, tid: $tid, pwdAcctPwd: $pwdAcctPwd, rebate: $rebate, rebateFt: $rebateFt, rebateSc: $rebateSc, rebateK3: $rebateK3, rebate115: $rebate115, rebateZr: $rebateZr, rebateDz: $rebateDz, rebateTy: $rebateTy, rebateQp: $rebateQp, rebateMs: $rebateMs, rebateBy: $rebateBy, rebateTcl: $rebateTcl, partnerFlag: $partnerFlag, custTag: $custTag, scope: $scope, accessToken: $accessToken, tokenType: $tokenType, refreshToken: $refreshToken, expiresIn: $expiresIn, pwdIsExpired: $pwdIsExpired, levelInfo: $levelInfo, isShow: $isShow, blacklistGame: $blacklistGame, isService: $isService, liveLeve: $liveLeve, is3rd: $is3rd, isBet: $isBet, isYuan: $isYuan, rzOtc: $rzOtc, custContact: $custContact, roomNickname: $roomNickname, custAccountType: $custAccountType, isNewRegister: $isNewRegister, walletStatus: $walletStatus, isFrozen: $isFrozen}';
  }
}

class CustContact {
  CustContact({
    this.custId,
    this.custCode,
    this.contactName,
    this.gender,
    this.mobilePhone,
    this.email,
    this.qq,
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
    this.certificationLevel,
    this.googleSecret,
  });

  CustContact.fromJson(dynamic json) {
    custId = json['cust_id'];
    custCode = json['cust_code'];
    contactName = json['contact_name'];
    gender = json['gender'];
    mobilePhone = json['mobile_phone'];
    email = json['email'];
    qq = json['qq'];
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
    certificationLevel = json['certification_level'];
    googleSecret = json['google_secret'];
  }
  int? custId;
  String? custCode;
  String? contactName;
  int? gender;
  String? mobilePhone;
  String? email;
  String? qq;
  int? createTime;
  int? state;
  int? stateTime;
  int? tid;
  String? zalo;
  String? facebook;
  String? whatsApp;
  String? line;
  int? rzState;
  int? rz2State;
  int? certificationLevel;
  String? googleSecret;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_id'] = custId;
    map['cust_code'] = custCode;
    map['contact_name'] = contactName;
    map['gender'] = gender;
    map['mobile_phone'] = mobilePhone;
    map['email'] = email;
    map['qq'] = qq;
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
    map['certification_level'] = certificationLevel;
    map['google_secret'] = googleSecret;
    return map;
  }
}

class LevelInfo {
  LevelInfo({
    this.levelName,
    this.level,
  });

  LevelInfo.fromJson(dynamic json) {
    levelName = json['level_name'];
    level = json['level'];
  }
  String? levelName;
  int? level;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['level_name'] = levelName;
    map['level'] = level;
    return map;
  }
}

class ImageVerifyCodeBean {
  ImageVerifyCodeBean({
    this.image,
    this.verifyCodeKey,
  });

  String? image;
  String? verifyCodeKey;

  ImageVerifyCodeBean.fromJson(dynamic json) {
    image = json['image'];
    verifyCodeKey = json['verifycode_key'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['image'] = image;
    map['verifycode_key'] = verifyCodeKey;
    return map;
  }
}

class LoginPartner {
  LoginPartner({
    this.acct_id,
    this.agent_type,
    this.all_level_switch,
    this.allowAddFriend,
    this.allowChat,
    this.allow_cust,
    this.allow_lower,
    this.allow_peer,
    this.allow_rebate,
    this.allow_transfer,
    this.bonus,
    this.buildGroup,
    this.busi_code,
    this.create_time,
    this.direct_level_switch,
    this.fict_flag,
    this.friend_code,
    this.is_auto_track,
    this.is_charge,
    this.is_flag_seed,
    this.is_receive,
    this.is_refresh,
    this.is_return,
    this.level,
    this.lower_quota,
    this.lower_quota_used,
    this.mark,
    this.partner_code,
    this.partner_des,
    this.partner_id,
    this.partner_level,
    this.partner_name,
    this.partner_type,
    this.peer_id,
    this.peer_quota,
    this.peer_quota_used,
    this.promote_code,
    this.promotion_link_switch,
    this.rebate,
    this.rebate_115,
    this.rebate_115_min,
    this.rebate_by,
    this.rebate_dz,
    this.rebate_ft,
    this.rebate_ft_min,
    this.rebate_hb,
    this.rebate_k3,
    this.rebate_k3_min,
    this.rebate_min,
    this.rebate_ms,
    this.rebate_ms_min,
    this.rebate_qp,
    this.rebate_ratio,
    this.rebate_sc,
    this.rebate_sc_min,
    this.rebate_tcl,
    this.rebate_tcl_min,
    this.rebate_ty,
    this.rebate_zr,
    this.return_PRebate,
    this.state,
    this.state_time,
    this.superMember,
    this.tid,
    this.total_valid_bet,
    this.track_state,
    this.upper_id,
    this.wages,
  });

  num? acct_id;
  num? agent_type;
  num? all_level_switch;
  bool? allowAddFriend;
  bool? allowChat;
  bool? allow_cust;
  bool? allow_lower;
  bool? allow_peer;
  bool? allow_rebate;
  bool? allow_transfer;
  num? bonus;
  bool? buildGroup;
  num? busi_code;
  num? create_time;
  num? direct_level_switch;
  num? fict_flag;
  num? friend_code;
  num? is_auto_track;
  num? is_charge;
  num? is_flag_seed;
  num? is_receive;
  num? is_refresh;
  num? is_return;
  num? level;
  num? lower_quota;
  num? lower_quota_used;
  num? mark;
  String? partner_code;
  String? partner_des;
  num? partner_id;
  num? partner_level;
  String? partner_name;
  num? partner_type;
  num? peer_id;
  num? peer_quota;
  num? peer_quota_used;
  String? promote_code;
  num? promotion_link_switch;
  num? rebate;
  num? rebate_115;
  num? rebate_115_min;
  num? rebate_by;
  num? rebate_dz;
  num? rebate_ft;
  num? rebate_ft_min;
  num? rebate_hb;
  num? rebate_k3;
  num? rebate_k3_min;
  num? rebate_min;
  num? rebate_ms;
  num? rebate_ms_min;
  num? rebate_qp;
  num? rebate_ratio;
  num? rebate_sc;
  num? rebate_sc_min;
  num? rebate_tcl;
  num? rebate_tcl_min;
  num? rebate_ty;
  num? rebate_zr;
  bool? return_PRebate;
  num? state;
  num? state_time;
  bool? superMember;
  num? tid;
  num? total_valid_bet;
  num? track_state;
  num? upper_id;
  num? wages;

  LoginPartner.fromJson(dynamic json) {
    acct_id = json['acct_id'];
    agent_type = json['agent_type'];
    all_level_switch = json['all_level_switch'];
    allowAddFriend = json['allowAddFriend'];
    allowChat = json['allowChat'];
    allow_cust = json['allow_cust'];
    allow_lower = json['allow_lower'];
    allow_peer = json['allow_peer'];
    allow_rebate = json['allow_rebate'];
    allow_transfer = json['allow_transfer'];
    bonus = json['bonus'];
    buildGroup = json['buildGroup'];
    busi_code = json['busi_code'];
    create_time = json['create_time'];
    direct_level_switch = json['direct_level_switch'];
    fict_flag = json['fict_flag'];
    friend_code = json['friend_code'];
    is_auto_track = json['is_auto_track'];
    is_charge = json['is_charge'];
    is_flag_seed = json['is_flag_seed'];
    is_receive = json['is_receive'];
    is_refresh = json['is_refresh'];
    is_return = json['is_return'];
    level = json['level'];
    lower_quota = json['lower_quota'];
    lower_quota_used = json['lower_quota_used'];
    mark = json['mark'];
    partner_code = json['partner_code'];
    partner_des = json['partner_des'];
    partner_id = json['partner_id'];
    partner_level = json['partner_level'];
    partner_name = json['partner_name'];
    partner_type = json['partner_type'];
    peer_id = json['peer_id'];
    peer_quota = json['peer_quota'];
    peer_quota_used = json['peer_quota_used'];
    promote_code = json['promote_code'];
    promotion_link_switch = json['promotion_link_switch'];
    rebate = json['rebate'];
    rebate_115 = json['rebate_115'];
    rebate_115_min = json['rebate_115_min'];
    rebate_by = json['rebate_by'];
    rebate_dz = json['rebate_dz'];
    rebate_ft = json['rebate_ft'];
    rebate_ft_min = json['rebate_ft_min'];
    rebate_hb = json['rebate_hb'];
    rebate_k3 = json['rebate_k3'];
    rebate_k3_min = json['rebate_k3_min'];
    rebate_min = json['rebate_min'];
    rebate_ms = json['rebate_ms'];
    rebate_ms_min = json['rebate_ms_min'];
    rebate_qp = json['rebate_qp'];
    rebate_ratio = json['rebate_ratio'];
    rebate_sc = json['rebate_sc'];
    rebate_sc_min = json['rebate_sc_min'];
    rebate_tcl = json['rebate_tcl'];
    rebate_tcl_min = json['rebate_tcl_min'];
    rebate_ty = json['rebate_ty'];
    rebate_zr = json['rebate_zr'];
    return_PRebate = json['return_PRebate'];
    state = json['state'];
    state_time = json['state_time'];
    superMember = json['superMember'];
    tid = json['tid'];
    total_valid_bet = json['total_valid_bet'];
    track_state = json['track_state'];
    upper_id = json['upper_id'];
    wages = json['wages'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['acct_id'] = acct_id;
    map['agent_type'] = agent_type;
    map['all_level_switch'] = all_level_switch;
    map['allowAddFriend'] = allowAddFriend;
    map['allowChat'] = allowChat;
    map['allow_cust'] = allow_cust;
    map['allow_lower'] = allow_lower;
    map['allow_peer'] = allow_peer;
    map['allow_rebate'] = allow_rebate;
    map['allow_transfer'] = allow_transfer;
    map['bonus'] = bonus;
    map['buildGroup'] = buildGroup;
    map['busi_code'] = busi_code;
    map['create_time'] = create_time;
    map['direct_level_switch'] = direct_level_switch;
    map['fict_flag'] = fict_flag;
    map['friend_code'] = friend_code;
    map['is_auto_track'] = is_auto_track;
    map['is_charge'] = is_charge;
    map['is_flag_seed'] = is_flag_seed;
    map['is_receive'] = is_receive;
    map['is_refresh'] = is_refresh;
    map['is_return'] = is_return;
    map['level'] = level;
    map['lower_quota'] = lower_quota;
    map['lower_quota_used'] = lower_quota_used;
    map['mark'] = mark;
    map['partner_code'] = partner_code;
    map['partner_des'] = partner_des;
    map['partner_id'] = partner_id;
    map['partner_level'] = partner_level;
    map['partner_name'] = partner_name;
    map['partner_type'] = partner_type;
    map['peer_id'] = peer_id;
    map['peer_quota'] = peer_quota;
    map['peer_quota_used'] = peer_quota_used;
    map['promote_code'] = promote_code;
    map['promotion_link_switch'] = promotion_link_switch;
    map['rebate'] = rebate;
    map['rebate_115'] = rebate_115;
    map['rebate_115_min'] = rebate_115_min;
    map['rebate_by'] = rebate_by;
    map['rebate_dz'] = rebate_dz;
    map['rebate_ft'] = rebate_ft;
    map['rebate_ft_min'] = rebate_ft_min;
    map['rebate_hb'] = rebate_hb;
    map['rebate_k3'] = rebate_k3;
    map['rebate_k3_min'] = rebate_k3_min;
    map['rebate_min'] = rebate_min;
    map['rebate_ms'] = rebate_ms;
    map['rebate_ms_min'] = rebate_ms_min;
    map['rebate_qp'] = rebate_qp;
    map['rebate_ratio'] = rebate_ratio;
    map['rebate_sc'] = rebate_sc;
    map['rebate_sc_min'] = rebate_sc_min;
    map['rebate_tcl'] = rebate_tcl;
    map['rebate_tcl_min'] = rebate_tcl_min;
    map['rebate_ty'] = rebate_ty;
    map['rebate_zr'] = rebate_zr;
    map['return_PRebate'] = return_PRebate;
    map['state'] = state;
    map['state_time'] = state_time;
    map['superMember'] = superMember;
    map['tid'] = tid;
    map['total_valid_bet'] = total_valid_bet;
    map['track_state'] = track_state;
    map['upper_id'] = upper_id;
    map['wages'] = wages;
    return map;
  }
}
