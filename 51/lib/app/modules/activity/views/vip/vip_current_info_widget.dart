import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/vip_info_bean.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/public_util.dart';

class VipCurrentInfoWidget extends StatefulWidget {
  final int level;
  final double rechargeDiff;
  final double bettingDiff;
  final VipLevelItemBean? vipLevel;
  const VipCurrentInfoWidget({
    super.key,
    required this.level,
    required this.rechargeDiff,
    required this.bettingDiff,
    required this.vipLevel,
  });

  @override
  State<VipCurrentInfoWidget> createState() => _VipCurrentInfoWidgetState();
}

class _VipCurrentInfoWidgetState extends State<VipCurrentInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 274.h,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      padding: EdgeInsets.only(left: 60.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        image: DecorationImage(
          image: AssetImage(Assets.theme1.images.activity.vip.vipInfoBg.path),
          fit: BoxFit.cover, // 使用 BoxFit.cover
          alignment: Alignment.topCenter, // 将图像对齐到顶部
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCurrentLevelWidget(),
              Text(
                widget.vipLevel?.level == widget.level
                    ? '恭喜，您已达最高VIP等级！'
                    : '距离VIP${widget.level + 1}, \n${widget.rechargeDiff > 0 ? '充值还差${parseNumber(widget.rechargeDiff)},' : ''}${widget.bettingDiff > 0 ? '投注还差${parseNumber(widget.bettingDiff)},' : ''}',
                style: TextStyle(
                  fontSize: 36.sp,
                  color: const Color(color5398A2),
                  height: 1.2,
                ),
              )
            ],
          ),
          Positioned(
            top: 30.h,
            right: 60.r,
            child: _buildVipImageWidget(),
          )
        ],
      ),
    );
  }

  Widget _buildVipImageWidget() {
    String path = 'assets/theme1/images/activity/vip/vip${widget.level}.png';

    return Image.asset(
      path,
      width: 243.w,
      height: 212.h,
      errorBuilder: (context, error, stackTrace) => Image.asset(
        Assets.theme1.images.activity.vip.vip10.path,
        fit: BoxFit.cover, // 根据需要调整 fit 属性
        height: 212.h,
      ),
    );
  }

  Widget _buildCurrentLevelWidget() {
    return Row(
      children: [
        Text(
          '当前等级：',
          style: TextStyle(fontSize: 39.sp, color: const Color(color5398A2)),
        ),
        SizedBox(width: 30.w),
        Text(
          'VIP${widget.level}',
          style: TextStyle(
            fontSize: 60.sp,
            color: const Color(color008EA3),
          ),
        )
      ],
    );
  }
}
