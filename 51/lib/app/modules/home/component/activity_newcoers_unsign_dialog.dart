import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

class ActivityNewcoersUnsignDialog extends StatefulWidget {

  final String? price;

  const ActivityNewcoersUnsignDialog({
    super.key,
    this.price,
  });

  @override
  _ActivityNewcoersUnsignDialogState createState() => _ActivityNewcoersUnsignDialogState();
}

class _ActivityNewcoersUnsignDialogState extends State<ActivityNewcoersUnsignDialog>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.zero, // Remove all padding to use full screen width
      child: Stack(
        children: [
          // Transparent background that can be tapped to dismiss
          Positioned.fill(
            child: GestureDetector(
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Main content
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main white container
                Container(
                  width: 0.9.sw,
                  height: 0.4.sh,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter, // 从上到下渐变
                      end: Alignment.bottomCenter,
                      colors: ThemeService.to.currentTheme.value?.model == 'blue' ||
                        ThemeService.to.currentTheme.value?.model == 'gold3'
                        ? [
                            context.theme.primaryColor, // 顶部黑色（透明度 0.2）
                            Colors.white, // 底部白色
                          ]
                        : [
                            Color(0xff444756), // 顶部黑色（透明度 0.2）
                            context.customTheme?.dialogBgColor ?? Colors.transparent, // 底部白色
                          ],
                      stops: [0.0, 0.2], // 调整渐变范围（0.0~0.3 是黑色到白色，之后纯白）
                    ),
                  ),
                  child: Stack(
                    clipBehavior: Clip.none, // Allow children to overflow
                    children: [
                      // Top image that extends beyond the container
                      Positioned(
                        top: -180.h, // Adjust this value based on your image's height
                        left: 50.w,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 0.9.sw, // Slightly smaller than container
                            height: 750.h, // Adjust based on your image's aspect ratio
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(ThemeService.to.currentTheme.value?.model == 'blackGold'
                                  ? Assets.theme1.images.home.homeNewcomersSignTopBlackgold.path
                                  : Assets.theme1.images.home.homeNewcomersSignTop.path),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Text content
                      Padding(
                        padding: EdgeInsets.only(top: 300.h), // Make space for the overflowing image
                        child: Center(
                          child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '恭喜您获得',
                              style: TextStyle(
                                fontSize: 73.sp,
                                fontWeight: FontWeight.bold,
                                color: ThemeService.to.currentTheme.value?.model == 'blackGold'
                                  ? context.customTheme?.titleColor
                                  : const Color(theme01MainColor)
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style, // 继承默认文本样式（如字体）
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "888元", // 左边灰色文字
                                    style: TextStyle(
                                      fontSize: 84.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeService.to.currentTheme.value?.model == 'blackGold'
                                        ? context.theme.primaryColor :Colors.red
                                    ),
                                  ),
                                  TextSpan(
                                    text: '新人大礼包', // 右边黑色文字
                                    style: TextStyle(
                                      fontSize: 73.sp,
                                      fontWeight: FontWeight.bold,
                                      color: ThemeService.to.currentTheme.value?.model == 'blackGold'
                                        ? context.customTheme?.titleColor
                                        : const Color(theme01MainColor)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                      ),
                      // Bottom button
                      Positioned(
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                               Get.back();
                               showRegisterDialog();
                            },
                            child: Image.asset(
                              ThemeService.to.currentTheme.value?.model == 'blackGold'
                                ? Assets.theme1.images.home.homeNewcomersBtnBlackgold.path
                                : Assets.theme1.images.home.homeNewcomersBtn.path,
                              width: 0.6.sw, // Make button responsive
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                // Close button
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  child: const Icon(
                    Icons.close_sharp,
                    color: Color(0xffCECECE),
                    size: 15,
                  ),
                ).onTap(() => Get.back()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
