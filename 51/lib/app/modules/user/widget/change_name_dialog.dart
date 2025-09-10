import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/user_api.dart';
import 'package:flutter_tiyu_app/app/data/login_bean.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/user_info_controller.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/debounce_throttle.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';

import '../../../../kernel/network/error.dart';
import '../../../../kernel/network/service.dart';
import '../../../../utils/CommonRipple.dart';

class ChangeNameDialog extends StatefulWidget {
  final bool isRealName;
  final String oriValue;
  const ChangeNameDialog(
      {super.key, this.isRealName = false, required this.oriValue});

  @override
  State<ChangeNameDialog> createState() => _ChangeNameDialogState();
}

class _ChangeNameDialogState extends State<ChangeNameDialog> {
  String name = "";
  late UserInfoController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 70.w),
      child: Container(
        height: widget.isRealName ? 690.h : 600.h,
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
                  widget.isRealName ? "姓名" : "昵称",
                  style: TextStyle(
                      fontSize: 51.sp, color: context.customTheme?.titleColor),
                ),
                Container(
                  height: 125.h,
                  margin: EdgeInsets.symmetric(horizontal: 62.w),
                  decoration: BoxDecoration(
                      color: context.customTheme?.inputBgColor,
                      borderRadius: BorderRadius.circular(30.r)),
                  child: TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    cursorColor: context.theme.primaryColor,
                    style: TextStyle(
                      color: context.customTheme
                          ?.titleColor, // Set your desired text color
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 60.h, left: 36.w),
                      hintText: widget.isRealName ? "请输入真实姓名" : "请输入昵称",
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
                  ),
                ),
                if (widget.isRealName)
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 65.w),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '提示：\n1：该姓名将默认为出款姓名。\n2：一经确认，无法修改。',
                        style: TextStyle(
                          fontSize: 36.sp,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                Obx(() => _buildButton())
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

  Future<void> _handleTap() async {
    if (name.isEmpty) {
      EasyLoading.showError("修改失败!\n内容不能为空");
      // Get.snackbar("修改失败!", "内容不能为空");
      return;
    }
    bool isSuccess = false;
    controller.isLoading.value = true;
    var errorTips = "";
    if (widget.isRealName) {
      int operMethod = 2;
      if (widget.oriValue.isEmpty) {
        operMethod = 1;
      }
      var data = {
        'ori_value': widget.oriValue,
        'new_value': name,
        'trans_type': 101,
        'busi_type': 200,
        'oper_method': operMethod,
      };
      NetworkResponse res = await UserApi().setContactMessage(data);
      if (res.type == NetworkService.networkTypeSuccess) {
        if (res.data['response_code'] == '9999') {
          isSuccess = true;
          LoginManager.instance.loginInfo?.custContact?.contactName = name;
          await SpUtil.saveBean<LoginBean>(
              "loginBean", LoginManager.instance.loginInfo!);
        }
      } else {
        if (res.data is NetworkError) {
          NetworkError error = res.data;
          errorTips = error.info;
          isSuccess = false;
        }
      }
    } else {
      isSuccess = await UserApi().changeNickName(name);
    }

    if (isSuccess) {
      Get.back(result: name);
      // Get.snackbar("修改成功!", "");
      EasyLoading.showSuccess("修改成功!");
    } else {
      Get.back();
      if (errorTips.isNotEmpty) {
        // Get.snackbar("修改失败!", "${errorTips}");
        EasyLoading.showError("修改失败!\n${errorTips}");
      } else {
        // Get.snackbar("修改失败!", "请稍后再试");
        EasyLoading.showError("修改失败!\n内容不能为空");
      }
    }
    controller.isLoading.value = false;
  }

  Widget _buildButton() {
    return CommonRipple(
      onTap: () async {
        AppManager.instance.tapVibrate();
        if (controller.isLoading.value) {
          return;
        }
        DebounceThrottle.debounce(() => _handleTap())();
      },
      child: Container(
        height: 115.h,
        width: double.infinity,
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(horizontal: 62.w),
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
