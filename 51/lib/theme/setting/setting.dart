import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/base.theme.dart';
import 'package:flutter_tiyu_app/theme/setting/chat.collapse.dart';
import 'package:flutter_tiyu_app/theme/setting/controller/controller.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:get/get.dart';

class SettingPage extends GetView<SettingController> {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "设置",
            style: TextStyle(fontSize: 57.sp, color: Colors.black),
          ),
          centerTitle: true,
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Column(
          children: [
            ChatCollapse(
              valueAlign: Alignment.centerRight,
              label: "修改主题",
              valueWidget: Obx(() => UnconstrainedBox(
                    child: DropdownButton<ThemeObjMode>(
                        value: controller.theme.value,
                        items: [
                          DropdownMenuItem(
                            value: ThemeObjMode.blue,
                            child: Container(
                              width: 30,
                              height: 30,
                              color: BaseTheme.primaryBlueLight,
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeObjMode.gold3,
                            child: Container(
                              width: 30,
                              height: 30,
                              color: BaseTheme.primaryGold3Light,
                            ),
                          ),
                          DropdownMenuItem(
                            value: ThemeObjMode.blackGold,
                            child: Container(
                              width: 30,
                              height: 30,
                              color: BaseTheme.primaryBlackGoldLight,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          controller.updateTheme(value!);
                        }),
                  )),
            ),
          ],
        ));
  }
}
