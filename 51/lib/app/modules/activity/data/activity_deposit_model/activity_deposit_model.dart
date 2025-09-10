import 'package:json_annotation/json_annotation.dart';

part 'activity_deposit_model.g.dart';

@JsonSerializable()
class ActivityDepositModel {
  @JsonKey(name: 'aseq_id')
  int? aseqId;
  int? tid;
  @JsonKey(name: 'pay_org_id')
  int? payOrgId;
  String? currency;
  int? cat;
  String? name;
  int? type;
  @JsonKey(name: 'sort_v')
  int? sortV;
  @JsonKey(name: 'icon_url')
  String? iconUrl;
  @JsonKey(name: 'acct_type')
  String? acctType;
  @JsonKey(name: 'acct_desc')
  String? acctDesc;
  int? state;
  @JsonKey(name: 'state_time')
  int? stateTime;
  @JsonKey(name: 'create_time')
  int? createTime;
  String? describeinfo;
  @JsonKey(name: 'blank_code')
  String? blankCode;
  @JsonKey(name: 'is_show')
  int? isShow;
  int? mark;
  @JsonKey(name: 'withdraw_type')
  int? withdrawType;
  @JsonKey(name: 'show_flag')
  int? showFlag;
  @JsonKey(name: 'pay_offline_percentage_of_yards')
  int? payOfflinePercentageOfYards;
  @JsonKey(name: 'pay_org_name')
  String? payOrgName;
  String? operLogStr;

  ActivityDepositModel({
    this.aseqId,
    this.tid,
    this.payOrgId,
    this.currency,
    this.cat,
    this.name,
    this.type,
    this.sortV,
    this.iconUrl,
    this.acctType,
    this.acctDesc,
    this.state,
    this.stateTime,
    this.createTime,
    this.describeinfo,
    this.blankCode,
    this.isShow,
    this.mark,
    this.withdrawType,
    this.showFlag,
    this.payOfflinePercentageOfYards,
    this.payOrgName,
    this.operLogStr,
  });

  @override
  String toString() {
    return 'ActivityDepositModel(aseqId: $aseqId, tid: $tid, payOrgId: $payOrgId, currency: $currency, cat: $cat, name: $name, type: $type, sortV: $sortV, iconUrl: $iconUrl, acctType: $acctType, acctDesc: $acctDesc, state: $state, stateTime: $stateTime, createTime: $createTime, describeinfo: $describeinfo, blankCode: $blankCode, isShow: $isShow, mark: $mark, withdrawType: $withdrawType, showFlag: $showFlag, payOfflinePercentageOfYards: $payOfflinePercentageOfYards, payOrgName: $payOrgName, operLogStr: $operLogStr)';
  }

  factory ActivityDepositModel.fromJson(Map<String, dynamic> json) {
    return _$ActivityDepositModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ActivityDepositModelToJson(this);

  ActivityDepositModel copyWith({
    int? aseqId,
    int? tid,
    int? payOrgId,
    String? currency,
    int? cat,
    String? name,
    int? type,
    int? sortV,
    String? iconUrl,
    String? acctType,
    String? acctDesc,
    int? state,
    int? stateTime,
    int? createTime,
    String? describeinfo,
    String? blankCode,
    int? isShow,
    int? mark,
    int? withdrawType,
    int? showFlag,
    int? payOfflinePercentageOfYards,
    String? payOrgName,
    String? operLogStr,
  }) {
    return ActivityDepositModel(
      aseqId: aseqId ?? this.aseqId,
      tid: tid ?? this.tid,
      payOrgId: payOrgId ?? this.payOrgId,
      currency: currency ?? this.currency,
      cat: cat ?? this.cat,
      name: name ?? this.name,
      type: type ?? this.type,
      sortV: sortV ?? this.sortV,
      iconUrl: iconUrl ?? this.iconUrl,
      acctType: acctType ?? this.acctType,
      acctDesc: acctDesc ?? this.acctDesc,
      state: state ?? this.state,
      stateTime: stateTime ?? this.stateTime,
      createTime: createTime ?? this.createTime,
      describeinfo: describeinfo ?? this.describeinfo,
      blankCode: blankCode ?? this.blankCode,
      isShow: isShow ?? this.isShow,
      mark: mark ?? this.mark,
      withdrawType: withdrawType ?? this.withdrawType,
      showFlag: showFlag ?? this.showFlag,
      payOfflinePercentageOfYards:
          payOfflinePercentageOfYards ?? this.payOfflinePercentageOfYards,
      payOrgName: payOrgName ?? this.payOrgName,
      operLogStr: operLogStr ?? this.operLogStr,
    );
  }
}
