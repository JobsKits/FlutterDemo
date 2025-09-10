import 'package:flutter_tiyu_app/app/modules/activity/data/lucky_bet_model/elot_activity_pg.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lucky_bet_model.g.dart';

@JsonSerializable()
class LuckyBetModel {
  int? id;
  @JsonKey(name: 'fortune_id')
  final int? fortuneId;
  @JsonKey(name: 'game_type')
  final int? gameType;
  @JsonKey(name: 'game_name')
  final String? gameName;
  @JsonKey(name: 'tail_num')
  final String? tailNum;
  @JsonKey(name: 'lowest_award_amount')
  final int? lowestAwardAmount;
  @JsonKey(name: 'award_type')
  final int? awardType;
  @JsonKey(name: 'award_amount')
  final int? awardAmount;
  @JsonKey(name: 'marking_multix')
  final int? markingMultix;
  @JsonKey(name: 'grant_type')
  final int? grantType;
  int? state;
  @JsonKey(name: 'begin_time')
  final int? beginTime;
  @JsonKey(name: 'end_time')
  final int? endTime;
  @JsonKey(name: 'd_begin_time')
  final int? dBeginTime;
  @JsonKey(name: 'd_end_time')
  final int? dEndTime;
  final int? tid;
  @JsonKey(name: 'detail_content')
  final String? detailContent;
  @JsonKey(name: 'ip_limit')
  final int? ipLimit;
  @JsonKey(name: 'phone_limit')
  final int? phoneLimit;
  @JsonKey(name: 'vip_limit')
  final int? vipLimit;
  @JsonKey(name: 'reward_type')
  final int? rewardType;
  final int? quota;
  @JsonKey(name: 'restriction_type')
  final int? restrictionType;
  @JsonKey(name: 'type_recharges')
  final String? typeRecharges;
  @JsonKey(name: 'type_plays')
  final String? typePlays;
  @JsonKey(name: 'times_limit')
  final int? timesLimit;
  @JsonKey(name: 'times_limit_total')
  final int? timesLimitTotal;
  @JsonKey(name: 'activity_rule')
  final String? activityRule;
  @JsonKey(name: 'isShowDetailTime')
  final String? isShowDetailTime;
  @JsonKey(name: 'show_time')
  final int? showTime;
  final dynamic elotActivityPg;

  LuckyBetModel({
    this.id,
    this.fortuneId,
    this.gameType,
    this.gameName,
    this.tailNum,
    this.lowestAwardAmount,
    this.awardType,
    this.awardAmount,
    this.markingMultix,
    this.grantType,
    this.state,
    this.beginTime,
    this.endTime,
    this.dBeginTime,
    this.dEndTime,
    this.tid,
    this.detailContent,
    this.ipLimit,
    this.phoneLimit,
    this.vipLimit,
    this.rewardType,
    this.quota,
    this.restrictionType,
    this.typeRecharges,
    this.typePlays,
    this.timesLimit,
    this.timesLimitTotal,
    this.activityRule,
    this.isShowDetailTime,
    this.showTime,
    this.elotActivityPg,
  });

  factory LuckyBetModel.fromJson(Map<String, dynamic> json) {
    return _$LuckyBetModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$LuckyBetModelToJson(this);

  LuckyBetModel copyWith({
    int? id,
    int? fortuneId,
    int? gameType,
    String? gameName,
    String? tailNum,
    int? lowestAwardAmount,
    int? awardType,
    int? awardAmount,
    int? markingMultix,
    int? grantType,
    int? state,
    int? beginTime,
    int? endTime,
    int? dBeginTime,
    int? dEndTime,
    int? tid,
    String? detailContent,
    int? ipLimit,
    int? phoneLimit,
    int? vipLimit,
    int? rewardType,
    int? quota,
    int? restrictionType,
    String? typeRecharges,
    String? typePlays,
    int? timesLimit,
    int? timesLimitTotal,
    String? activityRule,
    String? isShowDetailTime,
    int? showTime,
    dynamic elotActivityPg,
  }) {
    return LuckyBetModel(
      id: id ?? this.id,
      fortuneId: fortuneId ?? this.fortuneId,
      gameType: gameType ?? this.gameType,
      gameName: gameName ?? this.gameName,
      tailNum: tailNum ?? this.tailNum,
      lowestAwardAmount: lowestAwardAmount ?? this.lowestAwardAmount,
      awardType: awardType ?? this.awardType,
      awardAmount: awardAmount ?? this.awardAmount,
      markingMultix: markingMultix ?? this.markingMultix,
      grantType: grantType ?? this.grantType,
      state: state ?? this.state,
      beginTime: beginTime ?? this.beginTime,
      endTime: endTime ?? this.endTime,
      dBeginTime: dBeginTime ?? this.dBeginTime,
      dEndTime: dEndTime ?? this.dEndTime,
      tid: tid ?? this.tid,
      detailContent: detailContent ?? this.detailContent,
      ipLimit: ipLimit ?? this.ipLimit,
      phoneLimit: phoneLimit ?? this.phoneLimit,
      vipLimit: vipLimit ?? this.vipLimit,
      rewardType: rewardType ?? this.rewardType,
      quota: quota ?? this.quota,
      restrictionType: restrictionType ?? this.restrictionType,
      typeRecharges: typeRecharges ?? this.typeRecharges,
      typePlays: typePlays ?? this.typePlays,
      timesLimit: timesLimit ?? this.timesLimit,
      timesLimitTotal: timesLimitTotal ?? this.timesLimitTotal,
      activityRule: activityRule ?? this.activityRule,
      isShowDetailTime: isShowDetailTime ?? this.isShowDetailTime,
      showTime: showTime ?? this.showTime,
      elotActivityPg: elotActivityPg ?? this.elotActivityPg,
    );
  }
}
