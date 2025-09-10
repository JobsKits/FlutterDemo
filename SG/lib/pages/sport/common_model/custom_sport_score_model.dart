///主要是为了做适配， 赛事详情 和 投注详情的本地api model 不一样
///但 够需要使用到 比分组件，所以用这个model 来统一适配
class CustomSportScoreModel {
  // state.list.first.si
  int? si; //"si": 1, //球种Id
  //state.model.value.list?.first.ed;
  int? ed; //"ed": 1702155600, //赛事开始时间
  // state.list.first.atn
  String? atn; //"atn": "洛杉矶FC", //客队名称
  // state.list.first.htn
  String? htn; //"htn": "哥伦布机员", //主队名称
  // state.model.value.list?.first?.atpic
  String? atpic; //"atpic": "/sports/im/tm/62054.webp", //客队图片
  // state.model.value.list?.first?.htpic
  String? htpic; //"htpic": "/sports/im/tm/975.webp", //主队图片
  // state.model.value.list?.first?.hp
  int? hp; //"hp": 0, //主队得分
  // state.model.value.list?.first?.ap
  int? ap; //"ap": 0, //客队得分

  CustomSportScoreModel({
    this.si,
    this.ed,
    this.atn,
    this.htn,
    this.atpic,
    this.htpic,
    this.hp,
    this.ap,
  });
}
