// 认证信息
import 'package:flutter_tiyu_app/app/modules/wallet/data/withdraw_type_new_bean.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class CertificationInfoBean {
  CertificationInfoBean({
    this.certificationLevel,
    this.check,
    this.contactName,
    this.country,
    this.documentType,
    this.email,
    this.googleSecret,
    this.idCard,
    this.idCardLogAddr,
    this.isBindingEmail,
    this.isBindingGoogle,
    this.isBindingPhone,
    this.mobileCountry,
    this.phone,
    this.rz2State,
    this.rzState,
    this.withdrawAttestation,
    this.withdrawAttestationTwo,
    this.withdrawSmsVerify,
    this.withdrawalRemark,
    this.phone_sms_verify,
  });

  int? certificationLevel;
  String? check;
  String? contactName;
  String? country;
  String? documentType;
  String? email;
  String? googleSecret;
  String? idCard;
  String? idCardLogAddr;
  String? isBindingEmail;
  String? isBindingGoogle;
  String? isBindingPhone;
  String? mobileCountry;
  String? phone;
  String? rz2State;
  String? rzState;
  String? withdrawAttestation;
  String? withdrawAttestationTwo;
  String? withdrawSmsVerify;
  String? withdrawalRemark;
  String? phone_sms_verify;

  CertificationInfoBean.fromJson(dynamic json) {
    certificationLevel = json['certification_level'];
    check = json['check'];
    contactName = json['contact_name'];
    country = json['country'];
    documentType = json['document_type'];
    email = json['email'];
    googleSecret = json['google_secret'];
    idCard = json['id_card'];
    idCardLogAddr = json['id_card_log_addr'];
    isBindingEmail = json['is_binding_email'];
    isBindingGoogle = json['is_binding_google'];
    isBindingPhone = json['is_binding_phone'];
    mobileCountry = json['mobile_country'];
    phone = json['phone'];
    rz2State = '${json['rz2_state']}';
    rzState = '${json['rz_state']}';
    withdrawAttestation = json['withdraw_attestation'];
    withdrawAttestationTwo = json['withdraw_attestation_two'];
    withdrawSmsVerify = json['withdraw_sms_verify'];
    withdrawalRemark = json['withdrawal_remark'];
    phone_sms_verify = json['phone_sms_verify'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['certification_level'] = certificationLevel;
    map['check'] = check;
    map['contact_name'] = contactName;
    map['country'] = country;
    map['document_type'] = documentType;
    map['email'] = email;
    map['google_secret'] = googleSecret;
    map['id_card'] = idCard;
    map['id_card_log_addr'] = idCardLogAddr;
    map['is_binding_email'] = isBindingEmail;
    map['is_binding_google'] = isBindingGoogle;
    map['is_binding_phone'] = isBindingPhone;
    map['mobile_country'] = mobileCountry;
    map['phone'] = phone;
    map['rz2_state'] = rz2State;
    map['rz_state'] = rzState;
    map['withdraw_attestation'] = withdrawAttestation;
    map['withdraw_attestation_two'] = withdrawAttestationTwo;
    map['withdraw_sms_verify'] = withdrawSmsVerify;
    map['withdrawal_remark'] = withdrawalRemark;
    map['phone_sms_verify'] = phone_sms_verify;
    return map;
  }
}

/// 提现方式(后台数据)
class WithdrawMethodBackendBean {
  WithdrawMethodBackendBean(this.data);

  late List<WithdrawTypeTabBean> data;

  WithdrawMethodBackendBean.fromJson(List<dynamic> list) {
    data = list.map((e) => WithdrawTypeTabBean.fromJson(e)).toList();
  }
}

/// 提现方式(后台数据)
class WithdrawTypeTabBean {
  WithdrawTypeTabBean({
    this.data,
    this.title,
  });

  List<WithdrawTypeNewBean>? data;
  String? title;

  WithdrawTypeTabBean.fromJson(dynamic json) {
    title = json['title'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WithdrawTypeNewBean.fromJson(v));
      });
    }
  }
  // WithdrawTypeTabBean.fromJson(List<dynamic> list) {
  //   data = list.map((e) => WithdrawTypeNewBean.fromJson(e)).toList();
  //   title =
  // }
}

class WithdrawMethodBackendItemBean {
  WithdrawMethodBackendItemBean({
    this.custId,
    this.cut,
    this.isBind,
    this.num,
    this.payInfoId,
    this.payOrgId,
    this.payOrgName,
    this.sortV,
    this.state,
    this.tid,
  });

  int? custId;
  int? cut;
  int? isBind;
  int? num;
  int? payInfoId;
  int? payOrgId;
  String? payOrgName;
  int? sortV;
  int? state;
  int? tid;

  WithdrawMethodBackendItemBean.fromJson(dynamic json) {
    custId = json['cust_id'];
    cut = json['cut'];
    isBind = json['is_bind'];
    num = json['num'];
    payInfoId = json['pay_info_id'];
    payOrgId = json['pay_org_id'];
    payOrgName = json['pay_org_name'] ?? '';
    sortV = json['sort_v'];
    state = json['state'];
    tid = json['tid'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['cust_id'] = custId;
    map['cut'] = cut;
    map['is_bind'] = isBind;
    map['num'] = num;
    map['pay_info_id'] = payInfoId;
    map['pay_org_id'] = payOrgId;
    map['pay_org_name'] = payOrgName;
    map['sort_v'] = sortV;
    map['state'] = state;
    map['tid'] = tid;
    return map;
  }
}

class WithdrawBindCardBean {
  WithdrawBindCardBean({
    this.count,
    this.data,
  });

  int? count;
  List<WithdrawBindCardItemBean>? data;

  WithdrawBindCardBean.fromJson(dynamic json) {
    count = json['count'];
    if (json['data'] != null) {
      data = (json['data'] as List<dynamic>)
          .map((e) =>
              WithdrawBindCardItemBean.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }
}

class WithdrawBindCardItemBean {
  WithdrawBindCardItemBean({
    this.createTime,
    this.currency,
    this.custCode,
    this.custId,
    this.cut,
    this.ifsc,
    this.isBind,
    this.num,
    this.openAddr,
    this.operCode,
    this.operTime,
    this.payInfoId,
    this.payNo,
    this.payName,
    this.payOrgId,
    this.payOrgName,
    this.qrCodeAddress,
    this.sortV,
    this.state,
    this.stateTime,
    this.tid,
    this.usdtType,
    this.telephone,
    required this.isShowNum,
    this.tempPayNo,
  });

  int? createTime;
  String? currency;
  String? custCode;
  int? custId;
  int? cut;
  dynamic? ifsc;
  int? isBind;
  int? num;
  String? openAddr;
  String? operCode;
  int? operTime;
  int? payInfoId;
  String? payNo;
  String? payName;
  int? payOrgId;
  String? payOrgName;
  String? qrCodeAddress;
  int? sortV;
  int? state;
  int? stateTime;
  int? tid;
  String? usdtType;
  String? telephone;
  RxBool isShowNum = false.obs;
  String? tempPayNo;

  WithdrawBindCardItemBean.fromJson(dynamic json) {
    createTime = json['create_time'];
    currency = json['currency'];
    custCode = json['cust_code'];
    custId = json['cust_id'];
    cut = json['cut'];
    ifsc = json['ifsc'];
    isBind = json['is_bind'];
    num = json['num'];
    openAddr = json['open_addr'];
    operCode = json['oper_code'];
    operTime = json['oper_time'];
    payInfoId = json['pay_info_id'];
    payNo = json['pay_no'];
    payName = json['pay_name'];
    payOrgId = json['pay_org_id'];
    payOrgName = json['pay_org_name'];
    qrCodeAddress = json['qr_code_address'];
    sortV = json['sort_v'];
    state = json['state'];
    stateTime = json['state_time'];
    tid = json['tid'];
    usdtType = json['usdt_type'];
    telephone = json['telephone'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['create_time'] = createTime;
    map['currency'] = currency;
    map['cust_code'] = custCode;
    map['cust_id'] = custId;
    map['cut'] = cut;
    map['ifsc'] = ifsc;
    map['is_bind'] = isBind;
    map['num'] = num;
    map['open_addr'] = openAddr;
    map['oper_code'] = operCode;
    map['oper_time'] = operTime;
    map['pay_info_id'] = payInfoId;
    map['pay_no'] = payNo;
    map['pay_name'] = payName;
    map['pay_org_id'] = payOrgId;
    map['pay_org_name'] = payOrgName;
    map['qr_code_address'] = qrCodeAddress;
    map['sort_v'] = sortV;
    map['state'] = state;
    map['state_time'] = stateTime;
    map['tid'] = tid;
    map['usdt_type'] = usdtType;
    map['telephone'] = telephone;
    return map;
  }

  @override
  String toString() {
    return 'WithdrawBindCardItemBean{createTime: $createTime, currency: $currency, custCode: $custCode, custId: $custId, cut: $cut, ifsc: $ifsc, isBind: $isBind, num: $num, openAddr: $openAddr, operCode: $operCode, operTime: $operTime, payInfoId: $payInfoId, payNo: $payNo, payName: $payName, payOrgId: $payOrgId, payOrgName: $payOrgName, qrCodeAddress: $qrCodeAddress, sortV: $sortV, state: $state, stateTime: $stateTime, tid: $tid, usdtType: $usdtType, telephone: $telephone, isShowNum: $isShowNum, tempPayNo: $tempPayNo}';
  }
}

/// 提现限额
class WithdrawLimitConfigBean {
  WithdrawLimitConfigBean({
    this.contactName,
    this.email,
    this.idCard,
    this.idCardLogAddr,
    this.listFeel,
    this.rz2State,
    this.rzState,
    this.state,
    this.withdrawAmount,
    this.withdrawAmountAli,
    this.withdrawAttestation,
    this.withdrawAttestationTwo,
    this.withdrawCount,
    this.withdrawMinAmount,
    this.withdrawMinAmountAli,
    this.withdrawPromptWord,
    this.withdrawTotalAmount,
  });

  String? contactName;
  String? email;
  String? idCard;
  String? idCardLogAddr;
  String? listFeel;
  String? rz2State;
  String? rzState;
  String? state;
  dynamic withdrawAmount;
  dynamic withdrawAmountAli;
  String? withdrawAttestation;
  String? withdrawAttestationTwo;
  String? withdrawCount;
  dynamic withdrawMinAmount;
  dynamic withdrawMinAmountAli;
  String? withdrawPromptWord;
  String? withdrawTotalAmount;

  WithdrawLimitConfigBean.fromJson(dynamic json) {
    contactName = json['contact_name'];
    email = json['email'];
    idCard = json['id_card'];
    idCardLogAddr = json['id_card_log_addr'];
    listFeel = json['listFeel'];
    rz2State = '${json['rz2_state']}';
    rzState = '${json['rz_state']}';
    state = '${json['state']}';
    withdrawAmount = json['withdraw_amount'];
    withdrawAmountAli = json['withdraw_amount_ali'];
    withdrawAttestation = json['withdraw_attestation'];
    withdrawAttestationTwo = json['withdraw_attestation_two'];
    withdrawCount = json['withdraw_count'];
    withdrawMinAmount = json['withdraw_min_amount'];
    withdrawMinAmountAli = json['withdraw_min_amount_ali'];
    withdrawPromptWord = json['withdraw_prompt_word'];
    withdrawTotalAmount = json['withdraw_total_amount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['contact_name'] = contactName;
    map['email'] = email;
    map['id_card'] = idCard;
    map['id_card_log_addr'] = idCardLogAddr;
    map['listFeel'] = listFeel;
    map['rz2_state'] = rz2State;
    map['rz_state'] = rzState;
    map['state'] = state;
    map['withdraw_amount'] = withdrawAmount;
    map['withdraw_amount_ali'] = withdrawAmountAli;
    map['withdraw_attestation'] = withdrawAttestation;
    map['withdraw_attestation_two'] = withdrawAttestationTwo;
    map['withdraw_count'] = withdrawCount;
    map['withdraw_min_amount'] = withdrawMinAmount;
    map['withdraw_min_amount_ali'] = withdrawMinAmountAli;
    map['withdraw_prompt_word'] = withdrawPromptWord;
    map['withdraw_total_amount'] = withdrawTotalAmount;
    return map;
  }
}
