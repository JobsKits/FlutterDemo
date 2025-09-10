import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_home_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_level_model/vip_level_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/controller/controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/controller/vip_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class VipDetailView extends StatefulWidget {
  const VipDetailView({super.key});

  @override
  State<VipDetailView> createState() => _VipDetailViewState();
}

class _VipDetailViewState extends State<VipDetailView> {
  
  late VipDetailController controller = Get.put(VipDetailController());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          'VIP详情',
          style: TextStyle(
            color: context.customTheme?.appbarText,
            fontSize: 57.sp,
          ),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            AppManager.instance.tapVibrate();
            Get.back();
          },
          child: SizedBox(
            width: 54.w,
            height: 54.h,
            child: Center(
              child: SvgPicture.asset(
                Assets.theme1.images.common.iconBack,
                width: 34.w,
                height: 54.h,
                color: context.customTheme?.appbarText,
              ),
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Get.context?.customTheme?.pageTwoBg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.theme1.images.activity.vip.vipDetailLeft.path,
                          fit: BoxFit.contain,
                          height: 30.h,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '返水比例',
                            style: TextStyle(
                              color: context.theme.primaryColor,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          Assets.theme1.images.activity.vip.vipDetailRight.path,
                          fit: BoxFit.contain,
                          height: 30.h,
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(60),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          // 表头
                          TableRow(
                            children: controller.columnKeys.map((key) {
                              return Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  controller.gamesTypeMap[key] ?? key,
                                  style: TextStyle(color: context.customTheme?.titleColor),
                                ),
                              );
                            }).toList(),
                          ),
                          // 数据行
                          ...List.generate(controller.rebateModels.length, (index) {
                            final data = controller.rebateModels[index];
                            final isEven = index % 2 == 0;
                            return TableRow(
                              decoration: BoxDecoration(
                                color: isEven ? context.customTheme?.inputBgColor : context.customTheme?.pageTwoBg,
                              ),
                              children: controller.columnKeys.map((key) {
                                final value = backWithValue(key, data);
                                return Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(value, style: TextStyle(color: context.customTheme?.title3Color),),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        ' 1.以上为银河官方场馆最高返水比例，具体返水比例请以实际游戏为准，其他疑问请联系7*24在线客服咨询 ',
                        style: TextStyle(
                          color: context.customTheme?.titleColor
                        )
                      ),
                    )
                  ],
                )
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: Get.context?.customTheme?.pageTwoBg),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          Assets.theme1.images.activity.vip.vipDetailLeft.path,
                          fit: BoxFit.contain,
                          height: 30.h,
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          child: Text(
                            '规则和条款',
                            style: TextStyle(
                              color: context.theme.primaryColor,
                              fontSize: 45.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Image.asset(
                          Assets.theme1.images.activity.vip.vipDetailRight.path,
                          fit: BoxFit.contain,
                          height: 30.h,
                        ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Table(
                        defaultColumnWidth: FixedColumnWidth(60),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          // 表头
                          TableRow(
                            children: controller.ruleKeys.map((key) {
                              return Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  controller.ruleTypeMap[key] ?? key,
                                  style: TextStyle(color: context.customTheme?.titleColor),
                                ),
                              );
                            }).toList(),
                          ),
                          // 数据行
                          ...List.generate(controller.vipModel.value.data?.length ?? 0, (index) {
                            final data = controller.vipModel.value.data?[index];
                            final isEven = index % 2 == 0;
                            return TableRow(
                              decoration: BoxDecoration(
                                color: isEven ? context.customTheme?.inputBgColor : context.customTheme?.pageTwoBg,
                              ),
                              children: controller.ruleKeys.map((key) {
                                final value = vipBackWithValue(key, data);
                                return Container(
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Text(value, style: TextStyle(color: context.customTheme?.titleColor),),
                                );
                              }).toList(),
                            );
                          }),
                        ],
                      ),
                    ),
                    Obx(() => Container(
                      padding: EdgeInsets.all(10),
                      child: HtmlWidget(
                        controller.ruler.value, 
                        textStyle: TextStyle(color: context.customTheme?.titleColor)
                      ),
                    ))
                  ],
                )
              )
            ],
          ),
        ),
      ),
    );
  }

  String backWithValue(String key, VipLevelModel data) {
    String value = '';
    switch (key) {
      case 'level':
        value = 'V${data.level}';
        break;
      case '100':
        value = "${NumberFormat("#,##0.0").format(((data.hundred0 ?? 0) / 1000))}%";
        break;
      case '101':
        value = "${NumberFormat("#,##0.0").format(((data.hundred1 ?? 0) / 1000))}%";
        break;
      case '102':
        value = "${NumberFormat("#,##0.0").format(((data.hundred2 ?? 0) / 1000))}%";
        break;
      case '103':
        value = "${NumberFormat("#,##0.0").format(((data.hundred3 ?? 0) / 1000))}%";
        break;
      case '104':
        value = "${NumberFormat("#,##0.0").format(((data.hundred4 ?? 0) / 1000))}%";
        break;
      case '106':
        value = "${NumberFormat("#,##0.0").format(((data.hundred6 ?? 0) / 1000))}%";
        break;
      case '107':
        value = "${NumberFormat("#,##0.0").format(((data.hundred7 ?? 0) / 1000))}%";
        break;
      case '109':
        value = "${NumberFormat("#,##0.0").format(((data.hundred9 ?? 0) / 1000))}%";
        break;
      default:
    }
    return value;
  }

  String vipBackWithValue(String key, Datum? data) {
    String value = '';
    switch (key) {
      case '1':
        value = 'V${data?.level ?? 0}';
        break;
      case '2':
        value = NumberFormat("#,##0.00").format(((data?.valueLower ?? 0) / 1000));
        break;
      case '3':
        value = NumberFormat("#,##0.00").format(((data?.levelReward ?? 0) / 1000));
        break;
      case '4':
        value = NumberFormat("#,##0.00").format(((data?.birthdayRedPacket ?? 0) / 1000));
        break;
      case '5':
        value = NumberFormat("#,##0.00").format(((data?.daySalary ?? 0) / 1000));
        break;
      case '6':
        value = NumberFormat("#,##0.00").format(((data?.weekSalary ?? 0) / 1000));
        break;
      case '7':
        value = NumberFormat("#,##0.00").format(((data?.monthSalary ?? 0) / 1000));
        break;
      default:
    }
    return value == '0.00' ? '-' : value;
  }
}
