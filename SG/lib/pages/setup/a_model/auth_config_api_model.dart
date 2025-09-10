///获取安全验证配置
///{{url}}/member/auth/config
class AuthConfigApiModel {
  // "auth_secret": "H2VPVVIZQ2WSXVNW4TIW5PGSNIR7LRBQ", //二阶段密钥
  // "is_secret": "1", //是否已配置密钥 1:已配置 0:未配置
  // "is_pay_password": "0" //是否已配置资金密码 1:已配置 0:未配置
  String? authSecret;
  String? isSecret;
  String? isPayPassword;

  AuthConfigApiModel({
    this.authSecret,
    this.isSecret,
    this.isPayPassword,
  });

  ///判断是否已双重验证
  bool isAuthSecret() {
    return isSecret == "1";
  }

  factory AuthConfigApiModel.fromJson(Map<String, dynamic> json) => AuthConfigApiModel(
        authSecret: json["auth_secret"],
        isSecret: json["is_secret"],
        isPayPassword: json["is_pay_password"],
      );

  Map<String, dynamic> toJson() => {
        "auth_secret": authSecret,
        "is_secret": isSecret,
        "is_pay_password": isPayPassword,
      };
}
