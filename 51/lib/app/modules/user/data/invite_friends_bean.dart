///邀请好友的实体类
class InviteFriendsBean {
  InviteFriendsBean({
    this.partnerName,
    this.direc,
    this.count,
    this.promoteCode,
    this.linkAddr,
    this.rebateSum,
    this.custCount,
    this.newChargeCustCount,
    this.addCustCount,
    this.addDirecCount,
    this.receiveState,
  });

  InviteFriendsBean.fromJson(dynamic json) {
    partnerName = json['partnerName'];
    direc = json['direc'];
    count = json['count'];
    promoteCode = json['promote_code'];
    linkAddr = json['link_addr'];
    rebateSum = json['rebate_sum'];
    custCount = json['cust_count'] != null
        ? CustCount.fromJson(json['cust_count'])
        : null;
    newChargeCustCount = json['new_charge_cust_count'] != null
        ? NewChargeCustCount.fromJson(json['new_charge_cust_count'])
        : null;
    addCustCount = json['add_cust_count'];
    addDirecCount = json['add_direc_count'];
    receiveState = json['receive_state'];
  }
  String? partnerName;
  num? direc;
  num? count;
  String? promoteCode;
  String? linkAddr;
  num? rebateSum;
  CustCount? custCount;
  NewChargeCustCount? newChargeCustCount;
  num? addCustCount;
  num? addDirecCount;
  num? receiveState;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partnerName'] = partnerName;
    map['direc'] = direc;
    map['count'] = count;
    map['promote_code'] = promoteCode;
    map['link_addr'] = linkAddr;
    map['rebate_sum'] = rebateSum;
    if (custCount != null) {
      map['cust_count'] = custCount?.toJson();
    }
    if (newChargeCustCount != null) {
      map['new_charge_cust_count'] = newChargeCustCount?.toJson();
    }
    map['add_cust_count'] = addCustCount;
    map['add_direc_count'] = addDirecCount;
    map['receive_state'] = receiveState;
    return map;
  }

  @override
  String toString() {
    return 'InviteFriendsBean{partnerName: $partnerName, direc: $direc, count: $count, promoteCode: $promoteCode, linkAddr: $linkAddr, rebateSum: $rebateSum, custCount: $custCount, newChargeCustCount: $newChargeCustCount, addCustCount: $addCustCount, addDirecCount: $addDirecCount, receiveState: $receiveState}';
  }
}

class NewChargeCustCount {
  NewChargeCustCount({
    this.newChargeCustCount,
  });

  NewChargeCustCount.fromJson(dynamic json) {
    newChargeCustCount = json['new_charge_cust_count'];
  }
  num? newChargeCustCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_charge_cust_count'] = newChargeCustCount;
    return map;
  }
}

class CustCount {
  CustCount({
    this.partnerCount,
    this.custCount,
  });

  CustCount.fromJson(dynamic json) {
    partnerCount = json['partner_count'];
    custCount = json['cust_count'];
  }
  num? partnerCount;
  num? custCount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['partner_count'] = partnerCount;
    map['cust_count'] = custCount;
    return map;
  }
}
