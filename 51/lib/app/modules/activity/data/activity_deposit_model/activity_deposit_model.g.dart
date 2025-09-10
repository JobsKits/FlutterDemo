// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_deposit_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActivityDepositModel _$ActivityDepositModelFromJson(
        Map<String, dynamic> json) =>
    ActivityDepositModel(
      aseqId: (json['aseq_id'] as num?)?.toInt(),
      tid: (json['tid'] as num?)?.toInt(),
      payOrgId: (json['pay_org_id'] as num?)?.toInt(),
      currency: json['currency'] as String?,
      cat: (json['cat'] as num?)?.toInt(),
      name: json['name'] as String?,
      type: (json['type'] as num?)?.toInt(),
      sortV: (json['sort_v'] as num?)?.toInt(),
      iconUrl: json['icon_url'] as String?,
      acctType: json['acct_type'] as String?,
      acctDesc: json['acct_desc'] as String?,
      state: (json['state'] as num?)?.toInt(),
      stateTime: (json['state_time'] as num?)?.toInt(),
      createTime: (json['create_time'] as num?)?.toInt(),
      describeinfo: json['describeinfo'] as String?,
      blankCode: json['blank_code'] as String?,
      isShow: (json['is_show'] as num?)?.toInt(),
      mark: (json['mark'] as num?)?.toInt(),
      withdrawType: (json['withdraw_type'] as num?)?.toInt(),
      showFlag: (json['show_flag'] as num?)?.toInt(),
      payOfflinePercentageOfYards:
          (json['pay_offline_percentage_of_yards'] as num?)?.toInt(),
      payOrgName: json['pay_org_name'] as String?,
      operLogStr: json['operLogStr'] as String?,
    );

Map<String, dynamic> _$ActivityDepositModelToJson(
        ActivityDepositModel instance) =>
    <String, dynamic>{
      'aseq_id': instance.aseqId,
      'tid': instance.tid,
      'pay_org_id': instance.payOrgId,
      'currency': instance.currency,
      'cat': instance.cat,
      'name': instance.name,
      'type': instance.type,
      'sort_v': instance.sortV,
      'icon_url': instance.iconUrl,
      'acct_type': instance.acctType,
      'acct_desc': instance.acctDesc,
      'state': instance.state,
      'state_time': instance.stateTime,
      'create_time': instance.createTime,
      'describeinfo': instance.describeinfo,
      'blank_code': instance.blankCode,
      'is_show': instance.isShow,
      'mark': instance.mark,
      'withdraw_type': instance.withdrawType,
      'show_flag': instance.showFlag,
      'pay_offline_percentage_of_yards': instance.payOfflinePercentageOfYards,
      'pay_org_name': instance.payOrgName,
      'operLogStr': instance.operLogStr,
    };
