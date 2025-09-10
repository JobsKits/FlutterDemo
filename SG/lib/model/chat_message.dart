// To parse this JSON data, do
//
//     final chatMessageModel = chatMessageModelFromJson(jsonString);

import 'dart:convert';

ChatMessageModel chatMessageModelFromJson(String str) => ChatMessageModel.fromJson(json.decode(str));

String chatMessageModelToJson(ChatMessageModel data) => json.encode(data.toJson());

class ChatMessageModel {
  String? u;
  String? c;
  String? s;
  String? n;
  String? v;
  int? t;
  bool? showed;

  ChatMessageModel({
    this.u,
    this.c,
    this.n,
    this.t,
    this.s,
    this.v,
    this.showed,
  });

  ChatMessageModel copyWith({
    String? u,
    String? c,
    String? s,
    String? n,
    String? v,
    int? t,
    bool? showed,
  }) =>
      ChatMessageModel(
        u: u ?? this.u,
        c: c ?? this.c,
        n: n ?? this.n,
        t: t ?? this.t,
        s: s ?? this.s,
        v: v ?? this.v,
        showed: showed ?? this.showed,
      );

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) => ChatMessageModel(
    u: json["u"],
    c: json["c"],
    n: json["n"],
    t: json["t"],
    s: json["s"],
    v: json["v"],
    showed: json["showed"],
  );

  Map<String, dynamic> toJson() => {
    "u": u,
    "c": c,
    "n": n,
    "t": t,
    "s": s,
    "v": v,
    "showed": showed,
  };
}
