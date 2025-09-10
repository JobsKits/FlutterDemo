import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_deposit_model/activity_deposit_model.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityDepositDialog extends StatelessWidget {
  final String? title;
  final String tips;
  final dynamic data;
  final String? display;
  final String? bottomTips;
  final String? comfirmText;
  final String? cancelText;
  final VoidCallback? confirmAction;
  final VoidCallback? cancelAction;
  final String? type;
  const ActivityDepositDialog({
    super.key,
    this.title,
    required this.tips,
    this.data,
    this.display,
    this.comfirmText,
    this.cancelText,
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
                          Text(
                            tips,
                            style: TextStyle(
                              fontSize: 38.sp,
                              color: const Color(0xFF3B3B3B),
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          if ((data ?? '').isNotEmpty) ...[
                            Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30.w, vertical: 40.h),
                                alignment: Alignment.center,
                                child: _buildTypeGrid()),
                          ],
                        ],
                      ),
                    ),
                  ),

                  // 底部按钮区域（固定高度）
                  Container(
                    margin: EdgeInsets.only(top: 60.h),
                    child: _buildButtonArea(),
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
                              ? const Color(theme01MainColor)
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
                child: InkWell(
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

  _buildTypeGrid() {
    List<ActivityDepositModel> depositDatas = <ActivityDepositModel>[];
    depositDatas.assignAll((data as List)
        .map((item) => ActivityDepositModel.fromJson(item))
        .toList());

    List<ActivityDepositModel> filteredList = depositDatas.where((item) {
      return display!.contains(item.payOrgId.toString());
    }).toList();

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: filteredList.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.92,
        crossAxisSpacing: 18.w,
        mainAxisSpacing: 18.w,
      ),
      itemBuilder: (context, index) {
        ActivityDepositModel deposit = filteredList[index];
        return InkWell(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            height: 118.h,
            decoration: BoxDecoration(
                color: const Color(colorF4F4F4),
                borderRadius: BorderRadius.circular(27.r)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Center horizontally
              crossAxisAlignment: CrossAxisAlignment.center, // Center
              children: [
                Image.network(
                  deposit.iconUrl?.isEmpty ??
                          false ||
                              deposit.iconUrl == '' ||
                              deposit.iconUrl == null
                      ? '${NetworkService().baseURL}/images/recharge/recharge_${deposit.payOrgId}.png'
                      : deposit.iconUrl ?? '',
                  width: 40.w,
                  height: 40.h,
                ),
                SizedBox(width: 10.w),
                Text(
                  "${deposit.name}",
                  style: TextStyle(
                      fontSize: 42.sp, color: const Color(color6D6D6D)),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // 按钮区域构建方法
  Widget _buildButtonArea() {
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
              margin: EdgeInsets.only(right: 10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.r),
                color: Colors.white,
                border: Border.all(
                  color: const Color(theme01MainColor),
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
                    color: const Color(theme01MainColor),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
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
        ],
      );
    }
  }
}
