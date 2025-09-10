import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../../../../gen/assets.gen.dart';

//重置登录密码的弹窗
class ResetLoginPwdDialog extends StatefulWidget {
  final bool isLoginType;
  const ResetLoginPwdDialog({super.key, this.isLoginType = true});

  @override
  State<ResetLoginPwdDialog> createState() => _ResetLoginPwdDialogState();
}

class _ResetLoginPwdDialogState extends State<ResetLoginPwdDialog> {
  bool isShowOldPwd = false; //是否显示原密码
  bool isShowNewPwd = false; //是否显示新密码
  bool isShowConfirmPwd = false; //是否显示确认密码

  bool isCanClick = false; //是否可以点击进行请求，默认false
  late TextEditingController oldPwdController;
  late TextEditingController newPwdController;
  late TextEditingController confirmPwdController;

  String oldPwd = "";
  String newPwd = "";
  String confirmPwd = "";
  String errorTips = "";

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    oldPwdController = TextEditingController()
      ..addListener(() {
        oldPwd = oldPwdController.text;
        setState(() {
          errorTips = _getVerifyErrorTip();
        });
      });
    newPwdController = TextEditingController()
      ..addListener(() {
        newPwd = newPwdController.text;
        setState(() {
          errorTips = _getVerifyErrorTip();
        });
      });
    confirmPwdController = TextEditingController()
      ..addListener(() {
        confirmPwd = confirmPwdController.text;
        setState(() {
          errorTips = _getVerifyErrorTip();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 1000.h,
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
                  widget.isLoginType ? "登录密码设置" : "支付密码设置",
                  style: TextStyle(fontSize: 51.sp),
                ),
                SizedBox(
                  height: 85.h,
                ),
                _buildInputWidget(
                    title: "原密码",
                    hint: "请输入原密码",
                    editController: oldPwdController,
                    isShowPwd: isShowOldPwd,
                    clickEye: (isShow) {
                      setState(() {
                        isShowOldPwd = isShow;
                      });
                    }),
                SizedBox(
                  height: 55.h,
                ),
                _buildInputWidget(
                    title: "新密码",
                    hint: "8~12位字符",
                    isShowPwd: isShowNewPwd,
                    editController: newPwdController,
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
                    editController: confirmPwdController,
                    isShowPwd: isShowConfirmPwd,
                    clickEye: (isShow) {
                      setState(() {
                        isShowConfirmPwd = isShow;
                      });
                    }),
                SizedBox(
                  height: 20.h,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorTips,
                    style: TextStyle(color: Colors.red, fontSize: 35.sp),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                ),
                GestureDetector(
                  onTap: isCanClick
                      ? () async {
                          AppManager.instance.tapVibrate();
                          bool isSuccess = false;
                          setState(() {
                            isLoading = true;
                          });
                          if (widget.isLoginType) {
                            isSuccess = await UserApi()
                                .changeLoginPwd(oldPwd, newPwd, false);
                          } else {
                            // isSuccess = await UserApi()
                            //     .changePayPwd(oldPwd, newPwd, false);
                          }
                          if (isSuccess) {
                            Get.back();
                            Get.snackbar("修改成功!", "");
                          }

                          setState(() {
                            isLoading = false;
                          });
                        }
                      : null,
                  child: Container(
                    height: 115.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: isCanClick
                            ? context.theme.primaryColor
                            : Color(colorF4F4F4),
                        borderRadius: BorderRadius.circular(66.r)),
                    child: isLoading
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
                            "确认修改",
                            style:
                                TextStyle(fontSize: 54.sp, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 38.h,
              right: -12.w,
              child: GestureDetector(
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
              GestureDetector(
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

  void verifyPwd() {}
  //验证失败的提示信息
  String _getVerifyErrorTip() {
    setState(() {
      //需要进行校验的时候，默认就为false
      isCanClick = false;
    });

    if (oldPwd.isEmpty) return "原密码不能为空";
    if (oldPwd.length < 6) return "密码不能少于6位";
    if (newPwd.isEmpty) return "新密码不能为空";
    if (newPwd.length < 6) return "新密码不能少于6位";
    if (confirmPwd.isEmpty) return "确认密码不能为空";
    if (confirmPwd != newPwd) return "两次密码不一致";
    setState(() {
      //能走到这里，说明能登录
      isCanClick = true;
    });
    return "";
  }
}
