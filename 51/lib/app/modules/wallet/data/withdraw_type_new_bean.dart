//改版的提现渠道列表
import 'dart:core';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

class WithdrawTypeNewBean {
  WithdrawTypeNewBean({
    this.payOrgId,
    this.payOrgName,
    this.popupContent,
    this.popupPayId,
    this.payInfo,
    this.popupWithdrawalInfo,
  });

  WithdrawTypeNewBean.fromJson(dynamic json) {
    payOrgId = json['pay_org_id'];
    payOrgName = json['pay_org_name'];
    popupContent = json['popup_content'];
    popupPayId = json['popup_pay_id'];
    if (json['payInfo'] != null) {
      payInfo = [];
      json['payInfo'].forEach((v) {
        payInfo?.add(PayInfo.fromJson(v));
      });
    }

    popupWithdrawalInfo = json['popupWithdrawalInfo'] != null
        ? WithdrawTypeNewBean.fromJson(json['popupWithdrawalInfo'])
        : null;
  }
  int? payOrgId;
  String? payOrgName;
  String? popupContent;
  WithdrawTypeNewBean? popupWithdrawalInfo;
  num? popupPayId;
  List<PayInfo>? payInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pay_org_id'] = payOrgId;
    map['pay_org_name'] = payOrgName;
    map['popup_content'] = popupContent;
    map['popup_pay_id'] = popupPayId;
    if (payInfo != null) {
      map['payInfo'] = payInfo?.map((v) => v.toJson()).toList();
    }
    if (popupWithdrawalInfo != null) {
      map['popupWithdrawalInfo'] = popupWithdrawalInfo?.toJson();
    }
    return map;
  }

  @override
  String toString() {
    return 'WithdrawTypeNewBean{payOrgId: $payOrgId, payOrgName: $payOrgName, popupContent: $popupContent, popupPayId: $popupPayId, payInfo: $payInfo}';
  }
}

class PayInfo {
  PayInfo({
    this.payInfoId,
    this.custId,
    this.payOrgId,
    this.state,
    this.tid,
    this.sortV,
    this.isBind,
    this.cut,
    this.nums,
    this.cust_code,
    this.pay_org_name,
    this.iconUrl,
    this.pay_name,
    this.pay_no,
    this.create_time,
    this.state_time,
    this.oper_code,
    this.oper_time,
    this.open_addr,
    this.telephone,
    this.ifsc,
    required this.isShowNum,
    this.tempPayNo,
  });

  PayInfo.fromJson(dynamic json) {
    payInfoId = json['pay_info_id'];
    custId = json['cust_id'];
    cust_code = json['cust_code'];
    payOrgId = json['pay_org_id'];
    pay_org_name = json['pay_org_name'];
    pay_name = json['pay_name'];
    iconUrl = json['iconUrl'];
    pay_no = json['pay_no'];
    create_time = json['create_time'];
    state_time = json['state_time'];
    state = json['state'];
    tid = json['tid'];
    sortV = json['sort_v'];
    oper_code = json['oper_code'];
    oper_time = json['oper_time'];
    open_addr = json['open_addr'];
    isBind = json['is_bind'];
    cut = json['cut'];
    telephone = json['telephone'];
    ifsc = json['ifsc'];
    nums = json['num'];

    cust_code = json['cust_code'];
    pay_org_name = json['pay_org_name'];
    pay_name = json['pay_name'];
    pay_no = json['pay_no'];
    create_time = json['create_time'];
    state_time = json['state_time'];
    oper_code = json['oper_code'];
    oper_time = json['oper_time'];
    open_addr = json['open_addr'];
    telephone = json['telephone'];
    ifsc = json['ifsc'];
    tKey1 = json['tKey1'];
  }
  num? payInfoId;
  num? custId;
  num? payOrgId;
  num? state;
  num? tid;
  num? sortV;
  num? isBind;
  int? cut;
  num? nums;
  String? cust_code;
  String? pay_org_name;
  String? iconUrl;
  String? pay_name;
  String? pay_no;
  num? create_time;
  num? state_time;
  String? oper_code;
  num? oper_time;
  String? open_addr;
  String? telephone;
  String? ifsc;
  RxBool isShowNum = false.obs;
  String? tempPayNo;
  dynamic? tKey1;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pay_info_id'] = payInfoId;
    map['cust_id'] = custId;
    map['pay_org_id'] = payOrgId;
    map['iconUrl'] = iconUrl;
    map['state'] = state;
    map['tid'] = tid;
    map['sort_v'] = sortV;
    map['is_bind'] = isBind;
    map['cut'] = cut;
    map['num'] = nums;
    map['cust_code'] = cust_code;
    map['pay_org_name'] = pay_org_name;
    map['pay_name'] = pay_name;
    map['pay_no'] = pay_no;
    map['create_time'] = create_time;
    map['state_time'] = state_time;
    map['oper_code'] = oper_code;
    map['oper_time'] = oper_time;
    map['open_addr'] = open_addr;
    map['telephone'] = telephone;
    map['ifsc'] = ifsc;
    map['tKey1'] = tKey1;
    return map;
  }

  @override
  String toString() {
    return 'PayInfo{tKey1:$tKey1 payInfoId: $payInfoId, custId: $custId, payOrgId: $payOrgId, state: $state, tid: $tid, sortV: $sortV, isBind: $isBind, cut: $cut, nums: $nums, cust_code: $cust_code, pay_org_name: $pay_org_name, pay_name: $pay_name, pay_no: $pay_no, create_time: $create_time, state_time: $state_time, oper_code: $oper_code, oper_time: $oper_time, open_addr: $open_addr, telephone: $telephone, ifsc: $ifsc, isShowNum: $isShowNum, tempPayNo: $tempPayNo}';
  }
}
