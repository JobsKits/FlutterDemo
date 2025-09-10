import 'package:flutter_bet/generated/l10n.dart';

///联盟计划-tab-直属用户 model
class DirectUserModel {
  int time; //加入时间
  String account; //账号
  bool isFirstDeposit; //是否首存
  int lastLoginTime; //上次登陆时间
  int onLineState; // 在线状态， 1在线；2离线
  int onLineTimes; // 在线状态次数

  DirectUserModel({
    required this.time,
    required this.account,
    required this.isFirstDeposit,
    required this.lastLoginTime,
    required this.onLineState,
    required this.onLineTimes,
  });

  String getIsFirstDeposit() {
    return isFirstDeposit ? S.current.random_text_116 : S.current.random_text_117;
  }

  bool isOnline() {
    return onLineState == 1;
  }

  String getOnLineState() {
    return onLineState == 1 ? S.current.random_text_118 : S.current.random_text_119;
  }

  String getOnLineTimes() {
    return onLineTimes.toString() + S.current.random_text_120;
  }
}
