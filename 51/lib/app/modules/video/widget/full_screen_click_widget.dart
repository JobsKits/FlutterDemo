import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_detail_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../controllers/video_black_detail_controller.dart';

//全屏后，响应点击的组件
class FullScreenClickWidget extends StatefulWidget {
  final bool isBlack;
  const FullScreenClickWidget({super.key, this.isBlack = false});

  @override
  State<FullScreenClickWidget> createState() => _FullScreenClickWidgetState();
}

class _FullScreenClickWidgetState extends State<FullScreenClickWidget> {
  late var controller;
  @override
  void initState() {
    super.initState();
    if (widget.isBlack) {
      controller = Get.find<VideoBlackDetailController>();
    } else {
      controller = Get.find<VideoDetailController>();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        controller.showOrHideController();
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }
}
