import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tiyu_app/app/data/video_domain.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/data/tenant_bean.dart';

String uuid(int? len, int? radix) {
  const chars =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  final rng = Random();
  radix ??= chars.length;

  if (len != null) {
    // Compact form
    return List.generate(len, (_) => chars[rng.nextInt(radix!)]).join('');
  } else {
    // rfc4122, version 4 form
    final uuid = List<String>.filled(36, '', growable: false);
    int r;

    // rfc4122 requires these characters
    uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
    uuid[14] = '4';

    for (var i = 0; i < 36; i++) {
      if (uuid[i] == '') {
        r = rng.nextInt(16);
        uuid[i] = chars[i == 19 ? (r & 0x3) | 0x8 : r];
      }
    }

    return uuid.join('');
  }
}

int randomInteger(int low, int high) {
  final random = Random();
  return low + random.nextInt(high - low + 1);
}

String strPadLeft(String str, int length) {
  if (str.length >= length) {
    return str;
  } else {
    return strPadLeft('0$str', length);
  }
}

// 获取平台
String getBetPlatform() {
  // 5=PC; 7=HOMESCREEN_IOS; 6=HOMESCREEN_ANDROID; 4=H5_IOS 3=IOS 2=H5_ANDROID; 1=ANDROID 8=马甲包
  if (Platform.isIOS) {
    return 'FLUTTER_IOS';
  } else if (Platform.isAndroid) {
    return 'FLUTTER_ANDROID';
  }
  return 'FLUTTER';
}

String getBetPlatform2() {
  // 5=PC; 7=HOMESCREEN_IOS; 6=HOMESCREEN_ANDROID; 4=H5_IOS 3=IOS 2=H5_ANDROID; 1=ANDROID 8=马甲包
  if (Platform.isIOS) {
    return 'IOS';
  } else if (Platform.isAndroid) {
    return 'ANDROID';
  }
  return 'FLUTTER';
}

int getBetPlatform3() {
  // 最后登录方式,5-pc登录4-H5苹果登录3-APP苹果登录2-H5安卓登录1-APP安卓登录
  if (Platform.isIOS) {
    return 3;
  } else if (Platform.isAndroid) {
    return 1;
  }
  return 0;
}

// 图片线路探测
Future<String> reqImgsUrl(List<ImgsDomain> payload) async {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 3),
    ),
  );
  for (int index = 0; index < payload.length; index++) {
    String? domainAddr = payload[index].domainAddr;
    if (domainAddr != null && domainAddr.isNotEmpty) {
      // if (!domainAddr.endsWith('/')) {
      //   domainAddr += '/';
      // }
      try {
        final response = await dio.get('$domainAddr/test.txt',
            options: Options(
              responseType: ResponseType.plain, // 设定为简单文本响应
              receiveTimeout: const Duration(seconds: 3), // 设置超时时间为3秒
            ));
        if (response.statusCode == 200) {
          return domainAddr; // 返回找到的可用域名地址
        }
      } catch (e) {
        // print('域名$domainAddr 检测异常:$e');
      }
    }
  }
  return ''; // 没有找到可用的服务器，返回空字符串
}

// 视频线路探测
Future<String> reqVideosUrl(List<VideoDomain> payload) async {
  final Dio dio = Dio();
  for (int index = 0; index < payload.length; index++) {
    String? domainAddr = payload[index].domainAddr;
    if (domainAddr != null && domainAddr.isNotEmpty) {
      try {
        if (!domainAddr.contains("https://")) {
          domainAddr = "https://$domainAddr";
        }
        final response = await dio.get('$domainAddr',
            options: Options(
              receiveTimeout: const Duration(seconds: 3), // 设置超时时间为3秒
            ));
        if (response.statusCode == 200) {
          return domainAddr; // 返回找到的可用域名地址
        }
      } on DioException catch (e) {
        if (e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionTimeout) {
          // 处理超时错误，继续检测下一个服务器
        } else {
          // 其他错误处理，继续检测下一个服务器
        }
      }
    }
  }
  return ''; // 没有找到可用的服务器，返回空字符串
}

/// 获取设备唯一ID
Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String deviceId;
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    deviceId = iosInfo.identifierForVendor!;
  } else if (Platform.isAndroid) {
    String? androidId = await const AndroidId().getId();
    deviceId = androidId ?? '';
  } else {
    deviceId = '';
  }
  return deviceId;
}

/// 获取设备版本号
Future<String> getDeviceVersion() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String version = '';
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
    version = iosInfo.systemVersion;
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
    version = androidInfo.version.sdkInt.toString();
  }
  return version;
}

// 根据Locale翻译传入的中文内容
String translate(String zhStr) {
  // 获取应用当前设置的Locale
  Locale locale = Locale('en');
  // 根据languageCode从翻译文件中返回对应的内容，翻译文件为JSON格式
  // 支持中文简体、繁体，英文，印度语

  return '';
}

String getChanCode() {
  if (Platform.isIOS) {
    return 'IOS';
  } else if (Platform.isAndroid) {
    return 'ANDROID';
  }
  return 'MWEB';
}

Future<String> fetchVersionInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;
  String fixNumber = '001';
  return '$version($buildNumber) $fixNumber';
}
