import 'package:flutter_bet/generated/l10n.dart';
import 'dart:math';
import 'dart:ui';

import 'package:get/get.dart';

///联盟计划-工具数据转化
class AllianceCommonData {
  ///int type; //类型
  static const pageSize = 10;
}



///我的推广 下的更多 会用到
enum AlliancePageEnum {
  study(pageIndex: 0), //我的推广界面
  myPromotion(pageIndex: 1), //我的推广界面
  myCommission(pageIndex: 2), //我的佣金界面
  myPerformance(pageIndex: 3), //我的业绩界面
  allData(pageIndex: 4), //所有数据界面
  directFinance(pageIndex: 5), //直属财务界面
  directBetting(pageIndex: 6), //直属投注界面
  directUser(pageIndex: 7), //直属用户界面
  commissionRate(pageIndex: 8); //下属的投注界面

  final int pageIndex; //tab 第几个，从0开始
  const AlliancePageEnum({required this.pageIndex});

  ///根据pageIndex 适配不同的
  static AlliancePageEnum? adaptor(int pageIndex){
    return  AlliancePageEnum.values.firstWhereOrNull((element) => element.pageIndex ==pageIndex);
  }
}

///我的佣金中的 类型
enum TypeEnum {
  basketball(type: 1),
  football(type: 2),
  tennis(type: 3);

  final int type;

  // final String? _name;

  const TypeEnum({required this.type});

  static getTypeNme(int type) {
    // for (var value in TypeEnum.values) {
    //   if(value.type == type){
    //     return value.name;
    //   }
    // }
    switch (type) {
      case 1:
        return S.current.random_text_65;
      case 2:
        return S.current.sport_bet_football;
      case 3:
        return S.current.sport_bet_tennis;
      default:
        return "";
    }
  }
}

///返佣比例界面, 与后端约定的 数值
///1真人 2捕鱼 3电子 4体育 5棋牌 6电竞
///【0313】【需求变更】使用接口icon
enum CommissionRateTypeEnum {
  other(type: "0",asset: "assets/images/alliance/ic_alliance_tab_ty.webp"),
  realPerson(type: "1",asset: "assets/images/alliance/ic_alliance_tab_zr.webp"), //真人
  fishing(type: "2",asset: "assets/images/alliance/ic_alliance_tab_py.webp"),//捕鱼
  electronic(type: "3",asset: "assets/images/alliance/ic_alliance_tab_lhj.webp"), //电子 改为 也是老虎机
  sport(type: "4",asset: "assets/images/alliance/ic_alliance_tab_ty.webp"), //体育
  chessCard(type: "5",asset: "assets/images/alliance/ic_alliance_tab_qp.webp"), //棋牌
  eSportGame(type: "6",asset: "assets/images/alliance/ic_alliance_tab_lhj.webp"),; //电竞

  final String type;
  final String asset;

  const CommissionRateTypeEnum({required this.type,required this.asset});

  ///根据 type 返回 枚举
  static CommissionRateTypeEnum? getTypeEnum(String? type) {
    //接口存在  "model_ids": "4,3", 的情况
    return CommissionRateTypeEnum.values.firstWhereOrNull((element) => type == element.type);
  }
}

enum ProcessLevel {
  levelContent(level: 0, color: Color(0xFFFF9D00)),
  levelA(level: 1, color: Color(0xFF69E244)),
  levelB(level: 2, color: Color(0xFF1475E1)),
  levelC(level: 3, color: Color(0xFFFFB1FB));

  final int level;

  // final String name;
  final Color color;

  const ProcessLevel({required this.level, required this.color});

  String getLevelName() {
    switch (level) {
      case 0:
        return S.current.random_text_196;
      case 1:
        return "A";
      case 2:
        return "B";
      case 3:
        return "C";
      default:
        return "";
    }
  }
}

///联盟计划-推广教程- 的流程线、箭头类型 和 无箭头线类型
enum ProcessLine {
  arrow(type: 1),
  arrowLeft(type: 2),
  arrowRight(type: 3),
  line(type: 21);

  final int type;

  const ProcessLine({required this.type});
}



///title 排序状态
///sort_type=排序方式 desc:降序  asc:升序
enum SortState {
  up(type: 1, sort: 'asc'), //升序
  down(type: 2, sort: 'desc'), //降序
  none(type: 0, sort: '');

  final int type;
  final String sort;

  const SortState({required this.type, required this.sort});
}
