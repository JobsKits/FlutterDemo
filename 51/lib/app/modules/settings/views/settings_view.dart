import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        title: Text(
          "设置",
          style: TextStyle(
            fontSize: 57.sp,
            color: context.customTheme?.appbarText,
          ),
        ),
        backgroundColor: context.customTheme?.navbarBg,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 33.w),
          margin: EdgeInsets.only(top: 10.h),
          child: Column(
            children: [
              _buildList1(context),
              _buildList2(context),
              _buildList3(context),
              _buildVibrationItem(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildList1(BuildContext context) {
    List<SettingBean> list = controller.settingList.sublist(0, 1);
    return _buildListView(context, list);
  }

  Widget _buildList2(BuildContext context) {
    List<SettingBean> list = controller.settingList.sublist(1, 3);
    return _buildListView(context, list);
  }

  Widget _buildList3(BuildContext context) {
    List<SettingBean> list = controller.settingList.sublist(3, 5);
    return _buildListView(context, list);
  }

  Widget _buildVibrationItem(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30.h, left: 0.w, right: 0.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          color: context.customTheme?.pageTwoBg),
      child: ListTile(
        leading: Icon(
          Icons.vibration,
          color: context.theme.primaryColor,
        ),
        title: Text(
          '震动提示',
          style: TextStyle(
              fontSize: 42.sp, color: context.customTheme?.titleColor),
        ),
        trailing: Obx(
          () => Switch(
            activeColor: Colors.white,
            inactiveTrackColor: Colors.white,
            activeTrackColor: context.theme.primaryColor,
            value: AppManager.instance.isVibrationEnabled.value,
            onChanged: (bool value) {
              AppManager.instance.vibrationChanged(value);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context, List<SettingBean> list) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: context.customTheme?.pageTwoBg,
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
              margin: EdgeInsets.only(left: 40.w, right: 40.w),
              decoration: (index != list.length - 1)
                  ? const BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.grey, width: 0.2), // 添加下划线
                      ),
                    )
                  : null,
              child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.onClickItem(list[index]);
                },
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: _buildListItemIcon(context, list[index].key),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 36.w,
                    color: const Color(colorCECECE),
                  ),
                  title: Row(
                    children: [
                      Expanded(
                          child: Text(
                        list[index].title,
                        style: TextStyle(
                            fontSize: 42.sp,
                            color: context.customTheme?.titleColor),
                      )),
                      Obx(() => Visibility(
                          visible: list[index].key == SettingEnum.clearCache,
                          child: Text(
                            controller.cacheSize.value,
                            style: TextStyle(
                                fontSize: 42.sp,
                                color: context.customTheme?.titleColor),
                          )))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  Widget _buildListItemIcon(BuildContext context, SettingEnum key) {
    switch (key) {
      case SettingEnum.userInfo:
        return SvgPicture.asset(
          Assets.theme1.images.settings.iconUser,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
      case SettingEnum.loginPwd:
        return SvgPicture.asset(
          Assets.theme1.images.settings.iconLoginPwd,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
      case SettingEnum.paymentPwd:
        return SvgPicture.asset(
          Assets.theme1.images.settings.iconPayPwd,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
      case SettingEnum.language:
        return SvgPicture.asset(
          Assets.theme1.images.settings.iconLanguage,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
      case SettingEnum.clearCache:
        return SvgPicture.asset(
          Assets.theme1.images.settings.iconClearCache,
          width: 50.w,
          height: 50.h,
          color: context.theme.primaryColor,
        );
    }
  }

  // void showChangePasswordDialog() {
  //   print('=====> inini');
  //   Get.defaultDialog(
  //     title: "修改登录密码",
  //     content: Form(
  //       key: controller.loginPwdformKey,
  //       child: Column(
  //         children: [
  //           TextFormField(
  //             decoration: InputDecoration(labelText: "原密码"),
  //             obscureText: true,
  //             onChanged: (value) {
  //               controller.oldPassword.value = value;
  //             },
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return '原密码不能为空';
  //               }
  //               return null;
  //             },
  //           ),
  //           TextFormField(
  //             decoration: InputDecoration(labelText: "新密码"),
  //             obscureText: true,
  //             onChanged: (value) {
  //               controller.newPassword.value = value;
  //             },
  //             validator: (value) {
  //               if (value == null || value.isEmpty) {
  //                 return '新密码不能为空';
  //               } else if (value.length <= 6) {
  //                 return '密码长度必须大于6个字符';
  //               }
  //               return null;
  //             },
  //           ),
  //           TextFormField(
  //             decoration: InputDecoration(labelText: "确认密码"),
  //             obscureText: true,
  //             onChanged: (value) {
  //               controller.confirmPassword.value = value;
  //             },
  //             validator: (value) {
  //               if (value != controller.newPassword.value) {
  //                 return '密码不匹配';
  //               }
  //               return null;
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //     confirm: ElevatedButton(
  //       child: Text("确认"),
  //       onPressed: () {
  //         // if (_formKey.currentState?.validate() ?? false) {
  //         //   // 可以在这里执行密码修改逻辑
  //         //   print('原密码: ${oldPassword.value}, 新密码: ${newPassword.value}');
  //         //   Get.back(); // 关闭对话框
  //         // }
  //       },
  //     ),
  //     cancel: ElevatedButton(
  //       child: Text("取消"),
  //       onPressed: () {
  //         Get.back(); // 关闭对话框
  //       },
  //     ),
  //   );
  // }
}
