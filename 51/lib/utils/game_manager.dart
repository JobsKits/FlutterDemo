/// 游戏配置管理类
class GameManager {
  late bool _isOpenCp;
  late Map<int, int> _gameState;

  GameManager._privateConstructor();
  static final GameManager instance = GameManager._privateConstructor();

  // 彩票是否可用？？？
  bool get isOpenCp => _isOpenCp;
  void setIsOpenCp(bool isOpenCp) {
    _isOpenCp = isOpenCp;
  }

  // 所有游戏销售状态
  Map<int, int> get gameState => _gameState;
  void setGameState(Map<int, int> gameState) {
    _gameState = gameState;
  }
}
