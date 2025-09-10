import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/clipboard_util.dart';
import '../../../../utils/common_color.dart';
import '../controllers/alternate_urls_controller.dart';

//备用网址页面
class AlternateUrlsView extends GetView<AlternateUrlsController> {
  const AlternateUrlsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.appbarText,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          "备用网址",
          style: TextStyle(
              fontSize: 57.sp, color: context.customTheme?.appbarText),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: Stack(
        children: [
          Image.asset(ThemeService.to.currentTheme.value?.model == 'blackGold'
              ? Assets.theme1.images.user.alternateUrlsBgBlackGold.path
              : Assets.theme1.images.user.alternateUrlsBg.path),
          Positioned(
              top: 80.h,
              left: 40.w,
              child: Text(
                "备份备用网址\n回家不迷路",
                style: TextStyle(fontSize: 60.sp, color: Colors.white),
              )),
          Positioned(
            top: 400.h,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                  color: context.customTheme?.pageTwoBg,
                  borderRadius: BorderRadius.circular(30.r)),
              padding: EdgeInsets.only(
                  top: 55.h, left: 60.w, right: 60.w, bottom: 100.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${controller.appName.value}备用网址",
                    style: TextStyle(
                        fontSize: 57.sp,
                        color: context.customTheme?.titleColor),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Obx(
                    () => controller.itemList.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: controller.itemList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              String domainAddr =
                                  controller.itemList[index].domainAddr ?? '';
                              if (!domainAddr.startsWith('http')) {
                                domainAddr = 'https://$domainAddr';
                              }
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 40.h),
                                child: Row(
                                  children: [
                                    FutureBuilder<Map<String, dynamic>>(
                                        future: checkDomainWithDio(domainAddr),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return SizedBox(
                                              width: 60.w,
                                              height: 60.h,
                                              child: LoadingIndicator(
                                                indicatorType: Indicator
                                                    .ballSpinFadeLoader,
                                                colors: [
                                                  context.theme.primaryColor
                                                ],
                                              ),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                "错误: ${snapshot.error}");
                                          } else {
                                            final result = snapshot.data!;
                                            final isAvailable =
                                                result['isAvailable'] as bool;
                                            final time = result['time'] as int?;
                                            Color timeColor =
                                                const Color(0xFF2BD42B);
                                            if (time != null && time > 1000) {
                                              timeColor =
                                                  const Color(0xFFD6D203);
                                            }
                                            return isAvailable
                                                ? Text(
                                                    "${time}ms",
                                                    style: TextStyle(
                                                        color: timeColor,
                                                        fontSize: 36.sp),
                                                  )
                                                : Text(
                                                    "超时",
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 36.sp),
                                                  );
                                          }
                                        }),
                                    SizedBox(
                                      width: 20.w,
                                    ),
                                    Expanded(
                                      child: Text(
                                        domainAddr,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 36.sp,
                                          color:
                                              context.customTheme?.title2Color,
                                        ),
                                      ),
                                    ),
                                    CommonRipple(
                                      child: Container(
                                        height: 80.h,
                                        width: 140.w,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 20.w),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            border: Border.all(
                                                color: context
                                                    .theme.primaryColor)),
                                        child: Text(
                                          "复制",
                                          style: TextStyle(
                                              fontSize: 36.sp,
                                              color:
                                                  context.theme.primaryColor),
                                        ),
                                      ),
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        ClipboardUtil.copy(domainAddr);
                                      },
                                    ),
                                    CommonRipple(
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        _openUrl(domainAddr);
                                      },
                                      child: Container(
                                        height: 80.h,
                                        width: 140.w,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            color: context.theme.primaryColor),
                                        child: Text(
                                          "打开",
                                          style: TextStyle(
                                              fontSize: 36.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: Container(
                              width: 300.w,
                              height: 300.h,
                              alignment: Alignment.center,
                              child: Text(
                                "暂无备用网址",
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openUrl(String urls) async {
    final Uri url = Uri.parse(urls);
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  // Future<void> pingUrl(String urls) async {
  //   final result = await Ping(urls, count: 1).stream.first;
  //   print("输出一下结果：$result");
  // }
  Future<Map<String, dynamic>> checkDomainWithDio(String url) async {
    final dio = Dio();
    final startTime = DateTime.now();
    try {
      final response = await dio.get(url,
          options: Options(
              sendTimeout: Duration(milliseconds: 5000),
              receiveTimeout: Duration(milliseconds: 5000)));
      final endTime = DateTime.now();

      if (response.statusCode == 200) {
        return {
          'isAvailable': true,
          'time': endTime.difference(startTime).inMilliseconds,
        };
      } else {
        return {
          'isAvailable': false,
          'time': null,
        };
      }
    } catch (e) {
      return {
        'isAvailable': false,
        'time': null,
      };
    }
  }
}
