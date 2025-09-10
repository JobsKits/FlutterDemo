import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/login/views/login_input_widget.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/forget_password_controller.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/common_color.dart';

class ForgetPasswordDialog extends StatefulWidget {
  const ForgetPasswordDialog({super.key});

  @override
  State<ForgetPasswordDialog> createState() => _ForgetPasswordDialogState();
}

class _ForgetPasswordDialogState extends State<ForgetPasswordDialog> {
  late ForgetPasswordController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ForgetPasswordController());
  }

  @override
  void dispose() {
    Get.delete<ForgetPasswordController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 55.w),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBody(context),
                SizedBox(
                  height: 40.h,
                ),
                CommonRipple(
                  //弹窗的关闭按钮
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back(); // 关闭弹窗
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 45.w,
                    child: SvgPicture.asset(
                      Assets.theme1.images.home.iconDialogClose,
                      width: 39.w,
                      height: 39.h,
                      colorFilter:
                          const ColorFilter.mode(Colors.black, BlendMode.srcIn),
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

  _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 21.h),
      padding: EdgeInsets.symmetric(horizontal: 76.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          SizedBox(height: 50.h),
          Text(
            '忘记密码',
            style: TextStyle(
              fontSize: 56.sp,
              color: context.theme.primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20.h),
          Obx(() {
            return LoginInputWidget(
              margin: EdgeInsets.only(top: 43.h),
              hint: "手机号",
              headIconPath: Assets.theme1.images.login.iconInputLeftPhone.path,
              onChanged: (str) {
                controller.setPhone(str);
              },
              loginInputType: LoginInputWidgetType.phoneInputType,
              countryCode: controller.countryCode.value,
              countrys: controller.countrys,
              onCounrtyChanged: (code) {
                controller.setCountryCode(code);
              },
            );
          }),
          LoginInputWidget(
            margin: EdgeInsets.only(top: 43.h),
            hint: "密码",
            isShowPwd: true,
            defaultContent: controller.userPwd.value,
            headIconPath: Assets.theme1.images.login.iconInputLeftPwd.path,
            onChanged: (str) {
              controller.setPwd(str);
            },
            loginInputType: LoginInputWidgetType.userPwdInputType,
          ),
          LoginInputWidget(
            margin: EdgeInsets.only(top: 43.h),
            hint: "再次确认密码",
            isShowPwd: true,
            defaultContent: controller.userConfirmPwd.value,
            headIconPath: Assets.theme1.images.login.iconInputLeftPwd.path,
            onChanged: (str) {
              controller.setConfirmPwd(str);
            },
            loginInputType: LoginInputWidgetType.userPwdInputType,
          ),
          LoginInputWidget(
            margin: EdgeInsets.only(top: 43.h),
            hint: "验证码",
            defaultContent: controller.userCode.value,
            headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
            loginInputType: LoginInputWidgetType.codeType,
            onChanged: (str) {
              controller.setCode(str);
            },
            onValid: (Function cb) {
              return controller.reqSMSCode(cb);
            },
          ),
          SizedBox(height: 30.h),
          _errorTipsText(), //登录校验失败的提示信息
          SizedBox(height: 50.h),
          _buildForgetButton(),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  //登录校验失败的提示信息
  Widget _errorTipsText() {
    return Obx(() {
      final errorText = controller.verifyErrorTips.value;
      if (errorText.isEmpty) return const SizedBox();
      return Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(errorText,
                style: TextStyle(fontSize: 38.sp, color: Colors.red)),
          ),
          SizedBox(height: 32.h),
        ],
      );
    });
  }

  //忘密码按钮
  Widget _buildForgetButton() {
    return SizedBox(
      width: 863.w,
      height: 125.h,
      child: Obx(
        () => ElevatedButton(
          onPressed: controller.isCanForget.value
              ? () {
                  AppManager.instance.tapVibrate();
                  if (!controller.isLoading.value) {
                    controller.handleForget();
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
              backgroundColor: controller.isLoading.value
                  ? context.theme.primaryColor.withOpacity(0.3)
                  : context.theme.primaryColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              controller.isLoading.value
                  ? SizedBox(
                      width: 48.w,
                      height: 48.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 4.w,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(colorFFFFFF),
                        ), // 圆圈颜色
                      ),
                    )
                  : Text(
                      "确认",
                      style: TextStyle(fontSize: 52.sp, color: Colors.white),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
