import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/data/leg_lottery_data.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';

void main() {
  // test('购彩大厅数据请求', () async {
  //   int cmdId = 320542;
  //   const data = {
  //     'tid': 3,
  //     'cust_id': 424182,
  //     'play_cat': 1,
  //     'type': 0,
  //     'size': 3,
  //   };
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //   );
  // print('res data: ${res.data}');
  // if (res.type == NetworkService.networkTypeSuccess) {
  //   print("data长度:${res.data.length}");
  //   if (res.data is List) {
  //     for (var info in res.data) {
  //       // 分分快三
  //       if (info['play_id'] == 237) {
  //         print('play_id: ${info['play_id']}');
  //         print('sub_play_id: ${info['sub_play_id']}');
  //         print('play_cname: ${info['play_cname']}');
  //         print('play_name: ${info['play_name']}');
  //         // type = 7 进入k3界面
  //         print('type: ${info['type']}');
  //         print('base: ${info['base']}');
  //         // 根据base和本地配置信息完善 playInfo
  //         String base = info['base'];
  //         if (playInfoCommon[base] != null) {
  //           Map<String, dynamic> commonInfo = playInfoCommon[base]!;
  //           print('cat: ${commonInfo['cat']}');
  //           print('pan: ${commonInfo['pan']}');
  //           print('strategy: ${commonInfo['strategy']}');
  //         }
  //       }
  //     }
  //   }
  // }
  // });
  test('天成彩票', () async {
    int cmdId = 317104;
    const data = {
      'tid': 3,
      'cust_id': 424182,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    List<LotteryGames> tempList = [];
    if (res.data is List) {
      for (var item in res.data) {
        if (item["games"] != null && item["games"] is List) {
          for (var secondItem in item["games"]) {
            tempList.add(LotteryGames.fromJson(secondItem));
          }
        }
      }
      for (var item in tempList) {
        print("输出一下整理后的集合${item.remark}");
      }
    }
  });
  // var playInfo = {
  //   'play_id': 237,
  //   'sub_play_id': 237000,
  //   'play_cname': '分分快三',
  //   'play_name': 'K31FCT3',
  //   'type': 7, // url => k3?playid=237&goback=0&subplayid=237000
  //   'base': 'A_K31F',
  //   'cat': 'K3',
  //   'pan': 'A',
  //   'strategy': 'K3',
  // };
  //
  // test('租户的彩种配置', () async {
  //   // 获取彩票销售时间
  //   int cmdId = 320151;
  //   var data = {
  //     'tid': 3,
  //   };
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int playId = 237;
  //     Map config = res.data[playId.toString()];
  //     print('play_id: ${playId}');
  //     print('play_cname: ${config['play_cname']}');
  //     print('销售时间: ${config['sell_start_time']}-${config['sell_end_time']}');
  //   }
  // });
  //
  // test('检测3方平台', () async {
  //   int cmdId = 321543;
  //   var data = {
  //     'tid': 3,
  //     'play_id': 237,
  //   };
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('可以进入游戏');
  //     }
  //   }
  // });
  //
  // test('request 321535', () async {
  //   // 获取指定彩种的所有玩法状态
  //   // 分分快三:和值 分分快三:二同号单选
  //   // 分分快三是主玩法 main_play_id，和值/二同号单选...这些是子玩法 subplayid
  //   int cmdId = 321535;
  //   int tid = 3;
  //   int mainPlayId = 237; // 分分快三
  //   var data = [tid, mainPlayId];
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print("data:${jsonEncode(res.data)}");
  //     String stateKey = '${mainPlayId}';
  //     print('主玩法 $stateKey 状态：');
  //     int state = res.data[stateKey];
  //     if (state == 1) {
  //       print('可以进入');
  //     } else if (state == 2) {
  //       print('暂停销售');
  //     } else if (state == 3) {
  //       print('停止销售');
  //     } else if (state == 4) {
  //       print('内部测试');
  //     }
  //
  //     String pricingstrategysKey = '${mainPlayId}-pricingstrategys';
  //     if (res.data[pricingstrategysKey] is List) {
  //       print('子玩法：');
  //       for (var strategyInfo in res.data[pricingstrategysKey]) {
  //         String subStateKey = '${strategyInfo['billing_object_id']}';
  //         print('\t玩法: ${strategyInfo['description']}, $subStateKey');
  //         int subState = res.data[subStateKey];
  //         if (subState == 1) {
  //           print('\t可以进入');
  //         } else if (subState == 2) {
  //           print('\t暂停销售');
  //         } else if (subState == 3) {
  //           print('\t停止销售');
  //         } else if (subState == 4) {
  //           print('\t内部测试');
  //         }
  //         print('\t-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('获取子玩法', () async {
  //   int playId = 237;
  //   String playCat = 'K3';
  //   String strategy = 'K3';
  //   bool isXY = playIsXY(playCat, playId);
  //   if (isXY) {
  //     print('信用玩法');
  //   } else {
  //     print('非信用玩法');
  //   }
  //   Map subInfo = AppConfigs.getSubPlayInfo(strategy, isXY);
  //   // {subs: [{groupName: default, playids: [0, 100, 200, 300, 400, 500, 600, 700]}]}
  //   print('subInfo: $subInfo');
  // });
  //
  // test('子玩法信息', () async {
  //   String strategy = 'K3';
  //   int subPlayId = 0;
  //   if (playsStrategy[strategy]?[subPlayId] != null) {
  //     Map<String, dynamic> info = playsStrategy[strategy]![subPlayId]!;
  //     int ruleId = info['rule_id'];
  //     Map ruleInfo = playRuleInfo[ruleId];
  //     print('subPlayId: $subPlayId');
  //     print('play_cname: ${info['play_cname']}');
  //     print('area_id: ${info['area_id']}');
  //     print('dices: ${info['dices']}');
  //     print('Method: ${info['Method']}');
  //     print('tip: ${ruleInfo['tip']}');
  //   }
  // });
  //
  // test('getBallInfo', () async {
  //   // 获得玩法的选号球信息
  //   int areaId = 37000;
  //   Map ballArea = ballAreaAll[areaId];
  //   if (ballArea['areas'] is List) {
  //     for (var area in ballArea['areas']) {
  //       int ballpanid = area['ballpanid'];
  //       Map ballPlan = ballPanAll[ballpanid];
  //       if (ballPlan['balls'] is List) {
  //         for (var ball in ballPlan['balls']) {
  //           int id = area['baseballid'] + ball['id'];
  //           // 过滤和值中3和18
  //           if (areaId == 37000 && (id == 104 || id == 119)) {
  //             continue;
  //           }
  //           print('${id}-${ball['name']}-${ball['cmd']}');
  //         }
  //       }
  //     }
  //   }
  // });
  //
  // test('request 320142', () async {
  //   // 请求所有子玩法信息详情 playDetails
  //   Map playDetails = {};
  //   int cmdId = 320142;
  //   int tid = 3;
  //   int playId = 237; // 分分快三
  //   var data = [tid, playId];
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       for (var info in res.data) {
  //         playDetails[info['play_id']] = info;
  //       }
  //     }
  //
  //     int subPlayId = 237000; // 和值
  //     Map playDetail = playDetails[subPlayId];
  //     print('玩法:${playDetail['play_cname']}');
  //     print('sub_play_plan_num:${playDetail['sub_play_plan_num']}');
  //     print('sub_play_plan_num_win:${playDetail['sub_play_plan_num_win']}');
  //     print('base_note_num:${playDetail['base_note_num']}');
  //     if (playDetail['subPlay'] is List) {
  //       for (var subInfo in playDetail['subPlay']) {
  //         print('\t玩法:${subInfo['play_cname']}, ${subInfo['play_id']}');
  //         print('\tsub_play_plan_num:${subInfo['sub_play_plan_num']}');
  //         print('\tsub_play_plan_num_win:${subInfo['sub_play_plan_num_win']}');
  //         print('\tbase_note_num:${subInfo['base_note_num']}');
  //         print('\t-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 330951', () async {
  //   // 请求玩法定价方案(赔率) playPricingPlan
  //   Map playPricingPlan = {};
  //   int cmdId = 330951;
  //   int playId = 237; // 分分快三
  //   int roomLevel = 0;
  //   int tid = 3;
  //   var data = [playId, roomLevel, tid];
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     String key = '${playId}-${roomLevel}';
  //     playPricingPlan[key] = res.data;
  //
  //     int subPlayId = 237000;
  //     String ballCmd = '18';
  //     String priceKey = '${subPlayId}${ballCmd}';
  //     Map priceMap = playPricingPlan[key][priceKey];
  //     print('price: ${priceMap['0']}');
  //   }
  // });
  //
  // test('计算和值赔率', () async {
  //   // getPlayK3HeZhiBallOdds
  //   int planNum = 2;
  //   int planNumWin = 1;
  //   int price = 900; // ballCmd = '19'
  //   int rebate = 1000; // getBaseRebate
  //   int slider = 1000; // // 选号界面滑块
  //   int value = rebate - slider;
  //   int baseNoteNum = 1;
  //   double min = getPlayK3HeZhiBallOdds(
  //       planNum, planNumWin, price, rebate, value, baseNoteNum);
  //
  //   planNum = 216;
  //   planNumWin = 1;
  //   price = 880; // ballCmd = '18'
  //   baseNoteNum = 1;
  //   double max = getPlayK3HeZhiBallOdds(
  //       planNum, planNumWin, price, rebate, value, baseNoteNum);
  //   print('$min-$max');
  // });
  //
  // test('计算和值以外赔率', () async {
  //   // Method > 0
  //   // 数字彩res_id和ballId为0 getPlayK3SubplayOdds
  //   // Map playDetail = {
  //   //   'play_id': 237100,
  //   //   'play_cname': '二同号单选',
  //   //   'base_note_num': 1,
  //   //   'sub_play_plan_num': 216,
  //   //   'sub_play_plan_num_win': 3,
  //   // };
  //   Map playDetail = {
  //     'play_id': 237200,
  //     'play_cname': '二同号复选',
  //     'base_note_num': 1,
  //     'sub_play_plan_num': 216,
  //     'sub_play_plan_num_win': 15,
  //   };
  //   int price = 900;
  //   int rebate = 1000;
  //   int rebateValue = 0;
  //   // computeOdds('A', )
  //   double ret = computeOddsA(
  //       price,
  //       rebate,
  //       rebateValue,
  //       playDetail['base_note_num'],
  //       playDetail['sub_play_plan_num'],
  //       playDetail['sub_play_plan_num_win']);
  //   print('ret = $ret');
  //   //double odd = 72;
  // });
  //
  // test('request 320539', () async {
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   // 请求指定彩种的开奖公告
  //   int cmdId = 320539;
  //   var data = {
  //     'tid': 3,
  //     'play_name': 'K31FCT3',
  //     'count': 30,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       for (var termInfo in res.data) {
  //         int termCode = termInfo['term_code'];
  //         String termStr = termCode.toString();
  //         if (termStr.length >= 10) {
  //           termStr = termStr.substring(4);
  //         }
  //         print('第$termStr期');
  //         print('开奖号码: ${termInfo['win_code']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 320334', () async {
  //   // 请求彩种当前期信息
  //   int cmdId = 320334;
  //   int playId = 237;
  //   int tid = 3;
  //   String playName = 'K31FCT3';
  //   var data = [tid.toString(), playName];
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //     Map newTerm = res.data;
  //     print('第${newTerm['term_code']}期');
  //     print('part_mon: ${newTerm['part_mon']}');
  //     newTerm['startTime'] = startTime(newTerm['begin_time'],
  //         newTerm['start_sale_offset'], newTerm['db_sys_date']);
  //     newTerm['stopTime'] = stopTime(newTerm['end_time'],
  //         newTerm['stop_sale_offset'], newTerm['db_sys_date']);
  //     if (isFrost(newTerm['startTime'], newTerm['stopTime'])) {
  //       print('已封期');
  //     } else {
  //       int stopTime = newTerm['stopTime'];
  //       int currentTime = DateTime.now().millisecondsSinceEpoch;
  //       int duraction = stopTime - currentTime;
  //       print('倒计时: ${duraction / 1000}秒');
  //     }
  //   }
  // });
  //
  // test('获取平台', () async {
  //   String plat = getBetPlatform();
  //   print('plat:${plat}');
  // });
  //
  // test('获得指定号码列表的指令', () async {
  //   // getSelectedIdsCMD
  //   // 237000#19*1*1#B1
  //   int subPlayId = 237000;
  //   String ballCmd = '19';
  //   int note = 1;
  //   int multx = 1; // 倍数
  //   int basketMultx = 1;
  //   String play_cmd =
  //       '${subPlayId}#${ballCmd}*${note}*${multx}#B${basketMultx}';
  //   print('play_cmd:${play_cmd}');
  // });
  //
  // test('投注', () async {
  //   int cmdId = 320604;
  //   var data = [
  //     {
  //       'acct_id': 589612,
  //       'amount': 1000, // 总金币
  //       'base_num': 0,
  //       'chan_code': 'MWEB',
  //       'com_amount': 0,
  //       'comsi_pct': 0,
  //       'cust_code': '3_c_18800001000',
  //       'cust_id': 423761,
  //       'cust_nickname': '123',
  //       'disp_flag': 1,
  //       'div_num': 0,
  //       'finish_num': 0,
  //       'founder_code': '3_c_18800001000',
  //       'founder_id': 423761,
  //       'is_com': 0,
  //       'multix': 1,
  //       'note_num': 1,
  //       'per_amount': 1000,
  //       'plan_type': 1,
  //       'platform': 'H5_IOS',
  //       'playPlanTickets': [
  //         {
  //           'multx': 1, // 倍数
  //           'note_num': 1,
  //           'note_price': 1000, // 单注金币 n x 1000
  //           'num': '[[100]]',
  //           'play_cmd': '237000#19*1*1#B1', // "237000#19*1*1#B1"
  //           'play_cname': '和值',
  //           'play_id': 237000,
  //           'play_name': 'HZ',
  //           'rebate': 0,
  //           'ticket_code': 0,
  //           'ticket_id': 0,
  //           'tid': 3,
  //         },
  //       ],
  //       'play_cname': '分分快三',
  //       'play_id': 237,
  //       'play_name': 'K31FCT3',
  //       'play_room_id': 0, // 固定的
  //       'profitor_acct_id': 589612,
  //       'profitor_code': '3_c_18800001000',
  //       'profitor_id': 423761,
  //       'profitor_nickname': '123',
  //       'pub_type': 2,
  //       'room_level': 0, // 固定的
  //       'splay_cname': '和值',
  //       'splay_id': 237000,
  //       'splay_name': 'HZ',
  //       'term_cnt': 1,
  //       'term_code': 202410041401,
  //       'term_part': 278,
  //       'tid': 3,
  //     }
  //   ];
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('投注成功, 祝您中奖');
  //     }
  //   } else {
  //     print('${res.data}');
  //   }
  // });
  //
  // test('request 320631', () async {
  //   // 我的投注
  //   int cmdId = 320631;
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'play_id': 237,
  //     'play_name': '',
  //     'plan_type': 1,
  //     'platform_order_id': '',
  //     'start_time': timestamp - 1000 * 3600 * 24 * 7,
  //     'end_time': timestamp,
  //     'page_start': 1,
  //     'num_per_page': 10,
  //   };
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['data'] is List) {
  //       for (var record in res.data['data']) {
  //         print('期号: ${record['term_code']}');
  //         print('投注金币: ${record['amount'] / 1000}');
  //         print('中奖金币: ${record['reward_pretax'] / 1000}');
  //         int winFlag = record['win_flag'];
  //         if (winFlag == 2) {
  //           print('未中奖');
  //         } else if (winFlag == 3) {
  //           print('已中奖');
  //         } else if (winFlag == 4) {
  //           print('和局');
  //         }
  //         print('-----');
  //       }
  //     }
  //     // if (res.data is List) {
  //     //   for (var termInfo in res.data) {
  //     //     int termCode = termInfo['term_code'];
  //     //     String termStr = termCode.toString();
  //     //     if (termStr.length >= 10) {
  //     //       termStr = termStr.substring(4);
  //     //     }
  //     //     print('第$termStr期');
  //     //     print('开奖号码: ${termInfo['win_code']}');
  //     //     print('-----');
  //     //   }
  //     // }
  //   }
  // });
}
