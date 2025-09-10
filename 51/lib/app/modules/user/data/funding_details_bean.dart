class FundingDetailsBean {
  FundingDetailsBean({
    this.t,
    this.data,
    this.count,
  });

  FundingDetailsBean.fromJson(dynamic json) {
    t = json['t'] != null ? FundingTime.fromJson(json['t']) : null;
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(FundingData.fromJson(v));
      });
    }
    count = json['count'];
  }
  FundingTime? t;
  List<FundingData>? data;
  int? count;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (t != null) {
      map['t'] = t?.toJson();
    }
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['count'] = count;
    return map;
  }
}

class FundingData {
  FundingData({
    this.aseqId,
    this.acctId,
    this.chargeId,
    this.acctBalanceId,
    this.balanceTypeId,
    this.origTransSerial,
    this.origTransDatetime,
    this.transSerial,
    this.transDatetime,
    this.transType,
    this.busiType,
    this.totalAmount,
    this.genAmount,
    this.balance, //操作后余额
    this.freezeBalance, //操作后冻结余额
    this.chanCode,
    this.chanSerial,
    this.transFlag,
    this.succFlag,
    this.statCode,
    this.statMsg,
    this.remark,
    this.operCode,
    this.crtDatetime,
    this.updDatetime,
    this.partMon,
    this.tid,
    this.markingQuantity, //操作后打码量
    this.genMarking, //发生打码量
    this.origTransSerialS,
    this.zcyhAmount,
    this.qtyhAmount,
    this.czyhAmount,
    this.qdAmount,
    this.ksjyjAmount,
    this.czdlbAmount,
    this.ywjylAmount,
    this.zljAmount,
    this.jjcjAmount,
    this.r1Amount,
    this.hbyhbAmount,
    this.yflAmount,
    this.fxlqgzAmount,
    this.genMarking2,
    this.partDay,
    this.isTry,
    this.experienceGold,
    this.custId,
    this.busi_type_name,
  });

  FundingData.fromJson(dynamic json) {
    aseqId = json['aseq_id'];
    acctId = json['acct_id'];
    chargeId = json['charge_id'];
    acctBalanceId = json['acct_balance_id'];
    balanceTypeId = json['balance_type_id'];
    origTransSerial = json['orig_trans_serial'];
    origTransDatetime = json['orig_trans_datetime'];
    transSerial = json['trans_serial'];
    transDatetime = json['trans_datetime'];
    transType = json['trans_type'];
    busiType = json['busi_type'];
    totalAmount = json['total_amount'];
    genAmount = json['gen_amount'];
    balance = json['balance'];
    freezeBalance = json['freeze_balance'];
    chanCode = json['chan_code'];
    chanSerial = json['chan_serial'];
    transFlag = json['trans_flag'];
    succFlag = json['succ_flag'];
    statCode = json['stat_code'];
    statMsg = json['stat_msg'];
    remark = json['remark'];
    operCode = json['oper_code'];
    crtDatetime = json['crt_datetime'];
    updDatetime = json['upd_datetime'];
    partMon = json['part_mon'];
    tid = json['tid'];
    markingQuantity = json['marking_quantity'];
    genMarking = json['gen_marking'];
    origTransSerialS = json['orig_trans_serial_s'];
    zcyhAmount = json['zcyh_amount'];
    qtyhAmount = json['qtyh_amount'];
    czyhAmount = json['czyh_amount'];
    qdAmount = json['qd_amount'];
    ksjyjAmount = json['ksjyj_amount'];
    czdlbAmount = json['czdlb_amount'];
    ywjylAmount = json['ywjyl_amount'];
    zljAmount = json['zlj_amount'];
    jjcjAmount = json['jjcj_amount'];
    r1Amount = json['r1_amount'];
    hbyhbAmount = json['hbyhb_amount'];
    yflAmount = json['yfl_amount'];
    fxlqgzAmount = json['fxlqgz_amount'];
    genMarking2 = json['gen_marking2'];
    partDay = json['part_day'];
    isTry = json['is_try'];
    experienceGold = json['experience_gold'];
    custId = json['cust_id'];
    busi_type_name = json['busi_type_name'];
  }
  num? aseqId;
  num? acctId;
  num? chargeId;
  num? acctBalanceId;
  num? balanceTypeId;
  num? origTransSerial; //原交易流水
  num? origTransDatetime;
  num? transSerial; //交易流水
  num? transDatetime;
  String? transType; //交易类型
  String? busiType;
  num? totalAmount;
  num? genAmount;
  num? balance;
  num? freezeBalance;
  String? chanCode;
  num? chanSerial;
  String? transFlag;
  String? succFlag;
  String? statCode;
  String? statMsg;
  String? remark; //备注
  String? operCode;
  num? crtDatetime;
  num? updDatetime;
  num? partMon;
  num? tid;
  num? markingQuantity;
  num? genMarking;
  String? origTransSerialS;
  num? zcyhAmount;
  num? qtyhAmount;
  num? czyhAmount;
  num? qdAmount;
  num? ksjyjAmount;
  num? czdlbAmount;
  num? ywjylAmount;
  num? zljAmount;
  num? jjcjAmount;
  num? r1Amount;
  num? hbyhbAmount;
  num? yflAmount;
  num? fxlqgzAmount;
  num? genMarking2;
  num? partDay;
  num? isTry;
  num? experienceGold;
  num? custId;
  String? busi_type_name;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aseq_id'] = aseqId;
    map['acct_id'] = acctId;
    map['charge_id'] = chargeId;
    map['acct_balance_id'] = acctBalanceId;
    map['balance_type_id'] = balanceTypeId;
    map['orig_trans_serial'] = origTransSerial;
    map['orig_trans_datetime'] = origTransDatetime;
    map['trans_serial'] = transSerial;
    map['trans_datetime'] = transDatetime;
    map['trans_type'] = transType;
    map['busi_type'] = busiType;
    map['total_amount'] = totalAmount; //交易金币
    map['gen_amount'] = genAmount; //发生金币
    map['balance'] = balance;
    map['freeze_balance'] = freezeBalance;
    map['chan_code'] = chanCode;
    map['chan_serial'] = chanSerial;
    map['trans_flag'] = transFlag;
    map['succ_flag'] = succFlag;
    map['stat_code'] = statCode;
    map['stat_msg'] = statMsg;
    map['remark'] = remark;
    map['oper_code'] = operCode;
    map['crt_datetime'] = crtDatetime;
    map['upd_datetime'] = updDatetime;
    map['part_mon'] = partMon;
    map['tid'] = tid;
    map['marking_quantity'] = markingQuantity;
    map['gen_marking'] = genMarking;
    map['orig_trans_serial_s'] = origTransSerialS;
    map['zcyh_amount'] = zcyhAmount;
    map['qtyh_amount'] = qtyhAmount;
    map['czyh_amount'] = czyhAmount;
    map['qd_amount'] = qdAmount;
    map['ksjyj_amount'] = ksjyjAmount;
    map['czdlb_amount'] = czdlbAmount;
    map['ywjyl_amount'] = ywjylAmount;
    map['zlj_amount'] = zljAmount;
    map['jjcj_amount'] = jjcjAmount;
    map['r1_amount'] = r1Amount;
    map['hbyhb_amount'] = hbyhbAmount;
    map['yfl_amount'] = yflAmount;
    map['fxlqgz_amount'] = fxlqgzAmount;
    map['gen_marking2'] = genMarking2;
    map['part_day'] = partDay;
    map['is_try'] = isTry;
    map['experience_gold'] = experienceGold;
    map['cust_id'] = custId;
    map['busi_type_name'] = busi_type_name;
    return map;
  }

  @override
  String toString() {
    return 'FundingData{aseqId: $aseqId, acctId: $acctId, chargeId: $chargeId, acctBalanceId: $acctBalanceId, balanceTypeId: $balanceTypeId, origTransSerial: $origTransSerial, origTransDatetime: $origTransDatetime, transSerial: $transSerial, transDatetime: $transDatetime, transType: $transType, busiType: $busiType, totalAmount: $totalAmount, genAmount: $genAmount, balance: $balance, freezeBalance: $freezeBalance, chanCode: $chanCode, chanSerial: $chanSerial, transFlag: $transFlag, succFlag: $succFlag, statCode: $statCode, statMsg: $statMsg, remark: $remark, operCode: $operCode, crtDatetime: $crtDatetime, updDatetime: $updDatetime, partMon: $partMon, tid: $tid, markingQuantity: $markingQuantity, genMarking: $genMarking, origTransSerialS: $origTransSerialS, zcyhAmount: $zcyhAmount, qtyhAmount: $qtyhAmount, czyhAmount: $czyhAmount, qdAmount: $qdAmount, ksjyjAmount: $ksjyjAmount, czdlbAmount: $czdlbAmount, ywjylAmount: $ywjylAmount, zljAmount: $zljAmount, jjcjAmount: $jjcjAmount, r1Amount: $r1Amount, hbyhbAmount: $hbyhbAmount, yflAmount: $yflAmount, fxlqgzAmount: $fxlqgzAmount, genMarking2: $genMarking2, partDay: $partDay, isTry: $isTry, experienceGold: $experienceGold, custId: $custId, busi_type_name: $busi_type_name}';
  }
}

class FundingTime {
  FundingTime({
    this.sumTotalAmount,
    this.sumGenAmount,
  });

  FundingTime.fromJson(dynamic json) {
    sumTotalAmount = json['sum_total_amount'];
    sumGenAmount = json['sum_gen_amount'];
  }
  num? sumTotalAmount;
  num? sumGenAmount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sum_total_amount'] = sumTotalAmount;
    map['sum_gen_amount'] = sumGenAmount;
    return map;
  }
}
