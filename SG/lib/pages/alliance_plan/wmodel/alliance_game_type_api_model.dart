
///联盟计划-游戏类型， 下拉框- /agency/commission/models/list
class AllianceGameTypeApiModel {
  String? id;
  String? name;

  AllianceGameTypeApiModel({
    this.id,
    this.name,
  });

  factory AllianceGameTypeApiModel.fromJson(Map<String, dynamic> json) => AllianceGameTypeApiModel(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
