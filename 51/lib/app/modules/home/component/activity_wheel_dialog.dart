import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/activity_wheel_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ActivityWheelDialog extends StatefulWidget {
  final Function(bool)? onClose;

  const ActivityWheelDialog({Key? key, this.onClose}) : super(key: key);

  @override
  State<ActivityWheelDialog> createState() => _ActivityWheelDialogState();
}

class _ActivityWheelDialogState extends State<ActivityWheelDialog>
    with TickerProviderStateMixin {
  final ActivitysWheelController controller =
      Get.put(ActivitysWheelController());
  bool show = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return show
        ? Container(
            color: Colors.black.withAlpha(50),
            width: Get.width,
            height: Get.height,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 900.w,
                        height: 1100.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                  Assets.theme1.images.home.wheelTitleBg.path,
                                  width: Get.width / 1.5.w,
                                  height: 165.h,
                                  fit: BoxFit.contain,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 7.5),
                                    child: Text(
                                      '助力转盘',
                                      style: TextStyle(
                                        fontSize: 54.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Stack(children: [
                              Image.asset(
                                Assets.theme1.images.home.wheelBackgroud.path,
                                width: 600.w,
                                height: 600.w,
                                fit: BoxFit.contain,
                              ),
                              // Center(
                              //     child: AnimatedContainer(
                              //       duration: Duration(milliseconds: 500),
                              //       width: 450,
                              //       height: 450,
                              //       alignment: Alignment.center,
                              //       child: Transform.rotate(
                              //         angle: spinDeg,
                              //         child: Stack(
                              //           alignment: Alignment.center,
                              //           children: [
                              //             //  ...List.generate(controller.repositoryData
                              //             //       .value.param?.prizeArr?.length ?? 0 * 2, (index) {
                              //             ...List.generate(12, (index) {
                              //               final prize = controller.repositoryData
                              //                   .value.param?.prizeArr?[index % 6];
                              //               double angle = index * 30.0;
                              //               return Transform.rotate(
                              //                 angle: angle * (3.1416 / 180),
                              //                 child: CustomPaint(
                              //                   size: Size(100, 100),
                              //                   painter: SectorPainter(
                              //                       150,
                              //                       index % 3 == 0
                              //                           ? Colors.blueAccent
                              //                               .withAlpha(75)
                              //                           : index % 3 == 1
                              //                               ? Colors.blueAccent
                              //                                   .withAlpha(50)
                              //                               : Colors.blueAccent
                              //                                   .withAlpha(25)),
                              //                 ),
                              //               );
                              //             }),
                              //             AnimatedBuilder(
                              //               animation: _animation,
                              //               builder: (context, child) {
                              //                 return Transform.rotate(
                              //                   angle: _animation.value,
                              //                   child: Stack(
                              //                     alignment: Alignment.center,
                              //                     children: [
                              //                       ...List.generate(12, (index) {
                              //                         final prize = controller
                              //                             .repositoryData
                              //                             .value
                              //                             .param
                              //                             ?.prizeArr?[index % 6];
                              //                         // ...List.generate(controller.repositoryData.value.param?.prizeArr?.length ?? 0 * 2, (index) {
                              //                         //   final prize = controller.repositoryData.value.param?.prizeArr?[index % 6];
                              //                         double angle = index * 30.0;
                              //                         return Transform.rotate(
                              //                           angle: angle * (3.1416 / 180),
                              //                           child: Align(
                              //                             alignment: FractionalOffset(
                              //                                 0.5, 0.21),
                              //                             child: Column(
                              //                               mainAxisSize:
                              //                                   MainAxisSize.min,
                              //                               children: [
                              //                                 Image.network(
                              //                                   prize?.prizeIcon ??
                              //                                       '',
                              //                                   width: 40,
                              //                                   height: 40,
                              //                                 ),
                              //                                 SizedBox(height: 10),
                              //                                 Text(
                              //                                   prize?.prizeName ??
                              //                                       '',
                              //                                   style: TextStyle(
                              //                                       fontSize: 8,
                              //                                       color:
                              //                                           Colors.white),
                              //                                 ),
                              //                               ],
                              //                             ),
                              //                           ),
                              //                         );
                              //                       }),
                              //                     ],
                              //                   ),
                              //                 );
                              //               },
                              //             ),
                              //             CommonRipple(
                              //               onTap: () {
                              //                 if ((controller.repositoryData.value
                              //                             .integral ??
                              //                         0) ==
                              //                     0) {
                              //                   showDialog(
                              //                       context: context,
                              //                       builder: (BuildContext context) =>
                              //                           const AppCommonDialog(
                              //                               okLabel: '确定',
                              //                               msg: '您的积分不足，请补充积分再试一次'));
                              //                   return;
                              //                 }
                              //                 startRotation();
                              //                 controller.setTurntableWin((data) {
                              //                   if (data == true) {
                              //                     // 处理成功的结果
                              //                     controller.ztlight.value = 2;
                              //                     showWinDialog.value = true;
                              //                   }
                              //                   stopRotation();
                              //                 });
                              //               },
                              //               child: Image.network(
                              //                 zpImg!,
                              //                 fit: BoxFit.contain,
                              //                 height: 150,
                              //                 width: 150,
                              //               ),
                              //             ),
                              //             // RotatingImage(imageUrl: zpImg!),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ]),
                            SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '待领取：',
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.normal,
                                      color: context.theme.primaryColor,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '邀请人数：',
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    '0/5',
                                    style: TextStyle(
                                      fontSize: 36.sp,
                                      fontWeight: FontWeight.normal,
                                      color: context.theme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                width: Get.width / 1.5.w,
                                height: 115.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(115.r),
                                    ),
                                    backgroundColor: const Color(0XFF10c8e3),
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: () {},
                                  child: Text("领取",
                                      style: TextStyle(
                                          fontSize: 42.sp,
                                          color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        )),
                    SizedBox(height: 20.h), // Adjust the space if needed
                    // Close icon
                    Container(
                      width: 80.w,
                      height: 80.h,
                      decoration: BoxDecoration(
                        color: Colors.white, // White background
                        shape: BoxShape.circle, // Circular shape
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                            offset: Offset(0, 4), // Shadow position
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon:
                            Icon(Icons.close, color: Colors.black, size: 40.sp),
                        onPressed: () {
                          setState(() => show = false);
                          widget.onClose?.call(true);
                        },
                      ),
                    ),
                  ]),
            ))
        : const SizedBox.shrink();
  }
}
