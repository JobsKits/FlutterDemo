/// 接口 获取二阶段验证qrcode
/// {{url}}/member/auth/qrcode
class AuthQrcodeApiModel {
  String? secret;
  String? qrcode;

  AuthQrcodeApiModel({
    this.secret,
    this.qrcode,
  });

  factory AuthQrcodeApiModel.fromJson(Map<String, dynamic> json) => AuthQrcodeApiModel(
        secret: json["secret"],
        qrcode: json["qrcode"],
      );

  Map<String, dynamic> toJson() => {
        "secret": secret,
        "qrcode": qrcode,
      };
}
