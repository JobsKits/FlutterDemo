import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/CommonRipple.dart';

class TipsDialog extends StatelessWidget {
  final String? title;
  final String tips;
  final String? desc;
  final String? bottomTips;
  final String? comfirmText;
  final String? cancelText;
  final double? contentF1Size;
  final double? contentF2Size;
  final VoidCallback? confirmAction;
  final VoidCallback? cancelAction;
  final String? type;
  const TipsDialog({
    super.key,
    this.title = '温馨提示',
    required this.tips,
    this.desc = '',
    this.comfirmText = '确认',
    this.cancelText = '',
    this.contentF1Size = 51,
    this.contentF2Size = 45,
    this.confirmAction,
    this.cancelAction,
    this.bottomTips,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 500.h,
          maxHeight:
              MediaQuery.of(Get.context!).size.height * 0.8, // 限制最大高度为屏幕80%
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 标题部分
                  Padding(
                    padding: EdgeInsets.only(top: 38.h),
                    child: Text(
                      title ?? '温馨提示',
                      style: TextStyle(
                        fontSize: 57.sp,
                        color: const Color(0xFF3B3B3B),
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  SizedBox(height: 40.h),

                  // 内容部分（自适应高度）
                  Flexible(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (type == 'main')
                            RichText(
                              text: TextSpan(
                                text: '领取成功，您共获得 ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 32.sp,
                                ),
                                children: [
                                  TextSpan(
                                    text: tips,
                                    style: TextStyle(
                                      color: context.theme.primaryColor,
                                      fontSize: 32.sp,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: ' 金额',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            )
                          else
                            Text(
                              tips,
                              style: TextStyle(
                                fontSize: contentF1Size?.sp ?? 32.sp,
                                color: type == 'redbag'
                                    ? const Color(0xFFD62E2E)
                                    : const Color(0xFF3B3B3B),
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          if ((desc ?? '').isNotEmpty) ...[
                            SizedBox(height: 30.h),
                            Text(
                              desc!,
                              style: TextStyle(
                                fontSize: contentF2Size?.sp ?? 28.sp,
                                color: const Color(0xFF3B3B3B),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 底部按钮区域（固定高度）
                  Container(
                    margin: EdgeInsets.only(top: 60.h),
                    child: _buildButtonArea(context),
                  ),

                  // 底部附加提示（如果有）
                  if ((bottomTips ?? '').isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: Text(
                        bottomTips!,
                        style: TextStyle(
                          fontSize: 48.sp,
                          color: type == 'custom'
                              ? context.theme.primaryColor
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),

              // 关闭按钮
              Positioned(
                top: 0,
                right: 0,
                child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Icon(
                      Icons.clear,
                      size: 72.w,
                      color: Colors.black26,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 按钮区域构建方法
  Widget _buildButtonArea(BuildContext context) {
    if (cancelText == '') {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 210.w),
        height: 120.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.r),
          gradient: LinearGradient(
            colors: type == 'redbag'
                ? [const Color(0xFFF04639), const Color(0xFFFF514B)]
                : [const Color(0xFF10C8E3), const Color(0xFF00F5FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: type == 'redbag'
                  ? const Color(0xFFFF514B)
                  : const Color(0x8000DEFF),
              offset: Offset(0, 6.w),
              blurRadius: 10.w,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () async {
            AppManager.instance.tapVibrate();
            Get.back();
            confirmAction?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.r),
            ),
          ),
          child: Text(
            comfirmText ?? '确认',
            style: TextStyle(
              fontSize: 48.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Container(
              height: 120.h,
              margin: comfirmText == '' ? EdgeInsets.symmetric(horizontal: 180.w) : EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.r),
                color: Colors.white,
                border: Border.all(
                  color: context.theme.primaryColor,
                  width: 1.0,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {
                  AppManager.instance.tapVibrate();
                  Get.back();
                  cancelAction?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                ),
                child: Text(
                  cancelText ?? "取消",
                  style: TextStyle(
                    fontSize: 48.sp,
                    color: context.theme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          if (comfirmText != '') ... [
            SizedBox(width: 20.w),
              Expanded(
                child: Container(
                  height: 120.h,
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60.r),
                    gradient: LinearGradient(
                      colors: type == 'redbag'
                          ? [const Color(0xFFF04639), const Color(0xFFFF514B)]
                          : [const Color(0xFF10C8E3), const Color(0xFF00F5FF)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: type == 'redbag'
                            ? const Color(0xFFFF514B)
                            : const Color(0x8000DEFF),
                        offset: Offset(0, 6.w),
                        blurRadius: 10.w,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      AppManager.instance.tapVibrate();
                      Get.back();
                      confirmAction?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(60.r),
                      ),
                    ),
                    child: Text(
                      comfirmText ?? "确认",
                      style: TextStyle(
                        fontSize: 48.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
          ]
        ],
      );
    }
  }
}
