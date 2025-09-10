import '../../../utils/cbor_json_util.dart';
import 'alliance_common_params.dart';

///title 排序model
class AllianceSortModel {
  ///需求变更： 排序只有一个
  ///接口格式："sort_key":"created_at"，  "sort_type":"desc"
  //   "sort_key":"created_at",created_at根据注册日期排序
  //   "sort_type":"desc" 排序方式 desc:降序 asc:升序
  //排序接口规范， key 为接口返回的 字段名
  // sort_key=deposit_amount存款金额排序，
  // valid_bet_amount有效投注排序
  // sort_type=排序方式 desc:降序asc:升序

  SortState? joinTime = SortState.none; //加入时间
  SortState? countTime = SortState.none; //统计时间
  SortState? personAmount = SortState.none; //下属人数
  SortState? performance = SortState.none; //业绩
  SortState? contributeCommission = SortState.none; //贡献佣金
  SortState? deposit = SortState.none; //存款 or 存款金额
  SortState? withdraw = SortState.none; //取款 or 取款金额
  SortState? depositAndWithdrawDiff = SortState.none; //存取款差额
  SortState? validBet = SortState.none; //有效投注
  SortState? totalWinOrLoss = SortState.none; //总输赢
  SortState? isFirstDeposit = SortState.none; //是否首存
  SortState? lastLogin = SortState.none; //上次登陆
  SortState? onLine = SortState.none; //在线状态

  ///加入时间
  String get join_time => getModelValue(joinTime);

  ///统计时间
  String get count_time => getModelValue(countTime);

  String get direct_user_count => getModelValue(personAmount);

  ///业绩
  String get valid_bet_amount_direct => getModelValue(performance);

  ///贡献佣金
  String get commission_amount_direct => getModelValue(contributeCommission);

  ///所有数据-存款
  String get deposit_amount => getModelValue(deposit);

  ///存款- 直属财务
  String get withdraw_amount => getModelValue(withdraw);

  ///所有数据-有效投注
  String get valid_bet_amount => getModelValue(validBet);

  ///所有数据-总输赢
  String get net_amount => getModelValue(totalWinOrLoss);

  ///存取款差额：直属财务
  String get deposit_withdraw_amount => getModelValue(depositAndWithdrawDiff);

  ///是否首存：直属用户
  String get deposit_count => getModelValue(isFirstDeposit);

  ///上次登陆时间：直属用户
  String get last_login_at => getModelValue(lastLogin);

  ///把新的排序 封装在已有的 排序model中
  void copyWith(AllianceSortModel model) {
    joinTime = model.joinTime; //加入时间
    countTime = model.countTime; //统计时间
    personAmount = model.personAmount; //下属人数
    performance = model.performance; //业绩
    contributeCommission = model.contributeCommission; //贡献佣金
    deposit = model.deposit; //存款 or 存款金额
    withdraw = model.withdraw; //取款 or 取款金额
    depositAndWithdrawDiff = model.depositAndWithdrawDiff; //存取款差额
    validBet = model.validBet; //有效投注
    totalWinOrLoss = model.totalWinOrLoss; //总输赢
    isFirstDeposit = model.isFirstDeposit; //是否首存
    lastLogin = model.lastLogin; //上次登陆
    onLine = model.onLine; //在线状态
  }

  String getModelValue(SortState? model) {
    if (model != null) {
      return model.sort;
    } else {
      return '';
    }
  }

  ///转换接口需要的参数
  /// 接口格式："sort_key":"created_at"，  "sort_type":"desc"
  Iterable<MapEntry<String , String>> getApiParamsFormat() {
    // var apiParams = <Map<String,String>>{};
    // var sortMap =  toJson();
    var list =  toJson().entries.where((element) =>element.value.isNotEmpty);
    if(list.isNotEmpty){
      // return  {"sort_key":apiParams.first.key, "sort_type":apiParams.first.value};
      return  [MapEntry("sort_key",list.first.key),MapEntry("sort_type",list.first.value)];
    }
    return [];
  }

  ///转换map 方便取值
  Map<String, String> toJson() => {
    "join_time": join_time,
    "count_time": count_time,
    "direct_user_count": direct_user_count,
    "valid_bet_amount_direct": valid_bet_amount_direct,
    "commission_amount_direct": commission_amount_direct,
    "deposit_amount": deposit_amount,
    "withdraw_amount": withdraw_amount,
    "valid_bet_amount": valid_bet_amount,
    "net_amount": net_amount,
    "deposit_withdraw_amount": deposit_withdraw_amount,
    "deposit_count": deposit_count,
    "last_login_at": last_login_at,
  };


}
