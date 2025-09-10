import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/video/controllers/video_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/date_time_utils.dart';
import '../../../routes/app_pages.dart';

///视频首页黑料列表组件
class VideoBlackListWidget extends StatefulWidget {
  const VideoBlackListWidget({super.key});

  @override
  State<VideoBlackListWidget> createState() => _VideoCategoryListWidgetState();
}

class _VideoCategoryListWidgetState extends State<VideoBlackListWidget> {
  late VideoController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.fromLTRB(horizontal: 36.w, vertical: 50.h),
      padding: EdgeInsets.fromLTRB(36.w, 50.h, 36.w, 23.h),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: controller.secondList.length,
          itemBuilder: (context, index) {
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.toNamed(Routes.VIDEO_BLACK_DETAIL,
                    arguments: {"videoId": controller.secondList[index].id});
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40.r),
                child: Container(
                  height: 600.h,
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      // image: DecorationImage(
                      //     fit: BoxFit.cover,
                      //     image: NetworkImage(
                      //         controller.secondList[index].uploadThumb!)),
                      borderRadius: BorderRadius.circular(40.r)),
                  margin: EdgeInsets.only(bottom: 27.h),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                          placeholder: (context, url) => Image.asset(
                                Assets
                                    .theme1.images.video.defaultVideoImage.path,
                                width: 274.w,
                                height: 241.h,
                              ),
                          errorWidget: (context, url, error) => Image.asset(
                                Assets
                                    .theme1.images.video.defaultVideoImage.path,
                                width: 274.w,
                                height: 241.h,
                              ),
                          imageUrl:
                              "${controller.secondList[index].uploadThumb!}"),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 0.w, vertical: 0.h),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 40.w, right: 40.w), // 可选的内边距
                          margin: EdgeInsets.only(top: 250.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFF000000).withAlpha(0), // 渐变起始颜色
                                Color(0xFF000000).withAlpha(100), // 渐变结束颜色
                              ],
                            ),
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${controller.secondList[index].title}",
                                style: TextStyle(
                                  fontSize: 54.sp,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${DateTimeUtils.formatDateTime(controller.secondList[index].createDate!)}",
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    "${controller.secondList[index].classify}",
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15.h),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
