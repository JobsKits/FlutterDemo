import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_component_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/redbag_rain_detail_model/redbag_rain_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/new_redbag_rain_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/redbag_rain_controller.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../utils/CommonRipple.dart';

class RedbagRainView extends StatefulWidget {
  @override
  _RedbagRainViewState createState() => _RedbagRainViewState();
}

class _RedbagRainViewState extends State<RedbagRainView> {
  final NewRedbagRainController controller = Get.put(NewRedbagRainController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: Stack(
            children: [
              // 背景图像
              Image.asset(
                Assets.theme1.images.home.redbagDetailBg.path,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
              // 页面内容
              SafeArea(
                child: Column(
                  children: [
                    // 顶部导航栏
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 左侧返回按钮
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          // 中间标题
                          Expanded(
                            child: Text(
                              '活动详情',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // 右侧文本按钮
                          CommonRipple(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              Get.toNamed(Routes.CUSTOMER_SERVICE);
                            },
                            child: Text(
                              '在线客服',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 可滑动内容
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 250.h), // 根据需要动态调整
                        child: Column(
                          children: [
                            // 顶部图片
                            Image.asset(
                              Assets.theme1.images.home.redbagDetailTitle.path,
                              fit: BoxFit.contain,
                              width: 800.w,
                              height: 320.h,
                            ),

                            if (controller.model.value.isShowAvatar == '1') ...[
                              Container(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 0.0),
                                child: InteractiveViewer(
                                  minScale: 0.5,
                                  maxScale: 5.0,
                                  child: Image.network(
                                    controller.model.value.showAvatar ?? '',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )
                            ] else ...[
                              SizedBox(height: 200),
                            ],
                            // 活动详情部分
                            if (controller.jsonData['dailyLimitType'] != 1 &&
                                controller.jsonData.isNotEmpty)
                              Container(
                                margin: EdgeInsets.only(
                                    top: 38.h,
                                    left: 30.w,
                                    right: 30.w,
                                    bottom: 5.h),
                                padding: EdgeInsets.all(50.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          '总上限${controller.jsonData['totalLimitCount']}次（今日还剩${controller.reviceNum.value}次）'),
                                    ),
                                    SizedBox(height: 10),
                                    _buildTable(),
                                  ],
                                ),
                              ),
                            // 活动规则部分
                            Container(
                              margin: EdgeInsets.only(
                                  top: 38.h, left: 30.w, right: 30.w),
                              padding: EdgeInsets.all(50.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 12.w,
                                        height: 46.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(6.w),
                                            bottom: Radius.circular(6.w),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 20.w),
                                      Text(
                                        '活动规则与条款',
                                        style: TextStyle(
                                          fontSize: 51.sp,
                                          color: const Color(0xFF2D2D2D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20.w),
                                  HtmlWidget(
                                    controller.model.value.activityRule ?? '-',
                                    textStyle: TextStyle(
                                      fontSize: 39.sp,
                                      color: const Color(0xFF4B4B4B),
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTable() {
    List<String> titleList = ["当日充值", "抢红包上限"];

    List<dynamic> datas = [];
    if (controller.jsonData['dailyLimitType'] == 2) {
      datas = controller.jsonData['dailyRechargeSetting'];
    } else if (controller.jsonData['dailyLimitType'] == 3) {
      datas = controller.jsonData['dailyBetSetting'];
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        border: Border.all(color: Colors.grey, width: 1), // 可选的边框
      ),
      child: Column(
        children: [
          // 表头
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w),
              ),
            ),
            child: _rankItemHeaderRow(titleList),
          ),
          // 列表
          ListView.builder(
            shrinkWrap: true, // 高度自适应
            physics: const NeverScrollableScrollPhysics(), // 禁用单独滚动
            itemCount: datas.length,
            itemBuilder: (context, idx) {
              var data = datas[idx];
              final listRow = [
                '≥${(data['amount'] / 1000).toInt().toString()}',
                '${data['count'].toString()}次',
              ];
              return _rankItemRow(idx, listRow, '');
            },
          ),
        ],
      ),
    );
  }

  Widget _rankItemHeaderRow(List<String> values) {
    TextStyle style = TextStyle(
        color: Colors.white, fontSize: 28.sp, fontWeight: FontWeight.bold);

    // Create a list of widget columns based on the values
    List<Widget> columns = values.asMap().entries.map((entry) {
      String value = entry.value;

      // For the first and last item, use fixed width
      return Expanded(
        flex: 1,
        child: _rankItemCol(value, 100.w, style, true),
      );
    }).toList();

    return Row(
      children: columns,
    );
  }

  Widget _rankItemRow(int index, List<String> values, String? rollingType) {
    TextStyle defaultStyle = TextStyle(
      color: const Color.fromRGBO(102, 102, 102, 1),
      fontSize: 28.sp,
    );
    // Map each value to a column widget, with specific styling for the last column
    List<Widget> columns = values.asMap().entries.map((entry) {
      return Expanded(
        flex: 1,
        child: _rankItemCol(entry.value, 80.w, defaultStyle, false),
      );
    }).toList();
    // print({'object =======$index'});
    return Container(
      color: Colors.white,
      child: Row(
        children: columns,
      ),
    );
  }

  Widget _rankItemCol(
      String val, double width, TextStyle style, bool isheader) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        height: 35,
        alignment: Alignment.center,
        width: width,
        decoration: BoxDecoration(
          border: Border.all(
              color: isheader ? Colors.transparent : Colors.grey,
              width: isheader ? 0 : 0.5), // 添加边框
        ),
        child: Text(val, style: style));
  }
}
