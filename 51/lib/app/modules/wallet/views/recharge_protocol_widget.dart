import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/controllers/recharge_controller.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/data/recharge_type_bean.dart';
import 'package:flutter_tiyu_app/app/modules/wallet/widget/recharge_module_title_widget.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/clipboard_util.dart';
import '../../login/views/login_input_widget.dart';
import '../controllers/recharge_online_controller.dart';
import '../widget/dashed_border_container_widget.dart';
import '../widget/recharge_rich_title_widget.dart';

/// 充值协议 选择渠道
// ignore: must_be_immutable
class RechargeProtocolWidget extends StatelessWidget {
  RechargeProtocolWidget({super.key});

  late RechargeController controller = Get.find();
  late RechargeOnlineController onLineController = Get.find();

  @override
  Widget build(BuildContext context) {
    Widget emptyWidget = const SizedBox();

    return Obx(() {
      // 使用 Obx 来自动重建整切片
      if (controller.currentRechargeMarkType.value ==
          RechargeMarkType.offline) {
        return controller.offLineProtocolList.isEmpty
            ? emptyWidget
            : _buildProtocolWidget(context);
      } else {
        return controller.merchatProtocolList.isEmpty
            ? emptyWidget
            : _buildProtocolWidget(context);
      }
    });
  }

  /// 构建协议
  Widget _buildProtocolWidget(BuildContext context) {
    bool isOffLine =
        controller.currentRechargeMarkType.value == RechargeMarkType.offline;
    int length = isOffLine
        ? controller.offLineProtocolList.length
        : controller.merchatProtocolList.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RechargeModuleTitleWidget(
          str: "选择渠道",
          fontSize: 45.sp,
        ),
        SizedBox(
          height: 27.h,
        ),
        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16.h,
            mainAxisSpacing: 16.w,
            childAspectRatio: 2.77,
          ),
          itemBuilder: (context, index) {
            if (controller.tabList[controller.currentTabIndex.value].data?[0]
                    .payOrgId ==
                187) {
              return digitalCurrencyItemStyle(context, index);
            } else {
              return defaultItemStyle(context, isOffLine, index);
            }
          },
        ),
        if (controller.currentRechargeType.mark == RechargeMarkType.online)
          Obx(() {
            return controller.merchatProtocolList.isNotEmpty
                ? (controller
                            .merchatProtocolList[
                                controller.currentSelectProtocalIndex.value]
                            .isEmbed ==
                        "1"
                    ? _buildWalletInfoWidget(context)
                    : const SizedBox.shrink())
                : const SizedBox.shrink();
          }),
      ],
    );
  }

  ///数字钱包的样式
  Widget digitalCurrencyItemStyle(BuildContext context, index) {
    return Obx(() {
      bool selected = controller.currentSelectProtocalIndex.value == index;
      String baseName = controller
          .showRechargeTypeList[controller.currentRechargeTypeIndex.value]
          .name!;
      String? iconUrl;
      String? mainName = '';
      String? subName = '';
      String maxPercentage = '';
      bool isRecommend =
          controller.merchatProtocolList[index].isRecommend ?? false;
      iconUrl = controller.merchatProtocolList[index].iconUrl ?? "";
      String name1 =
          controller.merchatProtocolList[index].channelCustomName ?? '';
      String name2 =
          controller.merchatProtocolList[index].channelCustomName2 ?? '';
      String sourcetypeName =
          controller.merchatProtocolList[index].sourcetypeName ?? '';
      maxPercentage = controller.merchatProtocolList[index].maxPercentage ?? '';
      // 有其中一个
      if (name1 != '' || name2 != '') {
        mainName = name1;
        subName = name2;
      } else {
        mainName =
            sourcetypeName == '' ? '${baseName}${index + 1}' : sourcetypeName;
      }
      return Stack(clipBehavior: Clip.none, children: [
        CommonRipple(
          onTap: () {
            if (controller.currentSelectProtocalIndex.value != index) {
              AppManager.instance.tapVibrate();
            }
            controller.changeCurrentSelectProtocalIndex(index);
          },
          child: Container(
            height: 119.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? context.customTheme?.rechargeMoneyTypeColor
                  : context.customTheme?.pageBg,
              borderRadius: BorderRadius.circular(27.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isRecommend
                    ? Image.asset(
                        Assets
                            .theme1.images.recharge.iconRechargeRecommend.path,
                        width: 46.w,
                        height: 46.h,
                      )
                    : CircleAvatar(
                        radius: 32.w,
                        child: Image.asset(
                          controller.getRechargeTypeIcon(
                            payOrgId: controller
                                    .merchatProtocolList[index].payOrgId ??
                                0,
                          ),
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              Assets.theme1.images.home.errorImg.path,
                              fit: BoxFit.cover, // 根据需要调整 fit 属性
                            );
                          },
                        ),
                      ),
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.only(left: 10.w),
                        child: FittedBox(
                          fit: BoxFit.scaleDown, // 自动缩小以适配宽度
                          child: Text(
                            textAlign: TextAlign.center,
                            // "${controller.merchatProtocolList[index].channelCustomName}",
                            "${mainName}",
                            maxLines: 1,
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : context
                                      .customTheme?.rechargeSecondTypeBgColor,
                              fontSize: 41.sp,
                              height: 1.2,
                            ),
                          ),
                        ))),
                if (isRecommend)
                  Image.asset(
                    Assets.theme1.images.recharge.iconRechargeRecommend.path,
                    width: 46.w,
                    height: 46.h,
                  )
              ],
            ),
          ),
        ),
        Obx(() {
          if (controller.isShowDiscount.value &&
              maxPercentage != '' &&
              maxPercentage != '0') {
            return Positioned(
              top: -30.h,
              right: -10.w,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 340.w, // 最大宽度限制
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(colorF70054), // 标签背景颜色
                  borderRadius: BorderRadius.circular(36.r), // 圆角
                ),
                child: Text(
                  '送${maxPercentage}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          return const SizedBox();
        })
      ]);
    });
  }

  Widget defaultItemStyle(BuildContext context, isOffLine, index) {
    return Obx(() {
      bool selected = controller.currentSelectProtocalIndex.value == index;
      String baseName = controller
          .showRechargeTypeList[controller.currentRechargeTypeIndex.value]
          .name!;

      String? iconUrl;
      String? mainName = '';
      String? subName = '';
      String maxPercentage = '';
      String channel_custom_name2 = '';

      if (isOffLine) {
        iconUrl = controller.offLineProtocolList[index].iconUrl ?? "";

        String name1 =
            controller.offLineProtocolList[index].channelCustomName ?? '';
        String name2 =
            controller.offLineProtocolList[index].channelCustomName2 ?? '';
        String sourcetypeName =
            controller.offLineProtocolList[index].sourcetypeName ?? '';
        maxPercentage =
            controller.offLineProtocolList[index].maxPercentage ?? '';
        channel_custom_name2 =
            controller.offLineProtocolList[index].channelCustomName2 ?? '';
        // 有其中一个
        if (name1 != '' || name2 != '') {
          mainName = name1;
          subName = name2;
        } else {
          mainName =
              sourcetypeName == '' ? '${baseName}${index}' : sourcetypeName;
        }
      } else {
        iconUrl = controller.merchatProtocolList[index].iconUrl ?? "";

        String name1 =
            controller.merchatProtocolList[index].channelCustomName ?? '';
        String name2 =
            controller.merchatProtocolList[index].channelCustomName2 ?? '';
        String sourcetypeName =
            controller.merchatProtocolList[index].sourcetypeName ?? '';
        maxPercentage =
            controller.merchatProtocolList[index].maxPercentage ?? '';
        channel_custom_name2 =
            controller.merchatProtocolList[index].channelCustomName2 ?? '';
        // 有其中一个
        if (name1 != '' || name2 != '') {
          mainName = name1;
          subName = name2;
        } else {
          mainName =
              sourcetypeName == '' ? '${baseName}${index + 1}' : sourcetypeName;
        }
      }

      return Stack(clipBehavior: Clip.none, children: [
        CommonRipple(
          onTap: () {
            if (controller.currentSelectProtocalIndex.value != index) {
              AppManager.instance.tapVibrate();
            }
            controller.changeCurrentSelectProtocalIndex(index);
          },
          child: Container(
            height: 92.h,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? context.customTheme?.rechargeMoneyTypeColor
                  : context.customTheme?.pageBg,
              borderRadius: BorderRadius.circular(27.r),
            ),
            child: _buildProtocolChildWidget(
                mainName: mainName,
                subName: subName,
                selected: selected,
                iconUrl: iconUrl,
                index: index,
                context: context),
          ),
        ),
        Obx(() {
          if (controller.isShowDiscount.value &&
              maxPercentage != '' &&
              maxPercentage != '0') {
            return Positioned(
              top: -30.h,
              right: -10.w,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 340.w, // 最大宽度限制
                ),
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(colorF70054), // 标签背景颜色
                  borderRadius: BorderRadius.circular(36.r), // 圆角
                ),
                child: Text(
                  '送${maxPercentage}%',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }
          return const SizedBox();
        })
      ]);
    });
  }

  Widget _buildWalletInfoWidget(BuildContext context) {
    var item = controller
        .showRechargeTypeList[controller.currentRechargeTypeIndex.value];

    var iconUrl = controller.getRechargeTypeIcon(
      payOrgId: item.payOrgId!,
    );
    if (item.iconUrl != null &&
        item.iconUrl != "null" &&
        item.iconUrl!.isNotEmpty) {
      iconUrl = item.iconUrl!;
    }
    bool isNetWork = iconUrl.contains("http");
    return Obx(() => controller.isLoadingWalletInfo.value
        ? Center(
            child: SizedBox(
              width: 100.w,
              height: 100.h,
              child: LoadingIndicator(
                indicatorType: Indicator.ballSpinFadeLoader,
                colors: [context.theme.primaryColor],
              ),
            ),
          )
        : (controller.isBindWallet.value
            ? Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 60.w,
                        child: isNetWork
                            ? Image.network(
                                iconUrl,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    Assets.theme1.images.home.errorImg.path,
                                    fit: BoxFit.cover, // 根据需要调整 fit 属性
                                  );
                                },
                              )
                            : Image.asset(
                                controller.getRechargeTypeIcon(
                                  payOrgId: controller
                                      .showRechargeTypeList[controller
                                          .currentRechargeTypeIndex.value]
                                      .payOrgId!,
                                ),
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    Assets.theme1.images.home.errorImg.path,
                                    fit: BoxFit.cover, // 根据需要调整 fit 属性
                                  );
                                },
                              ),
                      ),
                      SizedBox(
                        width: 25.w,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${controller.currentRechargeType.name}",
                              style: TextStyle(
                                  fontSize: 45.sp,
                                  fontWeight: FontWeight.bold)),
                          Row(
                            children: [
                              Text(
                                "￥${((controller.walletBean.value?.walletBalance ?? 0) / 1000).truncateToFixed(2)}",
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 12.sp,
                              ),
                              CommonRipple(
                                onTap: () {
                                  AppManager.instance.tapVibrate();
                                  controller.reqUserInfo(isRefresh: true);
                                },
                                child: SvgPicture.asset(
                                  Assets.theme1.images.user.iconRefresh,
                                  width: 45.w,
                                  height: 45.h,
                                ),
                              )
                            ],
                          )
                        ],
                      )),
                      CommonRipple(
                        onTap: () async {
                          AppManager.instance.tapVibrate();
                          String jumpUrl = await controller.getJumpUrl() ?? "";
                          if (jumpUrl.isEmpty) return;
                          final Uri url = Uri.parse(jumpUrl);
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 267.w,
                          height: 87.h,
                          decoration: BoxDecoration(
                              color: const Color(theme01MainColor),
                              borderRadius: BorderRadius.circular(12.r)),
                          child: Text(
                            "购买余额",
                            style:
                                TextStyle(fontSize: 43.sp, color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      Text(
                          "钱包地址: ${controller.walletBean.value?.walletAddress ?? ''}"),
                      SizedBox(
                        width: 10.w,
                      ),
                      CommonRipple(
                        onTap: () {
                          ClipboardUtil.copy(
                              controller.walletBean.value?.walletAddress);
                        },
                        child: SvgPicture.asset(
                          Assets.theme1.images.user.iconCopy,
                          width: 40.w,
                          height: 40.h,
                          colorFilter: const ColorFilter.mode(
                              Color(theme01MainColor), BlendMode.srcIn),
                        ),
                      )
                    ],
                  )
                ],
              )
            : controller.currentRechargePayOrgId.value ==
                    308 //nopay才显示nopay的绑定方式
                ? noPayView()
                : _buildThirdUnBindWidget()));
    // : noPayView()));
  }

//no钱包内嵌的组件
  Widget noPayView() {
    return noPayNotBindView();
  }

  //no钱包内嵌未绑定的组件
  Widget noPayNotBindView() {
    return Container(
      margin: EdgeInsets.only(top: 40.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Column(
            children: [
              Text("已有账号，可立即绑定", style: TextStyle(fontSize: 34.sp)),
              CommonRipple(
                  onTap: () async {
                    String? registerUrl =
                        await controller.reqNoPayRegisterUrl(true);
                    if (registerUrl != null && registerUrl.isNotEmpty) {
                      final Uri url = Uri.parse(registerUrl);
                      await launchUrl(url,
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Color(theme01MainColor),
                    ),
                    child: const Text(
                      "立即绑定",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
            ],
          )),
          SizedBox(
            width: 40.w,
          ),
          Expanded(
              child: Column(
            children: [
              Text(
                "首次使用？只需设置支付密码",
                style: TextStyle(fontSize: 34.sp),
              ),
              CommonRipple(
                  onTap: () async {
                    showTipsDialog();
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    alignment: Alignment.center,
                    height: 80.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: const Color(theme01MainColor),
                    ),
                    child: const Text("立即设置",
                        style: TextStyle(color: Colors.white)),
                  )),
            ],
          ))
        ],
      ),
    );
  }

  showTipsDialog() {
    Get.dialog(
        Dialog(
          insetPadding: EdgeInsets.zero,
          child: IntrinsicHeight(
            child: Container(
              width: 0.7.sw,
              padding: EdgeInsets.all(20.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        "重要提醒",
                        style: TextStyle(
                            fontSize: 50.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Text("是否确定要新创建一个NO钱包账号?",
                          style: TextStyle(fontSize: 40.sp)),
                      SizedBox(
                        height: 80.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: CommonRipple(
                            onTap: () async {
                              Get.back();
                              String? registerUrl =
                                  await controller.reqNoPayRegisterUrl(true);
                              if (registerUrl != null &&
                                  registerUrl.isNotEmpty) {
                                final Uri url = Uri.parse(registerUrl);
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                EasyLoading.showError("地址为空，请刷新界面重试!");
                              }
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 100.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.r),
                                    border: Border.all(
                                        color: Color((theme01MainColor)))),
                                child: const Text(
                                  "已有nopay钱包",
                                  style:
                                      TextStyle(color: Color(theme01MainColor)),
                                )),
                          )),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                              child: CommonRipple(
                            onTap: () async {
                              Get.back();
                              String? registerUrl =
                                  await controller.reqNoPayRegisterUrl(false);
                              if (registerUrl != null &&
                                  registerUrl.isNotEmpty) {
                                final Uri url = Uri.parse(registerUrl);
                                await launchUrl(url,
                                    mode: LaunchMode.externalApplication);
                              } else {
                                String? registerUrl =
                                    await controller.getJumpUrl();
                                if (registerUrl != null &&
                                    registerUrl.isNotEmpty) {
                                  final Uri url = Uri.parse(registerUrl);
                                  await launchUrl(url,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  EasyLoading.showError("地址为空，请刷新界面重试!");
                                }
                              }
                            },
                            child: Container(
                              height: 100.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Color((theme01MainColor))),
                              child: const Text(
                                "确认",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )),
                          SizedBox(
                            height: 100.h,
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: CommonRipple(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(Icons.close),
                      ))
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }

  final Map<String, dynamic> _defaultCountryCode = {
    'name': '中国',
    'code': 'CN',
    'dial_code': '+86',
  };
  late Rx<CountryCode> countryCode =
      CountryCode.fromJson(_defaultCountryCode).obs;
  //三方钱包未绑定的组件
  Widget _buildThirdUnBindWidget() {
    return Column(
      children: thirdUnBindItemWidget(),
    );
  }

  List<Widget> thirdUnBindItemWidget() {
    List<Widget> tempList = [];
    var bindWidgetList = controller.thirdWalletBean.value?.field?.bind ?? [];
    if (bindWidgetList.isNotEmpty) {
      for (var item in bindWidgetList) {
        // controller.thirdParameters['${item.key}'] = '';//把需要校验的参数赋值初始值
        tempList.add(Container(
          margin: EdgeInsets.only(top: 20.h),
          child: RechargeRichTitleWidget(
            str: item.name ?? "",
            fontSize: 45.sp,
            required: true,
          ),
        ));

        switch (item.key) {
          case "3rdSmsCode":
            tempList.add(LoginInputWidget(
                key: const ValueKey(1),
                margin: EdgeInsets.only(top: 20.h),
                borderRadius: 20,
                hint: item.desc ?? "",
                headIconPath: Assets.theme1.images.login.iconInputLeftCode.path,
                loginInputType: LoginInputWidgetType.codeType,
                onChanged: (str) {
                  controller.thirdParameters['${item.key}'] = str;
                  onLineController.isCanSendThirdCodes();
                  onLineController.isCanBinds();
                  print("监听输入");
                },
                onValid: (Function cb) {
                  if (onLineController.isCanSendThirdCode.value) {
                    print("发送验证码");
                    return onLineController.sendThirdCode(cb);
                  } else {
                    Get.snackbar("发送失败!", "请完整填写信息");
                    print("不满足发送要求");
                  }
                }));
            break;
          case "3rdName":
            tempList.add(LoginInputWidget(
                isCanCN: true,
                margin: EdgeInsets.only(top: 20.h),
                borderRadius: 20,
                hint: item.desc ?? "",
                headIconPath: Assets.theme1.images.login.iconInputLeftUser.path,
                loginInputType: LoginInputWidgetType.textInputType,
                onChanged: (str) {
                  controller.thirdParameters['${item.key}'] = str;
                  onLineController.isCanSendThirdCodes();
                  onLineController.isCanBinds();
                }));
            break;
          case "3rdPhone":
            tempList.add(LoginInputWidget(
                margin: EdgeInsets.only(top: 20.h),
                borderRadius: 20,
                hint: item.desc ?? "",
                isNewPhone: false,
                headIconPath:
                    Assets.theme1.images.login.iconInputLeftPhone.path,
                loginInputType: LoginInputWidgetType.phoneInputType,
                countryCode: item.isAreaCode == "1" ? countryCode.value : null,
                onChanged: (str) {
                  controller.thirdParameters['${item.key}'] = str;
                  onLineController.isCanSendThirdCodes();
                  onLineController.isCanBinds();
                }));
            break;
        }
      }
    }
    tempList.add(Container(
      margin: EdgeInsets.only(top: 50.h),
      child: DashedBorderContainerWidget(
        strokeWidth: 3.w,
        color: Colors.black,
        child: CommonRipple(
          onTap: () async {
            AppManager.instance.tapVibrate();
            var bindWidgetList =
                controller.thirdWalletBean.value?.field?.bind ?? [];
            if (bindWidgetList.isNotEmpty) {
              bool allValuesNotNull = false;
              if (controller.thirdParameters.isNotEmpty) {
                allValuesNotNull = controller.thirdParameters.values
                    .every((value) => (value != null && value.isNotEmpty));
              }
              if (allValuesNotNull) {
                String? registerUrl = await controller.reqRegisterUrl();
                if (registerUrl != null && registerUrl.isNotEmpty) {
                  final Uri url = Uri.parse(registerUrl);
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  //绑定成功
                  if (registerUrl != null && registerUrl.isEmpty) {
                    controller.changeCurrentSelectProtocalIndex(
                        controller.currentSelectProtocalIndex.value);
                  }
                }
              } else {
                Get.snackbar("绑定失败!", "请完整填写信息");
              }
            } else {
              String? registerUrl = await controller.reqRegisterUrl();
              if (registerUrl != null && registerUrl.isNotEmpty) {
                final Uri url = Uri.parse(registerUrl);
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                //绑定成功
                if (registerUrl != null && registerUrl.isEmpty) {
                  controller.changeCurrentSelectProtocalIndex(
                      controller.currentSelectProtocalIndex.value);
                }
              }
            }
          },
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            color: Colors.white,
            height: 120.h,
            child: Text(
              "+立即绑定",
              style: TextStyle(fontSize: 45.sp),
            ),
          ),
        ),
      ),
    ));
    return tempList;
  }

  /// 构建协议模块
  Widget _buildProtocolChildWidget({
    required String mainName,
    required String subName,
    required bool selected,
    required String? iconUrl,
    required int index,
    required BuildContext context,
  }) {
    bool isRecommend = false;
    if (controller.currentRechargeMarkType.value == RechargeMarkType.offline) {
      isRecommend = controller.offLineProtocolList[index].isRecommend ?? false;
    } else {
      isRecommend = controller.merchatProtocolList[index].isRecommend ?? false;
    }
    return Row(
      children: [
        isRecommend
            ? Image.asset(
                Assets.theme1.images.recharge.iconRechargeRecommend.path,
                width: 46.w,
                height: 46.h,
              )
            : (iconUrl != ''
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: _buildProtocolChildIcon(iconUrl!),
                    ),
                  )
                : const SizedBox()),
        Expanded(
          child: Center(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: subName != ''
                    ? [
                        TextSpan(
                          text: (mainName.isEmpty) ? subName : mainName,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : context
                                    .customTheme?.rechargeSecondTypeBgColor,
                            fontSize: 41.sp,
                          ),
                        ),
                        // const TextSpan(text: '\n'), // 换行
                        // TextSpan(
                        //   text: subName,
                        //   style: TextStyle(
                        //     color: selected ? Colors.white : Colors.black,
                        //     fontSize: 41.sp,
                        //   ),
                        // ),
                      ]
                    : [
                        TextSpan(
                          text: mainName,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : context
                                    .customTheme?.rechargeSecondTypeBgColor,
                            fontSize: 41.sp,
                          ),
                        ),
                      ],
              ),
            ),
          ),
        ),
        if (isRecommend)
          Image.asset(
            Assets.theme1.images.recharge.iconRechargeRecommend.path,
            width: 46.w,
            height: 46.h,
          )
      ],
    );
  }

  /// 构建协议icon
  Widget _buildProtocolChildIcon(String iconUrl) {
    return CachedNetworkImage(
      imageUrl: iconUrl,
      imageBuilder: (context, imageProvider) => Container(
        width: 46.w,
        height: 46.h,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill, // 可以根据需要调整 fit 属性
          ),
        ),
      ),
      errorWidget: (context, url, error) => SvgPicture.asset(
        Assets.theme1.images.recharge.iconHot,
        width: 46.w,
        height: 46.h,
      ),
    );
  }
}
