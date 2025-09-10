import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/tips_dialog.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/api/activity_api.dart';

import '../../../../utils/CommonRipple.dart';

class GetBonusCodeDialog extends StatefulWidget {
  final String aid;
  const GetBonusCodeDialog({
    super.key,
    required this.aid,
  });

  @override
  State<GetBonusCodeDialog> createState() => _GetBonusCodeDialogState();
}

class _GetBonusCodeDialogState extends State<GetBonusCodeDialog> {
  String code = '';
  RxBool loading = true.obs;
  RxString username = ''.obs;

  @override
  void initState() {
    super.initState();

    username.value = LoginManager.instance.loginInfo?.custName ?? '';
    _reqPromoCode();
  }

  Future<void> _reqPromoCode() async {
    loading.value = true;
    final response = await ActivityApi.reqPromoCode(widget.aid);

    String msg = response.data['msg'];

    print('====> ${response.data}');
    if (response.type == NetworkService.networkTypeSuccess) {
      if (response.data['response_code'] == '9999') {
        setState(() {
          code = response.data['t'];
        });
      } else {
        Get.back();
        Get.dialog(
          TipsDialog(tips: msg),
          barrierDismissible: false,
        );
      }
    } else {
      Get.back();
      Get.dialog(
        TipsDialog(tips: msg),
        barrierDismissible: false,
      );
    }
    loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 900.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Obx(() => _buildBody()),
            Positioned(
              top: 38.h,
              right: 46.w,
              child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 72.w,
                    color: Colors.black26,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (loading.value) {
      return SizedBox(
        height: 400.h,
        child: Center(
          child: SizedBox(
            width: 80.w,
            height: 80.h,
            child: CircularProgressIndicator(
              strokeWidth: 4.w,
              valueColor: AlwaysStoppedAnimation<Color>(
                  context.theme.primaryColor), // 圆圈颜色
            ),
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          '获取兑换码',
          style: TextStyle(
            fontSize: 57.sp,
            color: const Color(0xFF3B3B3B),
            fontWeight: FontWeight.w600,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 62.w),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: '',
                style: TextStyle(
                  fontSize: 39.sp,
                  color: const Color(color4B4B4B),
                ),
                children: [
                  const TextSpan(text: '恭喜'),
                  TextSpan(
                    text: username.value,
                    style: TextStyle(
                      color: context.theme.primaryColor,
                    ),
                  ),
                  const TextSpan(text: '获得兑换码：'),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 182.h,
          margin: EdgeInsets.symmetric(horizontal: 62.w),
          decoration: BoxDecoration(
            color: const Color(colorFFFFFF),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              color: context.theme.primaryColor,
              width: 3.h,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Row(
            children: [
              Text(
                '兑换码：',
                style: TextStyle(
                  fontSize: 52.sp,
                  color: const Color(color3B3B3B),
                ),
              ),
              SizedBox(width: 20.w),
              Text(
                code,
                style: TextStyle(
                  fontSize: 52.sp,
                  color: const Color(color3B3B3B),
                ),
              ),
              CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  ClipboardUtil.copy(code);
                  Get.back();
                },
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                  child: SvgPicture.asset(
                    Assets.theme1.images.common.iconCopy,
                    width: 52.w,
                    height: 52.h,
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
            left: 62.w,
            right: 62.w,
            bottom: 30.w,
          ),
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF10C8E3), Color(0xFF00F5FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0x8000DEFF),
                offset: Offset(0, 6.w),
                blurRadius: 10.w,
              ),
            ],
          ),
          height: 120.h,
          child: ElevatedButton(
            onPressed: () async {
              AppManager.instance.tapVibrate();
              ClipboardUtil.copy(code);
              Get.back();
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
                '复制',
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
