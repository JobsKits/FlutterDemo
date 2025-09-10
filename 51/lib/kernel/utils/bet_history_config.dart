import '../helpers/helperOthersGame.dart';

class BetHistoryConfig {
  static const Map<int, String> betHistory = {
    60: 'AGSXGames',
    297: 'KYQiPaiGames',
    299: 'LYQiPaiGames',
    339: 'LMGGameNames',
    340: 'JDBDianZiGameNames',
    342: 'SBTGameNames',
    343: 'MGGames',
    344: 'IgGameNames',
    345: 'BBINShiXunGames',
    380: 'DFWQiPaiGames',
    382: 'CSQiPaiGames',
    383: '',
    390: '',
    391: 'TMQiPaiGames',
    393: 'THQiPaiGames',
    394: 'BLQiPaiGames',
    396: 'MGGames',
    397: 'JDBDianZiGameNames',
    398: 'TJQiPaiGames',
    399: 'THBYGameNames',
    400: 'DGShiXunGames',
    402: 'BGShiXunGames',
    403: 'CQ9DianZiGames',
    404: 'BSQiPaiGames',
    405: 'DTDianZiGames',
    407: 'BSBYGameNames',
    408: 'CQ9BYGameNames',
    401: 'XSJQiPaiGames',
    412: 'MGGames',
    409: 'HGTiYuGames',
    414: 'PTDianZiGames',
    413: 'BBINDZGames',
    418: 'MBTiYuGames',
    415: 'AGDZGames',
    416: 'AGPYDZGames',
    417: 'MBQPGames',
    419: 'QGHBGames',
    420: 'IGSXGames',
    421: 'OBSXGames',
    422: 'LHDJGames',
    423: 'IBOSXGames',
    468: 'TCCPGames',
    490: '',
    504: 'GPIcaipiao',
    506: 'KingmakerGame',
    507: 'EVOPlayGame',
    508: 'PPPlayGame',
    509: 'KPPlayGames',
    593: 'UPGGameCode',
    570: 'getSBOTYName',
    571: 'PGGames',
    572: 'EBETSXGames',
    706: 'sv388',
    388: 'HLQiPaiGames',
    707: 'FGGameCode',
    708: 'FGBYGameNames',
    709: 'FGPlayGames',
    710: 'TGSXGames',
    711: 'HCGameCode',
    745: 'KGPlayGames',
    1380: 'PGSlotNew',
    1382: 'PGSlotNew2',
    750: 'SEXYSportsNames',
    924: 'XGSXGames',
    925: 'TRCBetTypes',
    926: 'SimplePlayGameCode',
    927: 'QiPai365Games',
    938: 'AMEBAGameCode',
    939: 'PSDZGameCode',
    928: 'JILIQPGameCode',
    929: 'JILIDZGameCode',
    930: 'EABQGameCode', // EA板球
    746: 'DTQPGameCode', // 大唐棋牌
    747: 'DTBYGameCode', // 大唐捕鱼
    931: 'IMTYGameCode', // IM体育
    980: 'EVOSXGames', // evo真人
    960: 'RTDZGameCode', // RT电子
    961: 'VTDZGameCode', // VT电子
    981: 'IMDJGameCode', // IM电竞
    1031: 'KYTYGameCode', // 开元体育
    1308: 'FBTYGameCode', // FB体育
    1305: 'JOKERGameCode', // JOKER电子
    1306: 'RSGDZGameCode', // RGS电子
    1309: 'WMZRGameCode', // 完美真人
    983: 'MTDZGameCode', // MT电子
    1311: 'NEXTSPINGameCode', // NEXTSPIN电子
    1312: 'AESEXYGameCode', // AESEXY真人
    1313: 'PRETTYGameCode', // PRETTY真人
    1314: 'AFBSXGameCode', // AFB真人
    1315: 'AFBDZGameCode', // AFB电子
    1316: 'AFBTYGameCode', // AFB体育
    1317: 'SAGSXGameCode', // SAGaming视讯
    1318: 'PGSOFTDZGameCode', // PGSOFT电子
    1319: 'EVOPLAYDZGameCode', // EVOPLAY电子
    1320: 'TPDZGameCode', // TP电子
    1321: 'KADZGameCode', // KA电子
    1322: 'PPSXGameCode', // PP真人
    1323: 'NEDZGameCode', // NETENT电子
    1324: 'FCDZGameCode', // FC电子
    1325: 'SGDZGameCode', // SG电子
    1387: 'DBDJGameCode', // DB电竞
    1383: 'DBQiPaiGames', // DB棋牌
    1386: 'DBDZGames', // DB电子
  };

  static formatValue({
    required String playTypeId,
    required Map<String, dynamic> item,
  }) {
    String itemPlayTypeId = '${item['play_type_id']}';

    String gameTypeId = '';
    String platformOrderId = '';

    // 单独文件设置的第三方
    String? games = BetHistoryConfig.betHistory[int.parse(itemPlayTypeId)];
    String id = '${item['game_type_id']}';

    // 部分游戏特殊处理
    if ([931, 981, 1308].contains(int.parse(itemPlayTypeId))) {
      //IM电竞
      platformOrderId = '${item['order_id']}';
    }

    if (int.parse(itemPlayTypeId) == 383) {
      // BG捕鱼大师
      gameTypeId = playTypeId;
    }
    if (int.parse(itemPlayTypeId) == 390) {
      // BG西游捕鱼
      gameTypeId = playTypeId;
    }
    if (int.parse(itemPlayTypeId) == 490) {
      // s128斗鸡
      gameTypeId = 's128斗鸡';
    }

    if (int.parse(itemPlayTypeId) == 938) {
      // Ameba电子
      id = '${item['game_id']}';
    } else if (int.parse(itemPlayTypeId) == 925) {
      // TRC赛马
      id = '${item['betType']}';
    } else if (int.parse(itemPlayTypeId) == 1326) {
      // 沙巴彩票
      gameTypeId = '-';
    } else if (int.parse(itemPlayTypeId) == 1385) {
      // DB彩票
      gameTypeId = '-';
    }

    if ((games ?? '').isNotEmpty) {
      gameTypeId = getOtherGameName(games!, id);
    }

    return {'gameTypeId': gameTypeId, 'platformOrderId': platformOrderId};
  }
}
