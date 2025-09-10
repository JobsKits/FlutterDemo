import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_plugin_engagelab/flutter_plugin_engagelab.dart';
import 'package:flutter_tiyu_app/api/system_api.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';
import 'package:flutter_tiyu_app/kernel/network/helper.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:htprotect/htprotect.dart';

class AppManager {
  RxBool isVibrationEnabled = true.obs;
  bool isUpdatingBaseUrl = false;
  bool isFront = true; // App是否处于前台

  final _htprotectPlugin = Htprotect();

  AppManager._privateConstructor() {
    _initialize();
  }

  void _initialize() async {
    bool? enabled = await SpUtil.getBool('VibrationEnabled');
    if (enabled == null) {
      await SpUtil.saveBool('VibrationEnabled', true);
      isVibrationEnabled.value = true;
    } else {
      isVibrationEnabled.value = enabled;
    }
  }

  static final AppManager instance = AppManager._privateConstructor();

  void vibrationChanged(bool value) {
    isVibrationEnabled.value = value;
    SpUtil.saveBool('VibrationEnabled', value);
  }

  void tapVibrate() {
    if (isVibrationEnabled.value) {
      // print('震动');
      Vibration.vibrate(duration: 30, amplitude: 80);
    }
  }

  Future<bool> checkNetwork() async {
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    // print('connectivityResult: ${connectivityResult}');
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  Future<void> updateBaseUrl() async {
    if (isUpdatingBaseUrl) return;

    bool hasNetwork = await AppManager.instance.checkNetwork();
    if (!hasNetwork) {
      EasyLoading.show(
        status: '网络未连接，请检查您的网络设置',
        maskType: EasyLoadingMaskType.black,
      );
      return;
    }

    isUpdatingBaseUrl = true;
    NetworkService ns = NetworkService();
    ns.setBaseURL('');
    List<String>? urlList = await SpUtil.getStringList('urlList');
    if (urlList != null && urlList.isNotEmpty) {
      await AppManager.instance.validateAndSetBaseUrl(urlList);
    }
    if (ns.baseURL.isEmpty) {
      List<String> urlList2 =
          await AppManager.instance.fetchAndSaveUrlListFromFile();
      if (urlList2.isNotEmpty) {
        await AppManager.instance.validateAndSetBaseUrl(urlList2);
      }
    }
    if (ns.baseURL.isEmpty) {
      isUpdatingBaseUrl = false;
      Get.offNamed(Routes.MAINTENANCE);
      return;
    }
    // print('选中域名: ${ns.baseURL}');
    isUpdatingBaseUrl = false;
  }

  Future<List<String>> fetchAndSaveUrlListFromFile() async {
    NetworkService networkService = NetworkService();
    List<String> urlList = await networkService.domainsFromFile();
    return urlList;
  }

  Future<bool> validateAndSetBaseUrl(List<String> urlList) async {
    List<String> failedDomain =
        (await SpUtil.getStringList('failedDomain')) ?? [];
    List<String> failedReason =
        (await SpUtil.getStringList('failedReason')) ?? [];
    NetworkService networkService = NetworkService();
    for (var urlStr in urlList) {
      networkService.setBaseURL(urlStr);

      String domainStr = failedDomain.isNotEmpty ? failedDomain.join(',') : '';
      String reasonStr = failedReason.isNotEmpty ? failedReason.join(',') : '';
      // print('上报域名: ${domainStr} ${reasonStr}');
      final res = await SystemApi.checkBaseUrl(domainStr, reasonStr);
      // print('检测${urlStr}返回${res}');
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['list'] is List) {
          List<String> addrList = _processResponseData(res.data['list']);
          if (addrList.isNotEmpty) {
            // print('addrList: ${addrList}');
            failedDomain = [];
            failedReason = [];
            await SpUtil.saveStringList('failedDomain', failedDomain);
            await SpUtil.saveStringList('failedReason', failedReason);
            await SpUtil.saveStringList('urlList', addrList);
            return true;
          } else {
            failedDomain.add(urlStr);
            failedReason.add('addrList is empty');
          }
        } else {
          failedDomain.add(urlStr);
          failedReason.add('list is ${res.data['list']}');
        }
      } else {
        failedDomain.add(urlStr);
        failedReason.add('网络异常');
        // if (res.data is NetworkError) {
        //   NetworkError err = res.data;
        //   failedReason.add(err.info2);
        // } else {
        //   failedReason.add('unknown');
        // }
      }
      networkService.setBaseURL('');
    }
    await SpUtil.saveStringList('failedDomain', failedDomain);
    await SpUtil.saveStringList('failedReason', failedReason);
    return false;
  }

  /*
  Future<bool> validateAndSetBaseUrl(List<String> urlList) async {
    List<String> failedDomain =
        (await SpUtil.getStringList('failedDomain')) ?? [];
    List<String> failedReason =
        (await SpUtil.getStringList('failedReason')) ?? [];
    NetworkService networkService = NetworkService();

    // 用于记录当前检测的失败域名和原因
    List<String> currentFailedDomain = [];
    List<String> currentFailedReason = [];

    for (var urlStr in urlList) {
      networkService.setBaseURL(urlStr);

      // 仅将当前域名的失败信息传递给接口
      String domainStr =
          currentFailedDomain.isNotEmpty ? currentFailedDomain.join(',') : '';
      String reasonStr =
          currentFailedReason.isNotEmpty ? currentFailedReason.join(',') : '';

      final res = await SystemApi.checkBaseUrl(domainStr, reasonStr);

      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['list'] is List) {
          List<String> addrList = _processResponseData(res.data['list']);
          if (addrList.isNotEmpty) {
            // 清空当前的失败记录
            currentFailedDomain = [];
            currentFailedReason = [];
            // 更新保存的失败记录
            await SpUtil.saveStringList('failedDomain', failedDomain);
            await SpUtil.saveStringList('failedReason', failedReason);
            await SpUtil.saveStringList('urlList', addrList);
            return true;
          } else {
            currentFailedDomain.add(urlStr);
            currentFailedReason.add('addrList is empty');
          }
        } else {
          currentFailedDomain.add(urlStr);
          currentFailedReason.add('list is ${res.data['list']}');
        }
      } else {
        currentFailedDomain.add(urlStr);
        currentFailedReason.add('网络异常');
      }

      // 不清空失败记录，保存所有失败的信息
      failedDomain.addAll(currentFailedDomain);
      failedReason.addAll(currentFailedReason);

      networkService.setBaseURL('');
    }

    // 最终保存所有的失败记录
    await SpUtil.saveStringList('failedDomain', failedDomain);
    await SpUtil.saveStringList('failedReason', failedReason);
    return false;
  }
  */

  List<String> _processResponseData(List<dynamic> dataList) {
    List<String> addrList = [];
    for (var info in dataList) {
      if (info is Map<String, dynamic> && info.containsKey('domain_addr')) {
        String addr = decrypt3DES(info['domain_addr']);
        if (addr.isNotEmpty) {
          addrList.add(addr);
        }
      }
    }
    return addrList;
  }

  void getRegistrationId() {
    FlutterPluginEngagelab.getRegistrationId().then((rid) async {
      // print('推送信息rid1: $rid');
      LoginManager.instance.registrationId = rid;
      await SystemApi.addPushInfo();
      SystemApi.updatePushInfo();
    });
  }

  Future<void> initHTP() async {
    final res = await SystemApi.reqConfig('YIDUN_PRODUCT_ID');
    if (res.type == NetworkService.networkTypeSuccess) {
      print('易盾产品编号: ${res.data}');
      String productId = res.data['value'];
      Map<String, dynamic> params = {};
      // params['serverType'] = 1;
      // params['channel'] = 'test';
      // var map1 = {'aa': 'aaa', 'bb': 'bbb'};
      // params['extData'] = map1;

      _htprotectPlugin.init(productId, params: params).then((initResult) {
        var code = initResult['code'];
        if (code == 200) {
          print('易盾初始化成功');
        } else {
          print('易盾初始化失败: ${initResult}');
        }
      });
    }
  }

  // 注册登录保护
  Future<String> getToken1() async {
    String optionCode = '';
    if (Platform.isIOS) {
      optionCode = 'YIDUN_BUSINESS_ID_REGISTER_IOS';
    } else if (Platform.isAndroid) {
      optionCode = 'YIDUN_BUSINESS_ID_REGISTER_ANDROID';
    }

    final res = await SystemApi.reqConfig(optionCode);
    if (res.type == NetworkService.networkTypeSuccess) {
      // print('易盾注册登录业务ID: ${res.data}');
      String businessId = res.data['value'];

      final result = await _htprotectPlugin.getToken(3000, businessId);
      // print('易盾 getToken1 result:$result');
      if (result['token'] != null) {
        return result['token'];
      }
    }

    return '';
  }

  // 手机短信验证
  Future<String> getToken2() async {
    String optionCode = '';
    if (Platform.isIOS) {
      optionCode = 'YIDUN_BUSINESS_ID_SENDSMS_IOS';
    } else if (Platform.isAndroid) {
      optionCode = 'YIDUN_BUSINESS_ID_SENDSMS_ANDROID';
    }

    final res = await SystemApi.reqConfig(optionCode);
    if (res.type == NetworkService.networkTypeSuccess) {
      // print('易盾发送短信业务ID: ${res.data}');
      String businessId = res.data['value'];

      final result = await _htprotectPlugin.getToken(3000, businessId);
      // print('易盾 getToken2 result:$result');
      if (result['token'] != null) {
        return result['token'];
      }
    }

    return '';
  }
}
