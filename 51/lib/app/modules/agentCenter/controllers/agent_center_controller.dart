import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../data/agent_center_tab_bean.dart';
import '../views/share/agent_center_share_view.dart';
import '../views/data/agent_center_data_view.dart';
import '../views/finance/agent_center_finance_view.dart';
import '../views/member/agent_center_member_view.dart';

class AgentCenterController extends GetxController
    with GetTickerProviderStateMixin {
  RxInt currentTabIndex = 0.obs;

  late PageController pageController;
  // TAB数据
  late RxList<AgentCenterTabBean> agentCenterData = <AgentCenterTabBean>[].obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();

    pageController = PageController(initialPage: 0);
    tabController = TabController(length: 0, vsync: this);

    _initData();
  }

  @override
  void onClose() {
    tabController.dispose();
    pageController.dispose();
    super.onClose();
  }

  void _initData() {
    tabController.dispose(); // 先卸载

    List<AgentCenterTabBean> baseData = [
      AgentCenterTabBean(
        title: '推广分享',
        child: const AgentCenterShareView(),
        show: true,
      ),
      AgentCenterTabBean(
        title: '推广数据',
        child: const AgentCenterDataView(),
        show: true,
      ),
      AgentCenterTabBean(
        title: '业绩/会员',
        child: const AgentCenterMemberView(),
        show: true,
      ),
      AgentCenterTabBean(
        title: '财务报表',
        child: const AgentCenterFinanceView(),
        show: true,
      ),
    ].where((ele) => ele.show).toList();

    agentCenterData.value = baseData;
    tabController = TabController(length: baseData.length, vsync: this);
  }

  // 页面跳转
  jumpToPage(int index) {
    currentTabIndex.value = index;
    tabController.animateTo(index);
    pageController.jumpToPage(index);
  }
}
