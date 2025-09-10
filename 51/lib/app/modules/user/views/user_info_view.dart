import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/debounce_throttle.dart';
import '../controllers/user_info_controller.dart';

//个人信息页面
class UserInfoView extends GetView<UserInfoController> {
  const UserInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("个人信息",
            style: TextStyle(color: context.customTheme?.appbarText)),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 144.h, left: 33.w, right: 33.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() => CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    Get.toNamed(Routes.CHANGE_AVATAR)?.then((_) {
                      controller.initUserInfo();
                    });
                  },
                  child: CircleAvatar(
                    radius: 103.w,
                    backgroundColor: Colors.black26,
                    backgroundImage: NetworkImage(controller.userHead.value),
                  ),
                )),
            SizedBox(
              height: 206.h,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: Column(
                children: List.generate(controller.infoList.length, (index) {
                  return CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      DebounceThrottle.debounce(
                          () => controller.clickItem(index))();
                    },
                    child: Obx(
                      () => _buildListItem(
                        context,
                        title: controller.infoList[index].title,
                        defaultValue: controller.infoList[index].desc.value,
                        isUid: index == 2,
                        canUpdatePhone: controller.canUpdatePhone.value,
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context, {
    required String title,
    String defaultValue = "",
    bool isUid = false,
    bool canUpdatePhone = true,
  }) {
    if (title == '手机号' && canUpdatePhone == false) {
      return Container(
        height: 185.h,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: context.customTheme?.lineColor ?? Colors.white)),
            color: context.customTheme?.pageTwoBg),
        child: Row(
          children: [
            Expanded(child: Text(title)),
            Text(defaultValue),
            // SizedBox(
            //   width: 40.w,
            // ),
          ],
        ),
      );
    } else {
      return Container(
        height: 185.h,
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: context.customTheme?.lineColor ?? Colors.white)),
          color: context.customTheme?.pageTwoBg,
        ),
        child: Row(
          children: [
            Expanded(
                child: Text(title,
                    style: TextStyle(
                        color:
                            context.customTheme?.title2Color ?? Colors.white))),
            Text(defaultValue,
                style: TextStyle(
                    color: context.customTheme?.titleColor ?? Colors.white)),
            SizedBox(
              width: 40.w,
            ),
            isUid
                ? CommonRipple(
                    onTap: () {
                      AppManager.instance.tapVibrate();
                      ClipboardUtil.copy(defaultValue);
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
                      child: SvgPicture.asset(
                        Assets.theme1.images.user.iconCopy,
                        width: 42.w,
                        height: 42.h,
                      ),
                    ))
                : Icon(
                    Icons.arrow_forward_ios,
                    size: 50.w,
                    color: context.customTheme?.arrowColor,
                  )
          ],
        ),
      );
    }
  }
}
