import '../../../generated/l10n.dart';
import '../../../utils/date_util.dart';

///直属用户  /agency/report/user
class DirectUserApiModel {
  // "uid": "52498479228142538", //会员ID
  // "username": "allan15", //会员账号
  // "online": "1", //1:离线 2:在线
  // "deposit_count": 0, //存款次数当值大于0标识首存
  // "last_login_at": 0, //上次登录时间
  // "login_count": 0, //登陆次数
  // "vip": "0", //vip等级
  // "created_at": 1701487496 //注册时间
  String? uid;
  String? username;
  String? online;
  int? depositCount;
  int? lastLoginAt;
  int? loginCount;
  String? vip;
  int? createdAt;

  DirectUserApiModel({
    this.uid,
    this.username,
    this.online,
    this.depositCount,
    this.lastLoginAt,
    this.loginCount,
    this.vip,
    this.createdAt,
  });

  ///存款次数当值大于0标识首存
  bool isFirstDeposit() {
    return depositCount != null && depositCount! > 0;
  }

  ///存款次数当值大于0标识首存
  String getIsFirstDeposit() {
    return (depositCount ?? 0) > 0 ? S.current.random_text_116 : S.current.random_text_117;
  }

  bool isOnline() {
    return online == "2";
  }

  String getOnLineState() {
    return online == "2" ? S.current.random_text_118 : S.current.random_text_119;
  }

  // String getCreatedAtTimes() {
  //   // return onLineTimes.toString() + S.current.random_text_120;
  //   return "${DateUtil.formatDateMs(createdAt ?? 0, format: 'dd/MM/yyyy')}\n${DateUtil.formatDateMs(lastLoginAt ?? 0, format: 'HH:mm:ss')}";
  // }
  //
  // String getOnLineTimes() {
  //   // return onLineTimes.toString() + S.current.random_text_120;
  //   return "${DateUtil.formatDateMs(lastLoginAt ?? 0, format: 'dd/MM/yyyy')}\n${DateUtil.formatDateMs(lastLoginAt ?? 0, format: 'HH:mm:ss')}";
  // }

  factory DirectUserApiModel.fromJson(Map<String, dynamic> json) => DirectUserApiModel(
        uid: json["uid"],
        username: json["username"],
        online: json["online"],
        depositCount: json["deposit_count"],
        lastLoginAt: json["last_login_at"],
        loginCount: json["login_count"],
        vip: json["vip"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "online": online,
        "deposit_count": depositCount,
        "last_login_at": lastLoginAt,
        "login_count": loginCount,
        "vip": vip,
        "created_at": createdAt,
      };
}
