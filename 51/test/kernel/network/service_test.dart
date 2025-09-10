import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';

void main() {
  // test('极光接口', () async {
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 380501;
  //   final deviceId = 'test123';
  //   //await getDeviceId();
  //   const deviceType = '1'; // 1: 安卓，2: iOS
  //   const registrationId = '13065ffa4e1b76e6639';
  //   var data = {
  //     'tid': 3,
  //     'device_id': deviceId,
  //     'device_type': deviceType,
  //     'registration_id': registrationId,
  //     'user_id': 121,
  //     'alias_id': 121,
  //     'alias_name': 'scott123'
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //     // headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print("data:${jsonEncode(res.data)}");
  //   }
  // });
  // test('381119', () async {
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('http://51zhh5.wc9003.com');
  //
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: 1,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   // if (res.type == NetworkService.networkTypeSuccess) {
  //   //   // print("data:${jsonEncode(res.data)}");
  //   //   if (res.data['gameState'] is Map) {
  //   //     Map gameState = res.data['gameState'];
  //   //     print('DB彩票 销售状态 ${gameState['1385']}');
  //   //     print('双赢彩票 销售状态 ${gameState['1410']}');
  //   //     print('天成彩票 销售状态 ${gameState['468']}');
  //   //     print('沙巴彩票 销售状态 ${gameState['1326']}');
  //   //   }
  //   // }
  // });
  //
  // test('彩票的数据列表', () async {
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 320542;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //     'cust_id': '',
  //     'play_cat': 1,
  //     'type': 0,
  //     'size': 10,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //     if (res.data is List) {
  //       for (Map info in res.data) {
  //         // 是否有db彩票
  //         if (info['type'] == 31) {
  //           print('${info['play_cname']} play_state:${info['play_state']}');
  //         }
  //       }
  //     }
  //   }
  // });
  // //
  test('371130', () async {
    NetworkService ns = NetworkService();
    ns.setBaseURL('https://test456.oossc360.icu');
    // 通过域名地址获取租户信息
    int cmdId = 371130;
    var data = {
      'domain_addr': ns.baseURL,
      'language': '0',
    };
    int paramType = 0;
    final res = await ns.request(
      cmdId,
      data: data,
      paramType: paramType,
      headerType: 1,
    );
    // print('res data: ${res.data}');
    // if (res.type == NetworkService.networkTypeSuccess) {
    //   print("data:${jsonEncode(res.data)}");
    // }
  });
  //
  // test('request vue.min.js', () async {
  //   const jsLog = 'https://gitee.com/shilin001/vue/raw/master/1/vue.min.js';
  //
  //   final dio = Dio(
  //     BaseOptions(
  //       connectTimeout: const Duration(seconds: 10),
  //       receiveTimeout: const Duration(seconds: 10),
  //     ),
  //   );
  //
  //   try {
  //     final response = await dio.get(jsLog);
  //     String content = response.data;
  //     var regex = RegExp(r'(?<=return(\s*)\[)(.*?)(?=\])');
  //     final match = regex.firstMatch(content);
  //     if (match == null) {
  //       throw Exception('文件解析异常');
  //     }
  //     content = match[0] as String;
  //     // print('matched is $content');
  //     regex = RegExp(r"(?<=')([A-Za-z0-9+/=]*?)(?=')");
  //     final matches = regex.allMatches(content);
  //     if (matches.isEmpty) {
  //       throw Exception('域名解析异常');
  //     }
  //     List<String> urlList = [];
  //     for (var match in matches) {
  //       final cryptedStr = match[0] as String;
  //       String url = decryptDomain(cryptedStr);
  //       if (url.isEmpty) {
  //         print('$cryptedStr 解密失败');
  //       } else {
  //         urlList.add(url);
  //       }
  //     }
  //
  //     print('urlList is $urlList');
  //   } catch (e) {
  //     print('文件获取失败 $jsLog $e');
  //   }
  // });
  //
  // test('request 371138', () async {
  //   // 维护界面数据
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 371138;
  //   var data = {
  //     'domain_addr': ns.baseURL,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     String startDate = res.data['update_start'];
  //     String endDate = res.data['update_end'];
  //     print('系统将于${startDate}至${endDate}进行系统维护');
  //   }
  // });
  //
  // test('头像列表', () async {
  //   // maxHeadNum: i18n.lang === 'cn' ? 60 : 109
  //   int maxHeadNum = 60;
  //   String imgDomain = 'https://image2.typay2.com/';
  //   for (int i = 1; i <= maxHeadNum; i++) {
  //     String urlStr = '${imgDomain}static/heads/cn/head_${i}.png';
  //     print(urlStr);
  //   }
  // });
  //
  // test('request 310114', () async {
  //   // 修改头像
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 310114;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //     'cust_id': 423761,
  //     'head': 'static/heads/cn/head_1.png',
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 10', () async {
  //   // 发送绑定手机号的验证码
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 10;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //     'client_id': 'react_client',
  //     'grant_type': 'password',
  //     'scope': 'read write',
  //     'type': 5,
  //     // 目前设置的 +86
  //     'country': "China",
  //     'verifycode': "",
  //     'receive_mobile': '18800001000',
  //   };
  //   final res = await NetworkService().request(
  //     cmdId,
  //     data: data,
  //     headerType: 1,
  //   );
  //   print('res data: ${res.data}');
  //   // beb2cbde47fc172d52a0bdc071b998e4
  //   // beb2cbde47fc172d52a0bdc071b998e4
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //   }
  //   // print("发送验证码：${res.data}");
  //   // if (res.type == NetworkService.networkTypeSuccess) {
  //   //   if (res.data['response_code'] == '9999') {}
  //   // }
  // });
  //
  // test('request 16', () async {
  //   // 绑定手机号
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 16;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //     'cust_id': 423761,
  //     'phone_num': '18800001000',
  //     'smsCode': '111111',
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //   }
  // });
  //
  // test('request 371143', () async {
  //   // 请求租户注册联系人配置
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 371143;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print("data:${jsonEncode(res.data)}");
  //   }
  // });
  //
  // test('request 325308', () async {
  //   // 查询用户信息认证状态
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 325308;
  //   var data = {
  //     'tid': AppConfigs.tid,
  //     'cust_id': 423761,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //     String withdrawSmsVerify = res.data['withdraw_sms_verify'];
  //     if (withdrawSmsVerify == '1') {
  //       print('提现时 需要 绑定手机号');
  //       String phoneSmsVerify = res.data['phone_sms_verify'];
  //       if (phoneSmsVerify == '1') {
  //         print('绑定手机号 需要 短信验证');
  //       } else {
  //         print('绑定手机号 不需要 短信验证');
  //       }
  //     } else {
  //       print('提现时 不需要 绑定手机号');
  //     }
  //   }
  // });
  //
  // test('request 3711361', () async {
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   // app域名智能线路获取
  //   int cmdId = 3711361;
  //   var data = {
  //     'aseq_id': '120', // 对应版本号的，是否更新APP使用的
  //     'tid': '3',
  //     'chan_code': 'zhcaipiaoh5', // 综合彩票h5，体育h5
  //     'clusters_id': 997,
  //     'proxy': 0,
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print("data:${jsonEncode(res.data)}");
  //     if (res.data['list'] is List) {
  //       List addrList = res.data['list'];
  //       for (Map info in addrList) {
  //         String addr = decrypt3DES(info['domain_addr']);
  //         print('addr: ${addr}, weight: ${info['weight']}');
  //       }
  //     }
  //   }
  // });
  //
  // test('获取所有三方余额', () async {
  //   int cmdId = 391137;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 424182,
  //     'data_type': 1,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // 一分钟只能刷新一次
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // print("data:${jsonEncode(res.data)}");
  //     if (res.data is List) {
  //       for (var info in res.data) {
  //         int playId = info['play_id']; // 通过 play_id 对应首页数据
  //         String? name = info['play_name'];
  //         int total = info['total']; // 第三方总余额  -- 平台
  //         int lower = info['lower']; // 第三方科下分余额  -- 平台
  //         int isKickout = info['is_kickout'];
  //         print('$playId, $name, $total, $lower, $isKickout');
  //       }
  //     }
  //   }
  // });

  // test('requst 375011', () async {
  //   // 设置收件箱信息状态 删除
  //   int cmdId = 375011;
  //   // 单个已读/删除
  //   var data1 = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'isAll': 'false', // 是否批量
  //     'type': 2, // 2:删除 1:已读
  //     'mail_id': 18601,
  //     'put_cust_name': 'system',
  //     'send_cust_name': '18800001000',
  //   };
  //   // 批量已读/删除
  //   var data2 = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'isAll': 'true', // 是否批量
  //     'type': 1, // 2:删除 1:已读
  //   };
  //
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data1,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 380334', () async {
  //   // 站内信 设置我的消息 批量已读/删除
  //   int cmdId = 380334;
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   int beginTime = timestamp - 30 * 24 * 3600 * 1000;
  //   int endTime = timestamp + 2 * 24 * 3600 * 1000;
  //   var data = {
  //     'tid': 3,
  //     'state': 9, // 9:已读 100:删除
  //     'receivor_id': 423761, // userInfo.value.cust_id
  //     'receivor_type': 1, // 固定
  //     'message_id': 30, // 固定
  //     'begin_time': beginTime,
  //     'end_time': endTime,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 380335', () async {
  //   // 站内信 设置我的消息 单个已读/删除
  //   int cmdId = 380335;
  //   var data = {
  //     'tid': 3,
  //     'state': 9, // 9:已读 100:删除
  //     'message_inst_id': 1566170, // 列表接口返回
  //     'part_mon': 9, // 列表接口返回
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('一键回收', () async {
  //   int cmdId = 391138;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'type': 1,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     } else {
  //       print('操作失败');
  //     }
  //   }
  // });
  //
  // test('添加虚拟货币', () async {
  //   int cmdId = 310400;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'cust_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'oper_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'state': 1,
  //     'usdt_type': 'TRC20', // 前端写死，只支持TRC20
  //     'pay_no': 'TR1NHXXXXXX',
  //     'pay_org_id': 187,
  //     'pay_org_name': '虚拟货币',
  //     'sort_v': 0, // 1:设为默认 0:非默认
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('添加成功 pay_info_id: ${res.data['pay_info_id']}');
  //   }
  // });
  //
  // test('添加支付宝', () async {
  //   int cmdId = 310400;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'cust_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'oper_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'state': 1,
  //     'pay_name': '张三',
  //     'pay_no': 'san001@zhifubao.com',
  //     'pay_org_id': 185,
  //     'pay_org_name': '支付宝',
  //     'currency': 'CNY',
  //     'sort_v': 1, // 1:设为默认 0:非默认
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // 当前账号最多只能绑定1个支付宝账号！
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('添加成功 pay_info_id: ${res.data['pay_info_id']}');
  //   }
  // });
  //
  // test('request 310412', () async {
  //   // 设定默认银行卡
  //   int cmdId = 310412;
  //   int tid = 3;
  //   int payInfoId = 8828; // pay_info_id
  //   int custId = 423761;
  //   var data = [tid, payInfoId, custId];
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('设定成功');
  //     }
  //   }
  // });
  //
  // test('request 310400', () async {
  //   // 添加 绑卡
  //   int cmdId = 310400;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'cust_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'oper_code': '3_c_18800001000', // userInfo.value.cust_code
  //     'state': 1,
  //     'pay_name': '张三',
  //     'pay_no': '1234567891',
  //     'pay_org_id': '6',
  //     'pay_org_name': '民生银行',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('添加成功 pay_info_id: ${res.data['pay_info_id']}');
  //   }
  // });
  //
  // test('request 310136', () async {
  //   // 检查提现密码是否正确
  //   int cmdId = 310136;
  //   var data = {
  //     'tid': 3,
  //     'acct_pwd': getP('123456'),
  //     'cust_code': '3_c_18800001000',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('提现密码正确');
  //     }
  //   }
  // });
  //
  // test('request 371632', () async {
  //   // 查询IFSC india 待定
  //   int cmdId = 371632;
  //   const data = {
  //     'tid': 3,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  // });
  //
  // test('获取银行列表', () async {
  //   int cmdId = 371234;
  //   int tid = 3;
  //   var data = [tid];
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       List bankList = res.data;
  //       for (Map item in bankList) {
  //         print('pay_org_id: ${item['pay_org_id']}');
  //         print('name: ${item['name']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 310436', () async {
  //   // 添加提现方式时的提示文案
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310436;
  //   const data = {
  //     'tid': 3,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('银行卡提示文案: ${res.data['yinghangka']}');
  //     print('支付宝提示文案: ${res.data['zhifubao']}');
  //     print('虚拟货币提示文案: ${res.data['xunihuobi']}');
  //   }
  // });
  //
  // test('request 310430', () async {
  //   // 返回用户钱包地址
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310430;
  //   int tid = 3;
  //   int custId = 423761;
  //   var data = [tid, custId, 1, 20];
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //     headerType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['count'] > 0) {
  //       if (res.data['data'] is List) {
  //         List payInfos = res.data['data'];
  //         for (Map item in payInfos) {
  //           int payOrgId = item['pay_org_id'];
  //           // 参考 withdraw_constants.dart 中的 payType 值
  //           if (payOrgId == 185) {
  //             print('支付宝');
  //           } else if (payOrgId == 187) {
  //             print('虚拟币');
  //           } else if (payOrgId == 195) {
  //             print('UPI');
  //           } else if (payOrgId == 199) {
  //             print('PicPay');
  //           } else if (payOrgId == 203) {
  //             print('PixPay');
  //           } else {
  //             print('银行卡');
  //           }
  //           print('pay_name: ${item['pay_name']}');
  //           print('pay_org_name: ${item['pay_org_name']}');
  //           print('pay_no: ${item['pay_no']}');
  //           print('sort_v: ${item['sort_v']}');
  //           if (item['sort_v'] == 1) {
  //             print('默认银行卡/渠道');
  //           } else {
  //             print('非默认');
  //           }
  //           print('-----');
  //         }
  //       }
  //     } else {
  //       print('请先设置您的提币地址');
  //     }
  //   }
  // });
  //
  // test('370730', () async {
  //   // 绑卡字段设置 待定
  //   int cmdId = 370730;
  //   const data = {
  //     'tid': 3,
  //     'option_code': 'CHARGE_DESC_NEW',
  //   };
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('http://51zhh5.wc9003.com');
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  // });
  //
  // test('request 3104351', () async {
  //   // 用户的默认银行卡信息 用来生产提现方式列表
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 3104351;
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //   // var data = [tid, custId];
  //   const data = {
  //     'tid': 3,
  //     'cust_id': 424182, // userInfo.value.cust_id
  //   };
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 0,
  //   );
  //   // print('res data: ${res.data}');
  //   // if (res.data is List) {
  //   //   List<int> cutList = withdrawMethodConfigList
  //   //       .map((method) => method['value'] as int)
  //   //       .toList();
  //   //   for (Map payInfo in res.data) {
  //   //     int isBind = payInfo['is_bind'];
  //   //     int cut = payInfo['cut'];
  //   //     // 有权限绑定的 并且 配置含有该项
  //   //     if (isBind != 2 && cutList.contains(cut)) {
  //   //       Map<String, dynamic> config = withdrawMethodConfigList
  //   //           .firstWhere((method) => method['value'] == cut);
  //   //       print('${config['label']}');
  //   //       print('\t${payInfo['pay_org_name']}');
  //   //       print('\t${payInfo['pay_name']}');
  //   //       print('\t${payInfo['pay_no']}');
  //   //     }
  //   //   }
  //   // }
  // });
  // test('request 310435', () async {
  //   // 用户的默认银行卡信息 用来生产提现方式列表
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310435;
  //   int tid = 3;
  //   int custId = 424182;
  //   var data = [tid, custId];
  //   // const data = {
  //   //   'tid': 3,
  //   //   'cust_id': 424182, // userInfo.value.cust_id
  //   // };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //   );
  //   print('res data: ${res.data}');
  // if (res.data is List) {
  //   List<int> cutList = withdrawMethodConfigList
  //       .map((method) => method['value'] as int)
  //       .toList();
  //   for (Map payInfo in res.data) {
  //     int isBind = payInfo['is_bind'];
  //     int cut = payInfo['cut'];
  //     // 有权限绑定的 并且 配置含有该项
  //     if (isBind != 2 && cutList.contains(cut)) {
  //       Map<String, dynamic> config = withdrawMethodConfigList
  //           .firstWhere((method) => method['value'] == cut);
  //       print('${config['label']}');
  //       print('\t${payInfo['pay_org_name']}');
  //       print('\t${payInfo['pay_name']}');
  //       print('\t${payInfo['pay_no']}');
  //     }
  //   }
  // }
  // });
  // test('VIP规则说明', () async {
  //   // vip等级详情 370730 VIP_ACTIVITY_RULE_CONFIG
  //   int cmdId = 370730;
  //   const data = {'tid': 3, 'option_code': 'VIP_ACTIVITY_RULE_CONFIG'};
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('VIP规则说明:');
  //     final htmlContent = res.data['value'];
  //     print('${htmlContent}');
  //   }
  // });

  // test('request 321539', () async {
  //   // 获取vip升级禁用列表信息 321539
  //   int cmdId = 321539;
  //   const data = {
  //     'tid': 3,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       print('禁用列表:');
  //       for (Map item in res.data) {
  //         print('${item['play_name']} 所属平台：${item['play_platfrom']}');
  //       }
  //     }
  //   }
  // });

  // test('request 374031', () async {
  //   // 获取vip晋级模式列表信息,并携带领取状态
  //   // 获取vip晋级模式列表信息 374030
  //   int cmdId = 374031;
  //   const data = {
  //     'tid': 3,
  //     'cust_id': 423761, // userInfo.value.cust_id
  //     'cust_name': '18800001000', // userInfo.value.cust_name
  //     'level': 1, // userInfo.value.cust_level
  //     'state': 1,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['data'] is List) {
  //       List vipList = res.data['data'];
  //       int custLevel = 1; // userInfo.cust_level
  //       print('当前会员等级: VIP${custLevel}');
  //
  //       Map currentItem = vipList[custLevel - 1]; // VIP1是第0个
  //       Map nextItem = vipList[custLevel];
  //
  //       var current = nextItem['balance_lower'] / 1000 -
  //           currentItem['balance_differ_amount'] / 1000;
  //       var next = nextItem['balance_lower'] / 1000;
  //       print('充值进度: ${current}/${next}');
  //
  //       // 当前积分 {{ amountVip.current }} / {{ amountVip.next }}
  //       current = nextItem['value_lower'] / 1000 -
  //           currentItem['differ_amount'] / 1000;
  //       next = nextItem['value_lower'] / 1000;
  //       print('积分进度: ${current}/${next}\n');
  //
  //       for (Map item in vipList) {
  //         print('VIP: ${item['level']}');
  //         print('晋级奖励: ${item['level_reward'] / 1000}');
  //         if (item['isLevelReward'] == 0 ||
  //             item['level_reward'] == 0 ||
  //             custLevel < item['level']) {
  //           print('\t暂不可领取');
  //         }
  //         if (item['isLevelReward'] == 1 &&
  //             item['level_reward'] > 0 &&
  //             custLevel >= item['level']) {
  //           print('\t可以领取');
  //         }
  //         if (item['isLevelReward'] == 2 && item['level_reward'] > 0) {
  //           print('\t已领取');
  //         }
  //
  //         print('周俸禄: ${item['week_reward'] / 1000}');
  //         if (item['isWeekReward'] == 0 ||
  //             item['week_reward'] == 0 ||
  //             custLevel < item['level']) {
  //           print('\t暂不可领取');
  //         }
  //         if (item['isWeekReward'] == 1 &&
  //             item['week_reward'] > 0 &&
  //             custLevel >= item['level']) {
  //           print('\t可以领取');
  //         }
  //         if (item['isWeekReward'] == 2 && item['week_reward'] > 0) {
  //           print('\t已领取');
  //         }
  //
  //         print('月俸禄: ${item['month_reward'] / 1000}');
  //         if (item['isMonth_Reward'] == 0 ||
  //             item['month_reward'] == 0 ||
  //             custLevel < item['level']) {
  //           print('\t暂不可领取');
  //         }
  //         if (item['isMonth_Reward'] == 1 &&
  //             item['month_reward'] > 0 &&
  //             custLevel >= item['level']) {
  //           print('\t可以领取');
  //         }
  //         if (item['isMonth_Reward'] == 2 && item['month_reward'] > 0) {
  //           print('\t已领取');
  //         }
  //         print('自助返水: ${item['scale'] / 1000}%');
  //         print('保级模式: ${item['relegation_mode'] == 0 ? '-' : '降一级'}');
  //         print('保级天数: ${item['relegation_day']}');
  //         print('保级充值: ${item['relegation_charge_lower'] / 1000}');
  //         print('保级投注: ${item['relegation_bet_lower'] / 1000}');
  //         print('每日提款额度: ${item['withdraw_upper_limit'] / 1000}');
  //         print('成长积分: ${item['value_lower'] / 1000}');
  //         print('周俸禄的打码要求: ${item['week_salary'] / 1000}');
  //         print('月俸禄的投注要求: ${item['month_salary'] / 1000}');
  //         print('-----\n');
  //       }
  //       //       print('真人分类下的数据:');
  //       //       List agGames = [];
  //       //       for (Map game in thirdGames) {
  //     }
  //   }
  // });
  // test('首页棋牌下的平台', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['thirdGames'] is List) {
  //       List thirdGames = res.data['thirdGames'];
  //       int i = 1;
  //
  //       final qipaiIds = GameUtils.getCategoryKeys('QP');
  //       qipaiIds.addAll([744, 1034]); // 744 赢博棋牌 1034 瓦力棋牌
  //
  //       for (Map game in thirdGames) {
  //         int playId = game['play_id'];
  //         if (qipaiIds.contains(playId)) {
  //           print('第${i}个:');
  //           print('play_id: ${game['play_id']}');
  //           print('play_cname: ${game['play_cname']}');
  //           print('-----');
  //           i++;
  //         }
  //       }
  //     }
  //   }
  // });
  //
  // test('获取所有的棋牌游戏', () async {
  //   // 棋牌，与电子使用相同接口，不需要传入upper_id参数
  //   int cmdId = 320146;
  //   const data = {
  //     'tid': 3,
  //     'cust_id': 0,
  //     // 'upper_id': -1, // -1:电子
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       Map mapData = res.data as Map;
  //       String playId = '382'; // 财神棋牌
  //       if (mapData.containsKey(playId)) {
  //         List allGames = mapData[playId];
  //         print('财神棋牌 全部 有${allGames.length}个游戏');
  //
  //         List hotGames = allGames
  //             .where((game) => (game['hot_val'] ?? 0) > 0)
  //             .toList()
  //           ..sort(
  //               (a, b) => (b['hot_val'] ?? 0).compareTo((a['hot_val'] ?? 0)));
  //         print('财神棋牌 热门 有${hotGames.length}个游戏');
  //
  //         List recentGames = allGames
  //             .where((game) => (game['is_top'] ?? 0) > 0)
  //             .toList()
  //           ..sort((a, b) => (b['is_top'] ?? 0).compareTo((a['is_top'] ?? 0)));
  //         print('财神棋牌 最新 有${recentGames.length}个游戏');
  //
  //         List collectGames = allGames
  //             .where((game) => (game['play_collection'] ?? 0) == 2)
  //             .toList();
  //         print('财神棋牌 收藏 有${collectGames.length}个游戏');
  //       }
  //     }
  //   }
  // });
  //
  // test('首页真人/体育分类下数据', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['thirdGames'] is List) {
  //       List thirdGames = res.data['thirdGames'];
  //       print('真人分类下的数据:');
  //       List agGames = [];
  //       for (Map game in thirdGames) {
  //         int playId = game['play_id'];
  //         if (playInfo.containsKey(playId)) {
  //           Map<String, dynamic> info = playInfo[playId]!;
  //           // 真人 == AG，体育 == TY
  //           if (info['cat'] == 'AG') {
  //             agGames.add({
  //               'play_id': game['play_id'],
  //               'play_cname': game['play_cname'],
  //               'hot_val': game['hot_val'],
  //               'is_top': game['is_top'],
  //               'play_collection': game['play_collection'],
  //             });
  //           }
  //         }
  //       }
  //
  //       print('真人 全部 有${agGames.length}个游戏');
  //       // for (Map game in agGames) {
  //       //   print(game['play_cname']);
  //       // }
  //
  //       List hotGames = agGames
  //           .where((game) => (game['hot_val'] ?? 0) > 0)
  //           .toList()
  //         ..sort((a, b) => (b['hot_val'] ?? 0).compareTo((a['hot_val'] ?? 0)));
  //       print('真人 热门 有${hotGames.length}个游戏');
  //
  //       List recentGames = agGames
  //           .where((game) => (game['is_top'] ?? 0) > 0)
  //           .toList()
  //         ..sort((a, b) => (b['is_top'] ?? 0).compareTo((a['is_top'] ?? 0)));
  //       print('真人 最新 有${recentGames.length}个游戏');
  //
  //       List collectGames = agGames
  //           .where((game) => (game['play_collection'] ?? 0) == 2)
  //           .toList();
  //       print('真人 收藏 有${collectGames.length}个游戏');
  //     }
  //   }
  // });
  //
  // test('首页捕鱼分类下数据', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['thirdGames'] is List) {
  //       List thirdGames = res.data['thirdGames'];
  //       print('捕鱼分类下的平台:');
  //       for (Map game in thirdGames) {
  //         int playId = game['play_id'];
  //         if (playInfo.containsKey(playId)) {
  //           Map<String, dynamic> info = playInfo[playId]!;
  //           if (info['cat'] == 'BY') {
  //             print(
  //                 '\tplay_id: ${game['play_id']} play_cname: ${game['play_cname']}');
  //             print('\t-----');
  //           }
  //         }
  //         // if (GameUtils.getGameCategory(game['play_id']) == 3) {}
  //       }
  //     }
  //
  //     // 所有的捕鱼游戏
  //     if (res.data['homeHotGames']['3'] is List) {
  //       List homeHotGames3 = res.data['homeHotGames']['3'];
  //       List fishingGames = [];
  //       for (var game in homeHotGames3) {
  //         int playId = game['play_id'];
  //         if (playInfo.containsKey(playId)) {
  //           Map<String, dynamic> info = playInfo[playId]!;
  //           fishingGames.add({
  //             'play_id': playId,
  //             'main_id': info['main_id'],
  //             'play_cname': info['play_cname'],
  //             'hot_val': game['hot_val'],
  //             'is_top': game['is_top'],
  //             'play_collection': game['play_collection'],
  //           });
  //         } else {
  //           // print('捕鱼 ${playId} 不存在');
  //         }
  //       }
  //       int mainId = 708; // 平台 FG捕鱼 的play_id
  //       List fgAllGames = fishingGames
  //           .where((game) => (game['main_id'] ?? 0) == mainId)
  //           .toList();
  //       print('FG捕鱼 全部 有${fgAllGames.length}个游戏');
  //       // for (Map game in fgAllGames) {
  //       //   print(game['play_cname']);
  //       // }
  //
  //       List hotGames = fgAllGames
  //           .where((game) => (game['hot_val'] ?? 0) > 0)
  //           .toList()
  //         ..sort((a, b) => (b['hot_val'] ?? 0).compareTo((a['hot_val'] ?? 0)));
  //       print('FG捕鱼 热门 有${hotGames.length}个游戏');
  //
  //       List recentGames = fgAllGames
  //           .where((game) => (game['is_top'] ?? 0) > 0)
  //           .toList()
  //         ..sort((a, b) => (b['is_top'] ?? 0).compareTo((a['is_top'] ?? 0)));
  //       print('FG捕鱼 最新 有${recentGames.length}个游戏');
  //
  //       List collectGames = fgAllGames
  //           .where((game) => (game['play_collection'] ?? 0) == 2)
  //           .toList();
  //       print('FG捕鱼 收藏 有${collectGames.length}个游戏');
  //     }
  //   }
  // });
  //
  // test('首页电子分类下的平台', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['thirdGames'] is List) {
  //       List thirdGames = res.data['thirdGames'];
  //       int i = 1;
  //       for (Map game in thirdGames) {
  //         int playId = game['play_id'];
  //         if (playInfo.containsKey(playId)) {
  //           Map<String, dynamic> info = playInfo[playId]!;
  //           if (info['cat'] == 'DZ') {
  //             print('第${i}个:');
  //             print('play_id: ${game['play_id']}');
  //             // 国际化，PG电子: 'PG',
  //             print('play_cname: ${game['play_cname']}');
  //             print('-----');
  //             i++;
  //           }
  //         }
  //         // 748 鑫豪爷电子 (不要了)， H5还有展示
  //         // GameUtils.getGameCategory 代码需要优化
  //         // if (GameUtils.getGameCategory(game['play_id']) == 2) {}
  //       }
  //     }
  //   }
  // });
  //
  // test('320146', () async {
  //   final DateTime startTime = DateTime.now(); // 记录开始时间
  //   // 电子
  //   int cmdId = 320146;
  //   const data = {
  //     'tid': 3,
  //     'cust_id': 423761, //0,
  //     'upper_id': -1, // -1:电子
  //   };
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //   final res = await ns.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //   );
  //   final DateTime endTime = DateTime.now(); // 记录结束时间
  //   final duration = endTime.difference(startTime); // 计算时间差
  //
  //   print('接口响应时间: ${duration.inMilliseconds} 毫秒');
  //   // print('res data: ${res.data}');
  //   // if (res.type == NetworkService.networkTypeSuccess) {
  //   //   if (res.data is Map) {
  //   //     Map mapData = res.data as Map;
  //   //     String playId = '1380'; // PG 电子
  //   //     if (mapData.containsKey(playId)) {
  //   //       List allGames = mapData[playId];
  //   //       print('PG电子 全部 有${allGames.length}个游戏');
  //   //
  //   //       List hotGames = allGames
  //   //           .where((game) => (game['hot_val'] ?? 0) > 0)
  //   //           .toList()
  //   //         ..sort(
  //   //             (a, b) => (b['hot_val'] ?? 0).compareTo((a['hot_val'] ?? 0)));
  //   //       print('PG电子 热门 有${hotGames.length}个游戏');
  //   //
  //   //       List recentGames = allGames
  //   //           .where((game) => (game['is_top'] ?? 0) > 0)
  //   //           .toList()
  //   //         ..sort((a, b) => (b['is_top'] ?? 0).compareTo((a['is_top'] ?? 0)));
  //   //       print('PG电子 最新 有${recentGames.length}个游戏');
  //   //
  //   //       List collectGames = allGames
  //   //           .where((game) => (game['play_collection'] ?? 0) == 2)
  //   //           .toList();
  //   //       print('PG电子 收藏 有${collectGames.length}个游戏');
  //   //     }
  //   //   }
  //   // }
  // });
  //
  // test('首页游戏分类', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['version_type'] is List) {
  //       // 获取分类列表
  //       List<dynamic> categoryList = res.data['version_type'];
  //       // 移除 sort_v 为 0 的对象，并按照 sort_v 值进行降序排序
  //       categoryList.removeWhere((item) => item['sort_v'] == 0);
  //       categoryList.sort((a, b) => b['sort_v'].compareTo(a['sort_v']));
  //       // 支持的游戏类别
  //       List<int> supportList = [1, 2, 3, 4, 5, 6];
  //       // 筛选出 type 在 supportList 中的对象
  //       categoryList = categoryList
  //           .where((item) => supportList.contains(item['type']))
  //           .toList();
  //
  //       // 初始化 homeCategoryList
  //       List<Map<String, dynamic>> homeCategoryList = [
  //         {'name': '推荐', 'key': '103', 'icon': 'xxx'},
  //         {'name': '收藏', 'key': '101', 'icon': 'xxx'},
  //         {'name': '最近', 'key': '102', 'icon': 'xxx'},
  //       ];
  //       // 将 categoryList 中的对象添加到 homeCategoryList
  //       for (var category in categoryList) {
  //         homeCategoryList.add({
  //           'name': category['play_name'],
  //           'key': category['type'],
  //           'icon': 'xxx',
  //         });
  //       }
  //       print('首页展示的分类列表: $homeCategoryList');
  //     }
  //   }
  // });
  //
  // test('request 390003', () async {
  //   // 返水页面数据
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 390003;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 252158,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // 一键返水按钮是否可以点击 0-可以点击 1-置灰
  //     int is_auto = res.data['is_auto'];
  //     if (is_auto == 1) {
  //       print('不可以一键返水');
  //     } else {
  //       print('可以一键返水');
  //     }
  //     print('总计游戏投注: ${res.data['play_amount_sum']}');
  //     print('返水总金额: ${res.data['shuffle_amount_sum']}');
  //     if (res.data['list'] is Map) {
  //       // 游戏投注金额和返水金币数据
  //       Map mapData = res.data['list'] as Map;
  //       List keys = mapData.keys.toList();
  //       for (String key in keys) {
  //         if (key == '100') {
  //           print('棋牌');
  //         } else if (key == '101') {
  //           print('电子');
  //         } else if (key == '102') {
  //           print('捕鱼');
  //         }
  //         if (mapData[key] is List) {
  //           List games = mapData[key];
  //           for (Map game in games) {
  //             print('\tplay_name: ${game['play_name']}');
  //           }
  //         }
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 340620', () async {
  //   // 余额宝 明细
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 340620;
  //   var data = {
  //     'tid': 3,
  //     'cust_code': '18800001000', // userInfo.value.cust_name
  //     'page_start': 1,
  //     'num_per_page': 10,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int count = res.data['count'];
  //     print('count: $count');
  //     if (res.data['data'] is List) {
  //       List records = res.data['data'];
  //       for (Map record in records) {
  //         print('remark: ${record['remark']}');
  //         if (record['trans_type'] == '409') {
  //           print('发生额: -${record['gen_amount'] / 1000}');
  //         } else {
  //           print('发生额: ${record['gen_amount'] / 1000}');
  //         }
  //
  //         print('余额: ${record['rear_balance'] / 1000}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 340335', () async {
  //   // 余额宝 转出
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 340335;
  //   var data = {
  //     'tid': 3,
  //     'acct_id': 589612, // userInfo.value.acct_id
  //     'balance': 100000, // 100x1000,
  //     'mark': 1,
  //     'oper_code': '3_c_18800001000', // userInfo.value.cust_code
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('转出成功');
  //     }
  //   }
  // });
  //
  // test('request 340334', () async {
  //   // 余额宝 转入
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 340334;
  //   var data = {
  //     'tid': 3,
  //     'acct_id': 589612, // userInfo.value.acct_id
  //     'balance': 100000, // 100x1000,
  //     'mark': 1,
  //     'oper_code': '3_c_18800001000', // userInfo.value.cust_code
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['balance_transfer_id'] == 1) {
  //       print('转入成功');
  //       print('继续请求340336 370601');
  //     }
  //   }
  // });
  //
  // test('request 360731', () async {
  //   // 验证余额宝
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 360731;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'type': '105',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('继续请求340334');
  //     }
  //   }
  // });
  //
  // test('request 340337', () async {
  //   // 余额宝利息相关
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 340337;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     // mb_t('余额宝说明')
  //     print('总金币: ${res.data['total_balance'] / 1000}');
  //     print('总本金: ${res.data['principal'] / 1000}');
  //     print('计息金币: ${res.data['balance'] / 1000}');
  //     print('上次收益: ${res.data['before_interest'] / 1000}');
  //     print('累计收益: ${res.data['total_interest'] / 1000}');
  //     print('日利率: ${res.data['day_skill'] / 100}%');
  //   }
  // });
  //
  // test('request 370601', () async {
  //   // 余额宝利息
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 370601;
  //   var data = {
  //     'tid': 3,
  //     'type': '105',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['state'] == 1) {
  //       print('继续请求340337');
  //     }
  //   }
  // });
  //
  // test('request 340336', () async {
  //   // 余额宝余额
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 340336;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('余额宝余额: ${res.data['balanceTreasure'] / 1000}');
  //     print('钱包金币: ${res.data['acctBalance'] / 1000}');
  //   }
  // });
  //
  // test('request 360728', () async {
  //   // 查询活动状态
  //   int cmdId = 360728;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'activity_name': 'qiandao', // 签到
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('活动正常');
  //     }
  //   }
  // });
  //
  // test('request 374002', () async {
  //   // 签到
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 374002;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('签到成功');
  //     }
  //   }
  // });
  //
  // test('request 374003', () async {
  //   // 获取签到数据
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 374003;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       int isLevelReward = res.data['isLevelReward'];
  //       if (isLevelReward == 2) {
  //         print('不能领取，请联系客服');
  //       }
  //
  //       List rewardList = [
  //         res.data['monday'] / 1000,
  //         res.data['tuesday'] / 1000,
  //         res.data['wednesday'] / 1000,
  //         res.data['thursday'] / 1000,
  //         res.data['friday'] / 1000,
  //         res.data['saturday'] / 1000,
  //         res.data['sunday'] / 1000,
  //       ];
  //       print('奖励列表:$rewardList');
  //       int signDay = res.data['sign_day'];
  //       print('签到天数:$signDay');
  //       if (res.data['day_type'] == 1) {
  //         print('已签到');
  //       } else {
  //         print('未签到');
  //       }
  //
  //       int web_state = res.data['web_state'];
  //       int signType = res.data['sign_type'];
  //       if (signType == 1) {
  //         print('金币');
  //       } else if (signType == 2) {
  //         print('成长值');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 324463', () async {
  //   // 平台简介 常见问题 注册协议 理财服务协议 隐私协议 type:6
  //   int cmdId = 324463;
  //   var data = {
  //     'tid': 3,
  //     'type': 6,
  //     'language': 0,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       print('平台简介: ${res.data['about_us']}');
  //       print('常见问题: ${res.data['rule_introduction']}');
  //       print('注册协议: ${res.data['company_cooperation']}');
  //     }
  //   }
  // });
  //
  // test('request 371137', () async {
  //   // 获取备用网址
  //   int cmdId = 371137;
  //   var data = {
  //     'tid': 3,
  //     'state': 1,
  //     'proxy': 0, // tenantInfo.value.proxy
  //     'chan_code': 'tiyuh5',
  //     'page_start': 1,
  //     'num_per_page': 1000,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['data'] is List) {
  //       List domains = res.data['data'];
  //       for (Map domain in domains) {
  //         print('网址: ${domain['domain_addr']}');
  //         print('权重: ${domain['weight']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });

  // test('request 380239', () async {
  //   // 获取在线客服列表
  //   int cmdId = 380239;
  //   var data = {
  //     'tid': 3,
  //     'state': 1,
  //     'message_id': 50,
  //     'proxy': 0, // tenantInfo.value.proxy
  //     'cust_id': 423761,
  //     'chan_con': 8,
  //     'chan_code': 'MWEB',
  //     'language': 0,
  //     'apply': 6,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  // });

  // test('request 375010', () async {
  //   // 站内信 收件箱
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 375010;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       List mails = res.data;
  //       DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //       for (Map mail in mails) {
  //         print('mail_id: ${mail['mail_id']}');
  //         print('theme: ${mail['theme']}');
  //         print('content: ${mail['content']}');
  //         DateTime date =
  //             DateTime.fromMillisecondsSinceEpoch(mail['send_time']);
  //         print('send_time: ${formatter.format(date)}');
  //         print('put_cust_name: ${mail['put_cust_name']}');
  //         print('send_cust_name: ${mail['send_cust_name']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 375023', () async {
  //   // 站内信 收件箱回复列表
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 375023;
  //   var data = {
  //     'tid': 3,
  //     'mail_id': 18544,
  //     'send_cust_name': '18800001000', // 来自接口 375010
  //     'put_cust_name': 'system', // 来自接口 375010
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       List replies = res.data;
  //       DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //       for (Map reply in replies) {
  //         print('cust_name: ${reply['cust_name']}');
  //         print('reply_content: ${reply['reply_content']}');
  //         DateTime date =
  //             DateTime.fromMillisecondsSinceEpoch(reply['send_time']);
  //         print('send_time: ${formatter.format(date)}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 375018', () async {
  //   // 站内信 回复收件箱信息
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 375018;
  //   String replyContent = '789';
  //   var data = {
  //     'tid': 3,
  //     'mail_id': 18544,
  //     'send_cust_name': '18800001000', // 来自接口 375010
  //     'put_cust_name': 'system', // 来自接口 375010
  //     'reply_content': replyContent,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 375017', () async {
  //   // 站内信 问题反馈
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 375017;
  //   String content = '反馈内容1';
  //   var data = {
  //     'tid': 3,
  //     'theme': '问题反馈',
  //     'from_user': '18800001000',
  //     'data_type': 7,
  //     'content': content,
  //     'addresseeName': 'system',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 380232', () async {
  //   // 站内信 系统公告
  //   int cmdId = 380232;
  //   var data = {
  //     'tid': 3,
  //     'proxy': 0, // tenantInfo.value.proxy
  //     'vip_level': 1, // userInfo.value.cust_level || 0
  //     'type': 'MWEB',
  //     'language': 0, // languageNum, cn: 0, en: 1,
  //     'sort_flag': 1,
  //     'state': 1,
  //     'chan_con': 8,
  //     'apply': 8,
  //     'message_id': 10,
  //     'page_start': 1,
  //     'num_per_page': 15,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int count = res.data['count'];
  //     print('count: $count');
  //     if (res.data['data'] is List) {
  //       List messages = res.data['data'];
  //       for (Map message in messages) {
  //         print('content_type: ${message['content_type']}');
  //         print('content: ${message['content']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  // test('request 380336', () async {
  //   // 站内信 我的消息列表
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 380336;
  //   int timestamp = DateTime.now().millisecondsSinceEpoch;
  //   int beginTime = timestamp - 30 * 24 * 3600 * 1000;
  //   int endTime = timestamp + 2 * 24 * 3600 * 1000;
  //   var data = {
  //     'tid': 3,
  //     'receivor_id': 423761,
  //     'receivor_type': 1,
  //     'message_id': 30,
  //     'page_start': 1,
  //     'num_per_page': 10,
  //     'begin_time': beginTime,
  //     'end_time': endTime,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int count = res.data['count'];
  //     print('count: $count');
  //     if (res.data['data'] is List) {
  //       List messages = res.data['data'];
  //       for (Map message in messages) {
  //         print('message_id: ${message['message_id']}');
  //         print('subject: ${message['subject']}');
  //         print('content_type: ${message['content_type']}');
  //         print('content: ${message['content']}');
  //         print('detail_type: ${message['detail_type']}');
  //         print('detail: ${message['detail']}');
  //         print('state: ${message['state']}'); // state=9 表示已读
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 310211', () async {
  //   // 修改联系方式 真实姓名
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310211;
  //   String contactName = '张三2';
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'mark': 1,
  //     'contact_name': contactName,
  //     'contact_addr': '',
  //     'email': '',
  //     'facebook': '',
  //     'mobile_phone': '',
  //     'qq': '',
  //     'telegram': '',
  //     'weixin': '',
  //     'whatsApp': '',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   } else {
  //     if (res.data is NetworkError) {
  //       NetworkError error = res.data;
  //       print('error: ${error.info}');
  //     }
  //   }
  // });
  //
  // test('request 310230', () async {
  //   // 获取联系方式
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310230;
  //   int tid = 3;
  //   int custId = 423761;
  //   var data = [tid, custId];
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       String contactName = res.data['contact_name'];
  //       print('真实姓名: $contactName');
  //     }
  //   }
  // });
  //
  // test('request 314502', () async {
  //   // 获取投注记录列表信息
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 314502;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'type_id': 4, // 电子投注
  //     'platform': 1380, // PG
  //     'start_time': 1725811200000, // 20240909
  //     'end_time': 1725897599000, // 20240909
  //     'page_start': 1,
  //     'num_per_page': 10,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['data'] is List) {
  //       List records = res.data['data'];
  //       DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  //       for (Map record in records) {
  //         int timestamp = record['bet_start_time'];
  //         DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  //         print('投注时间: ${formatter.format(date)}');
  //         print(
  //             '游戏-注单: PG-${record['game_type_id']} ${record['platform_order_id']}');
  //         print('投注金额: ${record['effective_bets'] / 1000}');
  //         print('已派奖: ${record['profit_loss'] / 1000}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 310122', () async {
  //   // 修改提现密码
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   // 支付密码 注册有填 填的 如果注册没有填 默认就是 登录密码
  //   int cmdId = 310122;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'ispwd': -1,
  //     'acct_pwd': getP('123456'),
  //     'ori_acct_pwd': getP('123457'),
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 31011101', () async {
  //   // 修改登录密码
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 31011101;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'cust_code': '3_c_18800001000',
  //     'mark': '1',
  //     'ispwd': -1,
  //     'password': getP('123456'),
  //     'ori_password': getP('123457'),
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  // test('request 313232', () async {
  //   // 是否修改过密码
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 313232;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'pwd_type': 0, // 0: 登录密码，1: 提现密码
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('count: ${res.data['count']}');
  //   }
  // });
  // test('request 310113', () async {
  //   // 修改昵称
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310113;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'nickname': '昵称18810',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['response_code'] == '9999') {
  //       print('操作成功');
  //     }
  //   }
  // });
  //
  // test('request 322961', () async {
  //   // 积分查询
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 322961;
  //   var data = {
  //     'tid': 3,
  //     'custId': 423761,
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       int usable = res.data['usable'];
  //       int tomorrow = res.data['tomorrow'];
  //       print('我的当前积分: ${usable / 1000}');
  //       print('明日转化积分: ${tomorrow / 1000}');
  //     }
  //   }
  // });
  //
  // test('request 322957', () async {
  //   // 大转盘查询奖品列表
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 322957;
  //   var data = {
  //     'tId': 3,
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //   );
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['luckyBigWheelSys'] is List) {
  //       List wheels = res.data['luckyBigWheelSys'];
  //       for (Map wheel in wheels) {
  //         print('轮盘标识: ${wheel['sysId']}');
  //         print('轮盘名字: ${wheel['name']}');
  //         print('每次消耗 ${wheel['integral'] / 1000} 积分');
  //         print('奖品列表:');
  //         if (wheel['luckyBigWheeDetails'] is List) {
  //           List prizeList = wheel['luckyBigWheeDetails'];
  //           for (Map prize in prizeList) {
  //             print('\t奖品名字:${prize['name']}');
  //             print('\t奖品价值:${prize['prize'] / 1000}');
  //             print('\t奖品图片:${prize['img_url']}');
  //             print('\t-----');
  //           }
  //         }
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 322962', () async {
  //   // 大转盘抽奖
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 322962;
  //   var data = {
  //     'tid': 3,
  //     'custId': 423761,
  //     'sysId': 42, // 322957接口返回
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is Map) {
  //       print('奖品名字:${res.data['name']}');
  //       print('奖品价值:${res.data['prize'] / 1000}');
  //       print('奖品图片:${res.data['img_url']}');
  //     }
  //   }
  // });
  //
  // test('request 340333', () async {
  //   // 账变明细
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   List<Map<String, dynamic>> firstList = [
  //     {'trans_type': 0, 'text': '全部'},
  //     {'trans_type': 1, 'text': '充值记录'},
  //     {'trans_type': 3, 'text': '提现记录'},
  //     {'trans_type': 5, 'text': '投注返水'},
  //     {'trans_type': 8, 'text': '代理返点'},
  //     {'trans_type': 6, 'text': '充值优惠'},
  //     {'trans_type': 11, 'text': '余额转换'},
  //     {'trans_type': 17, 'text': '活动礼金'},
  //     {'trans_type': 19, 'text': '其它'},
  //   ];
  //   Map<int, List<Map<String, dynamic>>> secondList = {
  //     1: [
  //       {'trans_type': 200, 'text': '自助充值'},
  //       {'trans_type': 701, 'text': '手工充值'},
  //     ],
  //     3: [
  //       {'trans_type': 900, 'text': '提款中'},
  //       {'trans_type': 901, 'text': '提款失败'},
  //       {'trans_type': 902, 'text': '提款'},
  //     ],
  //     5: [
  //       {'trans_type': 350, 'text': '自助领取'},
  //       {'trans_type': 414, 'text': '人工赠送'},
  //       {'trans_type': 999, 'text': '系统派送'},
  //     ],
  //     6: [
  //       {'trans_type': 398, 'text': '手动添加奖金'},
  //       {'trans_type': 399, 'text': '首次充值奖金'},
  //       {'trans_type': 712, 'text': '渠道充值奖金'},
  //     ],
  //     17: [
  //       {'trans_type': 402, 'text': '注册奖金'},
  //       {'trans_type': 403, 'text': '首次登录奖金'},
  //       {'trans_type': 404, 'text': '签到奖金'},
  //       {'trans_type': 703, 'text': '晋级VIP奖金'},
  //       {'trans_type': 702, 'text': '周俸禄'},
  //       {'trans_type': 704, 'text': '月俸禄'},
  //       {'trans_type': 419, 'text': '推荐奖金'},
  //       {'trans_type': 412, 'text': '分享领工资'},
  //       {'trans_type': 405, 'text': '亏损救援金'},
  //       {'trans_type': 418, 'text': '转盘奖金'},
  //       {'trans_type': 888, 'text': '红包雨奖金'},
  //       {'trans_type': 417, 'text': '会员任务'},
  //       {'trans_type': 411, 'text': '游戏任务'},
  //       {'trans_type': 9999991, 'text': '其他'},
  //     ],
  //   };
  //
  //   dynamic trans_type = 0; // 全部
  //   dynamic busi_type = 0; // 全部
  //   // trans_type = ['17']; // 活动礼金
  //   // busi_type = ['402']; // 注册奖金
  //
  //   int cmdId = 340333;
  //   int tid = 3;
  //   // 测试账号 13412341235
  //   int acct_id = 589612; //注意是acct_id，不是cust_id，
  //   int start_time = 1722470400 * 1000; // 2024-07-01，时间戳，毫秒
  //   int end_time = start_time + (90 * 86400000 - 1000); // 90天
  //   var data = {
  //     'tid': tid,
  //     'acct_id': acct_id,
  //     'trans_type': trans_type,
  //     'busi_type': busi_type,
  //     'start_time': start_time,
  //     'end_time': end_time,
  //     'page_start': 1,
  //     'num_per_page': 10,
  //   };
  //   // 查询全部记录时不要传trans_type, busi_type
  //   if (trans_type == 0) {
  //     data.remove('trans_type');
  //   }
  //   if (busi_type == 0) {
  //     data.remove('busi_type');
  //   }
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 0,
  //     headerType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int count = res.data['count']; // 记录总条数
  //     if (count > 0) {
  //       if (res.data['t'] is Map) {
  //         Map t = res.data['t'];
  //         print('交易总金币: ${t['sum_total_amount'] / 1000}');
  //         print('-----');
  //       }
  //       if (res.data['data'] is List) {
  //         List items = res.data['data'];
  //         for (Map info in items) {
  //           print('trans_type: ${info['trans_type']}');
  //           print('busi_type: ${info['busi_type']}');
  //           print('备注: ${info['remark']}');
  //           print('stat_msg: ${info['stat_msg']}');
  //           print('交易流水: ${info['trans_serial']}');
  //           print('原交易流水: ${info['orig_trans_serial']}');
  //           print('交易类型: ${info['trans_type']}');
  //           print('发生金币: ${info['gen_amount'] / 1000}');
  //           print('交易金币: ${info['total_amount'] / 1000}');
  //           print('操作后余额: ${info['balance'] / 1000}');
  //           print('操作后冻结余额: ${info['freeze_balance']}');
  //           print('发生打码量: ${info['gen_marking'] / 1000}');
  //           print('操作后打码量: ${info['marking_quantity'] / 1000}');
  //           print('-----');
  //         }
  //       }
  //     }
  //   }
  // });
  //
  // test('request 373133', () async {
  //   //373133
  //   int cmdId = 373133;
  //   var data = {
  //     'tid': 3,
  //     // 1聊天线路 8视频线路 9阿里云存储线路 10AWS云存储
  //     'domain_type': '8', // 支持一次请求多种 比如1,8
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 0,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       for (Map domainInfo in res.data) {
  //         print('domain_line_id: ${domainInfo['domain_line_id']}');
  //         print('domain_addr: ${domainInfo['domain_addr']}');
  //         print('state: ${domainInfo['state']}');
  //       }
  //     }
  //   }
  // });
  //
  // test('request 340234', () async {
  //   // 请求账户余额(汇总)
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //
  //   int cmdId = 340234;
  //   int tid = 3;
  //   int custId = 417542;
  //   var data = [tid, custId];
  //   final res = await ns.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //     headerType: 2,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('账户金额: ${res.data['balance'] / 1000}');
  //     print('VIP等级: ${res.data['level']}'); // 刷新余额时对用户 cust_level 等级刷新
  //   }
  // });
  //
  // test('request 310140', () async {
  //   // 提现限制
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310140;
  //   int tid = 3;
  //   int custId = 423761;
  //   var data = [tid, custId];
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //     headerType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     int v1 = ensureInt(res.data['withdraw_min_amount']);
  //     int v2 = ensureInt(res.data['withdraw_min_amount_ali']);
  //     double minAmount = (v1 > 0 ? v1 : v2) / 1000;
  //     print('最小提现金额: $minAmount');
  //     v1 = ensureInt(res.data['withdraw_amount']);
  //     v2 = ensureInt(res.data['withdraw_amount_ali']);
  //     double maxAmount = (v1 > 0 ? v1 : v2) / 1000;
  //     print('最大提现金额: $maxAmount');
  //     print('最大金额为0时的提现自定义提示: ${res.data['withdraw_prompt_word']}');
  //   }
  // });
  //
  // test('request 310139', () async {
  //   // 充值渠道
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310139;
  //   int tid = 3; // 租户标识
  //   int custId = 424182; // 用户标识
  //   var data = [tid, custId];
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //     headerType: 2,
  //   );
  //   // print('res data: ${res.data}');
  //   if (res.data is List) {
  //     for (int i = 0; i < res.data.length; i++) {
  //       var item = res.data[i];
  //       print('第${i + 1}个:');
  //       print('aseq_id: ${item['aseq_id']}');
  //       print('name: ${item['name']}');
  //       // mark 1线下 2线上 3快速充值
  //       print('mark: ${item['mark']}');
  //       // 线上、线下通道字段不同
  //       var channelKey = '';
  //       if (item['mark'] == 1) {
  //         print('线下');
  //         channelKey = 'tenantPayInfo';
  //       } else if (item['mark'] == 2) {
  //         print('线上');
  //         channelKey = 'tenantPayMerchant';
  //       } else if (item['mark'] == 3) {
  //         print('快速充值');
  //         // 跟线上一样
  //         channelKey = 'tenantPayMerchant';
  //       }
  //
  //       if (item[channelKey] is List) {
  //         for (var channel in item[channelKey]) {
  //           print('\t通道名字: ${channel['channel_custom_name']}');
  //           print('\t通道图标: ${channel['icon_url']}');
  //           print('\t通道优惠百分比: ${channel['maxPercentage']}');
  //           if (channel['percentageList'] is List) {
  //             for (var partner in channel['percentageList']) {
  //               // 5%(存款2倍打码)
  //               double partnerB = double.tryParse(partner['b']) ?? 0;
  //               print('\t通道优惠: ${partner['a']}%(存款${partnerB / 100}倍打码)');
  //             }
  //           }
  //           print('\t最小充值: ${channel['quota_min'] / 1000}');
  //           print('\t最大充值: ${channel['quota_max'] / 1000}');
  //           if (channel['is_enter_amount'] == 1) {
  //             print('\t可以输入充值金额');
  //           } else {
  //             print('\t不可以输入充值金额');
  //           }
  //           print('\t-----');
  //         }
  //       }
  //     }
  //   }
  // });
  //
  // test('request 320567', () async {
  //   // 首页游戏 收藏/取消收藏
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   // 首页游戏对象中 play_collection=2表示已收藏，play_collection=1表示未收藏，
  //   int cmdId = 320567;
  //   int status = 1; // 1:收藏 2:取消收藏
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'play_id': 1383015,
  //     'type': 12,
  //     'play_cat': 3,
  //     'status': status,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     headerType: 2,
  //     isApiV2: false,
  //     paramType: 0,
  //   );
  //   print('res data: ${res.data}');
  //   if (res.data['response_code'] == '9999') {
  //     print('操作成功');
  //   }
  // });
  //
  // test('request 3', () async {
  //   // 账号注册
  //   String custName = '18800001001'; // 账户
  //   String password = '123456'; // 密码
  //   String inviteCode = '';
  //
  //   int cmdId = 3;
  //   // 头像的地址 https://image2.typay2.com//static/heads/head_192.png
  //   int randomNumber = randomInteger(1, 200);
  //   final headURI =
  //       '/static/heads/head_${strPadLeft(randomNumber.toString(), 2)}.png';
  //   var data = {
  //     'acctPwd': '',
  //     'acct_pwd': '',
  //     'adm_code': '1',
  //     'chan_code': AppConfigs.chanCode,
  //     'client_id': AppConfigs.clientId,
  //     'contact_name': '', // 真实会员名称
  //     'cust_name': custName, // 会员账号
  //     'domain_addr': '',
  //     'email': '', // 注册邮箱
  //     'emailCode': '',
  //     'facebook': '', // 注册的facebook
  //     'gender': 0,
  //     'grant_type': 'password',
  //     'head': headURI,
  //     'invite_code': inviteCode, // 邀请码
  //     'line': '', // line 邮箱
  //     'link_addr': '',
  //     'mobile_phone': '', // 联系电话
  //     'nickname': '', // 昵称
  //     'password': getP(password),
  //     'platform': getBetPlatform(),
  //     'proxy': 0, //tenantState.tenantInfo.proxy,
  //     'qq': '', // qq
  //     'regist_from':
  //         'typcblack.lg0808.com', // tenantState.tenantInfo.domain_addr
  //     'scope': 'read write',
  //     'state': 1,
  //     'tid': 3, //tenantState.tenantInfo.tid,
  //     'whatsApp': '',
  //     'zalo': '',
  //     'verifycode': '',
  //     'verifycode_key': '',
  //     'isQp': 1
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: 1,
  //     headerType: 1,
  //   );
  //
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('res data: ${res.data}');
  //   } else {
  //     NetworkError error = res.data;
  //     error.log();
  //   }
  // });
  //
  // test('request 310635', () async {
  //   // 退出登录
  //   // 测试时需要修改service.dart中的accessToken, tid, Custid
  //   int cmdId = 310635;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 423761,
  //     'cust_code': '3_c_18800001000',
  //     'app_key': '',
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     headerType: 2,
  //     isApiV2: false,
  //     paramType: 1,
  //   );
  //
  //   print('res data: ${res.data}');
  //   if ((res.data is String) && res.data.toString() == '亲，麻烦重新登录哦') {
  //     print('当前账户不是已登录状态');
  //   } else if (res.data['response_code'] == '9999') {
  //     print('退出登录成功');
  //   }
  // });
  //
  // test('request 7', () async {
  //   // 获取图形验证码
  //   int cmdId = 7;
  //   var data = {
  //     'type': 2, // 1:登录 2:注册
  //     'verifycode_key': uuid(32, 16),
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 0,
  //     headerType: 1,
  //   );
  //
  //   print('res data: ${res.data}');
  // });
  //
  // test('request 375026', () async {
  //   // 获取消息未读数量 登录后每10秒取一次
  //   int cmdId = 375026;
  //   var data = {
  //     'tid': 3,
  //     'cust_id': 252158,
  //   };
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: 0,
  //     headerType: 2,
  //   );
  //
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print('res data: ${res.data}');
  //   } else {
  //     if (res.data is NetworkError) {
  //       NetworkError error = res.data;
  //       error.log();
  //       if (error.logout) {
  //         //退出登录，清空现有的登录信息
  //       }
  //     }
  //   }
  // });
  //
  // test('request 370433', () async {
  //   int cmdId = 370433;
  //   const data = ['7'];
  //   int paramType = 2;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   /*
  //   {aseq_id: 7, version_code: 1, version_name: MWEB v1.0, version_digest: MWEB 客户端1.0版本, app_type: 1, state: 1, download_url: https://www.cw.pub/500caipiao, chan_code: IPhone, wappay_state: 0, filesize: 9999, collect_state: 0, update_state: 0, reg_addr: http://m.180500a.com/reg?p=6f7dbed0f07e34fe41963d86f3981bba88, share_url: https://www.baidu.com, magic_key: ibRMOe6oQ9ZZMItO, version_serial: 3337, old_version_serial: 0, last_version_serial: 0, tid: 0, renewal_content: 发送, is_mandatory_upate: 0, ios_download_url: , download_method: 1, remark: , basic_settings: , menu_management: ;;百家乐, game_management: , update_type: 0}
  //    */
  //   expect(res.data['version_name'], 'MWEB v1.0');
  // });
  //
  // test('request 371130', () async {
  //   // 通过域名地址获取租户信息
  //   int cmdId = 371130;
  //   String domainAddr = NetworkService.baseURL;
  //   var data = {
  //     'domain_addr': domainAddr,
  //     'language': '0',
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   expect(res.data['tid'], 3);
  //   if (res.data['tenant'] is Map) {
  //     Map tenant = res.data['tenant'];
  //     // online_addr 主盘在线客服地址
  //     // online_addr1 代理盘1在线客服地址
  //     // online_addr2 代理盘2在线客服地址
  //     // online_addr3 代理盘3在线客服地址
  //     print('在线客服: ${tenant['online_addr']}');
  //     print('官方网址: ${tenant['xmpp_outer']}');
  //     print('客服QQ: ${tenant['qq']}');
  //     print('客服微信: ${tenant['weixin']}');
  //     print('Whatsapp: ${tenant['whatsApp']}');
  //     print('Telegram: ${tenant['telegram']}');
  //   }
  //   //代理盘控制开关
  //   if (res.data['listShow'] is List) {
  //     List configs = res.data['listShow'];
  //     for (Map info in configs) {
  //       if (info['conf_id'] == 2054) {
  //         // 幸运大转盘
  //         print('cname: ${info['cname']}');
  //         // 是否展示
  //         print('show_mobile: ${info['show_mobile']}');
  //       }
  //     }
  //   }
  //   // if (res.data['imgs_domain'] is List) {
  //   //   final imgDomain = await reqImgsUrl(res.data['imgs_domain']);
  //   //   print('选中域名:$imgDomain');
  //   // }
  // });
  //
  // test('request 4', () async {
  //   // 登录
  //   int cmdId = 4;
  //   int tid = 3; // 租户标识
  //   String custName = '18800001000'; // 账户
  //   String password = '123456'; // 密码
  //   var data = {
  //     'app_key': '',
  //     'chan_code': 'MWEB',
  //     'client_id': 'react_client',
  //     'cust_name': custName,
  //     'domain_addr': '192.168.8.100:8992',
  //     'grant_type': 'password',
  //     'password': getP(password.trim()),
  //     'scope': 'read write',
  //     'special_problems': '',
  //     'tid': tid,
  //     'validate': '',
  //     'verifycode': '',
  //     'verifycode_key': '695bcdfd-007d-4dd3-b114-39d2a3db45b6',
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   print('res data: ${res.data}');
  //   print('access_token: ${res.data['access_token']}');
  //   print('cust_id: ${res.data['cust_id']}');
  //   print('acct_id: ${res.data['acct_id']}');
  //   print('cust_code: ${res.data['cust_code']}');
  //   print('账号: ${res.data['cust_name']}');
  //   print('昵称: ${res.data['nickname']}');
  //   print('头像: ${res.data['head']}');
  //   print('会员等级: ${res.data['cust_level']}');
  //   // expect(res.data['cust_id'], 252158); // 全局保存用户信息实体类，cust_id=252158
  //   // access_token: 493ed5e6-9dcd-48fd-b468-b9b005a42b6b
  // });
  //
  // test('request 314501', () async {
  //   // 请求第三方游戏url
  //   int cmdId = 314501;
  //   int tid = 3; // 租户标识
  //   int custId = 252158; // 用户标识
  //   var data = {
  //     'type': '120',
  //     'tid': tid,
  //     'cust_id': custId,
  //     'play_id': 1383,
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     // accessToken: '2ea3c52e-9248-418f-9419-07f42ffc8261',
  //   );
  //   print('res data: ${res.data}');
  //   // {"url":"https://gameqp.yyaky.com?token=xieN0Q2NjAxMUIyREZENzMwOEtlOUFCMEFBMDM4NjZBRkY4OTJFQ0YxREZDNDQyRDc3MjY1RTc0NjE5Q0MxMzMwNzVGMjM0QjgwQTNFRjg2QTM4RUNGNDNEMDc2QkY0RTc1M0MxQTFGNjUwNjMxRThGQzA1QkY3QkE2NDJGOENDNjBDMTA1MDAxNDY2Q0VFMTY3MTkxNUMxMkY4RTEzRTgyMjFDMjQxQzVGODdDMzBCM0NCNDcxQzBDQjRDOTQ3QzE2RkJFZhtTI&deviceType=1&pcode=ZmFsaWFuZ3Fw&t=MTIw&ma=bWFpbmxhbmQ=&g=d3NzOi8vZ2ZxcC1vay4yMTdlczBwcC5jb20vZ2F0ZS93cw==&line=d3NzOi8vZ2ZxcC1vay4yMTdlczBwcC5jb20vZ2F0ZS93cyx3c3M6Ly9nYXRld2F5MjAyMC5mdW4xMDAuc2l0ZS9nYXRlL3dz"}
  // });
  //
  // test('request 381119', () async {
  //   //获取游戏大类平台数据
  //   int cmdId = 381119;
  //   const data = {
  //     'tid': 3, // tenantInfo.value.tid
  //     'aseq': {
  //       'aseq': '7',
  //     },
  //     'version_type': {
  //       'version_type': 3, // 1 是棋牌, 2 是网赚 3, 是综合彩票
  //     },
  //     'news': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 10,
  //       'sort_flag': 1,
  //       'vip_level': 0,
  //       'proxy': 0,
  //       'apply': 8, // // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
  //       'language': 0,
  //     },
  //     'game_news': {
  //       'page_start': 1,
  //       'num_per_page': 9999,
  //       'state': 1,
  //       'message_id': 17,
  //       'sort_flag': 1,
  //       'tid': 3, // tenantInfo.value.tid
  //       'proxy': 0, // tenantInfo.value.proxy
  //       'chan_con': 0,
  //       'apply': 8,
  //       'ma_id': 10,
  //       'vip_level': 0,
  //       'type': 'MWEB', // getDeviceType: MWEB, PC, IOS, ANDROID
  //       'language': 0, // 固定传中文语言类型，游戏公告在其他语言类型下不会返回
  //     },
  //     'banners': {
  //       'page_start': 1,
  //       'num_per_page': 999,
  //       'chan_con': 8,
  //       'state': 1,
  //       'message_id': 12,
  //       'sort_flag': 1,
  //       'proxy': 0,
  //       'apply': 8,
  //       'language': 0,
  //     },
  //     'homeHotGames': {
  //       'cust_id': '0', // userInfo.value.cust_id || '0'
  //     },
  //     'proxyConfig': {
  //       'proxy': 0,
  //     },
  //     'hotGames': {
  //       'size': 12,
  //     },
  //   };
  //   int paramType = 1;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     isApiV2: true,
  //     data: data,
  //     paramType: paramType,
  //     headerType: 1,
  //   );
  //   // print('res data: ${res.data}');
  //   expect(res.data['aseq']['aseq_id'], 7);
  //
  //   // 存在假PG的时候不显示真pg 假PG=1382,真PG=1380
  //   var hasFakePG = false;
  //   if (res.data['thirdGames'] is List) {
  //     List thirdGames = res.data['thirdGames'];
  //     hasFakePG = thirdGames.any((game) => game['play_id'] == 1382);
  //   }
  //   if (res.data['homeHotGames'] is Map) {
  //     Map homeHotGames = res.data['homeHotGames'];
  //     List fixedHotGames = [];
  //     if (homeHotGames['1'] is List) {
  //       fixedHotGames.addAll(homeHotGames['1']);
  //     }
  //     if (homeHotGames['6'] is List) {
  //       // 原创游戏
  //       fixedHotGames.addAll(homeHotGames['6']);
  //     }
  //     if (homeHotGames['7'] is List) {
  //       // 哈希游戏
  //       fixedHotGames.addAll(homeHotGames['7']);
  //     }
  //     if (hasFakePG) {
  //       fixedHotGames.removeWhere((game) => game['upper_play_id'] == 1380);
  //     }
  //     // print('fixedHotGames: ${fixedHotGames.length}');
  //     fixedHotGames.removeWhere((game) =>
  //         game['state'] == 3 || game['play_id'] == game['upper_play_id']);
  //     fixedHotGames.sort((a, b) {
  //       int topDiff = b['is_top'] - a['is_top'];
  //       int hotDiff = b['hot_val'] - a['hot_val'];
  //       if (topDiff == 0) {
  //         // 如果 is_top 相同，则按 hot_val 排序
  //         if (hotDiff == 0) {
  //           // 如果 hot_val 也相同，则按 sub_play_id 或 play_id 排序
  //           return (b['sub_play_id'] ?? b['play_id']) -
  //               (a['sub_play_id'] ?? a['play_id']);
  //         } else {
  //           return hotDiff;
  //         }
  //       } else {
  //         return topDiff;
  //       }
  //     });
  //
  //     // 从返回的租户信息中获取 enantInfo.imgs_domain[0].domain_addr
  //     String imgDomain = 'https://image2.typay2.com';
  //     String lang = 'cn'; // 本地语言，支持 en, cn
  //     String str = 'qipai';
  //     String imgUrl = '';
  //     final glGgame = Game3Config.gameArr['glg'] ?? [];
  //     final glDZGgame = Game3Config.gameArr['dz'] ?? [];
  //     final qipai = Game3Config.gameArr['qipai'] ?? [];
  //     final videoArr = Game3Config.gameArr['video'] ?? [];
  //     final tiyuArr = Game3Config.gameArr['tiyu'] ?? [];
  //     for (var game in fixedHotGames) {
  //       bool lotteryTicket = false;
  //       int category = GameUtils.getGameCategory(game['upper_play_id']);
  //       if (category == 4) {
  //         // caipai
  //         //     let play = config.getPlayInfo(item.play_id);
  //         // if (play) {
  //         //   imgUrl =
  //         //     imgDomain.value + 'staticQ/caipiao/default/' + lang + '/icon_play_' + (play.icon !== undefined ? (item.play_cat === 4 && play.base ? play.base + '_XY' : play.icon) : play.id) + '.png';
  //         // }
  //         lotteryTicket = true;
  //       } else if (category == 3) {
  //         // 捕鱼
  //         imgUrl =
  //             '$imgDomain/staticQ/buyu/${game['upper_play_id']}/$lang/game_${game['play_id']}.png';
  //       } else if (category == 6) {
  //         // 真人视讯
  //         imgUrl =
  //             '$imgDomain/staticQ/caipiao/default/$lang/icon_play_${game['play_id']}.png';
  //       } else if (category == 2) {
  //         // 电子
  //         if (game['upper_play_id'] == 340) {
  //           imgUrl =
  //               '$imgDomain/staticQ/dianzi/${game['upper_play_id']}/$lang/game_${game['play_name']}.png';
  //         } else {
  //           imgUrl =
  //               '$imgDomain/staticQ/dianzi/${game['upper_play_id']}/$lang/game_${game['play_id']}.png';
  //         }
  //       } else {
  //         switch (category) {
  //           case 1:
  //             str = 'qipai';
  //             break;
  //           case 5:
  //             str = 'tiyu';
  //             break;
  //           case 7:
  //             str = 'hongbao';
  //             break;
  //           case 8:
  //             str = 'caipiao';
  //             break;
  //         }
  //         imgUrl =
  //             '$imgDomain/staticQ/$str/${game['upper_play_id']}/game_${game['upper_play_id'] == 340 ? game['play_name'] : game['play_id']}.png';
  //
  //         str = 'qipai';
  //         if (glGgame.contains(ensureInt(game['upper_play_id']))) {
  //           if (glDZGgame.contains(ensureInt(game['upper_play_id']))) {
  //             str = 'dianzi';
  //           }
  //           imgUrl =
  //               '$imgDomain/staticQ/$str/${game['upper_play_id']}/$lang/game_${game['upper_play_id'] == 340 ? game['play_name'] : game['play_id']}.png';
  //         }
  //       }
  //
  //       if ((game['upper_play_id'] == 504) ||
  //           (game['upper_play_id'] == 506 && game['play_id'] != 506) ||
  //           (ensureInt(game['upper_play_id']) == 745)) {
  //         imgUrl =
  //             '$imgDomain/staticQ/${game['upper_play_id'] == 504 ? 'caipiao' : 'qipai'}/${game['upper_play_id']}/$lang/game_${game['play_id']}.png';
  //       }
  //
  //       if (game['upper_play_id'] == 468) {
  //         imgUrl = '$imgDomain/staticQ/caipiao/468/game_${game['play_id']}.png';
  //       } else if (ensureInt(game['upper_play_id']) == 750) {
  //         imgUrl =
  //             '$imgDomain/staticQ/caipiao/default/$lang/icon_play_${game['play_id']}.png';
  //       }
  //       if (glDZGgame.contains(ensureInt(game['upper_play_id']))) {
  //         imgUrl =
  //             '$imgDomain/staticQ/dianzi/${game['upper_play_id']}/$lang/game_${game['upper_play_id'] == 340 ? game['play_name'] : game['play_id']}.png';
  //       }
  //       if (videoArr.contains(ensureInt(game['upper_play_id'])) ||
  //           tiyuArr.contains(ensureInt(game['upper_play_id']))) {
  //         imgUrl =
  //             '$imgDomain/staticQ/caipiao/default/$lang/icon_play_${game['play_id']}.png';
  //       }
  //       if (qipai.contains(ensureInt(game['upper_play_id']))) {
  //         imgUrl =
  //             '$imgDomain/staticQ/qipai/${game['upper_play_id']}/$lang/game_${game['upper_play_id'] == 340 ? game['play_name'] : game['play_id']}.png';
  //       }
  //       game['gameImgUrl'] = imgUrl;
  //     }
  //
  //     expect(fixedHotGames[0]['gameImgUrl'],
  //         'https://image2.typay2.com/staticQ/qipai/1383/cn/game_1383019.png');
  //   }
  // });
  //
  // test('request 380238', () async {
  //   int cmdId = 380238;
  //   var data = {
  //     'tid': 3,
  //     'proxy': 0,
  //     'cat': 'KA电子',
  //     'apply': 3,
  //     'chan_con': 'MWEB',
  //     'type': 'MWEB',
  //     'language': 0,
  //   };
  //   int paramType = 0;
  //   final res = await NetworkService.request(
  //     cmdId,
  //     data: data,
  //     paramType: paramType,
  //   );
  //   print('res data: ${res.data}');
  // });
  // 测试新版充值渠道
  test('request 3101392', () async {
    int cmdId = 3101392;
    var data = {
      'tid': 3,
      'cust_id': 34,
    };
    NetworkService ns = NetworkService();
    ns.setBaseURL('http://51zhh5.wc9003.com');
    final res = await ns.request(
      cmdId,
      data: data,
    );
  });

  //首页排行榜
  // test('request 341533', () async {
  //   int cmdId = 341533;
  //   var data = {
  //     'tid': 3,
  //   };
  //   // var data = [3];
  //   final res =
  //       await NetworkService().request(cmdId, data: data, headerType: 2);
  //   print("输出一下：${res.data}");
  // });
  //首页排行榜
  // test('request 321552', () async {
  //   int cmdId = 321552;
  //     NetworkService ns = NetworkService();
  //     ns.setBaseURL('https://51zhh5.lg0808.com');
  //   var data = {
  //     'tid': 3,
  //   };
  //   final res =
  //       await ns.request(cmdId, data: data, headerType: 2);
  //   print("输出一下：${res.data}");
  // });
  // 首页排行榜
  // test('request 724300', () async {
  //   int cmdId = 724300;
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://test456.oossc360.icu');
  //   var data = {
  //     'tid': 3,
  //   };
  //   final res = await ns.request(cmdId, data: data, headerType: 2);
  //   print("输出一下：${res.data}");
  // });
  // 个人中心banner
  // test('request 380232', () async {
  //   int cmdId = 380232;
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://51zhh5.lg0808.com');
  //   var data = {
  //     'tid': 3,
  //     'state': 1,
  //     'message_id': 12,
  //     'page_start': 1,
  //     'num_per_page': 999,
  //     'proxy': 0,
  //     'sort_flag': 1,
  //     'type': "ANDROID",
  //     'apply': 8,
  //     'language': 22,
  //   };
  //   final res = await ns.request(cmdId, data: data, headerType: 2);
  //   // print("输出一下：${res.data}");
  // });
  //首页活动列表
  // test('request 7242042', () async {
  //   int cmdId = 7242042;
  //   NetworkService ns = NetworkService();
  //   ns.setBaseURL('https://test456.oossc360.icu');
  //   var data = {
  //     'tid': 3,
  //   };
  //   final res = await ns.request(cmdId, data: data);
  //   print("输出一下首页活动列表：${res.data}");
  // });
  //   首页活动列表
  test('request 3109013', () async {
    int cmdId = 3109013;
    NetworkService ns = NetworkService();
    ns.setBaseURL('https://test456.oossc360.icu');
    var data = {
      'tid': 3,
      'page_start': 1,
      'num_per_page': 20,
    };
    // var data = {
    //   'game_type': 100,
    //   'sgame_type': 203,
    //   'tid': 3,
    // };
    final res = await ns.request(cmdId, data: data, headerType: 1);
    // print("输出一下11：${res.data}");
  });
}
