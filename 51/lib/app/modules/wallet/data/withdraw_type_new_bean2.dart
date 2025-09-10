//改版的提现渠道列表
import 'dart:core';

import 'package:flutter_tiyu_app/app/modules/wallet/data/withdraw_type_new_bean.dart';

class WithdrawTypeNewBean2 {
  WithdrawTypeNewBean2({
    this.payOrgId,
    this.payOrgName,
    this.popupContent,
    this.popupPayId,
    this.payInfo,
    this.popupWithdrawalInfo,
    this.rechargeTypeId,
    this.withdrawalGift,
    this.describeinfo,
    this.sourcetype,
    this.icon_url,
    this.label,
  });

  WithdrawTypeNewBean2.fromJson(dynamic json) {
    payOrgId = json['pay_org_id'];
    payOrgName = json['pay_org_name'];
    popupContent = json['popup_content'];
    popupPayId = json['popup_pay_id'];
    withdrawalGift = json['withdrawal_gift'];
    rechargeTypeId = json['recharge_type_id'];
    describeinfo = json['describeinfo'];
    icon_url = json['icon_url'];
    sourcetype = json['sourcetype'];
    if (json['payInfo'] != null) {
      payInfo = [];
      json['payInfo'].forEach((v) {
        payInfo?.add(PayInfo.fromJson(v));
      });
    }
    popupWithdrawalInfo = json['popupWithdrawalInfo'] != null
        ? WithdrawTypeNewBean2.fromJson(json['popupWithdrawalInfo'])
        : null;
  }
  int? payOrgId;
  String? payOrgName;
  String? popupContent;
  String? describeinfo;
  String? icon_url;
  WithdrawTypeNewBean2? popupWithdrawalInfo;
  num? popupPayId;
  List<PayInfo>? payInfo;
  num? withdrawalGift;
  int? rechargeTypeId;
  String? sourcetype;
  String? label;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pay_org_id'] = payOrgId;
    map['pay_org_name'] = payOrgName;
    map['popup_content'] = popupContent;
    map['popup_pay_id'] = popupPayId;
    map['withdrawal_gift'] = withdrawalGift;
    map['recharge_type_id'] = rechargeTypeId;
    map['describeinfo'] = describeinfo;
    map['sourcetype'] = sourcetype;
    map['icon_url'] = icon_url;
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
    return 'WithdrawTypeNewBean2{sourcetype:$sourcetype payOrgId: $payOrgId, payOrgName: $payOrgName, popupContent: $popupContent, describeinfo: $describeinfo, popupWithdrawalInfo: $popupWithdrawalInfo, popupPayId: $popupPayId, payInfo: $payInfo, withdrawalGift: $withdrawalGift, rechargeTypeId: $rechargeTypeId}';
  }
}
