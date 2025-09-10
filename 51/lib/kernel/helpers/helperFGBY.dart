// ignore_for_file: camel_case_types

class helperFGBY {
  helperFGBY._privateConstructor();
  static final helperFGBY instance = helperFGBY._privateConstructor();

  final Map<int, String> _gameNames = {
    5001: '美人捕鱼',
    5002: '雷霆战警',
    5003: '捕鸟达人',
    5004: '欢乐捕鱼',
    5005: '天天捕鱼',
    5006: '捕鱼来了3D',
    5007: '魔法王者',
    5008: '猎鼠达人3D',
    5009: '美人鱼传说',
  };

  final _gameIds = {
    708001: 5001, // '美人捕鱼',
    708002: 5002, // '雷霆战警',
    708003: 5003, // '捕鸟达人',
    708004: 5004, // '欢乐捕鱼',
    708005: 5005, // '天天捕鱼',
    708006: 5006, // '捕鱼来了3D',
    708007: 5007, // '魔法王者',
    708008: 5008, // '猎鼠达人3D',
    708009: 5009, // '美人鱼传说',
  };

  Map<int, String> get getGameNames => _gameNames;

  int getGameId(int id) {
    return _gameIds[id] ?? 0;
  }
}
