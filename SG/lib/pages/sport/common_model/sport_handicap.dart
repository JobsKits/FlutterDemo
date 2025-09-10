
///盘口数据 最小颗粒 model
class Handicap {
  int? bt; //投注项id
  String? btn; //下拉选单显示名称 ,"让分盘"
  //需求变更：0103。
  //获取列表投注项 bettype/filter
  //这只接口返回的字段增加 egi
  //原本是用bt 来跟 event/list 取回来的资料做对应,需要改成用 bt 跟egi 都要相同来对应

  int? egi; //"egi": 1,

  Handicap({
    this.bt,
    this.btn,
    this.egi,
  });

  factory Handicap.fromJson(Map<String, dynamic> json) => Handicap(
    bt: json["bt"],
    btn: json["btn"],
    egi: json["egi"],
  );

  Map<String, dynamic> toJson() => {
    "bt": bt,
    "btn": btn,
    "egi": egi,
  };
}