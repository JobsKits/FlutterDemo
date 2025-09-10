import '../../../generated/l10n.dart';
import 'activity_common_params.dart';

///推广活动有效推广人数详情 model
///{{url}}/member/agency/valid/member/detail?pid=40039904499718196
class ActivityInviteApiModel {
  // "uid": "23614085988113275", //子会员uid
  // "username": "leo666", //子会员名
  // "parent_uid": "124322367247894", //子会员的上级uid
  // "pid": "40039904499718196", //活动id
  // "state": 1, //该子会员是否为有效推广，1：有效、2：无效
  // "registered_at": 1711443515 //子会员注册时间
  String? uid;
  String? username;
  String? parentUid;
  String? pid;
  int? state;
  int? registeredAt;

  ActivityInviteApiModel({
    this.uid,
    this.username,
    this.parentUid,
    this.pid,
    this.state,
    this.registeredAt,
  });


  String getStateLabel() {
    return ActivityInviteState.adaptor(state)?.getLabel() ?? "";
  }


  factory ActivityInviteApiModel.fromJson(Map<String, dynamic> json) => ActivityInviteApiModel(
        uid: json["uid"],
        username: json["username"],
        parentUid: json["parent_uid"],
        pid: json["pid"],
        state: json["state"],
        registeredAt: json["registered_at"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "username": username,
        "parent_uid": parentUid,
        "pid": pid,
        "state": state,
        "registered_at": registeredAt,
      };
}
