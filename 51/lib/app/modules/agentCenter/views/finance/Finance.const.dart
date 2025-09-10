import 'package:flutter_tiyu_app/kernel/utils/bet_history_config.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';

enum BetStatus { success, fail, pending }

enum GameResult { win, lose }

enum DateTypeEnum {
  today, // 今日
  yesterday, // 昨日
  weekly, // 近7日
  monthly, // 本月
  custom, // 自定义
}

DateTime dateTimeNow() {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    23,
    59,
    59,
  );
}

DateTime dateTimeNowBy(int d) {
  return DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
    0,
    0,
    0,
  ).subtract(Duration(days: d)); // 开始日期（d天前）
}

List<DateTime> dateTimeBy = [
  DateTime.now(), // 现在(今天)
  dateTimeNowBy(1), // 昨天
  dateTimeNowBy(7), // 一周（7天）
  dateTimeNowBy(31), // 本月（31天）
  dateTimeNowBy(30), // 本月（30天）
  dateTimeNowBy(28), // 本月（28天）
];

class CommissionItem {
  final double total; // 总佣金
  final double direct; // 直属佣金
  final double others; // 其他佣金
  final DateTime settledAt; // 结算时间

  CommissionItem({
    required this.total,
    required this.direct,
    required this.others,
    required this.settledAt,
  });
}

class DayGroup {
  final DateTime day;
  final List<AgentRecord> items;
  DayGroup(this.day, this.items);
  num get subtotal => items.fold<num>(0, (a, b) => a + b.delta);
}

class AgentRecord {
  final String relation; // 例如：(直属) 7848121
  final num delta; // 例如：+2312.00
  final DateTime time;
  AgentRecord(
      {required this.relation, required this.delta, required this.time});
}

class BetHistoryRecord {
  final String orderNo;
  final String memberId;
  final String gameName;
  final String playTypeId;
  final String gameTypeId;
  final double amount;
  final DateTime betTime;
  final BetStatus status;
  final GameResult result;

  const BetHistoryRecord({
    required this.orderNo,
    required this.memberId,
    required this.gameName,
    required this.playTypeId,
    required this.gameTypeId,
    required this.amount,
    required this.betTime,
    required this.status,
    required this.result,
  });

  factory BetHistoryRecord.fromJson(Map<String, dynamic> json) {
    // 用 GameUtils + BetHistoryConfig 统一转换
    Map<String, dynamic>? play =
        GameUtils.getPlayInfo('${json['play_type_id']}');

    var playTypeId =
        play != null ? play['play_cname'] : '${json['play_type_id']}';

    var historyData = BetHistoryConfig.formatValue(
      playTypeId: playTypeId,
      item: json,
    );

    return BetHistoryRecord(
      orderNo: json['order_no'] ?? '',
      memberId: json['member_id'] ?? '',
      gameName: json['game_name'] ?? '',
      playTypeId: playTypeId,
      gameTypeId: historyData['gameTypeId'] != ''
          ? historyData['gameTypeId']
          : '${json['play_type_id']}',
      amount: double.tryParse('${json['amount']}') ?? 0.0,
      betTime: DateTime.tryParse('${json['bet_time']}') ??
          DateTime.fromMillisecondsSinceEpoch(json['bet_time'] ?? 0),
      status: json['status'] ?? '',
      result: GameResult.win,
    );
  }
}

class RecordQuery {
  final String? memberId;
  final String? gameCategory;
  const RecordQuery({this.memberId, this.gameCategory});
}

class ProfitRecordItem {
  final double totalPerformance; // 总业绩
  final double directPerformance; // 直属业绩
  final double otherPerformance; // 其他业绩
  final DateTime calculationTime; // 计算时间

  ProfitRecordItem({
    required this.totalPerformance,
    required this.directPerformance,
    required this.otherPerformance,
    required this.calculationTime,
  });
}

class MemberRecordItem {
  final double usrID; // 会员ID
  final double profitAndLoss; // 投注赢亏
  final double amount; // 下注流水
  final double totalCommission; // 累计提成
  final DateTime registerTime; // 注册时间

  MemberRecordItem({
    required this.usrID,
    required this.profitAndLoss,
    required this.amount,
    required this.totalCommission,
    required this.registerTime,
  });
}

class RechargeRecordItem {
  final String usrID; // 会员ID
  final String rechargeStyle; // 充值方式
  final String rechargeValue; // 充值金额
  final String rechargeTime; // 充值时间

  RechargeRecordItem({
    required this.usrID,
    required this.rechargeStyle,
    required this.rechargeValue,
    required this.rechargeTime,
  });
}

class WithdrawRecordItem {
  final String usrID; // 会员ID
  final String withdrawStatus; // 状态
  final String withdrawValue; // 提现金额
  final String withdrawTime; // 申请时间

  WithdrawRecordItem({
    required this.usrID,
    required this.withdrawStatus,
    required this.withdrawValue,
    required this.withdrawTime,
  });
}
