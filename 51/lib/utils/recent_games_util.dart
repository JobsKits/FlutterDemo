import 'package:flutter_tiyu_app/utils/sp_util.dart';

///最近游戏的工具类
class RecentGamesUtil {
  //保存点击过的游戏
  static void saveGameId(int gameId) async {
    List<String> gameIdList = await SpUtil.getStringList('recentGames') ?? [];
    gameIdList.add(gameId.toString());
    gameIdList = gameIdList.toSet().toList();
    SpUtil.saveStringList('recentGames', gameIdList);
  }

  //获取最近游戏集合
  static Future<List<int>> getRecentGameIds() async {
    List<String> gameIdList = await SpUtil.getStringList('recentGames') ?? [];
    // 将字符串列表转换为 int 列表
    return gameIdList.map((id) => int.parse(id)).toList();
  }
}
