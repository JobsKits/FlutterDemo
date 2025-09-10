import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/manual_recharge_tips.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
// import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';

import 'package:flutter_tiyu_app/utils/tenant_manager.dart';

import '../utils/date_time_utils.dart';

/// 系统方面全局API， 例如站内信/消息等
class SystemApi {
  /// app域名智能线路获取
  static Future<NetworkResponse> checkBaseUrl(
      String failedDomain, String failedReason) async {
    int cmdId = 3711361;
    // 所有参数固定
    var data = {
      'aseq_id': AppConfigs.aseqId,
      'tid': AppConfigs.tid,
      'chan_code': AppConfigs.chanCode,
      'clusters_id': AppConfigs.clustersId,
      'proxy': AppConfigs.proxy,
      'failed_domain': failedDomain,
      'failed_reason': failedReason,
    };
    // print('checkBaseUrl: ${data}');
    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 1,
    );
  }

  /// 上报推送信息
  static Future<void> addPushInfo() async {
    int cmdId = 380501;

    var registrationId = LoginManager.instance.registrationId;
    if (registrationId.isNotEmpty) {
      final deviceId = await getDeviceId();
      var deviceType = '1'; // 1: 安卓，2: iOS
      if (Platform.isIOS) {
        deviceType = '2';
      }
      var data = {
        'tid': AppConfigs.tid,
        'device_id': deviceId,
        'device_type': deviceType,
        'registration_id': registrationId,
      };

      // print('推送信息上传: ${data}');
      final res = await NetworkService().request(
        cmdId,
        data: data,
        paramType: 1,
      );
      // print('推送信息上传返回: ${res.data}');
    }
  }

  static Future<void> updatePushInfo() async {
    int cmdId = 380501;

    var registrationId = LoginManager.instance.registrationId;
    if (registrationId.isNotEmpty && LoginManager.instance.loginInfo != null) {
      final deviceId = await getDeviceId();
      var deviceType = '1'; // 1: 安卓，2: iOS
      if (Platform.isIOS) {
        deviceType = '2';
      }

      var data = {
        'tid': AppConfigs.tid,
        'device_id': deviceId,
        'device_type': deviceType,
        'registration_id': registrationId,
        'user_id': LoginManager.instance.loginInfo!.custId,
        'alias_id': LoginManager.instance.loginInfo!.custId,
        'alias_name': LoginManager.instance.loginInfo!.custName
      };

      // print('推送信息更新: ${data}');
      final res = await NetworkService().request(
        cmdId,
        data: data,
        paramType: 1,
      );
      // print('推送信息更新返回: ${res.data}');
    }
  }

  /// 请求未读消息
  static Future<NetworkResponse> reqUnReadMsg() async {
    // 获取消息未读数量 登录后每10秒取一次
    int cmdId = 375026;
    // 获取投注记录列表信息
    Map<String, int> dayRange =
        DateTimeUtils.getTimeRange(30); //这里传入具体的天数，当天：0，多少天前，就传多少天
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'receivor_id': LoginManager.instance.loginInfo?.custId,
      'message_id': 30,
      'receivor_type': 1,
      'begin_time': dayRange["startTime"],
      'end_time': dayRange["endTime"],
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 2,
    );
    // print("输出一下信息:${res}");
    return res;
  }

  /// 获取上传图片的线路
  static Future<NetworkResponse> reqUploadImageUrlList() async {
    int cmdId = 360830;

    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'domain_type': '4,9,10',
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }

  /// 获取阿里云存储配置
  static Future<NetworkResponse> reqAliyunOssConfig(int domainType) async {
    int cmdId = 370730;

    var data = {
      'tid': 0,
      'option_code': domainType == 9
          ? 'ALIYUN_OSS_STORAGE_CONFIGURE' // aliyun 存储
          : 'AWS_STORAGE_CONFIGURE', // 亚马逊 S3 存储
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 获取人工充值描述
  static Future<ManualRechargeTips?> getManualRechargeDesc() async {
    int cmdId = 370730;
    var data = {
      'tid': AppConfigs.tid,
      'option_code': 'CHARGE_DESC_NEW', // 亚马逊 S3 存储
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    if (res.type == NetworkService.networkTypeSuccess) {
      return ManualRechargeTips.fromJson(res.data);
    }
    return null;
  }

  /// 获取是否显示底部导航栏的充值角标
  static Future<bool> getIsShowRechargeTips() async {
    int cmdId = 370730;
    var data = {
      'tid': AppConfigs.tid,
      'option_code': 'RECHARGE_NAVIGATION_CORNER_MARK', // 亚马逊 S3 存储
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
    return res.data?["intValue"] == 1;
  }

  /// 获取阿里云存储令牌凭证
  static Future<NetworkResponse> reqAliyunOssSecret(
      Map<String, dynamic> data) async {
    int cmdId = 370722;

    return await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      logError: true,
    );
  }

  /// 线下充值
  static Future<NetworkResponse> reqOfflineRecharge(
      Map<String, dynamic> params) async {
    int cmdId = 341400;

    var data = {
      'cust_code': LoginManager.instance.loginInfo!.custCode,
      'oper_code': LoginManager.instance.loginInfo!.custCode,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'acct_id': LoginManager.instance.loginInfo!.acctId,
      'tid': TenantManager.instance.tenantBean!.tid,
      'chan_code': AppConfigs.chanCode,
      'state': 1, // 待付款
      'pay_chan': 0,
      ...params,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 1,
      isApiV2: false,
      logError: true,
    );
  }

  /// 线上充值
  static Future<NetworkResponse> reqOnlineRecharge(
      Map<String, dynamic> params, Map<String, String> thirdData) async {
    int cmdId = 383029;

    Map<String, dynamic> acctPayLog = {
      'cust_code': LoginManager.instance.loginInfo!.custCode,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'acct_id': LoginManager.instance.loginInfo!.acctId,
      'tid': TenantManager.instance.tenantBean!.tid,
      'chan_code': AppConfigs.chanCode,
      'balance_type_id': 1,
      'status': 1, // 待付款
      'success_time': DateTime.now().microsecondsSinceEpoch,
      'deposit': double.parse(params['amount'] ?? 0) * 1000,
      'sourcetype': params['payEngName'],
      ...params,
    };

    acctPayLog.remove('amount');
    acctPayLog.remove('payEngName');

    Map<String, dynamic> paramsJson = {
      'amount': double.parse(params['amount'] ?? 0) * 100,
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'redirect_url': NetworkService().hostName
    };
    if (thirdData != null && thirdData.isNotEmpty) {
      thirdData.forEach((key, value) {
        paramsJson[key] = value;
      });
    }
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'acctPayLog': jsonEncode(acctPayLog),
      'paramsJson': jsonEncode(paramsJson),
      'payEngName': params['payEngName'],
    };

    print('xxxx====>${data}');

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: true,
      logError: true,
    );
  }

  /// 查询用户信息认证状态
  static Future<NetworkResponse> reqCertificationInfo() async {
    int cmdId = 325308;

    var data = {
      'cust_id': LoginManager.instance.loginInfo!.custId,
      'tid': TenantManager.instance.tenantBean!.tid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }

  /// 用户的默认银行卡信息
  static Future<NetworkResponse> reqDefaultBankCard() async {
    int cmdId = 310435;

    var data = [
      TenantManager.instance.tenantBean!.tid,
      LoginManager.instance.loginInfo!.custId
    ];

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
      logError: true,
    );
  }

  /// 用户的默认银行卡信息
  static Future<NetworkResponse> reqDefaultBankCard2() async {
    int cmdId = 3104351;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
    };
    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 请求用户的银行卡提示文案
  static Future<NetworkResponse> reqBankCardTips() async {
    int cmdId = 310436;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      logError: true,
    );
  }

  /// 返回用户钱包地址
  /// contact_name:姓名 id_card_log_addr:证件图片地址 id_card:证件号码 country:国家 document_type:证件类型
  static Future<NetworkResponse> reqBindBankList() async {
    int cmdId = 310430;

    var data = [
      TenantManager.instance.tenantBean!.tid,
      LoginManager.instance.loginInfo!.custId,
      1,
      20,
    ];

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 2,
      isApiV2: false,
      logError: true,
    );
  }

  /// 提现页面数据获取
  static Future<NetworkResponse> reqWithdrawLimint() async {
    int cmdId = 310140;

    var data = [
      TenantManager.instance.tenantBean!.tid,
      LoginManager.instance.loginInfo!.custId,
    ];

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 2,
      isApiV2: false,
      logError: true,
    );
  }

  static Future<Map<String, dynamic>> memberOperInfoVoParams() async {
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
      'trans_type': 105,
      'busi_type': 222,
      'mark': 1,
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

  /// 添加 绑卡
  /// open_addr,pay_org_id,pay_org_name,pay_name,pay_no,ifsc
  /// telephone sort_v qr_code_address state pixKey pixType usdt_type
  /// branch_number:分行好[支店番号] paynow_no:paynow账号
  /// custContact:{mobile_phone,email,weixin}[个人资料信息]
  static Future<NetworkResponse> reqBindCard(
      Map<String, dynamic> params) async {
    int cmdId = 310400;
    final voParams = await memberOperInfoVoParams();
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'cust_code': LoginManager.instance.loginInfo!.custCode,
      'oper_code': LoginManager.instance.loginInfo!.custCode,
      'state': 1,
      'memberOperInfoVo': {
        'tid': TenantManager.instance.tenantBean!.tid,
        'cust_id': LoginManager.instance.loginInfo?.custId,
        'cust_name': LoginManager.instance.loginInfo?.custName,
        'ori_value': '',
        'new_value': '',
        'oper_code': LoginManager.instance.loginInfo?.custId,
        'oper_method': 1,
        'oper_name': LoginManager.instance.loginInfo?.custName,
        'oper_class_type': 2,
        'oper_source_type': 2,
        ...voParams,
      },
      ...params,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 1,
      isApiV2: false,
      logError: true,
    );
  }

  /// 获取银行卡
  static Future<NetworkResponse> reqNewBankList() async {
    int cmdId = 371234;

    var data = [TenantManager.instance.tenantBean!.tid];

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 2,
      logError: true,
    );
  }

  /// 获取银行卡 查询IFSC india
  static Future<NetworkResponse> reqIFSC() async {
    int cmdId = 371632;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  /// 账户相关的一些配置信息 绑卡字段设置 (银行卡与PixPay 使用)
  static Future<NetworkResponse> reqBindCardConfig() async {
    int cmdId = 370730;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'option_code': 'BIND_CARD_FIELD',
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }

  // 检查提现密码是否正确
  static Future<NetworkResponse> reqCheckFundPassword(String password) async {
    int cmdId = 310136;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_code': LoginManager.instance.loginInfo!.custCode,
      'acct_pwd': getP(password.trim()),
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }

  // 提现
  static Future<NetworkResponse> reqWithdraw(
      Map<String, dynamic> params) async {
    int cmdId = 341200;

    var data = {
      ...params,
      'acct_id': LoginManager.instance.loginInfo!.acctId,
      'tid': TenantManager.instance.tenantBean!.tid,
      'acct_pwd': params['acct_pwd'] != '' ? getP(params['acct_pwd']) : '',
      'chan_code': AppConfigs.chanCode,
      'cust_code': LoginManager.instance.loginInfo!.custCode,
      'oper_code': LoginManager.instance.loginInfo!.custCode,
      'cust_id': LoginManager.instance.loginInfo?.custId,
      'remark': '审核中',
      'state': 1,
      'withdraw_type': 1
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: 1,
      isApiV2: true,
      logError: true,
    );
  }

  /// 获取系统配置相关参数
  static Future<NetworkResponse> reqConfig(String optionCode) async {
    int cmdId = 370730;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'option_code': optionCode,
    };

    return await NetworkService().request(
      cmdId,
      data: data,
      logError: true,
    );
  }
}
