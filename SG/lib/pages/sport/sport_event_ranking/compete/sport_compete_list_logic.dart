import 'dart:math';

import 'package:get/get.dart';

import 'sport_compete_item_model.dart';

class SportCompeteListLogic extends GetxController {

  final modelList = <SportCompeteItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadListData();
  }

  ///加载列表数据
  void loadListData(){
    var tempList = <SportCompeteItemModel>[];
    List.generate(/*Random().nextInt(20)+*/10, (index) {
      var model = SportCompeteItemModel(
        // type: Random().nextInt(5),
        // level: Random().nextInt(10)+1,
        // money: 2.3223232111111,
        // type: 1,
        // title: '复式投注 (2)',
        // money: -4446.536541,
        // coinType: 1,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
  }


}
