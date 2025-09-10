import 'package:flutter/material.dart';
import 'package:flutter_tiyu_app/app/modules/user/controllers/agent_center_web_controller.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/common_color.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../utils/CommonRipple.dart';

class AgentCenterWebView extends GetView<AgentCenterWebController> {
  const AgentCenterWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.webViewController.canGoBack()) {
          controller.webViewController.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: WebViewWidget(controller: controller.webViewController),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomAppBar(
                  height: 251.h,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                        controller.tabsController.defaultBottomItemList.length,
                        (index) {
                      return Expanded(
                        child: CommonRipple(
                          onTap: () {
                            AppManager.instance.tapVibrate();
                            controller.backToIndex(index);
                          },
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SvgPicture.asset(
                                //   controller.tabsController
                                //       .defaultBottomItemList[index].iconPath,
                                //   width: 55.w,
                                //   height: 55.h,
                                //   colorFilter: ColorFilter.mode(
                                //       controller.tabsController.currentIndex
                                //                   .value ==
                                //               index
                                //           ? Color(theme01MainColor)
                                //           : Color(colorABACB2),
                                //       BlendMode.srcIn),
                                // ),
                                SizedBox(
                                  height: 28.h,
                                ),
                                Text(
                                  overflow: TextOverflow.ellipsis,
                                  controller.tabsController
                                      .defaultBottomItemList[index].title.tr,
                                  style: TextStyle(
                                      fontSize: 40.sp,
                                      color: controller.tabsController
                                                  .currentIndex.value ==
                                              index
                                          ? context.theme.primaryColor
                                          : Color(colorABACB2)),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
