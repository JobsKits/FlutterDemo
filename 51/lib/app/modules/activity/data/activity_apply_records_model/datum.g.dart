// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Datum _$DatumFromJson(Map<String, dynamic> json) => Datum(
      id: (json['id'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      aid: (json['aid'] as num?)?.toInt(),
      activityName: json['activityName'] as String?,
      activityStartTime: (json['activityStartTime'] as num?)?.toInt(),
      activityEndTime: (json['activityEndTime'] as num?)?.toInt(),
      acctId: (json['acctId'] as num?)?.toInt(),
      account: json['account'] as String?,
      applyDeviceType: json['applyDeviceType'] as String?,
      applyIp: json['applyIp'] as String?,
      applyDevice: json['applyDevice'] as String?,
      applyTime: (json['applyTime'] as num?)?.toInt(),
      applyText: json['applyText'] as String?,
      status: json['status'] as String?,
      custId: (json['cust_id'] as num?)?.toInt(),
      custName: json['cust_name'] as String?,
      answer: json['answer'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      remark1: json['remark1'] as String?,
      remark2: json['remark2'] as String?,
    );

Map<String, dynamic> _$DatumToJson(Datum instance) => <String, dynamic>{
      'id': instance.id,
      'tid': instance.tid,
      'aid': instance.aid,
      'activityName': instance.activityName,
      'activityStartTime': instance.activityStartTime,
      'activityEndTime': instance.activityEndTime,
      'acctId': instance.acctId,
      'account': instance.account,
      'applyDeviceType': instance.applyDeviceType,
      'applyIp': instance.applyIp,
      'applyDevice': instance.applyDevice,
      'applyTime': instance.applyTime,
      'applyText': instance.applyText,
      'status': instance.status,
      'cust_id': instance.custId,
      'cust_name': instance.custName,
      'answer': instance.answer,
      'amount': instance.amount,
      'remark1': instance.remark1,
      'remark2': instance.remark2,
    };
