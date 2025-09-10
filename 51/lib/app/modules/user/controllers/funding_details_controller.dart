import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/funding_details_bean.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';

class FundingDetailsController extends GetxController {
  GlobalKey typeKey = GlobalKey(); //类型的key
  GlobalKey timeKey = GlobalKey(); //时间的key
  double typeWidgetHeight = 0; //类型组件的高度
  double timeWidgetHeight = 0; //时间组件的高度
  RxInt currentTypeIndex = 0.obs;
  RxInt currentTimeIndex = 0.obs;
  RxString currentTypeName = "全部类型".obs;
  int currentType = 0; //当前用于接口请求的type
  int currentDate = 0; //当前用于接口请求的日期
  int currentPage = 1; //当前页数
  RxBool isLoading = false.obs;
  bool hasMore = false; //是否还有必要加载更多
  RxString currentTimeName = "今日".obs;
  RxList<FundingData> fundingList = <FundingData>[].obs;
  late ScrollController scrollController;
  //资金类型列表
  List<Map<String, dynamic>> typeList = [
    {'trans_type': 0, 'text': '全部'},
    {'trans_type': 1, 'text': '充值记录'},
    {'trans_type': 3, 'text': '提现记录'},
    {'trans_type': 5, 'text': '投注返水'},
    {'trans_type': 8, 'text': '代理返点'},
    {'trans_type': 6, 'text': '充值优惠'},
    {'trans_type': 11, 'text': '余额转换'},
    {'trans_type': 17, 'text': '活动礼金'},
    {'trans_type': 18, 'text': '代理转账'},
    {'trans_type': 16, 'text': '红包雨'},
    {'trans_type': 19, 'text': '其它'},
  ];
  //资金条目类型列表
  Map<int, List<Map<String, dynamic>>> typeSecondList = {
    1: [
      {'trans_type': 200, 'text': '自助充值'},
      {'trans_type': 701, 'text': '手工充值'},
    ],
    3: [
      {'trans_type': 900, 'text': '提款中'},
      {'trans_type': 901, 'text': '提款失败'},
      {'trans_type': 902, 'text': '提款'},
    ],
    5: [
      {'trans_type': 350, 'text': '自助领取'},
      {'trans_type': 414, 'text': '人工赠送'},
      {'trans_type': 999, 'text': '系统派送'},
    ],
    6: [
      {'trans_type': 398, 'text': '手动添加奖金'},
      {'trans_type': 399, 'text': '首次充值奖金'},
      {'trans_type': 712, 'text': '渠道充值奖金'},
    ],
    17: [
      {'trans_type': 402, 'text': '注册奖金'},
      {'trans_type': 403, 'text': '首次登录奖金'},
      {'trans_type': 404, 'text': '签到奖金'},
      {'trans_type': 703, 'text': '晋级VIP奖金'},
      {'trans_type': 702, 'text': '周俸禄'},
      {'trans_type': 704, 'text': '月俸禄'},
      {'trans_type': 419, 'text': '推荐奖金'},
      {'trans_type': 412, 'text': '分享领工资'},
      {'trans_type': 405, 'text': '亏损救援金'},
      {'trans_type': 418, 'text': '转盘奖金'},
      {'trans_type': 888, 'text': '红包雨奖金'},
      {'trans_type': 417, 'text': '会员任务'},
      {'trans_type': 411, 'text': '游戏任务'},
      {'trans_type': 9999991, 'text': '其他'},
    ],
  };
  List<Map<String, dynamic>> timeList = [
    {"timeTitle": "今日", "date": 0},
    {"timeTitle": "昨日", "date": 1},
    {"timeTitle": "近3日", "date": 3},
    {"timeTitle": "近7日", "date": 7},
    {"timeTitle": "近15日", "date": 15},
    {"timeTitle": "近30日", "date": 30},
  ];
  @override
  void onInit() async {
    super.onInit();
    scrollController = ScrollController();
    refreshData(); //请求明细列表数据
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isLoading.value) {
        loadMoreData();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 在构建完成后执行
      var typeBox = (typeKey.currentContext!.findRenderObject() as RenderBox);
      typeWidgetHeight =
          typeBox.localToGlobal(Offset.zero).dy + typeBox.size.height;

      var timeBox = (timeKey.currentContext!.findRenderObject() as RenderBox);
      timeWidgetHeight =
          timeBox.localToGlobal(Offset.zero).dy + timeBox.size.height;
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void changeTypeIndex(int index) {
    currentTypeIndex.value = index;
  }

  void changeTimeIndex(int index) {
    currentTimeIndex.value = index;
  }

  void updateType() {
    if (currentType == typeList[currentTypeIndex.value]["trans_type"] &&
        currentTypeName == typeList[currentTypeIndex.value]["text"]) {
      return; //如果名字和类型都是之前的，就没必要更新
    }
    currentTypeName.value = typeList[currentTypeIndex.value]["text"];
    currentType = typeList[currentTypeIndex.value]["trans_type"];
    refreshData();
  }

  void updateTime() {
    if (currentDate == timeList[currentTimeIndex.value]["date"] &&
        currentTimeName == timeList[currentTimeIndex.value]["timeTitle"]) {
      return; //如果名字和类型都是之前的，就没必要更新
    }
    currentTimeName.value = timeList[currentTimeIndex.value]["timeTitle"];
    currentDate = timeList[currentTimeIndex.value]["date"];
    refreshData();
  }

  List<int> genReqType() {
    if (currentType == 0) {
      List<int> transTypeList =
          typeList.map((item) => item['trans_type'] as int).toList();
      transTypeList.add(34); // 34=PG结算
      return transTypeList;
    } else {
      return [currentType];
    }
  }

  Future<void> refreshData() async {
    currentPage = 1;

    fundingList.value = await UserApi.reqFundingDetailsData(
        reqType: genReqType(), time: currentDate, page: currentPage);
    hasMore = fundingList.length == 10; //如果长度等于10，表示刚好请求到足够的数据，所以可以进行下一页的请求
  }

  loadMoreData() async {
    if (hasMore) {
      //如果经过判断，有更多数据，才执行加载更多
      isLoading.value = true;
      currentPage += 1;
      var netList = await UserApi.reqFundingDetailsData(
          reqType: genReqType(), time: currentDate, page: currentPage);
      hasMore = netList.length == 10;
      fundingList.addAll(netList);
      isLoading.value = false;
    }
  }
}
