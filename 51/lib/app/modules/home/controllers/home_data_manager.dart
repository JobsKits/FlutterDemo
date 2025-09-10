import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/api/login_api.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/data/home_main_info_bean.dart';
import 'package:flutter_tiyu_app/app/data/home_rank_list_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/InboxMsgItemBean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/balance_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/my_message_bean.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/sp_util.dart';
import '../../../data/login_bean.dart';

class HomeRequestManager extends GetxService {
  static HomeRequestManager get to => Get.find<HomeRequestManager>();

  RxList<HomeRankListBean> rankList = <HomeRankListBean>[].obs;
  List<GameLotteryItemBean> gameLotteryData = <GameLotteryItemBean>[].obs;
  Rx<HomeMainInfoBean> homeMainInfoBean = HomeMainInfoBean().obs;
  RxInt unReadCount = 0.obs;
  RxString balanceStr = "".obs;

  /// 统一的请求入口，发起所有数据请求
  Future<void> fetchAllData() async {
    //拿取一次UserInfo，看看是否已登录
    LoginBean? loginBean = await SpUtil.getBean<LoginBean>("loginBean", (json) {
      return LoginBean.fromJson(json);
    });
    LoginManager.instance.setLoginBean(loginBean);
    try {
      await Future.wait([
        _safeRequest(reqRankList, 'RankList'),
        _safeRequest(reqHomeData, 'HomeData'),
      ]);
    } catch (e) {
      print("fetchAllData 请求出错：$e");
    }
  }

  /// 封装请求方法，单独处理每个请求的异常
  Future<void> _safeRequest(
      Future<void> Function() requestFunction, String requestName) async {
    try {
      await requestFunction();
    } catch (e) {
      print("请求 $requestName 出错：$e");
      return Future.error("$requestName 请求失败");
    }
  }

  /// 请求排行榜数据
  Future<void> reqRankList() async {
    try {
      final rankRes = await HomeApi.getRankList();
      if (rankRes.data['data'] is List) {
        // 数据转换
        List<HomeRankListBean> tempList = (rankRes.data['data'] as List)
            .map((item) => HomeRankListBean.fromJson(item))
            .take(3)
            .toList();
        rankList.value = tempList;
      }
    } catch (e) {
      print("reqRankList 请求失败: $e");
      throw Exception("获取排行榜数据失败");
    }
  }

  GameChessAndElectronicBean? gameChessAndElectronicBean;

  /// 请求首页主要数据
  Future<void> reqHomeData() async {
    try {
      HomeMainInfoBean? spHomeData;
      try {
        spHomeData = await SpUtil.getBean<HomeMainInfoBean>("homeBean", (json) {
          return HomeMainInfoBean.fromJson(json);
        });
      } catch (e) {
        print('保存对象失败: $e');
      }
      if (spHomeData != null) {
        homeMainInfoBean.value = spHomeData;
      }
      final res = await HomeApi.reqHomeData();
      if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
        homeMainInfoBean.value = HomeMainInfoBean.fromJson(res.data);
        SpUtil.saveBean<HomeMainInfoBean>("homeBean", homeMainInfoBean.value);
      }
    } catch (e) {
      print("reqHomeData 请求失败: $e");
      throw Exception("获取首页数据失败");
    }
  }

  /// 请求彩票数据
  Future<void> reqLotteryData() async {
    try {
      final res = await HomeApi.reqLotteryData();
      if (res.type == NetworkService.networkTypeSuccess && res.data != null) {
        var gameLotteryBean = GameLotteryBean.fromJson(res.data);
        gameLotteryData = gameLotteryBean.data ?? [];
      }
    } catch (e) {
      print("reqLotteryData 请求失败: $e");
      throw Exception("获取彩票数据失败");
    }
  }

  Future<void> reqMessage() async {
    try {
      int unReadCount = 0; //未读数量
      List<InboxMsgItemBean> inboxList = await UserApi().reqInboxMsg();
      unReadCount += inboxList.where((item) => item.type == 0).toList().length;
      MyMessageBean? messageBean = await UserApi().reqMyMsg();
      if (messageBean != null && messageBean.data != null) {
        List<MyMessageItemBean> myMsgList = messageBean.data!;
        unReadCount += myMsgList.where((item) => item.state != 9).length;
      }
      this.unReadCount.value = unReadCount;
    } catch (e) {
      print("reqMessage 请求失败: $e");
      throw Exception("获取通知数据失败");
    }
  }

  // 获取账户余额
  Future<void> reqMoney() async {
    try {
      if (TenantManager.instance.tenantBean != null &&
          LoginManager.instance.loginInfo != null) {
        final res = await LoginApi.reqBalance();
        if (res.type == NetworkService.networkTypeSuccess) {
          BalanceBean balance = BalanceBean.fromJson(res.data);
          LoginManager.instance.setUserBalanceBean(balance);
          balanceStr.value = (balance.balance! / 1000).truncateToFixed(2);
        } else {
          if (res.data is NetworkError) {
            NetworkError error = res.data;
            error.log();
            if (error.logout) {
              Get.snackbar("登录已过期！", "请重新登录");
              LoginManager.instance.clear();
            }
          }
        }
      }
    } catch (e) {
      print("reqMoney 请求失败: $e");
      throw Exception("获取Money数据失败");
    }
  }
}
