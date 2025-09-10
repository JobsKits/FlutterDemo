// To parse this JSON data, do
//
//     final regularModel = regularModelFromJson(jsonString);

import 'dart:convert';

RegularModel regularModelFromJson(String str) => RegularModel.fromJson(json.decode(str));

String regularModelToJson(RegularModel data) => json.encode(data.toJson());

class RegularModel {
    bool? birthday;
    Mail? mail;
    Phone? phone;
    bool? username;

    RegularModel({
        this.birthday,
        this.mail,
        this.phone,
        this.username,
    });

    factory RegularModel.fromJson(Map<String, dynamic> json) => RegularModel(
        birthday: json["birthday"],
        mail: json["mail"] == null ? null : Mail.fromJson(json["mail"]),
        phone: json["phone"] == null ? null : Phone.fromJson(json["phone"]),
        username: json["username"],
    );

    Map<String, dynamic> toJson() => {
        "birthday": birthday,
        "mail": mail?.toJson(),
        "phone": phone?.toJson(),
        "username": username,
    };
}

class Mail {
    bool? mail;
    bool? verify;

    Mail({
        this.mail,
        this.verify,
    });

    factory Mail.fromJson(Map<String, dynamic> json) => Mail(
        mail: json["mail"],
        verify: json["verify"],
    );

    Map<String, dynamic> toJson() => {
        "mail": mail,
        "verify": verify,
    };
}

class Phone {
    bool? phone;
    bool? verify;

    Phone({
        this.phone,
        this.verify,
    });

    factory Phone.fromJson(Map<String, dynamic> json) => Phone(
        phone: json["phone"],
        verify: json["verify"],
    );

    Map<String, dynamic> toJson() => {
        "phone": phone,
        "verify": verify,
    };
}
