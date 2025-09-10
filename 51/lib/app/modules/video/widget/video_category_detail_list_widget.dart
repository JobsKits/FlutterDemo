import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../data/video_home_bean.dart';

///视频分类详情的列表组件
class VideoCategoryDetailListWidget extends StatefulWidget {
  final RxList<VideoSecondList> data; //标题

  const VideoCategoryDetailListWidget({super.key, required this.data});

  @override
  State<VideoCategoryDetailListWidget> createState() =>
      _VideoCategoryListWidgetState();
}

class _VideoCategoryListWidgetState
    extends State<VideoCategoryDetailListWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        padding: EdgeInsets.symmetric(horizontal: 33.w, vertical: 45.h),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(40.r)),
        child: Column(
          children: [
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
                      if (widget.data[index].id == 130) {
                        Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                            arguments: {"videoId": widget.data[index].id});
                      } else {
                        if (widget.data[index].classify?.contains("黑料") ??
                            false) {
                          Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                              arguments: {"videoId": widget.data[index].id});
                        } else {
                          Get.toNamed(Routes.VIDEO_DETAIL,
                              arguments: {"videoId": widget.data[index].id});
                        }
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
          ],
        ),
      ),
    );
  }
}
