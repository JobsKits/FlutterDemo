import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OpenSharePlugin {
  static const MethodChannel _channel = MethodChannel('open_share_plugin');

  /// 获取安装参数
  static Future<String> getInstallParams() async {
    try {
      final String result = await _channel.invokeMethod('getInstallParams');
      return result;
    } catch (e) {
      debugPrint('获取安装参数异常: ${e}');
      return '';
    }
  }
}
