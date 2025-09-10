import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/app_lucky_wheel_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';

import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';

//幸运大转盘页面
class AppLuckyWheelView extends GetView<AppLuckyWheelController> {
  const AppLuckyWheelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("幸运大转盘"),
        centerTitle: true,
        leading: BackButton(
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 33.w),
      alignment: Alignment.center,
      child: Column(
        children: [_buildPoints(), _buildWheel(context), _buildPointsButton()],
      ),
    );
  }

  Widget _buildPoints() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Obx(() => Text("当前积分：${controller.luckyPointsBean.value?.usable}")),
        ElevatedButton(onPressed: () {}, child: const Text("充值"))
      ],
    );
  }

  Widget _buildPointsButton() {
    return Obx(() => Row(
          children: List.generate(
              controller.luckyWheelBean.value?.luckyBigWheelSys?.length ?? 0,
              (index) {
            return Expanded(
                child: Obx(() => CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        controller.changeSelectIndex(index);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 200.h,
                        margin: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                            color:
                                (controller.currentSelectIndex.value == index)
                                    ? Colors.red
                                    : Colors.black26,
                            borderRadius: BorderRadius.circular(30.r)),
                        child: Column(
                          children: [
                            Text(
                              "${controller.luckyWheelBean.value?.luckyBigWheelSys![index].name}",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.sp),
                            ),
                            Text(
                              "每次消耗 ${controller.luckyWheelBean.value?.luckyBigWheelSys![index].integral} 积分",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30.sp),
                            ),
                          ],
                        ),
                      ),
                    )));
          }),
        ));
  }

  Widget _buildWheel(BuildContext context) {
    return Obx(() => SizedBox(
          width: 300,
          height: 300,
          child: Stack(
            children: [
              controller.wheelItems.isNotEmpty
                  ? FortuneWheel(
                      animateFirst: false,
                      indicators: [],
                      selected: controller.selected.stream,
                      onAnimationEnd: () {
                        controller.showFinishDialog();
                      },
                      items: [
                        for (int i = 0; i < controller.wheelItems.length; i++)
                          FortuneItem(
                            style: FortuneItemStyle(
                                textAlign: TextAlign.end,
                                color: (i % 2 == 0)
                                    ? context.theme.primaryColor
                                    : context.theme.primaryColor
                                        .withOpacity(0.6),
                                borderColor: Colors.white),
                            child: Padding(
                                padding: EdgeInsets.only(right: 50.w),
                                child: RotatedBox(
                                    quarterTurns: 1,
                                    child: Column(
                                      children: [
                                        Text(
                                            "${(controller.wheelItems[i].prize! / 1000) == 0 ? '谢谢参与' : (controller.wheelItems[i].prize! / 1000)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 45.sp)),
                                        SizedBox(
                                          height: 50.h,
                                        ),
                                        Image.network(
                                          "${controller.wheelItems[i].imgUrl}",
                                          width: 100.w,
                                          height: 100.h,
                                        )
                                      ],
                                    ))),
                          ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              Visibility(
                  visible: controller.wheelItems.isNotEmpty,
                  child: Center(
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        // controller.selected.add(11); //这里传递想要停止位置的索引，0开始
                        controller.startWheel();
                      },
                      child: Image.asset(
                          Assets.theme1.images.user.btnRotate.path,
                          width: 64,
                          height: 64),
                    ),
                  ))
            ],
          ),
        ));
  }
}
