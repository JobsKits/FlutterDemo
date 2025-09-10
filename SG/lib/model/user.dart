import 'dart:convert';

import 'wallet/BalanceBean.dart';

// {
// "uid": "99981480358944791",
// "realname": "",
// "area_code": "",
// "phone": "",
// "email": "englishaiwen@gmail.com",
// "email_check_state": 0,
// "telegram": "",
// "facebook": "",
// "zalo": "",
// "line": "",
// "viber": "",
// "whatsapp": "",
// "twitter": "",
// "wechat": "",
// "qq": "",
// "sex": 1,
// "token": ""
// }

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  String? uid;
  String? token;
  String? username;
  String? email;
  int? emailCheckState;
  String? password;
  int? createdAt;
  String? createdIp;
  String? levelId;
  String? vip;
  String? topUid;
  String? topName;
  String? parentUid;
  String? parentName;
  String? tester;
  int? avatar;
  String? deviceNumber;
  String? lastLoginIp;
  int? lastLoginAt;
  String? lastLoginDevice;
  String? lastLoginDomain;
  String? regDomain;
  String? regIp;
  String? regDeviceNo;
  int? agencyRebateState;
  String? state;
  String? score;
  String? source;
  int? memberType;
  int? bonusState;
  String? bonusNote;
  String? note;
  int? depositCount;
  int? withdrawCount;
  String? depositAmount;
  String? withdrawAmount;
  String? googleKey;
  int? googleVerify;
  String? payPassword;
  String? online;
  String? levelLockState;
  UserRealNameModel? realname;
  UserExt? mext;
  BalanceBean? balance;
  BalanceBean? balance_locker;
  String? phone;
  int? phoneCheckState;

  User(
      {this.uid,
      this.token,
      this.username,
      this.email,
      this.emailCheckState,
      this.password,
      this.createdAt,
      this.createdIp,
      this.levelId,
      this.vip,
      this.topUid,
      this.topName,
      this.parentUid,
      this.parentName,
      this.tester,
      this.avatar,
      this.deviceNumber,
      this.lastLoginIp,
      this.lastLoginAt,
      this.lastLoginDevice,
      this.lastLoginDomain,
      this.regDomain,
      this.regIp,
      this.regDeviceNo,
      this.agencyRebateState,
      this.state,
      this.score,
      this.source,
      this.memberType,
      this.bonusState,
      this.bonusNote,
      this.note,
      this.depositCount,
      this.withdrawCount,
      this.depositAmount,
      this.withdrawAmount,
      this.googleKey,
      this.googleVerify,
      this.payPassword,
      this.online,
      this.realname,
      this.levelLockState,
      this.mext,
      this.balance,
      this.balance_locker,
      this.phone,
      this.phoneCheckState});

  User copyWith({
    String? uid,
    String? token,
    String? username,
    String? email,
    int? emailCheckState,
    String? password,
    int? createdAt,
    String? createdIp,
    String? levelId,
    String? vip,
    String? topUid,
    String? topName,
    String? parentUid,
    String? parentName,
    String? tester,
    int? avatar,
    String? deviceNumber,
    String? lastLoginIp,
    int? lastLoginAt,
    String? lastLoginDevice,
    String? lastLoginDomain,
    String? regDomain,
    String? regIp,
    String? regDeviceNo,
    int? agencyRebateState,
    String? state,
    String? score,
    String? source,
    int? memberType,
    int? bonusState,
    String? bonusNote,
    String? note,
    int? depositCount,
    int? withdrawCount,
    String? depositAmount,
    String? withdrawAmount,
    String? googleKey,
    int? googleVerify,
    String? payPassword,
    String? online,
    String? levelLockState,
    UserExt? ext,
    BalanceBean? balance,
    BalanceBean? balance_locker,
    String? phone,
    int? phoneCheckState,
  }) =>
      User(
        uid: uid ?? this.uid,
        token: token ?? this.token,
        username: username ?? this.username,
        email: email ?? this.email,
        emailCheckState: emailCheckState ?? this.emailCheckState,
        password: password ?? this.password,
        createdAt: createdAt ?? this.createdAt,
        createdIp: createdIp ?? this.createdIp,
        levelId: levelId ?? this.levelId,
        vip: vip ?? this.vip,
        topUid: topUid ?? this.topUid,
        topName: topName ?? this.topName,
        parentUid: parentUid ?? this.parentUid,
        parentName: parentName ?? this.parentName,
        tester: tester ?? this.tester,
        avatar: avatar ?? this.avatar,
        deviceNumber: deviceNumber ?? this.deviceNumber,
        lastLoginIp: lastLoginIp ?? this.lastLoginIp,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        lastLoginDevice: lastLoginDevice ?? this.lastLoginDevice,
        lastLoginDomain: lastLoginDomain ?? this.lastLoginDomain,
        regDomain: regDomain ?? this.regDomain,
        regIp: regIp ?? this.regIp,
        regDeviceNo: regDeviceNo ?? this.regDeviceNo,
        agencyRebateState: agencyRebateState ?? this.agencyRebateState,
        state: state ?? this.state,
        score: score ?? this.score,
        source: source ?? this.source,
        memberType: memberType ?? this.memberType,
        bonusState: bonusState ?? this.bonusState,
        bonusNote: bonusNote ?? this.bonusNote,
        note: note ?? this.note,
        depositCount: depositCount ?? this.depositCount,
        withdrawCount: withdrawCount ?? this.withdrawCount,
        depositAmount: depositAmount ?? this.depositAmount,
        withdrawAmount: withdrawAmount ?? this.withdrawAmount,
        googleKey: googleKey ?? this.googleKey,
        googleVerify: googleVerify ?? this.googleVerify,
        payPassword: payPassword ?? this.payPassword,
        online: online ?? this.online,
        levelLockState: levelLockState ?? this.levelLockState,
        balance: balance ?? this.balance,
        balance_locker: balance_locker ?? this.balance_locker,
        mext: ext ?? this.mext,
        realname: realname ?? this.realname,
        phone: phone ?? this.phone,
        phoneCheckState: phoneCheckState ?? this.phoneCheckState,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        uid: json["uid"],
        token: json["token"],
        username: json["username"],
        email: json["email"],
        emailCheckState: json["email_check_state"],
        password: json["password"],
        createdAt: json["created_at"],
        createdIp: json["created_ip"],
        levelId: json["level_id"],
        vip: json["vip"],
        topUid: json["top_uid"],
        topName: json["top_name"],
        parentUid: json["parent_uid"],
        parentName: json["parent_name"],
        tester: json["tester"],
        avatar: json["avatar"],
        deviceNumber: json["device_number"],
        lastLoginIp: json["last_login_ip"],
        lastLoginAt: json["last_login_at"],
        lastLoginDevice: json["last_login_device"],
        lastLoginDomain: json["last_login_domain"],
        regDomain: json["reg_domain"],
        regIp: json["reg_ip"],
        regDeviceNo: json["reg_device_no"],
        agencyRebateState: json["agency_rebate_state"],
        state: json["state"],
        score: json["score"],
        source: json["source"],
        memberType: json["member_type"],
        bonusState: json["bonus_state"],
        bonusNote: json["bonus_note"],
        note: json["note"],
        depositCount: json["deposit_count"],
        withdrawCount: json["withdraw_count"],
        depositAmount: json["deposit_amount"],
        withdrawAmount: json["withdraw_amount"],
        googleKey: json["google_key"],
        googleVerify: json["google_verify"],
        payPassword: json["pay_password"],
        online: json["online"],
        levelLockState: json["level_lock_state"],
        realname: json["realname"] == null ? null : UserRealNameModel.fromJson(json["realname"]),
        mext: json["mext"] == null ? null : UserExt.fromJson(json["mext"]),
        balance: json["balance"] == null ? null : BalanceBean.fromJson(json["balance"]),
        balance_locker:
            json["balance_locker"] == null ? null : BalanceBean.fromJson(json["balance_locker"]),
        phone: json["phone"],
        phoneCheckState: json["phone_check_state"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "token": token,
        "username": username,
        "email": email,
        "email_check_state": emailCheckState,
        "password": password,
        "created_at": createdAt,
        "created_ip": createdIp,
        "level_id": levelId,
        "vip": vip,
        "top_uid": topUid,
        "top_name": topName,
        "parent_uid": parentUid,
        "parent_name": parentName,
        "tester": tester,
        "avatar": avatar,
        "device_number": deviceNumber,
        "last_login_ip": lastLoginIp,
        "last_login_at": lastLoginAt,
        "last_login_device": lastLoginDevice,
        "last_login_domain": lastLoginDomain,
        "reg_domain": regDomain,
        "reg_ip": regIp,
        "reg_device_no": regDeviceNo,
        "agency_rebate_state": agencyRebateState,
        "state": state,
        "score": score,
        "source": source,
        "member_type": memberType,
        "bonus_state": bonusState,
        "bonus_note": bonusNote,
        "note": note,
        "deposit_count": depositCount,
        "withdraw_count": withdrawCount,
        "deposit_amount": depositAmount,
        "withdraw_amount": withdrawAmount,
        "google_key": googleKey,
        "google_verify": googleVerify,
        "pay_password": payPassword,
        "online": online,
        "level_lock_state": levelLockState,
        "realname": realname?.toJson(),
        "mext": mext?.toJson(),
        "balance": balance?.toJson(),
        "balance_locker": balance_locker?.toJson(),
        "phone": phone,
        "phone_check_state": phoneCheckState,
      };
}

class UserExt {
  String? uid;
  String? telegram;
  String? facebook;
  String? zalo;
  String? line;
  String? phone;
  String? areaCode;
  String? viber;
  String? whatsapp;
  String? twitter;
  String? wechat;
  String? qq;
  String? cpf;
  int? sex;

  UserExt({
    this.uid,
    this.telegram,
    this.facebook,
    this.zalo,
    this.line,
    this.phone,
    this.areaCode,
    this.viber,
    this.whatsapp,
    this.twitter,
    this.wechat,
    this.qq,
    this.cpf,
    this.sex,
  });

  factory UserExt.fromJson(Map<String, dynamic> json) => UserExt(
        uid: json["uid"],
        telegram: json["telegram"],
        facebook: json["facebook"],
        zalo: json["zalo"],
        line: json["line"],
        phone: json["phone"],
        areaCode: json["area_code"],
        viber: json["viber"],
        whatsapp: json["whatsapp"],
        twitter: json["twitter"],
        wechat: json["wechat"],
        qq: json["qq"],
        cpf: json["cpf"],
        sex: json["sex"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "telegram": telegram,
        "facebook": facebook,
        "zalo": zalo,
        "line": line,
        "phone": phone,
        "area_code": areaCode,
        "viber": viber,
        "whatsapp": whatsapp,
        "twitter": twitter,
        "wechat": wechat,
        "qq": qq,
        "cpf": cpf,
        "sex": sex,
      };
}

UserRealNameModel userRealNameModelFromJson(String str) =>
    UserRealNameModel.fromJson(json.decode(str));

String userRealNameModelToJson(UserRealNameModel data) => json.encode(data.toJson());

class UserRealNameModel {
  String? cn;
  String? vn;
  String? th;
  String? br;
  String? en;
  String? inKey;

  UserRealNameModel({
    this.cn,
    this.vn,
    this.th,
    this.br,
    this.en,
    this.inKey,
  });

  UserRealNameModel copyWith({
    String? cn,
    String? vn,
    String? th,
    String? br,
    String? en,
    String? inKey,
  }) =>
      UserRealNameModel(
        cn: cn ?? this.cn,
        vn: vn ?? this.vn,
        th: th ?? this.th,
        br: br ?? this.br,
        en: en ?? this.en,
        inKey: inKey ?? this.inKey,
      );

  factory UserRealNameModel.fromJson(Map<String, dynamic> json) => UserRealNameModel(
        cn: json["cn"],
        vn: json["vn"],
        th: json["th"],
        br: json["br"],
        en: json["en"],
        inKey: json["in"],
      );

  Map<String, dynamic> toJson() => {
        "cn": cn,
        "vn": vn,
        "th": th,
        "br": br,
        "en": en,
        "in": inKey,
      };
}
