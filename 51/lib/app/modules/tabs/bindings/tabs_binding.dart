import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/user_controller.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_controller.dart';
import 'package:get/get.dart';

import '../../wallet/controllers/recharge_controller.dart';
import '../controllers/tabs_controller.dart';

import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_task_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_activity_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_sign_in_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_rebate_new_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_yuebao_page.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_vip_page.dart';

class TabsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<ActivityController>(
      () => ActivityController(),
    );
    Get.lazyPut<NewHomeController>(
      () => NewHomeController(),
    );
    // Get.lazyPut<RechargeController>(
    //   () => RechargeController(),
    // );
    Get.lazyPut<UserController>(
      () => UserController(),
    );
    Get.lazyPut<VideoController>(
      () => VideoController(),
    );

    Get.lazyPut<ControllerActivityPage>(
      () => ControllerActivityPage(),
    );
    Get.lazyPut<ControllerTaskPage>(
      () => ControllerTaskPage(),
    );
    Get.lazyPut<ControllerSignInPage>(
      () => ControllerSignInPage(),
    );
    Get.lazyPut<ControllerRebatePage>(
      () => ControllerRebatePage(),
    );
    Get.lazyPut<ControllerYuebaoPage>(
      () => ControllerYuebaoPage(),
    );
    Get.lazyPut<ControllerVipPage>(
      () => ControllerVipPage(),
    );
  }
}
