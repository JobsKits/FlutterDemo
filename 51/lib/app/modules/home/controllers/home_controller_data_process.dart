import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_const.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/constants/game_constants.dart';
import 'package:flutter_tiyu_app/kernel/helpers/helperFGBY.dart';

import '../../../../kernel/network/service.dart';

/// 首页相关数据处理
class HomeControllerDataProcess {
  /// 热门游戏列表
  static List<GameBeanItem> getHomeGames({
    required bool hasFakePG,
    HomeHotGameBean? hotGameBean,
  }) {
    List<GameBeanItem> fixedHotGames = [];
    if (hotGameBean != null) {
      // 棋牌/电子/体育等数据
      if (hotGameBean.gameList1 != null) {
        fixedHotGames.addAll(hotGameBean.gameList1!);
      }
      // 移除数据
      fixedHotGames.removeWhere((game) => game.state == 3);

      // 排序
      // fixedHotGames.sort((a, b) {
      //   int topDiff = (b.is_top ?? 0) - (a.is_top ?? 0);
      //   int hotDiff = (b.hot_val ?? 0) - (a.hot_val ?? 0);
      //   if (topDiff == 0) {
      //     // 如果 is_top 相同，则按 hot_val 排序
      //     if (hotDiff == 0) {
      //       // 如果 hot_val 也相同，则按 sub_play_id 或 play_id 排序
      //       return (b.sub_play_id ?? b.play_id ?? 0) -
      //           (a.sub_play_id ?? a.play_id ?? 0);
      //     } else {
      //       return hotDiff;
      //     }
      //   } else {
      //     return topDiff;
      //   }
      // });
    }

    for (int i = 0; i < fixedHotGames.length; i++) {
      var game = fixedHotGames[i];
      fixedHotGames[i].gameImgUrl = GameUtils.getHotGameImageUrl(
        playName: game.play_name!,
        upperPlayId: game.upper_play_id!,
        playId: game.play_id!,
        bigType: game.big_type!,
      );
    }
    return fixedHotGames;
  }

  /// 处理电子游戏
  static List<GameBeanItem> getGameElectronic({
    required HomeHotGameBean hotGameBean,
    required bool hasFakePG,
  }) {
    List<GameBeanItem> result = [];
    result = hotGameBean.gameList2 != null ? hotGameBean.gameList2! : [];
    if (hasFakePG) {
      result.removeWhere((game) => game.upper_play_id == 1380);
    }

    result.forEach((element) {
      var upperPlayId =
          element.upper_play_id ?? element.upper_id ?? element.play_id;
      element.gameImgUrl = GameUtils.getQPDZImg(
        playName: element.play_name ?? '',
        playId: element.play_id ?? 0,
        big_type: element.big_type ?? 0,
        upperPlayId: upperPlayId,
      );
    });

    return result;
  }

  /// 处理捕鱼游戏
  static List<GameBeanItem> getGameFishing({
    required HomeHotGameBean hotGameBean,
    required bool hasFakePG,
  }) {
    List<GameBeanItem> result = [];
    result = hotGameBean.gameList3 != null ? hotGameBean.gameList3! : [];
    result.removeWhere((game) =>
        game.state == 3 ||
        game.upper_play_id == 0 ||
        game.upper_play_id == game.play_id);
    result.forEach((element) {
      var upperPlayId =
          element.upper_play_id ?? element.upper_id ?? element.play_id;
      element.gameImgUrl = GameUtils.getQPDZImg(
        playName: element.play_name ?? '',
        playId: element.play_id ?? 0,
        big_type: element.big_type ?? 0,
        upperPlayId: upperPlayId,
      );
    });
    return result;
  }

  /// 处理棋牌游戏
  static List<GameBeanItem> getGameChess({
    required HomeHotGameBean hotGameBean,
    required bool hasFakePG,
  }) {
    List<GameBeanItem> result = [];
    result = hotGameBean.gameList5 != null ? hotGameBean.gameList5! : [];
    result.removeWhere((game) => game.state == 3);

    for (int i = 0; i < result.length; i++) {
      var game = result[i];
      result[i].gameImgUrl = GameUtils.getHotGameImageUrl(
        playName: game.play_name!,
        upperPlayId: game.upper_play_id!,
        playId: game.play_id!,
        bigType: game.big_type!,
      );
    }

    return result;
  }

  /// 处理区块链游戏
  static List<GameBeanItem> getGameBlockChain({
    required HomeHotGameBean hotGameBean,
    required bool hasFakePG,
  }) {
    List<GameBeanItem> result = [];
    result = hotGameBean.gameList8 != null ? hotGameBean.gameList8! : [];
    result.removeWhere((game) => game.state == 3);

    for (int i = 0; i < result.length; i++) {
      var game = result[i];
      result[i].gameImgUrl = GameUtils.getHotGameImageUrl(
        playName: game.play_name!,
        upperPlayId: game.upper_play_id!,
        playId: game.play_id!,
        bigType: game.big_type!,
      );
    }

    return result;
  }

  /// 获取3方参数
  static Map<String, dynamic> getPayload({
    required int playId,
    required String playName,
    num? gameType,
    int? upperPlayId,
    String? gtype,
  }) {
    print(
        "传递过来的大类ID：$gameType   playId:$playId   playName:$playName   upperPlayId:$upperPlayId   gtype:$gtype");
    Map<String, dynamic> payload = {
      'play_id': playId,
    };

    switch (gameType) {
      // 真人
      case HomeGameCategory.LIVE:
        if (playId == 412) {
          payload['data'] = {'type': 'SMG_titaniumLiveGames_MP_Baccarat'};
        } else if (playId == 1313) {
          // PRETTY真人
          payload['data'] = {'type': '1'};
        } else if (playId == 1034) {
          // 瓦力视讯
          payload['data'] = {'type': '80'};
        } else {
          payload['data'] = {'type': playName};
        }
        break;
      // 体育
      case HomeGameCategory.SPORTS:
        if (['BTI', 'SB'].contains(playName)) {
          payload['data'] = {'type': '1'};

          // IM电竞 PRETTY真人
        } else if ([981, 1313].contains(playId)) {
          payload['data'] = {'type': '1'};
        }
        break;
      // 捕鱼
      case HomeGameCategory.FISHING:
        var play;
        if ([381, 383].contains(upperPlayId)) {
          play = GameUtils.getPlayInfo('$upperPlayId');
        } else {
          play = GameUtils.getPlayInfo('$playId');
        }
        payload['play_id'] = upperPlayId ?? playId;
        payload['buyu_game_id'] = playId;
        if (['MGBY', 'THBY', 'CQ9BY', 'BSBY'].contains(playName)) {
          payload['play_id'] = play['main_id'];
          payload['data'] = {'type': play['play_name']};
        }

        if (['JDBBY'].contains(playName) || upperPlayId == 397) {
          payload['play_id'] = play?['main_id'] ?? upperPlayId ?? playId;
          payload['data'] = {'type': playName, 'gtype': 7};
        }

        if ([1032, 1038].contains(upperPlayId)) {
          payload['play_id'] = upperPlayId;
        }
        // if (['FGBY'].contains(playName) || [708].contains(upperPlayId)) {
        //   payload['play_id'] = play['main_id'];
        //   payload['data'] = {'type': helperFGBY.instance.getGameId(playId)};
        // }
        if ([383].contains(upperPlayId)) {
          payload['play_id'] = play['main_id'] ?? 383;
          payload['type'] = playId;
        }
        if ([381].contains(upperPlayId)) {
          payload['play_id'] = play['main_id'] ?? 381;
          payload['type'] = play['play_name'];
        }
        print("输出一下这是什么：${payload}");
        break;
      // 电子
      case HomeGameCategory.ELECTRONIC:
        payload['data'] = {'type': playName};
        payload['play_id'] = upperPlayId ?? playId;
        payload['data'] = {'gtype': gtype ?? ''};
        if ([1313].contains(playId)) {
          // PRETTY真人
          payload['data'] = {'type': '1'};
        }
        break;
      // 棋牌
      case HomeGameCategory.CHESS:
        payload['data'] = {'type': playName};
        payload['play_id'] = upperPlayId ?? playId;
        if ([340, 397].contains(playId)) {
          payload['data'] = {'type': playName, 'gtype': gtype};
        }

        if ([1326].contains(playId)) {
          payload['data'] = {'type': 1};
        }
        break;
      case HomeGameCategory.BLOCK_THIRD:
        payload['data'] = {'type': playName};
        payload['play_id'] = upperPlayId ?? playId;
        break;
      default:
        // payload['data'] = {'type': playName};
        // payload['play_id'] = upperPlayId ?? playId;
        break;
    }

    if ([1326, 1313].contains(playId)) {
      payload['type'] = 1;
    } else {
      payload['type'] = playName;
    }

    return payload;
  }
}
