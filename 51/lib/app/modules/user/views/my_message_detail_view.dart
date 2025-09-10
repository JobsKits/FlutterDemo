import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:get/get.dart';

import '../../../../utils/common_color.dart';

class MyMessageDetailView extends StatelessWidget {
  final String desc;
  const MyMessageDetailView({super.key, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "消息详情",
          style: TextStyle(color: context.customTheme?.appbarText),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.all(33.h),
        child: Text(
          desc,
          style: TextStyle(color: context.customTheme?.titleColor),
        ),
      ),
    );
    ;
  }
}
