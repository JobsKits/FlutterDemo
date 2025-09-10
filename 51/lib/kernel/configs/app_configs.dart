// import 'package:flutter_tiyu_app/kernel/configs/play_info.dart';

import 'package:flutter_tiyu_app/kernel/configs/sub_play.dart';

class AppConfigs {
  // 生产环境 澳门新葡京
  // static const aseqId = '21';
  // static const tid = 2;
  // static const clustersId = 23;

  // 预发布环境
  // static const aseqId = '7';
  // static const tid = 5;
  // static const clustersId = 25;

  // 开发环境
  static const aseqId = '7';
  static const tid = 3;
  static const clustersId = 997;

  static const chanCode = 'zhcaipiaoh5';
  static const proxy = 0;
  static const des3Key = 'zXxWLlX4+dQyIUp0sgs=';
  static const appVersion = -1.0;
  static const clientId = 'react_client';
  static const vk = 'fT6phq0wkOPRlAoyToidAnkogUV7ttGo';
  static const promote = ''; // 推广链接
  static const lang = 'cn'; //  本地语言，支持 en, cn

  // 获得子玩法信息 isXY是否信用
  static Map getSubPlayInfo(String strategy, bool isXY) {
    Map subInfo = {};
    String key = '$strategy${isXY ? 'XY' : ''}';
    if (subPlay[key] != null) {
      Map info = subPlay[key]!;
      subInfo['subs'] = info['subs'];
    }
    return subInfo;
  }

  // static
}
