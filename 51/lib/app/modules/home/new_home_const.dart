import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import 'home_view_const.dart';

///新首页的配置信息
final homeTabMap = {};

class HomeGameCategory {
  static const CHESS_AND_CARDS_KEY = 1; //棋牌的key
  static const LOTTERY_KEY = 2; //彩票的key
  static const ELECTRONIC_KEY = 3; //电子的key
  static const FISHING_KEY = 4; //捕鱼的key
  static const LIVE_KEY = 5; //真人的key
  static const SPORTS_KEY = 6; //体育的key
  static const BLOCKCHAIN_KEY = 39; //区块链的key
  static const COLLECT_KEY = 1001; //收藏的key
  static const RECENT_KEY = 1002; //最近的key
  static const RECOMMEND_KEY = 1003; //推荐的key
  static const GAME_TRY_KEY = 105; //试玩的key
  //实际打开游戏应该用下面这个
  static const CHESS = 1;
  static const ELECTRONIC = 2;
  static const FISHING = 3;
  static const LIVE = 4;
  static const SPORTS = 5;
  static const LOTTERY = 7;
  static const BLOCK_THIRD = 10;

  ///目前支持的游戏大类
  ///1:棋牌、2:彩票、3:电子、4:捕鱼、5:真人、6:体育、39:区块链
  static List<int> supportList = [
    CHESS_AND_CARDS_KEY,
    LOTTERY_KEY,
    ELECTRONIC_KEY,
    FISHING_KEY,
    LIVE_KEY,
    SPORTS_KEY,
    BLOCKCHAIN_KEY,
    GAME_TRY_KEY
  ];
}

enum GameCategory {
  chessAndCards, // 棋牌
  lottery, // 彩票
  electronic, // 电子
  fishing, // 捕鱼
  live, // 真人
  sports, // 体育
  blockchain, // 区块链
  collect, // 收藏
  recent, // 最近
  recommend, // 推荐
  gameTry, // 试玩
}

/// 映射表：后台返回的数字 -> 逻辑层枚举
const Map<int, GameCategory> backendKeyToCategory = {
  1: GameCategory.chessAndCards,
  2: GameCategory.lottery,
  3: GameCategory.electronic,
  4: GameCategory.fishing,
  5: GameCategory.live,
  6: GameCategory.sports,
  39: GameCategory.blockchain,
  1001: GameCategory.collect,
  1002: GameCategory.recent,
  1003: GameCategory.recommend,
  1004: GameCategory.gameTry,
};

/// 根据后台返回的 key 动态获取枚举值
GameCategory? categoryFromKey(int key) => backendKeyToCategory[key];

String getPageKey(int id) {
  ///1:棋牌、2:彩票、3:电子、4:捕鱼、5:真人、6:体育、39:区块链
  String pageKey = "";
  switch (id) {
    case HomeGameCategory.CHESS_AND_CARDS_KEY:
      pageKey = "chess";
      break;
    case HomeGameCategory.LOTTERY_KEY:
      pageKey = "lottery";
      break;
    case HomeGameCategory.ELECTRONIC_KEY:
      pageKey = "electronic";
      break;
    case HomeGameCategory.FISHING_KEY:
      pageKey = "fishing";
      break;
    case HomeGameCategory.LIVE_KEY:
      pageKey = "live";
      break;
    case HomeGameCategory.SPORTS_KEY:
      pageKey = "sports";
      break;
    case HomeGameCategory.BLOCKCHAIN_KEY:
      pageKey = "blockchain";
      break;
  }
  return pageKey;
}

enum GameTypeEnum {
  gameType1, // 用于场馆图片显示， 体育/真人
  gameType2, // 用于数据返回子游戏， 捕鱼/电子/棋牌
  gameType3, // 用于彩票子游戏， 彩票
  gameType4, // 用于收藏和最近 ？？
}

final Map<HomePageDetailEnum, int> homePageDetailIndex = {
  HomePageDetailEnum.collect: 1,
  HomePageDetailEnum.recent: 2,
  HomePageDetailEnum.live: 3,
  HomePageDetailEnum.electronic: 4,
  HomePageDetailEnum.fishing: 5,
  HomePageDetailEnum.chess: 6,
  HomePageDetailEnum.sports: 7,
  HomePageDetailEnum.lottery: 7,
};
