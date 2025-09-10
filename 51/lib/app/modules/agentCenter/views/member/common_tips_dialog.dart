import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonTipsDialog extends StatefulWidget {
  final String? tips;
  const CommonTipsDialog({
    super.key,
    this.tips,
  });

  @override
  _CommonTipsDialogState createState() => _CommonTipsDialogState();
}

class _CommonTipsDialogState extends State<CommonTipsDialog>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // 阴影颜色
              spreadRadius: 2, // 扩散程度
              blurRadius: 5, // 模糊程度
              offset: Offset(0, 3), // 阴影偏移量 (x, y)
            ),
          ],
        ),
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info, color: Colors.red, size: 120.w),
            SizedBox(height: 30.h),
            Text(
              widget.tips ?? '',
              style: TextStyle(fontSize: 38.sp),
            ),
          ],
        ),
      ),
    );
  }
}
