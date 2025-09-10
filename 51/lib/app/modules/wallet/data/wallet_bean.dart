class WalletBean {
  WalletBean({
    this.realName,
    this.walletBalance,
    this.walletAddress,
  });

  WalletBean.fromJson(dynamic json) {
    realName = json['realName'];
    walletBalance = json['walletBalance'];
    walletAddress = json['walletAddress'];
  }
  String? realName;
  num? walletBalance;
  String? walletAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['realName'] = realName;
    map['walletBalance'] = walletBalance;
    map['walletAddress'] = walletAddress;
    return map;
  }

  @override
  String toString() {
    return 'WalletBean{realName: $realName, walletBalance: $walletBalance, walletAddress: $walletAddress}';
  }
}
