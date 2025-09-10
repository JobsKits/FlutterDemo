import 'dart:convert';

import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/home/new_home_const.dart';
// import 'package:flutter_tiyu_app/constants/game_constants.dart';
import 'package:flutter_tiyu_app/constants/game_constants.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/configs/play_info.dart';
import 'package:flutter_tiyu_app/kernel/configs/plays_strategy/plays_strategy.dart';
// import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/game_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';

import '../../gen/assets.gen.dart';

/// 游戏处理工具
class GameUtils {
  static List<int> getCategoryKeys(String cat) {
    List<int> arr = [];
    playInfo.forEach((key, value) {
      if (value.containsKey('cat') && value['cat'] == cat) {
        arr.add(key);
      }
    });
    return arr;
  }

  static String getGameShowName(int playId) {
    return playInfo[playId]?["play_cname"] ?? "";
  }

  /// 游戏分类
  static int getGameCategory(int playId) {
    final qipaiIds = getCategoryKeys('QP');
    // 744 赢博棋牌 1034 瓦力棋牌 (不要了)
    qipaiIds.addAll([744, 1033, 1390]);

    final dianziIds = getCategoryKeys('DZ');
    // 748 鑫豪爷电子 (不要了)
    dianziIds.addAll([748, 1386]);

    final buyuIds = getCategoryKeys('BY');
    buyuIds.addAll([749, 1032, 1388, 1032]);

    final tiyuIds = getCategoryKeys('TY');
    tiyuIds.addAll([1389, 1387]);
    final zhenrenIds = getCategoryKeys('AG');
    zhenrenIds.addAll([1033, 1034, 1384]);

    final hongbaoIds = getCategoryKeys('HB');

    final caipiaoIds = getCategoryKeys('CP');

    if (qipaiIds.contains(playId)) {
      return 1; // 棋牌
    } else if (dianziIds.contains(playId)) {
      return 2; // 电子
    } else if (buyuIds.contains(playId)) {
      return 3; // 捕鱼
    } else if (tiyuIds.contains(playId)) {
      return 5; // 体育
    } else if (zhenrenIds.contains(playId)) {
      return 6; // 真人视讯
    } else if (hongbaoIds.contains(playId)) {
      return 7; // 红包
    } else if (caipiaoIds.contains(playId)) {
      return 8; // 彩票
    } else if ([1390, 1391].contains(playId)) {
      return 10; // 体育
    } else {
      return 4; // caipai
    }
  }

  /// 游戏分类
  static int getGameCategory2(int playId) {
    final qipaiIds = getCategoryKeys('QP');
    // 744 赢博棋牌 1034 瓦力棋牌 (不要了)
    qipaiIds.addAll([744, 1034]);

    final dianziIds = getCategoryKeys('DZ');
    // 748 鑫豪爷电子 (不要了)
    dianziIds.addAll([748, 1386]);

    final buyuIds = getCategoryKeys('BY');
    buyuIds.addAll([749, 1032, 1388]);

    final tiyuIds = getCategoryKeys('TY');
    tiyuIds.addAll([1389, 1387, 1035]);

    final zhenrenIds = getCategoryKeys('AG');
    zhenrenIds.addAll([1033]);

    final hongbaoIds = getCategoryKeys('HB');

    final caipiaoIds = getCategoryKeys('CP');
    caipiaoIds.add(1410);
    if (qipaiIds.contains(playId)) {
      return 1; // 棋牌
    } else if (caipiaoIds.contains(playId)) {
      return 2; // 彩票
    } else if (dianziIds.contains(playId)) {
      return 3; // 电子
    } else if (buyuIds.contains(playId)) {
      return 4; // 捕鱼
    } else if (zhenrenIds.contains(playId)) {
      return 5; // 真人视讯
    } else if (tiyuIds.contains(playId)) {
      return 6; // 体育
    } else if ([1390, 1391].contains(playId)) {
      return 10; // 体育
    } else {
      return 0; // caipai
    }
  }

  ///  判断大游戏分类
  static determineType(int bigType) {
    String bigClass = '';
    switch (bigType) {
      case HomeGameCategory.CHESS:
        bigClass = 'qipai';
        break;
      case HomeGameCategory.ELECTRONIC:
        bigClass = 'dianzi';
        break;
      case HomeGameCategory.FISHING:
        bigClass = 'buyu';
        break;
      case HomeGameCategory.SPORTS:
        bigClass = 'tiyu';
        break;
      case HomeGameCategory.LIVE:
        bigClass = 'zhenren';
        break;
      case HomeGameCategory.LOTTERY:
        bigClass = 'caipiao';
        break;
      case HomeGameCategory.BLOCK_THIRD:
        bigClass = 'qukuailian';
        break;
    }
    return bigClass;
  }

  // 根据ID判断游戏分类
  static determineTypeConst(int id) {
    switch (getGameCategory(id)) {
      case 1:
        return GameTypeConstants.chess;
      case 2:
        return GameTypeConstants.electronic;
      case 3:
        return GameTypeConstants.fishing;
      case 4:
        return GameTypeConstants.chess;
      case 5:
        return GameTypeConstants.sports;
      case 6:
        return GameTypeConstants.live;
      case 10:
        return GameTypeConstants.blockchain;
      // 其他类型都暂时不考虑
      default:
        return GameTypeConstants.lottery;
    }
  }

  // 根据ID判断游戏分类
  static determineTypeConst2(int id) {
    switch (getGameCategory2(id)) {
      case 1:
        return GameTypeConstants.chess;
      case 2:
        return GameTypeConstants.lottery;
      case 3:
        return GameTypeConstants.electronic;
      case 4:
        return GameTypeConstants.fishing;
      case 5:
        return GameTypeConstants.live;
      case 6:
        return GameTypeConstants.sports;
      case 10:
        return "blockChain";

      // 其他类型都暂时不考虑
      default:
        return GameTypeConstants.chess;
    }
  }

  static determineTypeConst3(int bigType) {
    switch (bigType) {
      case HomeGameCategory.CHESS:
        return GameTypeConstants.chess;
      case HomeGameCategory.LOTTERY:
        return GameTypeConstants.lottery;
      case HomeGameCategory.ELECTRONIC:
        return GameTypeConstants.electronic;
      case HomeGameCategory.FISHING:
        return GameTypeConstants.fishing;
      case HomeGameCategory.LIVE:
        return GameTypeConstants.live;
      case HomeGameCategory.SPORTS:
        return GameTypeConstants.sports;
      case HomeGameCategory.BLOCK_THIRD:
        return "blockChain";

      // 其他类型都暂时不考虑
      default:
        return GameTypeConstants.chess;
    }
  }

  /// 返回int
  static int ensureInt(dynamic value) {
    if (value is int) {
      return value;
    } else if (value is String) {
      return int.tryParse(value) ?? 0; // 尝试转换字符串为整数，转换失败返回默认值 0
    } else {
      return 0; // 非法类型返回默认值 0
    }
  }

  /// 复制
  static Map<String, dynamic> deepCopy(Map original) {
    // 创建一个新的 Map 来存储深拷贝的结果
    final copiedMap = <String, dynamic>{};

    // 遍历原始 Map 的所有键值对
    original.forEach((key, value) {
      // 处理嵌套的 Map
      if (value is Map) {
        copiedMap[key] = deepCopy(value);
      }
      // 处理嵌套的 List
      else if (value is List) {
        copiedMap[key] =
            List.from(value.map((item) => item is Map ? deepCopy(item) : item));
      } else {
        // 对于基本数据类型，直接复制
        copiedMap[key] = value;
      }
    });

    return copiedMap;
  }

//https://image3.typay2.com/staticQ/platform/51/game/electronic/color_415.png
  static String getGitColorIcon({
    required num? bigType,
    required num? playId,
  }) {
    String imgDomain = TenantManager.instance.appImgDomainPath.value;
    // 返回图片路径
    String imgUrl = '';
    switch (bigType) {
      case HomeGameCategory.FISHING:
        imgUrl = '$imgDomain/staticQ/platform/51/game/fish/color_$playId.png';
        break;
      case HomeGameCategory.BLOCK_THIRD:
        imgUrl =
            '$imgDomain/staticQ/platform/51/game/blockThird/color_$playId.png';
        break;
      case HomeGameCategory.ELECTRONIC:
        imgUrl =
            '$imgDomain/staticQ/platform/51/game/electronic/color_$playId.png';
        break;
      case HomeGameCategory.SPORTS:
        imgUrl = '$imgDomain/staticQ/platform/51/game/sports/color_$playId.png';
        break;
      case HomeGameCategory.LIVE:
        imgUrl = '$imgDomain/staticQ/platform/51/game/live/color_$playId.png';
        break;
      case HomeGameCategory.CHESS:
        imgUrl = '$imgDomain/staticQ/platform/51/game/chess/color_$playId.png';
        break;
      case HomeGameCategory.LOTTERY:
        imgUrl =
            '$imgDomain/staticQ/platform/51/game/lottery/color_$playId.png';
        break;
      default:
        break;
    }
    return imgUrl;
  }

  /// 热门游戏图片路径
  static getHotGameImageUrl(
      {required String playName,
      required num upperPlayId,
      required num bigType,
      required int playId,
      bool isHomeBig = false}) {
    /// 从返回的租户信息中获取 enantInfo.imgs_domain[0].domain_addr
    String imgDomain = TenantManager.instance.appImgDomainPath.value;
    // 返回图片路径
    String imgUrl = '';

    String lang = AppConfigs.lang;
    bool isBigClass = upperPlayId == playId; //是否是游戏平台
    switch (bigType) {
      case HomeGameCategory.FISHING:
        imgUrl = '$imgDomain/staticQ/buyu/$upperPlayId/$lang/game_$playId.png';
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl = '$imgDomain/staticQ/platform/51/game/fish/m_$playId.png';
          } else {
            imgUrl = '$imgDomain/staticQ/platform/51/game/fish/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.BLOCK_THIRD:
        imgUrl =
            '$imgDomain/staticQ/qukuailian/$upperPlayId/$lang/game_$playId.png';
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl =
                '$imgDomain/staticQ/platform/51/game/blockThird/m_$playId.png';
          } else {
            imgUrl =
                '$imgDomain/staticQ/platform/51/game/blockThird/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.ELECTRONIC:
        if (upperPlayId == 340) {
          imgUrl =
              '$imgDomain/staticQ/dianzi/$upperPlayId/$lang/game_$playName.png';
        } else {
          imgUrl =
              '$imgDomain/staticQ/dianzi/$upperPlayId/$lang/game_$playId.png';
        }
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl =
                '$imgDomain/staticQ/platform/51/game/electronic/m_$playId.png';
          } else {
            imgUrl =
                '$imgDomain/staticQ/platform/51/game/electronic/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.SPORTS:
        imgUrl = getPlatformImgUrl(
          playId: playId,
          gameType: GameTypeConstants.sports,
          prefix: 'g',
        );
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl = '$imgDomain/staticQ/platform/51/game/sports/m_$playId.png';
          } else {
            imgUrl = '$imgDomain/staticQ/platform/51/game/sports/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.LIVE:
        imgUrl = getPlatformImgUrl(
          playId: playId,
          gameType: GameTypeConstants.live,
          prefix: 'g',
        );
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl = '$imgDomain/staticQ/platform/51/game/live/m_$playId.png';
          } else {
            imgUrl = '$imgDomain/staticQ/platform/51/game/live/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.CHESS:
        imgUrl = '$imgDomain/staticQ/qipai/$upperPlayId/$lang/game_$playId.png';
        if (isBigClass) {
          if (isHomeBig) {
            imgUrl = '$imgDomain/staticQ/platform/51/game/chess/m_$playId.png';
          } else {
            imgUrl = '$imgDomain/staticQ/platform/51/game/chess/h_$playId.png';
          }
        }
        break;
      case HomeGameCategory.LOTTERY:
        imgUrl = '$imgDomain/staticQ/platform/51/game/lottery/h_$playId.png';
        break;
      default:
        imgUrl =
            "$imgDomain/staticQ/${determineType(ensureInt(upperPlayId))}/$upperPlayId/game_$playId.png";
        break;
    }
    return imgUrl;
  }

  /// 热门游戏图片路径
  static getColorIconImageUrl(
      {required num bigType, required int playId, bool isHomeBig = false}) {
    /// 从返回的租户信息中获取 enantInfo.imgs_domain[0].domain_addr
    String imgDomain = TenantManager.instance.appImgDomainPath.value;
    // 返回图片路径
    String imgUrl = '';

    String lang = AppConfigs.lang;
    switch (bigType) {
      case HomeGameCategory.FISHING:
        imgUrl = '$imgDomain/staticQ/platform/51/game/fish/g_$playId.png';
        break;
      case HomeGameCategory.BLOCK_THIRD:
        imgUrl = '$imgDomain/staticQ/platform/51/game/blockThird/g_$playId.png';
        break;
      case HomeGameCategory.ELECTRONIC:
        imgUrl = '$imgDomain/staticQ/platform/51/game/electronic/g_$playId.png';
        break;
      case HomeGameCategory.SPORTS:
        imgUrl = '$imgDomain/staticQ/platform/51/game/sports/g_$playId.png';
        break;
      case HomeGameCategory.LIVE:
        imgUrl = '$imgDomain/staticQ/platform/51/game/live/g_$playId.png';
        break;
      case HomeGameCategory.CHESS:
        imgUrl = '$imgDomain/staticQ/platform/51/game/chess/g_$playId.png';
        break;
      case HomeGameCategory.LOTTERY:
        imgUrl = '$imgDomain/staticQ/platform/51/game/lottery/g_$playId.png';
        break;
      default:
        imgUrl = "";
        break;
    }
    return imgUrl;
  }

  static Map<String, dynamic> parseJson(String? msg) {
    if (msg == null || msg.isEmpty) {
      return {};
    }

    try {
      return json.decode(msg);
    } catch (e) {
      // 处理解析错误，可以记录日志或返回一个默认值
      print('解析 JSON 时出错: $e');
      return {};
    }
  }

  /// 获取收藏列表的图片
  static String getCollectionImageUrl(
      HomeCollectionListItemBean collectionItem) {
    // 场馆目前需要取的本地， 真人/体育/捕鱼， 其他先取线上地址

    int playId = collectionItem.play_id!;
    // 收藏的彩票
    if (collectionItem.play_big_type == 7) {
      return 'assets/theme1/images/lottery/m_${playId}.png';
    }
    var msgObj =
        collectionItem.msg != null ? parseJson(collectionItem.msg!) : {};

    var upperId = msgObj["upper_id"];
    var upperPlayId = msgObj["upper_play_id"];
    var mainId = msgObj["main_id"];
    var bigType = msgObj["big_type"];
    var parentId = upperPlayId ?? upperId;

    /// 棋牌 和 电子 （ 判断的上级场馆）
    if (bigType != null && bigType == HomeGameCategory.CHESS ||
        bigType == HomeGameCategory.ELECTRONIC ||
        bigType == HomeGameCategory.FISHING ||
        bigType == HomeGameCategory.BLOCK_THIRD) {
      return getQPDZImg(
          playName: collectionItem.playName!,
          playId: playId,
          upperPlayId: parentId,
          big_type: bigType);
    }

    if (bigType != null && bigType == HomeGameCategory.SPORTS) {
      return getPlatformImgUrl(
        playId: playId,
        gameType: GameTypeConstants.sports,
        prefix: 'g',
      );
    }

    /// 真人视讯 以及 体育场馆图
    if (bigType != null && bigType == HomeGameCategory.LIVE) {
      return getPlatformImgUrl(
        playId: playId,
        gameType: GameTypeConstants.live,
        prefix: 'g',
      );
    }
    return msgObj['imgUrl'] ?? msgObj['gameImgUrl'] ?? '';
  }

  /// 棋牌、电子 图片路径
  static String getQPDZImg({
    required String playName,
    int? playId,
    num? upperPlayId,
    num? big_type,
    GameChessAndElectronicItemBean? itemData,
  }) {
    /// 从返回的租户信息中获取 enantInfo.imgs_domain[0].domain_addr
    String imgDomain = TenantManager.instance.appImgDomainPath.value;

    String lang = AppConfigs.lang;

    String imgUrl =
        "$imgDomain/staticQ/${determineType((big_type ?? 0).toInt())}/$upperPlayId/game_$playId.png";

    switch (big_type) {
      case HomeGameCategory.ELECTRONIC:
        imgUrl =
            '$imgDomain/staticQ/dianzi/$upperPlayId/$lang/game_${upperPlayId == 340 ? playName : playId}.png';
        break;
      case HomeGameCategory.CHESS:
        imgUrl = '$imgDomain/staticQ/qipai/$upperPlayId/$lang/game_$playId.png';
        break;
      case HomeGameCategory.FISHING:
        imgUrl = '$imgDomain/staticQ/buyu/$upperPlayId/$lang/game_$playId.png';
        break;
      case HomeGameCategory.BLOCK_THIRD:
        imgUrl =
            '$imgDomain/staticQ/qukuailian/$upperPlayId/$lang/game_$playId.png';
        break;
      default:
        break;
    }
    return imgUrl;
  }

  /// 捕鱼图片路径
  static String getFishImg({
    required num playId,
    required num upperPlayId,
  }) {
    String imgDomain = TenantManager.instance.appImgDomainPath.value;

    return '$imgDomain/staticQ/buyu/$upperPlayId/${AppConfigs.lang}/game_$playId.png';
  }

  /// 获得玩法信息
  static getPlayInfo(String playId) {
    /// 判断玩法ID规则
    if (double.tryParse(playId) == null) {
      return null;
    }

    final Map<String, dynamic>? currentPlayInfo = playInfo[int.parse(playId)];
    final Map<String, dynamic>? play =
        currentPlayInfo == null ? null : deepCopy(currentPlayInfo);

    /// 判断配置是否含有该玩法
    if (play == null) {
      // 动态生成玩法信息
      if (int.parse(playId) > 1000) {
        String mainPlayId = playId.substring(0, playId.length - 3);
        var mainPlay = playInfo[int.parse(mainPlayId)];
        var playBase = int.parse(mainPlayId) * 1000;

        // 捕鱼未用到此处逻辑, 彩票或许有此逻辑，先预留
        if (mainPlay != null && mainPlay['strategy'] != null) {
          Map<int, Map<String, dynamic>>? strategy =
              playsStrategy[mainPlay['strategy']];

          if (strategy != null) {
            strategy.forEach((key, val) {
              int subPlayId = playBase + key.toInt();
            });
          }
        }
      }
    } else {
      // 核对捕鱼原始逻辑，其余逻辑暂时不加
      if (play['default'] == null) {
        if (play['time'] == null) {
          play['default'] = playId;
        } else {
          play['default'] = '${playId}000';
        }
      }
    }

    return play;
  }

  /// 重组获取捕鱼的数据
  static List<GameBeanItem> getFishingData(List<GameFishingItem> fishing) {
    if (fishing.isEmpty) {
      return [];
    }

    Map<int, int> gameState = GameManager.instance.gameState;

    List<GameBeanItem> result = [];
    // 需要判断数据返回状态
    var statePlayId = <int>[13, 20, 21, 27, 28, 29, 31, 32, 33, 34];
    // 需要根据所有游戏销售状态， 判断状态
    var statePlayIdByData = <int>[27, 28, 29, 31, 32, 33, 34];

    for (int i = 0; i < fishing.length; i++) {
      GameFishingItem playItem = fishing[i];
      num key = playItem.play_id!;
      // 售卖状态
      int state = playItem.state ?? 0;
      var play = getPlayInfo(key.toString());

      if (play != null) {
        // 判断隐藏
        bool? hide = play['hide'];
        // 类型
        int type = play['type'] ?? 0;
        num? mainId = key;

        if (hide != true) {
          // 判断售卖状态
          bool isSale = statePlayId.contains(type.toInt()) ? state != 3 : false;

          // 所有游戏销售状态
          bool isSaleAsync = true;
          if (statePlayIdByData.contains(type.toInt())) {
            var asyncState = gameState[type];
            isSaleAsync = asyncState != 3;
            mainId = play['main_id'] ?? num.parse(play['default']);
            if (asyncState != null) {
              state = asyncState.toInt();
            }
          }
          //||playItem.play_id == 1388 不太了解之类逻辑，DB捕鱼被过滤掉了，现单独处理
          if (((isSale || playItem.play_id == 1388))) {
            var mainPlay = getPlayInfo(mainId.toString());
            final data = {
              "play_collection": playItem.play_collection,
              "play_cat": playItem.play_cat,
              "hot_val": playItem.hot_val,
              "is_top": playItem.is_top,
              "game_fever": playItem.game_fever, // 用不上的值
              "play_id": playItem.play_id,
              "big_type": playItem.big_type,
              "type": type,
              "state": state,
              "play_name": play['play_name'],
              "play_cname": play['play_cname'],
              "upper_play_cname": play['upper_play_cname'],
              "upper_play_id": mainId,
              "tid": TenantManager.instance.tenantBean!.tid, // 应该用不上
              "gameImgUrl": getFishImg(upperPlayId: mainId!, playId: key),
              "sub_play_id": null,
              "upper_id": null,
              "gtype": '',
            };
            result.add(GameBeanItem.fromJson(data));
          }
        }
      }
    }

    return result;
  }

  // 获取场馆图片
  static String getPlatformImgUrl({
    required num playId,
    required String gameType,
    String prefix = 'm',
  }) {
    return 'assets/theme1/images/game/$gameType/${prefix}_$playId.png';
  }

  // 获取场馆图片，fix 彩票的图片不在game文件夹下
  static String getLotteryImgUrl({
    required num playId,
    required String gameType,
    String prefix = 'm',
  }) {
    return 'assets/theme1/images/$gameType/${prefix}_$playId.png';
  }

  // 组装电子数据
  static List<GameBeanItem> dealDZList(
    List<GameChessAndElectronicItemBean> dzGameList,
  ) {
    List<GameBeanItem> resultDzGameList = [];

    for (int i = 0; i < dzGameList.length; i++) {
      var dzGameItem = dzGameList[i];

      if (dzGameItem.state != 3) {
        GameBeanItem currentData = GameBeanItem.fromJson({
          "play_name": dzGameItem.play_name,
          "play_cname": dzGameItem.play_cname,
          "gtype": dzGameItem.gtype,
          "play_collection": dzGameItem.play_collection,
          "play_cat": dzGameItem.play_cat,
          "hot_val": dzGameItem.hot_val,
          "game_fever": dzGameItem.game_fever,
          "play_id": dzGameItem.play_id,
          "state": dzGameItem.state,
          "upper_id": dzGameItem.upper_id,
          "upper_play_id": dzGameItem.upper_id,
          "play_sort": dzGameItem.play_sort,
          "play_is_hot": dzGameItem.play_is_hot,
          "hot_play_sort": dzGameItem.hot_play_sort,
          'big_type': dzGameItem.big_type,
          "type": dzGameItem.big_type, // 棋牌使用的值
          "sub_play_id": null, // 用不上
          "upper_play_cname": '', // 上级场馆名称
          "thumbnail_img_url": dzGameItem.thumbnail_img_url, // 上级场馆名称
          "gameImgUrl": getQPDZImg(
              playName: dzGameItem.play_name!,
              playId: dzGameItem.play_id!.toInt(),
              upperPlayId: dzGameItem.upper_id!,
              big_type: dzGameItem.big_type!,
              itemData: dzGameItem)
        });
        resultDzGameList.add(currentData);
      }
    }
    resultDzGameList.sort((a, b) => a.play_sort!.compareTo(b.play_sort!));
    return resultDzGameList;
  }

  /// 获取首页详情 棋牌/捕鱼/电子 相关tab场馆的icon
  static getHomeTabDefaultIcon({
    required String gameType,
    required num playId,
  }) {
    return 'assets/theme1/images/tab/$gameType/d_$playId.png';
  }

  /// 获取首页详情 棋牌/捕鱼/电子 相关tab场馆的带颜色的icon
  static getHomeTabDefaultColorIcon({
    required String gameType,
    required num playId,
  }) {
    return 'assets/theme1/images/tab/$gameType/color_$playId.png';
  }

  /// 彩票本地图片
  static getLotteryImg({
    required num playId,
  }) {
    return 'assets/theme1/images/lottery/g_$playId.png';
  }

  static getLotteryImg2({
    required num playId,
  }) {
    return 'assets/theme1/images/lottery/g2_$playId.png';
  }

  /// 获取首页详情 棋牌/捕鱼/电子 相关tab场馆的icon
  static getHomeTabActiveIcon({
    required String gameType,
    required num playId,
  }) {
    return 'assets/theme1/images/tab/$gameType/v_$playId.png';
  }

  //账户管理图标
  static getAccountManageIcon({
    required num id,
  }) {
    return 'assets/theme1/images/recharge/icons/recharge_$id.png';
  }

  //提现图标
  static getWithdrawIcon({
    required num id,
  }) {
    return 'assets/theme1/images/withdraw/icons/ico_cut_$id.png';
  }

  //  打卡真人游戏
  openLiveThirdPlatform() {}

  static String getTabEName(int id) {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    String iconPath = "";
    switch (id) {
      case 1:
        iconPath = "chess";
        break;
      case 2:
        iconPath = "lottery";
        break;
      case 3:
        iconPath = "electronic";
        break;
      case 4:
        iconPath = "fishing";
        break;
      case 5:
        iconPath = "live";
        break;
      case 6:
        iconPath = "sports";
        break;
    }
    return iconPath;
  }

  static String getTabEName2(int id) {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    String iconPath = "";
    switch (id) {
      case 1:
        iconPath = "chess";
        break;
      case 2:
        iconPath = "electronic";
        break;
      case 3:
        iconPath = "fishing";
        break;
      case 4:
        iconPath = "live";
        break;
      case 5:
        iconPath = "sports";
        break;
      case 7:
        iconPath = "lottery";
        break;
      case 10:
        iconPath = "blockChain";
        break;
    }
    return iconPath;
  }

  static String getTabIconPath(int id) {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    String iconPath = "";
    switch (id) {
      case 1:
        iconPath = Assets.theme1.images.home.iconGameChessAndCards;
        break;
      case 2:
        iconPath = Assets.theme1.images.home.iconCp;
        break;
      case 3:
        iconPath = Assets.theme1.images.home.iconGameElectronic;
        break;
      case 4:
        iconPath = Assets.theme1.images.home.iconGameFishing;
        break;
      case 5:
        iconPath = Assets.theme1.images.home.iconGameRealPerson;
        break;
      case 6:
        iconPath = Assets.theme1.images.home.iconGameSport;
        break;
      case 7:
      case 8:
      case 35:
      default:
        iconPath = Assets.theme1.images.home.iconGameChessAndCards;
        break;
    }
    return iconPath;
  }

  static String getTabIconPath2(int id) {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    String iconPath = "";
    switch (id) {
      case 1:
        iconPath = Assets.theme1.images.home.iconGameChessAndCards;
        break;
      case 2:
        iconPath = Assets.theme1.images.home.iconGameElectronic;
        break;
      case 3:
        iconPath = Assets.theme1.images.home.iconGameFishing;
        break;
      case 7:
        iconPath = Assets.theme1.images.home.iconCp;
        break;
      case 5:
        iconPath = Assets.theme1.images.home.iconGameSport;
        break;
      case 6:
        iconPath = Assets.theme1.images.home.iconGameRealPerson;
        break;
      case 10:
        iconPath = Assets.theme1.images.home.iconGameBlockchain;
        break;
      default:
        iconPath = Assets.theme1.images.home.iconGameChessAndCards;
        break;
    }
    return iconPath;
  }

  //游戏没加载到对应图片的默认图
  static String getGameDefaultIconPath(int id) {
    /// 1: 棋牌，2: 彩票， 3: 电子, 4: 捕鱼， 5: 真人， 6: 体育， 7: 红包 8: 原创 35： 经典游戏
    String iconPath = "";
    switch (id) {
      case 1:
        iconPath = Assets.theme1.images.tab.chess.color297.path;
        break;
      // case 2:
      //   iconPath = Assets.theme1.images.home.iconCp;
      //   break;
      case 3:
        iconPath = Assets.theme1.images.tab.electronic.color340.path;
        break;
      case 4:
        iconPath = Assets.theme1.images.tab.fishing.color381.path;
        break;
      case 5:
        iconPath = Assets.theme1.images.tab.live.color402.path;
        break;
      case 6:
        iconPath = Assets.theme1.images.tab.sports.color1031.path;
        break;
      default:
        iconPath = Assets.theme1.images.tab.chess.color297.path;
        break;
    }
    return iconPath;
  }
}
