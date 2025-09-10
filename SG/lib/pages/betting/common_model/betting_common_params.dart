import 'dart:ui';

import 'package:get/get_utils/get_utils.dart';

///投注模块公共常量配置
class BettingCommonConfig {
  ///赔率<1.1，不支援串关
  static const double unSupportDuplexOv = 1.10;

  ///只显示10条的默认高度， 这里考虑到10条item,1个title ，还有一个竞赛倒计时的title
  static const double rankListDefaultHeight_10 = 54 * 10 + 54 + 54;
}

///页面类型
enum BettingFromPageType {
  //main 底部主菜单
  mainMenuBettingCasinoType, //主菜单-娱乐城-我的投注列表
  mainMenuBettingSportType, //主菜单-体育-我的投注列表
  //browse
  browseMenuBettingCasinoType, //底部浏览菜单-投注tab-我的投注列表
  browseMenuBettingSportType, //底部浏览菜单-投注单tab-我的投注列表
  //side
  sideMenuBettingCasinoType, //侧边菜单-娱乐城-投注列表
  sideMenuBettingSportType, //侧边菜单-体育-投注列表

  insideBettingSportType; //底部菜单-体育tab-我的投注tab-投注列表

  ///来自main 底部主菜单, 需要分页
  static bool isFromMainMenu(BettingFromPageType? type) {
    return type == mainMenuBettingCasinoType || type == mainMenuBettingSportType;
  }

  ///来自底部浏览菜单, 不分页
  static bool isFromBrowseMenu(BettingFromPageType? type) {
    return type == browseMenuBettingCasinoType || type == browseMenuBettingSportType;
  }

  ///来自底部浏览菜单 - 体育的 我的投注
  static bool isFromBrowseMenuSport(BettingFromPageType? type) {
    return type == browseMenuBettingSportType;
  }

  ///来自侧边菜单
  static bool isFromSideMenu(BettingFromPageType? type) {
    return type == sideMenuBettingCasinoType || type == sideMenuBettingSportType;
  }
}

///体育 我的订单， item 类型
enum BettingOrderItemType {
  unBillList, //未结算
  billedList, //已结算
  unBillDetail, //明细对话框
  billedDetail; //明细对话框

  ///是否是 未结算
  bool isOrderUnBill() {
    return this == unBillList || this == unBillDetail;
  }

  ///是列表， 还是detail
  bool isOrderListItem() {
    return this == unBillList || this == billedList;
  }
}

///0：投注单 1:我的投注 3：风云榜 4:竞赛 5:所有投注
enum BettingTypeEnum {
  betBill(type: 0),
  myBet(type: 1),
  stormRanking(type: 3),
  raceRanking(type: 4),
  allBet(type: 5);

  final int type;

  const BettingTypeEnum({required this.type});

  ///是否是  3：风云榜 4:竞赛
  bool isRanking() {
    return this == stormRanking || this == raceRanking;
  }

  ///是否是  1:我的投注  5:所有投注
  bool isMyOrAllBet() {
    return this == myBet || this == allBet;
  }

  ///是否是投注单
  bool isBetBill() {
    return this == betBill;
  }
}

///查所有投注：type传0，就是所有投注的;查风云榜：同上，type传1，
///来自接口：{{web_url}}/member/bet/list
enum BettingCasinoRankTypeEnum {
  allBetting(type: "0"), //所有投注
  stormRanking(type: "1"); //风云榜

  final String type;

  const BettingCasinoRankTypeEnum({required this.type});
}

///娱乐城 - 我的投注 - 详情对话类型， 普通游戏、还有特有的小游戏
/// "game_class": "8",
// "game_name": "Limbo",
// "game_code": "limbo",
//        "game_class": "8",
//         "game_name": "Dice",
//         "game_code": "dice",
enum CasinoGameTypeEnum {
  game_common(type: "0", label: "common", gameCode: "common"), //普通游戏
  game_limbo(type: "1", label: "Limbo", gameCode: "limbo"),
  game_hilo(type: "2", label: "Hilo", gameCode: "hilo"),
  game_plinko(type: "3", label: "Plinko", gameCode: "plinko"),
  game_blackjack(type: "4", label: "Blackjack", gameCode: "blackjack"),
  game_mines(type: "5", label: "Mines", gameCode: "mines"),
  game_dice(type: "6", label: "Dice", gameCode: "dice"),
  game_crash(type: "7", label: "Crash", gameCode: "crash");

  final String type;
  final String gameCode; //类型码
  final String label;

  const CasinoGameTypeEnum({required this.type, required this.label, required this.gameCode});

  ///判断是否普通游戏
  bool isGameCommon() {
    return this == game_common;
  }

  ///是否是 crash 小游戏
  bool isGameCrash() {
    return this == game_crash;
  }

  ///匹配状态, 没有的话。
  static CasinoGameTypeEnum adaptor(String? gameCode) {
    return CasinoGameTypeEnum.values.firstWhereOrNull((element) => element.gameCode == gameCode) ??
        game_common;
  }
}

//Plinko游戏配置
enum PlinkoGameConfigEnum {
  factor_110(factor: 110, color: Color(0xFFFF003F), shadowColor: Color(0xFFA60004)),
  factor_41(factor: 41, color: Color(0xFFFF1837), shadowColor: Color(0xFFA60000)),
  factor_10(factor: 10, color: Color(0xFFFF302F), shadowColor: Color(0xFFA60000)),
  factor_05(factor: 5, color: Color(0xFFFF4827), shadowColor: Color(0xFFA70000)),
  factor_03(factor: 3, color: Color(0xFFFF6020), shadowColor: Color(0xFFA80100)),
  factor_1_5(factor: 1.5, color: Color(0xFFFF7818), shadowColor: Color(0xFFA93000)),
  factor_01(factor: 1, color: Color(0xFFFF9010), shadowColor: Color(0xFFAA4B00)),
  factor_0_5(factor: 0.5, color: Color(0xFFFFA808), shadowColor: Color(0xFFAA6300)),
  factor_0_3(factor: 0.3, color: Color(0xFFFFC000), shadowColor: Color(0xFFAB7900));

  final double factor;
  final Color color;
  final Color shadowColor;

  const PlinkoGameConfigEnum(
      {required this.factor, required this.color, required this.shadowColor});

  ///匹配状态, 没有的话。
  static PlinkoGameConfigEnum adaptor(String? value) {
    var targetValue = double.parse(value ?? "0");
    return PlinkoGameConfigEnum.values
            .firstWhereOrNull((element) => element.factor == targetValue) ??
        factor_0_3;
  }

  ///Plinko 结果背景颜色
  static colorAdaptor({String? row, int? index}) {
    var color = colors[row ?? "16"]?[index ?? 8];
    return color;
  }

  ///Plinko 结果背景阴影颜色
  static shadowsAdaptor({String? row, int? index}) {
    return shadows[row ?? "16"]?[index ?? 8];
  }

  static const colors = {
    "8": [
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa6020,
      0xFFfa8f11,
      0xFFfac000,
      0xFFfa8f11,
      0xFFfa6020,
      0xFFfa302f,
      0xFFfa223e,
    ],
    "9": [
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa6020,
      0xFFfa8f11,
      0xFFffac04,
      0xFFffac04,
      0xFFfa8f11,
      0xFFfa6020,
      0xFFfa302f,
      0xFFfa223e,
    ],
    "10": [
      0xFFfa223e,
      0xFFff2632,
      0xFFff4e27,
      0xFFfa6020,
      0xFFfa8f11,
      0xFFfac000,
      0xFFfa8f11,
      0xFFfa6020,
      0xFFff4e27,
      0xFFff2632,
      0xFFfa223e,
    ],
    "11": [
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa4527,
      0xFFfa681e,
      0xFFfa8c10,
      0xFFfaaf06,
      0xFFfaaf06,
      0xFFfa8c10,
      0xFFfa681e,
      0xFFfa4527,
      0xFFfa2234,
      0xFFfa223e,
    ],
    "12": [
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa4527,
      0xFFfa681e,
      0xFFfa8c10,
      0xFFfaa00c,
      0xFFfac000,
      0xFFfaa00c,
      0xFFfa7f17,
      0xFFfa681e,
      0xFFfa4527,
      0xFFfa302f,
      0xFFfa223e,
    ],
    "13": [
      0xFFfa223e,
      0xFFfa2235,
      0xFFfa4527,
      0xFFfa5922,
      0xFFfa7618,
      0xFFfa940e,
      0xFFfab104,
      0xFFfab104,
      0xFFfa940e,
      0xFFfa7618,
      0xFFfa5922,
      0xFFfa3a2c,
      0xFFfa223e,
      0xFFfa223e,
    ],
    "14": [
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa5224,
      0xFFfa681e,
      0xFFfa8c10,
      0xFFfaa00c,
      0xFFfac000,
      0xFFfaa00c,
      0xFFfa7f17,
      0xFFfa6e1b,
      0xFFfa5224,
      0xFFfa362d,
      0xFFfa223e,
      0xFFfa223e,
    ],
    "15": [
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa2235,
      0xFFfa4527,
      0xFFfa5922,
      0xFFfa7618,
      0xFFfa940e,
      0xFFfab104,
      0xFFfab104,
      0xFFfa940e,
      0xFFfa7618,
      0xFFfa5922,
      0xFFfa3a2c,
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa223e,
    ],
    "16": [
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa302f,
      0xFFfa5224,
      0xFFfa681e,
      0xFFfa8c10,
      0xFFfaa00c,
      0xFFfac000,
      0xFFfaa00c,
      0xFFfa7f17,
      0xFFfa6e1b,
      0xFFfa5224,
      0xFFfa362d,
      0xFFfa223e,
      0xFFfa223e,
      0xFFfa223e,
    ],
  };

  static const shadows = {
    "8": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFaa4b00,
      0xFFab7902,
      0xFFaa4b00,
      0xFFa81302,
      0xFFa61302,
      0xFFa61304,
    ],
    "9": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFaa4b00,
      0xFFab7902,
      0xFFab7902,
      0xFFaa4b00,
      0xFFa81302,
      0xFFa61302,
      0xFFa61304,
    ],
    "10": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFaa4b00,
      0xFFab7902,
      0xFFab7902,
      0xFFaa4b00,
      0xFFa81302,
      0xFFa61302,
      0xFFa61304,
      0xFFa61304,
    ],
    "11": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFa81a02,
      0xFFa94700,
      0xFFab6900,
      0xFFab6900,
      0xFFa94700,
      0xFFa81a02,
      0xFFa71302,
      0xFFa61302,
      0xFFa61304,
    ],
    "12": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFa81a02,
      0xFFa94700,
      0xFFab6900,
      0xFFab7902,
      0xFFab6900,
      0xFFa93a00,
      0xFFa71302,
      0xFFa61302,
      0xFFa61304,
      0xFFa61304,
    ],
    "13": [
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFa81a02,
      0xFFa94700,
      0xFFaa4f00,
      0xFFab6b01,
      0xFFab6b01,
      0xFFaa4f00,
      0xFFa94700,
      0xFFa81a02,
      0xFFa81302,
      0xFFa61302,
      0xFFa61304,
    ],
    "14": [
      0xFFa61304,
      0xFFa61304,
      0xFFa61302,
      0xFFa71302,
      0xFFa81a02,
      0xFFa94700,
      0xFFab6900,
      0xFFab7902,
      0xFFab6900,
      0xFFa94700,
      0xFFa81a02,
      0xFFa71302,
      0xFFa61302,
      0xFFa61304,
      0xFFa61304,
    ],
    "15": [
      0xFFa61304,
      0xFFa61304,
      0xFFa61302,
      0xFFa81302,
      0xFFa81a02,
      0xFFa94700,
      0xFFaa4f00,
      0xFFab6b01,
      0xFFab6b01,
      0xFFaa4f00,
      0xFFa94700,
      0xFFa81a02,
      0xFFa81302,
      0xFFa61302,
      0xFFa61304,
      0xFFa61304,
    ],
    "16": [
      0xFFa61304,
      0xFFa61304,
      0xFFa61304,
      0xFFa61302,
      0xFFa71302,
      0xFFa81a02,
      0xFFa94700,
      0xFFab6900,
      0xFFab6900,
      0xFFab7902,
      0xFFa94700,
      0xFFa81a02,
      0xFFa71302,
      0xFFa61302,
      0xFFa61304,
      0xFFa61304,
      0xFFa61304,
    ],
  };
}
