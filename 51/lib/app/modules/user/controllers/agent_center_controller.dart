import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/api/agent_center_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/invite_friends_bean.dart';
import 'package:get/get.dart';

import '../data/agent_commission_bean.dart';

class AgentCenterController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  RxInt currentIndex = 0.obs;
  Rxn<InviteFriendsBean> friendBean = Rxn<InviteFriendsBean>();
  Rxn<AgentCommissionBean> agentCommissionBean = Rxn<AgentCommissionBean>();
  List<String> tabList = [
    "邀请",
    "团队",
    "下级",
    "佣金",
  ];
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabList.length, vsync: this);
    reqInviteFriendInfo();
    AgentCenterApi().getMyInviteMoney();
  }

  void reqInviteFriendInfo() async {
    friendBean.value = await AgentCenterApi().inviteFriends();
  }

  void getMyInviteMoney() async {
    agentCommissionBean.value = await AgentCenterApi().getMyInviteMoney();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
