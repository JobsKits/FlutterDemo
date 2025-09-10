import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';
import 'package:get/get.dart';

import '../../../../data/home_main_info_bean.dart';
import '../../../home/controllers/new_home_controller.dart';

class RebateViewCardItemWidget extends StatelessWidget {
  final String imgUrl; // 图片
  final num betAmount; // 投注额
  final num proportion; // 比例
  final num percentage; // 进度
  final num reward; // 可领取奖励
  final num? play_id; // 可领取奖励
  final bool? showPercentage;
  final num upAmount; // 再投注金额
  final VoidCallback? onTap;
  late NewHomeController homeController = Get.find();
  RebateViewCardItemWidget({
    super.key,
    required this.betAmount,
    required this.imgUrl,
    required this.proportion,
    required this.percentage,
    required this.reward,
    required this.upAmount,
    this.showPercentage = true,
    this.onTap,
    this.play_id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    ThirdGamesItem? item = homeController.thirdGameList
        .firstWhereOrNull((item) => item.play_id == play_id);
    String imgUrls = "";
    if (item == null) {
      imgUrls = imgUrl;
    } else {
      imgUrls = item?.logo3_img_url ?? imgUrl;
    }
    bool isNetImg = imgUrls.contains("http");
    return Container(
      constraints: BoxConstraints(minHeight: 200.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        color: context.customTheme?.pageTwoBg,
      ),
      padding: EdgeInsets.only(left: 40.w, right: 40.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    isNetImg
                        ? Image.network(
                            imgUrls,
                            height: 44.h,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Assets.theme1.images.activity.taskBarBg.path,
                                fit: BoxFit.cover, // 根据需要调整 fit 属性
                                height: 44.h,
                              );
                            },
                          )
                        : Image.asset(
                            imgUrl,
                            height: 44.h,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Assets.theme1.images.activity.taskBarBg.path,
                                fit: BoxFit.cover, // 根据需要调整 fit 属性
                                height: 44.h,
                              );
                            },
                          ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Text(
                        '有效投注额',
                        style: TextStyle(
                          fontSize: 42.sp,
                          color: context.customTheme?.title2Color,
                        ),
                      ),
                    ),
                    Text(
                      parseNumber(betAmount / 1000),
                      style: TextStyle(
                        fontSize: 42.sp,
                        color: context.customTheme?.title3Color,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildPercentage(context),
              ],
            ),
          ),
          SizedBox(width: 20.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RichText(
                text: TextSpan(
                  text: '当前比例',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: context.customTheme?.title2Color,
                  ),
                  children: [
                    TextSpan(text: ' ${parseNumber(proportion / 1000)}%'),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              RichText(
                text: TextSpan(
                  text: '可领取',
                  style: TextStyle(
                    fontSize: 36.sp,
                    color: context.customTheme?.title2Color,
                  ),
                  children: [
                    TextSpan(
                      text: reward == 0
                          ? ' 0.00'
                          : ' ${parseNumber(double.parse((reward / 1000).truncateToFixed(3)))}',
                      style: TextStyle(
                        color: context.customTheme?.title3Color,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 30.w),
            child: SvgPicture.asset(
              Assets.theme1.images.common.iconArrowRight,
              width: 24.w,
            ),
          )
        ],
      ),
    );
  }

  /// 构建进度条
  Widget _buildPercentage(BuildContext context) {
    if (showPercentage == false) {
      return const SizedBox();
    }

    double curPercentage = percentage / 1000;
    double progressValue = 0;
    if (betAmount + upAmount > 0) {
      progressValue = betAmount / (betAmount + upAmount);
    }

    return SizedBox(
      width: 450.w,
      height: 50.h,
      child: Stack(
        children: [
          Container(
            width: 450.w,
            height: 50.h,
            padding: EdgeInsets.only(top: 6.h, bottom: 6.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.r), // 设置圆角
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.r), // 设置圆角
              child: LinearProgressIndicator(
                value: progressValue, // 进度值，0.5表示50%
                backgroundColor: const Color(colorCDCDCD), // 进度条的背景颜色
                valueColor: AlwaysStoppedAnimation<Color>(
                    context.theme.primaryColor), // 进度条的颜色
              ),
            ),
          ),
          Visibility(
            // visible: curPercentage != 0,
            visible: true,
            child: Positioned.fill(
              child: Center(
                child: Text(
                  '再投注${parseNumber(upAmount / 1000)}可${parseNumber(curPercentage)}%', // 显示百分比
                  style: TextStyle(
                    fontSize: 30.sp, // 字体大小
                    color: const Color(colorFFFFFF), // 字体颜色
                    fontWeight: FontWeight.bold, // 加粗字体
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
