import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../controllers/message_detail_controller.dart';

//消息详情页面
class MessageDetailView extends GetView<MessageDetailController> {
  const MessageDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF4F4F4),
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: BackButton(
            onPressed: () {
              Get.back();
            },
          ),
          title: Text("消息详情"),
          actions: [
            HorizontalMargin(
              left: 0,
              right: 47.h,
              child: Text(
                "删除",
                style: TextStyle(fontSize: 46.sp, color: Color(colorA6A6A6)),
              ),
            )
          ],
          centerTitle: true),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 83.h, left: 60.w, right: 60.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "通知主标题文案",
              style: TextStyle(fontSize: 63.sp, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 26.h),
              child: Text("2023-08-18 18:36",
                  style: TextStyle(fontSize: 36.sp, color: Color(colorA6A6A6))),
            ),
            _buildImg(),
            Text(
              "全网最高信誉，从演示站开始！作为国际专业的网 上博彩游戏运营商，我们承诺，为每一位客户提供 最安全、最公平的博彩娱乐，以及全方位的服务。 我们采用坚实、稳定与安全的博彩系统。所有游戏 共同的优点 — 不须耗时下载；界面简单明了；操 作功能齐全；画面精致优雅；游戏结果公平、公正 公开！由于您的信息保密度至关重要。我们将坚持 实行严格保密和隐私制度。 全网最高信誉，从演示站开始！作为国际专业的网 上博彩游戏运营商，我们承诺，为每一位客户提供 最安全、最公平的博彩娱乐，以及全方位的服务。 我们采用坚实、稳定与安全的博彩系统。所有游戏 共同的优点 — 不须耗时下载；界面简单明了；操 作功能齐全；画面精致优雅；游戏结果公平、公正 公开！由于您的信息保密度至关重要。我们将坚持 实行严格保密和隐私制度。",
              style: TextStyle(fontSize: 45.sp, color: Color(color4A4A4A)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildImg() {
    return Obx(() => controller.isImgType.value
        ? Container(
            margin: EdgeInsets.only(bottom: 31.h),
            height: 476.h,
            color: Colors.black26,
          )
        : SizedBox());
  }
}
