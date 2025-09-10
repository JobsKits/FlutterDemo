import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CommonLoadingView extends StatelessWidget {
  const CommonLoadingView({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300.w,
      child: Column(
        children: [
          TenantManager.instance.appIconPath.isNotEmpty
              ? Image.network(TenantManager.instance.appIconPath)
              : const SizedBox(),
          SizedBox(
            height: 60.h,
          ),
          SizedBox(
            width: 126.w,
            height: 126.h,
            child: LoadingIndicator(
              indicatorType: Indicator.ballSpinFadeLoader,
              colors: [context.theme.primaryColor],
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            "努力加载中",
            style:
                TextStyle(fontSize: 36.sp, color: context.theme.primaryColor),
          )
        ],
      ),
    );
  }
}
