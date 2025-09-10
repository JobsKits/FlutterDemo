/// 充值大类
class RechargeMarkType {
  static int offline = 1;
  static int online = 2;
  static int quick = 3;
}

class RechargeTypeBean {
  RechargeTypeBean({
    this.aseqId,
    this.payOrgId,
    this.name,
    this.iconUrl,
    this.sourcetype,
    this.createTime,
    this.stateTime,
    this.state,
    this.tid,
    this.sortV,
    this.mark,
    this.isShow,
    this.tenantPayMerchant,
    this.showFlag,
    this.payOfflinePercentageOfYards,
    this.currency,
    this.maxPercentage,
    this.contactName,
    this.channel_custom_name2,
    this.beforeRecommendLength,
    this.afterRecommendLength,
    this.isHasRecommend,
    this.realDataLength,
    this.cat,
  });

  RechargeTypeBean.fromJson(dynamic json) {
    aseqId = json['aseq_id'];
    payOrgId = json['pay_org_id'];
    name = json['name'];
    iconUrl = json['icon_url'];
    sourcetype = json['sourcetype'];
    createTime = json['create_time'];
    stateTime = json['state_time'];
    state = json['state'];
    tid = json['tid'];
    cat = json['cat'];
    sortV = json['sort_v'];
    mark = json['mark'];
    isShow = json['is_show'];
    if (json['tenantPayMerchant'] != null) {
      tenantPayMerchant = [];
      json['tenantPayMerchant'].forEach((v) {
        tenantPayMerchant?.add(TenantPayMerchant.fromJson(v));
      });
    }
    if (json['tenantPayInfo'] != null) {
      tenantPayInfo = [];
      json['tenantPayInfo'].forEach((v) {
        tenantPayInfo?.add(TenantPayInfo.fromJson(v));
      });
    }
    showFlag = json['show_flag'];
    payOfflinePercentageOfYards = json['pay_offline_percentage_of_yards'];
    currency = json['currency'];
    maxPercentage = json['maxPercentage'];
    contactName = json['contact_name'];
    describeinfo = json['describeinfo'];
    channel_custom_name2 = json['channel_custom_name2'];
  }
  int? aseqId;
  int? payOrgId;
  String? name;
  String? iconUrl;
  String? sourcetype;
  int? createTime;
  int? stateTime;
  int? state;
  int? tid;
  int? sortV;
  int? mark;
  int? cat;
  int? isShow;
  List<TenantPayMerchant>? tenantPayMerchant;
  List<TenantPayInfo>? tenantPayInfo;
  int? showFlag;
  int? payOfflinePercentageOfYards;
  String? currency;
  String? maxPercentage;
  String? channel_custom_name2;
  String? contactName;
  String? describeinfo;
  int? beforeRecommendLength; //前面的推荐数据长度
  int? afterRecommendLength; //后面的推荐数据长度
  int? realDataLength; //原始数据长度
  bool? isHasRecommend; //是否有推荐数据

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['aseq_id'] = aseqId;
    map['pay_org_id'] = payOrgId;
    map['name'] = name;
    map['icon_url'] = iconUrl;
    map['sourcetype'] = sourcetype;
    map['create_time'] = createTime;
    map['state_time'] = stateTime;
    map['state'] = state;
    map['tid'] = tid;
    map['cat'] = cat;
    map['sort_v'] = sortV;
    map['mark'] = mark;
    map['is_show'] = isShow;
    if (tenantPayMerchant != null) {
      map['tenantPayMerchant'] =
          tenantPayMerchant?.map((v) => v.toJson()).toList();
    }
    if (tenantPayInfo != null) {
      map['tenantPayInfo'] = tenantPayInfo?.map((v) => v.toJson()).toList();
    }
    map['show_flag'] = showFlag;
    map['pay_offline_percentage_of_yards'] = payOfflinePercentageOfYards;
    map['currency'] = currency;
    map['maxPercentage'] = maxPercentage;
    map['contact_name'] = contactName;
    map['describeinfo'] = describeinfo;
    map['channel_custom_name2'] = channel_custom_name2;

    return map;
  }

  @override
  String toString() {
    return 'RechargeTypeBean{name: $name}';
  }
}

class TenantPayMerchant {
  TenantPayMerchant({
    this.tenantPatMerId,
    this.payOrgId,
    this.sourcetype,
    this.reqAddr,
    this.remark,
    this.stateTime,
    this.state,
    this.sortV,
    this.tid,
    this.payMode,
    this.payClient,
    this.quotaMin,
    this.quotaMax,
    this.percentageOfYards,
    this.percentageOfFee,
    this.thirdFee,
    this.quickRechargeAmount,
    this.merType,
    this.isEnterAmount,
    this.balance,
    this.bonusAmountPercentage,
    this.bonusAmountPercentageOfYards,
    this.qqRecharge,
    this.vxRecharge,
    this.channelCustomName,
    this.channelCustomName2,
    this.paymentAccountType,
    this.channelCode,
    this.ipWhitelist,
    this.payType,
    this.numberType,
    this.sourcetypeName,
    this.list,
    this.countAll,
    this.successCount,
    this.moneyCount,
    this.percentageList,
    this.maxPercentage,
    this.iconUrl,
    this.jumpMethod,
    this.supportDevice,
    this.totalCharge,
    this.rate,
    this.india,
    this.weights,
    this.maxLimit,
    this.discountAmount,
    this.discountRate,
    this.discountLimit,
    this.floatingAmount,
    this.floatingAmount1,
    this.popup_content,
    this.popup_pay_id,
    this.popupTenantPayInfo,
    this.currency,
    this.isEmbed,
    this.isRecommend,
    this.cat,
  });

  TenantPayMerchant.fromJson(dynamic json) {
    tenantPatMerId = json['tenant_pat_mer_id'];
    payOrgId = json['pay_org_id'];
    sourcetype = json['sourcetype'];
    reqAddr = json['req_addr'];
    remark = json['remark'];
    stateTime = json['state_time'];
    state = json['state'];
    sortV = json['sort_v'];
    tid = json['tid'];
    payMode = json['pay_mode'];
    payClient = json['pay_client'];
    quotaMin = json['quota_min'];
    quotaMax = json['quota_max'];
    percentageOfYards = json['percentage_of_yards'];
    percentageOfFee = json['percentage_of_fee'];
    thirdFee = json['third_fee'];
    quickRechargeAmount = json['quick_recharge_amount'];
    merType = json['mer_type'];
    isEnterAmount = json['is_enter_amount'];
    balance = json['balance'];
    bonusAmountPercentage = json['bonus_amount_percentage'];
    bonusAmountPercentageOfYards = json['bonus_amount_percentage_of_yards'];
    qqRecharge = json['qq_recharge'];
    vxRecharge = json['vx_recharge'];
    channelCustomName = json['channel_custom_name'];
    channelCustomName2 = json['channel_custom_name2'];
    paymentAccountType = json['payment_account_type'];
    channelCode = json['channel_code'];
    ipWhitelist = json['ip_whitelist'];
    payType = json['pay_type'];
    numberType = json['number_type'];
    sourcetypeName = json['sourcetype_name'];
    if (json['list'] != null) {
      list = [];
      json['list'].forEach((v) {
        list?.add(SecondList.fromJson(v));
      });
    }
    countAll = json['countAll'];
    successCount = json['successCount'];
    moneyCount = json['moneyCount'];
    if (json['percentageList'] != null) {
      percentageList = [];
      json['percentageList'].forEach((v) {
        percentageList?.add(PercentageList.fromJson(v));
      });
    }
    maxPercentage = json['maxPercentage'];
    iconUrl = json['icon_url'];
    jumpMethod = json['jump_method'];
    supportDevice = json['support_device'];
    totalCharge = json['total_charge'];
    rate = json['rate'];
    india = json['india'];
    weights = json['weights'];
    maxLimit = json['max_limit'];
    discountAmount = json['discount_amount'];
    discountRate = json['discount_rate'];
    discountLimit = json['discount_limit'];
    floatingAmount = json['floating_amount'];
    floatingAmount1 = json['floating_amount1'];
    popup_content = json['popup_content'];
    popup_pay_id = json['popup_pay_id'];
    if (json['popupTenantPayInfo'] != null) {
      popupTenantPayInfo = TenantPayInfo.fromJson(json['popupTenantPayInfo']);
    }
    currency = json['currency'];
    isEmbed = json['is_embed'];
  }
  int? tenantPatMerId;
  int? payOrgId;
  String? sourcetype;
  String? reqAddr;
  String? remark;
  int? stateTime;
  int? state;
  int? sortV;
  int? tid;
  int? payMode;
  int? payClient;
  num? quotaMin;
  int? quotaMax;
  int? percentageOfYards;
  int? percentageOfFee;
  dynamic? thirdFee;
  String? quickRechargeAmount;
  int? merType;
  int? isEnterAmount;
  int? balance;
  String? bonusAmountPercentage;
  double? bonusAmountPercentageOfYards;
  String? qqRecharge;
  String? vxRecharge;
  String? channelCustomName;
  String? channelCustomName2;
  int? paymentAccountType;
  String? channelCode;
  String? ipWhitelist;
  int? payType;
  int? numberType;
  String? sourcetypeName;
  List<SecondList>? list;
  int? countAll;
  int? successCount;
  int? moneyCount;
  List<PercentageList>? percentageList;
  String? maxPercentage;
  String? iconUrl;
  int? jumpMethod;
  int? supportDevice;
  String? totalCharge;
  double? rate;
  String? india;
  int? weights;
  int? maxLimit;
  int? discountAmount;
  int? discountRate;
  int? discountLimit;
  int? floatingAmount;
  int? floatingAmount1;
  bool get iconUrlIsNotEmpty => (iconUrl ?? "")!.isNotEmpty;
  String? popup_content;
  num? popup_pay_id;
  String? currency;
  TenantPayInfo? popupTenantPayInfo;
  String? isEmbed;
  bool? isRecommend = false;
  int? cat;
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tenant_pat_mer_id'] = tenantPatMerId;
    map['pay_org_id'] = payOrgId;
    map['sourcetype'] = sourcetype;
    map['req_addr'] = reqAddr;
    map['remark'] = remark;
    map['state_time'] = stateTime;
    map['state'] = state;
    map['sort_v'] = sortV;
    map['tid'] = tid;
    map['pay_mode'] = payMode;
    map['pay_client'] = payClient;
    map['quota_min'] = quotaMin;
    map['quota_max'] = quotaMax;
    map['percentage_of_yards'] = percentageOfYards;
    map['percentage_of_fee'] = percentageOfFee;
    map['third_fee'] = thirdFee;
    map['quick_recharge_amount'] = quickRechargeAmount;
    map['mer_type'] = merType;
    map['is_enter_amount'] = isEnterAmount;
    map['balance'] = balance;
    map['bonus_amount_percentage'] = bonusAmountPercentage;
    map['bonus_amount_percentage_of_yards'] = bonusAmountPercentageOfYards;
    map['qq_recharge'] = qqRecharge;
    map['vx_recharge'] = vxRecharge;
    map['channel_custom_name'] = channelCustomName;
    map['channel_custom_name2'] = channelCustomName2;
    map['payment_account_type'] = paymentAccountType;
    map['channel_code'] = channelCode;
    map['ip_whitelist'] = ipWhitelist;
    map['pay_type'] = payType;
    map['number_type'] = numberType;
    map['sourcetype_name'] = sourcetypeName;
    if (list != null) {
      map['list'] = list?.map((v) => v.toJson()).toList();
    }
    map['countAll'] = countAll;
    map['successCount'] = successCount;
    map['moneyCount'] = moneyCount;
    if (percentageList != null) {
      map['percentageList'] = percentageList?.map((v) => v.toJson()).toList();
    }
    map['maxPercentage'] = maxPercentage;
    map['icon_url'] = iconUrl;
    map['jump_method'] = jumpMethod;
    map['support_device'] = supportDevice;
    map['total_charge'] = totalCharge;
    map['rate'] = rate;
    map['india'] = india;
    map['weights'] = weights;
    map['max_limit'] = maxLimit;
    map['discount_amount'] = discountAmount;
    map['discount_rate'] = discountRate;
    map['discount_limit'] = discountLimit;
    map['floating_amount'] = floatingAmount;
    map['floating_amount1'] = floatingAmount1;
    map['popup_content'] = popup_content;
    map['popup_pay_id'] = popup_pay_id;
    map['popupTenantPayInfo'] = popupTenantPayInfo;
    map['currency'] = currency;
    map['is_embed'] = isEmbed;
    return map;
  }

  @override
  String toString() {
    return '{cat: $cat,isRecommend: $isRecommend,tenantPatMerId: $tenantPatMerId, payOrgId: $payOrgId, sourcetype: $sourcetype, reqAddr: $reqAddr, remark: $remark, stateTime: $stateTime, state: $state, sortV: $sortV, tid: $tid, payMode: $payMode, payClient: $payClient, quotaMin: $quotaMin, quotaMax: $quotaMax, percentageOfYards: $percentageOfYards, percentageOfFee: $percentageOfFee, thirdFee: $thirdFee, quickRechargeAmount: $quickRechargeAmount, merType: $merType, isEnterAmount: $isEnterAmount, balance: $balance, bonusAmountPercentage: $bonusAmountPercentage, bonusAmountPercentageOfYards: $bonusAmountPercentageOfYards, qqRecharge: $qqRecharge, vxRecharge: $vxRecharge, channelCustomName: $channelCustomName, channelCustomName2: $channelCustomName2, paymentAccountType: $paymentAccountType, channelCode: $channelCode, ipWhitelist: $ipWhitelist, payType: $payType, numberType: $numberType, sourcetypeName: $sourcetypeName, list: $list, countAll: $countAll, successCount: $successCount, moneyCount: $moneyCount, percentageList: $percentageList, maxPercentage: $maxPercentage, iconUrl: $iconUrl, jumpMethod: $jumpMethod, supportDevice: $supportDevice, totalCharge: $totalCharge, rate: $rate, india: $india, weights: $weights, maxLimit: $maxLimit, discountAmount: $discountAmount, discountRate: $discountRate, discountLimit: $discountLimit, floatingAmount: $floatingAmount, floatingAmount1: $floatingAmount1, popup_content: $popup_content, popup_pay_id: $popup_pay_id, currency: $currency, popupTenantPayInfo: $popupTenantPayInfo, isEmbed: $isEmbed}';
  }
}

class PercentageList {
  PercentageList({
    this.a,
    this.b,
  });

  PercentageList.fromJson(dynamic json) {
    a = json['a'];
    b = json['b'];
  }
  String? a;
  String? b;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['a'] = a;
    map['b'] = b;
    return map;
  }

  @override
  String toString() {
    return 'PercentageList{a: $a, b: $b}';
  }
}

class SecondList {
  SecondList({
    this.custGroupId,
    this.featureId,
    this.custGroupCode,
    this.name,
    this.des,
    this.effTime,
    this.expTime,
    this.createTime,
    this.state,
    this.stateTime,
    this.tid,
    this.memberCount,
    this.memberWithdrawCount,
    this.memberWithdrawAmount,
    this.memberWithdrawTotalAmount,
    this.memberWithdrawLowestAmount,
    this.memberWithdrawTime,
    this.partnerNames,
    this.profitRatio,
    this.commissionRangeLower,
    this.commissionRangeUpper,
    this.promptWord,
    this.isShowCancel,
    this.handFee,
  });

  SecondList.fromJson(dynamic json) {
    custGroupId = json['cust_group_id'];
    featureId = json['feature_id'];
    custGroupCode = json['cust_group_code'];
    name = json['name'];
    des = json['des'];
    effTime = json['eff_time'];
    expTime = json['exp_time'];
    createTime = json['create_time'];
    state = json['state'];
    stateTime = json['state_time'];
    tid = json['tid'];
    memberCount = json['member_count'];
    memberWithdrawCount = json['member_withdraw_count'];
    memberWithdrawAmount = json['member_withdraw_amount'];
    memberWithdrawTotalAmount = json['member_withdraw_total_amount'];
    memberWithdrawLowestAmount = json['member_withdraw_lowest_amount'];
    memberWithdrawTime = json['member_withdraw_time'];
    partnerNames = json['partner_names'];
    profitRatio = json['profit_ratio'];
    commissionRangeLower = json['commission_range_lower'];
    commissionRangeUpper = json['commission_range_upper'];
    promptWord = json['prompt_word'];
    isShowCancel = json['is_show_cancel'];
    handFee = json['hand_fee'];
  }
  int? custGroupId;
  int? featureId;
  String? custGroupCode;
  String? name;
  String? des;
  int? effTime;
  int? expTime;
  int? createTime;
  int? state;
  int? stateTime;
  int? tid;
  int? memberCount;
  int? memberWithdrawCount;
  int? memberWithdrawAmount;
  int? memberWithdrawTotalAmount;
  int? memberWithdrawLowestAmount;
  int? memberWithdrawTime;
  String? partnerNames;
  int? profitRatio;
  int? commissionRangeLower;
  int? commissionRangeUpper;
  String? promptWord;
  int? isShowCancel;
  String? handFee;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_group_id'] = custGroupId;
    map['feature_id'] = featureId;
    map['cust_group_code'] = custGroupCode;
    map['name'] = name;
    map['des'] = des;
    map['eff_time'] = effTime;
    map['exp_time'] = expTime;
    map['create_time'] = createTime;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['tid'] = tid;
    map['member_count'] = memberCount;
    map['member_withdraw_count'] = memberWithdrawCount;
    map['member_withdraw_amount'] = memberWithdrawAmount;
    map['member_withdraw_total_amount'] = memberWithdrawTotalAmount;
    map['member_withdraw_lowest_amount'] = memberWithdrawLowestAmount;
    map['member_withdraw_time'] = memberWithdrawTime;
    map['partner_names'] = partnerNames;
    map['profit_ratio'] = profitRatio;
    map['commission_range_lower'] = commissionRangeLower;
    map['commission_range_upper'] = commissionRangeUpper;
    map['prompt_word'] = promptWord;
    map['is_show_cancel'] = isShowCancel;
    map['hand_fee'] = handFee;
    return map;
  }

  @override
  String toString() {
    return 'SecondList{custGroupId: $custGroupId, featureId: $featureId, custGroupCode: $custGroupCode, name: $name, des: $des, effTime: $effTime, expTime: $expTime, createTime: $createTime, state: $state, stateTime: $stateTime, tid: $tid, memberCount: $memberCount, memberWithdrawCount: $memberWithdrawCount, memberWithdrawAmount: $memberWithdrawAmount, memberWithdrawTotalAmount: $memberWithdrawTotalAmount, memberWithdrawLowestAmount: $memberWithdrawLowestAmount, memberWithdrawTime: $memberWithdrawTime, partnerNames: $partnerNames, profitRatio: $profitRatio, commissionRangeLower: $commissionRangeLower, commissionRangeUpper: $commissionRangeUpper, promptWord: $promptWord, isShowCancel: $isShowCancel, handFee: $handFee}';
  }
}

class TenantPayInfo {
  TenantPayInfo({
    this.accountOpening,
    this.agentBalance,
    this.agentCode,
    this.balance,
    this.bonusAmountPercentage,
    this.bonusAmountPercentageOfYards,
    this.callurl,
    this.cat,
    this.channelCustomName,
    this.channelCustomName2,
    this.createTime,
    this.currency,
    this.dataType,
    this.discountAmount,
    this.discountLimit,
    this.discountRate,
    this.handFee,
    this.iconUrl,
    this.ipWhiteList,
    this.isEnterAmount,
    this.jumpMethod,
    this.maxPercentage,
    this.md5Key,
    this.multiple,
    this.operCode,
    this.payName,
    this.payNo,
    this.payOrgId,
    this.payOrgName,
    this.payOrgNameReal,
    this.payType,
    this.principalCode,
    this.qrCodeAddr,
    this.quickRechargeAmount,
    this.quotaMax,
    this.quotaMin,
    this.rate,
    this.remark,
    this.reqAddr,
    this.sortV,
    this.sourcetypeName,
    this.state,
    this.stateTime,
    this.supportDevice,
    this.tenantPatMerId,
    this.tenantPayId,
    this.thirdFee,
    this.tid,
    this.totalCharge,
    this.tradeMedium,
    this.usdtType,
    this.percentageList,
    this.nickName,
    this.kf_url,
    this.head,
    this.isRecommend,
  });

  TenantPayInfo.fromJson(dynamic json) {
    accountOpening = json['account_opening'];
    agentBalance = json['agent_balance'];
    agentCode = json['agent_code'];
    balance = json['balance'];
    bonusAmountPercentage = json['bonus_amount_percentage'];
    bonusAmountPercentageOfYards = json['bonus_amount_percentage_of_yards'];
    callurl = json['callurl'];
    cat = json['cat'];
    channelCustomName = json['channel_custom_name'];
    channelCustomName2 = json['channel_custom_name2'];
    createTime = json['create_time'];
    currency = json['currency'];
    dataType = json['data_type'];
    discountAmount = json['discount_amount'];
    discountLimit = json['discount_limit'];
    discountRate = json['discount_rate'];
    handFee = json['hand_fee'];
    iconUrl = json['icon_url'];
    ipWhiteList = json['ip_whitelist'];
    isEnterAmount = json['is_enter_amount'];
    jumpMethod = json['jump_method'];
    maxPercentage = json['maxPercentage'];
    md5Key = json['md5Key'];
    multiple = json['multiple'];
    operCode = json['oper_code'];
    payName = json['pay_name'];
    payNo = json['pay_no'];
    payOrgId = json['pay_org_id'];
    payOrgName = json['pay_org_name'];
    payOrgNameReal = json['pay_org_name_real'];
    payType = json['pay_type'];
    principalCode = json['principal_code'];
    qrCodeAddr = json['qr_code_addr'];
    quickRechargeAmount = json['quick_recharge_amount'];
    quotaMax = json['quota_max'];
    quotaMin = json['quota_min'];
    rate = json['rate'];
    remark = json['remark'];
    reqAddr = json['req_addr'];
    sortV = json['sort_v'];
    sourcetypeName = json['sourcetype_name'];
    state = json['state'];
    stateTime = json['state_time'];
    supportDevice = json['support_device'];
    tenantPatMerId = json['tenant_pat_mer_id'];
    tenantPayId = json['tenant_pay_id'];
    thirdFee = json['third_fee'];
    tid = json['tid'];
    totalCharge = json['total_charge'];
    tradeMedium = json['trade_medium'];
    usdtType = json['usdt_type'];
    popup_content = json['popup_content'];
    popup_pay_id = json['popup_pay_id'];
    nickName = json['nickName'];
    kf_url = json['kf_url'];
    kf_type = json['kf_type'];
    head = json['head'];
    if (json['popupTenantPayInfo'] != null) {
      popupTenantPayInfo = TenantPayInfo.fromJson(json['popupTenantPayInfo']);
    }
    if (json['percentageList'] != null) {
      percentageList = [];
      json['percentageList'].forEach((v) {
        percentageList?.add(PercentageList.fromJson(v));
      });
    }
  }

  String? accountOpening;
  num? agentBalance;
  String? agentCode;
  num? balance;
  String? bonusAmountPercentage;
  num? bonusAmountPercentageOfYards;
  String? callurl;
  num? cat;
  String? channelCustomName;
  String? channelCustomName2;
  int? createTime;
  String? currency;
  int? dataType;
  num? discountAmount;
  num? discountLimit;
  num? discountRate;
  num? handFee;
  String? iconUrl;
  String? ipWhiteList;
  num? isEnterAmount;
  int? jumpMethod;
  String? maxPercentage;
  String? md5Key;
  num? multiple;
  String? operCode;
  String? payName;
  String? payNo;
  num? payOrgId;
  String? payOrgName;
  String? payOrgNameReal;
  int? payType;
  num? principalCode;
  String? qrCodeAddr;
  String? quickRechargeAmount;
  num? quotaMax;
  num? quotaMin;
  num? rate;
  String? remark;
  String? reqAddr;
  int? sortV;
  String? sourcetypeName;
  int? state;
  int? stateTime;
  int? supportDevice;
  num? tenantPatMerId;
  num? tenantPayId;
  num? thirdFee;
  int? tid;
  String? totalCharge;
  String? tradeMedium;
  String? usdtType;
  String? nickName;
  String? kf_url;
  num? kf_type;
  String? head;
  List<PercentageList>? percentageList;
  bool get iconUrlIsNotEmpty => (iconUrl ?? "")!.isNotEmpty;
  String? popup_content;
  num? popup_pay_id;
  TenantPayInfo? popupTenantPayInfo;
  bool? isRecommend;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['account_opening'] = accountOpening;
    map['agent_balance'] = agentBalance;
    map['agent_code'] = agentCode;
    map['balance'] = balance;
    map['bonus_amount_percentage'] = bonusAmountPercentage;
    map['bonus_amount_percentage_of_yards'] = bonusAmountPercentageOfYards;
    map['callurl'] = callurl;
    map['cat'] = cat;
    map['channel_custom_name'] = channelCustomName;
    map['channel_custom_name2'] = channelCustomName2;
    map['create_time'] = createTime;
    map['currency'] = currency;
    map['data_type'] = dataType;
    map['discount_amount'] = discountAmount;
    map['discount_limit'] = discountLimit;
    map['discount_rate'] = discountRate;
    map['hand_fee'] = handFee;
    map['icon_url'] = iconUrl;
    map['ip_whitelist'] = ipWhiteList;
    map['is_enter_amount'] = isEnterAmount;
    map['jump_method'] = jumpMethod;
    map['maxPercentage'] = maxPercentage;
    map['md5Key'] = md5Key;
    map['multiple'] = multiple;
    map['oper_code'] = operCode;
    map['pay_name'] = payName;
    map['pay_no'] = payNo;
    map['pay_org_id'] = payOrgId;
    map['pay_org_name'] = payOrgName;
    map['pay_org_name_real'] = payOrgNameReal;
    map['pay_type'] = payType;
    map['principal_code'] = principalCode;
    map['qr_code_addr'] = qrCodeAddr;
    map['quick_recharge_amount'] = quickRechargeAmount;
    map['quota_max'] = quotaMax;
    map['quota_min'] = quotaMin;
    map['rate'] = rate;
    map['remark'] = remark;
    map['req_addr'] = reqAddr;
    map['sort_v'] = sortV;
    map['sourcetype_name'] = sourcetypeName;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['support_device'] = supportDevice;
    map['tenant_pat_mer_id'] = tenantPatMerId;
    map['tenant_pay_id'] = tenantPayId;
    map['third_fee'] = thirdFee;
    map['tid'] = tid;
    map['total_charge'] = totalCharge;
    map['trade_medium'] = tradeMedium;
    map['usdt_type'] = usdtType;
    map['popup_content'] = popup_content;
    map['popup_pay_id'] = popup_pay_id;
    map['popupTenantPayInfo'] = popupTenantPayInfo;
    map['nickName'] = nickName;
    map['kf_url'] = kf_url;
    map['kf_type'] = kf_type;
    map['head'] = head;
    if (percentageList != null) {
      map['percentageList'] = percentageList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'TenantPayInfo{accountOpening: $accountOpening, agentCode: $agentCode, balance: $balance, bonusAmountPercentage: $bonusAmountPercentage, bonusAmountPercentageOfYards: $bonusAmountPercentageOfYards, callurl: $callurl, cat: $cat, channelCustomName: $channelCustomName, channelCustomName2: $channelCustomName2, createTime: $createTime, currency: $currency, dataType: $dataType, discountAmount: $discountAmount, discountLimit: $discountLimit, discountRate: $discountRate, handFee: $handFee, iconUrl: $iconUrl, ipWhiteList: $ipWhiteList, isEnterAmount: $isEnterAmount, jumpMethod: $jumpMethod, maxPercentage: $maxPercentage, md5Key: $md5Key, multiple: $multiple, operCode: $operCode, payName: $payName, payNo: $payNo, payOrgId: $payOrgId, payOrgName: $payOrgName, payOrgNameReal: $payOrgNameReal, payType: $payType, principalCode: $principalCode, qrCodeAddr: $qrCodeAddr, quickRechargeAmount: $quickRechargeAmount, quotaMax: $quotaMax, quotaMin: $quotaMin, rate: $rate, remark: $remark, reqAddr: $reqAddr, sortV: $sortV, sourcetypeName: $sourcetypeName, state: $state, stateTime: $stateTime, supportDevice: $supportDevice, tenantPatMerId: $tenantPatMerId, tenantPayId: $tenantPayId, thirdFee: $thirdFee, tid: $tid, totalCharge: $totalCharge, tradeMedium: $tradeMedium, usdtType: $usdtType, nickName: $nickName, kf_url: $kf_url, head: $head, percentageList: $percentageList, popup_content: $popup_content, popup_pay_id: $popup_pay_id, popupTenantPayInfo: $popupTenantPayInfo}';
  }
}

class DiscountBean {
  DiscountBean({
    this.isShowDiscount,
  });

  int? isShowDiscount;
  String? suggestOrgs;
  List<SuggestBean>? suggestAfter;
  List<SuggestBean>? suggestBefore;

  DiscountBean.fromJson(dynamic json) {
    isShowDiscount = json['is_showDiscount'];
    suggestOrgs = json['suggestOrgs'];
    if (json['suggestAfter'] != null) {
      suggestAfter = [];
      json['suggestAfter'].forEach((v) {
        suggestAfter?.add(SuggestBean.fromJson(v));
      });
    }
    if (json['suggestBefore'] != null) {
      suggestBefore = [];
      json['suggestBefore'].forEach((v) {
        suggestBefore?.add(SuggestBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['is_showDiscount'] = isShowDiscount;
    map['suggestOrgs'] = suggestOrgs;
    if (suggestAfter != null) {
      map['suggestAfter'] = suggestAfter?.map((v) => v.toJson()).toList();
    }
    if (suggestBefore != null) {
      map['suggestBefore'] = suggestBefore?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'DiscountBean{isShowDiscount: $isShowDiscount, suggestOrgs: $suggestOrgs, suggestAfter: $suggestAfter, suggestBefore: $suggestBefore}';
  }
}

class SuggestBean {
  int? site;
  int? cat;
  String? show;
  String? merId;
  int? sort;
  SuggestBean.fromJson(dynamic json) {
    site = json['site'];
    cat = json['cat'];
    show = json['show'];
    merId = json['merId'];
    sort = json['sort'];
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['site'] = site;
    map['cat'] = cat;
    map['show'] = show;
    map['merId'] = merId;
    map['sort'] = sort;
    return map;
  }

  @override
  String toString() {
    return 'SuggestBean{site: $site, cat: $cat, show: $show, merId: $merId, sort: $sort}';
  }
}
