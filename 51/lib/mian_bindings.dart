import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/home_data_manager.dart';
import 'package:flutter_tiyu_app/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MainBindings extends Bindings {
  @override
  void dependencies() {
    // Get.lazyPut(() => HomeController());
    Get.lazyPut(() => HomeRequestManager());
    // You can put other bindings here
  }
}
