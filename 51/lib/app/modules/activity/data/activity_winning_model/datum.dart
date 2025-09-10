import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  @JsonKey(name: 'fortune_plan_id')
  int? fortunePlanId;
  @JsonKey(name: 'game_type')
  int? gameType;
  @JsonKey(name: 'play_plan_id')
  String? playPlanId;
  @JsonKey(name: 'play_plan_amount')
  int? playPlanAmount;
  @JsonKey(name: 'award_amount')
  int? awardAmount;
  @JsonKey(name: 'award_time')
  int? awardTime;
  @JsonKey(name: 'fortune_id')
  int? fortuneId;
  @JsonKey(name: 'play_name')
  String? playName;
  @JsonKey(name: 'cplay_name')
  String? cplayName;
  @JsonKey(name: 'fortune_amount')
  int? fortuneAmount;
  int? state;
  @JsonKey(name: 'tail_num')
  String? tailNum;
  @JsonKey(name: 'cust_id')
  int? custId;
  @JsonKey(name: 'create_time')
  int? createTime;
  int? tid;
  @JsonKey(name: 'get_award_time')
  int? getAwardTime;
  @JsonKey(name: 'part_mon')
  int? partMon;
  String? ip;
  String? phone;
  @JsonKey(name: 'play_id')
  int? playId;
  @JsonKey(name: 'grant_type')
  int? grantType;
  @JsonKey(name: 'platform_order_id')
  String? platformOrderId;

  Datum({
    this.fortunePlanId,
    this.gameType,
    this.playPlanId,
    this.playPlanAmount,
    this.awardAmount,
    this.awardTime,
    this.fortuneId,
    this.playName,
    this.cplayName,
    this.fortuneAmount,
    this.state,
    this.tailNum,
    this.custId,
    this.createTime,
    this.tid,
    this.getAwardTime,
    this.partMon,
    this.ip,
    this.phone,
    this.playId,
    this.grantType,
    this.platformOrderId,
  });

  @override
  String toString() {
    return 'Datum(fortunePlanId: $fortunePlanId, gameType: $gameType, playPlanId: $playPlanId, playPlanAmount: $playPlanAmount, awardAmount: $awardAmount, awardTime: $awardTime, fortuneId: $fortuneId, playName: $playName, cplayName: $cplayName, fortuneAmount: $fortuneAmount, state: $state, tailNum: $tailNum, custId: $custId, createTime: $createTime, tid: $tid, getAwardTime: $getAwardTime, partMon: $partMon, ip: $ip, phone: $phone, playId: $playId, grantType: $grantType, platformOrderId: $platformOrderId)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? fortunePlanId,
    int? gameType,
    String? playPlanId,
    int? playPlanAmount,
    int? awardAmount,
    int? awardTime,
    int? fortuneId,
    String? playName,
    String? cplayName,
    int? fortuneAmount,
    int? state,
    String? tailNum,
    int? custId,
    int? createTime,
    int? tid,
    int? getAwardTime,
    int? partMon,
    String? ip,
    String? phone,
    int? playId,
    int? grantType,
    String? platformOrderId,
  }) {
    return Datum(
      fortunePlanId: fortunePlanId ?? this.fortunePlanId,
      gameType: gameType ?? this.gameType,
      playPlanId: playPlanId ?? this.playPlanId,
      playPlanAmount: playPlanAmount ?? this.playPlanAmount,
      awardAmount: awardAmount ?? this.awardAmount,
      awardTime: awardTime ?? this.awardTime,
      fortuneId: fortuneId ?? this.fortuneId,
      playName: playName ?? this.playName,
      cplayName: cplayName ?? this.cplayName,
      fortuneAmount: fortuneAmount ?? this.fortuneAmount,
      state: state ?? this.state,
      tailNum: tailNum ?? this.tailNum,
      custId: custId ?? this.custId,
      createTime: createTime ?? this.createTime,
      tid: tid ?? this.tid,
      getAwardTime: getAwardTime ?? this.getAwardTime,
      partMon: partMon ?? this.partMon,
      ip: ip ?? this.ip,
      phone: phone ?? this.phone,
      playId: playId ?? this.playId,
      grantType: grantType ?? this.grantType,
      platformOrderId: platformOrderId ?? this.platformOrderId,
    );
  }
}
