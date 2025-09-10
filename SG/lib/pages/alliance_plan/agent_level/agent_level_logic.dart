import 'dart:math';

import 'package:flutter_bet/base/getx/base_controller.dart';
import 'package:get/get.dart';

import 'agent_level_model.dart';
import 'agent_level_state.dart';

class AgentLevelLogic extends BaseController {
  final AgentLevelState state = AgentLevelState();

  final modelList = <AgentLevelModel>[].obs;

  @override
  void onReady() {
    super.onReady();
    loadListData();
  }

  ///加载列表数据
  void loadListData(){
    var tempList = <AgentLevelModel>[];
    List.generate(Random().nextInt(50), (index) {
      var model = AgentLevelModel(
        type: Random().nextInt(5),
        level: Random().nextInt(10)+1,
        money: 2.3223232111111,
      );
      tempList.add(model);
    });
    modelList.addAll(tempList);
  }
}
