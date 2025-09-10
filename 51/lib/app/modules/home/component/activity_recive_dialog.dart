import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';

class ActivityReciveDialog extends StatelessWidget {
  final double? price;
  const ActivityReciveDialog({super.key, this.price});

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 0.w),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: Colors.transparent.withOpacity(0),
              ),
            ),
            Positioned(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        Assets.theme1.images.home.activityOpenbg.path),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height / 2 - 130),
                    Image.asset(
                      Assets.theme1.images.home.activityOpentitle1.path,
                      fit: BoxFit.contain,
                      width: 285.w,
                      height: 80.h,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 50),
                        Text(
                          '${price}',
                          style: const TextStyle(
                            color: Color(0xFFDF0B10),
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          Assets.theme1.images.home.activityYuan.path,
                          fit: BoxFit.contain,
                          width: 40,
                          height: 30,
                          color: Color(0xFFDF0B10),
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                    SizedBox(height: 50),
                    Image.asset(
                      Assets.theme1.images.home.activityOpentitle2.path,
                      fit: BoxFit.contain,
                      width: 540.w,
                      height: 80.h,
                    ),
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: context.theme.cardColor.withOpacity(.9),
                          borderRadius: BorderRadius.circular(12.5),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_sharp,
                          color: Colors.red,
                          size: 15,
                        ),
                      ).onTap(() {
                        AppManager.instance.tapVibrate();
                        Get.back();
                      }),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
