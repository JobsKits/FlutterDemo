import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/bonus_code_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/get_bonus_code_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/empty_widget.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/welcome_bonus_controller.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';

// 新人彩金-活动详情
class WelcomeBonusView extends GetView<WelcomeBonusController> {
  const WelcomeBonusView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Obx(
          () => Text(
            controller.activityName.value,
            style: TextStyle(
              fontSize: 57.sp,
              color: const Color(0xFF2D2D2D),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() => _buildBody()),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          if (controller.isShowDetailTime.value == '1') ...[
            Container(
              margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
              padding: EdgeInsets.all(50.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          color: const Color(0xFF00CAE6),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6.w),
                            bottom: Radius.circular(6.w),
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Text(
                        '活动时间',
                        style: TextStyle(
                          fontSize: 51.sp,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    '活动对象：活动期间首充用户',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: const Color(0xFF4B4B4B),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 20.w),
                  Text(
                    '活动时间：${DateTimeUtils.formatDateTime(
                      controller.startTime.value,
                    )} ~ ${DateTimeUtils.formatDateTime(
                      controller.endTime.value,
                    )}',
                    style: TextStyle(
                      fontSize: 39.sp,
                      color: const Color(0xFF4B4B4B),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ],
          Container(
            margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
            padding: EdgeInsets.all(50.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00CAE6),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6.w),
                          bottom: Radius.circular(6.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '活动详情',
                      style: TextStyle(
                        fontSize: 51.sp,
                        color: const Color(0xFF2D2D2D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                HtmlWidget(
                  controller.content.value,
                  textStyle: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(0xFF4B4B4B),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
            padding: EdgeInsets.all(50.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00CAE6),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(6.w),
                          bottom: Radius.circular(6.w),
                        ),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Text(
                      '活动规则',
                      style: TextStyle(
                        fontSize: 51.sp,
                        color: const Color(0xFF2D2D2D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.w),
                HtmlWidget(
                  controller.rule.value,
                  textStyle: TextStyle(
                    fontSize: 39.sp,
                    color: const Color(0xFF4B4B4B),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildGetCodeWidget(),
          _buildInputCodeWidget(),
        ],
      ),
    );
  }

  Widget _buildGetCodeWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: 60.w,
        right: 60.w,
        bottom: 60.w,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x8000DEFF),
            offset: Offset(0, 6.w),
            blurRadius: 10.w,
          ),
        ],
      ),
      height: 120.h,
      child: ElevatedButton(
        onPressed: () {
          AppManager.instance.tapVibrate();
          Get.dialog(
              GetBonusCodeDialog(
                aid: controller.aid,
              ),
              barrierDismissible: false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: Text(
            '获取兑换码',
            style: TextStyle(
              fontSize: 48.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputCodeWidget() {
    return Container(
      margin: EdgeInsets.only(
        left: 60.w,
        right: 60.w,
        bottom: 60.w,
      ),
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.r),
        gradient: const LinearGradient(
          colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0x8000DEFF),
            offset: Offset(0, 6.w),
            blurRadius: 10.w,
          ),
        ],
      ),
      height: 120.h,
      child: ElevatedButton(
        onPressed: () {
          AppManager.instance.tapVibrate();
          Get.dialog(
              BonusCodeDialog(
                aid: controller.aid,
              ),
              barrierDismissible: false);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: double.infinity,
          child: Text(
            '填写优惠码',
            style: TextStyle(
              fontSize: 48.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
