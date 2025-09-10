import 'package:flutter/material.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/generated/l10n.dart';
import 'package:flutter_bet/model/notifis/notification.dart';
import 'package:flutter_bet/model/notifis/feedback.dart';
import 'package:flutter_bet/pages/notifs/children/feedback_detail/widgets/image_browsing.dart';
import 'package:flutter_bet/pages/notifs/widget/notifs_loding.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/utils/money_util.dart';
import 'package:flutter_bet/utils/route_util.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/dialog/custom_safe_dialog.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/extentions/ex_list.dart';

import 'index.dart';

/// 反馈详情聊天板块
class FeedbackDetailPage extends GetView<FeedbackDetailController> {
  FeedbackDetailPage(this.backAction, {Key? key}) : super(key: key);

  final Function()? backAction;

  final timeText = ThemeService().theme.textTheme.bodyMedium
      ?.copyWith(fontWeight: FontWeight.w400, color: const Color(0xFF979AA7));
  final contextText =  ThemeService().theme.textTheme.bodyMedium
      ?.copyWith(fontWeight: FontWeight.w500, color: Colors.black);
  // 主视图
  Widget _buildView(context) {

    /// 待替换为Loding
    if(controller.msgList.isEmpty) {
      return <Widget>[
        const SizedBox(height: AppValues.defaultMargin),
        <Widget>[
          const CustomAssetIcon(name: "assets/images/personal_center_icon/feedback_back.webp"),
          const SizedBox(width: AppValues.halfMargin),
          CustomText(S.current.feedback_back_title, style:ThemeService().theme.textTheme.bodyMedium)
        ].toRow().marginSymmetric(horizontal: AppValues.defaultMargin).onTap(() {
          backAction?.call();
        }),
        NotifsLoding(),
      ].toColumn();
    }

    return <Widget>[
      const SizedBox(height: AppValues.defaultMargin),
      <Widget>[
        <Widget>[
          const CustomAssetIcon(name: "assets/images/personal_center_icon/feedback_back.webp"),
          const SizedBox(width: AppValues.halfMargin),
          CustomText(S.current.feedback_back_title, style:ThemeService().theme.textTheme.bodyMedium),
        ].toRow().onTap(() {backAction?.call();}),
        const Spacer()
      ].toRow().marginSymmetric(horizontal: AppValues.defaultMargin),
      const SizedBox(height: AppValues.defaultMargin),
      CustomText(controller.feedInfo.timeTitle2, style:timeText),
      const SizedBox(height: AppValues.defaultMargin),

      ListView.builder(
        itemCount: controller.msgList.length,
        scrollDirection: Axis.vertical,
        controller: controller.scrollController,
        itemBuilder: (context, index) {
          final msgInfo = controller.msgList[index];
          // 是否为当前用户
          bool isUser   = msgInfo.uid == controller.feedInfo.uid;
          // 是否为空投消息/红包
          bool isBonusDrop = msgInfo.isBonusDrop;
          if (isUser) {
            return isBonusDrop ? _buildUserRedeemBonusDrop(msgInfo.content) : _buildUserContent(msgInfo);
          }
          return isBonusDrop ? _buildRedeemBonusDrop(msgInfo.content).onTap(() {
            controller.redeemBonusDrop(index);
          }) : _buildServiceContent(msgInfo.content);
        },
      ).marginSymmetric(horizontal: AppValues.defaultMargin).expanded(),

      _buildInput(context),
      SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
    ].toColumn().expanded();
  }

  /// 客服内容
  Widget _buildServiceContent(text) {
    return <Widget>[
      // Container(width: 32, height: 32).randomBackgroundColor().clipOval(),
      // const SizedBox(width: AppValues.halfMargin),
      <Widget>[
        CustomText(S.current.feedback_customer_service, style:timeText?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppValues.smallPadding),
        CustomText(text, style: contextText)
            .paddingAll(AppValues.defaultPadding)
            .backgroundColor(Colors.white).clipRRect(all: 8)
            .paddingRight(76)
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded()
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingBottom(AppValues.defaultMargin);
  }

  /// 客服空投奖金
  Widget _buildRedeemBonusDrop(text) {

    return <Widget>[
      // Container(width: 32, height: 32).randomBackgroundColor().clipOval(),
      // const SizedBox(width: AppValues.halfMargin),
      <Widget>[
        CustomText(S.current.feedback_customer_service, style:timeText?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppValues.smallPadding),
        _buildRedeemBonusDropWidget(false, text),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start).expanded()
    ].toRow(crossAxisAlignment: CrossAxisAlignment.start)
        .paddingBottom(AppValues.defaultMargin);
  }



  /// 用户消息
  Widget _buildUserContent(FeedbackMessageModel msgInfo) {

    const imgWidth   = 80.0;
    final imgsWidth = (imgWidth + 10) * msgInfo.imgUrls.length + AppValues.defaultMargin;
    final msgContentMaxWidth = Get.width - AppValues.defaultPadding * 5 - 76;
    final listViewWidth = imgsWidth > msgContentMaxWidth ?
    msgContentMaxWidth : imgsWidth;

    return <Widget>[
      <Widget>[
        CustomText(msgInfo.content, style: contextText, maxLines: 100).constrained(maxWidth: msgContentMaxWidth),
        const SizedBox(height: AppValues.defaultPadding).visibility(msgInfo.imgUrls.isNotEmpty),
        ListView(
         scrollDirection: Axis.horizontal,
         children: [
           for(int index = 0; index < msgInfo.imgUrls.length; index++)
             CustomNetWorkImage(
              imageUrl: msgInfo.imgUrls[index],
              width: 80,
              height: 80,
           ).paddingRight(10).onTap(() {
               showCustomDetailImageBrowsing(
                   context: Get.context!,
                   images: msgInfo.imgUrls,
                   dIndex: index
               );
             }),
        ],
      ).tight(width: listViewWidth, height: imgWidth)
        .visibility(msgInfo.imgUrls.isNotEmpty),
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .marginAll(AppValues.defaultPadding)
        .backgroundColor(Colors.white).clipRRect(all: 8)
        .paddingLeft(76)
    ].toRow(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start)
        .paddingBottom(AppValues.defaultMargin);


  }

  /// 用户空投奖金领取
  Widget _buildUserRedeemBonusDrop(text) {
    return <Widget>[
      <Widget>[
        <Widget>[
          _buildRedeemBonusDropWidget(true, text).opacity(0.5),
        ].toStack()
            .backgroundColor(Colors.white)
            .clipRRect(all: 4)
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.end).expanded(),
    ].toRow(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start)
        .paddingBottom(AppValues.defaultMargin);
  }


  /// 转账UI
  Widget _buildRedeemBonusDropWidget(bool isReceive, text) {

    final bonusFormat = MoneyUtil.toCoinAmountFormat("706", text);
    final amountStyle = ThemeService().theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700);
    final textStyle   = ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600);
    final textStyle2  = ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400);

    return <Widget>[
      <Widget>[
        const SizedBox(width: AppValues.defaultPadding),
        const CustomAssetIcon(
            name: "assets/images/personal_center_icon/feedback_transfer.webp",
            size: AppValues.iconSize_28
        ),
        const SizedBox(width: AppValues.halfMargin),
        <Widget>[
          <Widget>[
            const CustomAssetIcon(name: "assets/images/personal_center_icon/ic_usdt.webp", size: AppValues.iconDefaultSize),
            const SizedBox(width: AppValues.smallPadding),
            CustomText(bonusFormat, style: amountStyle),
          ].toRow(crossAxisAlignment: CrossAxisAlignment.center),
          CustomText(isReceive ? S.current.feedback_transfer_received : S.current.feedback_transfer_await, style: textStyle),
        ].toColumn(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start)
      ].toRow().height(64),
      Container(height: 1, width: double.infinity, color: Colors.white).opacity(0.5),
      Container(
        alignment: Alignment.centerLeft,
        child: CustomText(S.current.feedback_transfer_service, style: textStyle2)
            .paddingLeft(AppValues.defaultMargin),
      ).paddingVertical(6).paddingRight(5)
    ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
        .tight(width: 230)
        .backgroundColor(const Color(0xFFFF9800))
        .clipRRect(all: 4);
  }

  /// 输入框
  Widget _buildInput(context) {

    final lastMsg = controller.msgList.last;
    final isHidenInput = lastMsg.uid == controller.feedInfo.uid || (lastMsg.isBonusDrop && lastMsg.uid != controller.feedInfo.uid);

    const subColor   = Color.fromRGBO(255, 255, 255, 0.3);
    final subStyle   = ThemeService().theme.textTheme.bodyMedium?.copyWith(color:subColor, fontWeight: FontWeight.w600);
    final sendText   = ThemeService().theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: const Color(0xFF024703));

    return <Widget>[
      TextField(
        maxLines: 1,
        maxLength: 200,
        textAlignVertical: TextAlignVertical.center,
        controller: controller.textController,
        style: ThemeService().theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
          hintStyle: subStyle,
          hintText: S.current.please_input_message,
        ),
      ).height(41).paddingHorizontal(AppValues.defaultPadding)
          .border(all: 2, color: ThemeService().colorScheme.tertiary).expanded(),
      const SizedBox(width: 12),
      CustomText(S.current.message_send_button_text, style: sendText)
          .paddingSymmetric(horizontal: AppValues.largePadding, vertical: AppValues.defaultPadding)
          .backgroundColor(const Color(0xFF00E701))
          .clipRRect(all: 4)
          .onTap(() {controller.reqSendMessage(context);})
    ].toRow()
        .marginAll(16)
        .backgroundColor(const Color(0xFF213743))
        .visibility(!isHidenInput);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FeedbackDetailController>(
      init: FeedbackDetailController(),
      id: "feedback_detail",
      builder: (_) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return _buildView(context);
          },
        );
      },
    );
  }
}
