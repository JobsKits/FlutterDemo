import 'dart:io';

import 'package:flutter/services.dart';

//ios原生通信
class NativeWebView {
  static const _iosChannel = MethodChannel('native_webview');

  static const _androidChannel = MethodChannel('native_webview_channel');

  static Future<void> open(String url, String title) async {
    try {
      if (Platform.isIOS) {
        await _iosChannel.invokeMethod('openWebView', {
          'url': url,
          'title': title,
        });
      } else if (Platform.isAndroid) {
        await _androidChannel.invokeMethod('openWebView', {
          'urlString': url,
          'titleString': title,
        });
      } else {
        throw UnsupportedError('Unsupported platform');
      }
    } on PlatformException catch (e) {
      print('Failed to open native webview: ${e.message}');
    }
  }
}
