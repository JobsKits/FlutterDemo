import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bet/model/notifis/feedback.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_bonus/binding.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_home/controller.dart';
import 'package:flutter_bet/pages/notifs/logic.dart';
import 'package:flutter_bet/services/api/api_service.dart';
import 'package:flutter_bet/services/api/extension/notifs_api_service.dart';
import 'package:flutter_bet/widget/custom_progress_hud.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar.dart';
import 'package:flutter_bet/widget/snack_bar/custom_snack_bar_icons.dart';
import 'package:get/get.dart';

class FeedbackDetailController extends GetxController {
  FeedbackDetailController();

  ScrollController scrollController = ScrollController();
  TextEditingController textController = TextEditingController(text: "");

  late FeedbackModel feedInfo;
  List<FeedbackMessageModel> msgList = [];

  _initData() {

    FeedbackHomeController feedbackLogic = Get.find();
    feedInfo = feedbackLogic.notifsInfos[feedbackLogic.selIndex.value];

    reqDetaiInfo();
    reqFeedbackUpdate();

    update(["feedback_detail"]);
  }

  void onTap() {}

  /// 消除未读
  Future<void> reqFeedbackUpdate() async {
    await ApiService.instance.feedbackUpdate(
        id: feedInfo.id,
        success: (data) {
          print(data);
        },
        fail: (errorMessage) {
          print(errorMessage);
        }
    );
  }

  /// 请求聊天内容
  Future<void> reqDetaiInfo() async {
    await ApiService.instance.feedbackDetail(
        id: feedInfo.id,
        success: (data) {
          Future.delayed(const Duration(milliseconds: 550), () {
            msgList = (data.reversed.toList());

            switch (feedInfo.bonusState) {
              case 1: // 待领取 插入客服空投消息
                final kfMsg = newMsgModel(feedInfo.amount, false, isBonusDrop: true);
                msgList.add(kfMsg);
                break;
              case 2: // 已领取 插入客服空投消息 插入用户领取消息
                final kfMsg = newMsgModel(feedInfo.amount, false, isBonusDrop: true);
                final userMsg = newMsgModel(feedInfo.amount, true, isBonusDrop: true);
                kfMsg.isBonusDrop   = true;
                userMsg.isBonusDrop = true;
                msgList.addAll([kfMsg, userMsg]);
                break;
              default:
                break;
            }
            update(["feedback_detail"]);

            Future.delayed(const Duration(milliseconds: 100), () {
              scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
              );
            });

          });
        },
        fail: (errorMessage) {
          // CustomSnackBar.showError(errorMessage!, context);
          print(errorMessage);
        }
    );
  }

  /// 发送消息
  Future<void> reqSendMessage(context) async {
    if(textController.text.isEmpty) {
      return;
    }

    FocusScope.of(context).requestFocus(FocusNode());

    final text = textController.text;
    textController.text = '';

    await ApiService.instance.feedbackChatInsert(
        id: feedInfo.id,
        text: text,
        success: (data) {
         reqDetaiInfo();
        },
        fail: (errorMessage) {
          textController.text = text;
          CustomSnackBar.showError(errorMessage!, context);
        }
    );
  }

  /// 领取空投奖励 pop 领取奖金弹窗
  void redeemBonusDrop(index) {
    if(index == msgList.length - 1) {
      showCustomFeedbackBonusWidget(
          context: Get.context!,
          feedId: feedInfo.id,
          bonus: feedInfo.amount
      );
    }
  }

  /// pop 领取奖金弹窗领取成功回调
  void feedbackBonusCallback(msg) {
    final userMsg = newMsgModel(feedInfo.amount, true, isBonusDrop: true);
    msgList.addAll([userMsg]);
    update(["feedback_detail"]);

    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeInOut,
    );
  }

  FeedbackMessageModel newMsgModel(String content, bool isUser, {bool isBonusDrop = false}) {
    final msg = FeedbackMessageModel(
      id : "",
      feedId : "",
      content : content,
      createdAt : 0,
      uid : isUser ? feedInfo.uid : "1",
      images: "",
    );
    msg.isBonusDrop = isBonusDrop;
    return msg;
  }

  @override
  void onInit() {
    super.onInit();
    _initData();
  }

  @override
  void onReady() {
    super.onReady();

  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

}
