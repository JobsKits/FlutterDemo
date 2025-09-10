/// 游戏类别
class GameTypeConstants {
  /// 棋牌
  static const String chess = 'chess';

  /// 电子
  static const String electronic = 'electronic';

  /// 体育
  static const String sports = 'sports';

  /// 真人
  static const String live = 'live';

  /// 捕鱼
  static const String fishing = 'fishing';

  /// 彩票
  static const String lottery = 'lottery';

  /// 彩票
  static const String blockchain = 'blockchain';

  /// 试玩
  static const String gameTry = 'gameTry';
}

/// 游戏菜单类型 version_type tab
/// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
const Map<int, String> gameMenuSortMap = {
  1: GameTypeConstants.chess,
  2: GameTypeConstants.lottery,
  3: GameTypeConstants.electronic,
  4: GameTypeConstants.fishing,
  5: GameTypeConstants.live,
  6: GameTypeConstants.sports,
  39: GameTypeConstants.blockchain,
  105: GameTypeConstants.gameTry,
};

/// 三方彩票ID
const Map<String, int> lotteryTypeIdMap = {
  'GPI': 504,
  'DB': 1385,
  'SBCP': 1326,
  'SGWIN': 1410,
  'tianCheng': 468
};
