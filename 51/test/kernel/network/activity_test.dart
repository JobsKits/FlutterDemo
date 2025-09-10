import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';

void main() {
  test('请求活动下Tab数据', () async {
    int cmdId = 723606;
    var data = {
      'tid': 3,
      'page_start': 1,
      'num_per_page': 50,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      if (res.data['data'] is List) {
        for (Map info in res.data['data']) {
          print(
              '${info['id']} - ${info['categoryName']} - ${info['categoryType']}');
        }
      }
    }
  });

  test('请求某个Tab下的活动列表', () async {
    int cmdId = 723601;
    var data = {
      'tid': 3,
      'page_start': 1,
      'num_per_page': 50,
      'activityCategory': 3, // Tab id
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      if (res.data['data'] is List) {
        for (Map info in res.data['data']) {
          print(
              '${info['id']} - ${info['activityName']} - ${info['activityType']}');
        }
      }
    }
  });

  test('新人彩金提交优惠码', () async {
    int cmdId = 621116;
    var data = {
      'tid': 3,
      'acctId': 423761,
      'account': '18800001000',
      'aid': 107,
      'promoCode': 'aaa888',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print(res.data['msg']);
      // print("data:${jsonEncode(res.data)}");
      // if (res.data['data'] is List) {
      //   for (Map info in res.data['data']) {
      //     print(
      //         '${info['id']} - ${info['activityName']} - ${info['activityType']}');
      //   }
      // }
    }
  });

  test('获取排行榜列表', () async {
    NetworkService ns = NetworkService();
    ns.setBaseURL('https://51zhh5.lg0808.com');

    int cmdId = 621113;
    var data = {
      'tid': 3,
      'acctId': 423761,
      'id': 0,
      'aid': 90,
      'page_start': 1,
      'num_per_page': 50,
    };
    final res = await ns.request(
      cmdId,
      data: data,
      paramType: 1,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print("data:${jsonEncode(res.data)}");
    }
  });

  test('获取领取记录', () async {
    NetworkService ns = NetworkService();
    ns.setBaseURL('https://51zhh5.lg0808.com');

    int cmdId = 724208;
    var data = {
      "tid": 3,
      'custId': 423960,
      'page_start': 1,
      'num_per_page': 50,
      'date': 1,
      'status': 1,
    };
    final res = await ns.request(
      cmdId,
      data: data,
      paramType: 1,
    );
    print('res data: ${res.type}');
    print('res data: ${res.data.toString()}');
    print('res data: ${res.toString()}');
    if (res.type == NetworkService.networkTypeSuccess) {
      print("data:${jsonEncode(res.data)}");
    }
  });
}
