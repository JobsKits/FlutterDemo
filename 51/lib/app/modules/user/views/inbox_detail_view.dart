import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../controllers/inbox_detail_controller.dart';

//收件箱消息详情页面
class InboxDetailView extends GetView<InboxDetailController> {
  const InboxDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.titleColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("收件箱",
            style: TextStyle(color: context.customTheme?.titleColor)),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _buildHeader(context),
          Expanded(
              child: Obx(() => ListView.builder(
                  itemCount: controller.msgList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _buildItem(context, index);
                  }))),
          if (controller.isReply.value != 0) ...[
            _buildInputView(context),
          ]
        ],
      ),
    );
  }

  Widget _buildInputView(BuildContext context) {
    return Container(
      height: 200.h,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2), // 阴影颜色
          offset: Offset(0, -3), // 阴影的偏移量，只在顶部（y为负值）
          blurRadius: 6, // 阴影的模糊半径
          spreadRadius: 1, // 阴影的扩散半径
        ),
      ], color: context.customTheme?.pageTwoBg),
      padding: EdgeInsets.all(30.w),
      child: Row(
        children: [
          Expanded(
              child: Container(
                  height: 110.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: context.customTheme?.inputBgColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: TextField(
                    controller: controller.contentController,
                    cursorColor: context.theme.primaryColor,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null, // 不显示计数器
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 30.h, left: 36.w),
                      hintStyle: TextStyle(
                          fontSize: 46.sp, color: const Color(colorBCBCBC)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                    ),
                  ))),
          SizedBox(
            width: 35.w,
          ),
          CommonRipple(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.sendMsg();
            },
            child: Container(
              height: 110.h,
              width: 240.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(90.r)),
              child: Text(
                "发送",
                style: TextStyle(fontSize: 36.sp, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.w),
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.title,
            style: TextStyle(
                fontSize: 48.sp,
                color: context.theme.primaryColor,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.h,
          ),
          HtmlWidget(controller.topContent,
              textStyle:
                  TextStyle(fontSize: 42.sp, color: context.theme.primaryColor)),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${DateTimeUtils.formatTimestamp(controller.sendTime!)}",
              style: TextStyle(fontSize: 40.sp, color: Color(colorA0A0A0)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return controller.msgList[index].custName!.contains("system")
        ? _buildLeftItem(context, index)
        : _buildRightItem(context, index);
  }

  Widget _buildRightItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h, right: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 700.w, minWidth: 100.w),
            padding: EdgeInsets.only(
                top: 30.h, left: 50.w, right: 50.w, bottom: 30.h),
            decoration: BoxDecoration(
                color: context.customTheme?.pageTwoBg,
                borderRadius: BorderRadius.circular(30.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${controller.msgList[index].replyContent}",
                  maxLines: null,
                  style: TextStyle(color: context.customTheme?.titleColor),
                ),
                Text(
                  "${DateTimeUtils.formatTimestamp(controller.msgList[index].sendTime!)}",
                  style: TextStyle(fontSize: 30.sp, color: Color(colorA0A0A0)),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Obx(() => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 60.w,
                backgroundImage: NetworkImage(controller.userHead.value),
              ))
        ],
      ),
    );
  }

  String decodeSafely(String input) {
    try {
      return Uri.decodeComponent(input);
    } catch (e) {
      return input; // 返回原字符串或默认值
    }
  }

  Widget _buildLeftItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 40.h, left: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 60.w,
              backgroundColor: Colors.black26,
              backgroundImage:
                  NetworkImage(controller.homeController.iconPath.value)),
          SizedBox(
            width: 20.w,
          ),
          Container(
              constraints: BoxConstraints(maxWidth: 700.w, minWidth: 100.w),
              padding: EdgeInsets.only(
                  top: 30.h, left: 50.w, right: 50.w, bottom: 30.h),
              decoration: BoxDecoration(
                  color: context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(30.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HtmlWidget(
                    "${controller.msgList[index].replyContent}",
                    textStyle: TextStyle(
                      fontSize: 36.sp,
                      color: context.customTheme?.titleColor,
                      fontWeight: FontWeight.w300,
                    ),

                  ),
                  Text(
                    "${DateTimeUtils.formatTimestamp(controller.msgList[index].sendTime!)}",
                    style: TextStyle(
                        fontSize: 30.sp, color: const Color(colorA0A0A0)),
                  )
                ],
              )),
        ],
      ),
    );
  }
}
