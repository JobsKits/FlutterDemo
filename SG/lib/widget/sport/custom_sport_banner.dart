import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bet/app/modules/vault/views/vault_dialog_view.dart';
import 'package:flutter_bet/constant/app_common.dart';
import 'package:flutter_bet/constant/app_themes.dart';
import 'package:flutter_bet/constant/app_values.dart';
import 'package:flutter_bet/controllers/global_state_controller.dart';
import 'package:flutter_bet/pages/main/logic.dart';
import 'package:flutter_bet/pages/main/widget/main_page_bottom_bar_controller.dart';
import 'package:flutter_bet/pages/personal_center/vip/logic.dart';
import 'package:flutter_bet/pages/sport/sportbannermodel.dart';
import 'package:flutter_bet/services/branch/branch_service.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/custom_toast.dart';
import 'package:flutter_bet/widget/dialog/dialog_utils.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:flutter_html/flutter_html.dart' hide Content;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import '../../pages/activity/all_promotions/all_promotions_view.dart';
import '../../pages/alliance_plan/alliance_plan_view.dart';
import '../../pages/main/code.dart';
import '../../routes/routes.dart';
import '../../utils/route_util.dart';
import '../../utils/url_launch_util.dart';

class CustomSportBanner extends StatefulWidget {
  const CustomSportBanner(this.list, {super.key});

  final List<SportBannerModel> list;

  @override
  State<CustomSportBanner> createState() => CustomSportBannerState();
}

class CustomSportBannerState extends State<CustomSportBanner> {
  final GlobalStateController globalController = Get.find<GlobalStateController>();
  final GlobalKeyController globalKeyController = Get.find<GlobalKeyController>();
  final MainLogic logic = Get.find<MainLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: AppValues.sportPadding_12.h, bottom: AppValues.sportPadding_12.h),
      child: SizedBox(
          height: 208,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(AppValues.sportRadius_8),
                  child: Stack(
                    children: [
                      CustomNetWorkImage(
                        imageUrl: getImageUrl(widget.list[index]) ?? "",
                        fit: BoxFit.fill,
                      ),
                      mainView(widget.list[index])
                    ],
                  ));
            },
            itemCount: widget.list.length,
            viewportFraction: 0.92,
            scale: 0.97,
            loop: false,
            onTap: (i) {
              SportBannerModel model = widget.list[i];
              if (model.jumpState == 1) {
                customSportBanner_onTap(model.jumpType ?? 1, model.jumpUrl ?? '',true);
              }
            },
          )),
    );
  }
  //图片 1靠右 2靠左 3自定义
  Widget mainView(SportBannerModel model) {
    return model.bannerStyle! > 2
        ? Container()
        : Positioned.fill(
            child: Padding(
                padding: const EdgeInsets.all(
                  AppValues.padding_16,
                ),
                child: Row(
                  children: model.bannerStyle == 1
                      ? [
                          textView(model),
                          const SizedBox(
                            width: AppValues.defaultPadding,
                          ),
                          imageView(model),
                        ]
                      : [
                          imageView(model),
                          const SizedBox(
                            width: AppValues.defaultPadding,
                          ),
                          textView(model),
                        ],
                )));
  }

  Widget textView(SportBannerModel model) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (model.bannerInfo!.superscript != null &&
                  getText(model.bannerInfo!.superscript!) != '')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppValues.smallPadding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppValues.smallRadius),
                      color: AppThemes.widgetColorWhite),
                  child: CustomText(
                    getStrLimit(getText(model.bannerInfo!.superscript!), max: 26, length: 23),
                    style: const TextStyle(
                        fontSize: 12, color: AppThemes.surfaceVariant, fontWeight: FontWeight.w500),
                  ),
                ),
              // const SizedBox(
              //   height: 5,
              // ),
              // if (model.bannerInfo!.title != null)
              //   CustomText(
              //     getStrLimit(getText(model.bannerInfo!.title!),
              //         max: globalController.isVi() ? 36 : 33,
              //         length: globalController.isVi()
              //             ? 33
              //             : Get.width < 390
              //                 ? 27
              //                 : 30),
              //     style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              //   ),
              // const SizedBox(
              //   height: 5,
              // ),
              // CustomText(
              //   getStrLimit(getText(
              //     model.bannerInfo!.content!,
              //   )),
              //   maxLines: 3,
              // ),
              Container(
                padding: const EdgeInsets.only(top: AppValues.smallRadius),
                height: 120,
                // child: SingleChildScrollView(child: Html(data: (getText(model.bannerInfo!.content!)))),
                child:
                    SingleChildScrollView(child: HtmlWidget((getText(model.bannerInfo!.content!)))),
              )
            ],
          ),
          if (model.bannerInfo!.buttonState == 1)
            GestureDetector(
              onTap: () {
                customSportBanner_onTap(model.bannerInfo!.buttonJumpType ?? 1, model.bannerInfo!.buttonJumpUrl ?? '',true);
              },
              child: Container(
                width: 120,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppValues.smallRadius),
                  border: Border.all(
                    color: AppThemes.widgetColorWhite,
                  ),
                ),
                child: CustomText(
                  getText(model.bannerInfo!.buttonContent!),
                  maxLines: 2,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget imageView(SportBannerModel model) {
    return CustomNetWorkImage(
      imageUrl: '${BranchService.instance.current.asset_url}/${model.bannerInfo!.icon ?? ''}',
      width: 136,
    );
  }

  getImageUrl(SportBannerModel model) {
    if (model.bannerStyle == 3 && model.bannerUrl != null) {
      if (globalController.langType.value == 1) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.contentZhCn ?? ''}';
      } else if (globalController.langType.value == 2) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.enUs ?? ''}';
      } else if (globalController.langType.value == 3) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.ptBr ?? ''}';
      } else if (globalController.langType.value == 4) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.viVn ?? ''}';
      } else if (globalController.langType.value == 5) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.thTh ?? ''}';
      } else if (globalController.langType.value == 6) {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.hiIn ?? ''}';
      } else {
        return '${BranchService.instance.current.asset_url}/${model.bannerUrl?.zhCn ?? ''}';
      }
    } else {
      if (model.bannerInfo!.background != null) {
        return '${BranchService.instance.current.asset_url}/${model.bannerInfo!.background ?? ''}';
      } else {
        return "";
      }
    }
  }

  getText(Content model) {
    if (globalController.langType.value == 1) {
      return model.contentZhCn;
    } else if (globalController.langType.value == 2) {
      return model.enUs;
    } else if (globalController.langType.value == 3) {
      return model.ptBr;
    } else if (globalController.langType.value == 4) {
      return model.viVn;
    } else if (globalController.langType.value == 5) {
      return model.thTh;
    } else if (globalController.langType.value == 6) {
      return model.hiIn;
    } else {
      return model.contentZhCn ?? '';
    }
  }

  getStrLimit(String str, {int max = 66, int length = 64}) {
    if (globalController.isChinese()) {
      //Get.width < 390
      max = (max / 2).round();
      length = (length / 2).round();
      if (max > 14) length += 2;
      if (max > 24) length += 2;
    }
    if (str.length > max && str.length > length) {
      return '${str.substring(0, length)}...';
    }
    return str;
  }

  customSportBanner_onTap(int type, String url,bool ok) {
    switch (type) {

    // 展示方式 button
    // 1、内置页面
    // 2、跳转外部链接
    //
    // 跳转类型 button_type
    // 1、自定义URL
    // 2、娱乐城
    // 3、体育
    // 4、保险库
    // 5、VIP
    // 6、联盟计画
    // 7、优惠活动
    // 8、在线客服

    case 1:// 1、自定义URL
        if (url.isNotEmpty && !url.contains('http')) {
          url =
              '${AppValues.defaultBranch.api_url}/${globalController.getLangString().substring(0, 2)}/$url';
        }
        UrlLaunchUtil.launchURL(url).then((message) {
          if (message.isNotEmpty) {
            CustomToast.show(message, context);
          }
        });
        break;
      case 2:// 2、娱乐城
        if(ok){
          RouteUtil.popToFirst(Routes.mainPage);
        }
        Timer(const Duration(milliseconds: 50), () {
          logic.onMenuSelected(MenuCode.GAME);
        });
        break;
      case 3:// 3、体育
        if(ok){
          RouteUtil.popToFirst(Routes.mainPage);
        }
        Timer(const Duration(milliseconds: 400), () {
          logic.onMenuSelected(MenuCode.MSG);
        });
        break;
      case 4:// 4、保险库
        if(ok){
          RouteUtil.popView();
        }
        VaultDialogView.openDialog();
        break;
      case 5:// 5、VIP
        if(ok){
          RouteUtil.popView();
        }
        Timer(const Duration(milliseconds: 100), () {
          GlobalState.instance.index = 3;
          DialogUtils.goToPage(Routes.personalVip);
        });
        break;
      case 6:// 6、联盟计画
        GlobalState.instance.index = 4;
        AlliancePlanPage.openPage();
        break;
      case 7:// 7、优惠活动
        AllPromotionsPage.openPage();
        GlobalStateController.of().showOverlayView(isShowTopBarView: true, isShowBottomBarView: true);
        break;
      case 8:// 8、在线客服
        UrlLaunchUtil.jumpCs();
        break;
      default:
    }
  }
}
