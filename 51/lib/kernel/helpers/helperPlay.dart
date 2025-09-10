// 计算赔率 A盘公式
double computeOddsA(int price, int rebate, int value, int baseNoteNum,
    int subPlayPlanNum, int subPlayPlanNumWin) {
  double result = ((price / 1000) + ((rebate - value) / 10000)) *
      baseNoteNum *
      (subPlayPlanNum * (1 / subPlayPlanNumWin));
  // 四舍五入到小数点后三位
  return (result * 1000).round() / 1000;
}

// 计算赔率 信用盘公式
double computeOddsC(
    int price, int oddsRatio, int rebate, int value, int baseNoteNum) {
  double result = (price / 1000) *
      ((oddsRatio / 1000) + ((rebate - value) / 10000)) *
      baseNoteNum;
  // 四舍五入到小数点后三位
  return (result * 1000).round() / 1000;
}

int startTime(int beginTime, int startSaleOffset, int dbSysDate) {
  int delayTime = beginTime - startSaleOffset * 1000 - dbSysDate;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  return currentTime + delayTime;
}

int stopTime(int endTime, int stopSaleOffset, int dbSysDate) {
  int delayTime = endTime - stopSaleOffset * 1000 - dbSysDate;
  int currentTime = DateTime.now().millisecondsSinceEpoch;
  return currentTime + delayTime;
}

// 是否已封期
bool isFrost(int startTime, int stopTime) {
  if (startTime > 0 && stopTime > 0) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    return currentTime >= stopTime || currentTime < startTime;
  }
  return true;
}

// 是否为信用玩法
bool playIsXY(String playCat, int playId) {
  if (playCat.isNotEmpty && playId > 0) {
    const Map playConfig = {
      'SSC': {
        'min': 103,
        'max': 110,
      },
      'XYFT': {
        'min': 803,
        'max': 810,
      },
      'K3': {
        'min': 701,
        'max': 705,
      },
    };
    if (playConfig.containsKey(playCat)) {
      String curPlayidStr = playId.toString();
      if (curPlayidStr.length < 3) {
        return false;
      }
      String lastThreeStr = curPlayidStr.substring(curPlayidStr.length - 3);
      int last = int.parse(lastThreeStr);
      int min = playConfig[playCat]!['min']!;
      int max = playConfig[playCat]!['max']!;
      if (last >= min && last <= max) {
        return true;
      }
    }
  }
  return false;
}

// 获取玩家彩种基础返点
int getBaseRebate(String playCat) {
  int rebate = 0;
  // state.userInfo.partner
  Map baseRebates = {
    'rebate': 1000, // 时时彩
    'rebate_ft': 1000, // 福体
    'rebate_sc': 1000, // 北京赛车
    'rebate_k3': 1000, // 快3
    'rebate_115': 1000, // 11选5
    'rebate_zr': 0, // 真人
    'rebate_dz': 0, // 电子游艺
    'rebate_ty': 0, // 体育
    'rebate_qp': 0, // 棋牌
    'rebate_ms': 1000, // 六合彩
  };
  Map keys = {
    'PK10': 'rebate_sc',
    'PK10JDC': 'rebate_sc',
    'XYFTJDC': 'rebate_sc',
    'XYFT': 'rebate_sc',
    'SSC': 'rebate',
    'SSCJDC': 'rebate',
    '115': 'rebate_115',
    'K3': 'rebate_k3',
    'MARKSIX': 'rebate_ms',
    'LHCJDC': 'rebate_ms',
    'FC3D': 'rebate'
  };

  if (keys.containsKey(playCat)) {
    String rebateKey = keys[playCat];
    rebate = baseRebates[rebateKey];
  }

  return rebate;
}

// 计算 快三 和值 赔率
double getPlayK3HeZhiBallOdds(int planNum, int planNumWin, int price,
    int rebate, int value, int baseNoteNum) {
  double basicCalculation = (price * 0.001) + ((rebate - value) * 0.0001);
  double multipliedByBaseNote = basicCalculation * baseNoteNum;
  double multipliedByPlan = multipliedByBaseNote * (planNum * (1 / planNumWin));
  double ret = (multipliedByPlan * 1000).round() / 1000;
  return ret;
}
