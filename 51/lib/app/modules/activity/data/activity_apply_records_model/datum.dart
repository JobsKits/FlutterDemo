import 'package:json_annotation/json_annotation.dart';

part 'datum.g.dart';

@JsonSerializable()
class Datum {
  int? id;
  int? tid;
  int? aid;
  String? activityName;
  int? activityStartTime;
  int? activityEndTime;
  int? acctId;
  String? account;
  String? applyDeviceType;
  String? applyIp;
  String? applyDevice;
  int? applyTime;
  String? applyText;
  String? status;
  @JsonKey(name: 'cust_id')
  int? custId;
  @JsonKey(name: 'cust_name')
  String? custName;
  String? answer;
  int? amount;
  String? remark1;
  String? remark2;

  Datum({
    this.id,
    this.tid,
    this.aid,
    this.activityName,
    this.activityStartTime,
    this.activityEndTime,
    this.acctId,
    this.account,
    this.applyDeviceType,
    this.applyIp,
    this.applyDevice,
    this.applyTime,
    this.applyText,
    this.status,
    this.custId,
    this.custName,
    this.answer,
    this.amount,
    this.remark1,
    this.remark2,
  });

  @override
  String toString() {
    return 'Datum(id: $id, tid: $tid, aid: $aid, activityName: $activityName, activityStartTime: $activityStartTime, activityEndTime: $activityEndTime, acctId: $acctId, account: $account, applyDeviceType: $applyDeviceType, applyIp: $applyIp, applyDevice: $applyDevice, applyTime: $applyTime, applyText: $applyText, status: $status, custId: $custId, custName: $custName, answer: $answer, amount: $amount, remark1: $remark1, remark2: $remark2)';
  }

  factory Datum.fromJson(Map<String, dynamic> json) => _$DatumFromJson(json);

  Map<String, dynamic> toJson() => _$DatumToJson(this);

  Datum copyWith({
    int? id,
    int? tid,
    int? aid,
    String? activityName,
    int? activityStartTime,
    int? activityEndTime,
    int? acctId,
    String? account,
    String? applyDeviceType,
    String? applyIp,
    String? applyDevice,
    int? applyTime,
    String? applyText,
    String? status,
    int? custId,
    String? custName,
    String? answer,
    int? amount,
    String? remark1,
    String? remark2,
  }) {
    return Datum(
      id: id ?? this.id,
      tid: tid ?? this.tid,
      aid: aid ?? this.aid,
      activityName: activityName ?? this.activityName,
      activityStartTime: activityStartTime ?? this.activityStartTime,
      activityEndTime: activityEndTime ?? this.activityEndTime,
      acctId: acctId ?? this.acctId,
      account: account ?? this.account,
      applyDeviceType: applyDeviceType ?? this.applyDeviceType,
      applyIp: applyIp ?? this.applyIp,
      applyDevice: applyDevice ?? this.applyDevice,
      applyTime: applyTime ?? this.applyTime,
      applyText: applyText ?? this.applyText,
      status: status ?? this.status,
      custId: custId ?? this.custId,
      custName: custName ?? this.custName,
      answer: answer ?? this.answer,
      amount: amount ?? this.amount,
      remark1: remark1 ?? this.remark1,
      remark2: remark2 ?? this.remark2,
    );
  }
}
