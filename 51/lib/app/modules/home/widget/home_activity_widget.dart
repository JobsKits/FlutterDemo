import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tiyu_app/api/home_api.dart';
import 'package:flutter_tiyu_app/app/data/app_language_bean.dart';
import 'package:flutter_tiyu_app/app/modules/activity/controllers/activity_detail_controller.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_right_model/activity_pg_list.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/activity_turntable_detail_model/activity_turntable_detail_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/data/lucky_bet_model/lucky_bet_model.dart';
import 'package:flutter_tiyu_app/app/modules/activity/views/activity/activity_list_item_widget.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/activity_float_model/activity_float_model.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/models/activity_float_model/datum.dart';
import 'package:flutter_tiyu_app/app/modules/home/component/reabag_rain_dialog.dart';
import 'package:flutter_tiyu_app/app/modules/home/controllers/new_home_controller.dart';
import 'package:flutter_tiyu_app/app/modules/home/model/activity_redbag_detail_model/activity_redbag_detail_model.dart';
import 'package:flutter_tiyu_app/kernel/utils/app_utils.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/dialog_manager.dart';
import 'package:flutter_tiyu_app/utils/language_util.dart';
import 'package:flutter_tiyu_app/utils/sp_util.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../api/activity_api.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../kernel/network/service.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../../utils/common_color.dart';
import '../../../../utils/login_manager.dart';
import '../../../../utils/public_util.dart';
import '../../../routes/app_pages.dart';
import '../../activity/data/activity_coding_model/activity_coding_model.dart';
import '../component/activity_component_controller.dart';
import '../component/activity_count_timer.dart';
import '../component/models/redbag_rain_detail_model/redbag_rain_detail_model.dart';

//首页活动组件
class HomeActivityWidget extends StatefulWidget {
  ActivityFloatModel? floatModel = ActivityFloatModel();
  HomeActivityWidget({super.key, this.floatModel});

  @override
  State<HomeActivityWidget> createState() => _ChangeLanguageWidgetState();
}

class _ChangeLanguageWidgetState extends State<HomeActivityWidget> {
  NewHomeController homeController = Get.find();
  ActivitysComponentController controller = Get.find();
  late WebViewController webViewController;
  final String _jsChannelName = 'FlutterJSChannel';

  @override
  void initState() {
    super.initState();

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(_jsChannelName,
          onMessageReceived: _handleJavaScriptMessage)
      ..addJavaScriptChannel('RouteChange',
          onMessageReceived: (JavaScriptMessage message) {
        final url = message.message;
        if (!url.contains('/activity/')) {
          Get.back();
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // print('onPageStarted $url');
          },
          onPageFinished: (String url) {
            // print('onPageFinished $url');
            if (url.contains('/activity/')) {
              webViewController.runJavaScript('''
              // 注入 JavaScript 脚本，监听 Vue Router 的变化
              (function() {
                const originalPush = history.pushState;
                history.pushState = function(...args) {
                  originalPush.apply(this, args);
                  window.RouteChange.postMessage(location.href);
                };
                const originalReplace = history.replaceState;
                history.replaceState = function(...args) {
                  originalReplace.apply(this, args);
                  window.RouteChange.postMessage(location.href);
                };
                window.addEventListener('popstate', function() {
                  window.RouteChange.postMessage(location.href);
                });
              })();
              ''');
            }
          },
          onNavigationRequest: (NavigationRequest request) {
            // print('onNavigationRequest: ${request.url}');
            return NavigationDecision.navigate;
          },
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _handleJavaScriptMessage(JavaScriptMessage message) {
    try {
      final data = json.decode(message.message);
      if (data['type'] == 'backToFlutter') {
        Get.back();
      }
    } catch (e) {
      print('Failed to parse message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(bottom: 50.h),
        decoration: BoxDecoration(
            color: context.customTheme?.pageTwoBg,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.r),
                topRight: Radius.circular(40.r))),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      left: 30.w, right: 30.w, top: 30.h, bottom: 30.h),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: context.customTheme?.pageBg,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.r),
                          topRight: Radius.circular(40.r))),
                  child: Text(
                    "${homeController.homeFloatIconName.value}",
                    style: TextStyle(fontSize: 51.sp,
                        color: context.customTheme?.rechargeSecondTypeBgColor),
                  ),
                ),
                Positioned(
                    top: 40.h,
                    right: 54.w,
                    child: CommonRipple(
                      onTap: () {
                        AppManager.instance.tapVibrate();
                        Get.back();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Color(0xffcecece),
                      ),
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 40.w, top: 40.h, right: 40.w),
              alignment: Alignment.centerLeft,
              child: currentLayout(context),
            )
          ],
        ),
      ),
    );
  }

  Widget currentLayout(BuildContext context) {
    Widget layout;
    switch (widget.floatModel?.data?.length) {
      case 1:
      case 2:
        layout = itemLayout4(context);
        break;
      case 3:
        layout = itemLayout3(context);
        break;
      case 4:
        layout = itemLayout2(context);
        break;
      default:
        layout = itemLayout1(context);
        break;
    }
    return layout;
  }

  //大于4个的布局
  Widget itemLayout1(BuildContext context) {
    return SizedBox(
      height: 0.236.sh,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.floatModel?.data?.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.83,
              mainAxisSpacing: 40.w,
              crossAxisSpacing: 40.w),
          itemBuilder: (context, index) {
            var item = widget.floatModel?.data?[index];
            int startime = 0;
            int countdown = 0;
            bool isInProgress = false; // 标记当前时间是否在活动范围内
            if (item?.activity != null &&
                item!.activity!.actionCfg!.isNotEmpty &&
                item.activity?.activityType == '10') {
              String? jsonString = item.activity?.actionCfg;
              Map<String, dynamic> jsonData = json.decode(jsonString ?? '');
              List<dynamic> dispatchTimes = jsonData['dispatchTime'];
              String contactTime = findContactTime(dispatchTimes);
              // 检查当前时间是否在某个时间范围内
              isInProgress = isCurrentTimeInRange(dispatchTimes);
              // 获取时间戳
              countdown = getCustomEndTimestamp(contactTime, isInProgress);

              startime = DateTime.now().millisecondsSinceEpoch;
            }

            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
                clickItem(index);
              },
              child: Stack(
                children: [
                  Container(
                    width: 318.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(28.r)),
                        color: context.customTheme?.pageBg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          item?.picAddr ?? '',
                          width: 220.w,
                          height: 140.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            item?.linkName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 42.sp,
                                color: context.customTheme?.titleColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                      visible: item?.activity?.actionCfg != null &&
                          item?.activity?.activityType == '10',
                      child: Positioned(
                          top: 0,
                          right: 9.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 2.5),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(28.r),
                                    bottomLeft: Radius.circular(28.r))),
                            child: isInProgress
                                ? Text(
                                    '进行中',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                    ),
                                  )
                                : ActivityCountTimer(
                                    startTime: startime,
                                    endTime: countdown,
                                    fontColor: Colors.white,
                                  ),
                          )))
                ],
              ),
            );
          }),
    );
  }

  //等于4个的布局
  Widget itemLayout2(BuildContext context) {
    return SizedBox(
      height: 0.26.sh,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          itemCount: widget.floatModel?.data?.length,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.74,
              mainAxisSpacing: 40.w,
              crossAxisSpacing: 40.w),
          itemBuilder: (context, index) {
            var item = widget.floatModel?.data?[index];
            int startime = 0;
            int countdown = 0;
            bool isInProgress = false; // 标记当前时间是否在活动范围内

            if (item?.activity != null &&
                item!.activity!.actionCfg!.isNotEmpty &&
                item.activity?.activityType == '10') {
              String? jsonString = item.activity?.actionCfg;
              Map<String, dynamic> jsonData = json.decode(jsonString ?? '');
              List<dynamic> dispatchTimes = jsonData['dispatchTime'];
              String contactTime = findContactTime(dispatchTimes);

              // 检查当前时间是否在某个时间范围内
              isInProgress = isCurrentTimeInRange(dispatchTimes);

              // 获取时间戳
              countdown = getCustomEndTimestamp(contactTime, isInProgress);

              print({' ------ ${contactTime}, ${countdown}'});
              startime = DateTime.now().millisecondsSinceEpoch;
            }
            return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
                clickItem(index);
              },
              child: Stack(
                children: [
                  Container(
                    width: 466.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(28.r)),
                        color: context.customTheme?.pageBg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          item?.picAddr ?? '',
                          width: 220.w,
                          height: 140.h,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Text(
                            item?.linkName ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 42.sp,
                                color: context
                                    .customTheme?.rechargeSecondTypeBgColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                      visible: item?.activity?.actionCfg != null &&
                          item?.activity?.activityType == '10',
                      child: Positioned(
                          top: 0,
                          right: 9.w,
                          child: Container(
                            height: 42.h,
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(28.r),
                                    bottomLeft: Radius.circular(28.r))),
                            child: isInProgress
                                ? Text(
                                    '进行中',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30.sp,
                                    ),
                                  )
                                : ActivityCountTimer(
                                    startTime: startime,
                                    endTime: countdown,
                                    fontColor: Colors.white,
                                  ),
                          )))
                ],
              ),
            );
          }),
    );
  }

  //等于3个的布局
  Widget itemLayout3(BuildContext context) {
    return SizedBox(
      height: 267.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(widget.floatModel!.data!.length, (index) {
          var item = widget.floatModel?.data?[index];
          int startime = 0;
          int countdown = 0;
          bool isInProgress = false; // 标记当前时间是否在活动范围内

          if (item?.activity != null &&
              item!.activity!.actionCfg!.isNotEmpty &&
              item.activity?.activityType == '10') {
            String? jsonString = item.activity?.actionCfg;
            Map<String, dynamic> jsonData = json.decode(jsonString ?? '');
            List<dynamic> dispatchTimes = jsonData['dispatchTime'];
            String contactTime = findContactTime(dispatchTimes);

            // 检查当前时间是否在某个时间范围内
            isInProgress = isCurrentTimeInRange(dispatchTimes);

            // 获取时间戳
            countdown = getCustomEndTimestamp(contactTime, isInProgress);

            print({' ------ ${contactTime}, ${countdown}'});

            startime = DateTime.now().millisecondsSinceEpoch;
          }
          return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
                clickItem(index);
              },
              child: Container(
                width: 318.w,
                margin: EdgeInsets.only(
                    right: index == widget.floatModel!.data!.length - 1
                        ? 0
                        : 40.w),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(28.r)),
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            item?.picAddr ?? '',
                            width: 220.w,
                            height: 140.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "${item?.linkName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 42.sp),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible: item?.activity?.actionCfg != null &&
                            item?.activity?.activityType == '10',
                        child: Positioned(
                            top: 0,
                            right: 9.w,
                            child: Container(
                              height: 42.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(28.r),
                                      bottomLeft: Radius.circular(28.r))),
                              child: isInProgress
                                  ? Text(
                                      '进行中',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.sp,
                                      ),
                                    )
                                  : ActivityCountTimer(
                                      startTime: startime,
                                      endTime: countdown,
                                      fontColor: Colors.white,
                                    ),
                            )))
                  ],
                ),
              ));
        }),
      ),
    );
  }

  //等于2个和1个的布局
  Widget itemLayout4(BuildContext context) {
    return SizedBox(
      height: 267.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(widget.floatModel!.data!.length, (index) {
          var item = widget.floatModel?.data?[index];
          int startime = 0;
          int countdown = 0;
          bool isInProgress = false; // 标记当前时间是否在活动范围内

          if (item?.activity != null &&
              item!.activity!.actionCfg!.isNotEmpty &&
              item.activity?.activityType == '10') {
            String? jsonString = item.activity?.actionCfg;
            Map<String, dynamic> jsonData = json.decode(jsonString ?? '');
            List<dynamic> dispatchTimes = jsonData['dispatchTime'];
            String contactTime = findContactTime(dispatchTimes);

            // 检查当前时间是否在某个时间范围内
            isInProgress = isCurrentTimeInRange(dispatchTimes);

            // 获取时间戳
            countdown = getCustomEndTimestamp(contactTime, isInProgress);

            startime = DateTime.now().millisecondsSinceEpoch;
          }
          return CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                Get.back();
                clickItem(index);
              },
              child: Container(
                width: 500.w,
                margin: EdgeInsets.only(
                    right: index == widget.floatModel!.data!.length - 1
                        ? 0
                        : 40.w),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(28.r)),
                          color: Colors.white),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.network(
                            item?.picAddr ?? '',
                            width: 220.w,
                            height: 140.h,
                            fit: BoxFit.contain,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.w),
                            child: Text(
                              "${item?.linkName}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 42.sp),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                        visible: item?.activity?.actionCfg != null &&
                            item?.activity?.activityType == '10',
                        child: Positioned(
                            top: 0,
                            right: 9.w,
                            child: Container(
                              height: 42.h,
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(28.r),
                                      bottomLeft: Radius.circular(28.r))),
                              child: isInProgress
                                  ? Text(
                                      '进行中',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.sp,
                                      ),
                                    )
                                  : ActivityCountTimer(
                                      startTime: startime,
                                      endTime: countdown,
                                      fontColor: Colors.white,
                                    ),
                            )))
                  ],
                ),
              ));
        }),
      ),
    );
  }

  // 判断当前时间是否在某个时间范围内
  bool isCurrentTimeInRange(List<dynamic> dispatchTimes) {
    DateTime now = DateTime.now();

    for (Map<String, dynamic> tim in dispatchTimes) {
      DateTime start = parseTime(tim['startTime']);
      DateTime end = parseTime(tim['endTime']);

      if (start.isAfter(end)) {
        end = end.add(Duration(days: 1)); // 处理跨天时间
      }

      if (now.isAfter(start) && now.isBefore(end)) {
        return true; // 当前时间在某个时间范围内
      }
    }

    return false; // 当前时间不在任何时间范围内
  }

  // 找到距离当前时间最近的 startTime
  String findContactTime(List<dynamic> dispatchTimes) {
    DateTime now = DateTime.now();
    String nearestStartTime = '';
    Duration nearestDuration = Duration(days: 365); // 初始化为一个很大的值

    for (Map<String, dynamic> tim in dispatchTimes) {
      DateTime startTime = parseTime(tim['startTime']);
      Duration difference = startTime.difference(now);

      // 如果 startTime 已经过去（例如当前时间是 03:00，startTime 是 01:00）
      if (difference.isNegative) {
        startTime = startTime.add(Duration(days: 1)); // 将 startTime 调整到第二天
        difference = startTime.difference(now); // 重新计算时间差
      }

      // 找到最小的时间差
      if (difference < nearestDuration) {
        nearestDuration = difference;
        nearestStartTime = tim['startTime'];
      }
    }

    return nearestStartTime; // 返回距离当前时间最近的 startTime
  }

  // 将时间字符串转换为 DateTime 对象
  DateTime parseTime(String time) {
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  // 获取时间戳
  int getCustomEndTimestamp(String timeString, bool isInProgress) {
    final now = DateTime.now();
    final timeParts = timeString.split(':');

    if (timeParts.length > 1) {
      final hours = int.parse(timeParts[0]);
      final minutes = int.parse(timeParts[1]);

      // 创建今天的 DateTime 对象
      DateTime endOfDay =
          DateTime(now.year, now.month, now.day, hours, minutes);

      // 如果当前时间不在范围内，并且当前时间大于 startTime，则调整到明天
      if (!isInProgress && endOfDay.isBefore(now)) {
        endOfDay = endOfDay.add(Duration(days: 1));
      }

      // 返回时间戳
      return endOfDay.millisecondsSinceEpoch;
    } else {
      throw const FormatException(
          'Invalid time format. Expected format is "HH:mm".');
    }
  }

  jumpRedBagDetail(RedbagRainDetailModel item) async {
    if (controller.dispatchTime == '进行中') {
      controller.reqRadbagRainSearch();
    } else {
      final res = await ActivityApi.reqActivityDetails(item.id.toString());
      if (res.type == NetworkService.networkTypeSuccess) {
        final data = ActivityCodingModel.fromJson(res.data);
        Get.toNamed(
          Routes.REDBAG_DETAIL,
          arguments: {
            "model": data.t,
          },
        );
      }
    }
  }

  clickItem(int index) {
    Datum item = widget.floatModel!.data![index];
    if (item.slideshowAddress == '/activity?tab=5' || item.activity?.activityType == '4') {
      if (LoginManager.instance.isLogin.value) {
        homeController.pushToActivity('签到');
      } else {
        showLoginDialog(callback: () {
          homeController.pushToActivity('签到');
        });
      }
      return;
    }
    switch (item.linkType) {
      case 1:
        pushToActivityDetail(index);
        break;
      case 2:
        if (LoginManager.instance.isLogin.value) {
          homeController.pushToActivity('利息宝');
        } else {
          showLoginDialog(callback: () {
            homeController.pushToActivity('利息宝');
          });
        }
        break;
      case 3:
        if (LoginManager.instance.isLogin.value) {
          homeController.pushToActivity('VIP');
        } else {
          showLoginDialog(callback: () {
            homeController.pushToActivity('VIP');
          });
        }
        break;
      case 4:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.AGENT_CENTER);
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.AGENT_CENTER);
          });
        }
        break;
      case 5:
        if (LoginManager.instance.isLogin.value) {
          Get.toNamed(Routes.BOUNS_CENTER);
        } else {
          showLoginDialog(callback: () {
            Get.toNamed(Routes.BOUNS_CENTER);
          });
        }
        break;
      case 6:
        homeController.pushToActivity('任务');
        break;
    }
  }

  Future<void> pushToActivityDetail(int index) async {
    Datum item = widget.floatModel!.data![index];


    switch (item.activity?.activityType) {
      case '1':
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': item.activity?.id.toString(),
          'title': item.activity?.activityName,
          "type": ActivityTypsEnum.recharge,
        });
      case '2':
        final res = await ActivityApi.reqActivityDetails(item.activity!.id.toString());
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.activity?.activityName,
              "type": ActivityTypsEnum.coding,
              "codingModel": data,
            },
          );
        }
      case '3':
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': item.activity?.id.toString(),
          'title': item.activity?.activityName,
          "type": ActivityTypsEnum.none,
        });
      case '4':
        homeController.pushToActivity('签到');
      case '5':
        Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
          'aid': item.activity?.id.toString(),
        });
      case '6':
        Get.toNamed(Routes.WELCOME_BONUS, arguments: {
          'aid': item.activity?.id.toString(),
        });
      case '7':
        final res = await ActivityApi.reqActivityDetails(item.activity!.id.toString());
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.activity?.activityName,
              "type": ActivityTypsEnum.custom,
              "customModel": data,
            },
          );
        }
      case '8':
        // final res = await ActivityApi.reqLuckyActivityDetail(itemData.id.toString());
        // if (res.type == NetworkService.networkTypeSuccess) {
        //   final data = LuckyBetModel.fromJson(res.data);
        //   Get.toNamed(
        //     Routes.ACTIVITY_DETAIL,
        //     arguments: {
        //       "title": itemData.activityName,
        //       "type": ActivityTypsEnum.lucky,
        //       "luckyBetModel": data,
        //       "listItemBean": itemData
        //     },
        //   );
        // }
        final res = await ActivityApi.reqActivityDetails(item.activity!.id.toString());
        if (res.type == NetworkService.networkTypeSuccess &&
            res.data['t'] != null) {
          final data = ActivityTurntableDetailModel.fromJson(res.data['t']);
          Get.toNamed(
            Routes.ACTIVITY_TURNTABLE,
            arguments: {
              "model": data,
            },
          );
        } else {
          EasyLoading.showToast('活动不存在');
        }
      case '9':
        homeController.pushToActivity('任务');
      case '11':
        final res = await ActivityApi.reqActivityDetails(item.activity!.id.toString());
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.activity?.activityName,
              "type": ActivityTypsEnum.presave,
              "presaveModel": data,
            },
          );
        }
      case '12':
        _withAuthJumpToH5Activity(uri: '/activity/newsalary', aid: item.activity?.id.toString());
      case '13':
        final res = await ActivityApi.reqLuckyActivityDetail(item.activity!.id.toString());
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = LuckyBetModel.fromJson(res.data);
          final pgList = ActivityPgList.fromJson(item.activityed);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.activity?.activityName,
              "type": ActivityTypsEnum.lucky,
              "luckyBetModel": data,
              "listItemBean": pgList
            },
          );
        }
        break;
      default:
    }

    String content = item.slideshowAddress ?? '';
    // 空就去掉
    if (content.isEmpty) {
      return;
    }
    if (!content.contains('http')) {
      String? aidValue = getQueryParamValue(content, 'aid');
      String aid = aidValue ?? '';
      print('content:$content, aid:$aid');
      if (content.contains('activity/rank')) {
        _isUserLogin(() {
          // 排行榜
          Get.toNamed(Routes.LEADERBOARD_REWARD, arguments: {
            'aid': aid,
          });
        });
      } else if (content.contains('activity/newcomer')) {
        _isUserLogin(() {
          // 新人彩金
          Get.toNamed(Routes.WELCOME_BONUS, arguments: {
            'aid': aid,
          });
        });
      } else if (content.contains('activity/relayRoulette')) {
        // 助力转盘
        _withAuthJumpToH5Activity(uri: '/activity/relayRoulette', aid: aid);
      } else if (content.contains('activity/newsalary')) {
        // 分享赚现金
        _withAuthJumpToH5Activity(uri: '/activity/newsalary', aid: aid);
      } else if (content.contains('activity/reliefFund')) {
        // 救援金活动
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': aid,
          'title': item.linkName,
          "type": ActivityTypsEnum.none,
        });
      } else if (content.contains('activity/rechargeGift')) {
        // 充值活动
        Get.toNamed(Routes.RELIEF_FUND, arguments: {
          'aid': aid,
          'title': item.linkName,
          "type": ActivityTypsEnum.recharge,
        });
      } else if (content.contains('activity/registerBonus')) {
        String? tasksId = getQueryParamValue(content, 'tasks_id');
        final detail = await HomeApi.getRedbagDetailData(tasksId!);
        final data = ActivityRedbagDetailModel.fromJson(detail.data);
        Get.toNamed(
          Routes.ACTIVITY_DETAIL,
          arguments: {
            "title": item.linkName,
            "itemData": null,
            "isRedbag": true,
            "logRedbagModel": null,
            "redbagDetailModel": data
          },
        );
      } else if (content.contains('activity/lucky-bet')) {
        final res = await ActivityApi.reqLuckyActivityDetail(aid);
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = LuckyBetModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.linkName,
              "type": ActivityTypsEnum.lucky,
              "luckyBetModel": data,
            },
          );
        }
      } else if (content.contains('activity/play')) {
        final res = await ActivityApi.reqActivityDetails(aid);
        if (res.type == NetworkService.networkTypeSuccess) {
          final data = ActivityCodingModel.fromJson(res.data);
          Get.toNamed(
            Routes.ACTIVITY_DETAIL,
            arguments: {
              "title": item.linkName,
              "type": ActivityTypsEnum.coding,
              "codingModel": data,
            },
          );
        }
      } else if (content.contains('activity/redPackets')) {
        if (item.activity != null && item.activity!.actionCfg!.isNotEmpty) {
          String? jsonString = item.activity?.actionCfg;
          Map<String, dynamic> jsonData = json.decode(jsonString ?? '');
          List<dynamic> dispatchTimes = jsonData['dispatchTime'];
          // 检查当前时间是否在某个时间范围内
          bool isInProgress = isCurrentTimeInRange(dispatchTimes);
          if (isInProgress) {
            if (!LoginManager.instance.isLogin.value) {
              showLoginDialog();
              return;
            }
            DialogManager.showDialogWithQueue(
              dialog: RedBagRainStartModal(
                id: item.activity?.id ?? 0,
                onClose: () => {Get.back()},
              ),
            );
            // controller.reqRadbagRainSearch();
          } else {
            final res = await ActivityApi.reqActivityDetails(aid);
            if (res.type == NetworkService.networkTypeSuccess) {
              final data = ActivityCodingModel.fromJson(res.data);
              Get.toNamed(
                Routes.REDBAG_DETAIL,
                arguments: {
                  "model": data.t,
                },
              );
            }
          }
        }
      } else if (content.contains('activity/luckyWheel')) {
        final res = await ActivityApi.reqActivityDetails(aid);
        if (res.type == NetworkService.networkTypeSuccess &&
            res.data['t'] != null) {
          final data = ActivityTurntableDetailModel.fromJson(res.data['t']);
          Get.toNamed(
            Routes.ACTIVITY_TURNTABLE,
            arguments: {
              "model": data,
            },
          );
        } else {
          EasyLoading.showToast('活动不存在');
        }
      } else if (item.linkName == '签到' || content.contains('/activity/?tab=5')) {
        homeController.pushToActivity('签到');
      } else {
        print({'item ======== ${item.toJson()}'});
        EasyLoading.showToast('敬请期待～');
      }
    }
  }

  // 跳转H5活动
  _withAuthJumpToH5Activity({required String uri, String? aid}) {
    _isUserLogin(() {
      _gotoH5Acticity(uri: uri, aid: aid);
    });
  }

  /// 跳转H5活动公用方法
  _gotoH5Acticity({
    required String uri,
    String? aid,
  }) {
    String accessToken = '';
    String custId = '';
    if (LoginManager.instance.loginInfo != null) {
      accessToken = LoginManager.instance.loginInfo!.accessToken ?? '';
      custId = '${LoginManager.instance.loginInfo!.custId}';
    }

    if (accessToken.isNotEmpty && custId.isNotEmpty) {
      String platform = getBetPlatform();
      NetworkService ns = NetworkService();
      String url =
          '${ns.baseURL}${uri}?token=${accessToken}&cust_id=${custId}&platform=${platform}';

      if (aid != null) {
        url = '${url}&aid=${aid}';
      }

      // print('_gotoH5Acticity url: ${url}');
      webViewController.loadRequest(Uri.parse(url));
      Get.toNamed(
        Routes.WEB_PAGE,
        arguments: {
          'webViewController': webViewController,
        },
      );
    }
  }

  String? getQueryParamValue(String url, String param) {
    final uri = Uri.parse(url);
    return uri.queryParameters[param];
  }

  _isUserLogin(VoidCallback callBack) {
    bool isNotLogin = !LoginManager.instance.isLogin.value;

    // 未登录
    if (isNotLogin) {
      showLoginDialog(callback: () {
        callBack();
      });
      return;
    }

    callBack();
  }
}
