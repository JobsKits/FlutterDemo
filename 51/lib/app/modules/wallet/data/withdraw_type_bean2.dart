// 认证信息
import 'package:flutter_tiyu_app/app/modules/wallet/data/withdraw_type_new_bean2.dart';

/// 提现方式(后台数据)
class WithdrawTypeTabBean2 {
  WithdrawTypeTabBean2({
    this.data,
    this.title,
    this.rechargeTypeId,
    this.withdrawalGift,
    this.label,
  });

  List<WithdrawTypeNewBean2>? data;
  String? title;
  int? rechargeTypeId;
  num? withdrawalGift;
  String? describeinfo;
  String? label;

  WithdrawTypeTabBean2.fromJson(dynamic json) {
    title = json['title'];
    label = json['label'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WithdrawTypeNewBean2.fromJson(v));
      });
    }
    rechargeTypeId = json['recharge_type_id'];
    withdrawalGift = json['withdrawal_gift'];
    describeinfo = json['describeinfo'];
  }

  @override
  String toString() {
    return 'WithdrawTypeTabBean2{data: $data, title: $title, rechargeTypeId: $rechargeTypeId, withdrawalGift: $withdrawalGift, describeinfo: $describeinfo}';
  }
}
