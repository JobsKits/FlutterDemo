import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';

void main() {
  test('获取视频线路', () async {
    int cmdId = 373133;
    var data = {
      'tid': 3,
      'domain_type': '8',
    };
    final res = await NetworkService().request(
      cmdId,
      data: data,
      paramType: 0,
      headerType: 1,
    );
    // print('res data: ${res.data}');
    if (res.type == NetworkService.networkTypeSuccess) {
      // https://www8002-dev.wcmb86-cdn.com
      // https://livedev-k8s.qucacz.cn
      // https://cejriyqw.wcmb86-cdn.com
      if (res.data is List) {
        for (Map domainInfo in res.data) {
          print('domain_line_id: ${domainInfo['domain_line_id']}');
          print('domain_addr: ${domainInfo['domain_addr']}');
          print('state: ${domainInfo['state']}');
        }
      }
    }
  });

  test('导航栏', () async {
    // var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
    // NetworkService.setVideoBaseURL(url:videoBaseURL);
    Map<String, dynamic> parameters = {
      'user_id': 1,
    };
    final res = await NetworkService.videoGet('/api/video/nav',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      // print(res.data);
      if (res.data is List) {
        for (Map info in res.data) {
          print('name:${info['name']}, id:${info['id']}, type:${info['type']}');
        }
      }
    }
  });

  // 91video.html
  test('首页视频接口', () async {
    // var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
    // NetworkService.setVideoBaseURL(videoBaseURL);
    Map<String, dynamic> parameters = {
      'domain_type': 8,
      'tid': 3,
    };
    final res = await NetworkService.videoGet('/api/video/home',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      // print('data:${jsonEncode(res.data)}');
      List list = res.data;
      for (Map item in list) {
        print('title: ${item['title']}, type: ${item['type']}');
        if (item['list'] is List) {
          for (Map videoItem in item['list']) {
            print('\t id: ${videoItem['id']}');
            print('\t title: ${videoItem['title']}');
            print('\t upload_thumb: ${videoItem['upload_thumb']}');
            print('\t href: ${videoItem['href']}');
            print('\t-----');
          }
        }
      }
    }
  });

  test('视频列表', () async {
    Map<String, dynamic> parameters = {
      'type': 'cate', // cate:分类，label:标签，hot:热门，last:最新，max:播放次数最多
      'id': 130, // 国产 分类或标签id 如果是热门传0
      'only_topic': 1,
      'user_id': 1,
      'page': 1,
      'size': 1,
    };
    final res = await NetworkService.videoGet('/api/video/getList',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      print(res.data);
    }
  });

  // test('获取分类', () async {
  //   // var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   // NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     // 'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/video/getCateList',
  //       queryParameters: parameters);
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       print('分类:');
  //       List cateList = res.data;
  //       for (Map cate in cateList) {
  //         print('classify:${cate['classify']}, id:${cate['id']},');
  //       }
  //     }
  //   }
  // });
  //
  // test('分类中视频列表', () async {
  //   Map<String, dynamic> parameters = {
  //     'user_id': 1,
  //     'type': 'cate',
  //     'id': 111, // 日本AV
  //     'page': 1,
  //     'size': 10,
  //   };
  //   final res = await NetworkService.videoGet('/api/video/getList',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data['list'] is List) {
  //       for (Map videoItem in res.data['list']) {
  //         print('id: ${videoItem['id']}');
  //         print('title: ${videoItem['title']}');
  //         print('href: ${videoItem['href']}');
  //         print('upload_thumb: ${videoItem['upload_thumb']}');
  //         print('watchtimes: ${videoItem['watchtimes']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });
  //
  // test('视频搜索列表', () async {
  //   Map<String, dynamic> parameters = {
  //     'user_id': 1,
  //     'keyword': '123',
  //     'page': 1,
  //     'size': 10,
  //   };
  //   final res = await NetworkService.videoGet('/api/video/search',
  //       queryParameters: parameters);
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print(
  //         'current_page: ${res.data['current_page']}, last_page: ${res.data['last_page']}');
  //     if (res.data['data'] is List) {
  //       for (Map videoItem in res.data['data']) {
  //         print('id: ${videoItem['id']}');
  //         print('title: ${videoItem['title']}');
  //         print('href: ${videoItem['href']}');
  //         print('upload_thumb: ${videoItem['upload_thumb']}');
  //         print('-----');
  //       }
  //     }
  //   }
  // });

  // test('视频详情', () async {
  //   // var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   // NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     'id': 68715,
  //     'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/video/detail',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print("data:${jsonEncode(res.data)}");
  //   }
  // });

  // test('获取所有广告位', () async {
  //   var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/index/getAllAd',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print(res.data);
  //   }
  // });
  //
  // test('获取单个广告', () async {
  //   var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     /**
  //      * 1=>'首页的顶部轮播(375x135)'
  //      * 2=>'首页广告(390x104)'
  //      * 3=>'播放页下方广告1(355 x 90)'
  //      * 4=> '播放器上面第一个图片广告位(172.5*117)'
  //      * 5 => '首页弹窗广告位(262.5x393.75)'
  //      * 6 => '首页中间广告位图片+文字展示(50.83 x 50.83)'
  //      * 9 => '播放器下面第二个广告位 文字广告'
  //      * 10 => '猜你喜欢视频列表插入广告(165x108.9)'
  //      * 11 => '首页中间广告位2()'
  //      * 12 => '首页最新上传旁广告'
  //      * 13 => '插放页猜你喜欢旁广告'
  //      * 14 => '最下端广告位(375x93.75)'
  //      */
  //     'type': 2,
  //     'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/index/images',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print(res.data);
  //   }
  // });
  //
  // test('获取站点配置', () async {
  //   var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/index/config',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print(res.data);
  //   }
  // });
  //
  // test('获取站点配置', () async {
  //   var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
  //   NetworkService.setVideoBaseURL(videoBaseURL);
  //   Map<String, dynamic> parameters = {
  //     'user_id': 1,
  //   };
  //   final res = await NetworkService.videoGet('/api/index/config',
  //       queryParameters: parameters);
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     print(res.data);
  //   }
  // });
  //
  test('猜你喜欢', () async {
    // var videoBaseURL = 'https://www8002-dev.wcmb86-cdn.com';
    // NetworkService.setVideoBaseURL(videoBaseURL);
    Map<String, dynamic> parameters = {
      'id': 68715, // 当前视频id
      'user_id': 1,
    };
    final res = await NetworkService.videoGet('/api/video/getRelateList',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      print(res.data);
    }
  });

  // test('获取标签', () async {
  //   Map<String, dynamic> parameters = {};
  //   final res = await NetworkService.videoGet('/api/video/getLabelList',
  //       queryParameters: parameters);
  //   // print('res data: ${res.data}');
  //   if (res.type == NetworkService.networkTypeSuccess) {
  //     if (res.data is List) {
  //       print('标签:');
  //       List cateList = res.data;
  //       for (Map cate in cateList) {
  //         print('${cate['classify']}');
  //       }
  //     }
  //   }
  // });
}
