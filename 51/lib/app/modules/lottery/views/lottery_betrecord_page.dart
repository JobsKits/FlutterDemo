import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/app/modules/lottery/controllers/lottery_home_controller.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class LotteryBetRecrodPage extends StatefulWidget {
  const LotteryBetRecrodPage({super.key});

  @override
  State<LotteryBetRecrodPage> createState() => _LotteryBetRecrodPageState();
}

class _LotteryBetRecrodPageState extends State<LotteryBetRecrodPage> {
  final LotteryController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.betList.isNotEmpty
        ? ListView.builder(
            controller: controller.scrollController,
            itemCount: controller.betList.length + 1,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              // if (index == controller.betList.length) {
              //   return controller.betList.value
              //       ? Center(
              //           child: CircularProgressIndicator(),
              //         )
              //       : SizedBox();
              // }
              return _buildList();
            })
        : emptyWidget());
  }

  Widget _buildList() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Column(children: [
              Row(
                children: [
                  // Left-aligned Text
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10.0), // Left margin of 10
                    child: Text(
                      '彩票/分分快三',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Spacer to push the second text to the right
                  Spacer(),

                  // Right-aligned Text
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 10.0), // Right margin of 10
                    child: Text(
                      '已结算',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '投注项: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '和值',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ]),
              Row(children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '投注项: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '¥20',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '输赢金额: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, left: 10.0), // Left margin of 10
                  child: Text(
                    '¥0',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ]),
              Divider(
                color: Colors.grey, // Line color
                thickness: 1, // Line thickness
                height: 1, // Line height
              ),
              Row(
                children: [
                  // Left-aligned Text
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, left: 10.0), // Left margin of 10
                    child: Text(
                      '订单编号: CP21938...1239',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 32.sp,
                      ),
                    ),
                  ),

                  // Spacer to push the second text to the right
                  Spacer(),

                  // Right-aligned Text
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 10.0), // Right margin of 10
                    child: Text(
                      '交易时间：2024-10-21 22:00:00',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 32.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ])));
  }

  Widget emptyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 300.h,
        ),
        Image.asset(
          Assets.theme1.images.user.noFundingDataBg.path,
          width: 480.w,
          height: 339.h,
        ),
        SizedBox(
          height: 76.h,
        ),
        Text(
          "暂无任何数据",
          style: TextStyle(fontSize: 36.sp, color: const Color(colorAAAFBB)),
        )
      ],
    );
  }
}
