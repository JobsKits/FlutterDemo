import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../controllers/video_search_controller.dart';
import '../widget/video_search_list_widget.dart';

class VideoSearchView extends GetView<VideoSearchController> {
  const VideoSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(colorF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
        titleSpacing: 0,
        title: Container(
            height: 93.h,
            margin: EdgeInsets.only(right: 33.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: const Color(colorF5F5F5),
                borderRadius: BorderRadius.circular(77.r)),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20.w, right: 15.w),
                  child: SvgPicture.asset(
                    Assets.theme1.images.video.iconSearch,
                    width: 42.w,
                    height: 42.h,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    cursorColor: context.theme.primaryColor,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            required maxLength}) =>
                        null, // 不显示计数器
                    decoration: InputDecoration(
                      hintText: "大家都在搜",
                      contentPadding: EdgeInsets.only(top: 10.h),
                      hintStyle: TextStyle(
                          fontSize: 33.sp, color: const Color(colorBCBCBC)),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide.none, // 去除边框线
                      ),
                    ),
                  ),
                ),
                // _buildRightWidget()
                Obx(() => Visibility(
                    visible: controller.isShowDeleteIcon.value,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.cleanInput();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 30.w),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(colorBBBFC8),
                            borderRadius: BorderRadius.circular(26.r)),
                        width: 51.w,
                        height: 51.h,
                        child: Icon(
                          Icons.close,
                          size: 50.w,
                          color: Colors.white,
                        ),
                      ),
                    ))),
                CommonRipple(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                    controller.searchVideo();
                  },
                  child: Container(
                    width: 154.w,
                    margin: EdgeInsets.only(right: 10.w),
                    height: 70.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: context.theme.primaryColor,
                        borderRadius: BorderRadius.circular(35.r)),
                    child: Text(
                      "搜索",
                      style: TextStyle(fontSize: 39.sp, color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        _buildHistoryView(context),
        Expanded(
            child: Obx(() => controller.searchList.isNotEmpty
                ? VideoSearchListWidget(
                    // key: controller.homeListKeys[index],
                    data: controller.searchList,
                  )
                : SizedBox()))
      ],
    );
  }

  Widget _buildHistoryView(BuildContext context) {
    return Obx(() => controller.historyList.isNotEmpty
        ? Container(
            color: Colors.white,
            padding: EdgeInsets.only(
                top: 20.h, left: 45.w, right: 45.w, bottom: 40.h),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "历史搜索",
                      style: TextStyle(fontSize: 36.sp),
                    ),
                    Obx(() => CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            controller.changeDeleteMode();
                          },
                          child: controller.isDeleteMode.value
                              ? Row(
                                  children: [
                                    CommonRipple(
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        controller.deleteAllHistory();
                                      },
                                      child: Text(
                                        "清空",
                                        style: TextStyle(
                                            fontSize: 36.sp,
                                            color: Color(color99999)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 40.w),
                                      child: Text("|",
                                          style: TextStyle(
                                              fontSize: 36.sp,
                                              color: Color(color99999))),
                                    ),
                                    CommonRipple(
                                      onTap: () {
                                        AppManager.instance.tapVibrate();
                                        controller.changeDeleteMode();
                                      },
                                      child: Text("完成",
                                          style: TextStyle(
                                              fontSize: 36.sp,
                                              color:
                                                  context.theme.primaryColor)),
                                    )
                                  ],
                                )
                              : SvgPicture.asset(
                                  Assets.theme1.images.video.iconDelete,
                                  width: 54.w,
                                  height: 54.h,
                                ),
                        ))
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.h),
                  width: double.infinity,
                  child: Obx(() => Wrap(
                        alignment: WrapAlignment.start, // 确保左对齐
                        children: List.generate(controller.historyList.length,
                            (index) {
                          return _buildHistoryItem(index);
                        }),
                      )),
                )
              ],
            ))
        : SizedBox());
  }

  Widget _buildHistoryItem(int index) {
    return CommonRipple(
      onTap: () {
        AppManager.instance.tapVibrate();
        if (controller.isDeleteMode.value) {
          controller.deleteHistory(index);
        } else {
          controller.clickHistory(index);
        }
      },
      child: Container(
        height: 80.h,
        margin: EdgeInsets.only(right: 33.w, bottom: 33.h),
        padding: EdgeInsets.only(left: 40.w, right: 20.w),
        decoration: BoxDecoration(
            color: Color(colorF4F4F4),
            borderRadius: BorderRadius.circular(40.r)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "${controller.historyList[index]}",
              style: TextStyle(fontSize: 39.h, color: Color(color99999)),
            ),
            SizedBox(
              width: 20.w,
            ),
            Visibility(
                visible: controller.isDeleteMode.value,
                child: Icon(
                  Icons.close,
                  size: 50.w,
                  color: Color(colorCECECE),
                ))
          ],
        ),
      ),
    );
  }
}
