import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_half_screen_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../api/video_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../routes/app_pages.dart';
import '../../../widget/common_loading_view.dart';
import '../data/video_home_bean.dart';

///视频内容的列表组件
class VideoContentListWidget extends StatefulWidget {
  final VideoHomeBean data; //标题
  final VoidCallback? clickMore; //点击了更多、查看更多

  const VideoContentListWidget({super.key, required this.data, this.clickMore});

  @override
  State<VideoContentListWidget> createState() => _VideoContentListWidgetState();
}

class _VideoContentListWidgetState extends State<VideoContentListWidget> {
  int currentCategoryPage = 0;
  List<VideoSecondList> dataList = [];
  @override
  void initState() {
    super.initState();
    print('${widget.data.title}: ${widget.data.list}');
    // refreshTabList();
    if (widget.data.list != null) {
      dataList = widget.data.list!.take(6).toList();
    }
  }

  void refreshTabList() async {
    currentCategoryPage += 1;
    EasyLoading.show(indicator: const CommonLoadingView());
    dataList = await VideoApi.reqVideoList(
        id: widget.data.id!,
        type: widget.data.type!,
        page: currentCategoryPage);

    setState(() {});
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 45.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 14.w,
                    height: 51.h,
                    decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(21.r)),
                  ),
                  SizedBox(
                    width: 22.w,
                  ),
                  Text(
                    "${widget.data.title}",
                    style:
                        TextStyle(fontSize: 51.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 50.w,
                  ),
                  Text(
                    "边看边玩",
                    style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.w500,
                        color: Color(colorA6A6A6)),
                  ).onTap(() {
                    AppManager.instance.tapVibrate();
                    HalfScreenController.showHalfScreenImage();
                  })
                ],
              ),
              CommonRipple(
                onTap: widget.clickMore,
                child: Text(
                  "更多 >",
                  style: TextStyle(
                      fontSize: 36.sp, color: const Color(colorA6A6A6)),
                ),
              )
            ],
          ),
          SizedBox(
            height: 70.h,
          ),
          GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dataList.length, //数据后期从controller拿，现在暂时写死
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 32.w,
                mainAxisSpacing: 30.w,
              ),
              itemBuilder: (context, index) {
                return CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (widget.data.id == 130) {
                      Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                          arguments: {"videoId": dataList[index].id});
                    } else {
                      if (dataList[index].classify?.contains("黑料") ?? false) {
                        Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                            arguments: {"videoId": dataList[index].id});
                      } else {
                        Get.toNamed(Routes.VIDEO_DETAIL,
                            arguments: {"videoId": dataList[index].id});
                      }
                    }
                  },
                  child: Column(
                    children: [
                      // Container(
                      //   height: 287.h,
                      //   decoration: BoxDecoration(
                      //       color: Colors.black26,
                      //       borderRadius: BorderRadius.circular(30.r),
                      //       image: DecorationImage(
                      //           image: NetworkImage(
                      //               "${dataList[index].uploadThumb}"),
                      //           fit: BoxFit.cover)),
                      // ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(30.r),
                        child: Container(
                          height: 287.h,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.black26,
                          ),
                          child: CachedNetworkImage(
                              placeholder: (context, url) => Image.asset(
                                    Assets.theme1.images.video.defaultVideoImage
                                        .path,
                                    width: 274.w,
                                    height: 241.h,
                                  ),
                              errorWidget: (context, url, error) => Image.asset(
                                    Assets.theme1.images.video.defaultVideoImage
                                        .path,
                                    width: 274.w,
                                    height: 241.h,
                                  ),
                              imageUrl: "${dataList[index].uploadThumb}"),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Text(
                        "${dataList[index].title}",
                        style: TextStyle(
                            fontSize: 38.sp, color: const Color(color525252)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                    ],
                  ),
                );
              }),
          Row(
            children: [
              Expanded(
                  child: CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  refreshTabList();
                },
                child: Container(
                    height: 82.h,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(64.r),
                        color: const Color(colorF6F6F8)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.theme1.images.video.iconRefresh,
                          width: 42.w,
                          height: 42.h,
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          "换一换",
                          style: TextStyle(
                              fontSize: 38.sp, color: const Color(colorA7A7A7)),
                        )
                      ],
                    )),
              )),
              SizedBox(
                width: 38.w,
              ),
              Expanded(
                  child: CommonRipple(
                      onTap: widget.clickMore,
                      child: Container(
                        alignment: Alignment.center,
                        height: 82.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(64.r),
                            color: const Color(colorF6F6F8)),
                        child: Text(
                          "+ 查看更多",
                          style: TextStyle(
                              fontSize: 38.sp, color: const Color(colorA7A7A7)),
                        ),
                      )))
            ],
          )
        ],
      ),
    );
  }
}
