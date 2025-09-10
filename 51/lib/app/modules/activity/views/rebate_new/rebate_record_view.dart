import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/rebate_bean.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_rebate_new_page.dart';

class RebateRecordView extends StatefulWidget {
  const RebateRecordView({super.key});

  @override
  State<RebateRecordView> createState() => _RebateRecordViewState();
}

class _RebateRecordViewState extends State<RebateRecordView> {
  ControllerRebatePage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        title: Text(
          '返水记录',
          style: TextStyle(
            color: context.customTheme?.appbarText,
            fontSize: 57.sp,
          ),
        ),
        centerTitle: true,
        leading: CommonRipple(
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
      body: Container(
        color: context.customTheme?.pageBg,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
        child: _buildBody(context),
      ),
    );
  }

  /// 构建表头标题
  Widget _buildTableHeaderTitle(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 36.sp,
        color: context.customTheme?.titleColor,
        height: 1.1,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildTableBodyText(BuildContext context, String text,
      {bool? isClick = false, String? logId}) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (isClick == true) {
          controller.handleRebateRecordDetail(logId!);
        }
      },
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36.sp,
          color: isClick == false
              ? context.customTheme?.title3Color
              : const Color(colorD69B62),
          height: 1.1,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: [
      // 固定表头
      Container(
        color: context.customTheme?.selectBoxColor,
        height: 100.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(child: _buildTableHeaderTitle(context, '自助返水时间')),
            Expanded(child: _buildTableHeaderTitle(context, '自助返水量')),
            Expanded(child: _buildTableHeaderTitle(context, '返水金额')),
            Expanded(child: _buildTableHeaderTitle(context, '详情')),
          ],
        ),
      ),

      // 可滚动的表格内容
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              controller.historyData.length,
              (index) {
                RebateHistoryItemBean itemData = controller.historyData[index];
                return Container(
                  height: 120.h,
                  color: index % 2 == 0
                      ? Colors.transparent
                      : context.customTheme?.pageTwoBg,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: _buildTableBodyText(
                            context,
                            DateTimeUtils.formatTimestamp(
                                itemData.create_time ?? 0)),
                      ),
                      Expanded(
                        child: _buildTableBodyText(context,
                            parseNumber((itemData.amount ?? 0) / 1000)),
                      ),
                      Expanded(
                        child: _buildTableBodyText(context,
                            parseNumber((itemData.shuffle_amount ?? 0) / 1000)),
                      ),
                      Expanded(
                        child: _buildTableBodyText(context, '详情',
                            isClick: true, logId: '${itemData.log_id}'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    ]);
  }
}
