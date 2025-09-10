///投注限额 item 状态model
class BettingItemState {
  bool isBottom = false;
  bool? isEdit = false;
  double limitMoney;
  double curryMoney;
  int limitTimeType;

  BettingItemState({
    this.isBottom = false,
    this.isEdit = false,
    this.limitMoney = 0.0,
    this.curryMoney = 0.0,
    this.limitTimeType =0,
  });

  double getLimitProcess() {
    return curryMoney / limitMoney;
  }

  @override
  String toString() {
    return 'BettingItemState{isBottom: $isBottom, isShow: $isEdit, limitMoney: $limitMoney, curryMoney: $curryMoney, limitTimeType: $limitTimeType}';
  }
}


