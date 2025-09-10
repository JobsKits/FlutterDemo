import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_values.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_asset_icon.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../a_model/activity_quick_api_model.dart';

class CustomFloatingActionWidget extends StatefulWidget {
  final bool isShow;
  final List<ActivityQuickApiModel> modelList;
  final void Function(ActivityQuickApiModel model)? onClickItem;
  final void Function()? onClickClose;

  const CustomFloatingActionWidget({
    super.key,
    required this.isShow,
    required this.modelList,
    required this.onClickItem,
    required this.onClickClose,
  });

  @override
  State<CustomFloatingActionWidget> createState() => _CustomFloatingActionWidgetState();
}

class _CustomFloatingActionWidgetState extends State<CustomFloatingActionWidget> {
  @override
  Widget build(BuildContext context) {
    return _buildFloatingActionView();
  }

  Widget _buildFloatingActionView() {
    return Visibility(
      visible: widget.isShow,
      // visible: true,
      child: Container(
        height: 75,
        width: 75,
        color: Colors.transparent,
        // color: Colors.red,
        child: Stack(
          alignment: Alignment.center,
          // fit: StackFit.loose,
          children: [
            Swiper(
              itemWidth: 75,
              itemHeight: 75,
              containerWidth: 70,
              containerHeight: 70,
              scale: 0.90,
              // viewportFraction: 0.92,
              autoplayDelay: 3000,
              layout: SwiperLayout.DEFAULT,
              indicatorLayout: PageIndicatorLayout.NONE,
              loop: widget.modelList.length > 1 ? true : false,
              autoplay: widget.modelList.length > 1 ? true : false,
              autoplayDisableOnInteraction: false,
              axisDirection: AxisDirection.right,
              itemBuilder: (context, index) {
                return CustomButton(
                  padding: EdgeInsets.zero,
                  onTap: () {
                    if (widget.onClickItem != null) {
                      widget.onClickItem!.call(widget.modelList[index]);
                    }
                  },
                  child: Container(
                    // padding: const EdgeInsets.only(left: 3.0, right: 3.0, top: 3.0, bottom: 3.0),
                    child: CustomNetWorkImage(
                      imageUrl: getQuickActivityImageUrl(index),
                      // imageUrl:
                      //     "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
                      showErrorMsg: false,
                      // height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
              // autoplay: true,
              itemCount: widget.modelList.length,
              scrollDirection: Axis.horizontal,
              // pagination: const SwiperPagination(alignment: Alignment.centerRight),
              // control: logic.activityFloatListObs.length >= 2
              //     ? const SwiperControl(
              //         color: Color(0xFFB1BAD3),
              //         size: 20,
              //         padding: EdgeInsets.all(0),
              //       )
              //     : null,
              control: null,
              // controller: SwiperController(),
            ),
            Positioned(
                right: 1,
                top: 1,
                child: CustomButton(
                  // padding: EdgeInsets.zero,
                  padding: const EdgeInsets.only(left: 5, bottom: 5),
                  onTap: () {
                    if (widget.onClickClose != null) {
                      widget.onClickClose!.call();
                    }
                  },
                  child: const CustomAssetIcon(
                      name: "assets/images/common/ic_common_close_white.webp", size: 8),
                )),
          ],
        ),
      ),
    );
  }

  String baseNetIcon = AppValues.defaultBranch.asset_url;

  ///获取活动快捷入口 image url.
  String getQuickActivityImageUrl(int index) {
    var url = widget.modelList[index].iconList?.first;
    if (url != null && url.isNotEmpty) {
      //奇怪的图片链接，有时候有/。有时候没有
      if (url.startsWith('/')) {
        return "$baseNetIcon$url";
      } else {
        return "$baseNetIcon/$url";
      }
    }
    return "";
  }
}
