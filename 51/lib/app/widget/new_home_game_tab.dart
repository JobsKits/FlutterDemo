import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../modules/home/controllers/new_home_controller.dart';

///首页游戏tab
class NewHomeGameTab extends StatefulWidget {
  const NewHomeGameTab({super.key});

  @override
  State<NewHomeGameTab> createState() => _HomeGameTabState();
}

class _HomeGameTabState extends State<NewHomeGameTab>
    with SingleTickerProviderStateMixin {
  late NewHomeController homeController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      color: context.customTheme?.pageTwoBg,
      child: Obx(() => homeController.homeCategoryList.isNotEmpty
          ? TabBar(
              onTap: (index) {
                if (homeController.currentTabIndex.value != index) {
                  AppManager.instance.tapVibrate();
                }
                homeController.changeTabIndex(index);
                // homeController.pageController.jumpToPage(index);
              },
              tabAlignment: TabAlignment.start,
              indicatorPadding: EdgeInsets.zero, // 去除指示器的边距
              labelPadding: EdgeInsets.symmetric(horizontal: 0),
              padding: EdgeInsets.zero, // 去除整体的边距
              controller: homeController.tabController.value,
              isScrollable: true,
              dividerHeight: 1.h,
              indicatorWeight: 6.h,
              indicatorColor: context.theme.primaryColor,
              tabs: List.generate(homeController.homeCategoryList.length,
                  (index) {
                return Obx(() {
                  String imgUrl =
                      homeController.homeCategoryList[index].iconPath;
                  bool isNetImg = imgUrl.contains("http");
                  return Container(
                    decoration: BoxDecoration(
                      gradient: homeController.currentTabIndex.value == index
                          ? LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white, // 渐变结束颜色#
                                context.theme.primaryColor
                                    .withOpacity(0.2), // 渐变起始颜色
                              ],
                            )
                          : null,
                    ),
                    width: 170.w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        isNetImg
                            ? Image.network(
                                homeController.homeCategoryList[index].iconPath,
                                width: 110.w,
                                height: 100.h)
                            : Image.asset(
                                homeController.homeCategoryList[index].iconPath,
                                width: 110.w,
                                height: 100.h),
                        Expanded(
                            child: Text(
                          homeController.homeCategoryList[index].title,
                          style: TextStyle(
                              color:
                                  homeController.currentTabIndex.value == index
                                      ? context.theme.primaryColor
                                      : Colors.grey,
                              fontSize: 42.sp),
                        ))
                      ],
                    ),
                  );
                });
              }),
            )
          : const SizedBox.shrink()),
    );
  }
}
