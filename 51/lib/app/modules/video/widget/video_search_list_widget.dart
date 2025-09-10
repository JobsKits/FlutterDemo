import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../data/video_home_bean.dart';

///视频内容的列表组件
class VideoSearchListWidget extends StatefulWidget {
  final RxList<VideoSecondList> data; //标题
  final VoidCallback? clickMore; //点击了更多、查看更多
  final VoidCallback? clickRefresh; //点击了换一换

  const VideoSearchListWidget(
      {super.key, required this.data, this.clickMore, this.clickRefresh});

  @override
  State<VideoSearchListWidget> createState() => _VideoCategoryListWidgetState();
}

class _VideoCategoryListWidgetState extends State<VideoSearchListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 45.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
      child: GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: widget.data.length,
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
                  Container(
                    height: 287.h,
                    decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(30.r),
                        image: DecorationImage(
                            image: NetworkImage(
                                "${widget.data[index].uploadThumb}"),
                            fit: BoxFit.cover)),
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
                ],
              ),
            );
          }),
    );
  }
}
