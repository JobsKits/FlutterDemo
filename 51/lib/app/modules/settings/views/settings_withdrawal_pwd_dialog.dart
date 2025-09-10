import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/settings/views/withdrawal_pwd_pint_widget.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/CommonRipple.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/app_manager.dart';
import '../../user/controllers/settings_withdrawal_pwd_dialog_controller.dart';

class SettingsWithdrawalPwdDialog extends StatefulWidget {
  const SettingsWithdrawalPwdDialog({super.key});
  @override
  State<SettingsWithdrawalPwdDialog> createState() =>
      _SettingsWithdrawalPwdDialogState();
}

class _SettingsWithdrawalPwdDialogState
    extends State<SettingsWithdrawalPwdDialog> {
  SettingsWithdrawalPwdDialogController controller =
      Get.put(SettingsWithdrawalPwdDialogController());

  @override
  void dispose() {
    Get.delete<SettingsWithdrawalPwdDialogController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(36.r), // 去掉圆角
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IntrinsicHeight(
            child: Container(
              width: 0.9.sw,
              decoration: BoxDecoration(
                  color:
                      context.customTheme?.settingsWithdrawalPwdDialogBgColor,
                  borderRadius: BorderRadius.circular(36.r)),
              padding: EdgeInsets.only(top: 30.h, left: 50.w, right: 50.w),
              child: Obx(() => Column(
                    children: [
                      Text(
                        "设置提现密码",
                        style: TextStyle(
                            fontSize: 56.sp,
                            fontWeight: FontWeight.bold,
                            color:
                                context.customTheme?.rechargeSecondTypeBgColor),
                      ),
                      if (controller.hasPwd.value) oldPwdWidget(),
                      currentPwdWidget(),
                      confirmPwdWidget(),
                      SizedBox(
                        height: 50.h,
                      ),
                      _errorTipsText(),
                      FittedBox(
                          fit: BoxFit.scaleDown, // 自动缩小以适配宽度
                          child: Text(
                            "注意：提现密码不可随意告知他人，以免造成资金损失",
                            style:
                                TextStyle(fontSize: 36.sp, color: Colors.red),
                          )),
                      Container(
                        margin: EdgeInsets.only(top: 40.h, bottom: 60.h),
                        width: 1.sw,
                        height: 120.h,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.handleSubmit();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: context.theme.primaryColor,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            "确认设置",
                            style:
                                TextStyle(fontSize: 52.sp, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
          ),
          Positioned(
            bottom: -110.h,
            left: 0,
            right: 0,
            child: UnconstrainedBox(
              child: Container(
                width: 90.w,
                height: 90.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(45.r),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.close_sharp,
                  color: Colors.grey,
                  size: 20,
                ),
              ).onTap(() {
                Get.back();
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget oldPwdWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 60.h, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "旧提现密码",
                    style: TextStyle(
                        fontSize: 40.sp,
                        color: context.customTheme?.rechargeSecondTypeBgColor),
                  ),
                  CommonRipple(
                      onTap: () {
                        setState(() {
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.isShowOldStylePwd.value =
                              !controller.isShowOldStylePwd.value;
                          if (controller.isShowOldStylePwd.value) {
                            controller.oldStylePwd.value = "";
                          }
                        });
                      },
                      child: Text(
                        controller.isShowOldStylePwd.value
                            ? "  点击切换最新格式"
                            : "  老用户？点击切换格式",
                        style: TextStyle(
                            fontSize: 40.sp, color: context.theme.primaryColor),
                      )),
                ],
              ),
              InkWell(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.oldPwdIsShow.value =
                      !controller.oldPwdIsShow.value;
                },
                child: Obx(() => SvgPicture.asset(
                      controller.oldPwdIsShow.value
                          ? Assets.theme1.images.login.iconInputEyeClose
                          : Assets.theme1.images.login.iconInputEyeOpen,
                      width: 50.w,
                      height: 50.h,
                    )),
              )
            ],
          ),
        ),
        if (controller.isShowOldStylePwd.value) oldStyleInputWidget(),
        if (!controller.isShowOldStylePwd.value)
          WithdrawalPwdPintWidget(
            pwdIsShow: controller.oldPwdIsShow.value,
            onChanged: (str) {
              controller.setOldPwd(str);
            },
            onCompleted: (str) {
              controller.setOldPwd(str);
            },
            fucChange: (hasFuc) {
              if (!hasFuc) {
                //校验输入
                controller.doVerify();
              }
            },
          ),
        if (controller.oldPwdTips.value.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 50.w,
                  ),
                ),
                Text(
                  controller.oldPwdTips.value,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          )
      ],
    );
  }

  Widget currentPwdWidget() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 60.h, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "设置提现密码",
                style: TextStyle(
                    fontSize: 40.sp,
                    color: context.customTheme?.rechargeSecondTypeBgColor),
              ),
              InkWell(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.currentPwdIsShow.value =
                      !controller.currentPwdIsShow.value;
                },
                child: Obx(() => SvgPicture.asset(
                      controller.currentPwdIsShow.value
                          ? Assets.theme1.images.login.iconInputEyeClose
                          : Assets.theme1.images.login.iconInputEyeOpen,
                      width: 50.w,
                      height: 50.h,
                    )),
              )
            ],
          ),
        ),
        WithdrawalPwdPintWidget(
          pwdIsShow: controller.currentPwdIsShow.value,
          onChanged: (str) {
            controller.setUserPwd(str);
          },
          onCompleted: (str) {
            controller.setUserPwd(str);
          },
          fucChange: (hasFuc) {
            if (!hasFuc) {
              //校验输入
              controller.doVerify();
            }
          },
        ),
        if (controller.userPwdTips.value.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 50.w,
                  ),
                ),
                Text(
                  controller.userPwdTips.value,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          )
      ],
    );
  }

  Widget confirmPwdWidget() {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.only(left: 10.w, right: 10.w, top: 60.h, bottom: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "确认提现密码",
                style: TextStyle(
                    fontSize: 40.sp,
                    color: context.customTheme?.rechargeSecondTypeBgColor),
              ),
              InkWell(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.confirmPwdIsShow.value =
                      !controller.confirmPwdIsShow.value;
                },
                child: Obx(() => SvgPicture.asset(
                      controller.confirmPwdIsShow.value
                          ? Assets.theme1.images.login.iconInputEyeClose
                          : Assets.theme1.images.login.iconInputEyeOpen,
                      width: 50.w,
                      height: 50.h,
                    )),
              )
            ],
          ),
        ),
        WithdrawalPwdPintWidget(
          pwdIsShow: controller.confirmPwdIsShow.value,
          onChanged: (str) {
            controller.setConfirmPwd(str);
          },
          onCompleted: (str) {
            controller.setConfirmPwd(str);
          },
          fucChange: (hasFuc) {
            if (!hasFuc) {
              //校验输入
              controller.doVerify();
            }
          },
        ),
        if (controller.confirmPwdTips.value.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(top: 6.h),
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 4.h),
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.red,
                    size: 50.w,
                  ),
                ),
                Text(
                  controller.confirmPwdTips.value,
                  style: const TextStyle(color: Colors.red),
                )
              ],
            ),
          )
      ],
    );
  }

  //登录校验失败的提示信息
  Widget _errorTipsText() {
    return Obx(() {
      final errorText = controller.verifyErrorTips.value;
      if (errorText.isEmpty) return const SizedBox();
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 4.h),
                child: Icon(
                  Icons.error,
                  size: 50.w,
                  color: const Color(colorE01509),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                errorText,
                style: TextStyle(
                  fontSize: 42.sp,
                  color: const Color(colorE01509),
                ),
              ),
            ],
          ),
          SizedBox(height: 32.h),
        ],
      );
    });
  }

  Widget oldStyleInputWidget() {
    return Container(
      height: 124.h,
      decoration: BoxDecoration(
          color: const Color(colorDDDDDD).withOpacity(0.4),
          borderRadius: BorderRadius.circular(24.r)),
      child: TextFormField(
        obscureText: controller.oldPwdIsShow.value,
        onChanged: (str) {
          controller.setOldStylePwd(str);
        },
        cursorColor: const Color(theme01MainColor),
        buildCounter: (context,
                {required currentLength,
                required isFocused,
                required maxLength}) =>
            null, // 不显示计数器
        style: TextStyle(fontSize: 50.sp),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 30.h, left: 30.w),
          hintText: "请输入旧提现密码",
          hintStyle: TextStyle(
            fontSize: 40.sp,
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
    );
  }
}
