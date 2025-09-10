// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_end_overlay.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/leaderboard_reward_view.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_activity_page.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/constants/activity_constants.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../data/activity_bean.dart';

import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/network_image_with_fallback.dart';

class ActivityListItemWidget extends StatefulWidget {
  final ActivityPgList dataItem; // 活动子项的数据

  const ActivityListItemWidget({
    super.key,
    required this.dataItem,
  });

  @override
  State<ActivityListItemWidget> createState() => _ActivityListItemWidgetState();
}

class _ActivityListItemWidgetState extends State<ActivityListItemWidget> {
  ControllerActivityPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        controller.handleActivity(widget.dataItem);

        // ActivityListItemBean item = widget.dataItem;
        // if (item.activityType == '5') {
        //   // 排行榜
        //   Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
        //     'aid': widget.dataItem.id,
        //     'title': widget.dataItem.activityName,
        //     'content': widget.dataItem.activityContent,
        //     'rule': widget.dataItem.activityRule,
        //     'startTime': widget.dataItem.startTime,
        //     'endTime': widget.dataItem.endTime,
        //   });
        // } else if (item.activityType == '6') {
        //   // 新人彩金
        //   Get.toNamed(
        //     Routes.WELCOME_BONUS,
        //     arguments: {
        //       'aid': widget.dataItem.id,
        //       'title': widget.dataItem.activityName,
        //       'content': widget.dataItem.activityContent,
        //       'rule': widget.dataItem.activityRule,
        //       'startTime': widget.dataItem.startTime,
        //       'endTime': widget.dataItem.endTime,
        //     },
        //   );
        // }
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 30.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.r),
            color: context.customTheme?.pageTwoBg),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  constraints: BoxConstraints(minHeight: 332.h),
                  child: NetworkImageWithFallback(
                    imageUrl: widget.dataItem.showPic ?? '',
                    fallbackAsset: Assets.theme1.images.activity.imgEmpty.path,
                    isIcon: true,
                  ),
                ),
                if (widget.dataItem.showEndTime?.isNotEmpty ==
                    true) ...{
                  ActivityEndOverlay(
                    endTime: widget.dataItem.endTime,
                  ),
                }
              ],
            ),
            // Obx(() => _buildChildWidget()),
          ],
        ),
      ),
      // child: Container(
      //   width: double.infinity,
      //   height: 400.h,
      //   margin: EdgeInsets.only(bottom: 30.h),
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(36.r),
      //   ),
      //   child: Stack(
      //     children: [
      //       Positioned.fill(
      //         child: ClipRRect(
      //           borderRadius: BorderRadius.circular(36.r),
      //           child: Image.network(
      //             widget.dataItem.showPic,
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //       Positioned(
      //         left: 30.w,
      //         bottom: 30.h,
      //         child: Row(
      //           children: [
      //             Container(
      //               height: 72.h,
      //               margin: EdgeInsets.only(right: 30.w),
      //               padding:
      //                   EdgeInsets.symmetric(horizontal: 30.w, vertical: 4.h),
      //               decoration: BoxDecoration(
      //                 color: Color(theme01MainColor),
      //                 borderRadius: BorderRadius.circular(36.r),
      //               ),
      //               child: Text(
      //                 widget.dataItem.activityName,
      //                 style: TextStyle(
      //                   color: Colors.white,
      //                   fontSize: 42.sp,
      //                   fontWeight: FontWeight.w500,
      //                 ),
      //               ),
      //             ),
      //             // Text(
      //             //   '2024/10/05 - 2024/10/31',
      //             //   style: TextStyle(
      //             //     fontSize: 42.sp,
      //             //     fontWeight: FontWeight.w400,
      //             //   ),
      //             // ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // _buildChildWidget() {
  //   return Text(
  //     "领取",
  //     style: TextStyle(fontSize: 42.sp, color: Colors.white),
  //   );
  // }
  bool isTimeBeforeNow(String timeString) {
    DateTime targetTime = DateTime.parse(timeString);
    DateTime now = DateTime.now();
    return targetTime.isBefore(now);
  }

  // 构建子模块
  _buildChildWidget() {
    // if (controller.isShowBulletinId.value == widget.dataItem.bulletin_id) {
    //   // 自定义任务，渲染一个领取按钮
    //   if (widget.dataItem.task_type == ActivityTaskType.CustomTask) {
    //     return Container(
    //       height: 86.h,
    //       margin: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               shape: RoundedRectangleBorder(
    //                 borderRadius: BorderRadius.circular(43.r), // 设置圆角半径
    //               ),
    //               backgroundColor: const Color(0XFF10c8e3),
    //               padding: EdgeInsets.zero,
    //             ),
    //             onPressed: () {
    //               //
    //             },
    //             child: Text(
    //               "领取",
    //               style: TextStyle(fontSize: 42.sp, color: Colors.white),
    //             ),
    //           )
    //         ],
    //       ),
    //     );
    //   }

    //   // 图片
    //   if (widget.dataItem.content_type == ActivityContentType.Image) {
    //     return Container(
    //       padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
    //       constraints: BoxConstraints(minHeight: 300.h),
    //       child: NetworkImageWithFallback(
    //         imageUrl: widget.dataItem.content ?? '',
    //         fallbackAsset: Assets.theme1.images.activity.imgEmpty.path,
    //         fit: BoxFit.fitHeight,
    //       ),
    //     );
    //   }

    //   // 网址
    //   if (widget.dataItem.content_type == ActivityContentType.Text &&
    //       widget.dataItem.content!.isNotEmpty) {
    //     return Container(
    //       padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
    //       child: HtmlWidget("${widget.dataItem.content}"),
    //     );
    //   }
    // }
    return const SizedBox();
  }
}
