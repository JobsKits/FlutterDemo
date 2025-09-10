import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/widget/new_common_game_list.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import '../../../../../utils/CommonRipple.dart';

class TaskPageCenterContainer extends StatefulWidget {
  final String topText; // 标题
  final String reward; // 奖励
  final String bottomText; // 底部文案
  final StandaraListBean? itemStandara;
  final double? percentage; // 进度
  final bool? showQuestion; // 显示问题按钮
  final bool? showPercentage; // 显示进度条
  final Color? bottomColor; // 底部文案

  const TaskPageCenterContainer({
    super.key,
    this.itemStandara,
    required this.topText,
    required this.reward,
    required this.bottomText,
    required this.percentage,
    this.showQuestion = true,
    this.showPercentage = true,
    this.bottomColor,
  });

  @override
  State<TaskPageCenterContainer> createState() =>
      _TaskPageCenterContainerState();
}

class _TaskPageCenterContainerState extends State<TaskPageCenterContainer> {
  ControllerTaskPage controller = Get.find();

  Widget _buildTopText(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 350.w),
      padding: EdgeInsets.only(right: 30.w),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
              color: context.customTheme?.titleColor, fontSize: 36.sp), // 默认样式
          children: [
            TextSpan(text: widget.topText),
            if (widget.showQuestion == true)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (widget.itemStandara != null) {
                      controller.setTaskDetailData(widget.itemStandara!);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      Assets.theme1.images.activity.question,
                      width: 36.w,
                      height: 36.h,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPercentage(BuildContext context) {
    if (widget.showPercentage == false) {
      return const SizedBox();
    }

    return Row(
      children: [
        Container(
          width: 280.w,
          height: 30.h,
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
          child: LinearProgressIndicator(
            value: (widget.percentage ?? 0) / 100, // 进度值，0.5表示50%
            backgroundColor: Colors.grey[200], // 进度条的背景颜色
            valueColor: AlwaysStoppedAnimation<Color>(
                context.theme.primaryColor), // 进度条的颜色
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 10.w),
          child: Text(
            widget.reward,
            style: TextStyle(fontSize: 30.sp, color: context.customTheme?.titleColor),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopText(context),
          _buildPercentage(context),
          Container(
            constraints: BoxConstraints(maxWidth: 350.w),
            padding: EdgeInsets.only(right: 30.w),
            child: Text(
              widget.bottomText,
              style: TextStyle(
                color: widget.bottomColor != null
                    ? widget.bottomColor
                    : context.customTheme?.titleColor,
                fontSize: 36.sp,
              ),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
