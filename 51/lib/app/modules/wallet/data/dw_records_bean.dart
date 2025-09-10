class DwRecordsBean {
  DwRecordsBean({
    this.id,
    this.custCode,
    this.deposit,
    this.status,
    this.createTime,
    this.successTime,
    this.sourcetype,
    this.custId,
    this.acctId,
    this.balanceTypeId,
    this.cmoney,
    this.planId,
    this.innerStatus,
    this.queryStatus,
    this.queryCount,
    this.ugi,
    this.offerId,
    this.partMon,
    this.tid,
    this.handFee,
    this.thirdFee,
    this.orderNo,
    this.sourcetypeName,
    this.originalAmount,
    this.realAmount,
    this.groupId,
    this.isCharge,
    this.fictFlag,
    this.partnerId,
    this.numberType,
    this.rate,
    this.custLevel,
    this.accountType,
    this.payType,
    this.frontStatus,
    this.chgCurr,
    this.custPayName,
  });

  DwRecordsBean.fromJson(dynamic json) {
    id = json['id'];
    custCode = json['cust_code'];
    deposit = json['deposit'];
    status = json['status'];
    createTime = json['create_time'];
    successTime = json['success_time'];
    sourcetype = json['sourcetype'];
    custId = json['cust_id'];
    acctId = json['acct_id'];
    balanceTypeId = json['balance_type_id'];
    cmoney = json['cmoney'];
    planId = json['plan_id'];
    innerStatus = json['inner_status'];
    queryStatus = json['query_status'];
    queryCount = json['query_count'];
    ugi = json['ugi'];
    offerId = json['offer_id'];
    partMon = json['part_mon'];
    tid = json['tid'];
    handFee = json['hand_fee'];
    thirdFee = json['third_fee'];
    orderNo = json['orderNo'];
    sourcetypeName = json['sourcetype_name'];
    originalAmount = json['original_amount'];
    realAmount = json['real_amount'];
    groupId = json['group_id'];
    isCharge = json['is_charge'];
    fictFlag = json['fict_flag'];
    partnerId = json['partner_id'];
    numberType = json['number_type'];
    rate = json['rate'];
    custLevel = json['cust_level'];
    accountType = json['account_type'];
    payType = json['pay_type'];
    frontStatus = json['front_status'];
    chgCurr = json['chgCurr'];
    custPayName = json['cust_pay_name'];
    remark = json['remark'];
  }
  num? id;
  String? custCode;
  num? deposit;
  String? status;
  num? createTime;
  num? successTime;
  String? sourcetype;
  num? custId;
  num? acctId;
  num? balanceTypeId;
  num? cmoney;
  num? planId;
  num? innerStatus;
  num? queryStatus;
  num? queryCount;
  num? ugi;
  num? offerId;
  num? partMon;
  num? tid;
  num? handFee;
  num? thirdFee;
  String? orderNo;
  String? sourcetypeName;
  num? originalAmount;
  num? realAmount;
  num? groupId;
  num? isCharge;
  num? fictFlag;
  num? partnerId;
  num? numberType;
  num? rate;
  num? custLevel;
  num? accountType;
  num? payType;
  num? frontStatus;
  String? chgCurr;
  String? custPayName;
  String? remark;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cust_code'] = custCode;
    map['deposit'] = deposit;
    map['status'] = status;
    map['create_time'] = createTime;
    map['success_time'] = successTime;
    map['sourcetype'] = sourcetype;
    map['cust_id'] = custId;
    map['acct_id'] = acctId;
    map['balance_type_id'] = balanceTypeId;
    map['cmoney'] = cmoney;
    map['plan_id'] = planId;
    map['inner_status'] = innerStatus;
    map['query_status'] = queryStatus;
    map['query_count'] = queryCount;
    map['ugi'] = ugi;
    map['offer_id'] = offerId;
    map['part_mon'] = partMon;
    map['tid'] = tid;
    map['hand_fee'] = handFee;
    map['third_fee'] = thirdFee;
    map['orderNo'] = orderNo;
    map['sourcetype_name'] = sourcetypeName;
    map['original_amount'] = originalAmount;
    map['real_amount'] = realAmount;
    map['group_id'] = groupId;
    map['is_charge'] = isCharge;
    map['fict_flag'] = fictFlag;
    map['partner_id'] = partnerId;
    map['number_type'] = numberType;
    map['rate'] = rate;
    map['cust_level'] = custLevel;
    map['account_type'] = accountType;
    map['pay_type'] = payType;
    map['front_status'] = frontStatus;
    map['chgCurr'] = chgCurr;
    map['cust_pay_name'] = custPayName;
    map['remark'] = remark;
    return map;
  }

  @override
  String toString() {
    return 'DwRecordsBean{id: $id, custCode: $custCode, deposit: $deposit, status: $status, createTime: $createTime, successTime: $successTime, sourcetype: $sourcetype, custId: $custId, acctId: $acctId, balanceTypeId: $balanceTypeId, cmoney: $cmoney, planId: $planId, innerStatus: $innerStatus, queryStatus: $queryStatus, queryCount: $queryCount, ugi: $ugi, offerId: $offerId, partMon: $partMon, tid: $tid, handFee: $handFee, thirdFee: $thirdFee, orderNo: $orderNo, sourcetypeName: $sourcetypeName, originalAmount: $originalAmount, realAmount: $realAmount, groupId: $groupId, isCharge: $isCharge, fictFlag: $fictFlag, partnerId: $partnerId, numberType: $numberType, rate: $rate, custLevel: $custLevel, accountType: $accountType, payType: $payType, frontStatus: $frontStatus, chgCurr: $chgCurr, custPayName: $custPayName}';
  }
}
