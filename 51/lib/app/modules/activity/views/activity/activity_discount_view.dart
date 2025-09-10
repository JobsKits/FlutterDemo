import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_discount_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

///活动页面
class ActivityDiscountView extends GetView<ActivityDiscountController> {
  const ActivityDiscountView({super.key});

  @override
  build(BuildContext context) {
    if (!Get.isRegistered<ActivityDiscountController>()) {
      Get.put(ActivityDiscountController());
    }
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          '优惠申请',
          style: TextStyle(
            fontSize: 57.sp,
            color: const Color(0xFF2D2D2D),
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        return Column(
          children: [
            // ListView 部分（用 Expanded 包裹以允许滚动）
            Expanded(
              child: ListView.builder(
                itemCount: controller.questionDatas.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10, right: 10, bottom: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: QuestionInputWidget(
                      questionText: controller.questionDatas[index],
                      controller: controller.textControllers[index],
                    ),
                  );
                },
              ),
            ),

            // 底部按钮（添加适当边距）
            Container(
              margin: const EdgeInsets.only(bottom: 25, left: 10, right: 10),
              width: 0.6.sw,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(70.r),
                gradient: LinearGradient(
                  colors: [
                    context.theme.primaryColor,
                    context.theme.primaryColor.withOpacity(0.5)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.theme.primaryColor.withOpacity(0.5),
                    offset: Offset(0, 6.w),
                    blurRadius: 10.w,
                  ),
                ],
              ),
              height: 140.h,
              child: ElevatedButton(
                onPressed: () {
                  AppManager.instance.tapVibrate();
                  final allAnswers = controller.getAllAnswers();
                  List<String> questions = allAnswers.keys.toList();
                  List<String> answers = allAnswers.values
                      .where((s) => s.trim().isNotEmpty)
                      .toList();

                  if (questions.length != answers.length) {
                    showErrorToast(context);
                    return;
                  }
                  if (controller.verification == '1') {
                    controller.requestPromotionApply(questions, answers);
                  } else {
                    if (controller.isRequestVerify.value) {
                      return;
                    }
                    controller.showCaptcha(questions, answers);
                  }
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
                    '立即申请',
                    style: TextStyle(
                      fontSize: 38.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void showErrorToast(BuildContext context) {
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
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.white, size: 35.w),
                ),
                SizedBox(width: 15.w),
                Text(
                  '请输入问题答案',
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

class QuestionInputWidget extends StatelessWidget {
  final String questionText;
  final TextEditingController controller;

  const QuestionInputWidget({
    Key? key,
    required this.questionText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questionText,
          style: TextStyle(
            color: const Color(color4A4A4A),
            fontSize: 45.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: 100,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          decoration: InputDecoration(
              hintText: '请输入问题答案',
              hintStyle: const TextStyle(color: Colors.grey),
              filled: true, // This enables the background color
              fillColor:
                  const Color(colorF4F4F4), // Set your desired background color
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(15.0), // Adjust the radius as needed
                borderSide:
                    BorderSide.none, // Optional: removes the border line
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: BorderSide
                    .none, // Optional: removes the border line when enabled
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
                borderSide: const BorderSide(
                    color: Colors.blue,
                    width: 2.0), // Optional: custom focus border
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              counterText: ""),
        ),
      ],
    );
  }
}
