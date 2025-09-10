import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/daily_tasks_model/daily_tasks_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_newcomers_model/task_newcomers_model.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import "package:flutter_tiyu_app/constants/activity_constants.dart";
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/kernel/network/error.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';

import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/game_task_tab_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/task/task_detail_dialog.dart';
import 'task_data_process.dart';

class ControllerTaskPage extends GetxController
    with GetTickerProviderStateMixin {
  late PageController pageController;

  RxInt tabCurrentIndex = 0.obs;
  RxInt gameTaskCurrentIndex = 0.obs;

  late TabsController tabsController = Get.find();

  RxList<TaskTabItemBean> tabList = <TaskTabItemBean>[].obs;
  late TabController tabActivityListController;
  late TabController gameTaskTabController;

  final ActivityController actController = Get.find();

  RxInt leftCurrentIndex = 0.obs;
  RxInt taskDurationDisplay = 0.obs;
  RxList defaultLeftTab = [].obs;
  Rx<TaskNewcomersModel> newcommersModel = TaskNewcomersModel().obs;
  RxList<Datum> newcommersList = <Datum>[].obs;

  RxBool isLoading = false.obs;

  // 获取Tab数据项
  TaskTabItemBean getTabItemData(RxInt index) => tabList[index.toInt()];

  // 任务详情
  Rx<TaskDetailBean> taskDetail = TaskDetailBean(
    description: '',
    title: '',
    detail: '',
    scope: '',
    time: '',
    taskType: 0,
  ).obs;
  RxBool isReceiveLoading = false.obs; // 领取奖励loading

  // 会员任务
  RxList<StandaraListBean> memberTaskData = <StandaraListBean>[].obs;
  // 活动奖金
  RxList<StandaraListBean> activeBonusData = <StandaraListBean>[].obs;
  // 游戏任务
  RxList<GameTaskItemBean> gameTaskData = <GameTaskItemBean>[].obs;
  Rx<DailyTasksModel> dailyTasks = DailyTasksModel().obs;

  RxString claimed = '0'.obs; // 已领取
  RxString claimable = '0'.obs; // 可领取

  //------------游戏任务--------------
  List<GameTaskTabBean> defaultGameTaskTab = [
    GameTaskTabBean(tabCal: 0, tabTitle: '全部'),
    GameTaskTabBean(tabCal: 1, tabTitle: '棋牌'),
    GameTaskTabBean(tabCal: 2, tabTitle: '电子'),
    GameTaskTabBean(tabCal: 3, tabTitle: '捕鱼'),
    GameTaskTabBean(tabCal: 4, tabTitle: '彩票'),
    GameTaskTabBean(tabCal: 5, tabTitle: '体育'),
    GameTaskTabBean(tabCal: 6, tabTitle: '真人'),
    GameTaskTabBean(tabCal: 7, tabTitle: '原创'),
  ]; // 全的tab数据
  RxList<GameTaskTabBean> gameTaskTabData =
      <GameTaskTabBean>[].obs; // 真实的游戏任务tab

  RxString imgDomain = ''.obs;

  RxBool isClickJump = false.obs; // 是否点击跳转

  @override
  onInit() async {
    super.onInit();
    tabActivityListController = TabController(length: 0, vsync: this); // 先初始化为0
    gameTaskTabController = TabController(length: 0, vsync: this); // 先初始化为0

    pageController = PageController(initialPage: 0);

    // imgDomain.value = await TenantManager.instance.getCurrentImgDomain();
    // Tabs数据获取
    await requestActivityData();
    await requestNewcomersWelfareData();

    ever(actController.taskTabIndex, (value) {
      if (actController.taskTabIndex > 0) {
        final index = tabList.indexWhere((tab) => tab.type == value);
        jumpToPage(index);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (actController.taskTabIndex > 0) {
        final index = tabList
            .indexWhere((tab) => tab.type == actController.taskTabIndex.value);
        jumpToPage(index);
      }
    });

    // 监听登录
    ever(LoginManager.instance.isLogin, (isLogin) async {
      await requestActivityData();
      await requestNewcomersWelfareData();
    });

    ever(tabsController.currentIndex, (index) async {
      var isOpenVideo = TenantManager.instance.tenantBean?.isOpenVideo == 'true';
      final signInIndex = actController.activityData.indexWhere(
        (activity) => activity.title == '任务',
      );
      if (index == (isOpenVideo ? 3 : 2) && actController.currentTabIndex.value == signInIndex && LoginManager.instance.isLogin.value == true) {
        await requestActivityData();
        await requestNewcomersWelfareData();
      }
    });
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    tabActivityListController.dispose();
    gameTaskTabController.dispose();
    super.onClose();
  }

  /// 请求任务列表tab数据
  requestActivityData() async {
    print({'requestActivityData ==========='});
    final res = await ActivityApi.reqTaskListData();

    if (res.type == NetworkService.networkTypeSuccess) {
      final resultData = res.data;
      if (resultData is List) {
        resultData.forEach((element) {
          element['standaraList'] = TakDataProcess.standaraProcess(
              element['standara'],
              itemBean: element);
        });

        final resultTaskTabData = TaskTabBean.fromJson(resultData).data ?? [];

        final newList = resultTaskTabData.where((o) {
          if (o.standaraList != null && o.standaraList is List) {
            return true;
          }
          return false;
        }).toList();

        newList.sort((a, b) => a.sort_v!.compareTo(b.sort_v!));

        tabList.value = newList;

        // 只在第一次加载或更新数据时创建 tabActivityListController
        if (tabActivityListController.length != newList.length) {
          tabActivityListController.dispose(); // 先释放旧的控制器
          tabActivityListController =
              TabController(length: newList.length, vsync: this);
        }

        if (newList.isNotEmpty && !defaultLeftTab.contains('会员任务')) {
          defaultLeftTab.insert(defaultLeftTab.contains('新人福利') ? 1 : 0, '会员任务');
        }
      }

      tabChangeRefresh();
    }

    // 通知 UI 更新
    update();
  }

  requestNewcomersWelfareData() async {
    final res = await ActivityApi.reqNewcomersWelfareData();
    print({'requestNewcomersWelfareData == ${res}'});
    if (res.type == NetworkService.networkTypeSuccess) {
      newcommersModel.value = TaskNewcomersModel.fromJson(res.data);
      newcommersList.value = newcommersModel.value.data ?? [];
      taskDurationDisplay.value = newcommersModel.value.t?.taskDurationDisplay ?? 0;

      if (newcommersList.isNotEmpty && !defaultLeftTab.contains('新人福利') && newcommersModel.value.t != null) {
        defaultLeftTab.insert(0, '新人福利');
      }
    }
  }

  Future<void> reqNewcomersTaskReceive(Datum model) async {
    EasyLoading.show();
    isReceiveLoading.value = true;

    try {
      final res = await ActivityApi.reqActivityReceive(model.receiveLogId);
      if (res.type == NetworkService.networkTypeSuccess && res.data['response_code'] == '9999') {
        EasyLoading.showSuccess("领取成功");
        model.status = 3;
      }
    } finally {
      EasyLoading.dismiss();
      isReceiveLoading.value = false;
    }
  }

  // tab改变数据的刷新
  tabChangeRefresh() {
    final tabItem = getTabItemData(tabCurrentIndex);

    // 根据选中的 tab 类型执行请求
    switch (tabItem.type) {
      // 游戏任务
      case ActivityConstants.ACTIVITY_TYPE_110:
        requestGamesMissionData(forceRefresh: false);
        break;
      // 会员任务
      case ActivityConstants.ACTIVITY_TYPE_112:
        requestMemberMissionData(forceRefresh: false);
        break;
      // 活动奖金
      case ActivityConstants.ACTIVITY_TYPE_113:
        requestActiveBonusData(forceRefresh: false);
        break;
      case ActivityConstants.ACTIVITY_TYPE_204:
        requestActiveTaskData(forceRefresh: false);
        break;
      default:
        break;
    }
  }

  // 页面跳转
  jumpToPage(int index, {bool? needAnimate = true}) {
    tabCurrentIndex.value = index;

    if (needAnimate == true) {
      pageController.jumpToPage(index);
      // pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.ease);
    }

    tabChangeRefresh();
  }

  // 设置任务详情数据
  void setTaskDetailData(StandaraListBean item) {
    TaskTabItemBean taskItemData = tabList[tabCurrentIndex.value];

    String taskText = taskItemData.represent ?? '';
    num startTime = item.startTime ?? 0;
    num endTime = item.endTime ?? 0;

    Map<String, dynamic> jsonMap = {
      'title': '',
      'scope': '',
      'detail': '',
      'description': '',
      'time':
          '${DateTimeUtils.formatTimestamp(startTime.toInt())}~${DateTimeUtils.formatTimestamp(endTime.toInt())}',
      'taskType': taskItemData.type!,
    };

    // 充值大礼包
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_101) {
      jsonMap['title'] = (item.standara_name ?? '').isEmpty
          ? '充值满${parseNumber(item.fraction)}金币可领取'
          : item.standara_name;

      jsonMap['scope'] = '全充值方式';
      jsonMap['description'] = (item.explains ?? '').isEmpty
          ? (taskText.isEmpty ? '每日充值任务，实时结算，实时可领，每天24点重置更新。' : taskText)
          : item.explains;
    }

    // 天天得意金
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_102) {
      jsonMap['title'] = (item.standara_name ?? '').isEmpty
          ? '有效投注满${parseNumber(item.fraction)}金币可领取'
          : item.standara_name;

      jsonMap['scope'] = '在禁用列表的游戏打码不被统计在该活动';
      jsonMap['description'] = (item.explains ?? '').isEmpty
          ? (taskText.isEmpty ? '每日打码任务，实时结算，实时可领，每天24点重置更新。' : taskText)
          : item.explains;
    }

    // 亏损救援金 | 新增的 救援金活动
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_103 ||
        taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_203) {
      jsonMap['title'] = (item.standara_name ?? '').isEmpty
          ? '亏损满${parseNumber(item.fraction)}金币可领取'
          : item.standara_name;

      jsonMap['scope'] = '在禁用列表的游戏打码不被统计在该活动';
      jsonMap['description'] = (item.explains ?? '').isEmpty
          ? (taskText.isEmpty ? '每日亏损任务，每日结算，隔天可领，每天24点重置更新。' : taskText)
          : item.explains;
    }

    // 虚拟币充值
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_111) {
      jsonMap['title'] = (item.standara_name ?? '').isEmpty
          ? '充值满${parseNumber(item.fraction)}虚拟币可领取'
          : item.standara_name;

      jsonMap['scope'] = '虚拟币充值方式';
      jsonMap['description'] = (item.explains ?? '').isEmpty
          ? (taskText.isEmpty ? '每日虚拟币充值任务，实时结算，实时可领，每天24点重置更新。' : taskText)
          : item.explains;
    }

    // 会员任务
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_112) {
      jsonMap['title'] = item.standara_name ?? '';
      jsonMap['scope'] = item.scope ?? '';
      jsonMap['description'] =
          (item.explains ?? '').isEmpty ? taskText : item.explains;
    }

    // 活动奖金
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_113) {
      jsonMap['description'] = (item.explains ?? '').isEmpty
          ? '${DateTimeUtils.formatTimestamp(endTime.toInt())}前领取'
          : item.explains;

      jsonMap['title'] = item.standara_name ?? '';
      jsonMap['detail'] = item.desc_info ?? '';
    }

    // 活动奖金
    if (taskItemData.type!.toInt() == ActivityConstants.ACTIVITY_TYPE_204) {
      jsonMap['description'] =
          (item.explains ?? '').isEmpty ? taskText : item.explains;

      jsonMap['title'] = item.standara_name ?? '';
      jsonMap['detail'] = item.desc_info ?? '';
    }

    taskDetail.value = TaskDetailBean.fromJson(jsonMap);

    Get.dialog(const TaskDetailDialog(), barrierDismissible: false);
  }

  // 刷新
  Future<void> requestRefresh() async {
    try {
      EasyLoading.show(status: '加载中...');

      int? type = tabList[tabCurrentIndex.value].type;
      isLoading.value = true;

      // 游戏任务
      // if (type == ActivityConstants.ACTIVITY_TYPE_110) {
      //   await requestGamesMissionData();
      //   //会员任务
      // } else if (type == ActivityConstants.ACTIVITY_TYPE_112) {
        await requestMemberMissionData();
      //   // 活动奖金
      // } else if (type == ActivityConstants.ACTIVITY_TYPE_113) {
      //   await requestActiveBonusData();
      // } else if (type == ActivityConstants.ACTIVITY_TYPE_204) {
      //   await requestActiveTaskData();
      // } else {
      //   // 活动列表数据
      //   await requestActivityData();
      // }
    } finally {
      EasyLoading.dismiss();
      isLoading.value = false;
    }
  }

  // 请求任务奖励
  Future<void> reqReceiveTaskReward(
    int receiveLevel,
    int type,
    num reward,
    num percentage,
    num completed,
  ) async {
    try {
      isReceiveLoading.value = true;

      num realAmount = 0;
      if (percentage.toInt() == 1) {
        realAmount = ((completed / 1000) * reward) / 100;
      } else {
        realAmount = reward;
      }

      num amount = double.parse(realAmount.truncateToFixed(3)) * 1000;

      final res = await ActivityApi.reqReceiveTaskReward(
        receiveLevel: receiveLevel,
        type: type,
        amount: parseNumber(amount),
      );

      // 成功
      if (res.type == NetworkService.networkTypeSuccess) {
        final responseData = res.data;

        if (responseData['response_code'] == '9999') {
          EasyLoading.showSuccess('领取成功');
          await LoginManager.instance.reqMoney();
          requestRefresh(); // 刷新数据
        } else if (responseData['response_code'] == '0') {
          EasyLoading.showError('暂时无法领取，请联系客服');
        }
      } else {
        EasyLoading.showError('领取失败');
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }

  /// 游戏任务，数据复杂，还需梳理！！！
  requestGamesMissionData({bool? forceRefresh = true}) async {
    /// 当 forceRefresh = false 且 当前tab缓存有数据时不请求
    if (forceRefresh != null && !forceRefresh && activeBonusData.isNotEmpty) {
      return;
    }

    bool hasLoading = forceRefresh == false;
    try {
      if (hasLoading) EasyLoading.show(status: '加载中...');

      final res = await ActivityApi.reqGameMissionData();

      if (res.type == NetworkService.networkTypeSuccess) {
        List<GameTaskItemBean> data =
            GameTaskBean.fromJson(res.data).data ?? [];

        gameTaskData.value = await TakDataProcess.parseGameTaskData(data);

        final newList = defaultGameTaskTab.where((tabItem) {
          if (tabItem.tabCal == 0) {
            return true;
          }
          bool hasCal = false;
          for (int i = 0; i < gameTaskData.length; i++) {
            final item = gameTaskData[i];
            if (item.cal == tabItem.tabCal) {
              hasCal = true;
              break;
            }
          }
          return hasCal;
        }).toList();

        int count1 = 0;
        int count2 = 0;
        gameTaskData.forEach((ele) {
          if (ele.is_draw == 1) {
            count1 += 1;
          } else if (ele.is_draw == 2) {
            count2 += 1;
          }
        });
        claimed.value = parseNumber(double.parse('$count1'));
        claimable.value = parseNumber(double.parse('$count2'));

        gameTaskTabData.value = newList;

        // 只在第一次加载或更新数据时创建 gameTaskTabController
        if (gameTaskTabController.length != newList.length) {
          gameTaskTabController.dispose(); // 先释放旧的控制器
          gameTaskTabController =
              TabController(length: newList.length, vsync: this)
                ..addListener(() {
                  if (gameTaskTabController.indexIsChanging) {
                    gameTaskCurrentIndex.value = gameTaskTabController.index;
                    // gameTaskTabController.animateTo(gameTaskTabController.index);
                  }
                });
        }

        if (data.isNotEmpty && !defaultLeftTab.contains('会员任务')) {
          defaultLeftTab.insert(defaultLeftTab.contains('新人福利') ? 1 : 0, '会员任务');
        }
      }
    } finally {
      if (hasLoading) EasyLoading.dismiss();
    }
  }

  /// 获取活动奖金数据 , 该接口需要登录才能调用！！！
  requestActiveBonusData({bool? forceRefresh = true}) async {
    /// 非强制刷新
    /// 当 forceRefresh = false 且 当前tab缓存有数据时不请求
    if (forceRefresh != null && !forceRefresh && activeBonusData.isNotEmpty) {
      return;
    }

    bool isLogin = LoginManager.instance.isLogin.value;
    if (!isLogin) {
      return;
    }

    bool hasLoading = forceRefresh == false;
    try {
      if (hasLoading) EasyLoading.show(status: '加载中...');

      final res = await ActivityApi.reqTaskActivityBonusData();

      if (res.type == NetworkService.networkTypeSuccess) {
        List<dynamic> data = res.data;
        activeBonusData.value = TakDataProcess.parseActiveBonusData(data);

        if (activeBonusData.isNotEmpty && !defaultLeftTab.contains('会员任务')) {
          defaultLeftTab.insert(defaultLeftTab.contains('新人福利') ? 1 : 0, '会员任务');
        }
      }
    } finally {
      if (hasLoading) EasyLoading.dismiss();
    }
  }

  /// 获取活动奖金数据 , 该接口需要登录才能调用！！！
  requestActiveTaskData({bool? forceRefresh = true}) async {
    /// 非强制刷新
    /// 当 forceRefresh = false 且 当前tab缓存有数据时不请求
    if (forceRefresh != null && !forceRefresh && activeBonusData.isNotEmpty) {
      return;
    }

    bool isLogin = LoginManager.instance.isLogin.value;
    if (!isLogin) {
      return;
    }

    bool hasLoading = forceRefresh == false;
    try {
      if (hasLoading) EasyLoading.show(status: '加载中...');

      final res = await ActivityApi.reqActivityDailyTaskData();
      if (res.type == NetworkService.networkTypeSuccess) {
        dailyTasks.value = DailyTasksModel.fromJson(res.data);
        print({'dailyTasks ==========${dailyTasks.toJson()}'});
        if (!defaultLeftTab.contains('会员任务')) {
          defaultLeftTab.insert(defaultLeftTab.contains('新人福利') ? 1 : 0, '会员任务');
        }
      }
    } finally {
      if (hasLoading) EasyLoading.dismiss();
    }
  }

  /// 领取活动奖金奖励
  Future<void> reqReceiveTaskActivityBonus(StandaraListBean itemData) async {
    try {
      isReceiveLoading.value = true;
      final res = await ActivityApi.reqReceiveTaskActivityBonus(
        taskId: itemData.task_id!,
        id: itemData.id!,
      );

      if (res.type == NetworkService.networkTypeSuccess) {
        EasyLoading.showSuccess('领取成功');
        await LoginManager.instance.reqMoney();
        requestRefresh(); // 刷新数据
      } else {
        EasyLoading.showError('领取失败');
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }

  /// 领取活动奖金奖励
  Future<void> reqReceiveDailyTaskData(int receiveLogId) async {
    try {
      isReceiveLoading.value = true;
      final res = await ActivityApi.reqReceiveDailyTaskData(
        receiveLogId,
      );

      if (res.type == NetworkService.networkTypeSuccess) {
        EasyLoading.showSuccess('领取成功');
        await LoginManager.instance.reqMoney();
        requestRefresh(); // 刷新数据
      } else {
        EasyLoading.showError('领取失败');
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }

  /// 获取会员任务, 数据处理逻辑复杂，还需梳理 ！！！
  requestMemberMissionData({bool? forceRefresh = true}) async {
    /// 非强制刷新
    /// 当 forceRefresh = false 且 当前tab缓存有数据时不请求
    if (forceRefresh != null && !forceRefresh && memberTaskData.isNotEmpty) {
      return;
    }

    bool hasLoading = forceRefresh == false;

    try {
      if (hasLoading) EasyLoading.show(status: '加载中...');

      final res = await ActivityApi.reqTaskMemberMissionData();

      if (res.type == NetworkService.networkTypeSuccess) {
        List<MemberTaskItemBean> data =
            MemberTaskBean.fromJson(res.data).data ?? [];

        memberTaskData.value = TakDataProcess.parseUserTaskData(data);

        if (memberTaskData.isNotEmpty && !defaultLeftTab.contains('会员任务')) {
          defaultLeftTab.insert(defaultLeftTab.contains('新人福利') ? 1 : 0, '会员任务');
        }
      }
    } finally {
      if (hasLoading) EasyLoading.dismiss();
    }
  }

  /// 领取会员任务奖励
  Future<void> reqReceiveTaskMemberMission(StandaraListBean itemData) async {
    try {
      isReceiveLoading.value = true;
      final res = await ActivityApi.reqReceiveTaskMemberMission(
        standaraNumber: itemData.standaraNumber!,
        standaraType: itemData.standaraType!,
        alreadyNumber: itemData.alreadyNumber!,
        custTaskId: itemData.custTaskId!,
      );

      if (res.type == NetworkService.networkTypeSuccess) {
        final responseData = res.data;

        if (responseData['response_code'] == '9999') {
          EasyLoading.showSuccess('领取成功');
          await LoginManager.instance.reqMoney();
          requestRefresh(); // 刷新数据
        }
      } else {
        if (res.data is NetworkError) {
          NetworkError error = res.data;
          EasyLoading.showError(error.info);
        } else {
          EasyLoading.showError('领取失败');
        }
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }

  // 修改跳转值
  void setIsClickJump(bool val) {
    isClickJump.value = val;
  }

  // 点击领取
  Future<void> handleReceive({
    required bool isAll,
    GameTaskItemBean? item,
  }) async {
    try {
      isReceiveLoading.value = true;

      List<Map<String, dynamic>> dataList = [];
      // 全部领取
      if (isAll) {
        for (int i = 0; i < gameTaskData.length; i++) {
          var curItem = gameTaskData[i];
          // 可以领取
          if (curItem.is_draw == 2) {
            dataList.add({
              'mission_objective_id': curItem.mission_objective_id,
              'bet_amout': curItem.bet_amout,
              'bet_loss_amout': curItem.bet_loss_amout,
            });
          }
        }
      } else {
        dataList.add({
          'mission_objective_id': item!.mission_objective_id,
          'bet_amout': item!.bet_amout,
          'bet_loss_amout': item!.bet_loss_amout,
        });
      }

      final response = await ActivityApi.reqReceiveGameTask(dataList);

      if (response.type == NetworkService.networkTypeSuccess) {
        if (response.data['response_code'] == '9999') {
          requestRefresh(); // 刷新数据
          EasyLoading.showSuccess('领取成功');
          await LoginManager.instance.reqMoney();
        } else if (response.data['response_code'] == '8888') {
          EasyLoading.showError('暂时无法领取，请联系客服');
        }
      } else {
        EasyLoading.showError('领取失败');
      }
    } finally {
      isReceiveLoading.value = false;
    }
  }

  bool getIsEmpty(TaskTabItemBean taskItemData) {
    int type = taskItemData.type!.toInt();

    // 游戏任务
    if (type == ActivityConstants.ACTIVITY_TYPE_110) {
      return gameTaskData.isEmpty;
    }

    // 会员任务
    if (type == ActivityConstants.ACTIVITY_TYPE_112) {
      return memberTaskData.isEmpty;
    }

    // 活动奖金
    if (type == ActivityConstants.ACTIVITY_TYPE_113) {
      return activeBonusData.isEmpty;
    }

    // 日常任务
    if (type == ActivityConstants.ACTIVITY_TYPE_204) {
      return (dailyTasks.value.day ?? []).isEmpty &&
          (dailyTasks.value.week ?? []).isEmpty &&
          (dailyTasks.value.month ?? []).isEmpty;
    }

    // 其他任务
    return (taskItemData.standaraList ?? []).isEmpty;
  }
}
