import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  int? tid;
  int? aid;
  int? acctId;
  String? account;
  String? activityName;
  String? awardName;
  String? awardAmount;
  int? chargeAmount;
  int? rankWay;

  Datum({
    this.tid,
    this.aid,
    this.acctId,
    this.account,
    this.activityName,
    this.awardName,
    this.awardAmount,
    this.chargeAmount,
    this.rankWay,
  });

  @override
  String toString() {
    return 'Datum(tid: $tid, aid: $aid, acctId: $acctId, account: $account, activityName: $activityName, awardName: $awardName, awardAmount: $awardAmount, chargeAmount: $chargeAmount, rankWay: $rankWay)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? tid,
    int? aid,
    int? acctId,
    String? account,
    String? activityName,
    String? awardName,
    String? awardAmount,
    int? chargeAmount,
    int? rankWay,
  }) {
    return Datum(
      tid: tid ?? this.tid,
      aid: aid ?? this.aid,
      acctId: acctId ?? this.acctId,
      account: account ?? this.account,
      activityName: activityName ?? this.activityName,
      awardName: awardName ?? this.awardName,
      awardAmount: awardAmount ?? this.awardAmount,
      chargeAmount: chargeAmount ?? this.chargeAmount,
      rankWay: rankWay ?? this.rankWay,
    );
  }
}
