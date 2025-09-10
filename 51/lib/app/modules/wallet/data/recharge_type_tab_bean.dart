import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_bean.dart';

class RechargeTypeTabBean {
  RechargeTypeTabBean(
      {this.title,
      this.data,
      this.maxPercentage,
      this.isManualRecharge = false});

  RechargeTypeTabBean.fromJson(dynamic json) {
    title = json['title'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(RechargeTypeBean.fromJson(v));
      });
    }
  }
  String? title;
  String? maxPercentage;
  List<RechargeTypeBean>? data;
  bool? isManualRecharge; //是否人工充值

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  @override
  String toString() {
    return 'RechargeTypeTabBean{title: $title, data: $data}';
  }
}
