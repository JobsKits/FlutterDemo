import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import "package:flutter_tiyu_app/constants/activity_constants.dart";
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';

import 'package:flutter_tiyu_app/app/modules/activity/data/task_bean.dart';

import '../../../../../utils/CommonRipple.dart';

// 详情弹窗
class TaskDetailDialog extends StatefulWidget {
  const TaskDetailDialog({super.key});

  @override
  State<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends State<TaskDetailDialog> {
  ControllerTaskPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: Container(
            width: 980.w,
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.r),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    '任务详情',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50.sp,
                      color: const Color(color3B3B3B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _buildContentWidget(),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.h),
                    child: Center(
                      child: Text(
                        '关闭',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 50.sp,
                          color: context.theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 构建标题
  Widget _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 46.sp,
        color: const Color(color4A4A4A),
        fontWeight: FontWeight.w600,
        height: 2,
      ),
    );
  }

  bool isHtmlTemplate(String str) {
    // 这里的正则表达式匹配任意 HTML 标签
    const htmlPattern = r'<[^>]+>';
    final result = RegExp(htmlPattern).hasMatch(str);
    return result;
  }

  // 构建描述
  Widget _buildDesc(String text, {bool? isHtml = false}) {
    if (isHtml == true) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.w),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 800.h,
          ),
          child: SingleChildScrollView(
            // 添加滚动功能
            child: HtmlWidget(
              text,
              textStyle: TextStyle(
                fontSize: 40.sp,
                color: const Color(0xFF4A4A4A), // 这里使用您的 Color
                height: 1.2,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.w),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 40.sp,
          color: const Color(color4A4A4A),
          height: 1.2,
        ),
      ),
    );
  }

  // 构建内容区
  Widget _buildContentWidget() {
    TaskDetailBean taskDetail = controller.taskDetail.value;

    bool showScope = taskDetail.scope != '';
    bool showDetail = taskDetail.detail != '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 30.h),
      width: double.maxFinite,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: Color(colorF5F5F5),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle('任务简介：'),
          _buildDesc(taskDetail.title),
          _buildTitle('任务有效时间：'),
          _buildDesc(taskDetail.time),
          showScope ? _buildTitle('任务范围：') : const SizedBox(),
          showScope ? _buildDesc(taskDetail.scope) : const SizedBox(),
          _buildTitle(taskDetail.taskType == ActivityConstants.ACTIVITY_TYPE_112
              ? '活动详细说明：'
              : '任务说明：'),
          _buildDesc(taskDetail.description, isHtml: true),
          showDetail ? _buildTitle('任务详情：') : const SizedBox(),
          showDetail
              ? _buildDesc(taskDetail.detail, isHtml: true)
              : const SizedBox(),
        ],
      ),
    );
  }
}
