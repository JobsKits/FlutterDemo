// GENERATED CODE - DO NOT MODIFY BY HAND

part of 't.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

T _$TFromJson(Map<String, dynamic> json) => T(
      myOrderNo: json['myOrderNo'] as String?,
      myAwardAmount: json['myAwardAmount'] as String?,
      myRankAmount: (json['myRankAmount'] as num?)?.toInt(),
      rankWay: (json['rankWay'] as num?)?.toInt(),
      myOrderNoLastTime: json['myOrderNoLastTime'] as String?,
      myAwardAmountLastTime: (json['myAwardAmountLastTime'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TToJson(T instance) => <String, dynamic>{
      'myOrderNo': instance.myOrderNo,
      'myAwardAmount': instance.myAwardAmount,
      'myRankAmount': instance.myRankAmount,
      'rankWay': instance.rankWay,
      'myOrderNoLastTime': instance.myOrderNoLastTime,
      'myAwardAmountLastTime': instance.myAwardAmountLastTime,
    };
