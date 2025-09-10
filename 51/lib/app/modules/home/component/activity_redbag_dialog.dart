import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_redbag_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';
import '../../../../utils/CommonRipple.dart';

class ActivityRedbagDialog extends StatefulWidget {
  final Function(bool)? onClose;

  const ActivityRedbagDialog({Key? key, this.onClose}) : super(key: key);

  @override
  State<ActivityRedbagDialog> createState() => _ActivityRedbagDialogState();
}

class _ActivityRedbagDialogState extends State<ActivityRedbagDialog>
    with TickerProviderStateMixin {
  final ActivitysRedbagController controller =
      Get.put(ActivitysRedbagController());
  bool show = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withAlpha(50),
        width: Get.width,
        height: Get.height,
        child: Center(
          child: _displayRadbag(),
        )).onTap(() {
      AppManager.instance.tapVibrate();
      controller.wheelStatus.value = false;
    });
  }

  Widget _displayRadbag() {
    return Stack(children: [
      Positioned.fill(
        child: Container(
            child: Image.asset(
          Assets.theme1.images.home.activityBg.path,
          fit: BoxFit.contain,
        )),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Image.asset(
              Assets.theme1.images.home.activityTitle1.path,
              fit: BoxFit.contain,
              width: 150,
              height: 60,
            ),
            Image.asset(
              Assets.theme1.images.home.activityTitle2.path,
              fit: BoxFit.contain,
              width: 300.w,
              height: 40,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 50),
                Text(
                  '${controller.price.value}',
                  style: TextStyle(
                    color: Color(0xFFFDEBA3),
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  Assets.theme1.images.home.activityYuan.path,
                  fit: BoxFit.contain,
                  width: 40,
                  height: 30,
                  color: Color(0xFFFDEBA3),
                ),
                const SizedBox(width: 50),
              ],
            ),
            const SizedBox(height: 125),
            Stack(
              alignment: Alignment.center,
              children: [
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    getRedBag();
                  },
                  child: Image.asset(
                    Assets.theme1.images.home.activityReceive.path,
                    fit: BoxFit.cover,
                    width: 200,
                    height: 52.5,
                  ),
                ),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    getRedBag();
                  },
                  child: Image.asset(
                    Assets.theme1.images.home.activityReceivetitle.path,
                    fit: BoxFit.cover,
                    width: 85,
                    height: 20,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ]);
  }

  void getRedBag() {
    if (LoginManager.instance.isLogin.value) {
      controller.checkRedbagCanReceive();
    } else {
      controller.wheelStatus.value = false;
      showLoginDialog();
    }
  }
}
