import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_half_screen_controller.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../routes/app_pages.dart';
import '../data/video_home_bean.dart';

///视频内容的列表组件
class VideoCategoryListWidget extends StatefulWidget {
  final RxList<VideoSecondList> data; //标题
  final VoidCallback? clickMore; //点击了更多、查看更多
  final VoidCallback? clickRefresh; //点击了换一换

  const VideoCategoryListWidget(
      {super.key, required this.data, this.clickMore, this.clickRefresh});

  @override
  State<VideoCategoryListWidget> createState() =>
      _VideoCategoryListWidgetState();
}

class _VideoCategoryListWidgetState extends State<VideoCategoryListWidget> {
  // int _currentPage = 0;
  // int _itemsPerPage = 6; // 每页显示6条数据
  //
  // // 获取当前页面的数据
  // List<VideoSecondList> _getCurrentPageItems() {
  //   int start = _currentPage * _itemsPerPage;
  //   int end = start + _itemsPerPage;
  //   end = end > widget.data.length ? widget.data.length : end;
  //   return widget.data.sublist(start, end);
  // }
  //
  // // 切换到下一页
  // void _nextPage() {
  //   setState(() {
  //     _currentPage++;
  //     if (_currentPage * _itemsPerPage >= widget.data.length) {
  //       _currentPage = 0; // 如果超出数据，回到第一页
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 45.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
      child: Column(
        children: [
          Visibility(
              visible: widget.data[0].classify?.isNotEmpty ?? false,
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
                            "${widget.data[0].classify}",
                            style: TextStyle(
                                fontSize: 51.sp, fontWeight: FontWeight.bold),
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
                ],
              )),
          GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.data.length, //数据后期从controller拿，现在暂时写死
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 32.w,
                childAspectRatio: 1.1,
                mainAxisSpacing: 30.w,
              ),
              itemBuilder: (context, index) {
                return CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    if (widget.data[index].classify?.contains("黑料") ?? false) {
                      Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                          arguments: {"videoId": widget.data[index].id});
                    } else {
                      Get.toNamed(Routes.VIDEO_DETAIL,
                          arguments: {"videoId": widget.data[index].id});
                    }
                  },
                  child: Column(
                    children: [
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
                              imageUrl: "${widget.data[index].uploadThumb}"),
                        ),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Text(
                        "${widget.data[index].title}",
                        style: TextStyle(
                            fontSize: 38.sp, color: const Color(color525252)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 16.h,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text(
                      //         "${DateTimeUtils.formatDateTime(widget.data.list![index].createDate!)}",
                      //         style: TextStyle(
                      //             fontSize: 32.sp,
                      //             color: const Color(color8C8C8C))),
                      //     Text("${widget.data.list![index].watchtimes}观看",
                      //         style: TextStyle(
                      //             fontSize: 32.sp,
                      //             color: const Color(color8C8C8C))),
                      //   ],
                      // )
                    ],
                  ),
                );
              }),
          Row(
            children: [
              Expanded(
                  child: CommonRipple(
                onTap: widget.clickRefresh,
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
                        CommonRipple(
                          onTap: widget.clickRefresh,
                          child: Text(
                            "换一换",
                            style: TextStyle(
                                fontSize: 38.sp,
                                color: const Color(colorA7A7A7)),
                          ),
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
