import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bet/extentions/ex_widget.dart';
import 'package:flutter_bet/pages/home/home_logic.dart';
import 'package:flutter_bet/services/theme/theme_service.dart';
import 'package:flutter_bet/widget/custom_asset_icon.dart';
import 'package:flutter_bet/widget/custom_text.dart';
import 'package:flutter_bet/widget/network_image/custom_network_image.dart';
import 'package:get/get.dart';

import '../../../constant/app_themes.dart';

///首页菜单 导航 item
// class NavItemView extends GetView<HomeLogic> {
class NavItemView extends StatelessWidget {
  String assetName;
  String? assetLocalName; //本地资源， 错误加载本地图片
  String title;
  bool showTag;
  bool showBg;
  String? tag;
  bool? isLogin;
  final GestureTapCallback? onTap;

  NavItemView({
    super.key,
    required this.assetName,
    required this.title,
    this.assetLocalName,
    this.tag = '',
    this.showTag = false,
    this.showBg = false,
    this.onTap,
    this.isLogin = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) onTap!.call();
      },
      child: Container(
        height: 45,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: showBg
            ? const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                color: Color(0xFF2f4553),
              )
            : null,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.center, // 在主轴上居中对齐
          crossAxisAlignment: CrossAxisAlignment.center, // 在交叉轴上居中对齐
          children: [
            // CustomAssetIcon(
            //   name: assetLocalName??"",
            //   size: 14,
            //   color: AppThemes.iconColor,
            // ),
            assetName.contains("http")
                ? CustomNetWorkImage(
                    imageUrl: assetName,
                    width: 14,
                    height: 14,
                    errorWidget: CustomAssetIcon(
                      name: assetLocalName ?? "",
                      size: 14,
                      color: AppThemes.iconColor,
                    ),
                    // const SizedBox(
                    //   width: 14,
                    //   height: 14,
                    // ),
                  )
                : CustomAssetIcon(
                    name: assetName ?? "",
                    size: 14,
                    color: isLogin! ? AppThemes.iconColor : AppThemes.textColorGrey,
                  ),
            const SizedBox(
              width: 8,
            ),
            CustomText(title,
                style: TextStyle(
                    color: isLogin! ? AppThemes.widgetColorWhite : AppThemes.textColorGrey,
                    fontWeight: FontWeight.w600)),
            Expanded(child: Container()),
            // Spacer(),
            Visibility(
                visible: showTag,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                  decoration: BoxDecoration(
                      color: ThemeService().colorScheme.primary,
                      borderRadius: BorderRadius.circular(20)),
                  child: CustomText(
                    tag ?? "",
                    style: TextStyle(color: AppThemes.widgetColorDark, fontSize: 12),
                  ),
                )),
          ],
        ),
        // child: Stack(
        //   children: [
        //     Visibility(
        //       visible: showBg,
        //       child: Container(
        //         decoration: const BoxDecoration(
        //             color: Color(0xFF2f4553), borderRadius: BorderRadius.all(Radius.circular(4))),
        //       ).paddingZero.expanded(),
        //     ),
        //
        //   ],
        // ),
      ),
    );
  }
}
