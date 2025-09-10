//排行榜 是否倒计时配置
mixin BettingBizCountMixin {
  static const int maxCount = 5; //分钟倒计时，可用于间隔多少分钟刷新数据
  int minCurrent = maxCount;
  bool countSwitch = true; //是否启动倒计时计算

  ///刷新列表数据， 倒计时计算
  bool minCountdown() {
    if (minCurrent <= 0) {
      //倒计时重置
      minCurrent = maxCount;
      return true;
    } else {
      minCurrent--;
      return false;
    }
  }
}
