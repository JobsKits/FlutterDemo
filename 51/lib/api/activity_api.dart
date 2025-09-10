import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_collection_model/activity_collection_model.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
// import 'package:flutter_tiyu_app/utils/activity_manager.dart';
import 'package:network_info_plus/network_info_plus.dart';

class ActivityApi {
  // 请求活动下Tab数据
  static Future<NetworkResponse> reqTabsData() async {
    int cmdId = 723606;
    final tid = TenantManager.instance.tenantBean!.tid;
    var data = {
      'tid': tid,
      'page_start': 1,
      'num_per_page': 50,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 请求Tab下的活动列表
  static Future<NetworkResponse> reqTabListData(num tabId) async {
    int cmdId = 723601;
    final tid = TenantManager.instance.tenantBean!.tid;
    var data = {
      'tid': tid,
      'page_start': 1,
      'num_per_page': 50,
      'activityCategory': tabId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 请求转盘助力详情接口
  static Future<NetworkResponse> reqWheelData(num aid) async {
    int cmdId = 723621;
    final tid = TenantManager.instance.tenantBean!.tid;
    var data = {
      'tid': tid,
      'id': aid,
      'aid': aid,
      'acctId': LoginManager.instance.loginInfo!.custId,
      'account': LoginManager.instance.loginInfo!.custName,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 新人彩金 提交优惠码
  static Future<NetworkResponse> submitPromoCode(
      String aid, String promoCode) async {
    const cmdId = 621116;
    final tid = TenantManager.instance.tenantBean!.tid;
    var data = {
      'tid': tid,
      'acctId': LoginManager.instance.loginInfo!.acctId,
      'account': LoginManager.instance.loginInfo!.custName,
      'aid': aid,
      'promoCode': promoCode,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 新人彩金 获取优惠码
  static Future<NetworkResponse> reqPromoCode(String aid) async {
    const cmdId = 723624;
    final tid = TenantManager.instance.tenantBean!.tid;
    var data = {
      'tid': tid,
      'acctId': LoginManager.instance.loginInfo!.custId,
      'account': LoginManager.instance.loginInfo!.custName,
      'aid': aid,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 获取排行榜列表
  static Future<NetworkResponse> getRankList(String aid) async {
    int cmdId = 621113;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      'tid': AppConfigs.tid,
      'id': 0,
      'aid': aid,
      'page_start': 1,
      'num_per_page': 10,
    };

    if (isLogin) {
      data['acctId'] = LoginManager.instance.loginInfo!.acctId ?? 0;
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  // 领取排行榜奖励
  static Future<NetworkResponse> reqRankReward(String aid) async {
    int cmdId = 621112;
    var data = {
      'tid': AppConfigs.tid,
      'acctId': LoginManager.instance.loginInfo?.acctId,
      'custId': LoginManager.instance.loginInfo?.custId,
      'account': LoginManager.instance.loginInfo?.custName,
      'id': aid,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 请求优惠活动Tab数据
  static Future<NetworkResponse> reqActivityData() async {
    int cmdId = 380237;
    final tid = TenantManager.instance.tenantBean!.tid;
    final payload = {
      "apply": 3, // 1 棋牌；2 网赚；3 综合彩票；3 老版彩票； (apply后端设置默认为1，为可选参数)
      "type": "MWEB", // 设备码。 IOS/ANDROID/MWEB
      "tid": tid, //  平台数据上的 tid
      "chan_con": "MWEB", // 设备码。 IOS/ANDROID/MWEB
      "language": 0, // 前期客户端语言
      "proxy": 0, // 平台数据上的 proxy
    };

    return await NetworkService().request(
      cmdId,
      data: payload,
      paramType: 0,
      logError: true,
    );
  }

  /// 请求活动详情
  static Future<NetworkResponse> reqActivityDetail(String id) async {
    int cmdId = 723608;
    bool isLogin = LoginManager.instance.isLogin.value;
    final tid = TenantManager.instance.tenantBean!.tid;
    var payload = {
      "id": id,
      "tid": tid,
    };

    if (isLogin) {
      payload['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }

    return await NetworkService().request(
      cmdId,
      data: payload,
      paramType: 1,
      logError: true,
    );
  }

  /// 请求任务列表
  static Future<NetworkResponse> reqTaskListData() async {
    final tid = TenantManager.instance.tenantBean!.tid;
    bool isLogin = LoginManager.instance.isLogin.value;
    final cmdId = isLogin ? 370603 : 377212;

    var data = {
      "tid": tid,
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 请求任务列表
  static Future<NetworkResponse> reqNewcomersWelfareData() async {
    int cmdId = 3920003;
    final tid = TenantManager.instance.tenantBean!.tid;
    bool isLogin = LoginManager.instance.isLogin.value;

    var data = {
      "tid": tid,
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
    );
  }

  /// 获取活动奖金数据 , 该接口需要登录才能调用
  static Future<NetworkResponse> reqTaskActivityBonusData() async {
    final tid = TenantManager.instance.tenantBean!.tid;

    const cmdId = 377209;
    var data = {
      "tid": tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 获取日常任务
  static Future<NetworkResponse> reqActivityDailyTaskData() async {
    final tid = TenantManager.instance.tenantBean!.tid;

    const cmdId = 724206;
    var data = {
      "tid": tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 领取日常任务
  /// 724207
  static Future<NetworkResponse> reqReceiveDailyTaskData(int id) async {
    final tid = TenantManager.instance.tenantBean!.tid;

    const cmdId = 724207;
    var data = {
      "tid": tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "receive_log_id": id,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  // 领取活动奖金数据
  static Future<NetworkResponse> reqReceiveTaskActivityBonus({
    required num taskId,
    required num id,
  }) async {
    const cmdId = 377210;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "task_id": taskId,
      "id": id,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 获取会员任务
  static Future<NetworkResponse> reqTaskMemberMissionData() async {
    bool isLogin = LoginManager.instance.isLogin.value;

    final cmdId = isLogin ? 395010 : 395014;
    var data = {
      "tid": AppConfigs.tid,
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 领取会员任务奖励
  static Future<NetworkResponse> reqReceiveTaskMemberMission({
    required num standaraNumber,
    required num standaraType,
    required num alreadyNumber,
    required num custTaskId,
  }) async {
    const cmdId = 395011;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "custId": LoginManager.instance.loginInfo!.custId,
      "standaraNumber": standaraNumber,
      "standaraType": standaraType,
      "alreadyNumber": alreadyNumber,
      "custTaskId": custTaskId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
    );
  }

  /// 领取其他任务奖励
  static Future<NetworkResponse> reqReceiveTaskReward({
    required int receiveLevel,
    required int type,
    required String amount,
  }) async {
    const cmdId = 394012;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "receive_level": receiveLevel,
      "type": type,
      "amount": amount,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 获取游戏任务数据
  static Future<NetworkResponse> reqGameMissionData() async {
    final tid = TenantManager.instance.tenantBean!.tid;
    bool isLogin = LoginManager.instance.isLogin.value;

    final cmdId = isLogin ? 374038 : 377211;
    var data = {
      "tid": tid,
      "proxy": TenantManager.instance.tenantBean!.proxy,
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 游戏任务领取接口
  static Future<NetworkResponse> reqReceiveGameTask(
      List<Map<String, dynamic>> listData) async {
    const cmdId = 374037;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "missons": listData,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 获取签到数据
  static Future<NetworkResponse> reqSignInData() async {
    const cmdId = 374003;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo?.custId ?? 0,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 获取签到规则
  static Future<NetworkResponse> reqSignInRule() async {
    const cmdId = 31589;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 活动签到检查
  static Future<NetworkResponse> reqCheckSignInStatus() async {
    const cmdId = 360728;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "activity_name": "qiandao"
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 签到
  static Future<NetworkResponse> reqSignIn() async {
    const cmdId = 374002;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: false,
    );
  }

  /// 获取返水比例
  static Future<NetworkResponse> reqRebateProportion({
    required int gameType,
    required int sgameType,
  }) async {
    const cmdId = 390000;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "game_type": gameType,
      "sgame_type": sgameType
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 获取返水页面数据
  static Future<NetworkResponse> reqRebateData() async {
    const cmdId = 390003;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );

    return res;
  }

  /// 获取历史返水记录
  static Future<NetworkResponse> reqHistoryRebateData() async {
    const cmdId = 390005;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "data_type": 1,
      "page": 30,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 获取自助返水详情
  static Future<NetworkResponse> reqRebateDetail(String logId) async {
    const cmdId = 390006;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      // "cust_id": LoginManager.instance.loginInfo!.custId,
      "log_id": logId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取返水
  static Future<NetworkResponse> reqReceiveRebate(num endTime) async {
    const cmdId = 390004;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "end_time": endTime,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝 - 转入保险箱
  static Future<NetworkResponse> reqTransferInSafe(num balance) async {
    const cmdId = 340334;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "acct_id": LoginManager.instance.loginInfo!.acctId,
      "oper_code": LoginManager.instance.loginInfo!.custCode,
      "mark": 1,
      "balance": balance,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 余额宝 - 转出保险箱
  static Future<NetworkResponse> reqTransferOutSafe(num balance) async {
    const cmdId = 340335;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "acct_id": LoginManager.instance.loginInfo!.acctId,
      "oper_code": LoginManager.instance.loginInfo!.custCode,
      "mark": 1,
      "balance": balance,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 余额宝 - 打开保险箱 (新的UI没有用上！！！)
  @deprecated
  static Future<NetworkResponse> reqOpenSafe(String password) async {
    const cmdId = 310136;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      // "cust_id": LoginManager.instance.loginInfo!.custId,
      "cust_code": LoginManager.instance.loginInfo!.custCode,
      "acct_pwd": getP(password),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 2,
      logError: true,
    );
  }

  /// 获取余额宝利息相关
  static Future<NetworkResponse> reqYueBaoInterest() async {
    const cmdId = 340337;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 验证余额宝
  static Future<NetworkResponse> reqCheckYueBao({bool? isYueBao = true}) async {
    const cmdId = 360731;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "type": isYueBao == true ? "105" : "108", // 105余额宝, 108借呗
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝数据配置
  static Future<NetworkResponse> reqYueBaoDataConfig() async {
    const cmdId = 370601;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      // "cust_id": LoginManager.instance.loginInfo!.custId,
      "type": "105",
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝记录列表接口
  static Future<NetworkResponse> reqYueBaoListData({
    required int page,
    required int? pageSize,
  }) async {
    const cmdId = 340620;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_code": LoginManager.instance.loginInfo!.custName,
      "num_per_page": pageSize ?? 10,
      "page_start": page,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 保险箱相关数据
  static Future<NetworkResponse> reqSafeData() async {
    const cmdId = 340336;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      logError: true,
    );
  }

  /// 保险箱相关数据
  static Future<NetworkResponse> reqWaitingCollection() async {
    const cmdId = 340339;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      logError: true,
    );
  }

  /// 利息方案列表 is_auto_maturity 区分活期定期 ??? 不正确
  static Future<NetworkResponse> reqInterestPlan({
    required int page,
    required int pageSize,
    required int interestType,
  }) async {
    const cmdId = 360201;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "page_start": page,
      "num_per_page": pageSize,
      "interest_type": interestType, // interest_type  0 活期  1 定期
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝购买接口
  static Future<NetworkResponse> reqBuyPlan({
    required String amount,
    required int planId,
  }) async {
    const cmdId = 360212;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "amount": amount,
      "plan_id": planId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝赎回接口
  static Future<NetworkResponse> reqSellPlan({
    // required String amount,
    required int planId,
  }) async {
    const cmdId = 360213;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      // "amount": amount,
      "acct_product_id": planId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝已购买方案接口
  static Future<NetworkResponse> reqHasBuyPlanList({
    required int page,
    required int pageSize,
  }) async {
    const cmdId = 3602141;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      // "cust_id": LoginManager.instance.loginInfo!.custId,
      "cust_name": LoginManager.instance.loginInfo!.custName,
      "page_start": page,
      "num_per_page": pageSize,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 活动详情
  static Future<NetworkResponse> reqActivityDetails(String aid) async {
    const cmdId = 723603;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "id": aid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 活动详情
  static Future<NetworkResponse> reqReviceCodingDetail(int tasksId) async {
    const cmdId = 7242021;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tasks_id': tasksId
    };
    print({'7242021 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> reqApplyPreviewInfo(int tasksId) async {
    const cmdId = 725100;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tasks_id': tasksId
    };
    print({'725100 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> reqApplyPreview(int tasksId) async {
    const cmdId = 725101;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tasks_id': tasksId
    };
    print({'725101 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 活动详情-申请次数
  static Future<NetworkResponse> reqCustomApplyNumbers(int tasksId) async {
    const cmdId = 725001;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'tasks_id': tasksId
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }
    print({'725001 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 活动详情-申请优惠
  static Future<NetworkResponse> reqCustomApplyPromotion(
    int tasksId,
    List<String> applyText,
    List<String> answer,
  ) async {
    const cmdId = 725002;
    bool isLogin = LoginManager.instance.isLogin.value;
    var deviceName = await DeviceInfoUtil.getDeviceModel();
    var ip = await DeviceInfoUtil.getIpAddress();
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'aid': tasksId,
      'applyDeviceType': deviceName,
      'applyText': applyText,
      'answer': answer,
      'applyIp': ip,
      'applyDevice': Platform.isAndroid ? 'Android APP' : 'iOS APP',
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
      data['cust_name'] = LoginManager.instance.loginInfo!.custName ?? '';
    }
    print({'725001 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 活动详情-申请记录
  static Future<NetworkResponse> reqCustomApplyRecords(
      int tasksId, int day) async {
    const cmdId = 725004;
    bool isLogin = LoginManager.instance.isLogin.value;

    Map<String, int> dayRange = DateTimeUtils.getTimeRange(day);
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'tasks_id': tasksId,
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
      'page_start': 1,
      'num_per_page': 100,
    };

    if (isLogin) {
      data['cust_id'] = LoginManager.instance.loginInfo!.custId;
    }
    print({'725004 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取记录
  static Future<NetworkResponse> reqActivityRecorrdList(
      int date, String status) async {
    const cmdId = 724208;
    Map<String, int> dayRange = DateTimeUtils.getTimeRange(date);
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'page_start': 1,
      'num_per_page': 10,
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
    };

    if (status != 'null') {
      data['status'] = int.parse(status);
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取记录页面领取任务
  static Future<NetworkResponse> reqActivityReceive(int receiveLogId) async {
    const cmdId = 724209;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_log_id': receiveLogId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 福利中心充值次数接口
  static Future<NetworkResponse> reqActivityRechrgeFrequency(
      int receiveLogId) async {
    const cmdId = 725102;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_log_id': receiveLogId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 福利中心支付类型接口
  static Future<NetworkResponse> reqActivityPaymentType() async {
    const cmdId = 371237;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "type": "-1",
      "name": -1,
      "currency": -1,
      "state": "1",
      "cat": "1,2",
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取记录页面领取任务
  static Future<NetworkResponse> reqParticipateRewardActivity(
      String aid, String status) async {
    const cmdId = 621115;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'acctId': LoginManager.instance.loginInfo!.acctId,
      'account': LoginManager.instance.loginInfo!.custName,
      'aid': aid,
      'status': status,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      logError: true,
    );
  }

  /// 领取红包任务
  static Future<NetworkResponse> reqRedbagActivity(int receiveLogId) async {
    const cmdId = 15;
    String domainAddr = NetworkService().baseURL;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_log_id': receiveLogId,
      'platform': 1,
      'domain_addr': domainAddr
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运注单活动-详情
  static Future<NetworkResponse> reqLuckyActivityDetail(String aid) async {
    const cmdId = 7242032;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'fortune_id': aid
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 救援金-可领取奖励信息查询
  static Future<NetworkResponse> reqReliefRewards(String aid) async {
    const cmdId = 7242020;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tasks_id': aid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  static Future<NetworkResponse> reqRechargRewards(String aid) async {
    const cmdId = 7242022;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tasks_id': aid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运注单活动---查询用户可领取的总金额（前台）
  static Future<NetworkResponse> reqLuckyBetActivityCanRevice(
      int taskId) async {
    const cmdId = 7242030;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'task_id': taskId
    };
    print({'7242030 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运注单活动---查询用户可领取的总金额（前台）
  static Future<NetworkResponse> reqReviceLuckyBet(int taskId) async {
    const cmdId = 7242031;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'task_id': taskId
    };
    print({'7242031 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运注单活动---查询用户可领取的总金额（前台）
  static Future<NetworkResponse> reqWinningDetail(
      String tailNum, int gameType, int taskId) async {
    Map<String, int> dayRange = DateTimeUtils.getTimeRange(7);
    const cmdId = 322939;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'game_type': -1,
      'state': -1,
      'start_time': dayRange['startTime']!,
      'end_time': dayRange['endTime']!,
      'task_id': taskId
    };
    print({'322939 ============${data}'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 救援金-领取
  static Future<NetworkResponse> getReliefRewards(int logId) async {
    const cmdId = 724209;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_log_id': logId,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 打码活动---领取（前台）
  static Future<NetworkResponse> reqReviceCoding(int receiveLogId) async {
    const cmdId = 724209;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_log_id': receiveLogId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 余额宝利息领取
  static Future<NetworkResponse> reqReviceYuEbao() async {
    const cmdId = 340622;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "acct_id": LoginManager.instance.loginInfo!.acctId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 红包雨查询
  static Future<NetworkResponse> reqRadbagRainSearch() async {
    const cmdId = 7242045;
    Map<String, dynamic> data = {};
    if (LoginManager.instance.loginInfo == null) {
      data = {
        "tid": TenantManager.instance.tenantBean!.tid,
        // 'cust_id': LoginManager.instance.loginInfo!.custId,
      };
    } else {
      data = {
        "tid": TenantManager.instance.tenantBean!.tid,
        'cust_id': LoginManager.instance.loginInfo!.custId,
      };
    }
    print({'data obj ============== $data'});
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 红包雨领取
  static Future<NetworkResponse> reqReviceRain(int id) async {
    const cmdId = 7242041;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'id': id,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: false,
    );
  }

  /// 红包雨活动详情
  static Future<NetworkResponse> reqRedbagRainDetail() async {
    const cmdId = 7242042;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
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

  /// 首页浮窗列表
  static Future<NetworkResponse> reqFloatList() async {
    const cmdId = 383008;
    bool isLogin = LoginManager.instance.isLogin.value;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "chan_con": 0,
      "location": 0,
      "num_per_page": 20,
      "page_start": 1,
      "state": "1",
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

  /// 红包雨活动详情剩余领取次数
  static Future<NetworkResponse> reqRedbagRainRemainingNumbers(int id) async {
    const cmdId = 7242043;
    bool isLogin = LoginManager.instance.isLogin.value;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'id': id.toString(),
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

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityTurntable(
    int activity_id,
    int wheelType,
  ) async {
    const cmdId = 7242043;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'activity_id': activity_id.toString(),
      'wheelType': wheelType.toString(),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityDetailInfo(int activity_id) async {
    const cmdId = 7242043;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'id': activity_id.toString(),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityTurntableDetail(
    int activity_id,
    int wheelType,
  ) async {
    const cmdId = 7242023;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'activity_id': activity_id.toString(),
      'wheelType': wheelType.toString(),
    };

    print({'data obj ============== $data'});

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityTurntableWin(
    int activity_id,
    int wheelType,
  ) async {
    const cmdId = 7242024;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'activity_id': activity_id.toString(),
      'wheelType': wheelType.toString(),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: false,
    );
  }

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityTurntableRecords(
      String activity_id, String wheelType) async {
    const cmdId = 7242025;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'activity_id': activity_id,
      'wheelType': wheelType,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 幸运大转盘抽奖
  static Future<NetworkResponse> reqActivityTaskIntegral(
    int activity_id,
    int taskId,
  ) async {
    const cmdId = 7242026;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'activity_id': activity_id.toString(),
      'taskId': taskId.toString(),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 首次充值弹窗接口
  static Future<NetworkResponse> reqFirstRechrgeData() async {
    const cmdId = 7242044;
    bool isLogin = LoginManager.instance.isLogin.value;

    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
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

  /// 待领取列表
  static Future<NetworkResponse> reqCollectionList(
      {int receiveType = 0}) async {
    const cmdId = 327057;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'receive_type': receiveType == 99999 ? '' : receiveType
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取记录
  static Future<NetworkResponse> reqReceivedList(
      {dynamic receiveType = 0, dynamic status = 0}) async {
    const cmdId = 724211;
    Map<String, int> dayRange = DateTimeUtils.getTimeRange(30);
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'page_start': 1,
      'num_per_page': 10,
      'start_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
      'receive_type': receiveType == 99999 ? '' : receiveType,
      "status": status == 99999 ? '' : status
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 待领取列表
  static Future<NetworkResponse> reqCollectionReceive(
      int type, {ActivityCollectionModel? model}) async {
    const cmdId = 395015;
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      "cust_id": LoginManager.instance.loginInfo!.custId,
      "receiveType": type,
      if (type == 1) "platform": Platform.isAndroid ? 'Android' : 'iOS',
    };

    // 根据类型设置特定字段
    switch (type) {
      case 1:
        data['receive_log_id'] = model?.receiveId ?? '';

        break;
      case 2:
        data['cust_task_id'] = model?.receiveId ?? '';
        break;
      case 3:
        data['end_time'] = DateTime.now().millisecondsSinceEpoch;
        break;
      case 4:
        data['acct_id'] = LoginManager.instance.loginInfo!.acctId!;
        break;
      case 6:
        break;
      default:
        // 处理未知类型（可选）
        break;
    }
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 领取记录
  static Future<NetworkResponse> reqReceivedAllBouns() async {
    const cmdId = 395017;
    Map<String, int> dayRange = DateTimeUtils.getTimeRange(0);
    var data = {
      "tid": TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'end_time': dayRange["endTime"],
      "platform": Platform.isAndroid ? 'Android' : 'iOS',
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }
}

class DeviceInfoUtil {
  static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  static final NetworkInfo networkInfo = NetworkInfo();

  // 获取设备型号
  static Future<String> getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return iosInfo.utsname.machine ?? 'Unknown iOS device';
      }
      return 'Unknown device';
    } catch (e) {
      return 'Error getting device info: $e';
    }
  }

  // 获取IP地址
  static Future<String> getIpAddress() async {
    try {
      String? ip = await networkInfo.getWifiIP();
      return ip ?? '127.0.0.1';
    } catch (e) {
      return '127.0.0.1';
    }
  }

  // 获取完整的设备信息
  static Future<Map<String, dynamic>> getFullDeviceInfo() async {
    return {
      'deviceModel': await getDeviceModel(),
      'ipAddress': await getIpAddress(),
      'platform': Platform.operatingSystem,
      'platformVersion': Platform.operatingSystemVersion,
    };
  }
}
