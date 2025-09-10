import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/feedback.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_bonus/binding.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/notifs_api_service.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

class FeedbackHomeController extends GetxController {
  FeedbackHomeController();

  late BuildContext ctx;

  /// 有奖反馈tab
  List<String> feedbackTitles = [
    S.current.notifs_insert_feedback, 
    S.current.notifs_my_feedback
  ];
  int feedbackSelIndex = 0;
  /// 待领取奖金
  String bonus = '0';
  /// 列表所选-反馈详情;
  var selIndex = 10000.obs;

  /// 消息列表 当前消息类型选项消息
  List<FeedbackModel> notifsInfos = [];

  /// 列表数据加载 loding
  var isInitLoding = true;

  _initData() {
    update(["feedback_home"]);
  }

  /// 有奖反馈切换
  void feedbackDidSelIndex(context, int index) {
    feedbackSelIndex = index;

    const feedbackListView = 1;
    if(index == feedbackListView) {
      isInitLoding = true;
      notifsInfos  = [];
      reqBonusInfo();
      reqFeedbackList(context);
    }
    update(["feedback_home"]);
  }


  /// 反馈列表刷新
  Future<void> reqFeedbackList(context) async {
    await ApiService.instance.feedbackList(
        success: (pageInfo) {
          if (isInitLoding) {
            Future.delayed(const Duration(milliseconds: 150), () {
              notifsInfos = pageInfo.content as List<FeedbackModel>;
              isInitLoding = false;
              update(["feedback_home"]);
            });
          }else {
            notifsInfos = pageInfo.content as List<FeedbackModel>;
            isInitLoding = false;
            update(["feedback_home"]);
          }
        },
        fail: (errorMessage) {
          CustomSnackBar.showError(errorMessage!, context);
        }
    );
  }

  /// 待领取金额获取
  void reqBonusInfo() {
    ApiService.instance.feedbackBonusReward(
        success: (data) {
          bonus =  data;
          update(["feedback_home"]);
        },
        fail: (errorMessage) {
          CustomSnackBar.showError(errorMessage!, ctx);
        }
    );
  }

  /// pop 领取奖金弹窗
  void popFeedbackBonusWidget() {
    showCustomFeedbackBonusWidget(context: Get.context!, feedId: "", bonus: bonus);
  }

  /// pop 领取奖金弹窗领取成功回调
  void feedbackBonusCallback(msg) {
    reqBonusInfo();
    reqFeedbackList(ctx);
    CustomSnackBar.show(msg, ctx, title: S.current.success_pwd, preIcon: CustomSnackBarIcons.verifySucceed);
  }

  /// 跳转反馈详情页
  void feedbackDetail(index) {
    selIndex.value = index;
    update(["feedback_home"]);
  }

  /// 反馈详情页返回
  void feedbackDetailBack() {
    selIndex.value = 10000;
    reqBonusInfo();
    reqFeedbackList(ctx);
    update(["feedback_home"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
