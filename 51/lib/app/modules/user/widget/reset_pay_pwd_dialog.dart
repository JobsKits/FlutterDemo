import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';

//重置支付密码的弹窗
class ResetPayPwdDialog extends StatefulWidget {
  const ResetPayPwdDialog({super.key});

  @override
  State<ResetPayPwdDialog> createState() => _ResetLoginPwdDialogState();
}

class _ResetLoginPwdDialogState extends State<ResetPayPwdDialog> {
  bool isShowNewPwd = false; //是否显示新密码
  bool isShowConfirmPwd = false; //是否显示确认密码

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 825.h,
        padding: EdgeInsets.symmetric(horizontal: 62.w),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 56.h,
                ),
                Text(
                  "支付密码设置",
                  style: TextStyle(fontSize: 51.sp),
                ),
                SizedBox(
                  height: 85.h,
                ),
                _buildInputWidget(
                    title: "支付密码",
                    hint: "8~12位字符",
                    isShowPwd: isShowNewPwd,
                    clickEye: (isShow) {
                      setState(() {
                        isShowNewPwd = isShow;
                      });
                    }),
                SizedBox(
                  height: 55.h,
                ),
                _buildInputWidget(
                    title: "确认密码",
                    hint: "请再次输入新密码",
                    isShowPwd: isShowConfirmPwd,
                    clickEye: (isShow) {
                      setState(() {
                        isShowConfirmPwd = isShow;
                      });
                    }),
                SizedBox(
                  height: 90.h,
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.back();
                  },
                  child: Container(
                    height: 115.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(66.r)),
                    child: Text(
                      "确认设置",
                      style: TextStyle(fontSize: 54.sp, color: Colors.white),
                    ),
                  ),
                ),
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
                    color: Colors.black26,
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget(
      {required String title,
      required String hint,
      TextEditingController? editController,
      isShowPwd = false,
      required ValueChanged clickEye}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title",
          style: TextStyle(fontSize: 45.sp),
        ),
        Container(
          width: 635.w,
          height: 125.h,
          padding: EdgeInsets.symmetric(horizontal: 45.w),
          decoration: BoxDecoration(
              color: Color(colorF4F4F4),
              borderRadius: BorderRadius.circular(30.r)),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                onChanged: (value) {},
                cursorColor: context.theme.primaryColor,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(top: 60.h),
                  hintText: "$hint",
                  hintStyle: TextStyle(
                      fontSize: 36.sp, color: const Color(colorBCBCBC)),
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
                obscureText: isShowPwd ? true : false,
                controller: editController,
              )),
              CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  clickEye(!isShowPwd);
                },
                child: SvgPicture.asset(
                  isShowPwd
                      ? Assets.theme1.images.login.iconInputEyeClose
                      : Assets.theme1.images.login.iconInputEyeOpen,
                  width: 54.w,
                  height: 54.h,
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
