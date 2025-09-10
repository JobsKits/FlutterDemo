import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../gen/assets.gen.dart';

///app升级弹窗
class AppUpdateDialog extends StatefulWidget {
  final String title; // 标题
  final String updateContent; // 升级描述
  final bool forceUpdate; // 强制升级
  final String downloadUrl; // 下载地址

  const AppUpdateDialog({
    super.key,
    required this.title,
    required this.updateContent,
    required this.forceUpdate,
    required this.downloadUrl,
  });

  @override
  State<AppUpdateDialog> createState() => _AppUpdateDialogState();
}

class _AppUpdateDialogState extends State<AppUpdateDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.customTheme?.dialogBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(45.r),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 330.h),
              Padding(
                padding: EdgeInsets.all(60.w),
                child: Column(
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 60.sp,
                        fontWeight: FontWeight.w600,
                        color: context.customTheme?.titleColor,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Text(
                      widget.updateContent,
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.w400,
                        color: context.customTheme?.homeGameSearchHintTxtColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 60.w,
                  vertical: 20.h,
                ),
                child: _buildBottomButton(),
              ),
              SizedBox(height: 20.h),
            ],
          ),
          Positioned(
            top: -88.h,
            left: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.r),
              child: Image.asset(
                ThemeService.to.currentTheme.value?.model == 'blackGold'
                    ? Assets.theme1.images.home.iconDialogUpdateBlackGold.path
                    : Assets.theme1.images.home.iconDialogUpdate.path,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
    if (widget.forceUpdate) {
      return Row(
        children: [
          SizedBox(width: 60.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () async {
                AppManager.instance.tapVibrate();
                Uri url = Uri.parse(widget.downloadUrl);
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: Text(
                '立即更新',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 60.w),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: context.theme.primaryColor,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () {
                AppManager.instance.tapVibrate();
                Navigator.of(context).pop();
              },
              child: Text(
                '取消',
                style: TextStyle(
                  color: context.theme.primaryColor,
                  fontSize: 48.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 30.w),
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onPressed: () async {
                AppManager.instance.tapVibrate();
                Uri url = Uri.parse(widget.downloadUrl);
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
              child: Text(
                '立即更新',
                style: TextStyle(
                  color: context.customTheme?.rechargeMoneyColor,
                  fontSize: 48.sp,
                ),
              ),
            ),
          ),
        ],
      );
    }
  }
}
