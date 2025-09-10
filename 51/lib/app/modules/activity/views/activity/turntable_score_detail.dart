import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/action_cfg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/widget/JobsViews.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/controller_activity_page.dart';

class TurntableScoreDetail extends StatefulWidget {
  final Map<String, dynamic> arguments;
  const TurntableScoreDetail({super.key, required this.arguments});

  @override
  State<TurntableScoreDetail> createState() => _TurntableScoreDetailState();
}

class _TurntableScoreDetailState extends State<TurntableScoreDetail> {
  late final ControllerActivityPage controller =
      Get.find<ControllerActivityPage>();

  @override
  Widget build(BuildContext context) {
    final ActivityTurntableDetailModel model =
        controller.activityTurntableDetailData!;
    final List<SingleRechargeConfig> list =
        model.actionCfg?.singleRechargeConfigs ?? const [];

    final List<List<String>> rows = [
      for (final e in list)
        [
          '≥${((e.amount ?? 0) / 1000).toStringAsFixed(2)}',
          '${((e.giftPercentage ?? 0) * 100).toStringAsFixed(2)}%',
        ],
    ];

    // 主题色可按需调整
    final textDark = const Color(0xFF333333);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
      child: Stack(
        children: [
          Column(
            children: [
              const Spacer(),
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 50,
                    maxHeight: 1000.h,
                  ),
                  child: Material(
                    color: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.black26,
                    borderRadius: BorderRadius.circular(24.r),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SizedBox(height: 25.h),
                        // 标题
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Text(
                            '积分规则',
                            style: TextStyle(
                                fontSize: 38.sp, fontWeight: FontWeight.w700),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // 顶部分割线
                        Container(
                            width: double.infinity,
                            height: 1 / MediaQuery.of(context).devicePixelRatio,
                            color: Colors.black.withOpacity(0.08)),
                        SizedBox(height: 20.h),
                        // 表头
                        Padding(
                          padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
                          child: Container(
                            height: 84.h,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '单笔充值',
                                      style: TextStyle(
                                          fontSize: 28.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                                // 中间细分割线（发丝线）
                                Container(
                                    width: 1 /
                                        MediaQuery.of(context).devicePixelRatio,
                                    height: double.infinity,
                                    color: Colors.black.withOpacity(0.06)),
                                Expanded(
                                  child: Center(
                                    child: Text(
                                      '转化百分比',
                                      style: TextStyle(
                                          fontSize: 28.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 表体：卡片行列表
                        Expanded(
                          child: rows.isEmpty
                              ? JobsEmptyView()
                              : ListView.builder(
                                  padding:
                                      EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                                  itemCount: rows.length,
                                  itemBuilder: (_, i) {
                                    final r = rows[i];
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 0.h), // 行间距
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 18.h),
                                      decoration: BoxDecoration(
                                        color: i % 2 == 0
                                            ? Colors.white
                                            : const Color(0xFFF7F7F9),
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 5, // = 50%
                                            child: Center(
                                              child: Text(
                                                r[0],
                                                style: TextStyle(
                                                    fontSize: 28.sp,
                                                    color: textDark,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 5, // = 50%
                                            child: Center(
                                              child: Text(
                                                r[1],
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    fontSize: 28.sp,
                                                    color: textDark,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              // 关闭按钮
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: context.theme.cardColor.withOpacity(.9),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.close_sharp,
                      color: Colors.grey, size: 15),
                ).onTap(() {
                  Get.back();
                }),
              ),

              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
