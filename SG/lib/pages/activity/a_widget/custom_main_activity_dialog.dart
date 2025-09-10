import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_values.dart';
import '../../../services/lang_service.dart';
import '../../../utils/route_util.dart';
import '../../../widget/button/custom_button.dart';
import '../../../widget/custom_icon.dart';
import '../../../widget/dialog/custom_safe_dialog.dart';
import '../../../widget/network_image/custom_network_image.dart';
import '../a_model/activity_quick_api_model.dart';
import 'custom_main_activity_dialog_logic.dart';

class CustomMainActivityDialog extends StatefulWidget {
  final bool isShow;
  final List<ActivityQuickApiModel> modelList;
  final void Function(ActivityQuickApiModel model)? onClickItem;
  final void Function()? onClickClose;
  final bool isSwiper; //是否使用作用轮播组件，false 的话 使用单个显示
  final ActivityQuickApiModel? model; //当isSwiper 为false， 需要配置

  const CustomMainActivityDialog({
    super.key,
    required this.isShow,
    required this.modelList,
    required this.onClickItem,
    required this.onClickClose,
    this.isSwiper = true,
    this.model,
  });

  ///静态方法，打开方法, 显示窗口
  static Future<void> showDetailDialog<T>({
    required BuildContext context,
    bool barrierDismissible = false,
    bool useRootNavigator = true,
    // required BettingRecordApiModel recordModel,
    // required CasinoGameTypeEnum gameType,
    required CustomMainActivityDialog dialogView,
    void Function()? onDialogDelete,
  }) async {
    await CustomSafeDialog.show<T>(
        context: context,
        // tag: kCasinoDetailWidget,
        barrierDismissible: barrierDismissible,
        useRootNavigator: useRootNavigator,
        builder: (_) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: GestureDetector(
                onTap: () {
                  RouteUtil.popView();
                },
              )),
              dialogView,
              Expanded(child: GestureDetector(
                onTap: () {
                  RouteUtil.popView();
                },
              )),
            ],
          );
        }).then(
      (value) {
        if (onDialogDelete != null) {
          onDialogDelete.call();
        }
      },
    );
  }

  @override
  State<CustomMainActivityDialog> createState() => _CustomMainActivityDialogState();
}

class _CustomMainActivityDialogState extends State<CustomMainActivityDialog> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        // margin: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          // height: dialogMaxHeight,
          height: Get.width,
          child: LayoutBuilder(
            builder: (_, constraints) {
              // log("CustomCasinoDetailDialogWidget...constraints...$constraints");
              return Stack(
                children: [
                  widget.isSwiper
                      ? Swiper(
                          itemWidth: Get.width,
                          itemHeight: Get.width,
                          containerWidth: Get.width,
                          containerHeight: Get.width,
                          // scale: 0.90,
                          // viewportFraction: 0.92,
                          autoplayDelay: 3000,
                          layout: SwiperLayout.DEFAULT,
                          indicatorLayout: PageIndicatorLayout.NONE,
                          loop: widget.modelList.length > 1 ? true : false,
                          autoplay: widget.modelList.length > 1 ? true : false,
                          autoplayDisableOnInteraction: false,
                          axisDirection: AxisDirection.right,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              child: CustomButton(
                                padding: EdgeInsets.zero,
                                onTap: () {
                                  if (widget.onClickItem != null) {
                                    widget.onClickItem!.call(widget.modelList[index]);
                                  }
                                },
                                child: CustomNetWorkImage(
                                  imageUrl: getMainActivityImageUrl(widget.modelList[index]),
                                  // imageUrl:
                                  //     "https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg",
                                  showErrorMsg: false,
                                  // height: 50,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            );
                          },
                          // autoplay: true,
                          itemCount: widget.modelList.length,
                          scrollDirection: Axis.horizontal,
                          control: null,
                          // controller: SwiperController(),
                        )
                      : Padding(
                          padding: EdgeInsets.all(12),
                          child: InkWell(
                            child: CustomNetWorkImage(
                              // https://k.sinaimg.cn/www/dy/slidenews/2_img/2010_30/786_132481_319348.jpg/w640slw.jpg
                              imageUrl: getMainActivityImageUrl(widget.model),
                              showErrorMsg: false,
                              // height: 50,
                              fit: BoxFit.contain,
                            ),
                            onTap: () {
                              if (widget.onClickItem != null && widget.model != null) {
                                widget.onClickItem!.call(widget.model!);
                              }
                            },
                          ),
                        ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: InkWell(
                      onTap: () {
                        if (widget.onClickClose != null) {
                          widget.onClickClose!.call();
                        }
                      },
                      child: const Padding(
                        // padding: EdgeInsets.all(AppValues.defaultPadding),
                        padding: EdgeInsets.zero,
                        child: CustomIcon(
                          asset: 'assets/images/activity/ic_activity_dialog_close.webp',
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String baseNetIcon = AppValues.defaultBranch.asset_url;

  ///获取活动快捷入口 image url.
  String getMainActivityImageUrl(ActivityQuickApiModel? model) {
    if (model != null) {
      return "$baseNetIcon/images/promo/pop/${LangService().lang.label}/${model.ty}.webp";
    } else {
      return "";
    }
  }
}
