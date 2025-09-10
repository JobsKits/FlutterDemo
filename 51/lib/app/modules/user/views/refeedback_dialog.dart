import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/question_feedback_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_list_model/feedback_list_model.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RefeedbackDialog extends StatefulWidget {
  final FeedbackListModel? feedbackModel;
  final Function(bool)? onSubmitted;
  const RefeedbackDialog({super.key, this.feedbackModel, this.onSubmitted});

  @override
  State<RefeedbackDialog> createState() => _RefeedbackDialogState();
}

class _RefeedbackDialogState extends State<RefeedbackDialog> {
  final QuestionFeedbackController questionController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 50.h),
        decoration: BoxDecoration(
            color: const Color(colorF4F4F4),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r))),
        child: Container(
          // margin: EdgeInsets.only(left: 40.w, top: 40.h, right: 40.w),
          height: 320,
          alignment: Alignment.centerLeft,
          child: _InputBuildFeedBack(context),
        ),
      ),
    );
  }

  Widget _InputBuildFeedBack(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
              padding: EdgeInsets.all(50.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '反馈内容',
                        style: TextStyle(
                          fontSize: 34.sp,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: 34.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 15.h),
                          height: 398.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(31.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: questionController.feedbackController,
                            maxLines: null,
                            maxLength: 1000,
                            cursorColor: const Color(theme01MainColor),
                            decoration: InputDecoration(
                              hintText: '您的任何意见对我们都很重要，凡是有价值的意见都将被采纳\n\n\n',
                              contentPadding: EdgeInsets.only(
                                  top: 60.h, left: 36.w, right: 36.w),
                              hintStyle: TextStyle(
                                fontSize: 36.sp,
                                color: const Color(colorBCBCBC),
                              ),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none, // 去除边框线
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Spacer(),
          InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              questionController.replyToFeedback(widget.feedbackModel!, (tips) {
                showErrorToast(context, tips);
                if (tips == '提交成功！') {
                  widget.onSubmitted!(true);
                  Get.back();
                }
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 66.w, vertical: 30.h),
              height: 125.h,
              decoration: BoxDecoration(
                  color: Color(theme01MainColor),
                  borderRadius: BorderRadius.circular(79.r)),
              child: Text(
                "提交反馈",
                style: TextStyle(fontSize: 52.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showErrorToast(BuildContext context, String tips) {
    // 创建一个OverlayEntry
    final overlayEntry = OverlayEntry(
      builder: (context) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 40),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tips,
                  style: TextStyle(fontSize: 38.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // 插入到Overlay中
    Overlay.of(context).insert(overlayEntry);

    // 5秒后移除
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }
}
