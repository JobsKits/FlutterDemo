import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HomePageDetailEnum {
  collect, // 收藏
  recent, // 最近
  live, // 真人
  electronic, // 电子
  fishing, // 捕鱼
  chess, // 棋牌
  sports, // 体育
  lottery, // 彩票
  blockChain, // 区块链
}

enum GameTypeEnum {
  gameType1, // 用于场馆图片显示， 体育/真人
  gameType2, // 用于数据返回子游戏， 捕鱼/电子/棋牌
  gameType3, // 用于彩票子游戏， 彩票
  gameType4, // 用于收藏和最近 ？？
}

enum AssetsTypeEnum {
  netWork, // 网络图片
  local, // 本地图片
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

final Map<HomePageDetailEnum, int> homePageDetailCollectType = {
  HomePageDetailEnum.live: 11,
  HomePageDetailEnum.electronic: 12,
  HomePageDetailEnum.fishing: 13,
  HomePageDetailEnum.chess: 17,
  HomePageDetailEnum.sports: 15,
  HomePageDetailEnum.lottery: 16,
  HomePageDetailEnum.blockChain: 16,
};

/// 棋牌tab icon尺寸
final Map<int, Map<String, double>> chessTabIconSizeMap = {
  -1: {
    "w": 49.w,
    "h": 49.h,
  },
  297: {
    "w": 61.w,
    "h": 47.h,
  },
  299: {
    "w": 72.w,
    "h": 27.h,
  },
  382: {
    "w": 53.w,
    "h": 40.h,
  },
  388: {
    "w": 83.w,
    "h": 45.h,
  },
  393: {
    "w": 60.w,
    "h": 43.h,
  },
  394: {
    "w": 50.w,
    "h": 48.h,
  },
  401: {
    "w": 64.w,
    "h": 30.h,
  },
  404: {
    "w": 44.w,
    "h": 51.h,
  },
  417: {
    "w": 50.w,
    "h": 40.h,
  },
  506: {
    "w": 99.w,
    "h": 12.h,
  },
  709: {
    "w": 49.w,
    "h": 53.h,
  },
  744: {
    "w": 52.w,
    "h": 52.h,
  },
  745: {
    "w": 62.w,
    "h": 62.h,
  },
  746: {
    "w": 107.w,
    "h": 45.h,
  },
  927: {
    "w": 68.w,
    "h": 48.h,
  },
  928: {
    "w": 69.w,
    "h": 40.h,
  },
  1383: {
    "w": 50.w,
    "h": 50.h,
  },
};

/// 捕鱼tab icon尺寸
final Map<int, Map<String, double>> fishingTabIconSizeMap = {
  -1: {
    "w": 49.w,
    "h": 49.h,
  },
  381: {
    "w": 66.w,
    "h": 37.h,
  },
  383: {
    "w": 54.w,
    "h": 49.h,
  },
  390: {
    "w": 54.w,
    "h": 49.h,
  },
  396: {
    "w": 43.w,
    "h": 43.h,
  },
  397: {
    "w": 66.w,
    "h": 36.h,
  },
  399: {
    "w": 74.w,
    "h": 33.h,
  },
  407: {
    "w": 44.w,
    "h": 51.h,
  },
  408: {
    "w": 82.w,
    "h": 29.h,
  },
  708: {
    "w": 49.w,
    "h": 53.h,
  },
  747: {
    "w": 72.w,
    "h": 46.h,
  },
  1388: {
    "w": 50.w,
    "h": 50.h,
  },
};

/// 电子tab icon尺寸
final Map<int, Map<String, double>> electronicTabIconSizeMap = {
  -1: {
    "w": 49.w,
    "h": 49.h,
  },
  340: {
    "w": 66.w,
    "h": 36.h,
  },
  343: {
    "w": 43.w,
    "h": 43.h,
  },
  403: {
    "w": 82.w,
    "h": 29.h,
  },
  405: {
    "w": 57.w,
    "h": 50.h,
  },
  413: {
    "w": 75.w,
    "h": 29.h,
  },
  414: {
    "w": 60.w,
    "h": 42.h,
  },
  415: {
    "w": 66.w,
    "h": 37.h,
  },
  416: {
    "w": 53.w,
    "h": 43.h,
  },
  508: {
    "w": 38.w,
    "h": 48.h,
  },
  571: {
    "w": 67.w,
    "h": 37.h,
  },
  707: {
    "w": 54.w,
    "h": 54.h,
  },
  711: {
    "w": 60.w,
    "h": 60.h,
  },
  926: {
    "w": 44.w,
    "h": 49.h,
  },
  929: {
    "w": 69.w,
    "h": 40.h,
  },
  938: {
    "w": 47.w,
    "h": 47.h,
  },
  939: {
    "w": 62.w,
    "h": 48.h,
  },
  960: {
    "w": 53.w,
    "h": 40.h,
  },
  983: {
    "w": 70.w,
    "h": 43.h,
  },
  1305: {
    "w": 84.w,
    "h": 42.h,
  },
  1306: {
    "w": 64.w,
    "h": 48.h,
  },
  1307: {
    "w": 82.w,
    "h": 28.h,
  },
  1310: {
    "w": 54.w,
    "h": 46.h,
  },
  1311: {
    "w": 79.w,
    "h": 27.h,
  },
  1315: {
    "w": 82.w,
    "h": 29.h,
  },
  1320: {
    "w": 58.w,
    "h": 47.h,
  },
  1321: {
    "w": 56.w,
    "h": 59.h,
  },
  1323: {
    "w": 75.w,
    "h": 23.h,
  },
  1324: {
    "w": 68.w,
    "h": 47.h,
  },
  1325: {
    "w": 43.w,
    "h": 59.h,
  },
  1380: {
    "w": 67.w,
    "h": 37.h,
  },
  1382: {
    "w": 67.w,
    "h": 37.h,
  },
  1386: {
    "w": 50.w,
    "h": 50.h,
  },
  1411: {
    "w": 50.w,
    "h": 50.h,
  },
};
