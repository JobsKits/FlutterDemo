import 'dart:ui';

import 'package:dartx/dartx_io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_home_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/vip_level_model/vip_level_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/vip/controller/controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/widget/common_receive_button.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/login_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';

class VipHomeView extends StatefulWidget {
  final bool isShowTitle;
  const VipHomeView({super.key, this.isShowTitle = true});

  @override
  State<VipHomeView> createState() => _VipHomeViewState();
}

class _VipHomeViewState extends State<VipHomeView> {
  late Controller controller = Get.put(Controller());
  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: widget.isShowTitle
        ? AppBar(
          backgroundColor: const Color(colorFFFFFF),
          title: Text(
            'VIP',
            style: TextStyle(
              color: Colors.black,
              fontSize: 57.sp,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
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
        ) : null,
      body: Obx(() => RefreshIndicator(
        onRefresh: () async {
          await controller.refreshData();
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider.builder(
                itemCount: controller.vipModel.value.data?.length,
                options: CarouselOptions(
                  enlargeCenterPage: false,
                  viewportFraction: 0.9,
                  autoPlayInterval: const Duration(seconds: 3),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  onPageChanged: (index, reason) {
                    setState(() {
                      controller.currentIndex.value = index;
                    });
                  },
                ),
                itemBuilder: (context, index, realIdx) {
                  final levelData = controller.vipLevels[index];
                  final levelModel = controller.vipModel.value.data?[index];
                  return VipLevelCard(
                    level:levelData['level'],
                    betRequired: levelData['betRequired'],
                    depositRequired: levelData['depositRequired'],
                    color: levelData['color'],
                    path: levelData['imageBg'],
                    data: levelModel!,
                    isActive: index == controller.currentIndex.value,
                    progress: 0.5,
                  );
                },
              ),
              _buildCurrentVipLevel(context),
              if (!controller.currAwardData.isEmpty) ... [
                _buildFunctions(context),
              ],
              _buildQuotas(context),
              _buildDiscounts(context),

              ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.NEW_VIP_DETAIL, arguments: {'models': controller.rebateModels, 'data': controller.vipModel.value});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.theme.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  minimumSize: Size(double.infinity, 80.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                ),
                child: Text(
                  'VIP详情',
                  style: TextStyle(
                    color: context.customTheme?.title2Color,
                    fontSize: 40.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildCurrentVipLevel(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Image.asset(
            Assets.theme1.images.activity.vip.vipBottomArc.path,
            fit: BoxFit.contain,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 左侧文本
                Text(
                  (LoginManager.instance.loginInfo?.custLevel ?? 0) <= 1  ? '' : 'V${LoginManager.instance.loginInfo?.custLevel}',
                  style: TextStyle(
                    color: const Color(0xffD5987D50),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                // 中间文本
                Container(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    '我的等级:V${LoginManager.instance.loginInfo?.custLevel}',
                    style: TextStyle(
                      color: const Color(0xffD5987D),
                      fontSize: 36.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                
                // 右侧文本
                Text(
                  (LoginManager.instance.loginInfo?.custLevel ?? 0) >= 10  ? '' : 'V${(LoginManager.instance.loginInfo?.custLevel ?? 0) + 1}',
                  style: TextStyle(
                    color: const Color(0xffD5987D50),
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctions(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r)),
                  ),
                  width: 10.w,
                  height: 60.h,
                ),
                SizedBox(width: 25.w),
                Text(
                  'VIP特权领取',
                  style: TextStyle(
                    color: context.customTheme?.titleColor,
                    fontSize: 44.sp,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15.h),
          Center(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: controller.currAwardData.length,
              itemBuilder: (context, index) {
                final levelData = controller.currAwardData[index];
                return Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 20).w,
                  decoration: BoxDecoration(
                    color: context.customTheme?.inputBgColor,
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelData.icon,
                      fit: BoxFit.cover,
                      width: 180.w,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${levelData.label}',
                          style: TextStyle(
                            color: context.customTheme?.titleColor,
                            fontSize: 39.sp
                          ),
                        ),
                        Text(
                          levelData.key == '6' ? '¥${levelData.value}（流水倍数{${(controller.vipModel.value.data?[controller.currentIndex.value].exclusiveRedPacketBet ?? 0) / 1000 }}倍）' : '¥${levelData.value}',
                          style: TextStyle(
                            color: context.theme.primaryColor,
                            fontSize: 39.sp
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 240.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60.r),
                        gradient: LinearGradient(
                          colors: !levelData.disabled
                              ? [
                                  Color(0xffFFD69F),
                                  Color(0xffFFD69F)
                                ]
                              : [
                                  Color(0xffFFD69F).withOpacity(0.24),
                                  Color(0xffFFD69F).withOpacity(0.24),
                                ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff191917),
                            offset: Offset(0, 4.w),
                            blurRadius: 4.w,
                            spreadRadius: 3.w,
                          ),
                        ],
                      ),
                      height: 81.h,
                      child: ElevatedButton(
                        onPressed: () {
                          if (levelData.status && !levelData.disabled) {
                            if (levelData.key == '5') {
                              controller.reqCollectionReceive(levelData);
                            } else {
                              controller.reqVIPPrivilegePackageData(levelData);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(60.r),
                          ),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: double.infinity,
                          child: Text(
                            levelData.status ? '立即领取' : '已领取',
                            style: TextStyle(
                              fontSize: 38.sp,
                              color: levelData.disabled ? Color(0xffFFE6C499) : context.customTheme?.title2Color,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      )
    );
  }

  Widget _buildQuotas(BuildContext context) {
    final data = controller.vipModel.value.data?[controller.currentIndex.value];
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35.h, bottom: 30.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r)),
                  ),
                  width: 10.w,
                  height: 60.h,
                ),
                SizedBox(width: 25.w),
                Text(
                  'VIP提款额度',
                  style: TextStyle(
                    color: context.customTheme?.titleColor,
                    fontSize: 44.sp,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          Center(
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
                shrinkWrap: true,
                itemCount: 3,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.25,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: context.customTheme?.pageTwoBg,
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: index == 0 ? '${data?.dailyWithdrawalLimit}' : index == 1 ? '${data?.withdrawFreeCnt}' : index == 2 ? '${data?.withdrawUpperLimit}' : '',
                                  style: TextStyle(
                                    color: Color(0xFFFFD7A1),
                                    fontSize: 75.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: index == 0 ? '次' : index == 1 ? '笔' : index == 2 ? '万/日' : '',
                                  style: TextStyle(
                                    color: Color(0xFFFFD7A1),
                                    fontSize: 42.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // 渐变Container - 高度自适应优化
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r)),
                              gradient: LinearGradient(
                                colors: [const Color(0xFF99805F).withOpacity(0.25), const Color(0xFFFFD7A1).withOpacity(0.35)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                stops: [0.3, 0.9],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF99805F40).withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                index == 0 ? '提款次数提升' : index == 1 ? '免手续费数提升' : index == 2 ? '提款总额度提升' : '',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36.sp,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
          ),
        ]
      )
    );
  }

  Widget _buildDiscounts(BuildContext context) {
    final rebateData = controller.rebateModels[controller.currentIndex.value];
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 26.h, horizontal: 15.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          color: Get.context?.customTheme?.pageTwoBg),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 35.h),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.theme.primaryColor,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(5.r), bottomRight: Radius.circular(5.r)),
                  ),
                  width: 10.w,
                  height: 60.h,
                ),
                SizedBox(width: 25.w),
                Text(
                  'VIP优惠',
                  style: TextStyle(
                    color: context.customTheme?.titleColor,
                    fontSize: 44.sp,
                    fontWeight: FontWeight.bold
                  ),
                )
              ],
            ),
          ),
          Center(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: 8,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    AppManager.instance.tapVibrate();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${indexByTitle(index, rebateData, false)}',
                        style: TextStyle(
                            color: context.theme.primaryColor,
                            fontSize: 54.sp),
                      ),
                      Text(
                        '${indexByTitle(index, rebateData, true)}',
                        style: TextStyle(
                            color: context.customTheme?.titleColor,
                            fontSize: 39.sp),
                      )
                    ],
                  ),
                );
              }),
          ),
        ]
      )
    );
  }

  indexByTitle(int index, VipLevelModel rebateData, bool isTitle) {
    String percentage = '';
    String title = '';
    switch (index) {
      case 0:
        percentage = ((rebateData.hundred0 ?? 0) / 1000).toStringAsFixed(1);
        title = '棋牌';
        break;
      case 1:
        percentage = ((rebateData.hundred1 ?? 0) / 1000).toStringAsFixed(1);
        title = '电子';
        break;
      case 2:
        percentage = ((rebateData.hundred2 ?? 0) / 1000).toStringAsFixed(1);
        title = '捕鱼';
        break;
      case 3:
        percentage = ((rebateData.hundred3 ?? 0) / 1000).toStringAsFixed(1);
        title = '真人';
        break;
      case 4:
        percentage = ((rebateData.hundred4 ?? 0) / 1000).toStringAsFixed(1);
        title = '体育';
        break;
      case 5:
        percentage = ((rebateData.hundred6 ?? 0) / 1000).toStringAsFixed(1);
        title = '彩票';
        break;
      case 6:
        percentage = ((rebateData.hundred7 ?? 0) / 1000).toStringAsFixed(1);
        title = '区块链';
        break;
      case 7:
        percentage = ((rebateData.hundred9 ?? 0) / 1000).toStringAsFixed(1);
        title = '原创';
        break;
      default:
    }
    return isTitle ? title : '${percentage}%';
  }
}


class VipLevelCard extends StatelessWidget {
  final int level;
  final int betRequired;
  final int depositRequired;
  final Color color;
  final bool isActive;
  final double progress;
  final String path;
  final Datum data;

  const VipLevelCard({
    super.key,
    required this.level,
    required this.betRequired,
    required this.depositRequired,
    required this.color,
    required this.isActive,
    required this.progress,
    required this.path,
    required this.data,
  });
  

  @override
  Widget build(BuildContext context) {
    late Controller controller = Get.put(Controller());
    final pro = completionRate(data, controller);
    return AnimatedContainer(
      width: double.infinity,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(path),
          fit: BoxFit.contain,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                if (data.level == 10) ... [
                  Text(
                    '您已达最高等级',
                    style: TextStyle(
                      color: context.customTheme?.titleColor,
                      fontSize: 33.sp,
                    ),
                  ),
                ] else ... [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '需要投注 ',
                          style: TextStyle(
                            color: context.customTheme?.titleColor,
                            fontSize: 33.sp,
                          ),
                        ),
                        TextSpan(
                          text: NumberFormat("#,##0.0").format((((data.valueUpper ?? 0) - (data.valueLower ?? 0)) / 1000)),
                          style: TextStyle(
                            color: color,
                            fontSize: 33.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if ((((data.balanceUpper ?? 0) - (data.balanceLower ?? 0)) / 1000) > 0) ... [
                          TextSpan(
                            text: '，充值 ',
                            style: TextStyle(
                              color: context.customTheme?.titleColor,
                              fontSize: 33.sp,
                            ),
                          ),
                          TextSpan(
                            text: NumberFormat("#,##0.0").format((((data.balanceUpper ?? 0) - (data.balanceLower ?? 0)) / 1000)),
                            style: TextStyle(
                              color: color,
                              fontSize: 33.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                        
                        TextSpan(
                          text: ' 升级至VIP${level+1}',
                          style: TextStyle(
                            color: context.customTheme?.titleColor,
                            fontSize: 33.sp,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ],
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '需要',
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 33.sp,
                        ),
                      ),
                      TextSpan(
                        text: '${(data.relegationBetLower?? 0) / 1000}',
                        style: TextStyle(
                          color: color,
                          fontSize: 33.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '保级流水，',
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 33.sp,
                        ),
                      ),
                      TextSpan(
                        text: '${(data.relegationChargeLower?? 0) / 1000}',
                        style: TextStyle(
                          color: color,
                          fontSize: 33.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '保级充值(1个月)',
                        style: TextStyle(
                          color: context.customTheme?.titleColor,
                          fontSize: 33.sp,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                if ((data.level ?? 0) <= (LoginManager.instance.loginInfo?.custLevel ?? 0)) ... [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    width: 500.w,
                    child: Row(
                      children: [
                        // 进度条容器
                        Expanded(
                          child: Stack(
                            children: [
                              // 进度条背景
                              Container(
                                width: 460.w,
                                height: 10.h,
                                decoration: BoxDecoration(
                                  color: context.customTheme?.pageTwoBg,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              // 进度条前景
                              Container(
                                height: 10.h,
                                width: 460.w * pro,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        // 进度文本（显示在进度条右侧）
                        Text(
                          progress > 0 ? '${pro}%' : '未开始',
                          style: TextStyle(
                            color: progress > 0 ? Colors.white : Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 580.w,
                    child: Text(
                      '当前等级您已完成${NumberFormat("#,##0.0").format((((controller.vipModel.value.t?.planAmount ?? 0) - (data.valueLower ?? 0)) / 1000))}流水，${NumberFormat("#,##0.0").format((((controller.vipModel.value.t?.chargeAmount ?? 0) - (data.balanceLower ?? 0)) / 1000))}充值本月保级已完成 ${(controller.vipModel.value.t?.totalBet ?? 0) / 1000}流水，${(controller.vipModel.value.t?.totalRecharge ?? 0) / 1000}充值',
                      style: TextStyle(
                        color: color,
                        fontSize: 33.sp,
                      ),
                    ),
                  )
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
  double completionRate(Datum data, Controller controller) {
    final diffBetAmount = getAmount(
      bignumberMinus(
        [
          data.valueUpper ?? 0, 
          data.valueLower ?? 0
        ]
      )
    );
    
    final diffDepositsAmount = getAmount(
      bignumberMinus(
        [
          data.balanceUpper ?? 0,
          data.balanceLower ?? 0
        ]
      )
    );

    final placedBetsAmount = controller.bignumberDivide([(controller.vipModel.value.t?.planAmount ?? 0) - (data.valueLower ?? 0), 1000]);

    final maxPlacedBetsAmount = placedBetsAmount > diffBetAmount 
        ? diffBetAmount 
        : placedBetsAmount;
    
    final placedDepositsAmount = controller.bignumberDivide([(controller.vipModel.value.t?.chargeAmount ?? 0) - (data.balanceLower ?? 0), 1000]);
    final maxPlacedDepositsAmount = placedDepositsAmount > diffDepositsAmount 
        ? diffDepositsAmount 
        : placedDepositsAmount;
    print({'maxPlacedBetsAmount =======. $maxPlacedBetsAmount'});
    print({'maxPlacedDepositsAmount =======. $maxPlacedDepositsAmount'});
    if (diffBetAmount + diffDepositsAmount > 0) {
      final percentage = controller.bignumberDivide(
        [
          (maxPlacedBetsAmount + maxPlacedDepositsAmount).toInt(),
          diffBetAmount + diffDepositsAmount
        ]
      ) * 100;
      
      return bignumberToFormat(percentage).toDouble();
    } else {
      return 0;
    }
  }

  // 带空安全处理的版本
  int getAmount(num? amount) {
    if (amount == null) return 0;
    return (amount / 1000).ceil();
  }

  /// 大数字减法运算（支持多个参数）
  double bignumberMinus(List<int> args) {
    if (args.isEmpty) return 0;
    if (args.length == 1) return args[0].toDouble();
    
    return args.sublist(1).fold<double>(
      args[0].toDouble(),
      (previousValue, element) => previousValue - element.toDouble()
    );
  }

  /// 数字格式化，支持指定精度
  String bignumberToFormat(dynamic num, {int precision = 2}) {
    try {
      if (num is String) {
        final parsed = double.tryParse(num) ?? 0;
        return parsed.toStringAsFixed(precision);
      } else if (num is int || num is double) {
        return num.toDouble().toStringAsFixed(precision);
      } else {
        return 0.0.toStringAsFixed(precision);
      }
    } catch (e) {
      return '0.${'0' * precision}';
    }
  }
}
