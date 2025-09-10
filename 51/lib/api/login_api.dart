/// 用户登录注册以及用户信息相关
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/Wallet_bean.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
// import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../app/modules/wallet/data/Third_wallet_bean.dart';

/// 检测账号类型
/// 0 真实玩家 1 试玩账号
enum DetectAccountType {
  real(0),
  isTry(1);

  final int value;
  const DetectAccountType(this.value);
}

class LoginApi {
  /// 查询 用户账号 特殊校验状态
  /// reqSpecialStatus
  static Future<NetworkResponse> reqSpecialStatus(String custName) async {
    int cmdId = 40001;
    var data = {
      'tid': TenantManager.instance.tenantBean?.tid,
      'cust_name': custName,
    };

    return await NetworkService().request(
      cmdId,
      isApiV2: false,
      data: data,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
  }

  /// 共用的登录接口配置
  static Future<Map<String, dynamic>> getCommonLoginData() async {
    final deviceId = await getDeviceId();
    final token = await AppManager.instance.getToken1();
    return {
      'app_key': deviceId, // 唯一设备ID
      'chan_code': AppConfigs.chanCode,
      'client_id': AppConfigs.clientId,
      'domain_addr': NetworkService().baseURL,
      'grant_type': 'password',
      'scope': 'read write',
      'special_problems': '', // 需要特殊验证才需要的值, 暂时不考虑
      'tid': TenantManager.instance.tenantBean?.tid,
      'validate': '', // 智能检测相关代码
      'token': token, // 易盾
    };
  }

  /// 获取推广链接code
  static Future<String> getPromoteLinkCode() async {
    //  H5取了url上分享的链接
    String promoteCode = AppConfigs.promote;
    final appVersion = await getDeviceVersion();
    if (promoteCode.isEmpty && appVersion.isNotEmpty) {
      promoteCode = TenantManager.instance.aseqBean!.regAddr!;
    }

    if (TenantManager.instance.tenantBean!.isPromote == 1) {
      String domainAddr = TenantManager.instance.tenantBean!.domainAddr ?? '';
      promoteCode = md5.convert(utf8.encode(domainAddr)).toString();
    }

    return promoteCode;
  }

  /// 共用的注册接口配置
  static Future<Map<String, dynamic>> getCommonRegisterData() async {
    final deviceId = await getDeviceId();
    final token = await AppManager.instance.getToken1();
    // 头像的地址 https://image2.typay2.com//static/heads/head_192.png
    int randomNumber = randomInteger(1, 200);
    final headURI =
        '/static/heads/head_${strPadLeft(randomNumber.toString(), 2)}.png';
    // final linkAddr = await getPromoteLinkCode();
    return {
      'adm_code': '1',
      'app_key': deviceId, // 唯一设备ID
      'chan_code': AppConfigs.chanCode,
      'client_id': AppConfigs.clientId,
      'domain_addr': NetworkService().baseURL,
      'gender': 0,
      'state': 1,
      'grant_type': 'password',
      'scope': 'read write',
      'head': headURI,
      // 'link_addr': linkAddr,
      'platform': getBetPlatform2(),
      'proxy': TenantManager.instance.tenantBean!.proxy,
      'regist_from': TenantManager.instance.tenantBean!.domainAddr,
      'tid': TenantManager.instance.tenantBean!.tid,
      'mobile_phone': '', // 联系电话
      'nickname': '', // 昵称
      'contact_name': '', // 真实会员名称
      'email': '', // 注册邮箱
      'facebook': '', // 注册的facebook
      'telegram': '', // 注册的telegram
      'whatsApp': '', // 注册的whatsApp
      'zalo': '', // 注册的zalo
      'line': '', // 注册的line邮箱
      'qq': '', // 注册的qq
      'invite_code': '', // 邀请码 (App暂无)
      'verifycode': '',
      'verifycode_key': '',
      'isQp': 1,
      'token': token, // 易盾
    };
  }

  /// 请求租户注册联系人配置
  static Future<NetworkResponse> reqContactConfig() async {
    int cmdId = 371143;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
    };

    return await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      headerType: 1,
      logError: true,
    );
  }

  /// 账号模式登录
  static Future<NetworkResponse> reqAccountLogin(
      Map<String, dynamic> params) async {
    final commonData = await getCommonLoginData();
    final loginParams = await loginOutParams();
    var data = {
      ...commonData,
      ...params,
      ...loginParams,
    };
    var res = await NetworkService().request(
      4,
      isApiV2: true,
      data: data,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
    print("登录传参：${data}  响应：${res}");

    return res;
  }

  /// 短信登录
  static Future<NetworkResponse> reqSMSlogin(
      Map<String, dynamic> params) async {
    int cmdId = 401;
    final commonData = await getCommonLoginData();
    final loginParams = await loginOutParams();
    var data = {
      ...commonData,
      ...params,
      ...loginParams,
    };

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
  }

  /// 邮箱登录
  static Future<NetworkResponse> reqEmaillogin(
      Map<String, dynamic> params) async {
    int cmdId = 402;
    final commonData = await getCommonLoginData();
    final loginParams = await loginOutParams();
    var data = {
      ...commonData,
      ...params,
      ...loginParams,
    };

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 1,
      headerType: 1,
    );
  }

  /// 邮箱密码登录
  static Future<NetworkResponse> reqEmailPwdlogin(
      Map<String, dynamic> params) async {
    int cmdId = 403;
    final commonData = await getCommonLoginData();
    var data = {
      ...commonData,
      ...params,
    };

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 1,
      headerType: 1,
    );
  }

  // 登录(4, 401, 402)，退出登录(310635)接口增加日志相关参数
  static Future<Map<String, dynamic>> loginOutParams() async {
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
      'trans_type': '101',
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

  /// 登出账号
  static Future<void> logout() async {
    /// 已登录的号退出登录
    if (LoginManager.instance.isLogin.value) {
      int cmdId = 310635;
      final loginParams = await loginOutParams();
      var data = {
        "app_key": "",
        "cust_code": LoginManager.instance.loginInfo!.custCode,
        "cust_id": LoginManager.instance.loginInfo!.custId,
        "tid": LoginManager.instance.loginInfo!.tid,
        ...loginParams,
      };

      final res = await NetworkService().request(
        cmdId,
        data: data,
        headerType: 2,
        isApiV2: false,
        paramType: 1,
      );

      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data != null &&
            res.data['response_code'].toString() == '9999') {
          // print("用户ID【${data['cust_id']}】退出登录成功！");
          LoginManager.instance.clear();
        }
      } else {
        // 前端退出登录
        LoginManager.instance.clear();
      }
    }
  }

  /// 发送邮箱验证码 （登录/注册都可用）
  static Future<NetworkResponse> reqEmailCode(Map<String, dynamic> params,
      {bool isLogin = true}) async {
    int cmdId = 100;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'client_id': 'react_client',
      'grant_type': 'password',
      'scope': 'read write',
      // 2 注册 3 登录
      'email_type': isLogin ? 3 : 2,
      ...params,
    };

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
  }

  /// 发送手机验证码
  static Future<NetworkResponse> reqSMSCode(Map<String, dynamic> params) async {
    int cmdId = 10;
    final token = await AppManager.instance.getToken2();
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'client_id': 'react_client',
      'grant_type': 'password',
      'scope': 'read write',
      'token': token, // 易盾
      ...params,
      // // 1为注册短信，2为登录短信，3位忘记密码短信
      // 'type': type,
      // // 目前设置的 +86
      // 'country': country == '' ? 'China' : country,
      // 'verifycode': verifyCode,
      // 'receive_mobile': receiveMobile,
    };

    final res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: true,
      paramType: 1,
      headerType: 1,
      logError: true,
    );

    // print("发送手机验证码传参：${data}  响应：${res}");

    return res;
  }

  /// 账号注册 register
  static Future<NetworkResponse> reqRegister(
      Map<String, dynamic> params) async {
    int cmdId = 3;

    final commonData = await getCommonRegisterData();
    var data = {
      ...commonData,
      ...params,
    };
    final res = await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: 1,
      headerType: 1,
      logError: true,
    );

    // print("注册传参：${data}  响应：${res}");

    return res;
  }

  /// 发送注册短信 reqSMSRigister
  static Future<NetworkResponse> reqSMSRigister(
      Map<String, dynamic> params) async {
    int cmdId = 301;

    final commonData = await getCommonRegisterData();

    var data = {
      ...commonData,
      ...params,
    };
    return NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
  }

  /// 邮箱注册 reqEmailRigister
  static Future<NetworkResponse> reqEmailRigister(
      Map<String, dynamic> params) async {
    int cmdId = 302;

    final commonData = await getCommonRegisterData();

    var data = {
      ...commonData,
      ...params,
    };
    return NetworkService().request(
      cmdId,
      isApiV2: true,
      data: data,
      paramType: 1,
      headerType: 1,
      logError: true,
    );
  }

  /// 获取图形验证码
  static Future<NetworkResponse> reqImageVerifyCode(int type) async {
    int cmdId = 7;
    var data = {
      'verifycode_key': uuid(32, 16),
      'type': type, // 1 登录 2 注册
    };

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      headerType: 1,
      logError: true,
    );
  }

  /// 获取账户余额 (考虑是否为试玩) 0 非试玩 1 试玩
  static Future<NetworkResponse> reqBalance({
    DetectAccountType isTry = DetectAccountType.real,
  }) async {
    bool isTryAccount = isTry == DetectAccountType.isTry;
    int cmdId = isTryAccount ? 340235 : 340234;

    // 转为List<int>
    List<int> data = [
      TenantManager.instance.tenantBean!.tid.toInt(),
      LoginManager.instance.loginInfo!.acctId!.toInt(),
    ];

    if (isTryAccount) {
      data.add(1);
    }

    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      paramType: 2,
      headerType: 2,
      logError: true,
    );
  }

  /// 获取充值大类列表 mark 1线下 2线上
  // static Future<NetworkResponse> reqRechargeType({int? mark}) async {
  //   bool hasMarkId = mark != null && [1, 2].contains(mark);
  //   int cmdId = hasMarkId ? 310141 : 310139;
  //
  //   List<int> data = [
  //     TenantManager.instance.tenantBean!.tid.toInt(), // 租户标识
  //     LoginManager.instance.loginInfo!.custId.toInt(), // 用户标识
  //   ];
  //
  //   if (hasMarkId) {
  //     data.add(mark);
  //   }
  //
  //   return NetworkService().request(
  //     cmdId,
  //     data: data,
  //     isApiV2: false,
  //     paramType: 2,
  //     headerType: 2,
  //     logError: true,
  //   );
  // }
  /// 获取充值大类列表 mark 1线下 2线上
  static Future<NetworkResponse> reqRechargeType() async {
    int cmdId = 3101392;
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid.toInt(),
      'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
    };
    return NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
      paramType: 0,
      headerType: 2,
      logError: true,
    );
  }

  /////////////////////////////////////////////////////////⬇️
  //跳转地址
  static Future<String> reqRechargeJumpAddress(
      {required String payEngName}) async {
    int cmdId = 383031;
    var data = {
      'paramsJson': json.encode({
        'tid': AppConfigs.tid,
        'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
        'sourceType': payEngName // 'BoBiWallet1Pay',
      })
    };
    var res = await NetworkService().request(cmdId, data: data, isApiV2: true);
    // print("查询跳转地址结果是：${res}   请求参数：${data}");
    if (res.data['code'] == 200) {
      String jumpStr = res.data['data']?["jump_url"] ?? '';
      return jumpStr;
    } else {
      EasyLoading.showToast(res.data['msg']);
    }
    return '';
  }

  //用户是否绑定
  static Future<ThirdWalletBean?> reqUserBindStatus(
      {required String payEngName}) async {
    int cmdId = 383033;
    var data = {
      'paramsJson': json.encode({
        'tid': AppConfigs.tid,
        'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
        'sourceType': payEngName // 'BoBiWallet1Pay',
      })
    };
    var res = await NetworkService().request(cmdId, data: data, isApiV2: true);
    print("查询是否绑定结果是：${res}   请求参数：${data}");
    if (res.data['code'] == 200) {
      return ThirdWalletBean.fromJson(res.data['data']);
    }
    return null;
  }

  //查询用户信息
  static Future<WalletBean?> reqRechargeUserInfo(
      {required String payEngName}) async {
    int cmdId = 383030;
    var data = {
      'paramsJson': json.encode({
        'tid': AppConfigs.tid,
        'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
        'sourceType': payEngName,
      })
    };
    var res = await NetworkService().request(
      cmdId,
      data: data,
      isApiV2: false,
    );
    print("查询用户信息结果是：${res}   请求参数：${data}");
    return res.data['data'] != null
        ? WalletBean.fromJson(res.data['data'])
        : null;
  }

  //查询注册、绑定地址
  static Future<String?> reqRegisterAddress(
      {required String payEngName, Map<String, String>? thirdData}) async {
    int cmdId = 383032;
    var tempData = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
      'sourceType': payEngName,
    };
    if (thirdData != null) {
      thirdData.forEach((key, value) {
        tempData[key] = value;
      });
    }
    var data = {'paramsJson': json.encode(tempData)};
    var res = await NetworkService().request(cmdId, data: data, isApiV2: true);
    print("查询注册绑定地址结果是：${res}   请求参数：${data}");
    if (res.data?['code'] != 200) {
      Get.snackbar("绑定失败!", "${res.data?['msg'] ?? res.data?['own']}");
      return null;
    }
    return res.data['data']?['reg_url'] ?? "";
  }

  //查询数字钱包实时汇率
  static Future<String?> reqRates({required String payEngName}) async {
    int cmdId = 383035;
    var tempData = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
      'sourceType': payEngName,
      'bizType': 1,
    };
    var data = {'paramsJson': json.encode(tempData)};
    var res = await NetworkService().request(cmdId, data: data, isApiV2: true);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['data'] is Map) {
        Map dataMap = res.data['data'];
        if (dataMap.containsKey('cryptoRate')) {
          return res.data['data']['cryptoRate'].toString();
        }
      }
    }
    return null;
  }

  //查询提现数字钱包实时汇率
  static Future<String?> reqPayoutsRates() async {
    int cmdId = 383035;
    var tempData = {
      'tid': AppConfigs.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
      'sourceType': "qryDefRateHttp",
      'channelId': "USDT-TRC20",
      'bizType': 2,
    };
    var data = {'paramsJson': json.encode(tempData)};
    var res = await NetworkService().request(cmdId, data: data, isApiV2: true);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data['data'] is Map) {
        Map dataMap = res.data['data'];
        if (dataMap.containsKey('cryptoRate')) {
          return res.data['data']['cryptoRate'].toString();
        }
      }
    }
    return null;
  }

  //发送验证码
  static Future<NetworkResponse> sendThirdCode(
      {required String payEngName, required String phone}) async {
    int cmdId = 383034;
    var data = {
      'paramsJson': json.encode({
        'tid': AppConfigs.tid,
        'cust_id': LoginManager.instance.loginInfo!.custId.toInt(),
        'sourceType': payEngName,
        '3rdPhone': phone,
      })
    };
    return await NetworkService().request(cmdId, data: data, isApiV2: true);
  }

  /////////////////////////////////////////////////////////⬆️
  /// 获取用户是否在禁用名单
  static Future<NetworkResponse> reqDiscountInfo() async {
    int cmdId = 3101453;
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'cust_id': LoginManager.instance.loginInfo!.custId,
    };

    // discountInfo
    return NetworkService().request(
      cmdId,
      data: data,
    );
  }

  /// 获取线下充值的配置
  static Future<NetworkResponse> reqOffineConfig() async {
    int cmdId = 370730;
    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      'option_code': 'OFFLINE_RECHARGE_LIMIT',
    };

    return NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }

  /// 忘记密码
  static Future<NetworkResponse> reqForgetPassword(
      Map<String, dynamic> params) async {
    int cmdId = 31011103;

    var data = {
      'tid': TenantManager.instance.tenantBean!.tid,
      ...params,
    };

    return NetworkService().request(
      cmdId,
      data: data,
      headerType: 2,
      paramType: 0,
      isApiV2: false,
      logError: true,
    );
  }
}
