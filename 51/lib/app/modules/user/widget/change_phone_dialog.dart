// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/login_input_widget.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

// import '../../../../api/user_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../controllers/user_info_controller.dart';

//修改手机号的弹窗
class ChangePhoneDialog extends StatefulWidget {
  final bool isShowSendCode;
  const ChangePhoneDialog({super.key, this.isShowSendCode = false});

  @override
  State<ChangePhoneDialog> createState() => _ChangePhoneDialogState();
}

class _ChangePhoneDialogState extends State<ChangePhoneDialog> {
  UserInfoController controller = Get.put(UserInfoController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: widget.isShowSendCode ? 765.h : 625.h,
        padding: EdgeInsets.symmetric(horizontal: 62.w),
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.customTheme?.dialogBgColor,
            borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 56.h,
                ),
                Text(
                  "手机号",
                  style: TextStyle(
                      fontSize: 51.sp, color: context.customTheme?.titleColor),
                ),
                SizedBox(
                  height: 70.h,
                ),
                Row(
                  children: [
                    // Text(
                    //   "手机号",
                    //   style: TextStyle(fontSize: 45.sp),
                    // ),
                    // SizedBox(
                    //   width: 90.w,
                    // ),
                    Expanded(
                      child: Obx(
                        () => LoginInputWidget(
                          height: 140.h,
                          hint: "手机号",
                          headIconPath: Assets
                              .theme1.images.login.iconInputLeftPhone.path,
                          onChanged: (str) {
                            controller.setPhone(str);
                          },
                          maxLength: 12,
                          defaultContent: controller.originUserPhone.value,
                          loginInputType: LoginInputWidgetType.phoneInputType,
                          countryCode: controller.countryCode.value,
                          isShowLeftIcon: false,
                          countrys: controller.countrys,
                          borderRadius: 30,
                          onCounrtyChanged: (code) {
                            controller.setCountryCode(code);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Visibility(
                //     visible: widget.isShowSendCode,
                //     child: SizedBox(
                //       height: 10.h,
                //     )),
                Visibility(
                    visible: widget.isShowSendCode,
                    child: Row(
                      children: [
                        // Text(
                        //   "验证码",
                        //   style: TextStyle(fontSize: 45.sp),
                        // ),
                        // SizedBox(
                        //   width: 90.w,
                        // ),
                        Expanded(
                          child: LoginInputWidget(
                            margin: EdgeInsets.only(top: 43.h),
                            height: 140.h,
                            hint: "验证码",
                            headIconPath: Assets
                                .theme1.images.login.iconInputLeftCode.path,
                            loginInputType: LoginInputWidgetType.codeType,
                            onChanged: (str) {
                              controller.setCode(str);
                            },
                            maxLength: 8,
                            borderRadius: 30,
                            isShowLeftIcon: false,
                            onValid: (Function cb) {
                              return controller.reqSMSCode(cb);
                            },
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 60.h,
                ),
                Obx(() => _buildButton()),
              ],
            ),
            Positioned(
              top: 38.h,
              right: -12.w,
              child: CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Icon(
                    Icons.clear,
                    size: 72.w,
                    color: context.customTheme?.dialogXColor,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton() {
    return CommonRipple(
      onTap: () async {
        AppManager.instance.tapVibrate();
        controller.reqBindPhone();
      },
      child: Container(
        height: 115.h,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: controller.isLoading.value
                ? context.theme.primaryColor.withOpacity(0.5)
                : context.theme.primaryColor,
            borderRadius: BorderRadius.circular(66.r)),
        child: controller.isLoading.value
            ? SizedBox(
                width: 48.w,
                height: 48.h,
                child: CircularProgressIndicator(
                  strokeWidth: 4.w,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(colorFFFFFF)), // 圆圈颜色
                ),
              )
            : Text(
                "确认",
                style: TextStyle(fontSize: 54.sp, color: Colors.white),
              ),
      ),
    );
  }
}
