import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/InboxMsgItemBean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/bet_list_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/funding_details_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/game_balance_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/inbox_detail_msg_item_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/personal_statement_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/system_notify_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/user_bank_info_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/vip_info_bean.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/kernel/utils/bet_history_config.dart';
import 'package:flutter_tiyu_app/kernel/utils/game_utils.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../app/modules/activity/data/activity_bean.dart';
import '../app/modules/user/data/alternate_urls_bean.dart';
import '../app/modules/user/data/lucky_wheel_bean.dart';
import '../app/modules/user/data/my_message_bean.dart';
import '../app/modules/user/data/user_info_bean2.dart';
import '../app/modules/wallet/data/dw_records_bean.dart';
import '../app/modules/wallet/data/withdraw_type_bean.dart';
import '../kernel/configs/app_configs.dart';
import '../kernel/network/error.dart';
import '../kernel/network/helper.dart';
import '../kernel/network/service.dart';
import '../kernel/utils/app_utils.dart';
import '../utils/date_time_utils.dart';

class UserApi {
  //请求资金明细数据
  static Future<List<FundingData>> reqFundingDetailsData(
      {required List<int> reqType,
      required int time,
      required int page}) async {
    List<FundingData> fundingList = [];
    // dynamic trans_type = 0; // 全部
    // dynamic busi_type = 0; // 全部
    // trans_type = ['17']; // 活动礼金
    // busi_type = ['402']; // 注册奖金

    int cmdId = 340333;
    // 测试账号 13412341235 //注意是acct_id，不是cust_id，
// 测试时需要修改service.dart中的accessToken, tid, Custid

    // int start_time = 1722470400 * 1000; // 2024-07-01，时间戳，毫秒
    // int end_time = startTime + (90 * 86400000 - 1000); // 90天
    //通过传递过来的day，来获取实际的开始和结束时间
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(time); //这里传入具体的天数，当天：0，多少天前，就传多少天
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'acct_id': LoginManager.instance.loginInfo?.acctId,
      'trans_type': reqType, //trans_type,
      // 'busi_type': reqType, //busi_type,
      'marking_quantity': 0,
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
      'page_start': page,
      'num_per_page': 10,
    };
    // 查询全部记录时不要传trans_type, busi_type
    // if (reqType == 0) {
    //   data.remove('trans_type');
    //   data.remove('busi_type');
    // }
    // print('请求资金明细数据: $data');
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 2,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      FundingDetailsBean fundingDetailsBean =
          FundingDetailsBean.fromJson(res.data);
      fundingList = fundingDetailsBean.data ?? [];
      if (fundingList.isNotEmpty) {
        for (var item in fundingList) {
          // print('输出item: ${item.toString()}');
          // print('trans_type: ${item.transType}');
          // print('busi_type: ${item.busiType}');
          // print('备注: ${item.remark}');
          // print('stat_msg: ${item.statMsg}');
          // print('交易流水: ${item.transSerial}');
          // print('原交易流水: ${item.origTransSerial}');
          // print('交易类型: ${item.transType}');
          // print('发生金币: ${item.genAmount ?? 0 / 1000}');
          // print('交易金币: ${item.totalAmount ?? 0 / 1000}');
          // print('操作后余额: ${item.balance ?? 0 / 1000}');
          // print('操作后冻结余额: ${item.freezeBalance}');
          // print('发生打码量: ${item.genMarking ?? 0 / 1000}');
          // print('操作后打码量: ${item.markingQuantity ?? 0 / 1000}');
          // print('-----');
        }
      }
    }
    return fundingList;
  }

  // 修改昵称
  Future<bool> changeNickName(String newNickName) async {
    int cmdId = 310113;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'nickname': newNickName,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  Future<UserInfoBean2?> reqUserInfo() async {
    int cmdId = 310230;
    int tid = TenantManager.instance.tenantBean?.tid ?? 3;
    int custId = LoginManager.instance.loginInfo?.custId ?? 0;
    var data = [tid, custId];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
    );
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      return UserInfoBean2.fromJson(res.data);
    }
    return null;
  }

  // 修改真实姓名
  Future<dynamic> changeRealName(String newRealName) async {
    int cmdId = 310211;
    // 修改联系方式 真实姓名
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'mark': 1,
      'contact_name': newRealName,
      'contact_addr': '',
      'email': '',
      'facebook': '',
      'qq': '',
      'telegram': '',
      'weixin': '',
      'whatsApp': '',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    return res;
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    } else {
      if (res.data is NetworkError) {
        NetworkError error = res.data;
        Get.snackbar("123", "${error.info}");
        print('error222: ${error.info}');
        return false;
      }
    }
    return false;
  }

// 修改联系方式
  Future<bool> changePhone(String newPhone) async {
    int cmdId = 310211;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'mark': 1,
      'contact_addr': '',
      'email': '',
      'facebook': '',
      'mobile_phone': newPhone,
      'qq': '',
      'telegram': '',
      'weixin': '',
      'whatsApp': '',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    } else {
      if (res.data is NetworkError) {
        NetworkError error = res.data;
        print('error: ${error.info}');
        return false;
      }
    }
    return false;
  }

// 修改性别 1:男 2:女
  Future<bool> changeGender(int sex, String? contactName) async {
    int cmdId = 310211;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'mark': 1,
      'contact_name': contactName,
      'contact_addr': '',
      'email': '',
      'facebook': '',
      'qq': '',
      'telegram': '',
      'weixin': '',
      'whatsApp': '',
      'gender': sex,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    } else {
      if (res.data is NetworkError) {
        NetworkError error = res.data;
        print('error: ${error.info}');
        return false;
      }
    }
    return false;
  }

  // 修改登录密码
  Future<bool> changeLoginPwd(String oldPwd, String newPwd, bool hasPwd) async {
    int cmdId = 31011101;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_code': LoginManager.instance.loginInfo?.custCode,
      'ispwd': -1,
      'password': getP(newPwd),
      'ori_password': hasPwd ? getP(oldPwd) : "",
    };

    final res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    print("修改登录密码传参：${data}   响应：${res.data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //请求大转盘数据
  Future<LuckyWheelBean?> reqWheelData() async {
    // 大转盘查询奖品列表
    int cmdId = 322957;
    var data = {
      'tId': TenantManager.instance.tenantBean?.tid,
    };
    int paramType = 0;
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: paramType,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      LuckyWheelBean luckyWheelBean = LuckyWheelBean.fromJson(res.data);
      for (var item in luckyWheelBean.luckyBigWheelSys!) {
        print("我是分割线--------------");
        for (var item2 in item.luckyBigWheeDetails!) {
          print("这是大转盘每个条目的数据：${item2.toString()}");
        }
      }
      // print('\t奖品名字:${prize['name']}');
      // print('\t奖品价值:${prize['prize'] / 1000}');
      // print('\t奖品图片:${prize['img_url']}');
      // print('\t-----');
      return luckyWheelBean;
    }
    return null;
  }

  //大转盘抽奖
  Future<LuckySelectBean?> startWheel(int sysId) async {
    //抽奖钱，判断一下选中的积分选项和剩余的积分是否满足扣除需求，如果不满足，弹出积分不足弹窗，如果满足，再执行请求
    int cmdId = 322962;
    var data = {
      'tid': AppConfigs.tid,
      'custId': LoginManager.instance.loginInfo?.custId,
      'sysId': sysId,
    };
    int paramType = 0;
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: paramType,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      return LuckySelectBean.fromJson(res.data);
    }
    return null;
  }

  //查询大转盘积分
  Future<LuckyPointsBean?> checkWheelPoints() async {
    // 积分查询
    // 测试时需要修改service.dart中的accessToken, tid, Custid
    int cmdId = 322961;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'custId': LoginManager.instance.loginInfo?.custId,
    };
    int paramType = 0;
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: paramType,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      return LuckyPointsBean.fromJson(res.data);
    }
    return null;
  }

  //请求备用网址
  Future<AlternateUrlsBean?> reqAlternateURLs() async {
    // 获取备用网址
    int cmdId = 371137;
    var data = {
      'tid': AppConfigs.tid,
      'state': 1,
      'proxy': 0, // tenantInfo.value.proxy
      'chan_code': AppConfigs.chanCode,
      'page_start': 1,
      'num_per_page': 1000,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print("res22:${res.data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      return AlternateUrlsBean.fromJson(res.data);
    }
    return null;
  }

  //收件箱
  Future<List<InboxMsgItemBean>> reqInboxMsg() async {
    List<InboxMsgItemBean> tempList = [];
    // 站内信 收件箱
    int cmdId = 375012;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'data_type': 0
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (Map mail in res.data) {
          tempList.add(InboxMsgItemBean.fromJson(mail));
        }
      }
    }
    return tempList;
  }

  Future<NetworkResponse> reqFeedbackNumber() async {
    // 站内信 收件箱
    int cmdId = 375032;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    return res;
  }

  //系统公告
  Future<SystemNotifyBean?> reqSystemMsg() async {
    // 站内信 系统公告
    int cmdId = 380232;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'proxy': 0, // tenantInfo.value.proxy
      'vip_level': 1, // userInfo.value.cust_level || 0
      'type': 'MWEB',
      'language': 0, // languageNum, cn: 0, en: 1,
      'sort_flag': 1,
      'state': 1,
      'chan_con': 8,
      'apply': 8,
      'message_id': 10,
      'page_start': 1,
      'num_per_page': 15,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      return SystemNotifyBean.fromJson(res.data);
    }
    return null;
  }

  //发送问题反馈
  Future<bool> sendFeedback(String content) async {
    int cmdId = 375017;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'theme': '问题反馈',
      'from_user': LoginManager.instance.loginInfo?.custName,
      'data_type': 7,
      'content': content,
      'addresseeName': 'system',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //发送问题反馈
  Future<bool> replyToFeedback(int mail_id, String content) async {
    int cmdId = 375025;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'mail_id': mail_id,
      'reply_content': content,
      'reply_type': 2,
      'send_cust_name': LoginManager.instance.loginInfo?.nickname,
      'put_cust_name': "system",
    };
    print('res data: ${data}');
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  /// 意见反馈列表
  static Future<NetworkResponse> reqFeedbackList() async {
    const cmdId = 375012;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'data_type': 7,
    };
    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> receiveFeedbackGiftAmount() async {
    const cmdId = 375033;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
    };
    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 反馈详情
  static Future<NetworkResponse> reqFeedbackDetail(
      num mail_id, String put_cust_name, String send_cust_name) async {
    const cmdId = 375031;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'mail_id': mail_id,
      'put_cust_name': put_cust_name,
      'send_cust_name': send_cust_name
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> reqFeedbackDetailReceive(
      num mail_id, num reply_id) async {
    const cmdId = 390208;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'mail_id': mail_id,
      'reply_id': reply_id,
    };
    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  //我的消息
  Future<MyMessageBean?> reqMyMsg() async {
    int cmdId = 380336;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int beginTime = timestamp - 30 * 24 * 3600 * 1000;
    int endTime = timestamp + 2 * 24 * 3600 * 1000;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'receivor_id': LoginManager.instance.loginInfo?.custId,
      'receivor_type': 1,
      'message_id': 30,
      'page_start': 1,
      'num_per_page': 10,
      'begin_time': beginTime,
      'end_time': endTime,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      return MyMessageBean.fromJson(res.data);
    }
    return null;
  }

  //请求账户银行卡列表
  Future<List<UserBankInfoBean>> reqAccountBankTabList() async {
    // List<Map<String, dynamic>> tempList = [];
    List<UserBankInfoBean> tempList = [];
    // 用户的默认银行卡信息 用来生产提现方式列表
    // 测试时需要修改service.dart中的accessToken, tid, Custid
    int cmdId = 310435;
    int tid = TenantManager.instance.tenantBean!.tid;
    int custId = LoginManager.instance.loginInfo!.custId;
    var data = [tid, custId];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      paramType: 2,
    );
    if (res.data is List) {
      for (var item in res.data) {
        tempList.add(UserBankInfoBean.fromJson(item));
      }
    }
    return tempList;
  }

  //请求账户银行卡列表
  Future<List<WithdrawBindCardItemBean>> reqAccountBankList() async {
    // 返回用户钱包地址
    // 测试时需要修改service.dart中的accessToken, tid, Custid
    List<WithdrawBindCardItemBean> tempList = [];
    int cmdId = 310430;
    var data = [
      TenantManager.instance.tenantBean!.tid,
      LoginManager.instance.loginInfo!.custId,
      1,
      20,
    ];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      paramType: 2,
      headerType: 2,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      final data = WithdrawBindCardBean.fromJson(res.data);

      // 含有数据
      if (data.count! > 0) {
        tempList = data.data!; // 更新提现账户列表
      }
    }
    return tempList;
  }

  //设置默认银行卡
  Future<bool> setDefaultBank(int itemId) async {
    // 设定默认银行卡
    int cmdId = 310412;
    var data = [
      AppConfigs.tid,
      itemId,
      LoginManager.instance.loginInfo!.custId
    ];
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
    );
    print("设置默认银行卡：${res.data}  请求参数：${data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }

    return false;
  }

  //站内信 收件箱回复列表
  Future<List<InboxDetailMsgItemBean>> getInboxDetailList(
      {required int mail_id,
      required String send_cust_name,
      required String put_cust_name}) async {
    // 站内信 收件箱回复列表
    List<InboxDetailMsgItemBean> tempList = [];
    int cmdId = 375023;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'mail_id': mail_id,
      'send_cust_name': send_cust_name,
      'put_cust_name': put_cust_name,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (var item in res.data) {
          tempList.add(InboxDetailMsgItemBean.fromJson(item));
        }
        // List replies = res.data;
        // DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
        // for (Map reply in replies) {
        //   print('cust_name: ${reply['cust_name']}');
        //   print('reply_content: ${reply['reply_content']}');
        //   DateTime date =
        //       DateTime.fromMillisecondsSinceEpoch(reply['send_time']);
        //   print('send_time: ${formatter.format(date)}');
        //   print('-----');
        // }
      }
    }
    return tempList;
  }

  //回复收件箱信息
  Future<bool> sendMsg(
      {required int mail_id,
      required String send_cust_name,
      required String put_cust_name,
      required String content}) async {
    // 站内信 回复收件箱信息
    int cmdId = 375018;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'mail_id': mail_id,
      'send_cust_name': send_cust_name, // 来自接口 375010
      'put_cust_name': put_cust_name, // 来自接口 375010
      'reply_content': content,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //我的消息 - 单个删除或者已读
  Future<bool> readOrDeleteMsg({
    required int message_inst_id,
    required int part_mon,
    required int state,
  }) async {
    // 站内信 设置我的消息 单个已读/删除
    int cmdId = 380335;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'state': state, // 9:已读 100:删除
      'message_inst_id': message_inst_id, // 列表接口返回
      'part_mon': part_mon, // 列表接口返回
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //我的消息 - 一键已读
  Future<bool> readAllMyMsg() async {
    // 站内信 设置我的消息 批量已读/删除
    int cmdId = 380334;
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    int beginTime = timestamp - 30 * 24 * 3600 * 1000;
    int endTime = timestamp + 2 * 24 * 3600 * 1000;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'state': 9, // 9:已读 100:删除
      'receivor_id':
          LoginManager.instance.loginInfo!.custId, // userInfo.value.cust_id
      'receivor_type': 1, // 固定
      'message_id': 30, // 固定
      'begin_time': beginTime,
      'end_time': endTime,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //收件箱 - 已读或者删除单个
  Future<bool> deleteInBoxMsg(
      {required int mail_id,
      required String put_cust_name,
      required String send_cust_name}) async {
    // 设置收件箱信息状态 删除
    int cmdId = 375011;
    // 单个已读/删除
    var data1 = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'isAll': 'false', // 是否批量
      'type': 2, // 2:删除 1:已读
      'mail_id': mail_id,
      'put_cust_name': put_cust_name,
      'send_cust_name': send_cust_name,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data1,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //收件箱 - 一键已读
  Future<bool> readAllInBoxMsg() async {
    // 设置收件箱信息状态 删除
    int cmdId = 375011;
    // 批量已读/删除
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'isAll': 'true', // 是否批量
      'type': 1, // 2:删除 1:已读
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //获取vip晋级模式列表信息,并携带领取状态
  Future<dynamic> reqVipInfo() async {
    // 获取vip晋级模式列表信息,并携带领取状态
    // int cmdId = 374031;
    int cmdId = 3740312; // 和 Willie沟通，确认接口修改为 3740312 ！！！
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id':
          LoginManager.instance.loginInfo?.custId, // userInfo.value.cust_id
      'cust_name':
          LoginManager.instance.loginInfo?.custName, // userInfo.value.cust_name
      'level': LoginManager
          .instance.loginInfo?.custLevel, // userInfo.value.cust_level
      'state': 1,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print("获取vip晋级模式列表信息请求参数：$data");
    // print("获取vip晋级模式列表信息请求参数响应数据：${res}");
    if (ThemeService.to.currentTheme.value?.model == 'blackGold') {
        return res;
    } else {
      if (res.type == NetworkService.networkTypeSuccess) {
        return VipInfoBean.fromJson(res.data);
      }
    }
    return null;
  }

  //获取vip晋级模式列表信息
  Future<VipInfoBean?> reqVipList() async {
    // 获取vip晋级模式列表信息,并携带领取状态
    int cmdId = 374030;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      // 'cust_id':
      //     LoginManager.instance.loginInfo?.custId, // userInfo.value.cust_id
      // 'cust_name':
      //     LoginManager.instance.loginInfo?.custName, // userInfo.value.cust_name
      // 'level': LoginManager
      //     .instance.loginInfo?.custLevel, // userInfo.value.cust_level
      'state': 1,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      return VipInfoBean.fromJson(res.data);
    }
    return null;
  }

  //vip奖励领取
  Future<bool> reqReceiveVipReward() async {
    int cmdId = 3740012;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
    };

    final res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      return true;
    }
    return false;
  }

  //vip规则
  Future<String?> reqVipRule() async {
    int cmdId = 370730;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'option_code': 'VIP_ACTIVITY_RULE_CONFIG'
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      final htmlContent = res.data['value'];
      return htmlContent;
    }
    return null;
  }

  //vip奖励领取， 按类型领取
  Future<bool> reqGetVipRewardByType({
    required int receiveType,
    required double amount,
    int? level,
  }) async {
    int cmdId = 374001;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'receive_type': receiveType,
      'amount': amount,
      'level': level ?? LoginManager.instance.loginInfo?.custLevel,
    };

    final res = await NetworkService().request(
      cmdId,
      data: data,
    );

    if (res.type == NetworkService.networkTypeSuccess) {
      return true;
    }

    return false;
  }

  //一键找回
  Future<bool> findMoney() async {
    int cmdId = 391138;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'type': 1,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //一键找回 更改之后的接口
  Future<bool> findMoney2(String playIds) async {
    int cmdId = 3911381;
    Map<String, dynamic> data = {};
    if (playIds.isEmpty) {
      data = {
        'tid': TenantManager.instance.tenantBean?.tid,
        'cust_id': LoginManager.instance.loginInfo?.custId,
        'type': 1,
      };
    } else {
      if (playIds.contains(',')) {
        data = {
          'tid': TenantManager.instance.tenantBean?.tid,
          'cust_id': LoginManager.instance.loginInfo?.custId,
          'type': 3,
          'play_id': playIds,
        };
      } else {
        data = {
          'tid': TenantManager.instance.tenantBean?.tid,
          'cust_id': LoginManager.instance.loginInfo?.custId,
          'type': 1,
          'play_id': playIds,
        };
      }
    }
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('cmdId:$cmdId, data:$data');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //请求游戏余额列表
  Future<List<GameBalanceBean>> reqGameBalanceList() async {
    List<GameBalanceBean> tempList = [];
    int cmdId = 391137;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'data_type': 1,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // 一分钟只能刷新一次
    print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // print("data:${jsonEncode(res.data)}");
      if (res.data is List) {
        for (var info in res.data) {
          tempList.add(GameBalanceBean.fromJson(info));
          // int playId = info['play_id'];
          // String? name = info['play_name'];
          // int total = info['total'];
          // int lower = info['lower'];
          // int isKickout = info['is_kickout'];
          // print('$playId, $name, $total, $lower, $isKickout');
        }
      }
    } else {
      Get.snackbar("刷新页面失败", "${res.data}");
    }
    return tempList;
  }

  //请求投注列表
  Future<BetResponseBean> reqBetList({
    required int typeId,
    required int platform,
    required int time,
    required int page,
    required int pageSize,
  }) async {
    List<BetItem> tempList = [];
    bool hasMore = false;

    // 获取投注记录列表信息
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(time); //这里传入具体的天数，当天：0，多少天前，就传多少天
    // print("开始时间：${DateTimeUtils.formatTimestamp(dayRange["startTime"]!)}  结束时间：${DateTimeUtils.formatTimestamp(dayRange["endTime"]!)}");
    int cmdId = 314502;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'type_id': typeId, // 电子投注
      // 'platform': platform, // PG
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
      'page_start': page,
      'num_per_page': pageSize,
      'api_type': 2,
    };

    if (platform != 0) {
      data['platform'] = platform;
    }

    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('数据: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['data'] is List) {
        // 总数
        int count = res.data['count'] ?? 0;
        hasMore = count > page * pageSize;

        for (var item in res.data['data']) {
          Map<String, dynamic>? play =
              GameUtils.getPlayInfo('${item['play_type_id']}');
          String playTypeId =
              play != null ? play['play_cname'] : "${item['play_type_id']}";

          var historyData =
              BetHistoryConfig.formatValue(playTypeId: playTypeId, item: item);

          var platformOrderId2 = historyData['platformOrderId'] != ''
              ? historyData['platformOrderId']
              : item['platform_order_id'];

          item['game_type_id'] = historyData['gameTypeId'] != ''
              ? historyData['gameTypeId']
              : item['game_type_id'];
          item['platform_order_id'] = platformOrderId2;
          item['play_type_id'] = playTypeId;

          tempList.add(BetItem.fromJson(item));
        }
      }
    }

    return BetResponseBean(hasMore: hasMore, list: tempList);
  }

//请求个人报表列表
  Future<List<PersonalStatementItemBean>> reqPersonalStatementList({
    required int gameTypeId,
    required int gameStudioId,
    required int time,
    int sort = 0,
  }) async {
    List<PersonalStatementItemBean> tempList = [];
    // 获取投注记录列表信息
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(time); //这里传入具体的天数，当天：0，多少天前，就传多少天

    int cmdId = 3809567;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'game_type_id': gameTypeId == 0 ? "" : gameTypeId, // 电子投注
      'game_studio_id': gameStudioId == 0 ? "" : gameStudioId,
      'sort': sort, //0或者不传是默认顺序，1：倒序，2：正序
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
    };
    print("请求参数：$data");
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      PersonalStatementBean tempItem = PersonalStatementBean.fromJson(res.data);
      if (tempItem.data != null) {
        tempList.addAll(tempItem.data!);
      }
    }
    return tempList;
  }

  //发送绑定手机号的验证码
  Future<void> sendBindPhoneCode(String phone) async {
    int cmdId = 10;
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'client_id': 'react_client',
      'grant_type': 'password',
      'scope': 'read write',
      'type': 5,
      // 目前设置的 +86
      'country': "China",
      'verifycode': "",
      'receive_mobile': phone,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    // print("发送验证码：${res.data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {}
    }
  }

  //绑定手机号-验证码方式
  Future<bool> bindPhoneByCode(Map<String, dynamic> params) async {
    final commonData = await getCMData();
    int cmdId = 17;
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_name': LoginManager.instance.loginInfo?.custName,
      'oper_id': LoginManager.instance.loginInfo?.custId,
      ...params,
      ...commonData,
    };

    try {
      final res = await NetworkService().request(
        cmdId,
        data: data,
        headerType: 2,
        paramType: 0,
        logError: true,
      );

      // print("绑定手机号传参：${data}   响应：${res.data}");
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['response_code'] == '9999') {
          return true;
        }
      }
    } catch (e) {
      print("e:$e");
    }
    return false;
  }

  //设置头像
  Future<bool> setHeader(String url) async {
    int cmdId = 310114;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'head': url,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //获取平台简介
  Future<String> getPlatformIntroduction() async {
    var str = "";
    int cmdId = 324463;
    var data = {
      'tid': AppConfigs.tid,
      'type': 6,
      'language': 0,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is Map) {
        str = res.data['about_us'];
        // print('平台简介: ${res.data['about_us']}');
        // print('常见问题: ${res.data['rule_introduction']}');
        // print('注册协议: ${res.data['company_cooperation']}');
      }
    }
    return str;
  }

  //检查用户的密码状态
  Future<bool> checkPwdStatus(int type) async {
    int cmdId = 310160;
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'type': type, //1：登录密码，2：支付密码
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    return res.data == 1; //1不为空 否则为空
  }

  Future<List<ActivityListItemBean>> reqBanner({bool isHome = false}) async {
    int cmdId = 380232;
    List<ActivityListItemBean> tempList = [];
    var data = {
      'tid': AppConfigs.tid,
      'state': 1,
      'message_id': 12,
      'page_start': 1,
      'num_per_page': 999,
      'proxy': 0,
      'sort_flag': 1,
      'type': Platform.isAndroid ? "ANDROID" : "IOS",
      'apply': 8,
      'language': 0,
      'location': isHome ? "1" : "2",
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
      if (res.data['data'] is List && res.data['data'] != null) {
        for (var item in res.data['data']) {
          tempList.add(ActivityListItemBean.fromJson(item));
        }
      }

      return tempList;
    }
    return [];
  }

  Future<NetworkResponse> reqMarqueeList() async {
    int cmdId = 380232;
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'vip_level': LoginManager.instance.loginInfo?.vipFlag,
      'state': 1,
      'message_id': 13,
      'page_start': 1,
      'num_per_page': 10,
      'proxy': 0,
      'sort_flag': 1,
      'type': 'MWEB',
      'apply': 8,
      'chan_con': 8,
      'language': 0,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    // final res = await NetworkService().request(
    //   cmdId,
    //   data: data,
    // );
    // print("检查密码状态请求参数：${data}  响应参数：${res.data}");
    // return res.data == 1; //1不为空 否则为空
  }

  //设置生日
  Future<NetworkResponse> setBirthDay(String birthday) async {
    int cmdId = 3310051;
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'birthday': birthday,
    };
    var res = await NetworkService()
        .request(cmdId, data: data, paramType: 1, headerType: 2);
    print("输出一下结果:${res}  请求参数:${data}");
    return res;
  }

  // 共用的 日志统计 接口配置
  static Future<Map<String, dynamic>> getCMData() async {
    final deviceId = await getDeviceId();
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String osName = '';
    String version = '';
    String devicePlatform = '';
    String deviceModel = '';
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      version = iosInfo.systemVersion;
      osName = 'iOS';
      devicePlatform = iosInfo.name;
      deviceModel = iosInfo.model;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
      version = androidInfo.version.sdkInt.toString();
      osName = 'Android';
      devicePlatform = androidInfo.brand;
      deviceModel = androidInfo.model;
    }
    return {
      'oper_code': LoginManager.instance.loginInfo?.custId,
      'oper_name': LoginManager.instance.loginInfo?.custName,
      'oper_class_type': 2,
      'oper_source_type': 2,
      'client_type': getBetPlatform3(),
      'browser_brand': 'APP',
      'os_name': osName,
      'os_version': version,
      'device_platform': devicePlatform,
      'device_model': deviceModel,
      'device_number': deviceId,
      'device_fingerprint': '',
    };
  }

  // 修改联系人 新接口
  Future<NetworkResponse> setContactMessage(Map<String, dynamic> params) async {
    final commonData = await getCMData();
    int cmdId = 3310052;
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_name': LoginManager.instance.loginInfo?.custName,
      'mark': 1,
      ...params,
      ...commonData,
    };
    var res = await NetworkService()
        .request(cmdId, data: data, paramType: 1, headerType: 2);
    // print("输出一下结果:${res}  请求参数:${data}");
    return res;
  }

  // 修改登录密码
  Future<bool> newChangeLoginPwd(Map<String, dynamic> params) async {
    final commonData = await getCMData();
    int cmdId = 310111;
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_name': LoginManager.instance.loginInfo?.custName,
      'oper_id': LoginManager.instance.loginInfo?.custId,
      ...params,
      ...commonData,
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    // print("输出一下结果:${res}  请求参数:${data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  // 修改提现密码
  Future<bool> changePayPwd(Map<String, dynamic> params) async {
    int cmdId = 310122;
    final commonData = await getCMData();
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_name': LoginManager.instance.loginInfo?.custName,
      'oper_id': LoginManager.instance.loginInfo?.custId,
      ...params,
      ...commonData,
    };

    final res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    // print("修改提现密码传参：${data}   响应：${res.data}");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['response_code'] == '9999') {
        return true;
      }
    }
    return false;
  }

  //请求充值、提现纪录列表
  Future<List<DwRecordsBean>> reqDwRecordsList({
    required String type,
    required int frontStatus,
    required int time,
    required int page,
  }) async {
    List<DwRecordsBean> tempList = [];

    // 获取投注记录列表信息
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(time); //这里传入具体的天数，当天：0，多少天前，就传多少天
    // print("开始时间：${DateTimeUtils.formatTimestamp(dayRange["startTime"]!)}  结束时间：${DateTimeUtils.formatTimestamp(dayRange["endTime"]!)}");
    int cmdId = 340539;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'type': type, // 电子投注
      'front_status': frontStatus, // 电子投注
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
      'page_start': page,
      'num_per_page': 10,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    print('数据: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['data'] is List) {
        for (var item in res.data['data']) {
          tempList.add(DwRecordsBean.fromJson(item));
        }
      }
    }

    return tempList;
  }

  // 修改客户最后登录信息
  static Future<NetworkResponse> updateLastLogin() async {
    int cmdId = 3101113;
    final deviceId = await getDeviceId();
    var data = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'last_app_key': deviceId,
      'last_regist_from': NetworkService().baseURL,
      'last_platform': getBetPlatform3(),
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      // paramType: 1,
    );
    // print("修改最后登录信息 请求参数：${data}  响应参数：${res}");
    return res;
  }

  //获取vip返水列表信息
  Future<dynamic> reqRebateListData() async {
    int cmdId = 3900021;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    return res;
  }

  //领取vip特权
  Future<dynamic> reqVIPPrivilegePackageData(int type, int select_level) async {
    int cmdId = 3270572;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'type': type,
      'select_level': select_level
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
    );
    return res;
  }
  
}
