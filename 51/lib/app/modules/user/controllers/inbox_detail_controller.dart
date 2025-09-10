import 'package:flutter/cupertino.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/inbox_detail_msg_item_bean.dart';
import 'package:get/get.dart';

import '../../../../utils/login_manager.dart';
import '../../../../utils/tenant_manager.dart';
import '../../home/controllers/new_home_controller.dart';

class InboxDetailController extends GetxController {
  String title = "";
  late int mail_id;
  late String send_cust_name;
  late String put_cust_name;
  String content = "";
  String topContent = "";
  int sendTime = 0;
  RxString userHead = "".obs;
  RxInt isReply = 0.obs;
  late TextEditingController contentController;
  late NewHomeController homeController = Get.find();
  RxList<InboxDetailMsgItemBean> msgList = <InboxDetailMsgItemBean>[].obs;
  @override
  void onInit() async {
    super.onInit();

    contentController = TextEditingController();
    contentController.addListener(() {
      content = contentController.text;
    });

    // 获取传递的参数
    final arguments = Get.arguments as Map<String, dynamic>;
    title = arguments['title'] ?? '';
    mail_id = arguments['mail_id'] ?? 0;
    send_cust_name = arguments['send_cust_name'] ?? '';
    put_cust_name = arguments['put_cust_name'] ?? '';
    topContent = arguments['content'] ?? '';
    sendTime = arguments['sendTime'] ?? 0;
    isReply.value = arguments['is_reply'] ?? 0;
    String imgDomain = await TenantManager.instance.getCurrentImgDomain();
    userHead.value = "$imgDomain/${LoginManager.instance.loginInfo?.head}";
    reqMsgList();
  }

  void reqMsgList() async {
    msgList.value = (await UserApi().getInboxDetailList(
            mail_id: mail_id,
            send_cust_name: send_cust_name,
            put_cust_name: put_cust_name))
        .reversed
        .toList();
  }

  void sendMsg() async {
    if (content.isEmpty) {
      Get.snackbar("发送失败", "发送内容不能为空");
      return;
    }
    print("内容为：${content}");
    bool isSuccess = await UserApi().sendMsg(
        mail_id: mail_id,
        send_cust_name: send_cust_name,
        put_cust_name: put_cust_name,
        content: content);
    if (isSuccess) {
      contentController.text = "";
      reqMsgList();
    }
  }
}
