//视频模块的api
import 'package:flutter_tiyu_app/app/modules/video/data/video_category_bean.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_detail_bean.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_home_bean.dart';
import 'package:flutter_tiyu_app/app/modules/video/data/video_home_tab_bean.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';

import '../kernel/network/service.dart';

class VideoApi {
  //请求视频导航栏
  static Future<List<VideoHomeTabBean>> reqTabData() async {
    List<VideoHomeTabBean> dataList = [];
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'user_id': loginInfo?.uid ?? 1,
    };
    final res = await NetworkService.videoGet('/api/video/nav',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (var item in res.data) {
          dataList.add(VideoHomeTabBean.fromJson(item));
        }
      }
    }
    return dataList;
  }

  //请求视频首页数据
  static Future<List<VideoHomeBean>> reqVideoHomeData() async {
    List<VideoHomeBean> dataList = [];
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'user_id': loginInfo?.uid ?? 1,
    };
    final res = await NetworkService.videoGet('/api/video/home',
        queryParameters: parameters);

    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (var item in res.data) {
          dataList.add(VideoHomeBean.fromJson(item));
        }
      }
    }
    return dataList;
  }

  //请求视频详情数据
  static Future<VideoDetailBean?> reqVideoDetailData(int videoId) async {
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'id': videoId,
      'user_id': loginInfo?.uid ?? 1,
    };
    final res = await NetworkService.videoGet('/api/video/detail',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      return VideoDetailBean.fromJson(res.data);
    }
    return null;
  }

  //请求视频详情猜你喜欢列表
  static Future<List<VideoSecondList>> reqVideoDetailLikeData(
      int videoId) async {
    List<VideoSecondList> dataList = [];
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'id': videoId, // 当前视频id
      'user_id': loginInfo?.uid ?? 1,
    };
    final res = await NetworkService.videoGet('/api/video/getRelateList',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        for (var item in res.data) {
          dataList.add(VideoSecondList.fromJson(item));
        }
      }
    }
    return dataList;
  }

  //视频分类后的列表
  static Future<List<VideoSecondList>> reqVideoList(
      {required int id,
      required String type,
      int page = 1,
      int pageSize = 6,
      bool isBlack = false}) async {
    List<VideoSecondList> dataList = [];
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'user_id': loginInfo?.uid ?? 1,
      'type': type, // cate:分类，label:标签，hot:热门，last:最新，max:播放次数最多
      'id': id, // 国产 分类或标签id 如果是热门传0
      'page': page,
      'size': pageSize,
    };
    if (isBlack) {
      //如果是黑料，才添加此参数
      parameters["only_topic"] = 1;
    }
    final res = await NetworkService.videoGet('/api/video/getList',
        queryParameters: parameters);
    print("视频数据：$type   id:$id  isBlack：$isBlack  parameters:$parameters");
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data["list"] is List) {
        for (var item in res.data["list"]) {
          dataList.add(VideoSecondList.fromJson(item));
        }
      }
    }
    return dataList;
  }

  //获取视频分类列表
  static Future<List<VideoCategoryBean>> reqVideoCategoryList() async {
    List<VideoCategoryBean> dataList = [];
    Map<String, dynamic> parameters = {};
    final res = await NetworkService.videoGet('/api/video/getCateList',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      if (res.data is List) {
        List cateList = res.data;
        for (var item in cateList) {
          dataList.add(VideoCategoryBean.fromJson(item));
        }
      }
    }
    return dataList;
  }

  //获取视频搜索结果列表
  static Future<List<VideoSecondList>> searchVideo(String keyword) async {
    List<VideoSecondList> dataList = [];
    final loginInfo = LoginManager.instance.loginInfo;
    Map<String, dynamic> parameters = {
      'user_id': loginInfo?.uid ?? 1,
      'keyword': keyword,
      'page': 1,
      'size': 10,
    };
    final res = await NetworkService.videoGet('/api/video/search',
        queryParameters: parameters);
    if (res.type == NetworkService.networkTypeSuccess) {
      print(
          'current_page: ${res.data['current_page']}, last_page: ${res.data['last_page']}');
      if (res.data['data'] is List) {
        for (var item in res.data["data"]) {
          dataList.add(VideoSecondList.fromJson(item));
        }
      }
    }
    return dataList;
  }
}
