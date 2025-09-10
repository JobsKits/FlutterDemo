import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/feedback_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_detail_model/mail_reply_info.dart';
import 'package:flutter_tiyu_app/app/modules/user/views/refeedback_dialog.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../../utils/CommonRipple.dart';

class FeedbackDetailView extends GetView<FeedbackDetailController> {
  const FeedbackDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text("反馈详情"),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.w),
            child: CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.bottomSheet(RefeedbackDialog(
                  feedbackModel: controller.feedbackModel.value,
                  onSubmitted: (success) {
                    // Handle the data here
                    controller.reqFeedbackDetail();
                  },
                ));
              },
              child: const Text("再次反馈"),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() => Container(
          margin: EdgeInsets.only(top: 15.h),
          child: Column(
            children: [
              if (controller.giftsAmount.value > 0.00 ||
                  controller.reviceAmount.value > 0.00) ...[
                _topWidget(),
              ],
              _contentWidget(),
              if (controller.detailModel.value.mailReplyInfos?.isNotEmpty ??
                  false) ...[
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true, // 让 ListView 适应内容高度
                    physics:
                        const NeverScrollableScrollPhysics(), // 禁止 ListView 自身滚动（由 SingleChildScrollView 控制）
                    itemCount:
                        controller.detailModel.value.mailReplyInfos?.length ??
                            0,
                    itemBuilder: (context, index) {
                      return _ReplyContentWidget(
                        controller.detailModel.value.mailReplyInfos?[index],
                      );
                    },
                  ),
                )
              ]
            ],
          ),
        ));
  }

  Widget _topWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            Text(
              '采纳彩金：',
              style: TextStyle(
                fontSize: 39.sp,
                color: const Color(0xFF888888),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '¥${controller.giftsAmount.value}',
              style: TextStyle(
                fontSize: 52.sp,
                color: const Color(0xFF2D2D2D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '待领取：',
              style: TextStyle(
                fontSize: 39.sp,
                color: const Color(0xFF888888),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '¥${controller.reviceAmount.value}',
              style: TextStyle(
                fontSize: 39.sp,
                color: const Color(0xFF2D2D2D),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.reqFeedbackDetailReceive();
              },
              child: Container(
                alignment: Alignment.center,
                width: 252.w,
                margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                height: 93.h,
                decoration: BoxDecoration(
                    color: controller.reviceAmount.value > 0
                        ? const Color(theme01MainColor)
                        : const Color(0xFFC6C6C6),
                    borderRadius: BorderRadius.circular(10.r)),
                child: Text(
                  controller.reviceAmount.value > 0 ? "一键领取" : '领取',
                  style: TextStyle(fontSize: 42.sp, color: Colors.white),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _contentWidget() {
    return Container(
        margin: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
        padding: EdgeInsets.all(30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35.w,
                  backgroundColor: const Color(theme01MainColor),
                  backgroundImage: controller.userHead.value.isNotEmpty
                      ? NetworkImage(
                          controller.userHead.value,
                        )
                      : AssetImage(
                              Assets.theme1.images.home.rankListHeader1.path)
                          as ImageProvider,
                ),
                const SizedBox(width: 5),
                Text(
                  controller.feedbackModel.value.fromUser ?? '',
                  style: TextStyle(fontSize: 42.sp, color: Colors.black),
                ),
                const Spacer(),
                Text(
                  DateTimeUtils.formatTimestamp(
                      controller.feedbackModel.value.sendTime ?? 0,
                      temp: 'yyyy/MM/dd HH:mm:ss'),
                  style: TextStyle(
                      fontSize: 36.sp, color: const Color(colorAAAFBB)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              controller.feedbackModel.value.content ?? '',
              style:
                  TextStyle(fontSize: 36.sp, color: const Color(colorAAAFBB)),
              textAlign: TextAlign.start,
            ),
          ],
        ));
  }

  Widget _ReplyContentWidget(MailReplyInfo? mailReplyInfo) {
    return Container(
        margin: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
        padding: EdgeInsets.all(30.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 35.w,
                  backgroundColor: const Color(theme01MainColor),
                  backgroundImage:
                      AssetImage(Assets.theme1.images.user.iconMessageSys.path),
                ),
                const SizedBox(width: 5),
                Text(
                  '官方回复',
                  style: TextStyle(fontSize: 42.sp, color: Colors.black),
                ),
                const Spacer(),
                Text(
                  DateTimeUtils.formatTimestamp(mailReplyInfo?.sendTime ?? 0,
                      temp: 'yyyy/MM/dd HH:mm:ss'),
                  style: TextStyle(
                      fontSize: 36.sp, color: const Color(colorAAAFBB)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            HtmlWidget(
              mailReplyInfo?.replyContent ?? '',
              textStyle: TextStyle(
                fontSize: 36.sp,
                color: const Color(colorAAAFBB),
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ));
  }
}
