import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';

import "package:flutter_tiyu_app/app/modules/activity//widget/network_image_with_fallback.dart";

class TaskPageLeftIcon extends StatefulWidget {
  final String? iconUrl;
  final bool? isNetwork;
  const TaskPageLeftIcon({
    super.key,
    this.iconUrl,
    this.isNetwork = true,
  });

  @override
  State<TaskPageLeftIcon> createState() => _TaskPageLeftIconState();
}

class _TaskPageLeftIconState extends State<TaskPageLeftIcon> {
  @override
  Widget build(BuildContext context) {
    bool notNetWorkImg = widget.iconUrl == '' || widget.iconUrl == null;

    return Container(
      width: 114.w,
      height: 114.w,
      padding: EdgeInsets.all(0.r),
      margin: EdgeInsets.only(right: 44.w),
      alignment: Alignment.center,
      decoration: notNetWorkImg
          ? BoxDecoration(
              color: const Color(colorF6F6F6),
              borderRadius: BorderRadius.circular(56.r),
            )
          : null,
      child: widget.isNetwork == true
          ? NetworkImageWithFallback(
              imageUrl: widget.iconUrl ?? '',
              fallbackAsset: Assets.theme1.images.activity.taskBarBg.path,
              fit: BoxFit.cover,
            )
          // ? Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Transform.scale(
          //         scale: 0.9,
          //         alignment: Alignment.center,
          //         child: NetworkImageWithFallback(
          //           imageUrl: widget.iconUrl ?? '',
          //           fallbackAsset: Assets.theme1.images.activity.taskBarBg.path,
          //           fit: BoxFit.cover,
          //         ),
          //       ),
          //     ],
          //   )
          : Image.asset(
              widget.iconUrl!,
              fit: BoxFit.cover,
            ),
    );
  }
}
