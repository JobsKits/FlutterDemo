import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_apply_records_model/datum.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ActivityDiscountRecordsDialog extends StatefulWidget {
  final VoidCallback? onClose;
  final Datum? item;

  const ActivityDiscountRecordsDialog({super.key, this.onClose, this.item});

  @override
  _ActivityDiscountRecordsDialogState createState() =>
      _ActivityDiscountRecordsDialogState();
}

class _ActivityDiscountRecordsDialogState
    extends State<ActivityDiscountRecordsDialog>
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
      child: Center(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: 0.7.sh, // 避免整体超出屏幕
            minHeight: 0.4.sh, // 可选：设置最小高度
          ),
          width: 0.9.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // 高度随内容变化
            children: [
              _buildTitle(),
              Flexible(child: _buildContent()), // 重点：内容区最多占用剩余空间
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 30),
          Expanded(
            child: Center(
              child: Text(
                '申请信息',
                style: TextStyle(
                  fontSize: 60.sp,
                  color: const Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                width: 30,
                height: 30,
                child: const Icon(
                  Icons.close_sharp,
                  color: Color(0xFFCECECE),
                  size: 25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    List<String> stringList =
        List<String>.from(jsonDecode(widget.item?.applyText ?? '[]'));
    List<String> answerList =
        List<String>.from(jsonDecode(widget.item?.answer ?? '[]'));

    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.5.sh, // 最大高度 50% 屏幕
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 60.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...stringList.asMap().entries.map((entry) {
                final index = entry.key;
                final question = entry.value;
                final answer =
                    index < answerList.length ? answerList[index] : "无答案";

                return Padding(
                  padding: EdgeInsets.only(bottom: 10.h),
                  child: RichText(
                    key: ValueKey('qa_$index'),
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '问题${index + 1}: ',
                          style: TextStyle(
                            fontSize: 42.sp,
                            color: const Color(0xff000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '$question : $answer',
                          style: TextStyle(
                            fontSize: 42.sp,
                            color: const Color(0xff3b3b3b),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              // 奖金金额
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '奖金金额：',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: const Color(0xff3b3b3b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        text: widget.item?.amount == null
                            ? '--'
                            : (int.parse(widget.item!.amount.toString()) ~/
                                    1000)
                                .toStringAsFixed(0),
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: const Color(0xff3b3b3b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 管理员回复
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '管理员回复：',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: const Color(0xff3b3b3b),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 回复内容
              Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: 250.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffF5F5F5),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.item?.remark1?.isNotEmpty ?? false)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Text(
                          widget.item!.remark1!,
                          style: TextStyle(
                            fontSize: 39.sp,
                            color: const Color(0xff9f9f9f),
                          ),
                        ),
                      ),
                    if ((widget.item?.remark1?.isEmpty ?? true))
                      Text(
                        '暂无回复',
                        style: TextStyle(
                          fontSize: 39.sp,
                          color: const Color(0xff9f9f9f),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
