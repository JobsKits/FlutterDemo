import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/system_notify_detail_controller.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

///系统公告详情页
class SystemNotifyDetailView extends GetView<SystemNotifyDetailController> {
  const SystemNotifyDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          "公告详情",
          style: TextStyle(
              fontSize: 57.sp, color: context.customTheme?.appbarText),
        ),
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 33.w, vertical: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: context.customTheme?.pageTwoBg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text("${controller.title}",
                  style: TextStyle(
                      color: context.customTheme?.titleColor, fontSize: 18)),
            ),
            Text(
              "${controller.time}",
              style: TextStyle(color: context.customTheme?.titleColor),
            ),
            Obx(() => controller.isImage.value
                ? CachedNetworkImage(imageUrl: controller.url)
                : Expanded(
                    child: HtmlWidget(controller.url),
                    // WebViewWidget(controller: controller.webViewController),
                  ))
          ],
        ),
      ),
    );
  }
}
