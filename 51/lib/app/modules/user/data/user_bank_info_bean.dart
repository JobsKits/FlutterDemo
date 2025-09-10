class UserBankInfoBean {
  UserBankInfoBean({
    this.payInfoId,
    this.custId,
    this.payOrgId,
    this.state,
    this.tid,
    this.sortV,
    required this.isBind,
    required this.cut,
    this.nums,
    this.payOrgName,
    this.payName,
    this.payNo,
  });

  UserBankInfoBean.fromJson(dynamic json) {
    payInfoId = json['pay_info_id'];
    custId = json['cust_id'];
    payOrgId = json['pay_org_id'];
    state = json['state'];
    tid = json['tid'];
    sortV = json['sort_v'];
    isBind = json['is_bind'];
    cut = json['cut'];
    nums = json['num'];
    payOrgName = json['pay_org_name'];
    payName = json['pay_name'];
    payNo = json['pay_no'];
  }
  num? payInfoId;
  num? custId;
  num? payOrgId;
  num? state;
  num? tid;
  num? sortV;
  late int isBind;
  late int cut;
  String? payOrgName;
  String? payName;
  String? payNo;
  num? nums;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pay_info_id'] = payInfoId;
    map['cust_id'] = custId;
    map['pay_org_id'] = payOrgId;
    map['state'] = state;
    map['tid'] = tid;
    map['sort_v'] = sortV;
    map['is_bind'] = isBind;
    map['cut'] = cut;
    map['num'] = nums;
    return map;
  }

  @override
  String toString() {
    return 'UserBankInfoBean{payInfoId: $payInfoId, custId: $custId, payOrgId: $payOrgId, state: $state, tid: $tid, sortV: $sortV, isBind: $isBind, cut: $cut, payOrgName: $payOrgName, payName: $payName, payNo: $payNo, nums: $nums}';
  }
}
