
import 'package:flutter/cupertino.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class FrontBanner extends StatefulWidget {
  final List<String> data;

  const FrontBanner({super.key, required this.data});

  @override
  State<FrontBanner> createState() => _CustomSportBannerState();
}

class _CustomSportBannerState extends State<FrontBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 12),
        height: 188.sp,
        child: Obx(() {
          return Swiper(
            itemCount: widget.data.length,
            itemBuilder: (BuildContext context, int index) {
              print('图片地址：${AppValues.defaultBranch.asset_url + widget.data[index]}');
              return ClipRRect(
                borderRadius: BorderRadius.circular(8.0), // 设置圆角半径
                child: Image.network(
                  AppValues.defaultBranch.asset_url + widget.data[index],
                  fit: BoxFit.fill,
                  width: 322.sp, // 设置宽度
                  height: 188.sp, // 设置高度
                ),
              );
            },
            pagination: SwiperPagination(), // 添加小圆点指示器
            control: null, // 添加左右箭头控制
          );
        }),
      ),
    );
  }
}
