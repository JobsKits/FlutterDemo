import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/constants/withdraw_constants.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';

void main() {
  test('request 3119353', () async {
    // 代理 手动领取佣金数量 领取
    int cmdId = 3119353;
    var data = {
      'tid': 3,
      'cust_id': 423761,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        print('操作成功');
      }
    }
  });

  test('request 420029', () async {
    // 代理 手动领取佣金数量 查询
    int cmdId = 420029;
    var data = {
      'tid': 3,
      'cust_id': 423761,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      int code = ensureInt(res.data['code']);
      if (code == 1) {
        print('自动领取');
      } else if (code == 2) {
        print('已领取');
      } else if (code == 9999) {
        int rebate = res.data['rebate'];
        if (rebate > 0) {
          print('可领取 ${rebate / 1000}');
        } else {
          print('暂不可领取');
        }
      }
    }
  });

  test('request 370734', () async {
    // 代理教程
    int cmdId = 370734;
    var data = {
      'tid': 3,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print('mode: ${res.data['mode']}'); // tutorialType 控制展示内容
      print('is_three: ${res.data['is_three']}'); // 控制展示内容
      print('is_show: ${res.data['is_show']}'); // isshowFl 是否展示更多福利？
    }
  });

  test('request 311935', () async {
    // 我的分享 - 邀请好友页面
    int cmdId = 311935;
    var data = {
      'tid': 3,
      'cust_id': 248313,
      'is_clear': 'true',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print('推广链接: ${res.data['link_addr']}');
      print('上级账号: ${res.data['partnerName']}');
      print('直属成员人数: ${res.data['direc']}');
      print('团队成员人数: ${res.data['count']}');
      print('今日新增人数: ${res.data['cust_count']['cust_count']}');
      print(
          '团队新增充值人数: ${res.data['new_charge_cust_count']['new_charge_cust_count']}');
    }
  });

  test('request 324459', () async {
    // 获取我的分享 - 佣金
    int cmdId = 324459;
    var data = {
      'tid': 3,
      'cust_id': 248313,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print('历史总佣金: ${res.data['rebate_sum'] / 1000}');
      print('昨日佣金: ${res.data['rebate'] / 1000}');
      print('可领取佣金: ${res.data['receive_rebate'] / 1000}');
      if (res.data['code'] != 1) {
        print('展示立即领取按钮');
      }
    }
  });

  test('request 390205', () async {
    // 代理教程返点
    int cmdId = 390205;
    var data = {
      'tid': 3,
      'mode': 5, // 固定的
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        List rebateList = res.data;
        Map levelInfo = {
          1: '一级',
          2: '二级',
          3: '三级',
        };
        Map gameInfo = {
          'DZ': '电子',
          'QP': '棋牌',
          'CP': '彩票',
          'ZR': '真人',
          'TY': '体育',
          'BY': '捕鱼',
          'HS': '哈希',
        };
        for (Map item in rebateList) {
          int level = item['agent_level'];
          print('代理层级: ${levelInfo[level]}');
          String rebate = item['game_rebate'];
          Map<String, String> rebateMap =
              Map<String, String>.from(jsonDecode(rebate));
          List keys = rebateMap.keys.toList();
          print('返佣百分比:');
          for (String key in keys) {
            print('\t${gameInfo[key]}:${rebateMap[key]}%');
          }
          print('-----');
        }
      }
    }
  });

  test('request 380948', () async {
    // 获取前3种模式佣金列表数据，tutorialType = 1, 2, 3时调用此接口
    // 未使用
    int cmdId = 380948;
    var data = [3];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
    );
    // print('res data: ${res.data}');
  });

  test('request 3119451', () async {
    // 获取代理商列表
    int cmdId = 3119451;
    //默认传入当前用户的cust_id，传入返回数据的partner_id可以查对应的子级列表
    int upperId = 248313;
    var data = {
      'tid': 3,
      'depth': 1,
      'level': 1,
      'upper_id': upperId,
      'start_time': 1719331200000, // 2024-06-26
      'end_time': 1727366399999, // 2024-09-26
      'page_start': 1,
      'num_per_page': 10,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      int count = res.data['count'];
      print('返回${count}条数据');
      if (count > 0) {
        List agentList = res.data['data'];
        for (Map item in agentList) {
          print('编号: ${item['partner_id']}');
          print('会员账号: ${item['partner_name']}'); // 脱敏，显示为18*****16
          print('有效投注: ${item['total_valid_bet'] / 1000}');
          print('总充值: ${item['total_charge_amount'] / 1000}');
          int state = item['state'];
          String stateStr = '默认';
          switch (state) {
            case 0:
              stateStr = '默认';
              break;
            case 1:
              stateStr = '在用';
              break;
            case 2:
              stateStr = '已注销';
              break;
            case 3:
              stateStr = '锁定';
              break;
            case 9:
              stateStr = '预注册';
              break;
            default:
          }
          print('状态: $stateStr');
          print('-----\n');
        }
      }
    }
  });

  test('request 311936', () async {
    // 返回最近7天的流水信息
    int cmdId = 311936;
    var data = {
      'tid': 3,
      'cust_id': 248313,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print('累计直属总流水: ${ensureInt(res.data['play_amount_sum']) / 1000}');
      if (res.data['date'] is List) {
        List commissionlist = res.data['date'];
        Map yesterdayItem = commissionlist[0];
        print('昨日直属总流水: ${ensureInt(yesterdayItem['play_amount']) / 1000}');
        print('佣金明细:');
        for (Map item in commissionlist) {
          print('\t${item['part_day']}');
          print('\t总佣金${ensureInt(item['rebate_amount']) / 1000}');
          print('\t直属总流水${ensureInt(item['play_amount']) / 1000}');
          print('\t团队总流水${ensureInt(item['team_amount_sum']) / 1000}');
          print('-----');
        }
      }
    }
  });
}
