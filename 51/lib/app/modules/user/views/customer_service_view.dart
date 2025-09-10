import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_tiyu_app/app/routes/app_pages.dart';
import 'package:flutter_tiyu_app/constants/help_center_constants.dart';
import 'package:flutter_tiyu_app/gen/assets.gen.dart';
import 'package:flutter_tiyu_app/theme/context.ext.dart';
import 'package:flutter_tiyu_app/utils/app_manager.dart';
import 'package:flutter_tiyu_app/utils/tenant_manager.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/CommonRipple.dart';
import '../../../../utils/clipboard_util.dart';
import '../../../../utils/common_color.dart';
import '../../../data/app_customer_service_bean.dart';
import '../../../data/tenant_bean.dart';
import '../controllers/customer_service_controller.dart';

//客服页面
class CustomerServiceView extends GetView<CustomerServiceController> {
  const CustomerServiceView({super.key});

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
        title: Text(
          "在线客服",
          style: TextStyle(color: context.customTheme?.titleColor),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    List<AppCustomerServiceBean> csData = TenantManager.instance.csData;
    return Container(
        margin: EdgeInsets.only(top: 36.h, left: 33.w, right: 33.w),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30.r)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildItem(context,
                  iconPath:
                      Assets.theme1.images.user.service.iconCustomerService,
                  isCustomerService: true,
                  title: "在线客服"),

              ...List.generate(TenantManager.instance.csData.length, (index) {
                AppCustomerServiceBean item = csData[index];
                return _buildItem(context,
                    iconPath: item.iconPath,
                    title: item.name,
                    number: item.contactAddress ?? "");
              }),

              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconQq,
              //     title: "QQ客服",
              //     number: "${tenant.qq}"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconWechat,
              //     number: "${tenant.weixin}",
              //     title: "微信客服"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconTelegram,
              //     number: "${tenant.telegram}",
              //     title: "Telegram"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconWhatsapp,
              //     number: "${tenant.whatsApp}",
              //     title: "Whatsapp"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconFacebook,
              //     number: "${tenant.facebook}",
              //     title: "Facebook"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconZalo,
              //     number: "${tenant.zalo}",
              //     title: "Zalo"),
              // _buildItem(
              //     iconPath: Assets.theme1.images.user.service.iconServicePhone,
              //     number: "${tenant.phone}",
              //     title: "客服电话"),
              _buildCommonQuestions(
                iconPath: Assets.theme1.images.user.service.iconQuestion,
                title: '常见问题',
              ),
            ],
          ),
        ));
  }

  Widget _buildItem(
    BuildContext context, {
    required String iconPath,
    required String title,
    bool isCustomerService = false,
    String number = "",
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      height: 155.h,
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 50.w,
                  height: 50.h,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                    child: Text(
                  title,
                  style: TextStyle(fontSize: 42.sp),
                )),
                isCustomerService
                    ? CommonRipple(
                        onTap: () {
                          AppManager.instance.tapVibrate();

                          String? onlineAddr = TenantManager
                              .instance.tenantBean?.tenant?.onlineAddr;
                          if (onlineAddr != null) {
                            String? type = TenantManager.instance.tenantBean
                                ?.sysOptions?.customerServiceSkipType;
                            if (type == '1') {
                              launchUrl(Uri.parse(onlineAddr),
                                  mode: LaunchMode.externalApplication);
                            } else {
                              Get.toNamed(Routes.WEB_VIEW_INAPP, arguments: {
                                "url": onlineAddr, //请求地址
                                "title": "在线客服",
                              });
                            }
                          }
                        },
                        child: Container(
                          width: 230.w,
                          height: 82.h,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: context.theme.primaryColor,
                              borderRadius: BorderRadius.circular(66.r)),
                          child: Text(
                            "立即联系",
                            style:
                                TextStyle(fontSize: 36.sp, color: Colors.white),
                          ),
                        ),
                      )
                    : Expanded(
                        child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            number,
                            style: TextStyle(
                                fontSize: 40.sp, color: Color(color969696)),
                          )),
                          SizedBox(
                            width: 30.w,
                          ),
                          InkWell(
                            onTap: () {
                              AppManager.instance.tapVibrate();
                              ClipboardUtil.copy(number);
                            },
                            child: Image.asset(
                              Assets.theme1.images.user.service.iconCopy.path,
                              width: 42.w,
                              height: 42.h,
                            ),
                          )
                        ],
                      ))
              ],
            ),
          ),
          Visibility(
              visible: !isLast,
              child: Divider(
                height: 1.h,
                thickness: 1.h,
              ))
        ],
      ),
    );
  }

  Widget _buildCommonQuestions({
    required String iconPath,
    required String title,
  }) {
    return InkWell(
      onTap: () {
        AppManager.instance.tapVibrate();
        for (var element in HelpCenterConstants.helpList) {
          if (element.title == '常见问题') {
            String title = element.title;
            String text = element.text;
            Get.toNamed(Routes.WEB_VIEW, arguments: {
              "url": text,
              "title": title,
              "isChangeHtmlFontSize": true
            });
            break;
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.w),
        height: 155.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 50.w,
              height: 50.h,
            ),
            SizedBox(
              width: 20.w,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 42.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
