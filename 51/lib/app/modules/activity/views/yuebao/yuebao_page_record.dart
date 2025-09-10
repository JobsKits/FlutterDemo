import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity_detail_view.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import 'package:flutter_tiyu_app/app/modules/activity/data/yuebao_bean.dart';
import '../../controllers/controller_yuebao_page.dart';

import '../../widget/empty_widget.dart';

class YuebaoPageRecord extends StatefulWidget {
  const YuebaoPageRecord({super.key});

  @override
  State<YuebaoPageRecord> createState() => _YuebaoPageRecordState();
}

class _YuebaoPageRecordState extends State<YuebaoPageRecord> {
  late ControllerYuebaoPage controller;
  late bool showTitle;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<ControllerYuebaoPage>()) {
      controller = Get.find();
    } else {
      controller = Get.put(ControllerYuebaoPage());
    }
  }

  @override
  void dispose() {
    Get.delete<ControllerYuebaoPage>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.recordData.isNotEmpty
        ? RefreshIndicator(
            onRefresh:
                controller.reqYueBaoRecord, // Ensure this returns a Future
            child: ListView.builder(
                controller: controller.scrollController,
                itemCount: controller.recordData.length + 1,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  if (index == controller.recordData.length) {
                    return controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox();
                  }
                  YueBaoRecordDataItemBean itemData =
                      controller.recordData[index];
                  return _buildRecordItem(itemData);
                }),
          )
        : EmptyWidget());
  }

  Widget _buildBody() {
    return Column(
      children: [],
    );
  }

  Widget _buildRecordItem(YueBaoRecordDataItemBean itemData) {
    String remark = itemData.remark ?? '';
    String planName = '';
    if ('${itemData.trans_type}' == '408') {
      remark = '利息宝转入';
      planName = '转入';
    } else if ('${itemData.trans_type}' == '409') {
      remark = '利息宝转出';
      planName = '转出';
    } else if ('${itemData.trans_type}' == '410') {
      remark = '利息';
    }

    //  '${itemData.trans_type}' == '408'
    num time = itemData.crt_datetime ?? 0;

    double money = double.tryParse('${(itemData.gen_amount ?? 0) / 1000}') ?? 0;
    double balance = double.tryParse('${itemData.balance ?? 0}') ?? 0;

    return Container(
      constraints: BoxConstraints(minHeight: 230.h),
      margin: EdgeInsets.only(left: 30.w, right: 30.w, top: 30.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: context.customTheme?.pageTwoBg,
      ),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 58.w, vertical: 20.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  remark,
                  style: TextStyle(
                    color: context.customTheme?.titleColor,
                    fontSize: 45.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  DateTimeUtils.formatTimestamp(int.parse('${time}')),
                  style: TextStyle(
                      color: context.customTheme?.title2Color, fontSize: 39.sp),
                ),
              ],
            ),
          ),
          RichText(
            text: TextSpan(
              text: planName,
              style: TextStyle(
                fontSize: 45.sp,
                color: context.customTheme?.titleColor,
                fontWeight: FontWeight.w600,
              ),
              children: [
                TextSpan(
                  text: ' ${parseNumber(money)}',
                  style: const TextStyle(
                    color: Color(colorD73F4C),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Column(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     Text(
          //       parseNumber(money),
          //       style:
          //           TextStyle(color: const Color(colorD73F4C), fontSize: 45.sp),
          //     ),
          //     SizedBox(height: 10.h),
          //     Text(
          //       DateTimeUtils.formatTimestamp(int.parse('${time}')),
          //       style:
          //           TextStyle(color: const Color(color868686), fontSize: 39.sp),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
