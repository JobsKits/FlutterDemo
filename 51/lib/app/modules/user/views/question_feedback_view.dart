import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/extensions/AnyExtensions/onNum.dart';
import 'package:flutter_tiyu_app/extensions/WidgetExtensions/onGestures.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/theme/theme.service.dart';
import 'package:flutter_tiyu_app/app/modules/user/data/feedback_list_model/feedback_list_model.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/clipboard_util.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:flutter_tiyu_app/utils/date_time_utils.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../../gen/assets.gen.dart';
import '../../../../utils/CommonRipple.dart';
import '../../../routes/app_pages.dart';
import '../controllers/question_feedback_controller.dart';
import 'my_message_detail_view.dart';

///问题反馈、站内信
class QuestionFeedbackView extends GetView<QuestionFeedbackController> {
  const QuestionFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customTheme?.pageBg,
      appBar: AppBar(
        backgroundColor: context.customTheme?.navbarBg,
        leading: BackButton(
          color: context.customTheme?.titleColor,
          onPressed: () {
            Get.back();
          },
        ),
        title: Text("消息通知",
            style: TextStyle(color: context.customTheme?.titleColor)),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 30.w),
            child: CommonRipple(
              onTap: () {
                AppManager.instance.tapVibrate();
                controller.clickReadingAll();
              },
              child: Text("一键已读",
                  style: TextStyle(color: context.customTheme?.titleColor)),
            ),
          )
        ],
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 36.h),
      child: Column(
        children: [
          _buildTabBar(context),
          Expanded(child: Obx(() => _buildContent(context)))
        ],
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Row(
      children: List.generate(controller.tabList.length, (index) {
        return Expanded(
            child: Obx(() => CommonRipple(
                  onTap: () {
                    if (controller.currentTabIndex.value != index) {
                      AppManager.instance.tapVibrate();
                    }
                    controller.changeTabIndex(index);
                  },
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 90.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: controller.currentTabIndex.value == index
                                ? context.theme.primaryColor
                                : context.customTheme?.pageTwoBg,
                            borderRadius: BorderRadius.circular(20.r)),
                        margin: EdgeInsets.only(
                            left: index == 0 ? 36.w : 18.w,
                            right: index == controller.tabList.length - 1
                                ? 36.w
                                : 18.w),
                        child: Text(
                          controller.tabList[index],
                          style: TextStyle(
                              fontSize: 36.sp,
                              color: controller.currentTabIndex.value == index
                                  ? Colors.white
                                  : const Color(colorC6C8CF)),
                        ),
                      ),
                      Obx(() => controller.showUnReadDot(index) > 0
                          ? Positioned(
                              top: -10.h,
                              right: 30.w,
                              child: Container(
                                width: 42.w,
                                height: 42.h,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(21.r)),
                                child: Text(
                                  "${controller.showUnReadDot(index)}",
                                  style: TextStyle(
                                      fontSize: 32.sp, color: Colors.white),
                                ),
                              ))
                          : SizedBox())
                    ],
                  ),
                )));
      }),
    );
  }

  Widget _buildContent(BuildContext context) {
    Widget widget;
    switch (controller.currentTabIndex.value) {
      case 1:
        widget = _buildSystem();
        break;
      case 2:
        widget = _buildMarquee();
        break;
      case 3:
        widget = _FeedbackBuildBody(context);
        break;
      case 4:
        widget = _buildMyMsg();
        break;
      default:
        widget = _buildInbox();
        break;
    }
    return widget;
  }

  //收件箱
  Widget _buildInbox() {
    return Obx(() => controller.inboxList.isNotEmpty
        ? ListView.builder(
            itemCount: controller.inboxList.length,
            shrinkWrap: true,
            // padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  Get.toNamed(Routes.INBOX_DETAIL, arguments: {
                    "mail_id": controller.inboxList[index].mailId, //请求地址
                    "send_cust_name":
                        controller.inboxList[index].sendCustName, //发件人
                    "put_cust_name":
                        controller.inboxList[index].putCustName, //用户
                    "title": controller.inboxList[index].theme, //是否显示titled
                    "content": controller.inboxList[index].content, //顶部置顶的内容
                    "sendTime": controller.inboxList[index].sendTime, //消息发送时间
                    "is_reply": controller.inboxList[index].isReply //消息发送时间
                  })?.then((_) {
                    controller.reqInboxMsg();
                  });
                },
                child: Container(
                  height: 205.h,
                  padding: EdgeInsets.symmetric(horizontal: 42.w),
                  margin: EdgeInsets.only(top: 30.h, left: 36.w, right: 36.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: context.customTheme?.pageTwoBg),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60.w,
                            child: Image.asset(
                              controller.inboxList[index].type == 0 ||
                                      controller.inboxList[index].type == 4
                                  ? ThemeService.to.currentTheme.value?.model == 'blackGold'
                                    ? Assets.theme1.images.user.iconMsgEmailBlackGold.path
                                    : Assets.theme1.images.user.iconMsgEmail.path
                                  : Assets.theme1.images.user.iconMsgEmailO.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 35.w,
                          ),
                          Expanded(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                controller.inboxList[index].theme ?? '',
                                style: TextStyle(
                                    color: context.customTheme?.titleColor,
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                DateTimeUtils.formatTimestamp(controller.inboxList[index].sendTime!),
                                style: TextStyle(
                                    color: context.customTheme?.title2Color,
                                    fontSize: 40.sp),
                              ),
                            ],
                          )),
                          CommonRipple(
                              onTap: () {
                                AppManager.instance.tapVibrate();
                                controller.deleteInboxMsg(index);
                              },
                              child: SvgPicture.asset(
                                Assets.theme1.images.user.iconDelete,
                                width: 54.w,
                                height: 54.h,
                              )),
                        ],
                      ),
                      Positioned(
                          top: 20.h,
                          right: -20.w,
                          child: controller.inboxList[index].type == 0 ||
                                  controller.inboxList[index].type == 4
                              ? Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ))
                              : const SizedBox())
                    ],
                  ),
                ),
              );
            })
        : _buildEmptyView());
  }

  String decodeSafely(String input) {
    try {
      return Uri.decodeComponent(input);
    } catch (e) {
      return input; // 返回原字符串或默认值
    }
  }

  Widget _buildEmptyView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 200.h),
        Image.asset(
          Assets.theme1.images.common.noDataBg.path,
          width: 336.w,
          height: 336.h,
        ),
      ],
    );
  }

  //系统公告
  Widget _buildSystem() {
    return Obx(() => controller.systemList.isNotEmpty
        ? ListView.builder(
            itemCount: controller.systemList.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  if (controller.systemList[index].content!.isNotEmpty) {
                    // Get.toNamed(Routes.WEB_VIEW, arguments: {
                    //   "url": controller.systemList[index].content ?? "", //请求地址
                    //   "isShowTitle": true, //是否显示title
                    //   "isShowRecharge": false,
                    //   "isChangeHtmlFontSize": false,
                    //   "title": controller.systemList[index].title
                    // });
                    Get.toNamed(Routes.SYSTEM_NOTIFY_DETAIL, arguments: {
                      "url": controller.systemList[index].content ?? "", //请求地址
                      "isChangeHtmlFontSize": true,
                      "time":
                          DateTimeUtils.formatTimestamp(controller.systemList[index].createTime!),
                      "title": controller.systemList[index].title
                    });
                  } else {
                    Get.snackbar("打开失败", "内容为空");
                  }
                },
                child: Container(
                  height: 205.h,
                  padding: EdgeInsets.all(42.w),
                  margin: EdgeInsets.only(top: 30.h, left: 36.w, right: 36.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: context.customTheme?.pageTwoBg),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60.w,
                            child: Image.asset(
                              ThemeService.to.currentTheme.value?.model ==
                                      'blackGold'
                                  ? Assets.theme1.images.user
                                      .iconMsgNotifyBlackGold.path
                                  : Assets
                                      .theme1.images.user.iconMsgNotify.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 35.w,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${controller.systemList[index].title}",
                                  style: TextStyle(
                                      color: context.customTheme?.titleColor)),
                              Text(
                                  DateTimeUtils.formatTimestamp(controller.systemList[index].createTime!),
                                  style: TextStyle(
                                      color: context.customTheme?.title2Color)),
                            ],
                          )),
                          // SvgPicture.asset(
                          //   Assets.theme1.images.user.iconDelete,
                          //   width: 54.w,
                          //   height: 54.h,
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
        : _buildEmptyView());
  }

  //系统公告
  Widget _buildMarquee() {
    return Obx(() => controller.notices.value.data!.isNotEmpty
        ? ListView.builder(
            itemCount: controller.notices.value.data!.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  if (controller
                      .notices.value.data![index].content!.isNotEmpty) {
                    Get.toNamed(Routes.SYSTEM_NOTIFY_DETAIL, arguments: {
                      "url": controller.notices.value.data![index].content ??
                          "", //请求地址
                      "isChangeHtmlFontSize": true,
                      "time":
                          DateTimeUtils.formatTimestamp(controller.notices.value.data![index].createTime!),
                      "title": controller.notices.value.data![index].title
                    });
                  } else {
                    Get.snackbar("打开失败", "内容为空");
                  }
                },
                child: Container(
                  height: 205.h,
                  padding: EdgeInsets.all(42.w),
                  margin: EdgeInsets.only(top: 30.h, left: 36.w, right: 36.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: context.customTheme?.pageTwoBg),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60.w,
                            child: Image.asset(
                              ThemeService.to.currentTheme.value?.model ==
                                      'blackGold'
                                  ? Assets.theme1.images.user
                                      .iconMsgNotifyBlackGold.path
                                  : Assets
                                      .theme1.images.user.iconMsgNotify.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 35.w,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${controller.notices.value.data?[index].title}",
                                  style: TextStyle(
                                      color: context.customTheme?.titleColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500)),
                              Text(
                                  DateTimeUtils.formatTimestamp(controller.notices.value.data![index].createTime!),
                                  style: TextStyle(
                                      color: context.customTheme?.title2Color)),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            })
        : _buildEmptyView());
  }

  //我的消息
  Widget _buildMyMsg() {
    return Obx(() => controller.myMsgList.isNotEmpty
        ? ListView.builder(
            itemCount: controller.myMsgList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return CommonRipple(
                onTap: () {
                  AppManager.instance.tapVibrate();
                  controller.readOrDeleteMyMsg(index, false);
                  if (controller.myMsgList[index].detail!.isNotEmpty) {
                    Get.to(MyMessageDetailView(
                      desc: controller.myMsgList[index].detail!,
                    ));
                  } else {
                    Get.snackbar("打开失败", "内容为空");
                  }
                },
                child: Container(
                  height: 205.h,
                  padding: EdgeInsets.all(42.w),
                  margin: EdgeInsets.only(top: 30.h, left: 36.w, right: 36.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.white),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60.w,
                            child: Image.asset(
                              ThemeService.to.currentTheme.value?.model ==
                                      'blackGold'
                                  ? Assets.theme1.images.user
                                      .iconMsgEmailBlackGold.path
                                  : Assets.theme1.images.user.iconMsgEmail.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            width: 35.w,
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${controller.myMsgList[index].subject}"),
                              Text(
                                  DateTimeUtils.formatTimestamp(controller.myMsgList[index].createTime!)),
                            ],
                          )),
                          CommonRipple(
                              onTap: () {
                                AppManager.instance.tapVibrate();
                                controller.readOrDeleteMyMsg(index, true);
                              },
                              child: SvgPicture.asset(
                                Assets.theme1.images.user.iconDelete,
                                width: 54.w,
                                height: 54.h,
                              )),
                        ],
                      ),
                      Positioned(
                          top: -20.h,
                          right: -20.w,
                          child: controller.myMsgList[index].state != 9
                              ? Container(
                                  width: 20.w,
                                  height: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10.r),
                                  ))
                              : const SizedBox())
                    ],
                  ),
                ),
              );
            })
        : _buildEmptyView());
  }

  Widget _FeedbackBuildBody(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 36.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start, // 强制从左开始
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FeedbackBuildTabBar(),
          Expanded(child: Obx(() => _FeedbackBuildContent(context)))
        ],
      ),
    );
  }

  Widget _FeedbackBuildTabBar() {
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 36.w), // 整体左侧起始间距
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start, // 强制从左开始
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(controller.feedbackList.length, (index) {
            return Obx(() => InkWell(
                  onTap: () {
                    if (controller.feedbackCurrentIndex.value != index) {
                      AppManager.instance.tapVibrate();
                    }
                    controller.changeFeedbackIndex(index);
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 90.h,
                        constraints: BoxConstraints(minWidth: 150.w),
                        padding: EdgeInsets.symmetric(horizontal: 30.w),
                        margin: EdgeInsets.only(right: 18.w),
                        decoration: BoxDecoration(
                          color: controller.feedbackCurrentIndex.value == index
                              ? const Color(theme01MainColor)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(40.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          controller.feedbackList[index],
                          style: TextStyle(
                            fontSize: 36.sp,
                            color:
                                controller.feedbackCurrentIndex.value == index
                                    ? Colors.white
                                    : const Color(colorC6C8CF),
                          ),
                        ),
                      ),
                      // 数字红点
                      if (controller.feedbackUnReadCount.value > 0 &&
                          index != 0)
                        Positioned(
                          right: 0.w, // 调整这个值可以改变红点的水平位置
                          // top: 10.h,    // 调整这个值可以改变红点的垂直位置
                          child: Container(
                            padding: EdgeInsets.all(5.w),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 40.w,
                              minHeight: 40.h,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${controller.feedbackUnReadCount.value}', // 这里放你要显示的数字
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ));
          }),
        ),
      ),
    );
  }

  Widget _FeedbackBuildContent(BuildContext context) {
    Widget widget;
    switch (controller.feedbackCurrentIndex.value) {
      case 0:
        widget = _InputBuildFeedBack(context);
        break;
      case 1:
        widget = _MyBuildFeedBack();
        break;
      default:
        widget = _InputBuildFeedBack(context);
        break;
    }
    return widget;
  }

  Widget _InputBuildFeedBack(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              margin: EdgeInsets.only(top: 38.h, left: 30.w, right: 30.w),
              padding: EdgeInsets.all(50.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '反馈内容',
                        style: TextStyle(
                          fontSize: 34.sp,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '*',
                        style: TextStyle(
                          fontSize: 34.sp,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.w),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 15.h),
                          height: 398.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(31.r),
                            border: Border.all(
                              color: Colors.black.withOpacity(0.5),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.feedbackController,
                            maxLines: null,
                            maxLength: 1000,
                            cursorColor: const Color(theme01MainColor),
                            decoration: InputDecoration(
                              hintText: '您的任何意见对我们都很重要，凡是有价值的意见都将被采纳\n\n\n',
                              contentPadding: EdgeInsets.only(
                                  top: 60.h, left: 36.w, right: 36.w),
                              hintStyle: TextStyle(
                                fontSize: 36.sp,
                                color: const Color(colorBCBCBC),
                              ),
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
                      ],
                    ),
                  ),
                ],
              )),
          const Spacer(),
          InkWell(
            onTap: () {
              AppManager.instance.tapVibrate();
              controller.sendFeedback();
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 66.w, vertical: 30.h),
              height: 125.h,
              decoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  borderRadius: BorderRadius.circular(79.r)),
              child: Text(
                "提交反馈",
                style: TextStyle(fontSize: 52.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _MyBuildFeedBack() {
    return Obx(() => Container(
          margin: EdgeInsets.all(15.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              // 顶部固定内容
              Container(
                  margin: EdgeInsets.only(top: 10.h, left: 30.w, right: 30.w),
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        '待领取：',
                        style: TextStyle(
                          fontSize: 39.sp,
                          color: const Color(0xFF888888),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        controller.giftsAmount.value.truncateToFixed(2),
                        style: TextStyle(
                          fontSize: 52.sp,
                          color: const Color(0xFF2D2D2D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          AppManager.instance.tapVibrate();
                          controller.receiveFeedbackGiftAmount();
                          controller.loadFeedbackUnReadBage();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 252.w,
                          margin: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 5.h),
                          height: 93.h,
                          decoration: BoxDecoration(
                              color: controller.giftsAmount.value > 0
                                  ? const Color(theme01MainColor)
                                  : const Color(0xFFC6C6C6),
                              borderRadius: BorderRadius.circular(10.r)),
                          child: Text(
                            "一键领取",
                            style:
                                TextStyle(fontSize: 42.sp, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  )),

              // 可滚动内容区域
              Expanded(
                // 关键修改：使用Expanded让列表占据剩余空间
                child: RefreshIndicator(
                  onRefresh: () async => {
                    controller.loadFeedbackUnReadBage(),
                    controller.reqFeedbackList()
                  },
                  child: ListView.builder(
                    // 直接使用ListView.builder
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: controller.feedbackModels.length,
                    itemBuilder: (context, index) {
                      return _contentWidget(controller.feedbackModels[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _contentWidget(FeedbackListModel feedbackModel) {
    return Container(
      margin: EdgeInsets.only(top: 20.h, left: 30.w, right: 30.w),
      // padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Padding(
              // Added Padding widget here
              padding: const EdgeInsets.all(15), // Uniform 15 padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "反馈ID：",
                        style: TextStyle(fontSize: 42.sp, color: Colors.black),
                      ),
                      Text(
                        '${feedbackModel.mailId}',
                        style: TextStyle(fontSize: 42.sp, color: Colors.black),
                      ),
                      InkWell(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            ClipboardUtil.copy('${feedbackModel.mailId}');
                          },
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(10.w, 10.h, 0, 10.h),
                            child: SvgPicture.asset(
                              Assets.theme1.images.user.iconCopy,
                              width: 42.w,
                              colorFilter: const ColorFilter.mode(
                                Color(color979797),
                                BlendMode.srcIn,
                              ),
                              height: 42.h,
                            ),
                          )),
                      const Spacer(),
                      Text(
                        feedbackModel.feedbackStatus == 1
                            ? "待处理"
                            : feedbackModel.feedbackStatus == 2
                                ? "已采纳"
                                : feedbackModel.feedbackStatus == 3
                                    ? "不采纳"
                                    : '',
                        style: TextStyle(
                            fontSize: 48.sp,
                            color: feedbackModel.feedbackStatus == 1
                                ? const Color(theme01MainColor)
                                : feedbackModel.feedbackStatus == 2
                                    ? Colors.green
                                    : feedbackModel.feedbackStatus == 3
                                        ? Colors.red
                                        : const Color(colorAAAFBB)),
                      ),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: const Color(0xff8E9FA1),
                        size: 40.w,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "反馈内容：",
                        style: TextStyle(fontSize: 36.sp, color: Colors.black),
                      ),
                      const Spacer(),
                      Text(
                        DateTimeUtils.formatTimestamp(
                            feedbackModel.sendTime ?? 0,
                            temp: 'yyyy/MM/dd HH:mm:ss'),
                        style: TextStyle(
                            fontSize: 36.sp, color: const Color(colorAAAFBB)),
                      ),
                    ],
                  ),
                  Text(
                    feedbackModel.content ?? '',
                    style: TextStyle(
                        fontSize: 36.sp, color: const Color(colorAAAFBB)),
                    textAlign: TextAlign.start,
                  ),
                  if (feedbackModel.lastSysReply != null) ...[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      margin: EdgeInsets.symmetric(vertical: 30.h),
                      height: 1.h,
                      color: const Color(colorAAAFBB),
                    ),
                    Row(
                      children: [
                        Text(
                          "官方回复：",
                          style:
                              TextStyle(fontSize: 36.sp, color: Colors.black),
                        ),
                        const Spacer(),
                        Text(
                          DateTimeUtils.formatTimestamp(
                              feedbackModel.lastSysReply?.sendTime ?? 0,
                              temp: 'yyyy/MM/dd HH:mm:ss'),
                          style: TextStyle(
                              fontSize: 36.sp, color: const Color(colorAAAFBB)),
                        ),
                      ],
                    ),
                    HtmlWidget(
                      feedbackModel.lastSysReply?.replyContent ?? '',
                      textStyle: TextStyle(
                        fontSize: 36.sp,
                        color: const Color(colorAAAFBB),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ]
                ],
              )),
          if (feedbackModel.isReceive == 1 &&
              (feedbackModel.giftAmount ?? 0.0) > 0.0) ...[
            Positioned(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                ),
                child: Text(
                  "有奖", // You can change this text
                  style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    ).onTap(() {
          controller.loadFeedbackUnReadBage();
          Get.toNamed(Routes.FEEDBACK_DETAIL, arguments: feedbackModel);
        });
  }
}
