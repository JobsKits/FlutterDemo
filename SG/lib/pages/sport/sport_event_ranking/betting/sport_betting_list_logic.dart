import 'package:flutter_bet/generated/l10n.dart';
import 'dart:math';

import 'package:get/get.dart';

import 'sport_betting_item_model.dart';

class SportBettingListLogic extends GetxController {
  final modelList = <SportBettingItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadListData();
  }

  ///加载列表数据
  void loadListData(){
    var tempList = <SportBettingItemModel>[];
    List.generate(/*Random().nextInt(20)+*/10, (index) {
      var model = SportBettingItemModel(
        // type: Random().nextInt(5),
        // level: Random().nextInt(10)+1,
        // money: 2.3223232111111,
        type: 1,
        title: S.current.random_text_495,
        money: -4446.536541,
        coinType: 1,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
  }

}
