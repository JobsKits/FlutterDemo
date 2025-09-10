import 'dart:math';

import 'package:get/get.dart';

import 'commission_rate_model.dart';

///联盟计划-拥挤比例tab-list详细页面自己的controller
class CommissionRateListLogic extends GetxController {
  final modelList = <CommissionRateModel>[].obs;

  int currentPage = 0; //当第几页

  @override
  void onReady() {
    super.onReady();
    loadListData();
  }

  ///加载数据
  loadListData() {
    modelList.clear();
    //随机数量
    var datas = List.generate(
      Random().nextInt(20) ,
      (index) => CommissionRateModel(level: index, validBet: '111.11', rebateAmount: '222.22'),
    ).toList();
    modelList.addAll(datas);
  }
}
