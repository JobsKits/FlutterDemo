import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_detail_model/feedback_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_list_model/feedback_list_model.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FeedbackDetailController extends GetxController {
  Rx<FeedbackListModel> feedbackModel = FeedbackListModel().obs;
  Rx<FeedbackDetailModel> detailModel = FeedbackDetailModel().obs;
  RxString userHead = "".obs;
  RxDouble giftsAmount = 0.00.obs;
  RxDouble reviceAmount = 0.00.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments as FeedbackListModel;
    feedbackModel.value = arguments;

    String imgDomain = TenantManager.instance.appImgDomainPath.value;
    if (imgDomain.isNotEmpty) {
      userHead.value = "$imgDomain/${LoginManager.instance.loginInfo?.head}";
    }

    reqFeedbackDetail();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void reqFeedbackDetail() async {
    final response = await UserApi.reqFeedbackDetail(
        feedbackModel.value.mailId ?? 0,
        feedbackModel.value.putCustName ?? '',
        feedbackModel.value.sendCustName ?? '');
    print({'reqFeedbackList === ', response.data});
    if (response.type == NetworkService.networkTypeSuccess) {
      detailModel.value = FeedbackDetailModel.fromJson(response.data);
      calculateTotalGifts();
    }
  }

  void calculateTotalGifts() {
    double total = 0.00;
    for (var feedback in detailModel.value.mailReplyInfos!) {
      if (feedback.replyContent != null && feedback.giftAmount != null) {
        total += feedback.giftAmount ?? 0.0;
      }
    }
    giftsAmount.value = total;

    if (detailModel.value.mailReplyInfos?.isNotEmpty ?? false) {
      final first = detailModel.value.mailReplyInfos!.first;
      reviceAmount.value =
          (first.giftStatus == 2 ? 0.00 : first.giftAmount) ?? 0.00;
    }
  }

  void reqFeedbackDetailReceive() async {
    final response = await UserApi.reqFeedbackDetailReceive(
        feedbackModel.value.mailId ?? 0,
        detailModel.value.mailReplyInfos?.first.replyId ?? 0);
    print({'reqFeedbackDetailReceive === ', response.data});
    if (response.type == NetworkService.networkTypeSuccess &&
        response.data['response_code'] == '9999') {
      EasyLoading.showSuccess('领取成功');
      reqFeedbackDetail();
    }
  }
}
