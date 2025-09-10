import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/InboxMsgItemBean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_list_model/feedback_list_model.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/my_message_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/notice_marquee_model/notice_marquee_model.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:get/get.dart';

import '../../tabs/controllers/tabs_controller.dart';
import '../data/system_notify_bean.dart';

class QuestionFeedbackController extends GetxController {
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;
  late TextEditingController feedbackController;
  RxString feedbackContent = "".obs;
  List<String> tabList = [
    "收件箱",
    "系统公告",
    "跑马灯",
    "问题反馈",
    "我的消息",
  ];

  RxInt feedbackCurrentIndex = 0.obs;
  RxDouble giftsAmount = 0.0.obs;
  List<String> feedbackList = [
    "创建反馈",
    "我的反馈",
  ];

  RxInt inboxUnReadCount = 0.obs;
  RxInt myMsgUnReadCount = 0.obs;
  RxInt feedbackUnReadCount = 0.obs;

  RxList<InboxMsgItemBean> inboxList = <InboxMsgItemBean>[].obs; //收件箱列表
  RxList<SystemNotifyItemBean> systemList =
      <SystemNotifyItemBean>[].obs; //系统公告列表
  RxList<MyMessageItemBean> myMsgList = <MyMessageItemBean>[].obs; //我的消息列表
  Rx<NoticeMarqueeModel> notices = NoticeMarqueeModel().obs;

  RxList<FeedbackListModel> feedbackModels = <FeedbackListModel>[].obs; //我的消息列表
  TabsController tabsController = Get.find();
  @override
  void onInit() {
    super.onInit();
    feedbackController = TextEditingController();
    feedbackController.addListener(() {
      feedbackContent.value = feedbackController.text;
    });
    reqInboxMsg();
    reqSystemMsg();
    reqMarqueeList();
    reqMyMsg();
    reqFeedbackList();
    loadFeedbackUnReadBage();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeTabIndex(int index) {
    currentTabIndex.value = index;
  }

  void changeFeedbackIndex(int index) {
    feedbackCurrentIndex.value = index;
  }

  //请求收件箱消息列表
  void reqInboxMsg() async {
    inboxList.value = await UserApi().reqInboxMsg();
    inboxUnReadCount.value = inboxList
        .where((item) => item.type == 0 || item.type == 4)
        .toList()
        .length;
  }

  //请求系统消息列表
  void reqSystemMsg() async {
    SystemNotifyBean? systemNotifyBean = await UserApi().reqSystemMsg();
    if (systemNotifyBean != null && systemNotifyBean.data != null) {
      systemList.value = systemNotifyBean.data!;
    }
  }

  void reqMarqueeList() async {
    final response = await UserApi().reqMarqueeList();
    if (response.type == NetworkService.networkTypeSuccess) {
      notices.value = NoticeMarqueeModel.fromJson(response.data);
    }
  }

  //提交问题反馈
  void sendFeedback() async {
    if (feedbackContent.value.isEmpty) {
      // Get.snackbar("提交失败！", "内容不能为空!");
      EasyLoading.showInfo('内容不能为空!');
      return;
    }
    bool isSuccess = await UserApi().sendFeedback(feedbackContent.value);
    if (isSuccess) {
      feedbackController.text = "";
      EasyLoading.showSuccess('提交成功！');
    }
  }

  //提交问题反馈
  void replyToFeedback(
      FeedbackListModel feedbackModel, Function(String) callback) async {
    if (feedbackContent.value.isEmpty) {
      callback('内容不能为空!');
      return;
    }
    final response = await UserApi()
        .replyToFeedback(feedbackModel.mailId ?? 0, feedbackContent.value);
    if (response) {
      feedbackController.text = "";
      callback('提交成功！');
    }
  }

  //请求我的消息列表
  void reqMyMsg() async {
    MyMessageBean? messageBean = await UserApi().reqMyMsg();
    if (messageBean != null && messageBean.data != null) {
      myMsgList.value = messageBean.data!;
      myMsgUnReadCount.value =
          myMsgList.where((item) => item.state != 9).toList().length;
    }
    myMsgUnReadCount.value = tabsController.messageInstsCount.value;
    feedbackUnReadCount.value = tabsController.feedbackUnReadCount.value;
  }

  void reqFeedbackList() async {
    final response = await UserApi.reqFeedbackList();
    if (response.type == NetworkService.networkTypeSuccess) {
      feedbackModels.value = (response.data as List<dynamic>?)
              ?.map<FeedbackListModel>(
                  (e) => FeedbackListModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      calculateTotalGifts();
    }
  }

  void loadFeedbackUnReadBage() async {
    final response = await UserApi().reqFeedbackNumber();
    if (response.type == NetworkService.networkTypeSuccess) {
      int unRc = response.data;
      feedbackUnReadCount.value = unRc;
    }
  }

  void receiveFeedbackGiftAmount() async {
    final response = await UserApi.receiveFeedbackGiftAmount();
    if (response.type == NetworkService.networkTypeSuccess &&
        response.data['response_code'] == '9999') {
      giftsAmount.value = 0;
      EasyLoading.showSuccess('领取成功');
      reqFeedbackList();
    }
  }

  void calculateTotalGifts() {
    double total = 0.0;
    for (var feedback in feedbackModels) {
      if (feedback.lastSysReply != null &&
          feedback.lastSysReply?.giftAmount != null &&
          feedback.lastSysReply?.giftStatus == 1) {
        total += feedback.lastSysReply?.giftAmount ?? 0;
      }
    }
    giftsAmount.value = total;
  }

  RxInt showUnReadDot(int index) {
    RxInt tempInt = 0.obs;
    switch (index) {
      case 0:
        tempInt = inboxUnReadCount;
        break;
      case 3:
        tempInt = feedbackUnReadCount;
        break;
      case 4:
        tempInt = myMsgUnReadCount;
        break;
      default:
        tempInt = 0.obs;
        break;
    }
    return tempInt;
  }

  //一键已读
  void clickReadingAll() async {
    bool isMsgSuccess = await UserApi().readAllMyMsg();
    if (isMsgSuccess) {
      reqMyMsg();
    }
    bool isInboxSuccess = await UserApi().readAllInBoxMsg();
    if (isInboxSuccess) {
      reqInboxMsg();
    }
  }

  //已读或删除单条我的信息
  void readOrDeleteMyMsg(int index, bool isDelete) async {
    MyMessageItemBean item = myMsgList[index];
    bool isSuccess = await UserApi().readOrDeleteMsg(
        message_inst_id: item.messageInstId!,
        part_mon: item.partMon!,
        state: isDelete ? 100 : 9);
    if (isSuccess) {
      reqMyMsg(); //刷新我的消息列表
    }
  }

  //已读或者删除单个收件箱信息
  void deleteInboxMsg(int index) async {
    InboxMsgItemBean item = inboxList[index];
    bool isSuccess = await UserApi().deleteInBoxMsg(
        mail_id: item.mailId!,
        put_cust_name: item.putCustName!,
        send_cust_name: item.sendCustName!);
    if (isSuccess) {
      reqInboxMsg(); //刷新我的消息列表
    }
  }
}
