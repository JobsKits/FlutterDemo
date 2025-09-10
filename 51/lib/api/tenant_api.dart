import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';

class TenantApi {
  /// 请求Aseq 配置 (系统配置相关的)
  static Future<NetworkResponse> reqAseq() async {
    int cmdId = 370433;

    return await NetworkService().request(
      cmdId,
      isApiV2: true,
      data: [AppConfigs.aseqId],
      paramType: 2,
      headerType: 1,
      logError: true,
    );
  }

  /// 请求租户信息
  static Future<NetworkResponse> reqTenantInfo() async {
    // 通过域名地址获取租户信息
    int cmdId = 371130;

    String domainAddr = NetworkService().baseURL;
    var data = {
      'domain_addr': domainAddr,
      'language': '0',
    };
    int paramType = 0;

    return await NetworkService().request(
      cmdId,
      data: data,
      paramType: paramType,
      headerType: 1,
      logError: true,
    );
  }

  /// 请求租户信息
  static Future<NetworkResponse> reqRepairData() async {
    int cmdId = 371138;

    var data = {'domain_addr': NetworkService().baseURL};

    return await NetworkService().request(
      cmdId,
      data: data,
      headerType: 1,
      paramType: 0,
      logError: true,
    );
  }
}
