import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:get/get.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';

import '../../../../../utils/CommonRipple.dart';
import '../../controllers/controller_yuebao_page.dart';
import 'yuebao_buy_plan_dialog.dart';

class YuebaoPageDetail extends StatefulWidget {
  const YuebaoPageDetail({super.key});

  @override
  State<YuebaoPageDetail> createState() => _YuebaoPageDetailState();
}

class _YuebaoPageDetailState extends State<YuebaoPageDetail> {
  final ControllerYuebaoPage controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(colorF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(colorFFFFFF),
        title: Text(
          '产品详情',
          style: TextStyle(
            color: Colors.black,
            fontSize: 57.sp,
          ),
        ),
        centerTitle: true,
        leading: CommonRipple(
          onTap: () {
            AppManager.instance.tapVibrate();
            Get.back();
          },
          child: SizedBox(
            width: 54.w,
            height: 54.h,
            child: Center(
              child: SvgPicture.asset(
                Assets.theme1.images.common.iconBack,
                width: 34.w,
                height: 54.h,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(),
      // body: Obx(() => _buildBody()),
      bottomNavigationBar: Obx(() => _buildButton()),
    );
  }

  Widget _buildBody() {
    if (controller.detailData.value.plan_name == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(80.w, 50.w, 80.w, 100.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.detailData.value.plan_name ?? '',
                style: TextStyle(
                  fontSize: 45.sp,
                  color: const Color(color3A373A),
                ),
              ),
              SizedBox(height: 80.h),
              _buildCenterImg(),
              SizedBox(height: 80.h),
              _buildDetailBox(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCenterImg() {
    return Center(
      child: Container(
        constraints: BoxConstraints(minWidth: 550.w, maxWidth: 720.w),
        height: 720.h,
        color: const Color(colorD9D9D9),
        child: Image.network(
          controller.detailData.value.cover_url ?? '',
          errorBuilder: (context, error, stackTrace) => Image.asset(
            Assets.theme1.images.activity.imgEmpty.path,
            fit: BoxFit.fitHeight, // 根据需要调整 fit 属性
          ),
          fit: BoxFit.fitHeight,
        ),
        // child: NetworkImageWithFallback(
        //   imageUrl: controller.detailData.value.cover_url!,
        //   fallbackAsset: Assets.theme1.images.activity.imgEmpty.path,
        //   fit: BoxFit.fill,
        // ),
      ),
    );
  }

  Widget _buildTitle(String title, {Color? color}) {
    if (color == null) {
      return Text(
        title,
        style: TextStyle(color: const Color(color868686), fontSize: 40.sp),
      );
    }

    return Text(
      title,
      style:
          TextStyle(color: color, fontSize: 45.sp, fontWeight: FontWeight.w500),
    );
  }

  Widget _buildDetailBox() {
    var dataItem = controller.detailData.value;
    num rate = double.tryParse('${(dataItem.daily_rate ?? 0) / 100}') ?? 0.00;
    return Container(
      // constraints: BoxConstraints(minHeight: 394.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(colorFFFFFF),
        borderRadius: BorderRadius.circular(30.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 80.w, vertical: 50.h),
      child: controller.pageMode.value == JumpToPageMode.fixed
          ? Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('利率'),
                          SizedBox(height: 20.h),
                          _buildTitle('${rate.truncateToFixed(2)}%',
                              color: const Color(colorD73F4C)),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitle('产品周期'),
                          SizedBox(height: 20.h),
                          _buildTitle(
                              '${int.parse('${dataItem.product_cycle ?? 0}')}天',
                              color: const Color(color5077CF)),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle('利率'),
                SizedBox(height: 20.h),
                _buildTitle('${rate.truncateToFixed(2)}%',
                    color: const Color(colorD73F4C)),
              ],
            ),
    );
  }

  Widget _buildButton() {
    if (controller.detailData.value.state != 0) {
      return const SizedBox();
    }
    String title = '';
    if (controller.pageMode.value == JumpToPageMode.fixed) {
      title = '购买';
    } else if (controller.pageMode.value == JumpToPageMode.live) {
      title = '转入';
    } else if (controller.pageMode.value == JumpToPageMode.hasBuy) {
      title = '赎回';
    }

    return Container(
      color: const Color(colorFFFFFF),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.fromLTRB(50.w, 30.h, 50.h, 80.h),
      child: CommonReceiveButton(
        title: title,
        margin: EdgeInsets.only(top: 30.w),
        // onTap: () => controller.handleDetailBtn(),
        loading: controller.isDetailBtnLoading.value,
        onTap: () {
          // 固定模式
          if (controller.pageMode.value == JumpToPageMode.fixed) {
            Get.dialog(
              const YuebaoBuyPlanDialog(
                isFixed: true,
              ),
              barrierDismissible: false,
            );
          } else if (controller.pageMode.value == JumpToPageMode.live) {
            Get.dialog(
              const YuebaoBuyPlanDialog(
                isFixed: false,
              ),
              barrierDismissible: false,
            );
          } else {
            //
          }
        },
      ),
    );
  }
}
