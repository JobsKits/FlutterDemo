import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import '../../../../utils/CommonRipple.dart';
import '../data/tutorials_config_bean.dart';

///充值界面的充值按钮组件
// ignore: must_be_immutable
class RechargeTutorialsTextWidget extends StatelessWidget {
  RechargeTutorialsTextWidget({super.key});
  late RechargeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isShowTutorial.value) {
        return CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            _showTutorialsBottomSheet();
          },
          child: Text(
            "充值教程>",
            style: TextStyle(
                decoration: TextDecoration.underline,
                decorationColor: context.theme.primaryColor,
                fontSize: 36.sp,
                color: context.theme.primaryColor),
          ),
        );
      }
      return const SizedBox();
    });
  }

  /// 底部弹出
  void _showTutorialsBottomSheet() {
    TutorialsConfigBean configBean = controller.getTutorialsConfig();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? Colors.grey[800] : Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 添加标题
            Container(
              width: double.infinity,
              color: Colors.white,
              height: 130.h,
              child: Center(
                child: Text(
                  configBean.title,
                  style: TextStyle(
                    fontSize: 52.sp,
                    color: const Color(color2D2D2D),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
                child: Container(
              color: const Color(colorF5F5F5),
              padding: EdgeInsets.fromLTRB(34.w, 0, 34.w, 50.h),
              child: Column(
                children: List.generate(configBean.contentList.length, (index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    margin: EdgeInsets.only(top: 30.h),
                    child: ListTile(
                      title: Text(configBean.contentList[index]),
                      titleTextStyle: TextStyle(
                          fontSize: 46.sp, color: const Color(color313131)),
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.handleTutorials(index);
                      },
                    ),
                  );
                }),
              ),
            )),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }
}
