// To parse this JSON data, do
//
//     final keyValueModel = keyValueModelFromJson(jsonString);

import 'dart:convert';

KeyValueModel keyValueModelFromJson(String str) => KeyValueModel.fromJson(json.decode(str));

String keyValueModelToJson(KeyValueModel data) => json.encode(data.toJson());

class KeyValueModel {
  String id;

  KeyValueModel({
    required this.id,
  });

  factory KeyValueModel.fromJson(Map<String, dynamic> json) => KeyValueModel(
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
      };
}
