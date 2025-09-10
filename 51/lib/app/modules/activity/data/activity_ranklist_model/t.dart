import 'package:json_annotation/json_annotation.dart';

part 't.g.dart';

@JsonSerializable()
class T {
  String? myOrderNo;
  String? myAwardAmount;
  int? myRankAmount;
  int? rankWay;
  String? myOrderNoLastTime;
  int? myAwardAmountLastTime;

  T({
    this.myOrderNo,
    this.myAwardAmount,
    this.myRankAmount,
    this.rankWay,
    this.myOrderNoLastTime,
    this.myAwardAmountLastTime,
  });

  @override
  String toString() {
    return 'T(myOrderNo: $myOrderNo, myAwardAmount: $myAwardAmount, myRankAmount: $myRankAmount, rankWay: $rankWay, myOrderNoLastTime: $myOrderNoLastTime, myAwardAmountLastTime: $myAwardAmountLastTime)';
  }

  factory T.fromJson(Map<String, dynamic> json) => _$TFromJson(json);

  Map<String, dynamic> toJson() => _$TToJson(this);

  T copyWith({
    String? myOrderNo,
    String? myAwardAmount,
    int? myRankAmount,
    int? rankWay,
    String? myOrderNoLastTime,
    int? myAwardAmountLastTime,
  }) {
    return T(
      myOrderNo: myOrderNo ?? this.myOrderNo,
      myAwardAmount: myAwardAmount ?? this.myAwardAmount,
      myRankAmount: myRankAmount ?? this.myRankAmount,
      rankWay: rankWay ?? this.rankWay,
      myOrderNoLastTime: myOrderNoLastTime ?? this.myOrderNoLastTime,
      myAwardAmountLastTime:
          myAwardAmountLastTime ?? this.myAwardAmountLastTime,
    );
  }
}
