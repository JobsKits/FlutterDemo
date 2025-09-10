class HomeRankListBean {
  HomeRankListBean({
    this.id,
    this.cust_name,
    this.state,
    this.tid,
    this.oper_code,
    this.amount,
  });

  int? id;
  String? cust_name;
  int? state;
  int? tid;
  String? oper_code;
  double? amount;

  HomeRankListBean.fromJson(dynamic json) {
    id = json['id'];
    cust_name = json['cust_name'];
    state = json['state'];
    tid = json['tid'];
    oper_code = json['oper_code'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['cust_name'] = cust_name;
    map['state'] = state;
    map['tid'] = tid;
    map['oper_code'] = oper_code;
    map['amount'] = amount;
    return map;
  }

  @override
  String toString() {
    return 'HomeRankListBean{id: $id, cust_name: $cust_name, state: $state, tid: $tid, oper_code: $oper_code, amount: $amount}';
  }
}
