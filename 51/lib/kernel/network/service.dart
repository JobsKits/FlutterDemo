import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_tiyu_app/kernel/configs/app_configs.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';

import 'helper.dart';

class NetworkService {
  late Dio dio;
  static String _baseURL = '';
  static String _hostName = '';
  static String _imageURL = '';
  static int _languageNum = 0;
  Map<String, int> _failureCounts = {}; // 记录每个 baseURL 的失败次数

  NetworkService._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseURL,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        // 其他全局配置
      ),
    );
  }

  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  void setBaseURL(String url) {
    _baseURL = url;
    _hostName = Uri.parse(_baseURL).host;
    dio.options.baseUrl = _baseURL;

    if (url.isNotEmpty) {
      _failureCounts = {_baseURL: 0};
    }
  }

  void setImageURL(String url) {
    _imageURL = url;
  }

  // 多语言列表
  // banner 公告等接口后端需要传对应的语言数字
  // 0中文 1英语 2越南语 3泰语 4马来语 5印尼语 6葡萄牙语 7西班牙 9波兰语 10保加利亚语 11土耳其语 12日语 13韩语 14法语 15俄罗斯 16阿拉伯
  // 17意大利 18南非祖鲁 19罗马尼亚语 20德语 21匈牙利 22中文繁体 23印地语 24捷克语 25希腊语 26波斯语
  void setLanguageNum(String countryCode) {
    Map<String, int> numbers = {
      'cn': 0,
      'en': 1,
      'vi': 2,
      'th': 3,
      'ms': 4,
      'id': 5,
      'pt': 6,
      'es': 7,
      'pl': 9,
      'bg': 10,
      'tr': 11,
      'ja': 12,
      'ko': 13,
      'fr': 14,
      'ru': 15,
      'ar': 16,
      'it': 17,
      'zu': 18,
      'ro': 19,
      'de': 20,
      'hu': 21,
      'zh': 22,
      'hi': 23,
      'cs': 24,
      'el': 25,
      'fa': 26,
      'bn': 28,
    };
    _languageNum = numbers[countryCode] ?? 0;
  }

  String get baseURL => _baseURL;
  String get hostName => _hostName;
  String get imageURL => _imageURL;

  static final List<int> pingCmdIds = []; // 正在请求的接口id
  static final List<int> restrictCmdIds = []; // 限制重复请求的接口id
  // 需要限制的接口id
  static final List<int> needRestrictCmdIds = [
    320604, // 投注接口
    341400, // 线下充值
    341200, // 提现
    394012, // 任务领取
    374002, // 签到
    340334, // 转入保险箱
    340335, // 转入余额
    321543, // 第三方游戏状态
    314501, // 请求第三方游戏url
    374001, // 晋级奖励和俸禄领取
    310136, // 绑定银行卡验证密码
    310400, // 绑定银行卡
    400088, // 追号【一键开启】功能
    340234, // 查询余额
    371130, // 域名租户关系
    320567, // 收藏
  ];

  static const String networkTypeError = 'error';
  static const String networkTypeSuccess = 'success';

  Future<NetworkResponse> request(
    int cmdId, {
    bool isApiV2 = false,
    required dynamic data,
    int paramType = 0,
    int headerType = 2,
    bool logError = false,
  }) async {
    // if (restrictCmdIds.contains(cmdId)) {
    //   return NetworkResponse(networkTypeError, '重复提交===>$cmdId');
    // }
    pingCmdIds.add(cmdId);
    if (needRestrictCmdIds.contains(cmdId)) {
      restrictCmdIds.add(cmdId);
    }
    Map<String, dynamic> headers = {};
    String signature = '';
    if (headerType == 1) {
      const grantType = 'password';
      const scope = 'read write';
      headers['Cmdid'] = cmdId;
      headers['Aseqid'] = AppConfigs.aseqId;
      signature =
          'react_clientgrant_type=${grantType}scope=${scope}cmd_id=${cmdId}react';
    } else if (headerType == 2) {
      headers['Cmdid'] = cmdId;
      String accessToken = '';
      if (LoginManager.instance.loginInfo != null) {
        accessToken = LoginManager.instance.loginInfo!.accessToken ?? "";
      }
      final authorization = 'Bearer $accessToken';
      headers['Authorization'] = authorization;
      signature =
          'react_clientauthorization=${authorization}cmd_id=${cmdId}react';
    } else if (headerType == 3) {
      // 刷新AccessToken接口 2, 370432
    }

    headers['Signature'] = md5.convert(utf8.encode(signature)).toString();
    // print('Signature: ${headers['Signature']}');

    // int tid = 0;
    // if (TenantManager.instance.tenantBean != null) {
    //   tid = TenantManager.instance.tenantBean!.tid;
    // }
    headers['Tid'] = AppConfigs.tid;

    // headerType==2时， 需要该值， 其他情况不需要鉴权
    headers['Custid'] = headerType == 2 ? 0 : '';
    if (LoginManager.instance.loginInfo != null && headerType == 2) {
      headers['Custid'] = '${LoginManager.instance.loginInfo!.custId}';
    }
    // headers['Custid'] = 150;
    headers['Content-Type'] = 'application/x-www-form-urlencoded';
    headers['Accept'] =
        'application/json, application/xml, text/play, text/html, *.*';

    // reqMake
    int t = DateTime.now().millisecondsSinceEpoch;
    String hashInput = Random().nextDouble().toString() + t.toString();
    String rk = md5.convert(utf8.encode(hashInput)).toString().substring(0, 8);
    String vk = AppConfigs.vk;
    String pwd = enP(rk, vk, t);
    String sendDateStr = enD(rk, t.toString());
    String checkor = enC(rk, vk, sendDateStr);
    headers['Checkor'] = checkor;
    headers['Pwds'] = pwd;
    headers['Datetime'] = t;
    headers['Aseqid'] = AppConfigs.aseqId;
    headers['Tbc'] = md5
        .convert(utf8.encode('${t}fT6phq0wkOPRlAoyToidAnkogUV7tBBD'))
        .toString();
    headers['Nc'] = cmdId == 371130 ? '2' : '1';
    headers['Reqid'] = uuid(32, 16);
    headers['isMobileOpen'] = '1';
    headers['languagenum'] = _languageNum;
    headers['Platform'] = getBetPlatform2();
    headers['Project'] = 'tiyu-app';

    String url = '/api/v1/';
    if (cmdId == 371138) {
      url = '/api/v3/';
      headers['Tid'] = '';
    } else if (isApiV2) {
      url = '/api/v2/';
    }
    String sendStr = enD(rk, formatSendData(data, paramType));
    // if (cmdId == 301) {
    //   print('url:$_baseURL$url');
    //   print('headers:$headers');
    //   print('data:$data');
    // }

    CancelToken cancelToken = CancelToken();
    try {
      Response response = await dio.request(
        url,
        data: sendStr,
        options: Options(
          method: 'POST',
          headers: headers,
          responseType: ResponseType.plain,
        ),
        cancelToken: cancelToken,
      );
      if (pingCmdIds.contains(cmdId)) {
        pingCmdIds.remove(cmdId);
      }
      if (restrictCmdIds.contains(cmdId)) {
        restrictCmdIds.remove(cmdId);
      }
      _failureCounts[_baseURL] = 0;
      // print('域名${_baseURL}访问成功');
      // print('response:${response.data}');
      // if (cmdId == 301) {
      //   print('response:${response.data}');
      // }
      NetworkError err = NetworkError(cmd: cmdId);
      if (response.data is String && (response.data as String).isNotEmpty) {
        String rpwds = '';
        if (response.headers.value('pwds') != null) {
          rpwds = response.headers.value('pwds')!;
        }
        String rcheckor = '';
        if (response.headers.value('checkor') != null) {
          rcheckor = response.headers.value('checkor')!;
        }
        String rdatetime = '';
        if (response.headers.value('datetime') != null) {
          rdatetime = response.headers.value('datetime')!;
        }
        if (rpwds.isNotEmpty && rcheckor.isNotEmpty && rdatetime.isNotEmpty) {
          String recData = response.data;
          String dpwd = dnP(AppConfigs.vk, rpwds);
          String drk = dpwd.substring(0, 8);
          String dm = dnD(drk, recData);
          if (dm.isNotEmpty) {
            String recDateStr = enD(drk, rdatetime);
            String dc = enC(drk, AppConfigs.vk, recDateStr);
            if (dc == rcheckor) {
              // bool consoleUsable = cmdId == 320542;
              // if (consoleUsable) {
              //   String jsonString = jsonEncode(dm);
              //   debugPrint(jsonString, wrapWidth: 1024);
              // }
              // print('des dm:$dm');
              // if (cmdId == 301) {
              //   print('dm:${dm}');
              // }
              final resData = jsonDecode(dm);
              // print('des dm:$dm');
              if (resData is Map && resData['exLevel'] != null) {
                // 接口请求的错误处理
                err = NetworkError(
                  tag: 'Network error 3',
                  info: resData['exMessage'] ?? '请求异常',
                  origin: dm,
                  cmd: cmdId,
                  code: ensureInt(resData['exCode']),
                );
                // 版本号不对，强制更新
                if (err.code == 1108) {
                  err.update = true;
                } else if ([1200, 1201, 1109, 1112, 1202, 1007]
                    .contains(err.code)) {
                  // 1200 refresh_token错误
                  // 1201 access_token错误
                  // 1112 IP限制
                  err.logout = true; // 退出登录
                  err.tag = 'Network error 4';
                }

                // 打印以及抛错
                if (logError) err.log();
                return NetworkResponse(networkTypeError, err);
              } else {
                return NetworkResponse(networkTypeSuccess, resData);
              }
            }
          }
        }
      }
      return NetworkResponse(networkTypeError, err);
    } on DioException catch (e) {
      // print('域名${_baseURL} 异常${e.toString()}');
      if (_baseURL.isNotEmpty) {
        _failureCounts[_baseURL] = (_failureCounts[_baseURL] ?? 0) + 1;
        // print('域名${_baseURL}失败次数${_failureCounts[_baseURL]}');
        if (_failureCounts[_baseURL]! >= 3) {
          _failureCounts[_baseURL] = 0;
          if (AppManager.instance.isFront) {
            AppManager.instance.updateBaseUrl();
          }
        }
      }

      NetworkError err = NetworkError(cmd: cmdId);
      // err.info2 = e.toString();
      return NetworkResponse(networkTypeError, err);
    }
  }

  Future<List<String>> domainsFromFile() async {
    const List<String> strList = [
      'https://x01pjdbaa.oss-cn-beijing.aliyuncs.com/',
      'https://chengdu01xpj-1334233659.cos.ap-chengdu.myqcloud.com/',
      'https://gitee.com/shilin001/vue/raw/master/',
      'https://app-line-hk-6586.s3.ap-east-1.amazonaws.com/'
    ];

    const String fileName = 'Num23Tid251.txt';
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    for (final str in strList) {
      final String url = '$str$fileName';
      try {
        final List<String> urlList = await _fetchAndParseUrl(dio, url);
        if (urlList.isNotEmpty) {
          // print('${url}返回:${urlList}');
          return urlList;
        }
      } catch (e) {
        print("Failed to fetch URL from $url: $e");
      }
    }
    return [];
  }

  Future<List<String>> _fetchAndParseUrl(Dio dio, String url) async {
    try {
      final response = await dio.get(url);
      if (response.data == null) {
        throw Exception("Response data is null");
      }
      String content = decryptDomain(response.data);
      if (content.isEmpty) {
        throw Exception("Decrypted content is empty");
      }
      final domains = jsonDecode(content);
      if (domains is! List) {
        throw Exception("Parsed JSON is not a List");
      }
      List<String> parsedUrls = [];
      for (var domain in domains) {
        if (domain is Map<String, dynamic> && domain.containsKey('url')) {
          parsedUrls.add(domain['url']);
        }
      }
      return parsedUrls;
    } catch (e, stackTrace) {
      print("Failed to fetch and parse URL: $url, $e");
      // print(stackTrace);
      return [];
    }
  }

  static String videoBaseURL = 'https://www.hfkbd0.com/';
  static Dio _dioVideo = Dio(BaseOptions(baseUrl: videoBaseURL, headers: {
    'accept': 'application/json',
  }));

  static initVideoInfo(String? url) {
    if (url != null && url.isNotEmpty) {
      videoBaseURL = url;
      _dioVideo = Dio(BaseOptions(baseUrl: videoBaseURL, headers: {
        'accept': 'application/json',
      }));
    }
  }

  static Future<NetworkResponse> videoGet(String endpoint,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      var response =
          await _dioVideo.get(endpoint, queryParameters: queryParameters);
      if (response.data['code'] == 200) {
        return NetworkResponse(networkTypeSuccess, response.data['data']);
      } else {
        return NetworkResponse(networkTypeError, '');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);
        print(e.response!.headers);
        print(e.response!.requestOptions);
      } else {
        print(e.requestOptions);
        print(e.message);
      }
      return NetworkResponse(networkTypeError, '');
    }
  }
}

class NetworkResponse {
  final String type;
  final dynamic data;

  NetworkResponse(this.type, this.data);

  @override
  String toString() {
    return 'NetworkResponse{type: $type, data: $data}';
  }
}
