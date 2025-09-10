import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../gen/assets.gen.dart';
import '../data/home_main_info_bean.dart';
import '../modules/home/model/announcement_bean.dart';

///系统公告弹窗
class SystemAnnouncementDialog extends StatefulWidget {
  final List<BannerAndAnnouncementItem> sAnnouncementList;
  final List<AnnouncementBean> announcementList;
  final String title;
  const SystemAnnouncementDialog(
      {super.key,
      required this.sAnnouncementList,
      required this.title,
      required this.announcementList});

  @override
  State<SystemAnnouncementDialog> createState() =>
      _SystemAnnouncementDialogState();
}

class _SystemAnnouncementDialogState extends State<SystemAnnouncementDialog> {
  late PageController pageController = PageController();
  int currentIndex = 0;
  final GlobalKey _stackKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    String appName = '新葡京';
    if (TenantManager.instance.tenantBean?.tenant?.tenantName != null) {
      appName = TenantManager.instance.tenantBean!.tenant!.tenantName!;
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.transparent.withOpacity(0),
            ),
          ),
          RepaintBoundary(
            key: _stackKey,
            child: Align(
              // 使用 Align 包裹 Positioned
              alignment: Alignment.center, // 居中
              child: Column(
                mainAxisSize: MainAxisSize.min, // 使 Column 仅占用所需空间
                children: [
                  Stack(clipBehavior: Clip.none, children: [
                    Container(
                      width: 0.9.sw,
                      height: 0.625.sh,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(56.r),
                          image: DecorationImage(
                              image: AssetImage(Assets
                                  .theme1.images.home.systemDialogBg.path),
                              fit: BoxFit.cover)),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 18.h),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  widget.title,
                                  style: TextStyle(
                                      fontSize: 68.sp, color: Colors.white),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(top: 20.h),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.circular(63.r)),
                                  child: PageView.builder(
                                      controller: pageController,
                                      itemCount:
                                          widget.sAnnouncementList.length,
                                      onPageChanged: (index) {
                                        setState(() {
                                          currentIndex = index;
                                        });
                                      },
                                      itemBuilder: (context, index) {
                                        num isSavePic = widget
                                                .sAnnouncementList[index]
                                                .is_save_pic ??
                                            0;
                                        return Container(
                                          margin: EdgeInsets.all(40.w),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${widget.sAnnouncementList[index].title}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 58.sp,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              // Text(
                                              //     "${DateTimeUtils.formatTimestamp(widget.sAnnouncementList[index].create_time ?? 0)}",
                                              //     style: TextStyle(
                                              //       color: Color(colorA9A9A9),
                                              //       fontSize: 38.sp,
                                              //     )),
                                              // SizedBox(
                                              //   height: 20.h,
                                              // ),
                                              // Flexible(
                                              //     child: SingleChildScrollView(
                                              //   child: isImageUrl(widget
                                              //               .sAnnouncementList[index]
                                              //               .content ??
                                              //           "")
                                              //       ? CachedNetworkImage(
                                              //           imageUrl: widget
                                              //                   .sAnnouncementList[index]
                                              //                   .content ??
                                              //               "")
                                              //       : HtmlWidget(
                                              //           "${widget.sAnnouncementList[index].content}",
                                              //           textStyle: const TextStyle(
                                              //               color: Colors.black),
                                              //         ),
                                              // )),
                                              Flexible(
                                                  child: SingleChildScrollView(
                                                child: widget
                                                            .announcementList[
                                                                index]
                                                            .imageProvider !=
                                                        null
                                                    ? Image(
                                                        image: widget
                                                            .announcementList[
                                                                index]
                                                            .imageProvider!)
                                                    : IntrinsicHeight(
                                                        // 确保内容高度自适应
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            ConstrainedBox(
                                                              constraints:
                                                                  BoxConstraints(
                                                                maxHeight: 900
                                                                    .h, // 设置最大高度
                                                              ),
                                                              child:
                                                                  SingleChildScrollView(
                                                                // 为HtmlWidget单独添加滚动
                                                                physics:
                                                                    const ClampingScrollPhysics(), // 更平滑的滚动效果
                                                                child:
                                                                    HtmlWidget(
                                                                  "${widget.announcementList[index].html}",
                                                                  textStyle: const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  onTapUrl: (url) =>
                                                                      true, // 处理链接点击
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                              )),
                                              SizedBox(
                                                height: 20.h,
                                              ),
                                              Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  appName,
                                                  style: TextStyle(
                                                      fontSize: 40.sp),
                                                ),
                                              ),
                                              if (isSavePic == 1)
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          const Color(
                                                              theme01MainColor),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.r),
                                                      ),
                                                    ),
                                                    onPressed: () async {
                                                      AppManager.instance
                                                          .tapVibrate();
                                                      saveImageToGallery();
                                                    },
                                                    child: Text(
                                                      '保存至相册',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 48.sp,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                          widget.sAnnouncementList.length > 1
                              ? Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 40.h,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: AnimatedSmoothIndicator(
                                        activeIndex: currentIndex,
                                        count: widget.sAnnouncementList.length,
                                        onDotClicked: (index) {
                                          pageController.jumpToPage(index);
                                          setState(() {
                                            currentIndex = index;
                                          });
                                        },
                                        effect: WormEffect(
                                            dotWidth: 20.w,
                                            dotHeight: 20.w,
                                            activeDotColor:
                                                const Color(0xff10C8E4),
                                            dotColor: const Color(0xffC5C5C5)),
                                      )),
                                )
                              : const SizedBox()
                        ],
                      ),
                    ),
                    Positioned(
                      top: -70.h,
                      left: 24.w,
                      width: 186.w,
                      height: 188.h,
                      child: Image.asset(Assets
                          .theme1.images.home.systemAnnouncementIcon.path),
                    ),
                    // Positioned(
                    //   right: 38.w,
                    //   top: 38.h,
                    //   child: CommonRipple(
                    //     onTap: () {
                    //       AppManager.instance.tapVibrate();
                    //       Get.back();
                    //     },
                    //     child: SvgPicture.asset(
                    //       Assets.theme1.images.home.iconDialogClose,
                    //       width: 52.w,
                    //       height: 52.h,
                    //     ),
                    //   ),
                    // ),
                  ]),
                  const SizedBox(height: 25),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: context.theme.cardColor.withOpacity(.9),
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.close_sharp,
                      color: Colors.red,
                      size: 15,
                    ),
                  ).onTap(() {
                    Get.back();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isImageUrl(String url) {
    final RegExp imagePattern =
        RegExp(r'\.(jpg|jpeg|png|gif|bmp|webp|svg)$', caseSensitive: false);
    return imagePattern.hasMatch(url);
  }

  // 保存图片
  Future<void> saveImageToGallery() async {
    try {
      // 显示保存中提示
      EasyLoading.show(status: "图片保存中...");

      RenderRepaintBoundary boundary =
          _stackKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final imageData = byteData!.buffer.asUint8List();
      final result = await ImageGallerySaverPlus.saveImage(imageData);
      // 判断保存结果
      if (result['isSuccess']) {
        EasyLoading.showSuccess("图片保存成功");
      } else {
        EasyLoading.showError("图片保存失败");
      }
    } catch (e) {
      EasyLoading.showError("保存图片出错: $e");
    } finally {
      // 确保无论成功或失败都隐藏加载框
      await Future.delayed(const Duration(seconds: 1));
      EasyLoading.dismiss();
    }
  }
}
