import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/kernel/network/service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../api/user_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../data/user_info_bean2.dart';

//修改性别的弹窗
class ChangeSexDialog extends StatefulWidget {
  final UserInfoBean2 userInfo;
  const ChangeSexDialog({super.key, required this.userInfo});

  @override
  State<ChangeSexDialog> createState() => _ChangeSexDialogState();
}

class _ChangeSexDialogState extends State<ChangeSexDialog> {
  bool? isCheckMan; // 性别设置
  final bool isLoading = false;
  String oriValue = '';

  @override
  void initState() {
    super.initState();

    setState(() {
      int? gender = widget.userInfo.gender;
      if (gender == null) {
        oriValue = '';
      } else {
        if (gender == 1) {
          oriValue = '1';
        } else if (gender == 2) {
          oriValue = '2';
        } else {
          oriValue = '';
        }
      }
      isCheckMan = gender == null ? null : (gender == 1 ? true : false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: 658.h,
        width: double.infinity,
        decoration: BoxDecoration(
            color: context.customTheme?.dialogBgColor,
            borderRadius: BorderRadius.circular(40.r)),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "性别",
                  style: TextStyle(
                      fontSize: 51.sp, color: context.customTheme?.titleColor),
                ),
                HorizontalMargin(
                  left: 89.w,
                  right: 89.w,
                  child: Row(
                    children: [
                      Expanded(
                          child: CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          setState(() {
                            isCheckMan = true;
                          });
                        },
                        child: Container(
                            height: 166.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40.r),
                                color: isCheckMan == true
                                    ? Colors.white
                                    : const Color(colorF5F5F5),
                                border: isCheckMan == true
                                    ? Border.all(
                                        color: context.theme.primaryColor)
                                    : null),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Assets.theme1.images.user.iconMan,
                                  width: 48.w,
                                  height: 48.h,
                                ),
                                SizedBox(
                                  width: 37.w,
                                ),
                                Text(
                                  "男",
                                  style: TextStyle(
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )),
                      )),
                      SizedBox(
                        width: 40.w,
                      ),
                      Expanded(
                          child: CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          setState(() {
                            isCheckMan = false;
                          });
                        },
                        child: Container(
                          height: 166.h,
                          decoration: BoxDecoration(
                              color: isCheckMan == true
                                  ? const Color(colorF5F5F5)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(40.r),
                              border: isCheckMan == true
                                  ? null
                                  : Border.all(
                                      color: context.theme.primaryColor)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                Assets.theme1.images.user.iconWoman,
                                width: 48.w,
                                height: 48.h,
                              ),
                              SizedBox(
                                width: 37.w,
                              ),
                              Text(
                                "女",
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
                CommonRipple(
                  onTap: () async {
                    AppManager.instance.tapVibrate();
                    if (isLoading) {
                      return;
                    }

                    if (isCheckMan == null) {
                      EasyLoading.showError("请选择性别!");
                      return;
                    }

                    // bool isSuccess = await UserApi().changeGender(
                    //     isCheckMan == true ? 1 : 2,
                    //     widget.userInfo.contactName);

                    String newValue = '';
                    if (isCheckMan == true) {
                      newValue = '1';
                    } else {
                      newValue = '2';
                    }
                    int operMethod = 2;
                    if (oriValue.isEmpty) {
                      operMethod = 1;
                    }
                    var data = {
                      'ori_value': oriValue,
                      'new_value': newValue,
                      'trans_type': 101,
                      'busi_type': 201,
                      'oper_method': operMethod,
                    };
                    NetworkResponse res =
                        await UserApi().setContactMessage(data);
                    bool isSuccess = false;
                    if (res.type == NetworkService.networkTypeSuccess) {
                      if (res.data['response_code'] == '9999') {
                        isSuccess = true;
                      }
                    }
                    if (isSuccess) {
                      EasyLoading.showSuccess("修改成功!");
                      Get.back(result: isCheckMan == true ? "男" : "女");
                      // Get.snackbar("修改成功!", "");
                    } else {
                      EasyLoading.showError("修改失败!请稍后再试");
                      Get.back();
                      // Get.snackbar("修改失败!", "请稍后再试");
                    }
                  },
                  child: Container(
                    height: 115.h,
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 62.w),
                    decoration: BoxDecoration(
                        color: isLoading
                            ? context.theme.primaryColor.withOpacity(0.5)
                            : context.theme.primaryColor,
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
                            "确认",
                            style:
                                TextStyle(fontSize: 54.sp, color: Colors.white),
                          ),
                  ),
                )
              ],
            ),
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
                    color: context.customTheme?.dialogXColor,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
